package haxeboy;

import haxe.io.UInt8Array;

class HRAM implements MemoryMappable {
    var bank:UInt8Array;

    public function new()
    {
        bank = new UInt8Array(0x7E); // 128 bytes
    }

    public function getValue(address:Int):Int
    {
        return bank.get(address);
    }

    public function setValue(address:Int, value:Int) {
        bank.set(address, value);
    }

}