package opcodes;

import haxe.io.Bytes;

@:enum
abstract OPS(Int) from Int to Int {
    var STOP = 0x10;
}

class TestTools {
    /**
     *  Writes an 8bit integer array in Bytes byffer
     */
    public static function writeByteBuffer(buffer:Bytes, code:Array<Int>) {
        for ( i in 0 ... code.length ) {
            buffer.set(i, cast(code[i], Int));
        }
    }
}