package opcodes;

import haxeboy.core.Gameboy;
import haxeboy.mbc.ROM;
import haxe.io.Bytes;
import massive.munit.Assert;

using opcodes.TestTools;

class ADDTest extends OpcodeTest {

    @Before
    override public function setup() {
        gb = new Gameboy();
    }

    @Test
    function test_ADD_HL_BC() {
        var routine = Bytes.alloc(ROM.ROM_BANK_SIZE);
        routine.writeByteBuffer([0x09, STOP]);
        gb.insertCart(routine);

        gb.cpu.HL = 0xDE00;
        gb.cpu.BC = 0x00AD;

        gb.run();

        // Registers and timing check
        Assert.areEqual(0xDEAD, gb.cpu.HL);
        Assert.areEqual(0x00AD, gb.cpu.BC);
        Assert.areEqual(12, gb.cpu.cycles); // 8 for LD, 4 for STOP
        Assert.areEqual(0x0003, gb.cpu.PC); // 1 + LD (BC),A, 2 for STOP
        // Flags
        Assert.areEqual(0x00, gb.cpu.n);
        Assert.areEqual(0x00, gb.cpu.h);
        Assert.areEqual(0x00, gb.cpu.Cy);
    }

    @Test
    function test_ADD_HL_BC_halfcarry() {
        var routine = Bytes.alloc(ROM.ROM_BANK_SIZE);
        routine.writeByteBuffer([0x09, STOP]);
        gb.insertCart(routine);

        gb.cpu.HL = 0x0F00;
        gb.cpu.BC = 0x0100;

        gb.run();

        // Registers and timing check
        Assert.areEqual(0x1000, gb.cpu.HL);
        Assert.areEqual(0x0100, gb.cpu.BC);
        Assert.areEqual(12, gb.cpu.cycles); // 8 for LD, 4 for STOP
        Assert.areEqual(0x0003, gb.cpu.PC); // 1 + LD (BC),A, 2 for STOP
        // Flags
        Assert.areEqual(0x00, gb.cpu.n);
        Assert.areEqual(0x01, gb.cpu.h);
        Assert.areEqual(0x00, gb.cpu.Cy);
    }

    @Test
    function test_ADD_HL_BC_overflow() {
        var routine = Bytes.alloc(ROM.ROM_BANK_SIZE);
        routine.writeByteBuffer([0x09, STOP]);
        gb.insertCart(routine);

        gb.cpu.HL = 0xF000;
        gb.cpu.BC = 0x1000;

        gb.run();

        // Registers and timing check
        Assert.areEqual(0x0000, gb.cpu.HL);
        Assert.areEqual(0x1000, gb.cpu.BC);
        Assert.areEqual(12, gb.cpu.cycles); // 8 for LD, 4 for STOP
        Assert.areEqual(0x0003, gb.cpu.PC); // 1 + LD (BC),A, 2 for STOP
        // Flags
        Assert.areEqual(0x00, gb.cpu.n);
        Assert.areEqual(0x00, gb.cpu.h);
        Assert.areEqual(0x01, gb.cpu.Cy);
    }
}