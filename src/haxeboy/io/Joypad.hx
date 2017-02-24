package haxeboy.io;

import haxeboy.MemoryMappable;

// Those two enumerations are bitmasks allowing people to easily get a specific
// button from the given value or to set their flag.
@:enum
abstract DirectionBits(Int) {
    var  RightButton = 1 << 0;
    var  LeftButton = 1 << 1;
    var  UpButton = 1 << 2;
    var  DownButton = 1 << 3;
}
@:enum
abstract ButtonBits(Int) {
    var  AButton = 1 << 0;
    var  BButton = 1 << 1;
    var  SelectButton = 1 << 2;
    var  StartButton = 1 << 3;
}

// Bitmask that get the required kind of buttons to poll.
@:enum
abstract SwitchPolling(Int) {
    var SelectDirectionPolling = 1 << 4;
    var SelectButtonPolling = 1 << 5;
}

/**
 *  The Gameboy uses a single byte port to handle the joypad.
 *  Using a state-based controller, it allows fetching directions or butttons
 *  by writing two specific bits to this port.
 *
 *  TODO : Add an interruption notification when a button is pressed; (cf http://bgb.bircd.org/pandocs.htm#joypadinput)
 */
class Joypad implements MemoryMappable {

        var pollingState:SwitchPolling;
        var buttonsState:Int;
        var directionsState:Int;

        public function new() {
            pollingState = SelectButtonPolling;
            buttonsState = 0;
            directionsState = 0;
        }

        // TODO : link to actual functions.
        /**
         *  This function should be called from the wrapping system to update
         *  the button states.
         */
        public function updateButtonState() {
        }

        public function getValue(address:Int):Int {
            switch(pollingState) {
                case SelectButtonPolling:
                    return buttonsState;
                case SelectDirectionPolling:
                    return directionsState;
            }
        }

        public function setValue(address:Int, value:Int) {
            if ( (value & cast SelectDirectionPolling) != 0) {
                pollingState = SelectDirectionPolling;
            }
            else if ( (value & cast SelectButtonPolling) != 0) {
                pollingState = SelectButtonPolling;
            }
        }

}