package haxeboy;

// TODO
class VRAM implements MemoryMappable {
    /// Mockup of eventual API ///
    var accessible(get, never):Bool;

    public function new() {

    }

    private function get_accessible():Bool {
        // return if during HBLANK or VBLANK;
        return false;
    }

    // TODO : Get memory value
    // If the VRAM is accessible, the VRAM is supposed to yield 0xFF, whatever
    // was supposed to be on the given address.
    public function getValue(address:Int):Int
    {
        if(accessible) {
            // return memory value
            return 0;
        }
        else {
            return 0xFF;
        }
    }

    public function setValue(address:Int, value:Int) {
        // TODO : fill me
    }

}