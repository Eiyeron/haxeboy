package opcodes;

import haxeboy.Gameboy;
import haxeboy.ROM;
import haxe.io.Bytes;

using opcodes.TestTools;

class LDTest extends haxe.unit.TestCase {
    public static inline var HALT:Int = 0x76;

    var gb:Gameboy;

    override public function setup() {
        gb = new Gameboy();
    }


    function test_LD_BC_nn() {
        var routine = Bytes.alloc(ROM.ROM_BANK_SIZE);
        routine.writeByteBuffer([0x01, 0xDE, 0xAD, HALT]);
        gb.insertCart(routine);

        gb.run();

        // Registers and timing check
        assertEquals(0xDEAD, gb.cpu.BC);
        assertEquals(16, gb.cpu.cycles); // 12 for LD, 4 for HALT
        assertEquals(0x0004, gb.cpu.PC); // 3 + LD BC,nn, 1 for HALT
    }

    function test_LD_BC_A_normal() {
        var routine = Bytes.alloc(ROM.ROM_BANK_SIZE);
        routine.writeByteBuffer([0x02, HALT]);
        gb.insertCart(routine);

        gb.cpu.BC = 0xC000;
        gb.cpu.A = 0x42;

        gb.run();

        // Registers and timing check
        assertEquals(0xC000, gb.cpu.BC);
        assertEquals(0x42, gb.memory.getValue(0xC000));
        assertEquals(12, gb.cpu.cycles); // 8 for LD, 4 for HALT
        assertEquals(0x0002, gb.cpu.PC); // 1 + LD (BC),A, 1 for HALT
    }

    // Should fail by tryng to write in ROM
    function test_LD_BC_A_fail() {
        var routine = Bytes.alloc(ROM.ROM_BANK_SIZE);
        routine.writeByteBuffer([0x02, HALT]);
        gb.insertCart(routine);

        gb.cpu.BC = 0x0000;
        gb.cpu.A = 0x42;

        gb.run();

        // Registers and timing check
        assertEquals(0x0000, gb.cpu.BC);
        assertEquals(0x02, gb.memory.getValue(0x0000)); // Shouldn't have changed the ROM
        assertEquals(12, gb.cpu.cycles); // 8 for LD, 4 for HALT
        assertEquals(0x0002, gb.cpu.PC); // 1 + LD (BC),A, 1 for HALT
    }

    function test_LD_B_d8() {
        var routine = Bytes.alloc(ROM.ROM_BANK_SIZE);
        routine.writeByteBuffer([0x06, 0x42, 0x76]);
        gb.insertCart(routine);

        gb.run();

        // Registers and timing check
        assertEquals(0x42, gb.cpu.B);
        assertEquals(12, gb.cpu.cycles); // 8 for LD B,d8, 4 for HALT
        assertEquals(0x0003, gb.cpu.PC); // 1 + LD (BC),A, 1 for HALT
    }
}