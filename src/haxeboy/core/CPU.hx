package haxeboy.core;

using StringTools;

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

    // Interruupt Master Enable Flag
    public var IME:Int;

    // Stop status
    private var stop_requested:Bool;
    public var stopped:Bool;
    // Halt status
    private var halt_requested:Bool;
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
        SP = 0xFFFE;
        PC = 0;
        cycles = 0;
        cyclesToBurn = 0;
        halted = false;
        halt_requested = false;
    }

    /// Mockup of eventual API ///
    public var memory:Memory;

    public function step(ignoreCycles: Bool = false) {
        var interrupts: Int = memory.getValue(0xFF0F);
        var enabledInterrupts: Int = memory.getValue(0xFFFF);
        if(IME == 1 && interrupts != 0 && enabledInterrupts != 0) {
            halted = false;
            IME = 0;
            if(enabledInterrupts & interrupts & InterruptFlag.V_BLANK != 0) {
                interrupts &= ~InterruptFlag.V_BLANK;
                memory.setValue(0xFF0F, interrupts);
                op_call(Interrupt.V_BLANK);
                return;
            }
            if(enabledInterrupts & interrupts & InterruptFlag.LCD_STAT != 0) {
                interrupts &= ~InterruptFlag.LCD_STAT;
                memory.setValue(0xFF0F, interrupts);
                op_call(Interrupt.LCD_STAT);
                return;
            }
            if(enabledInterrupts & interrupts & InterruptFlag.TIMER != 0) {
                interrupts &= ~InterruptFlag.TIMER;
                memory.setValue(0xFF0F, interrupts);
                op_call(Interrupt.TIMER);
                return;
            }
            if(enabledInterrupts & interrupts & InterruptFlag.SERIAL != 0) {
                interrupts &= ~InterruptFlag.SERIAL;
                memory.setValue(0xFF0F, interrupts);
                op_call(Interrupt.SERIAL);
                return;
            }
            if(enabledInterrupts & interrupts & InterruptFlag.JOYPAD != 0) {
                interrupts &= ~InterruptFlag.JOYPAD;
                memory.setValue(0xFF0F, interrupts);
                op_call(Interrupt.JOYPAD);  
                return;  
            }
        }

        // TODO : stuff
        if(halted)
            return;

        var opcode:Int = memory.getValue(PC);

        if (cyclesToBurn > 0) {
            cyclesToBurn--;
            cycles++;
            if(!ignoreCycles) {
                return;
            }
            else {
                while(cyclesToBurn > 0) {
                    cyclesToBurn--;
                    cycles++;
                }
            }
        }
        if(halt_requested) {
            halted = true;
            halt_requested = false;
            return;
        }
        if(stop_requested) {
            stopped = true;
            stop_requested = false;
            return;
        }

        processOpcode(opcode);

        cyclesToBurn--;
        cycles++;
    }

    function op_call(address: Int) {
        SP -= 2;
        memory.setValue16(SP, PC);
        PC = address;
    }

    function op_ret() {
        PC = memory.getValue16(SP);
        SP += 2;
    }

    /// Register getters ///
    public inline function get_AF():Int {
        return (A << 8) | F;
    }

    public inline function get_BC():Int {
        return (B << 8) | C;
    }

    public inline function get_DE():Int {
        return (D << 8) | E;
    }

    public inline function get_HL():Int {
        return (H << 8) | L;
    }

    public inline function get_z():Int {
        return (F & (1 << 7)) >> 7;
    }

    public inline function get_n():Int {
        return (F & (1 << 6)) >> 6;
    }

    public inline function get_h():Int {
        return (F & (1 << 5)) >> 5;
    }

    public inline function get_Cy():Int {
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

    // If a+b triggers the half-carry on the lower nibble, then return 1 else 0
    private function get_half_carry_from_addition(a:Int, b:Int): Int {
        return ((((a & 0x0F) + (b & 0x0F)) & 0x10) == 0x10) ? 1 : 0;
    }
    // If a substraction put a value's lower nibble going higher than before,
    // a half carry must be raised.
    private function get_half_carry_after_substraction(before:Int, after:Int): Int {
        return ((before & 0x0F) < (after & 0x0F)) ? 1 : 0;
    }
    /// Opcodes ///

    /**
     *  The big, ugly, awsful function that makes people flee by its complexity.
     *  Note: for each opcode there should be a flag alteration indicator that
     *  should look like this:
     *  // Zx nx Hx Cx
     *  x must be one of those values:
     *  - 0 or 1 is the flag is set to 1 or 0
     *  - s if the flag is set according the opcode's logic
     *  - - if the flag is let as is it.
     */
    function processOpcode(opcode:Int) {
        switch (opcode) {
            case 0x00:
                // nop
                // Z- n- H- C-
                PC += 1;
                cyclesToBurn = 4;
            case 0x01:
                // ld BC,nn
                // Z- n- H- C-
                PC++;
                BC = take16BitValue();

                cyclesToBurn = 12;
            case 0x02:
                // ld (BC),a
                // Z- n- H- C-
                memory.setValue(BC, A);
                PC += 1;
                cyclesToBurn = 8;
            case 0x03:
                // inc BC
                // Z- n- H- C-
                BC++;
                PC += 1;
                cyclesToBurn = 8;
            case 0x04:
                // inc B
                // Zs n0 Hs C-
                var Bp = B;
                B = (B + 1) % 256;
                z = (B == 0 ? 1 : 0);
                n = 0;
                // If the lower nibble overdflowed, so raise the half-carry.
                h = get_half_carry_from_addition(Bp, 1);

                PC += 1;
                cyclesToBurn = 4;
            case 0x05:
                // dec B
                // Zs n1 Hs C-
                var Bp = B;
                B = (B - 1) % 256;
                if(B < 0)
                    B += 256;
                // If the lower nibble underflowed, so raise the half-carry.
                h = get_half_carry_after_substraction(Bp, B);
                n = 1;
                z = (B == 0xFF ? 1 : 0);

                PC += 1;
                cyclesToBurn = 4;
            case 0x06:
                // ld b, d8
                // Z- n- H- C-
                PC++;
                B = take8BitValue();

                cyclesToBurn += 8;
            case 0x07:
                // rlca
                // Z0 n0 H0 Cs
                var Ap = A;
                A = (A << 1) & 0xFF;
                h = 0;
                n = 0;
                z = 0;
                Cy = (Ap & 0x80 == 0x80 ) ? 1 : 0;

                PC += 1;
                cyclesToBurn += 4;
            case 0x08:
                // ld SP,nn
                // Z- n- H- C-
                PC++;
                SP = take16BitValue();

                cyclesToBurn = 20;
            case 0x09:
                // add HL, BC (Hl += BC)
                // Z- n0 Hs Cs
                var HLp = HL;
                HL = (HL + BC) & 0xFFFF;
                n = 0;
                // If the high byte's lower nibble underflowed, so raise the half-carry.
                h = get_half_carry_from_addition(HLp>>8, B);
                // If overflow happened.
                Cy = (HLp > HL) ? 1 : 0;

                PC += 1;
                cyclesToBurn = 8;
            case 0x0A:
                // ld A,(BC)
                // Z- n- H- C-
                A = memory.getValue(BC);

                PC += 1;
                cyclesToBurn = 8;
            case 0x0B:
                // dec BC
                // Z- n- H- C-
                BC = (BC - 1) % 0x10000;
                if (BC < 0)
                    BC += 0x10000;
                PC += 1;
                cyclesToBurn = 8;
            case 0x0C:
                // inc C
                // Zs n0 Hs C-
                var Cp = C;
                C = (C + 1) % 256;
                z = (C == 0 ? 1 : 0);
                n = 0;
                // If the lower nibble overdflowed, so raise the half-carry.
                h = get_half_carry_from_addition(Cp, 1);

                PC += 1;
                cyclesToBurn = 4;
            case 0x0D:
                // dec C
                // Zs n1 Hs C-
                var Cp = C;
                C = (C - 1) % 256;
                if(C < 0)
                    C += 256;
                // If the lower nibble underflowed, so raise the half-carry.
                h = get_half_carry_after_substraction(Cp, C);
                n = 1;
                z = (C == 0xFF ? 1 : 0);

                PC += 1;
                cyclesToBurn = 4;
            case 0x0E:
                // ld c, d8
                // Z- n- H- C-
                PC++;
                C = take8BitValue();

                cyclesToBurn += 8;

            case 0x0F:
                // RRCA
                // Z0 n0 H0 Cs
                var Ap = A;
                A >>= 1;
                z = 0;
                n = 0;
                h = 0;
                Cy = (Ap & 0x01) == 0x01 ? 1 : 0;

                PC += 1;
                cyclesToBurn = 4;
            case 0x10:
                // stop (supposed to jump next instruction)
                //Z- N- H- C-
                stop_requested = true;
                PC += 2;
                cyclesToBurn = 4;

            case 0x11:
                //ld de, d16
                //Z- N- H- C-
                PC++;
                DE = take16BitValue();
                cyclesToBurn = 12;
            // ...
            case 0x76:
                // halt
                halt_requested = true;
                PC += 1;
                cyclesToBurn = 4;

            case 0xC9:
                //ret
                //Z- N- H- C-
                cyclesToBurn = 16;
                PC++;
                op_ret();
            
            case 0xC0:
                //ret nz
                //Z- N- H- C-
                PC++;
                if(z == 0) {
                    cyclesToBurn = 20;
                    op_ret();
                }
                else {
                    cyclesToBurn = 8;
                }
            case 0xC8:
                //ret z
                //Z- N- H- C-
                PC++;
                if(z == 1) {
                    cyclesToBurn = 20;
                    op_ret();
                }
                else {
                    cyclesToBurn = 8;
                }
            case 0xD0:
                //ret nc
                //Z- N- H- C-
                PC++;
                if(C == 0) {
                    cyclesToBurn = 20;
                    op_ret();
                }
                else {
                    cyclesToBurn = 8;
                }
            case 0xD8:
                //ret nz
                //Z- N- H- C-
                PC++;
                if(C == 1) {
                    cyclesToBurn = 20;
                    op_ret();
                }
                else {
                    cyclesToBurn = 8;
                }

            case 0xC4:
                //call nz a16
                //Z- N- H- C-
                PC++;
                if(z == 0) {
                    cyclesToBurn = 24;
                    op_call(take16BitValue());
                }
                else {
                    PC += 2;
                    cyclesToBurn = 12;
                }

            case 0xCC:
                //call z a16
                //Z- N- H- C-
                PC++;
                if(z == 1) {
                    cyclesToBurn = 24;
                    op_call(take16BitValue());
                }
                else {
                    PC += 2;
                    cyclesToBurn = 12;
                }

            case 0xD4:
                //call nc a16
                //Z- N- H- C-
                PC++;
                if(C == 0) {
                    cyclesToBurn = 24;
                    op_call(take16BitValue());
                }
                else {
                    PC += 2;
                    cyclesToBurn = 12;
                }

            case 0xDC:
                //call c a16
                //Z- N- H- C-
                PC++;
                if(C == 1) {
                    cyclesToBurn = 24;
                    op_call(take16BitValue());
                }
                else {
                    PC += 2;
                    cyclesToBurn = 12;
                }

            case 0xCD:
                //call a16
                //Z- N- H- C-
                cyclesToBurn = 24;
                PC++;
                op_call(take16BitValue());

            case 0xD9:
                //reti
                //Z- N- H- C-
                cyclesToBurn = 16;
                PC++;
                IME = 1;
                op_ret();

            case 0xF3:
                //di
                //Z- N- H- C-
                IME = 0;
                PC++;
                cyclesToBurn = 4;

            case 0xFB:
                //ei
                //Z- N- H- C-
                IME = 1;
                PC++;
                cyclesToBurn = 4;

            case 0xC7:
                //rst 00
                //Z- N- H- C-
                PC++;
                cyclesToBurn = 16;
                op_call(0x00);
            case 0xCF:
                //rst 08
                //Z- N- H- C-
                PC++;
                cyclesToBurn = 16;
                op_call(0x08);
            case 0xD7:
                //rst 10
                //Z- N- H- C-
                PC++;
                cyclesToBurn = 16;
                op_call(0x10);
            case 0xDF:
                //rst 18
                //Z- N- H- C-
                PC++;
                cyclesToBurn = 16;
                op_call(0x18);
            case 0xE7:
                //rst 20
                //Z- N- H- C-
                PC++;
                cyclesToBurn = 16;
                op_call(0x20);
            case 0xEF:
                //rst 28
                //Z- N- H- C-
                PC++;
                cyclesToBurn = 16;
                op_call(0x28);
            case 0xF7:
                //rst 30
                //Z- N- H- C-
                PC++;
                cyclesToBurn = 16;
                op_call(0x30);
            case 0xFF:
                //rst 38
                //Z- N- H- C-
                PC++;
                cyclesToBurn = 16;
                op_call(0x38);
        }
    }

    //take 8 bit value starting at current PC, increment PC
    function take8BitValue(): Int {
        var value: Int = memory.getValue(PC++);
        return value;
    }

    //take 16 bit value starting at current PC, increment PC by 2
    function take16BitValue(): Int {
        var value: Int = memory.getValue16(PC++);
        PC++;
        return value;
    }
}

@:enum
abstract Interrupt(Int) from Int to Int {
    var V_BLANK = 0x40;
    var LCD_STAT = 0x48;
    var TIMER = 0x50;
    var SERIAL = 0x58;
    var JOYPAD = 0x60;
}

@:enum
abstract InterruptFlag(Int) from Int to Int {
    var V_BLANK = 1 << 0;
    var LCD_STAT = 1 << 1;
    var TIMER = 1 << 2;
    var SERIAL = 1 << 3;
    var JOYPAD = 1 << 4;
}
