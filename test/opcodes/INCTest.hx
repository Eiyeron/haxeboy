package opcodes;

import haxeboy.mbc.ROM;
import haxe.io.Bytes;
import massive.munit.Assert;

using opcodes.TestTools;

class INCTest extends OpcodeTest {
    @Test
    function test_INC_BC() {
        var routine = Bytes.alloc(ROM.ROM_BANK_SIZE);
        routine.writeByteBuffer([0x03, STOP]);
        gb.insertCart(routine, true);

        gb.run();

        // Registers and timing check
        Assert.areEqual(0x0001, gb.cpu.BC);
        Assert.areEqual(12, gb.cpu.cycles); // 8 for INC BC, 4 for STOP
        Assert.areEqual(0x0003, gb.cpu.PC); // 1 + INC, 2 for STOP
    }

    @Test
    function test_INC_B_normal() {
        var routine = Bytes.alloc(ROM.ROM_BANK_SIZE);
        routine.writeByteBuffer([0x04, STOP]);
        gb.insertCart(routine, true);

        gb.run();

        // Registers and timing check
        Assert.areEqual(0x01, gb.cpu.B);
        Assert.areEqual(8, gb.cpu.cycles); // 4 for INC B, 4 for STOP
        Assert.areEqual(0x0003, gb.cpu.PC); // 1 + INC, 2 for STOP
        // Flag check
        Assert.areEqual(0, gb.cpu.z); // It's not going to 0
        Assert.areEqual(0, gb.cpu.n); // Should be zero
        Assert.areEqual(0, gb.cpu.h); // Not overflowing
    }

    @Test
    function test_INC_B_overflow() {
        var routine = Bytes.alloc(ROM.ROM_BANK_SIZE);
        routine.writeByteBuffer([0x04, STOP]);
        gb.insertCart(routine, true);

        gb.cpu.B =0xFF;
        gb.run();

        // Registers and timing check
        Assert.areEqual(0x00, gb.cpu.B);
        Assert.areEqual(8, gb.cpu.cycles); // 4 for INC B, 4 for STOP
        Assert.areEqual(0x0003, gb.cpu.PC); // 1 + INC, 2 for STOP
        // Flag check
        Assert.areEqual(1, gb.cpu.z); // Overflowing
        Assert.areEqual(0, gb.cpu.n); // Should be zero
        Assert.areEqual(1, gb.cpu.h); // Half carry should be set
    }

    @Test
    function test_INC_B_halfcarry() {
        var routine = Bytes.alloc(ROM.ROM_BANK_SIZE);
        routine.writeByteBuffer([0x04, STOP]);
        gb.insertCart(routine, true);

        gb.cpu.B = 0x0F;
        gb.run();

        // Registers and timing check
        Assert.areEqual(0x10, gb.cpu.B);
        Assert.areEqual(8, gb.cpu.cycles); // 4 for INC B, 4 for STOP
        Assert.areEqual(0x0003, gb.cpu.PC); // 1 + INC, 2 for STOP
        // Flag check
        Assert.areEqual(0, gb.cpu.z); // Overflowing
        Assert.areEqual(0, gb.cpu.n); // Should be zero
        Assert.areEqual(1, gb.cpu.h); // Half carry should be set
    }

    @Test
    function test_INC_C_normal() {
        var routine = Bytes.alloc(ROM.ROM_BANK_SIZE);
        routine.writeByteBuffer([0x0C, STOP]);
        gb.insertCart(routine, true);

        gb.run();

        // Registers and timing check
        Assert.areEqual(0x01, gb.cpu.C);
        Assert.areEqual(8, gb.cpu.cycles); // 4 for INC B, 4 for STOP
        Assert.areEqual(0x0003, gb.cpu.PC); // 1 + INC, 2 for STOP
        // Flag check
        Assert.areEqual(0, gb.cpu.z); // It's not going to 0
        Assert.areEqual(0, gb.cpu.n); // Should be zero
        Assert.areEqual(0, gb.cpu.h); // Not overflowing
    }

    @Test
    function test_INC_C_overflow() {
        var routine = Bytes.alloc(ROM.ROM_BANK_SIZE);
        routine.writeByteBuffer([0x0C, STOP]);
        gb.insertCart(routine, true);

        gb.cpu.C =0xFF;
        gb.run();

        // Registers and timing check
        Assert.areEqual(0x00, gb.cpu.C);
        Assert.areEqual(8, gb.cpu.cycles); // 4 for INC B, 4 for STOP
        Assert.areEqual(0x0003, gb.cpu.PC); // 1 + INC, 2 for STOP
        // Flag check
        Assert.areEqual(1, gb.cpu.z); // Overflowing
        Assert.areEqual(0, gb.cpu.n); // Should be zero
        Assert.areEqual(1, gb.cpu.h); // Half carry should be set
    }

    @Test
    function test_INC_C_halfcarry() {
        var routine = Bytes.alloc(ROM.ROM_BANK_SIZE);
        routine.writeByteBuffer([0x0C, STOP]);
        gb.insertCart(routine, true);

        gb.cpu.C = 0x0F;
        gb.run();

        // Registers and timing check
        Assert.areEqual(0x10, gb.cpu.C);
        Assert.areEqual(8, gb.cpu.cycles); // 4 for INC B, 4 for STOP
        Assert.areEqual(0x0003, gb.cpu.PC); // 1 + INC, 2 for STOP
        // Flag check
        Assert.areEqual(0, gb.cpu.z); // Overflowing
        Assert.areEqual(0, gb.cpu.n); // Should be zero
        Assert.areEqual(1, gb.cpu.h); // Half carry should be set
    }

}