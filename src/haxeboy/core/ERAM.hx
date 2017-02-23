package haxeboy;

import haxe.io.Bytes;
import haxe.io.UInt8Array;

class ERAM implements MemoryMappable implements MemoryBankBased {
    public static inline var ERAM_BANK_SIZE:Int = 8 * 1024; // 8 kB

    var banks:Array<UInt8Array>;
    var current_bank:Int;

    public var number_of_banks(get, null):Int;

    public function new()
    {
        banks = [];
        current_bank = 0;

    }

    public function loadRAM(number_of_banks:Int, data:Bytes) {
        setUpBanks(number_of_banks);
        for (i in 0...number_of_banks) {
            for (j in 0...ERAM_BANK_SIZE) {
                banks[i].set(j, data.get(i * ERAM_BANK_SIZE + j));
            }
        }
    }

    public function setUpBanks(number:Int) {
        banks = [for (i in 0...number) new UInt8Array(ERAM_BANK_SIZE)];
    }

    // Note: if we're going to support the CGB next, change the logic
    // to split bank 0 from the others.


    public function getValue(address:Int) {
        return banks[current_bank].get(address);
    }

    public function getValueAtBank(bank:Int, address:Int) {
        return banks[bank].get(address);
    }

    public function setValue(address:Int, value:Int) {
        banks[current_bank].set(address, value);
    }

    /// Getters ///

    public function get_number_of_banks():Int {
        return banks.length;
    }
}