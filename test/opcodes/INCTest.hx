package opcodes;

import haxeboy.Gameboy;
import haxeboy.ROM;
import haxe.io.Bytes;

using opcodes.TestTools;

class INCTest extends haxe.unit.TestCase {
    public static inline var HALT:Int = 0x76;

    var gb:Gameboy;

    override public function setup() {
        gb = new Gameboy();
    }

    function test_INC_BC() {
        var routine = Bytes.alloc(ROM.ROM_BANK_SIZE);
        routine.writeByteBuffer([0x03, HALT]);
        gb.insertCart(routine);

        gb.run();

        // Registers and timing check
        assertEquals(0x0001, gb.cpu.BC);
        assertEquals(12, gb.cpu.cycles); // 8 for INC BC, 4 for HALT
        assertEquals(0x0002, gb.cpu.PC); // 1 + INC, 1 for HALT
    }

    function test_INC_B_normal() {
        var routine = Bytes.alloc(ROM.ROM_BANK_SIZE);
        routine.writeByteBuffer([0x04, HALT]);
        gb.insertCart(routine);

        gb.run();

        // Registers and timing check
        assertEquals(0x01, gb.cpu.B);
        assertEquals(8, gb.cpu.cycles); // 4 for INC B, 4 for HALT
        assertEquals(0x0002, gb.cpu.PC); // 1 + INC, 1 for HALT
        // Flag check
        assertEquals(0, gb.cpu.z); // It's not going to 0
        assertEquals(0, gb.cpu.n); // Should be zero
        assertEquals(0, gb.cpu.h); // Not overflowing
    }

    function test_INC_B_overflow() {
        var routine = Bytes.alloc(ROM.ROM_BANK_SIZE);
        routine.writeByteBuffer([0x04, HALT]);
        gb.insertCart(routine);

        gb.cpu.B =0xFF;
        gb.cpu.halted = false;
        gb.run();

        // Registers and timing check
        assertEquals(0x00, gb.cpu.B);
        assertEquals(8, gb.cpu.cycles); // 4 for INC B, 4 for HALT
        assertEquals(0x0002, gb.cpu.PC); // 1 + INC, 1 for HALT
        // Flag check
        assertEquals(1, gb.cpu.z); // Overflowing
        assertEquals(0, gb.cpu.n); // Should be zero
        assertEquals(1, gb.cpu.h); // Half carry should be set
    }

    function test_INC_B_halfcarry() {
        var routine = Bytes.alloc(ROM.ROM_BANK_SIZE);
        routine.writeByteBuffer([0x04, HALT]);
        gb.insertCart(routine);

        gb.cpu.B = 0x0F;
        gb.cpu.halted = false;
        gb.run();

        // Registers and timing check
        assertEquals(0x10, gb.cpu.B);
        assertEquals(8, gb.cpu.cycles); // 4 for INC B, 4 for HALT
        assertEquals(0x0002, gb.cpu.PC); // 1 + INC, 1 for HALT
        // Flag check
        assertEquals(0, gb.cpu.z); // Overflowing
        assertEquals(0, gb.cpu.n); // Should be zero
        assertEquals(1, gb.cpu.h); // Half carry should be set
    }

}