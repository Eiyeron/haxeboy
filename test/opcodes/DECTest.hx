package opcodes;

import haxeboy.core.ROM;
import haxe.io.Bytes;

using opcodes.TestTools;

class DECTest extends OpcodeTest {
    function test_DEC_B_normal() {
        var routine = Bytes.alloc(ROM.ROM_BANK_SIZE);
        routine.writeByteBuffer([0x05, STOP]);
        gb.insertCart(routine);

        gb.cpu.B = 0x02;
        gb.run();

        // Registers and timing check
        assertEquals(0x01, gb.cpu.B);
        assertEquals(8, gb.cpu.cycles); // 4 for DEC B, 4 for STOP
        assertEquals(0x0003, gb.cpu.PC); // 1 + DEC, 2 for STOP
        // Flag check
        assertEquals(0, gb.cpu.z); // It's not going to 0
        assertEquals(1, gb.cpu.n); // Should be one
        assertEquals(0, gb.cpu.h); // Not overflowing
    }

    function test_DEC_B_underflow() {
        var routine = Bytes.alloc(ROM.ROM_BANK_SIZE);
        routine.writeByteBuffer([0x05, STOP]);
        gb.insertCart(routine);

        gb.cpu.B = 0x00;
        gb.run();

        // Registers and timing check
        assertEquals(0xFF, gb.cpu.B);
        assertEquals(8, gb.cpu.cycles); // 4 for DEC B, 4 for STOP
        assertEquals(0x0003, gb.cpu.PC); // 1 + DEC, 2 for STOP
        // Flag check
        assertEquals(1, gb.cpu.z); // Underflowing
        assertEquals(1, gb.cpu.n); // Should be one
        assertEquals(1, gb.cpu.h); // Half carry should be set
    }

    function test_DEC_B_halfcarry() {
        var routine = Bytes.alloc(ROM.ROM_BANK_SIZE);
        routine.writeByteBuffer([0x05, STOP]);
        gb.insertCart(routine);

        gb.cpu.B = 0x10;
        gb.run();

        // Registers and timing check
        assertEquals(0x0F, gb.cpu.B);
        assertEquals(8, gb.cpu.cycles); // 4 for DEC B, 4 for STOP
        assertEquals(0x0003, gb.cpu.PC); // 1 + DEC, 2 for STOP
        // Flag check
        assertEquals(0, gb.cpu.z); // Should not going to zero
        assertEquals(1, gb.cpu.n); // Should be one
        assertEquals(1, gb.cpu.h); // Half carry should be set
    }

    function test_DEC_BC_normal() {
        var routine = Bytes.alloc(ROM.ROM_BANK_SIZE);
        routine.writeByteBuffer([0x0B, STOP]);
        gb.insertCart(routine);

        gb.cpu.BC = 0x02;
        gb.run();

        // Registers and timing check
        assertEquals(0x01, gb.cpu.BC);
        assertEquals(12, gb.cpu.cycles); // 8 for DEC BC, 4 for STOP
        assertEquals(0x0003, gb.cpu.PC); // 1 + DEC, 2 for STOP
    }

    function test_DEC_C_normal() {
        var routine = Bytes.alloc(ROM.ROM_BANK_SIZE);
        routine.writeByteBuffer([0x0D, STOP]);
        gb.insertCart(routine);

        gb.cpu.C = 0x02;
        gb.run();

        // Registers and timing check
        assertEquals(0x01, gb.cpu.C);
        assertEquals(8, gb.cpu.cycles); // 4 for DEC B, 4 for STOP
        assertEquals(0x0003, gb.cpu.PC); // 1 + DEC, 2 for STOP
        // Flag check
        assertEquals(0, gb.cpu.z); // It's not going to 0
        assertEquals(1, gb.cpu.n); // Should be one
        assertEquals(0, gb.cpu.h); // Not overflowing
    }

    function test_DEC_C_underflow() {
        var routine = Bytes.alloc(ROM.ROM_BANK_SIZE);
        routine.writeByteBuffer([0x0D, STOP]);
        gb.insertCart(routine);

        gb.cpu.C = 0x00;
        gb.run();

        // Registers and timing check
        assertEquals(0xFF, gb.cpu.C);
        assertEquals(8, gb.cpu.cycles); // 4 for DEC B, 4 for STOP
        assertEquals(0x0003, gb.cpu.PC); // 1 + DEC, 2 for STOP
        // Flag check
        assertEquals(1, gb.cpu.z); // Underflowing
        assertEquals(1, gb.cpu.n); // Should be one
        assertEquals(1, gb.cpu.h); // Half carry should be set
    }

    function test_DEC_C_halfcarry() {
        var routine = Bytes.alloc(ROM.ROM_BANK_SIZE);
        routine.writeByteBuffer([0x0D, STOP]);
        gb.insertCart(routine);

        gb.cpu.C = 0x10;
        gb.run();

        // Registers and timing check
        assertEquals(0x0F, gb.cpu.C);
        assertEquals(8, gb.cpu.cycles); // 4 for DEC B, 4 for STOP
        assertEquals(0x0003, gb.cpu.PC); // 1 + DEC, 2 for STOP
        // Flag check
        assertEquals(0, gb.cpu.z); // Should not going to zero
        assertEquals(1, gb.cpu.n); // Should be one
        assertEquals(1, gb.cpu.h); // Half carry should be set
    }
}