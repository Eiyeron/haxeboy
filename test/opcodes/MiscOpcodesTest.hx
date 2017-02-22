package opcodes;

import haxeboy.ROM;
import haxe.io.Bytes;

using opcodes.TestTools;

class MiscOpcodesTest extends OpcodeTest {
    public function test_STOP() {
        var routine = Bytes.alloc(ROM.ROM_BANK_SIZE);
        routine.writeByteBuffer([STOP, 0x00]);
        gb.insertCart(routine);
        gb.run();
        // Registers and timing check
        assertEquals(4, gb.cpu.cycles); //  4 for STOP
        assertEquals(0x0002, gb.cpu.PC); // 1 for RRCA, 1 for STOP
    }
}