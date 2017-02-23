package haxeboy.mbc;

import haxeboy.core.MemoryMappable;
import haxe.io.Bytes;
import haxe.io.UInt8Array;

using haxeboy.core.Tools;
using haxeboy.core.MemoryMappable;

class ROM implements MemoryMappable implements MBC {
    public static inline var ROM_BANK_SIZE:Int = 16 * 1024; // 16 kB
    var data: UInt8Array;
    var cart_inserted: Bool = false;

    public function new() {}

    public function loadCart(bytes: Bytes) {
        data = UInt8Array.fromBytes(bytes);
        cart_inserted = true;
    }

    public function removeCart() {
        data = null;
        cart_inserted = false;
    }

    public function getValue(address:Int):Int {
        if(!cart_inserted) {
            return 0;
        }

        if(address.inRange(0x0, 0x7FFF)) {
            return data[address];
        }
        else {
            //TODO: throw error?
            return 0;
        }
    }

    public function setValue(address:Int, value:Int) {
        // TODO : switch for unit test library that include exceptions
        // throw 'ROM_ONLY cartridges do not support writing';
    }
}