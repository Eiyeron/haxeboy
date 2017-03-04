package interrupts;

import haxeboy.core.Gameboy;
import haxeboy.mbc.ROM;
import haxe.io.Bytes;
import massive.munit.Assert;

using opcodes.TestTools;
using StringTools;

class InterruptTest {

    var gb: Gameboy;

    @Before
    public function setup() {
        gb = new Gameboy(10000);
    }

    @Test
    function test_VBLANK() {
        var routine = Bytes.alloc(ROM.ROM_BANK_SIZE);
        routine.writeByteBuffer([0x76]);
        routine.set(0x40, 0x03);
        routine.set(0x41, STOP);

        gb.insertCart(routine, true);

        gb.memory.setValue(0xFF0F, 1);

        gb.run();

        Assert.areEqual(0x0001, gb.cpu.BC);
    }

    @Test
    function test_LCD_STAT() {
        var routine = Bytes.alloc(ROM.ROM_BANK_SIZE);
        routine.writeByteBuffer([0x76]);
        routine.set(0x48, 0x03);
        routine.set(0x49, STOP);

        gb.insertCart(routine, true);

        gb.memory.setValue(0xFF0F, 1<<1);

        gb.run();

        Assert.areEqual(0x0001, gb.cpu.BC);
    }

    @Test
    function test_TIMER() {
        var routine = Bytes.alloc(ROM.ROM_BANK_SIZE);
        routine.writeByteBuffer([0x76]);
        routine.set(0x50, 0x03);
        routine.set(0x51, STOP);

        gb.insertCart(routine, true);

        gb.memory.setValue(0xFF0F, 1<<2);

        gb.run();
        
        Assert.areEqual(0x0001, gb.cpu.BC);
    }

    @Test
    function test_SERIAL() {
        var routine = Bytes.alloc(ROM.ROM_BANK_SIZE);
        routine.writeByteBuffer([0x76]);
        routine.set(0x58, 0x03);
        routine.set(0x59, STOP);

        gb.insertCart(routine, true);

        gb.memory.setValue(0xFF0F, 1<<3);

        gb.run();
        
        Assert.areEqual(0x0001, gb.cpu.BC);
    }

    @Test
    function test_JOYPAD() {
        var routine = Bytes.alloc(ROM.ROM_BANK_SIZE);
        routine.writeByteBuffer([0x76]);
        routine.set(0x60, 0x03);
        routine.set(0x61, STOP);

        gb.insertCart(routine, true);

        gb.memory.setValue(0xFF0F, 1<<4);

        gb.run();
        
        Assert.areEqual(0x0001, gb.cpu.BC);
    }

    @Test
    function test_ALL() {
        var routine = Bytes.alloc(ROM.ROM_BANK_SIZE);
        routine.writeByteBuffer([0x76]);

        routine.set(0x40, 0x03);
        routine.set(0x41, 0xC9);
        routine.set(0x48, 0x03);
        routine.set(0x49, 0xC9);
        routine.set(0x50, 0x03);
        routine.set(0x51, 0xC9);
        routine.set(0x58, 0x03);
        routine.set(0x59, 0xC9);
        routine.set(0x60, 0x03);
        routine.set(0x61, STOP);

        gb.insertCart(routine, true);

        gb.memory.setValue(0xFF0F, 0x1F);

        gb.run();
        
        Assert.areEqual(0x0005, gb.cpu.BC);
    }
}