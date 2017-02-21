package haxeboy;

class Gameboy {
	var cpu:CPU;
	var memory:Memory;

	public function new()
	{
	    cpu = new CPU();
	    memory = new Memory();
	}
}