package opcodes;

import haxeboy.core.Gameboy;

class OpcodeTest extends haxe.unit.TestCase {
    var gb:Gameboy;

    override public function setup() {
        gb = new Gameboy();
    }

}