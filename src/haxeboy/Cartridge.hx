package haxeboy;

import haxe.io.Bytes;

using haxeboy.core.Tools;

class Cartridge {
    var header: HeaderInfo;

    public function new(data: Bytes) {
        header = {TITLE: ''};
        for(i in 0...16) {
            header.TITLE += String.fromCharCode(data.get(HeaderLocation.TITLE+i));
        }
        header.CARTRIDGE_TYPE = data.get(HeaderLocation.CARTRIDGE_TYPE);
        header.ROM_SIZE = data.get(HeaderLocation.ROM_SIZE);
        header.RAM_SIZE = data.get(HeaderLocation.RAM_SIZE);
        header.JAPANESE = switch(data.get(HeaderLocation.DESTINATION_CODE)) {
            case 0x0:
                true;
            case 0x01:
                false;
            default:
                throw 'unknown destination code: ' + StringTools.hex(data.get(HeaderLocation.DESTINATION_CODE));
        }
    }

    public function setValue(address: Int, value: Int) {
        var ramMode: Bool = false;
        var ramBank: Int = 0;
        var romBank: Int = 0;

        if(address.inRange(0xA000, 0xBFFF)) {
            //RAM, should be handled in MBC
        }
        else if(address.inRange(0x000, 0x1FFF)) {
            if(value & 0xF == 0xA) {
                //ENABLE RAM
            }
            else {
                //DISABLE RAM
            }
        }
        else if(address.inRange(0x2000, 0x3FFF)) {
            romBank = (romBank & (0x60)) | (value & 0x1F);
            //USE THIS
        }
        else if(address.inRange(0x4000, 0x5FFF)) {
            if(ramMode) {
                ramBank = value & 0x3;
            }
            else {
                romBank = ((value & 0x3) << 5) | (romBank & 0x1F);
            }
        }
        else if(address.inRange(0x6000, 0x7FFF)) {
            if(address == 1) {
                ramMode = true;
            }
            else {
                ramMode = false;
            }
        }
    }
}

typedef HeaderInfo = {
    ?TITLE: String,
    ?MANUFACTURER_CODE: String,
    ?CGB_FLAG: Bool,
    ?CARTRIDGE_TYPE: CartridgeType,
    ?ROM_SIZE: Int,
    ?RAM_SIZE: Int,
    ?JAPANESE: Bool
}

@:enum
abstract HeaderLocation(Int) from Int to Int {
    var TITLE = 0x0134;
    var CARTRIDGE_TYPE = 0x0147;
    var CGB_FLAG = 0x0143;
    var ROM_SIZE = 0x0148;
    var RAM_SIZE = 0x0149;
    var DESTINATION_CODE = 0x014A;
}

@:enum
abstract CartridgeType(Int) from Int to Int {
    var ROM_ONLY = 0x0;
    var MBC1 = 0x1;
    var MBC1_RAM = 0x2;
    var MBC1_RAM_BATTERY = 0x3;
    var MBC2 = 0x5;
    var MBC2_BATTERY = 0x6;
    var ROM_RAM = 0x8;
    var ROM_RAM_BATTERY = 0x9;
    var MMM01 = 0xB;
    var MMM01_RAM= 0xC;
    var MMM01_RAM_BATTERY = 0xD;
    var MBC3_TIMER_BATTERY = 0xF;
    var MBC3_TIMER_RAM_BATTERY = 0x10;
    var MBC3 = 0x11;
    var MBC3_RAM = 0x12;
    var MBC3_RAM_BATTERY = 0x13;
    var MBC4 = 0x15;
    var MBC4_RAM = 0x16;
    var MBC4_RAM_BATTERY = 0x17;
    var MBC5 = 0x19;
    var MBC5_RAM = 0x1A;
    var MBC5_RAM_BATTERY = 0x1B;
    var MBC5_RUMBLE = 0x1C;
    var MBC5_RUMBLE_RAM = 0x1D;
    var MBC5_RAMBLE_RAM_BATTERY = 0x1E;
    var POCKET_CAMERA = 0xFC;
    var BANDAI_TAMA5 = 0xFD;
    var HuC3 = 0xFE;
    var HuC1_RAM_BATTERY= 0xFF;
}
