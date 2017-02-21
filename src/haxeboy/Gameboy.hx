package haxeboy;

import haxe.io.Bytes;

class Gameboy {
	var cpu:CPU;
	var memory:Memory;

	public var turned_on(default, null):Bool;

	public function new()
	{
	    cpu = new CPU();
	    memory = new Memory();
	    turned_on = false;
	}

    /// Mockup of eventual API ///
	// TODO : like, everything? I haven't thought of a final API.

	public function run() {
		turned_on = true;
		
		while(true) {
			cpu.step(memory.getValue(cpu.PC));
		}
	}

	public function reset() {
		// cpu.reset();
		// memory.reset();
	}

	public function insertCart(cartData:Bytes) {
		memory.rom.loadCart(cartData);
	}

	public function removeCart() {
		memory.rom.removeCart();
	}
}
