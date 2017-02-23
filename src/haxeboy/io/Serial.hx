package haxeboy.io;

import haxeboy.core.MemoryMappable;

@:enum
abstract TransferControlBits(Int) from Int to Int {
    var ShiftClock = 1 << 0;
    var ClockSpeed = 1 << 1;
    var TransferStart = 1 << 7;
}

@:enum
abstract ClockType(Int) from Int to Int {
    var ExternalClock = 0;
    var InternalClock = 1 << 0;
}

/**
 *  NOTE : The sent value is automatically replaced by the received value on the same register.
 *  WARNING : this is very probably a very wrong way to manage the serial port, this needs to be fixed.
 *  http://bgb.bircd.org/pandocs.htm#serialdatatransferlinkcable
 */
class Serial implements MemoryMappable {

    var transfer_data:Int;
    var transfer_control:Int;

    var clock_type:ClockType;

    public function new () {
        transfer_data = 0;
        transfer_control = 1 << 2; // Halt the timer
        clock_type = ExternalClock;
    }

    /**
     *  TODO : maange the timing correctly (On gb 8192Hz)
     *  TODO : trigger interruption
     *  Also manage the TransferStart.
     */
    public function transferData(value_to_receive:Int):Int {
        var value_to_send:Int = transfer_data;
        // Put the received data into the port.
        transfer_data = value_to_receive;
        // Tell the communication ended
        transfer_control &= ~TransferStart;
        // TODO : interruption here
        return value_to_send;
    }

    function updateSettings(new_control_value:Int) {
        // TODO : manage settings

        // TODO : manage clock switch
        switch (new_control_value & ShiftClock) {
            case ExternalClock:
                clock_type = ExternalClock;
            case InternalClock:
                clock_type = InternalClock;
        }
        // Finally
        transfer_control = new_control_value;
    }

    public function getValue(address:Int):Int {
        switch(address) {
            case 0x00:
                return transfer_data;
            case 0x01:
                return transfer_control;
            // This shouldn't happen
            default:
                // TODO : exception?
                return 0x00;
        }
    }

    public function setValue(address:Int, value:Int) {
        switch(address) {
            case 0x00:
                transfer_data = value;
            case 0x01:
                updateSettings(value);
            // This shouldn't happen
            default:
                // TODO : exception?
        }
    }
}