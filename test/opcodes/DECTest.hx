package opcodes;

import haxeboy.Gameboy;
import haxeboy.ROM;
import haxe.io.Bytes;

class DECTest extends haxe.unit.TestCase {
    var gb:Gameboy;

    override public function setup() {
        gb = new Gameboy();
    }

    function test_DEC_B_normal() {
        var routine = Bytes.alloc(ROM.ROM_BANK_SIZE);
        routine.set(0x0000, 0x05); // DEC B
        routine.set(0x0001, 0x76); // HALT
        gb.insertCart(routine);

        gb.cpu.B = 0x02;
        gb.run();

        // Registers and timing check
        assertEquals(0x01, gb.cpu.B);
        assertEquals(8, gb.cpu.cycles); // 4 for DEC B, 4 for HALT
        assertEquals(0x0002, gb.cpu.PC); // 1 + DEC, 1 for HALT
        // Flag check
        assertEquals(0, gb.cpu.z); // It's not going to 0
        assertEquals(1, gb.cpu.n); // Should be one
        assertEquals(0, gb.cpu.h); // Not overflowing
    }

    function test_DEC_B_underflow() {
        var routine = Bytes.alloc(ROM.ROM_BANK_SIZE);
        routine.set(0x0000, 0x05); // DEC B
        routine.set(0x0001, 0x76); // HALT
        gb.insertCart(routine);

        gb.cpu.B = 0x00;
        gb.cpu.halted = false;
        gb.run();

        // Registers and timing check
        assertEquals(0xFF, gb.cpu.B);
        assertEquals(8, gb.cpu.cycles); // 4 for DEC B, 4 for HALT
        assertEquals(0x0002, gb.cpu.PC); // 1 + DEC, 1 for HALT
        // Flag check
        assertEquals(1, gb.cpu.z); // Underflowing
        assertEquals(1, gb.cpu.n); // Should be one
        assertEquals(1, gb.cpu.h); // Half carry should be set
    }

    function test_DEC_B_halfcarry() {
        var routine = Bytes.alloc(ROM.ROM_BANK_SIZE);
        routine.set(0x0000, 0x05); // DEC B
        routine.set(0x0001, 0x76); // HALT
        gb.insertCart(routine);

        gb.cpu.B = 0x10;
        gb.cpu.halted = false;
        gb.run();

        // Registers and timing check
        assertEquals(0x0F, gb.cpu.B);
        assertEquals(8, gb.cpu.cycles); // 4 for DEC B, 4 for HALT
        assertEquals(0x0002, gb.cpu.PC); // 1 + DEC, 1 for HALT
        // Flag check
        assertEquals(0, gb.cpu.z); // Should not going to zero
        assertEquals(1, gb.cpu.n); // Should be one
        assertEquals(1, gb.cpu.h); // Half carry should be set
    }

}