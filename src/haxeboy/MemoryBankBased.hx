package haxeboy;

import haxe.io.UInt8Array;

interface MemoryBankBased {
    private var banks: Array<UInt8Array>;

    public function getValueAtBank(bank:Int, address:Int):Int;
}