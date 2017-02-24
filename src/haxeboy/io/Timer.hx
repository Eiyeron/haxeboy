package haxeboy.io;

import haxeboy.MemoryMappable;

/**
 *
 *  Reference : http://bgb.bircd.org/pandocs.htm#timeranddividerregisters
 */
class Timer implements MemoryMappable {
    var divider_register:Int;

    var timer_counter:Int;
    var timer_modulo:Int;
    var timer_control:Int;

    public function new() {
        divider_register = 0;

        timer_counter = 0;
        timer_modulo = 0;
        timer_control = 0;
    }

    // TODO : call this function 16384 Hz
    public function tick_divider()
    {
        divider_register = (divider_register + 1) % 256;
    }

    // TODO : call this function according to timer_control
    public function tick_timer() {
        if((timer_control & (1 << 2)) == 0) {
            return;
        }
        timer_counter = timer_counter + 1;
        if( timer_counter > 0xFF ) {
            timer_counter = timer_modulo;
            // TODO : trigger interruption
        }
    }

    public function get_timer_frequency():Int {
        switch(timer_control & 0x03) {
            case 0x00:
                return 4096;
            case 0x01:
                return 262144;
            case 0x02:
                return 65536;
            case 0x03:
                return 16384;
        }
        // This definitely shouldn't happen but heh
        return 0;
    }

    public function getValue(address:Int):Int {
        switch(address) {
            case 0x00:
                return divider_register;
            case 0x01:
                return timer_counter;
            case 0x02:
                return timer_modulo;
            case 0x03:
                return timer_control;


            // This shouldn't happen
            default:
                // TODO : exception?
                return 0x00;
        }
    }

    public function setValue(address:Int, value:Int) {
        switch(address) {
            case 0x00:
                divider_register = 0;
            case 0x01:
                timer_counter = value;
            case 0x02:
                timer_modulo = value;
            case 0x03:
                timer_control = value;
            // This shouldn't happen
            default:
                // TODO : exception?
        }
    }
}