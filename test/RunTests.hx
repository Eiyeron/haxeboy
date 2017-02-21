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
		routine.set(0x0001, 0xDE); // 
		routine.set(0x0002, 0xAD);
		routine.set(0x0003, 0x76); // HALT
		gb.insertCart(routine);

		gb.cpu.PC = 0x0000;
		gb.run();

		assertEquals(gb.cpu.BC, 0xDEAD);
		assertEquals(gb.cpu.cycles, 16); // 12 for LD, 4 for HALT
	}

  	public static function main() {
	    var r = new haxe.unit.TestRunner();
	    r.add(new RunTests());
	    r.run();
	  }
}