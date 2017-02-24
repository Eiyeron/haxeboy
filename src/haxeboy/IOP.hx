package haxeboy;

using haxeboy.Tools;

import haxeboy.io.Joypad;
import haxeboy.io.Serial;
import haxeboy.io.Timer;
import haxeboy.io.Palette;

class IOP implements MemoryMappable {

    var joypad:Joypad;

    var serial_port:Serial;

    var timer:Timer;

    // LCDC (LCD Controll)
    var lcd_control:Int;                // $FF40
    var lcd_stat:Int;                   // $FF41
        // Screen position
    var lcd_scy:Int;                    // $FF42
    var lcd_scx:Int;                    // $FF43
        // LCD screen copy position indication
    var lcd_ly:Int;                     // $FF44
    var lcd_lyc:Int;                    // $FF45
        // LCD OAM DMA
    var lcd_dma_transfer_address:Int;   // $FF46
        // Palettes
    // TODO : move them into the future LCDC class
    var bg_palette:Palette;                 // $FF47
    var obj0_palette:Palette;               // $FF48
    var obj1_palette:Palette;               // $FF49
        // Window position
    var lcd_wy:Int;                     // $FF4A
    var lcd_wx:Int;                     // $FF4B

    public function new()
    {
        joypad = new Joypad();
        serial_port = new Serial();
        timer = new Timer();
        // TODO : assign the other registers default values
    }

    public function getValue(address:Int):Int {
        if (address == 0x00)
            return joypad.getValue(address);
        else if(address.inRange(0x01, 0x02)) {
            return serial_port.getValue(address - 0x01);
        }
        else if(address.inRange(0x04, 0x07)) {
            return timer.getValue(address - 0x04);
        }
        else switch(address) {
            case 0x40:
            return lcd_control;
            case 0x41:
            return lcd_stat;
            case 0x42:
            return lcd_scy;
            case 0x43:
            return lcd_scx;
            case 0x44:
            return lcd_ly;
            case 0x45:
            return lcd_lyc;
            case 0x46:
            return lcd_dma_transfer_address;
            case 0x47:
            return bg_palette;
            case 0x48:
            return obj0_palette;
            case 0x49:
            return obj1_palette;
            case 0x4A:
            return lcd_wy;
            case 0x4B:
            return lcd_wx;

            // TODO: determine what to do when accessing non mapped addresses.
            default:
                return 0x00;
        }
    }

    public function setValue(address:Int, value:Int) {
            if (address == 0x00)
                return joypad.setValue(address, value);
            else if(address.inRange(0x01, 0x02)) {
                return serial_port.setValue(address - 0x01, value);
            }
            else if(address.inRange(0x04, 0x07)) {
                return timer.setValue(address - 0x04, value);
            }
            else switch(address) {
                case 0x40:
                lcd_control = value;
                case 0x41:
                lcd_stat = value;
                case 0x42:
                lcd_scy = value;
                case 0x43:
                lcd_scx = value;
                case 0x44:
                lcd_ly = value;
                case 0x45:
                lcd_lyc = value;
                case 0x46:
                lcd_dma_transfer_address = value;
                case 0x47:
                bg_palette = value;
                case 0x48:
                obj0_palette = value;
                case 0x49:
                obj1_palette = value;
                case 0x4A:
                lcd_wy = value;
                case 0x4B:
                lcd_wx = value;

            // TODO: determine what to do when accessing non mapped addresses.
            default:
        }
    }
}