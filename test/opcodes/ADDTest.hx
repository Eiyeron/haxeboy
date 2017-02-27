package opcodes;

import haxeboy.mbc.ROM;
import haxe.io.Bytes;

using opcodes.TestTools;

class ADDTest extends OpcodeTest {
    function test_ADD_HL_BC() {
        var routine = Bytes.alloc(ROM.ROM_BANK_SIZE);
        routine.writeByteBuffer([0x09, STOP]);
        gb.insertCart(routine);

        gb.cpu.HL = 0xDE00;
        gb.cpu.BC = 0x00AD;

        gb.run();

        // Registers and timing check
        assertEquals(0xDEAD, gb.cpu.HL);
        assertEquals(0x00AD, gb.cpu.BC);
        assertEquals(12, gb.cpu.cycles); // 8 for LD, 4 for STOP
        assertEquals(0x0003, gb.cpu.PC); // 1 + LD (BC),A, 2 for STOP
        // Flags
        assertEquals(0x00, gb.cpu.n);
        assertEquals(0x00, gb.cpu.h);
        assertEquals(0x00, gb.cpu.Cy);
    }

    function test_ADD_HL_BC_halfcarry() {
        var routine = Bytes.alloc(ROM.ROM_BANK_SIZE);
        routine.writeByteBuffer([0x09, STOP]);
        gb.insertCart(routine);

        gb.cpu.HL = 0x0F00;
        gb.cpu.BC = 0x0100;

        gb.run();

        // Registers and timing check
        assertEquals(0x1000, gb.cpu.HL);
        assertEquals(0x0100, gb.cpu.BC);
        assertEquals(12, gb.cpu.cycles); // 8 for LD, 4 for STOP
        assertEquals(0x0003, gb.cpu.PC); // 1 + LD (BC),A, 2 for STOP
        // Flags
        assertEquals(0x00, gb.cpu.n);
        assertEquals(0x01, gb.cpu.h);
        assertEquals(0x00, gb.cpu.Cy);
    }

    function test_ADD_HL_BC_overflow() {
        var routine = Bytes.alloc(ROM.ROM_BANK_SIZE);
        routine.writeByteBuffer([0x09, STOP]);
        gb.insertCart(routine);

        gb.cpu.HL = 0xF000;
        gb.cpu.BC = 0x1000;

        gb.run();

        // Registers and timing check
        assertEquals(0x0000, gb.cpu.HL);
        assertEquals(0x1000, gb.cpu.BC);
        assertEquals(12, gb.cpu.cycles); // 8 for LD, 4 for STOP
        assertEquals(0x0003, gb.cpu.PC); // 1 + LD (BC),A, 2 for STOP
        // Flags
        assertEquals(0x00, gb.cpu.n);
        assertEquals(0x00, gb.cpu.h);
        assertEquals(0x01, gb.cpu.Cy);
    }
}