package haxeboy;

import haxeboy.Cartridge;
import haxeboy.Tools.*;

using haxeboy.Tools;

class Memory {

/* === Instance Fields === */
    public var cartridge(default, null):Cartridge;

	public var vram(default, null):VRAM;
	public var eram(default, null):ERAM;
	public var wram(default, null):WRAM;
	public var oam(default, null):OAM;
	public var iop(default, null):IOP;
	public var hram(default, null):HRAM;

	/* Constructor Function */
	public function new():Void {

		vram = new VRAM();

		eram = new ERAM();

		wram = new WRAM();

		oam = new OAM();

		hram = new HRAM();
	}

/* === Instance Methods === */
    public function linkCartrdige(cartridge:Cartridge) : Void
    {
        this.cartridge = cartridge;
    }

    public function getValue(address:Int):Int {
        // ROM
        if (address.inRange(0x0000, 0x7FFF)) {
            return cartridge.getValue(address);
        }
        // VRAM
        else if (address.inRange(0x8000, 0x9FFF)) {
            return vram.getValue(address - 0x8000);
        }
        // External RAM
        else if (address.inRange(0xA000, 0xBFFF)) {
            // Beware, this part can be changed from the cart side.
            // return external_ram.getValue(address - 0xA000);
            //return 0xFF;
            return cartridge.getValue(address);
        }
        // Work RAM bank 0, always present
        else if (address.inRange(0xC000, 0xCFFF)) {
            return wram.getValueAtBank(0, address - 0xC000);
        }
        // Work RAM bank 1
        else if (address.inRange(0xD000, 0xDFFF)) {
            return wram.getValueAtBank(1, address - 0xD000);
        }
        // Work RAM bank 0 echo
        else if (address.inRange(0xE000, 0xFDFF)) {
            return wram.getValueAtBank(0, address - 0xE000);
        }
        // Sprite Attribute Table (OAM)
        else if (address.inRange(0xFE00, 0xFE9F)) {
            return oam.getValue(address - 0xFE00);
        }
        // Not accessible, should throw an exception, I think
        else if (address.inRange(0xFEA0, 0xFEFF)) {
            // meh
            return 0xFF;
        }
        // IO ports
        else if (address.inRange(0xFF00,0xFF7F)) {
            return iop.getValue(address - 0xFF00);
        }
        // HRAM (High RAM)
        else if (address.inRange(0xFF80, 0xFFFE)) {
            return hram.getValue(address - 0xFF80);
        }
        // Interrupt enabler
        else if (address == 0xFFFF) {
            // return interrupt_enabler;
            return 0xFF;
        }
        else {
            // throw MemoryAccesException('Out of Bounds');
            return 0xFF;
        }
    }

    /*
       TODO simply the body of setValue using shorthand methods and verbose commenting
    */
    public function setValue(address:Int, value:Int) {
        // ROM
        if(address.inRange(0x0000, 0x7FFF)) {
            return cartridge.setValue(address, value);
           // return rom.setValue(address, value);
        }
        // VRAM
        else if(address.inRange(0x8000, 0x9FFF)) {
            return vram.setValue(address - 0x8000, value);
        }
        // External RAM
        else if(address.inRange(0xA000, 0xBFFF)) {
            return cartridge.setValue(address, value);
            // Beware, this part can be changed from the cart side.
            // return external_ram.setValue(address - 0xA000, value);
            return;
        }
        // Work RAM bank 0, always present
        else if(address.inRange(0xC000, 0xCFFF)) {
            return wram.setValue(address - 0xC000, value);
        }
        // Work RAM bank 1
        else if(address.inRange(0xD000, 0xDFFF)) {
            return wram.setValue(address - 0xC000, value);
        }
        // Work RAM bank 0 echo
        else if(address.inRange(0xE000, 0xFDFF)) {
            return wram.setValue(0, address - 0xE000);
        }
        // Sprite Attribute Table (OAM)
        else if(address.inRange(0xFE00, 0xFE9F)) {
            return oam.setValue(address - 0xFE00, value);
        }
        // Not accessible, should throw an exception, I think
        else if(address.inRange(0xFEA0, 0xFEFF)) {
            // meh
            return ;
        }
        // IO ports
        else if(address.inRange(0xFF00, 0xFF7F)) {
            // return iop.setValue(address - 0xFF00, value);
            return;
        }
        // HRAM (High RAM)
        else if(address.inRange(0xFF80, 0xFFFE)) {
            return hram.setValue(address - 0xFF80, value);
        }
        // Interrupt enabler
        else if(address == 0xFFFF){
            // interrupt_enabler = value;
            return ;
        }
        else {
            // throw MemoryAccesException('Out of Bounds');
            return ;
        }
    }

	public inline function getValue16(address:Int) {
		return (getValue( address ) << 8) | (getValue(address + 1));
	}
}
