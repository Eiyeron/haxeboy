package haxeboy;

import haxe.io.Bytes;

using StringTools;

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

        var cart: Bytes = Bytes.alloc(32*1024);
        cart.set(0x0147, 0x9);

        insertCart(cart);
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

    var header_locations = {
        cartType: 0x0147
    };

    public function insertCart(cartData:Bytes) {
        memory.rom.loadCart(cartData);
        var cartType: CartridgeType = memory.getValue(header_locations.cartType);

        switch(cartType) {
            case ROM_RAM_BATTERY:
                trace('ROM_RAM_BATTERY');
            default:
        }
    }

    public function removeCart() {
        memory.rom.removeCart();
    }
}

@:enum
abstract CartridgeType(Int) from Int to Int {
    var ROM_ONLY = 0x0;
    var MBC1 = 0x1;
    var MBC1_RAM = 0x2;
    var MBC1_RAM_BATTERY = 0x3;
    var MBC2 = 0x5;
    var MBC2_BATTERY = 0x6;
    var ROM_RAM = 0x8;
    var ROM_RAM_BATTERY = 0x9;
    var MMM01 = 0xB;
    var MMM01_RAM= 0xC;
    var MMM01_RAM_BATTERY = 0xD;
    var MBC3_TIMER_BATTERY = 0xF;
    var MBC3_TIMER_RAM_BATTERY = 0x10;
    var MBC3 = 0x11;
    var MBC3_RAM = 0x12;
    var MBC3_RAM_BATTERY = 0x13;
    var MBC4 = 0x15;
    var MBC4_RAM = 0x16;
    var MBC4_RAM_BATTERY = 0x17;
    var MBC5 = 0x19;
    var MBC5_RAM = 0x1A;
    var MBC5_RAM_BATTERY = 0x1B;
    var MBC5_RUMBLE = 0x1C;
    var MBC5_RUMBLE_RAM = 0x1D;
    var MBC5_RAMBLE_RAM_BATTERY = 0x1E;
    var POCKET_CAMERA = 0xFC;
    var BANDAI_TAMA5 = 0xFD;
    var HuC3 = 0xFE;
    var HuC1_RAM_BATTERY= 0xFF;
}
