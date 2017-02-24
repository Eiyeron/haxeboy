package haxeboy;

import haxeboy.io.Joypad;

class IOP implements MemoryMappable {

    var joypad:Joypad;

    // Serial data
    var serial_data:Int;                // $FF01
    var serial_control:Int;             // $FF02

    // Timer values
    var timer_divider_register:Int;     // $FF04
    var timer_counter:Int;              // $FF05
    var timer_modulo:Int;               // $FF06
    var timer_control:Int;              // $FF07

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
    var bg_palette:Int;                 // $FF47
    var obj0_palette:Int;               // $FF48
    var obj1_palette:Int;               // $FF49
        // Window position
    var lcd_wy:Int;                     // $FF4A
    var lcd_wx:Int;                     // $FF4B

    public function new()
    {
        joypad = new Joypad();
        // TODO : assign the other registers default values
    }

    public function getValue(address:Int):Int {
        switch(address) {
            case 0x00:
            return joypad.getValue(address - 0x00);
            case 0x01:
            return serial_data;
            case 0x02:
            return serial_control;

            case 0x04:
            return timer_divider_register;
            case 0x05:
            return timer_counter;
            case 0x06:
            return timer_modulo;
            case 0x07:
            return timer_control;

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
        switch(address) {
            case 0x00:
            joypad.setValue(address - 0x00, value);
            case 0x01:
            serial_data = value;
            case 0x02:
            serial_control = value;

            case 0x04:
            timer_divider_register = value;
            case 0x05:
            timer_counter = value;
            case 0x06:
            timer_modulo = value;
            case 0x07:
            timer_control = value;

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