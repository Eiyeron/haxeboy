package haxeboy;

import haxe.io.Bytes;

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
    }

    public function removeCart() {
        memory.rom.removeCart();
    }
}
