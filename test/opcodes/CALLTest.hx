package opcodes;

import haxeboy.core.Gameboy;
import haxeboy.mbc.ROM;
import haxe.io.Bytes;
import massive.munit.Assert;

using opcodes.TestTools;

class CALLTest extends OpcodeTest {

    @Test
    function test_CALL_RET() {
        var routine = Bytes.alloc(ROM.ROM_BANK_SIZE);
        routine.writeByteBuffer([
            0xCD, 0x0, 0x6,
            0x03,
            STOP, 0x00,
            0x03,
            0x03,
            0xC9]);

        gb.insertCart(routine, true);

        gb.run();

        Assert.areEqual(0x0003, gb.cpu.BC);
        Assert.areEqual(68, gb.cpu.cycles); //would be 72 with the NOP but it stops at the STOP
        Assert.areEqual(0x6, gb.cpu.PC);
        Assert.areEqual(0xFFFE, gb.cpu.SP);
    }
}