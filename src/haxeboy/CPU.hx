package haxeboy;

class CPU {
    /// Registers ///

    // Accumulator and flags
    var A:Int;
    var F:Int;    

    // General registers
    var B:Int;
    var C:Int;

    var D:Int;
    var E:Int;

    var H:Int;
    var L:Int;

    // Stack Pointer
    var S:Int;
    var P:Int;

    // Program Counter
    var P:Int;
    var C:Int;

    // Halt status
    var halted:Bool;

    /// Mockup of eventual API ///
    var memory:Memory;

    public function step(opcode:Int) {
        // TODO : stuff
        switch (opcode) {
            case 0x00:
                // nop
            case 0x01:
                // ld BC,nn
                BC = memory.getValue16(PC);
        }
    }
}