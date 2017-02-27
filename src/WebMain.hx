package;

import haxeboy.core.Gameboy;
import haxeboy.sid.FileInputDriver;

class WebMain {
/* === Instance Fields === */

	var gameboy : Gameboy;
	var fid : FileInputDriver;

	/* Constructor Function */
	public function new() {
		gameboy = new Gameboy();
		fid = new FileInputDriver();

		initialize();
	}

/* === Instance Methods === */

	/**
	  * initialize the application as a whole
	  */
	private function initialize():Void {
		fid.init();
		fid.onFile(function( data ) {
			trace( data );
		});
	}

/* === Static Fields === */

	static public function main() {
		var app = new WebMain();
	}
}
