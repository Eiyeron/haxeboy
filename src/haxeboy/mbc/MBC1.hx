package haxeboy.mbc;

import haxe.io.Bytes;
import haxe.io.UInt8Array;

using haxeboy.Tools;

// TODO : add memory mapping support.
class MBC1 implements MemoryMappable implements MemoryBankBased implements MBC {
    public static inline var ROM_BANK_SIZE: Int = 16 * 1024; // 16 kB
    public static inline var RAM_BANK_SIZE: Int = 8 * 1024;

    var banks: Array<UInt8Array>;
    var ram_banks: Array<UInt8Array>;

    var real_number_of_rom_banks:Int;

    public var current_rom_bank(default, null):Int;
    var current_ram_bank: Int = 0;
    var cart_inserted(get, never):Bool;

    var ram_mode: Bool = false;

    var supports_ram: Bool;

    public function new(ram: Bool) {
        supports_ram = ram;
        banks = [];
        ram_banks = [];
        real_number_of_rom_banks = 0;
        current_rom_bank = 1;
    }

    public function loadCart(data:Bytes) {
        real_number_of_rom_banks = Math.ceil(data.length / ROM_BANK_SIZE);
        for(i in 0...real_number_of_rom_banks) {
            var bank:UInt8Array = UInt8Array.fromBytes(data.sub(i * ROM_BANK_SIZE, ROM_BANK_SIZE));
            banks.push(bank);
        }
    }

    public function removeCart() {
        banks = [];
        real_number_of_rom_banks = 0;
    }

    public function getValue(address:Int):Int {
        if(!cart_inserted) {
            return 0;
        }
        //ROM ACCESS
        if(address.inRange(0x000, 0x7FFF)) {
            var num_bank:Int = Std.int(address/ROM_BANK_SIZE);
            // If the select rom bank is over the current amount of loaded banks
            // The math.min is useful because you can only have access (up to) two
            // ROM banks : Bank 0 and Bank 1-127 (which is bank swappable).
            // Thus we're capping to up to the two accessible rom banks or lower
            // if the ROM only contains one ROM bank.
            if(num_bank > Math.min(real_number_of_rom_banks - 1, 1)) {
                return 0;
            }

            // As said earlier, the console can only access two ROM banks at once:
            // Bank 0 which is always accessible
            // Bank 1-n which is accessible by inquiring the cart to switch
            // banks.
            if(num_bank == 0) {
                return banks[0].get(address % ROM_BANK_SIZE);
            } else {
                return banks[current_rom_bank].get(address % ROM_BANK_SIZE);
            }
        }
            else if(address.inRange(0xA000,0xBFFF)) {
                if(!supports_ram) {
                    throw 'attempted to get ram value on unsupported MBC';
                }
                var num_bank = Std.int((address - 0xA000)/RAM_BANK_SIZE);
                return ram_banks[num_bank].get((address - 0xA000) % RAM_BANK_SIZE);
            }
        return 0x0;
    }

    // Note : the ROM banks index uses 7 bits, so can go up to 127.
    // The ROM banks only go up to 3, so the lowest 2 bits are used.
    public function setValue(address:Int, value:Int) {
        // RAM is READ/WRITE, up to 3 banks
        if(address.inRange(0xA000, 0xBFFF)) {
            if(!supports_ram) {
                throw 'attempted to set ram value on unsupported MBC';
            }

            var num_bank = Std.int((address - 0xA000)/RAM_BANK_SIZE);
            ram_banks[num_bank].set((address - 0xA000) % RAM_BANK_SIZE, value);
        }
         // Magic address space to enable RAM
        else if(address.inRange(0x000, 0x1FFF)) {
            if((value & 0x0F) == 0x0A) {
                // TODO : Enable RAM
            }
            else {
                // TODO : Disable RAM
            }
        }
        // Set lower 5 bits of ROM bank selection
        // Note: 0x60 because the highest bit isn't used.
        // The maximum number of banks is 127, not 255.
        else if(address.inRange(0x2000, 0x3FFF)) {
            current_rom_bank = (current_rom_bank & (0x60)) | (value & 0x1F);
        }
        else if(address.inRange(0x4000, 0x5FFF)) {
            if(ram_mode) {
                // Set the current ram bank (as there can only be 3 banks,
                // let's only take the two lowest bits.)
                current_ram_bank = (value & 0x03);
            }
            else {
                // Set the two highest bit in the current rom bank index.
                // Note : again, the rom bank number limit is 127.
                current_rom_bank = ((value & 0x03) << 5) | (current_rom_bank & 0x1F);
            }
        }
        // Swap between ROM bank addressing and RAM bank addressing for further
        // bank switchings.
        else if(address.inRange(0x6000, 0x7FFF)) {
            // If the logic doesn't involve anything else, it's better to keep
            // it onelined.
            ram_mode = (value == 0x01);
        }
    }

    public function getValueAtBank(bank:Int, address:Int) {
        return banks[bank].get(address);
    }

    // Getters

    public function get_cart_inserted():Bool {
        return real_number_of_rom_banks != 0;
    }
}