package haxeboy.mbc;

import haxe.io.Bytes;
import haxe.io.UInt8Array;

using haxeboy.Tools;

// TODO : add memory mapping support.
class MBC1 implements MemoryMappable implements MemoryBankBased implements MBC {
    public static inline var ROM_BANK_SIZE:Int = 16 * 1024; // 16 kB

    var banks: Array<UInt8Array>;

    var real_number_of_rom_banks:Int;

    public var current_rom_bank(default, null):Int;
    var cart_inserted(get, never):Bool;

    public function new() {
        banks = [];
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

    public function setValue(address:Int, value:Int) {
        var ramMode: Bool = false;
        var ramBank: Int = 0;
        var romBank: Int = 0;

        if(address.inRange(0xA000, 0xBFFF)) {
            //RAM, should be handled in MBC
        }
        else if(address.inRange(0x000, 0x1FFF)) {
            if(value & 0xF == 0xA) {
                //ENABLE RAM
            }
            else {
                //DISABLE RAM
            }
        }
        else if(address.inRange(0x2000, 0x3FFF)) {
            romBank = (romBank & (0x60)) | (value & 0x1F);
            //USE THIS
        }
        else if(address.inRange(0x4000, 0x5FFF)) {
            if(ramMode) {
                ramBank = value & 0x3;
            }
            else {
                romBank = ((value & 0x3) << 5) | (romBank & 0x1F);
            }
        }
        else if(address.inRange(0x6000, 0x7FFF)) {
            if(address == 1) {
                ramMode = true;
            }
            else {
                ramMode = false;
            }
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