package haxeboy.mbc;

import haxe.io.Bytes;

interface MBC {
    public function loadCart(bytes: Bytes): Void;

    public function getValue(address:Int): Int;

    public function setValue(address:Int, value:Int): Void;
}