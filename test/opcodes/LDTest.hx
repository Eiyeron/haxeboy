package opcodes;

import haxeboy.mbc.ROM;
import haxe.io.Bytes;
import massive.munit.Assert;

using opcodes.TestTools;

class LDTest extends OpcodeTest {
    @Test
    function test_LD_BC_nn() {
        var routine = Bytes.alloc(ROM.ROM_BANK_SIZE);
        routine.writeByteBuffer([0x01, 0xDE, 0xAD, STOP]);
        gb.insertCart(routine, true);

        gb.run();

        // Registers and timing check
        Assert.areEqual(0xDEAD, gb.cpu.BC);
        Assert.areEqual(16, gb.cpu.cycles); // 12 for LD, 4 for STOP
        Assert.areEqual(0x0005, gb.cpu.PC); // 3 + LD BC,nn, 2 for STOP
    }

    @Test
    function test_LD_BC_A_normal() {
        var routine = Bytes.alloc(ROM.ROM_BANK_SIZE);
        routine.writeByteBuffer([0x02, STOP]);
        gb.insertCart(routine, true);

        gb.cpu.BC = 0xC000;
        gb.cpu.A = 0x42;

        gb.run();

        // Registers and timing check
        Assert.areEqual(0xC000, gb.cpu.BC);
        Assert.areEqual(0x42, gb.memory.getValue(0xC000));
        Assert.areEqual(12, gb.cpu.cycles); // 8 for LD, 4 for STOP
        Assert.areEqual(0x0003, gb.cpu.PC); // 1 + LD (BC),A, 2 for STOP
    }

    // Should fail by tryng to write in ROM
    @Test
    function test_LD_BC_A_fail() {
        var routine = Bytes.alloc(ROM.ROM_BANK_SIZE);
        routine.writeByteBuffer([0x02, STOP]);
        gb.insertCart(routine, true);

        gb.cpu.BC = 0x0000;
        gb.cpu.A = 0x42;

        gb.run();

        // Registers and timing check
        Assert.areEqual(0x0000, gb.cpu.BC);
        Assert.areEqual(0x02, gb.memory.getValue(0x0000)); // Shouldn't have changed the ROM
        Assert.areEqual(12, gb.cpu.cycles); // 8 for LD, 4 for STOP
        Assert.areEqual(0x0003, gb.cpu.PC); // 1 + LD (BC),A, 2 for STOP
    }

    @Test
    function test_LD_B_d8() {
        var routine = Bytes.alloc(ROM.ROM_BANK_SIZE);
        routine.writeByteBuffer([0x06, 0x42, STOP]);
        gb.insertCart(routine, true);

        gb.run();

        // Registers and timing check
        Assert.areEqual(0x42, gb.cpu.B);
        Assert.areEqual(12, gb.cpu.cycles); // 8 for LD B,d8, 4 for STOP
        Assert.areEqual(0x0004, gb.cpu.PC); // 1 + LD (BC),A, 2 for STOP
    }

    @Test
    function test_LD_SP_nn() {
        var routine = Bytes.alloc(ROM.ROM_BANK_SIZE);
        routine.writeByteBuffer([0x08, 0xDE, 0xAD, STOP]);
        gb.insertCart(routine, true);

        gb.run();

        // Registers and timing check
        Assert.areEqual(0xDEAD, gb.cpu.SP);
        Assert.areEqual(24, gb.cpu.cycles); // 20 for LD Sp,nn, 4 for STOP
        Assert.areEqual(0x0005, gb.cpu.PC); // 3 + LD BC,nn, 2 for STOP
    }

    @Test
    function test_LD_A_BC() {
        var routine = Bytes.alloc(ROM.ROM_BANK_SIZE);
        routine.writeByteBuffer([0x0A, STOP]);
        gb.insertCart(routine, true);

        gb.cpu.BC = 0xC000;
        gb.memory.setValue(0xC000, 0x42);

        gb.run();

        // Registers and timing check
        Assert.areEqual(0x42, gb.cpu.A);
        Assert.areEqual(12, gb.cpu.cycles); // 8 for LD, 4 for STOP
        Assert.areEqual(0x0003, gb.cpu.PC); // 3 + LD BC,nn, 2 for STOP
    }

    @Test
    function test_LD_C_d8() {
        var routine = Bytes.alloc(ROM.ROM_BANK_SIZE);
        routine.writeByteBuffer([0x0E, 0x42, STOP]);
        gb.insertCart(routine, true);

        gb.run();

        // Registers and timing check
        Assert.areEqual(0x42, gb.cpu.C);
        Assert.areEqual(12, gb.cpu.cycles); // 8 for LD B,d8, 4 for STOP
        Assert.areEqual(0x0004, gb.cpu.PC); // 1 + LD (BC),A, 2 for STOP
    }
}