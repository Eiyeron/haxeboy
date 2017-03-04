package;
import haxeboy.core.Gameboy;
import haxeboy.mbc.ROM;
import haxe.io.Bytes;

using opcodes.TestTools;

class Main {
/* === Instance Fields === */
	var gameboy:Gameboy;

	/* Constructor Function */
	public function new() {
		gameboy = new Gameboy();

		var routine = Bytes.alloc(ROM.ROM_BANK_SIZE);
        routine.writeByteBuffer([
            0xCD, 0x0, 0x3,
            0x03,
            STOP,
            0x03,

        STOP]);

		var gb = new Gameboy();

        gb.insertCart(routine, true);

        gb.run();
	}

/* === Static Fields === */

	static public function main() {
		var app = new Main();
	}
}
