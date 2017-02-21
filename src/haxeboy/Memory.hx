package haxeboy;

class Memory {
    /// Mockup of eventual API ///

    public var rom(default, null):ROM;
    public var current_rom_bank(default, null):Int;

    public var vram(default, null):VRAM;
    // var eram:ERAM;
    public var wram(default, null):WRAM;
    public var oam(default, null):OAM;
    // var iop:IOP;
    public var hram(default, null):HRAM;

    public function new() {
        rom = new ROM();
        current_rom_bank = 0;

        vram = new VRAM();

        wram = new WRAM();

        oam = new OAM();

        hram = new HRAM();
    }

    public function getValue(address:Int):Int {
        // ROM bank 0, always present
        if(address >= 0x0000 && address <= 0x3FFFF) {
            return rom.getValueAtBank(0, address);            
        }
        // ROM bank 1-n, swappable
        else if(address >= 0x4000 && address <= 0x7FFF) {
            return rom.getValueAtBank(current_rom_bank, address-0x4000);            
        }
        // VRAM
        else if(address >= 0x8000 && address <= 0x9FFF) {
            return vram.getValue(address - 0x8000);            
        }
        // External RAM
        else if(address >= 0xA000 && address <= 0xBFFF) {
            // Beware, this part can be changed from the cart side.
            // return external_ram.getValue(address - 0xA000);
            return 0xFF;
        }
        // Work RAM bank 0, always present
        else if(address >= 0xC000 && address <= 0xCFFF) {
            return wram.getValueAtBank(0, address - 0xC000);            
        }
        // Work RAM bank 1
        else if(address >= 0xD000 && address <= 0xDFFF) {
            return wram.getValueAtBank(1, address - 0xD000);            
        }
        // Work RAM bank 0 echo
        else if(address >= 0xE000 && address <= 0xFDFF) {
            return wram.getValueAtBank(0, address - 0xE000);            
        }
        // Sprite Attribute Table (OAM)
        else if(address >= 0xFE00 && address <= 0xFE9F) {
            return oam.getValue(address - 0xFE00);            
        }
        // Not accessible, should throw an exception, I think
        else if(address >= 0xFEA0 && address <= 0xFEFF) {
            // meh
            return 0xFF;
        }
        // IO ports
        else if(address >= 0xFF00 && address <= 0xFF7F) {
            // return iop.getValue(address - 0xFF00);            
            return 0xFF;
        }
        // HRAM (High RAM)
        else if(address >= 0xFF80 && address <= 0xFFFE) {
            return hram.getValue(address - 0xFF80);            
        }
        // Interrupt enabler
        else if(address == 0xFFFF){
            // return interrupt_enabler;
            return 0xFF;
        }        
        else {
            // throw MemoryAccesException('Out of Bounds');
            return 0xFF;
        }
    }

    public function setValue(address:Int, value:Int) {
        // ROM bank 0, always present
        if(address >= 0x0000 && address <= 0x3FFFF) {
            return rom.setValue(address, value);            
        }
        // ROM bank 1-n, swappable
        else if(address >= 0x4000 && address <= 0x7FFF) {
            return rom.setValue(address, value);            
        }
        // VRAM
        else if(address >= 0x8000 && address <= 0x9FFF) {
            return vram.setValue(address - 0x8000, value);            
        }
        // External RAM
        else if(address >= 0xA000 && address <= 0xBFFF) {
            // Beware, this part can be changed from the cart side.
            // return external_ram.setValue(address - 0xA000, value);
            return;
        }
        // Work RAM bank 0, always present
        else if(address >= 0xC000 && address <= 0xCFFF) {
            return wram.setValue(address - 0xC000, value);            
        }
        // Work RAM bank 1
        else if(address >= 0xD000 && address <= 0xDFFF) {
            return wram.setValue(address - 0xC000, value);            
        }
        // Work RAM bank 0 echo
        else if(address >= 0xE000 && address <= 0xFDFF) {
            return wram.setValue(0, address - 0xE000);            
        }
        // Sprite Attribute Table (OAM)
        else if(address >= 0xFE00 && address <= 0xFE9F) {
            return oam.setValue(address - 0xFE00, value);            
        }
        // Not accessible, should throw an exception, I think
        else if(address >= 0xFEA0 && address <= 0xFEFF) {
            // meh
            return ;
        }
        // IO ports
        else if(address >= 0xFF00 && address <= 0xFF7F) {
            // return iop.setValue(address - 0xFF00, value);            
            return;
        }
        // HRAM (High RAM)
        else if(address >= 0xFF80 && address <= 0xFFFE) {
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
    
    
    public function getValue16(address:Int) {
        return (getValue(address) << 8) | (getValue(address+1));
    }
}
