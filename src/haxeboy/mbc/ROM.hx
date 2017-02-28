package haxeboy.mbc;

import haxeboy.core.MemoryMappable;
import haxe.io.Bytes;
import haxe.io.UInt8Array;

using haxeboy.core.Tools;
using haxeboy.core.MemoryMappable;

class ROM implements MemoryMappable implements MBC {
    public static inline var ROM_BANK_SIZE:Int = 16 * 1024; // 16 kB
    public static inline var RAM_BANK_SIZE:Int = 8 * 1024; // 8 kB
    var data: UInt8Array;
    var ram: UInt8Array;
    var cart_inserted: Bool = false;

    var supports_ram: Bool;

    public function new(supportsRam: Bool) {
        supports_ram = supportsRam;
        ram = new UInt8Array(RAM_BANK_SIZE);
    }

    public function loadCart(bytes: Bytes) {
        data = UInt8Array.fromBytes(bytes);
        cart_inserted = true;
    }

    public function removeCart() {
        data = null;
        cart_inserted = false;
    }

    public function getValue(address:Int):Int {
        if(address.inRange(0x0, 0x7FFF)) {
            return data[address];
        }
        else if (address.inRange(0xA000, 0xBFFF)) {
            if(!supports_ram) {
                throw 'attempted RAM access on unsupported hardware';
            }
            return ram.get(address - 0xA000);
        }
        return 0x0;
    }

    public function setValue(address:Int, value:Int) {
        if (address.inRange(0xA000, 0xBFFF)) {
            if(!supports_ram) {
                throw 'attempted RAM access on unsupported hardware';
            }
            ram.set(address - 0xA000, value);
        }
    }
}