package opcodes;

import haxeboy.core.Gameboy;
import haxeboy.mbc.ROM;
import haxe.io.Bytes;
import massive.munit.Assert;

using opcodes.TestTools;

class CALLTest extends OpcodeTest {

    @Test
    function test_CALL() {
        var routine = Bytes.alloc(ROM.ROM_BANK_SIZE);
        routine.writeByteBuffer([
            0xCD, 0x0, 0x5,
            0x03,
            STOP,
            0x03,
            0x03,
            0xC9]);

        gb.insertCart(routine, true);

        gb.run();

        Assert.areEqual(0x0003, gb.cpu.BC);
    }
}