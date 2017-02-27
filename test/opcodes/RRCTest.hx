package opcodes;

import haxeboy.mbc.ROM;
import haxe.io.Bytes;

using opcodes.TestTools;

class RRCTest extends OpcodeTest {
    public function test_RRCA_nocarry() {
        var routine = Bytes.alloc(ROM.ROM_BANK_SIZE);
        routine.writeByteBuffer([0x0F, STOP]);
        gb.insertCart(routine);

        gb.cpu.A = 0x02;

        gb.run();
        // Registers and timing check
        assertEquals(0x01, gb.cpu.A);
        assertEquals(8, gb.cpu.cycles); // 4 for RRCA, 4 for STOP
        assertEquals(0x0003, gb.cpu.PC); // 1 for RRCA, 2 for STOP
        // Flags
        assertEquals(0x00, gb.cpu.z);
        assertEquals(0x00, gb.cpu.n);
        assertEquals(0x00, gb.cpu.h);
        assertEquals(0x00, gb.cpu.Cy);
    }

    public function test_RRCA_carry() {
        var routine = Bytes.alloc(ROM.ROM_BANK_SIZE);
        routine.writeByteBuffer([0x0F, STOP]);
        gb.insertCart(routine);

        gb.cpu.A = 0x01;

        gb.run();
        // Registers and timing check
        assertEquals(0x00, gb.cpu.A);
        assertEquals(8, gb.cpu.cycles); // 4 for RRCA, 4 for STOP
        assertEquals(0x0003, gb.cpu.PC); // 1 for RRCA, 2 for STOP
        // Flags
        assertEquals(0x00, gb.cpu.z);
        assertEquals(0x00, gb.cpu.n);
        assertEquals(0x00, gb.cpu.h);
        assertEquals(0x01, gb.cpu.Cy);
    }}