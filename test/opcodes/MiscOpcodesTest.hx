package opcodes;

import haxeboy.mbc.ROM;
import haxe.io.Bytes;
import massive.munit.Assert;

using opcodes.TestTools;

class MiscOpcodesTest extends OpcodeTest {

    @Test
    public function test_STOP() {
        var routine = Bytes.alloc(ROM.ROM_BANK_SIZE);
        routine.writeByteBuffer([STOP, 0x00]);
        gb.insertCart(routine, true);
        gb.run();
        // Registers and timing check
        Assert.areEqual(4, gb.cpu.cycles); //  4 for STOP
        Assert.areEqual(0x0002, gb.cpu.PC); // 1 for RRCA, 2 for STOP
    }
}