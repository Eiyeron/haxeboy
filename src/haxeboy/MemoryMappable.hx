package haxeboy;

import haxe.io.Bytes;

interface MemoryMappable {
    public function getValue(address:Int):Int;

    public function setValue(address:Int, value:Int):Void;
}