package mbc;

import haxeboy.mbc.*;

class ROMTest extends haxe.unit.TestCase {
    var rom: MBC;

    override public function setup() {

    }

    function test_ROM_ONLY_WRITE() {
        rom = new ROM(false);

        try {
            rom.setValue(0xA000, 0x1);
        }
        catch(e: Dynamic) {
            assertTrue(true);
            return;
        }
        assertTrue(false);
    }

    function test_ROM_RAM_WRITE() {
        rom = new ROM(true);

        rom.setValue(0xA000, 0x1);

        assertEquals(0x1, rom.getValue(0xA000));
    }
}