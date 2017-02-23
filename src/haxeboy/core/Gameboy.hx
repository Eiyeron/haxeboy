package haxeboy;

import haxe.io.Bytes;

class Gameboy {
	/* Constructor Function */
	public function new():Void {
		cpu = new CPU();
		memory = new Memory();
		cpu.memory = memory;
		turned_on = false;
	}

	/* === Instance Methods === */

	/// Mockup of eventual API ///
	// TODO : like, everything? I haven't thought of a final API.

	/**
	 * this run method need not be here
	 */
	public function run() {
		turned_on = true;

		while(turned_on && !cpu.stopped) {
			cpu.step();
		}
	}

	// why?
	public inline function reset():Void {
		// cpu.reset();
		// memory.reset();
	}

	/**
	 * emulate the insertion of a game cartridge
	 */
	public inline function insertCart(cartData : Bytes):Void {
		memory.rom.loadCart(cartData);
	}

	/**
	 * emulate the removal of a game cartridge
	 */
	public inline function removeCart():Void {
		memory.rom.removeCart();
	}

	public inline function activate():Void turned_on = true;
	public inline function deactivate():Void turned_on = false;

	/* === Instance Fields === */

	public var cpu(default, null):CPU;
	public var memory(default, null):Memory;

	public var turned_on(default, null):Bool;
}
