package opcodes;

import haxeboy.mbc.ROM;
import haxe.io.Bytes;
import massive.munit.Assert;

using opcodes.TestTools;

class DECTest extends OpcodeTest {
        @Test
        function test_DEC_B_normal() {
        var routine = Bytes.alloc(ROM.ROM_BANK_SIZE);
        routine.writeByteBuffer([0x05, STOP]);
        gb.insertCart(routine, true);

        gb.cpu.B = 0x02;
        gb.run();

        // Registers and timing check
        Assert.areEqual(0x01, gb.cpu.B);
        Assert.areEqual(8, gb.cpu.cycles); // 4 for DEC B, 4 for STOP
        Assert.areEqual(0x0003, gb.cpu.PC); // 1 + DEC, 2 for STOP
        // Flag check
        Assert.areEqual(0, gb.cpu.z); // It's not going to 0
        Assert.areEqual(1, gb.cpu.n); // Should be one
        Assert.areEqual(0, gb.cpu.h); // Not overflowing
    }

        @Test
        function test_DEC_B_underflow() {
        var routine = Bytes.alloc(ROM.ROM_BANK_SIZE);
        routine.writeByteBuffer([0x05, STOP]);
        gb.insertCart(routine, true);

        gb.cpu.B = 0x00;
        gb.run();

        // Registers and timing check
        Assert.areEqual(0xFF, gb.cpu.B);
        Assert.areEqual(8, gb.cpu.cycles); // 4 for DEC B, 4 for STOP
        Assert.areEqual(0x0003, gb.cpu.PC); // 1 + DEC, 2 for STOP
        // Flag check
        Assert.areEqual(1, gb.cpu.z); // Underflowing
        Assert.areEqual(1, gb.cpu.n); // Should be one
        Assert.areEqual(1, gb.cpu.h); // Half carry should be set
    }

        @Test
        function test_DEC_B_halfcarry() {
        var routine = Bytes.alloc(ROM.ROM_BANK_SIZE);
        routine.writeByteBuffer([0x05, STOP]);
        gb.insertCart(routine, true);

        gb.cpu.B = 0x10;
        gb.run();

        // Registers and timing check
        Assert.areEqual(0x0F, gb.cpu.B);
        Assert.areEqual(8, gb.cpu.cycles); // 4 for DEC B, 4 for STOP
        Assert.areEqual(0x0003, gb.cpu.PC); // 1 + DEC, 2 for STOP
        // Flag check
        Assert.areEqual(0, gb.cpu.z); // Should not going to zero
        Assert.areEqual(1, gb.cpu.n); // Should be one
        Assert.areEqual(1, gb.cpu.h); // Half carry should be set
    }

        @Test
        function test_DEC_BC_normal() {
        var routine = Bytes.alloc(ROM.ROM_BANK_SIZE);
        routine.writeByteBuffer([0x0B, STOP]);
        gb.insertCart(routine, true);

        gb.cpu.BC = 0x02;
        gb.run();

        // Registers and timing check
        Assert.areEqual(0x01, gb.cpu.BC);
        Assert.areEqual(12, gb.cpu.cycles); // 8 for DEC BC, 4 for STOP
        Assert.areEqual(0x0003, gb.cpu.PC); // 1 + DEC, 2 for STOP
    }

        @Test
        function test_DEC_C_normal() {
        var routine = Bytes.alloc(ROM.ROM_BANK_SIZE);
        routine.writeByteBuffer([0x0D, STOP]);
        gb.insertCart(routine, true);

        gb.cpu.C = 0x02;
        gb.run();

        // Registers and timing check
        Assert.areEqual(0x01, gb.cpu.C);
        Assert.areEqual(8, gb.cpu.cycles); // 4 for DEC B, 4 for STOP
        Assert.areEqual(0x0003, gb.cpu.PC); // 1 + DEC, 2 for STOP
        // Flag check
        Assert.areEqual(0, gb.cpu.z); // It's not going to 0
        Assert.areEqual(1, gb.cpu.n); // Should be one
        Assert.areEqual(0, gb.cpu.h); // Not overflowing
    }

        @Test
        function test_DEC_C_underflow() {
        var routine = Bytes.alloc(ROM.ROM_BANK_SIZE);
        routine.writeByteBuffer([0x0D, STOP]);
        gb.insertCart(routine, true);

        gb.cpu.C = 0x00;
        gb.run();

        // Registers and timing check
        Assert.areEqual(0xFF, gb.cpu.C);
        Assert.areEqual(8, gb.cpu.cycles); // 4 for DEC B, 4 for STOP
        Assert.areEqual(0x0003, gb.cpu.PC); // 1 + DEC, 2 for STOP
        // Flag check
        Assert.areEqual(1, gb.cpu.z); // Underflowing
        Assert.areEqual(1, gb.cpu.n); // Should be one
        Assert.areEqual(1, gb.cpu.h); // Half carry should be set
    }

        @Test
        function test_DEC_C_halfcarry() {
        var routine = Bytes.alloc(ROM.ROM_BANK_SIZE);
        routine.writeByteBuffer([0x0D, STOP]);
        gb.insertCart(routine, true);

        gb.cpu.C = 0x10;
        gb.run();

        // Registers and timing check
        Assert.areEqual(0x0F, gb.cpu.C);
        Assert.areEqual(8, gb.cpu.cycles); // 4 for DEC B, 4 for STOP
        Assert.areEqual(0x0003, gb.cpu.PC); // 1 + DEC, 2 for STOP
        // Flag check
        Assert.areEqual(0, gb.cpu.z); // Should not going to zero
        Assert.areEqual(1, gb.cpu.n); // Should be one
        Assert.areEqual(1, gb.cpu.h); // Half carry should be set
    }
}