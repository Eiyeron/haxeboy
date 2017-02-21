package haxeboy;

import haxe.io.Bytes;
import haxe.io.UInt8Array;

class ROM implements MemoryMappable implements MemoryBankBased {
	public static inline var ROM_BANK_SIZE:Int = 16 * 1024; // 16 kB
 
	var banks: Array<UInt8Array>;

	var real_number_of_rom_banks:Int;

	var cart_inserted(get, never):Bool;

	public function new() {
		banks = [];
		real_number_of_rom_banks = 0;
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
	}

    public function getValue(address:Int):Int {
        return banks[Std.int(address/1024)].get(address%1024);
    }

    public function setValue(address:Int, value:Int) {
    	// wahtever the address, this should never be called
    	// Trigger an exception or whatever here
    }

    public function getValueAtBank(bank:Int, address:Int) {
        return banks[bank].get(address);
    }

    // Getters

    public function get_cart_inserted():Bool {
        return real_number_of_rom_banks != 0;
    }
}