package haxeboy;

// What could be doable with this? Easily swap parts by adding a register
// function that would give the element its starting address.
// Thus making the memory map for the GB would just be a factory easily
// swappable for another for GBC or SGB.
interface MemoryMappable {
    public function getValue(address:Int):Int;
    // public function registerAdress(starting_adress:Int):Void;
}

class Memory {
    /// Mockup of eventual API ///

    // var rom:ROM;
    var vram:VRAM;
    // var eram:ERAM;
    var wram:WRAM;
    // var oam:ORAM;
    // var iop:IOP;
    var hram:HRAM;

    public function getValue(address:Int) {
        // ROM bank 0, always present
        if(address >= 0x0000 && address <= 0x3FFFF) {
            // return rom.bank[0].getValue(address);
        }
        // ROM bank 1-n, swappable
        else if(address >= 0x4000 && address <= 0x7FFF) {
            // return rom.bank[current_bank_rom].getValue(address-0x4000);            
        }
        // VRAM
        else if(address >= 0x8000 && address <= 0x9FFF) {
            return vram.getValue(address - 0x8000);            
        }
        // External RAM
        else if(address >= 0xA000 && address <= 0xBFFF) {
            // Beware, this part can be changed from the cart side.
            // return external_ram.getValue(address - 0xA000);            
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
            // return oam.getValue(address - 0xFE00);            
        }
        // Not accessible, should throw an exception, I think
        else if(address >= 0xFEA0 && address <= 0xFEFF) {
            // meh
        }
        // IO ports
        else if(address >= 0xFF00 && address <= 0xFF7F) {
            // return iop.getValue(address - 0xFF00);            
        }
        // HRAM (High RAM)
        else if(address >= 0xFF80 && address <= 0xFFFE) {
            return hram.getValue(address - 0xFF80);            
        }
        // Interrupt enabler
        else if(address == 0xFFFF){
            // return interrupt_enabler;
        }        
        else {
            // throw MemoryAccesException('Out of Bounds');
        }

    }
    
    public function getValue16(address:Int) {
        return (getValue(address) << 8) | (getValue(address+1));
    }
}