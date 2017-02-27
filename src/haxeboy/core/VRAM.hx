package haxeboy.core;

import haxe.io.UInt8Array;

// TODO
class VRAM implements MemoryMappable {
	/* Constructor Function */
	public function new():Void {
		/*
		   Creating your UInt8Array-pairs this way is more concise,
		   but generates a longer and less efficient expression in the
		   compiled code
		*/
		// tile_banks = [for(i in 0...2) new UInt8Array(VRAM_TILE_BANK_SIZE)];
		// map_banks = [for(i in 0...2) new UInt8Array(VRAM_MAP_BANK_SIZE)];
		tile_banks = [
			new UInt8Array( VRAM_TILE_BANK_SIZE ),
			new UInt8Array( VRAM_TILE_BANK_SIZE )
		];
		map_banks = [
			new UInt8Array( VRAM_MAP_BANK_SIZE ),
			new UInt8Array( VRAM_MAP_BANK_SIZE )
		];
	}

/* === Instance Methods === */

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

/* === Computed Instance Fields === */

	/// Mockup of eventual API ///
	var accessible(get, never):Bool;
	private inline function get_accessible():Bool {
		// return if during HBLANK or VBLANK;
		return false;
	}

/* === Instance Fields === */

	var tile_banks : Array<UInt8Array>;
	var map_banks : Array<UInt8Array>;


/* === Static Fields (Constants) === */

	public static inline var VRAM_TILE_BANK_SIZE:Int = 4 * 1024; // 4 kB
	public static inline var VRAM_MAP_BANK_SIZE:Int = 1024; // 1 kB
}
