package;

import haxeboy.Gameboy;
import haxeboy.ROM;
import haxe.io.Bytes;

class RunTests extends haxe.unit.TestCase {
    var gb:Gameboy;

    override public function setup() {
        gb = new Gameboy();
    }

    function test_LD_BC_nn() {
        var routine = Bytes.alloc(ROM.ROM_BANK_SIZE);

        routine.set(0x0000, 0x01); // LD BC, 0xDEAD
        routine.set(0x0001, 0xDE);
        routine.set(0x0002, 0xAD);
        //
        routine.set(0x0003, 0x76); // HALT
        gb.insertCart(routine);

        gb.run();

        // Registers and timing check
        assertEquals(0xDEAD, gb.cpu.BC);
        assertEquals(16, gb.cpu.cycles); // 12 for LD, 4 for HALT
        assertEquals(0x0004, gb.cpu.PC); // 3 + LD BC,nn, 1 for HALT
    }

    function test_LD_BC_a_normal() {
        var routine = Bytes.alloc(ROM.ROM_BANK_SIZE);

        routine.set(0x0000, 0x02); // LD (BC), A
        routine.set(0x0001, 0x76); // HALT
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
    function test_LD_BC_a_fail() {
        var routine = Bytes.alloc(ROM.ROM_BANK_SIZE);

        routine.set(0x0000, 0x02); // LD (BC), A
        routine.set(0x0001, 0x76); // HALT
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


    function test_INC_BC() {
        var routine = Bytes.alloc(ROM.ROM_BANK_SIZE);
        routine.set(0x0000, 0x03); // INC BC
        routine.set(0x0001, 0x76); // HALT
        gb.insertCart(routine);

        gb.run();

        // Registers and timing check
        assertEquals(0x0001, gb.cpu.BC);
        assertEquals(12, gb.cpu.cycles); // 8 for INC BC, 4 for HALT
        assertEquals(0x0002, gb.cpu.PC); // 1 + INC, 1 for HALT
    }

    function test_INC_B_normal() {
        var routine = Bytes.alloc(ROM.ROM_BANK_SIZE);
        routine.set(0x0000, 0x04); // INC BC
        routine.set(0x0001, 0x76); // HALT
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
        routine.set(0x0000, 0x04); // INC BC
        routine.set(0x0001, 0x76); // HALT
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
        routine.set(0x0000, 0x04); // INC BC
        routine.set(0x0001, 0x76); // HALT
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


      public static function main() {
        var r = new haxe.unit.TestRunner();
        r.add(new RunTests());
        r.run();
      }
}