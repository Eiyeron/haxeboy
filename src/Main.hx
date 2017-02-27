package;

import haxeboy.Gameboy;

class Main {
/* === Instance Fields === */
	var gameboy:Gameboy;

	/* Constructor Function */
	public function new() {
		gameboy = new Gameboy();
	}

/* === Static Fields === */

	static public function main() {
		var app = new Main();
	}
}
