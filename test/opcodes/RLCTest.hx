package opcodes;

import haxeboy.ROM;
import haxe.io.Bytes;

using opcodes.TestTools;

class RLCTest extends OpcodeTest {
    public function test_RLCA_nocarry() {
        var routine = Bytes.alloc(ROM.ROM_BANK_SIZE);
        routine.writeByteBuffer([0x07, HALT]);
        gb.insertCart(routine);

        gb.cpu.A = 0x02;

        gb.run();
        assertEquals(0x01, gb.cpu.A);
        assertEquals(8, gb.cpu.cycles); // 12 for LD, 4 for HALT
        assertEquals(0x0002, gb.cpu.PC); // 3 + LD BC,nn, 1 for HALT
        // Flags
        assertEquals(0x00, gb.cpu.z); // 3 + LD BC,nn, 1 for HALT
        assertEquals(0x00, gb.cpu.n); // 3 + LD BC,nn, 1 for HALT
        assertEquals(0x00, gb.cpu.h); // 3 + LD BC,nn, 1 for HALT
        assertEquals(0x00, gb.cpu.Cy); // 3 + LD BC,nn, 1 for HALT
    }

    public function test_RLCA_carry() {
        var routine = Bytes.alloc(ROM.ROM_BANK_SIZE);
        routine.writeByteBuffer([0x07, HALT]);
        gb.insertCart(routine);

        gb.cpu.A = 0x01;

        gb.run();
        assertEquals(0x00, gb.cpu.A);
        assertEquals(8, gb.cpu.cycles); // 12 for LD, 4 for HALT
        assertEquals(0x0002, gb.cpu.PC); // 3 + LD BC,nn, 1 for HALT
        // Flags
        assertEquals(0x00, gb.cpu.z); // 3 + LD BC,nn, 1 for HALT
        assertEquals(0x00, gb.cpu.n); // 3 + LD BC,nn, 1 for HALT
        assertEquals(0x00, gb.cpu.h); // 3 + LD BC,nn, 1 for HALT
        assertEquals(0x01, gb.cpu.Cy); // 3 + LD BC,nn, 1 for HALT
    }}