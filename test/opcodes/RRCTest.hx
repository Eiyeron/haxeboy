package opcodes;

import haxeboy.mbc.ROM;
import haxe.io.Bytes;
import massive.munit.Assert;

using opcodes.TestTools;

class RRCTest extends OpcodeTest {
    @Test
    public function test_RRCA_nocarry() {
        var routine = Bytes.alloc(ROM.ROM_BANK_SIZE);
        routine.writeByteBuffer([0x0F, STOP]);
        gb.insertCart(routine);

        gb.cpu.A = 0x02;

        gb.run();
        // Registers and timing check
        Assert.areEqual(0x01, gb.cpu.A);
        Assert.areEqual(8, gb.cpu.cycles); // 4 for RRCA, 4 for STOP
        Assert.areEqual(0x0003, gb.cpu.PC); // 1 for RRCA, 2 for STOP
        // Flags
        Assert.areEqual(0x00, gb.cpu.z);
        Assert.areEqual(0x00, gb.cpu.n);
        Assert.areEqual(0x00, gb.cpu.h);
        Assert.areEqual(0x00, gb.cpu.Cy);
    }

    @Test
    public function test_RRCA_carry() {
        var routine = Bytes.alloc(ROM.ROM_BANK_SIZE);
        routine.writeByteBuffer([0x0F, STOP]);
        gb.insertCart(routine);

        gb.cpu.A = 0x01;

        gb.run();
        // Registers and timing check
        Assert.areEqual(0x00, gb.cpu.A);
        Assert.areEqual(8, gb.cpu.cycles); // 4 for RRCA, 4 for STOP
        Assert.areEqual(0x0003, gb.cpu.PC); // 1 for RRCA, 2 for STOP
        // Flags
        Assert.areEqual(0x00, gb.cpu.z);
        Assert.areEqual(0x00, gb.cpu.n);
        Assert.areEqual(0x00, gb.cpu.h);
        Assert.areEqual(0x01, gb.cpu.Cy);
    }}