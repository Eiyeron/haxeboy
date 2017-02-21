package;

import haxeboy.Gameboy;
import haxeboy.ROM;
import haxe.io.Bytes;

class RunTests extends haxe.unit.TestCase {
    var gb:Gameboy;

    override public function setup() {
        gb = new Gameboy();
    }

    function test_LD_BC_nn() {
        var routine = Bytes.alloc(ROM.ROM_BANK_SIZE);

        routine.set(0x0000, 0x01); // LD BC, 0xDEAD
        routine.set(0x0001, 0xDE);
        routine.set(0x0002, 0xAD);

        routine.set(0x0003, 0x76); // HALT
        gb.insertCart(routine);

        gb.run();

        assertEquals(gb.cpu.BC, 0xDEAD);
        assertEquals(gb.cpu.cycles, 16); // 12 for LD, 4 for HALT
        assertEquals(gb.cpu.PC, 0x0004); // 3 + LD, 1 for HALT
    }

    function test_INC_BC() {
        var routine = Bytes.alloc(ROM.ROM_BANK_SIZE);
        routine.set(0x0000, 0x03); // INC BC
        routine.set(0x0001, 0x76); // HALT
        gb.insertCart(routine);

        gb.cpu.halted = false;
        gb.run();

        assertEquals(0x0001, gb.cpu.BC);
        assertEquals(12, gb.cpu.cycles); // 8 for INC, 4 for HALT
        assertEquals(0x0002, gb.cpu.PC); // 1 + INC, 1 for HALT
    }

      public static function main() {
        var r = new haxe.unit.TestRunner();
        r.add(new RunTests());
        r.run();
      }
}