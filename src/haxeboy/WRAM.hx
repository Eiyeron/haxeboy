package haxeboy;

import haxe.io.UInt8Array;

class WRAM implements MemoryMappable implements MemoryBankBased {
    var banks:Array<UInt8Array>;

    public function new()
    {
        banks = [for(i in 0...2) new UInt8Array(1024)];
    }

    public function getValue(address:Int) {
        return banks[Std.int(address/1024)].get(address%1024);
    }

    public function getValueAtBank(bank:Int, address:Int) {
        return banks[bank].get(address);
    }
}