package opcodes;

import haxe.io.Bytes;

class TestTools {
    /**
     *  Writes an 8bit integer array in Bytes byffer
     */
    public static function writeByteBuffer(buffer:Bytes, code:Array<Int>) {
        for ( i in 0 ... code.length ) {
            buffer.set(i, code[i]);
        }
    }
}