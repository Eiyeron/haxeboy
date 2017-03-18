package haxeboy.core;

import haxe.io.UInt8Array;

// TODO
class VRAM implements MemoryMappable {
	public static inline var VRAM_TILE_BANK_SIZE:Int = 4 * 1024; // 4 kB
	public static inline var VRAM_MAP_BANK_SIZE:Int = 1024; // 1 kB

	var tile_banks : Array<UInt8Array>;
	var map_banks : Array<UInt8Array>;

	public function new():Void {
		tile_banks = [
			new UInt8Array( VRAM_TILE_BANK_SIZE ),
			new UInt8Array( VRAM_TILE_BANK_SIZE )
		];
		map_banks = [
			new UInt8Array( VRAM_MAP_BANK_SIZE ),
			new UInt8Array( VRAM_MAP_BANK_SIZE )
		];
	}

	public function getValue(address : Int):Int {
		if ( accessible ) {
			if (address < 0x1800) {
				var num_bank:Int = Std.int(address / VRAM_TILE_BANK_SIZE);
				return tile_banks[num_bank].get(address - num_bank * VRAM_TILE_BANK_SIZE);
			}
			else {
				var num_bank:Int = Std.int((address - 0x1800) / VRAM_MAP_BANK_SIZE);
				return map_banks[num_bank].get(address - 0x1800 - num_bank * VRAM_TILE_BANK_SIZE);
			}
		}
		else {
			return 0xFF;
		}
	}

	public function setValue(address:Int, value:Int):Void {
		if ( accessible ) {
			if (address < 0x1800) {
				var num_bank:Int = Std.int(address / VRAM_TILE_BANK_SIZE);
				tile_banks[num_bank].set(address - num_bank * VRAM_TILE_BANK_SIZE, value);
			}
			else {
				var num_bank:Int = Std.int((address - 0x1800) / VRAM_MAP_BANK_SIZE);
				map_banks[num_bank].set(address - 0x1800 - num_bank * VRAM_TILE_BANK_SIZE, value);
			}
		}
		else {
			// Note : throw an exception?
		}
	}

	/// Mockup of eventual API ///
	var accessible(get, never):Bool;
	private inline function get_accessible():Bool {
		// return if during HBLANK or VBLANK;
		return false;
	}
}
