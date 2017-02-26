package haxeboy;

import haxe.io.Bytes;
import sys.io.File;

class Gameboy {
    public var cpu(default, null):CPU;
    public var memory(default, null):Memory;

    public var turned_on(default, null):Bool;

    public function new()
    {
        cpu = new CPU();
        memory = new Memory();
        cpu.memory = memory;
        turned_on = false;

       // var cart: Bytes = Bytes.alloc(32*1024);
       // cart.set(0x0147, 0x9);

        insertCart(File.getBytes('main.gb'));
    }

    /// Mockup of eventual API ///
    // TODO : like, everything? I haven't thought of a final API.

    public function run() {
        turned_on = true;

        while(turned_on && !cpu.stopped) {
            cpu.step();
        }
    }

    public function reset() {
        // cpu.reset();
        // memory.reset();
    }

    public function insertCart(cartData:Bytes) {
        memory.rom.loadCart(cartData);
        new haxeboy.Cartridge(cartData);
    }

    public function removeCart() {
        memory.rom.removeCart();
    }
}