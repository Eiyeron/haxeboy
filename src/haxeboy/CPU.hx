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

    // cycles done
    public var cycles:Int;
    var cyclesToBurn:Int;

    public function new()
    {
        reset();
        // TODO: start values.
    }

    public function reset() {
        A = 0;
        F = 0;
        BC = 0;
        DE = 0;
        HL = 0;
        SP = 0;
        PC = 0;
        cycles = 0;
        cyclesToBurn = 0;
        halted = false;
    }

    /// Mockup of eventual API ///
    public var memory:Memory;

    public function step() {
        // TODO : stuff
        if(halted)
            return;
        var opcode:Int = memory.getValue(PC);

        if (cyclesToBurn > 0) {
            cyclesToBurn--;
            cycles++;
        }
        switch (opcode) {
            case 0x00:
                // nop
                PC += 1;
                cyclesToBurn = 4;
            case 0x01:
                // ld BC,nn
                BC = memory.getValue16(PC+1);
                PC += 3;
                cyclesToBurn = 12;
            case 0x02:
                // Ld (BC),a
                memory.setValue(BC, A);
                PC += 1;
                cyclesToBurn = 8;
            case 0x03:
                // inc BC
                BC = BC + 1;
                PC += 1;
                cyclesToBurn = 8;

            // ...
            case 0x76:
                // halt
                halted = true;
                PC += 1;
                cyclesToBurn = 4;
        }

        cyclesToBurn--;
        cycles++;
    }

    /// Register getters ///
cycles
    public function get_AF():Int {
        return ((A & 0xFF) << 8) | (F & 0xFF);
    }

    public function get_BC():Int {
        return ((B & 0xFF) << 8) | (C & 0xFF);
    }

    public function get_DE():Int {
        return ((D & 0xFF) << 8) | (E & 0xFF);
    }

    public function get_HL():Int {
        return ((H & 0xFF) << 8) | (L & 0xFF);
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