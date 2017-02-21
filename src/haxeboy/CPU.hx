package haxeboy;

class CPU {
    /// Registers ///

    // Accumulator and flags
    public var A:Int;
    public var F:Int;
    public var AF(get, set):Int;
    // Flags stored in F
    // - Zero flag
    public var z(get ,set):Int;
    // - Add/Sub-Flag (BCD)
    public var n(get ,set):Int;
    // - Half Carry Flag (BCD)
    public var h(get ,set):Int;
    // - Carry Flag (BCD)
    public var Cy(get ,set):Int;


    // General registers
    public var B:Int;
    public var C:Int;
    public var BC(get, set):Int;

    public var D:Int;
    public var E:Int;
    public var DE(get, set):Int;

    public var H:Int;
    public var L:Int;
    public var HL(get, set):Int;

    // Stack Pointer
    public var SP:Int;

    // Program Counter
    public var PC:Int;

    // Halt status
    public var halted:Bool;

    public function new()
    {
        // TODO: start values.
    }

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

    /// Register getters ///

    public function get_AF():Int {
        return ((A << 8) & 0xFF) | (F & 0xFF);
    }

    public function get_BC():Int {
        return ((B << 8) & 0xFF) | (C & 0xFF);
    }

    public function get_DE():Int {
        return ((D << 8) & 0xFF) | (E & 0xFF);
    }

    public function get_HL():Int {   
        return ((H << 8) & 0xFF) | (L & 0xFF);
    }

    public function get_z():Int {
        return (F & (1 << 7)) >> 7;
    }

    public function get_n():Int {
        return (F & (1 << 6)) >> 6;
    }

    public function get_h():Int {
        return (F & (1 << 5)) >> 5;
    }

    public function get_Cy():Int {
        return (F & (1 << 4)) >> 4;
    }

    /// Register setters ///

    public function set_AF(value:Int):Int {
        A = (value >> 8) & 0xFF;
        F = value & 0xFF;
        return value & 0xFFFF;
    }

    public function set_BC(value:Int):Int {
        B = (value >> 8) & 0xFF;
        C = value & 0xFF;
        return value & 0xFFFF;
    }

    public function set_DE(value:Int):Int {
        D = (value >> 8) & 0xFF;
        E = value & 0xFF;
        return value & 0xFFFF;
    }

    public function set_HL(value:Int):Int {
        H = (value >> 8) & 0xFF;
        L = value & 0xFF;
        return value & 0xFFFF;
    }

    public function set_z(value:Int):Int {
        if(value == 0) {
            F &= ~(1 << 7);
            return 0;
        } else {

            F |= (1 << 7);
            return 1;
        }
    }

    public function set_n(value:Int):Int {
        if(value == 0) {
            F &= ~(1 << 6);
            return 0;
        } else {

            F |= (1 << 6);
            return 1;
        }
    }

    public function set_h(value:Int):Int {
        if(value == 0) {
            F &= ~(1 << 5);
            return 0;
        } else {

            F |= (1 << 5);
            return 1;
        }
    }

    public function set_Cy(value:Int):Int {
        if(value == 0) {
            F &= ~(1 << 4);
            return 0;
        } else {

            F |= (1 << 4);
            return 1;
        }
    }
}