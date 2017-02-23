package haxeboy.core;

import haxeboy.core.Tools.*;

class SpriteAttribute implements MemoryMappable {
	/* Constructor Function */
	public function new():Void {

	}

/* === Instance Methods === */

	public function getValue(address : Int):Int {
		switch ( address ) {
			case 0:
				return y;

			case 1:
				return x;

			case 2:
				return tile;

			case 3:
				return attribute;

			// This isn't supposed to happen
			default:
				invalidAddress( address );
				return 0xFF;
		}
	}

	public function setValue(address:Int, value:Int) {
		switch ( address ) {
			case 0:
				y = value;
			case 1:
				x = value;
			case 2:
				tile = value;
			case 3:
				attribute = value;
				// This isn't supposed to happen
			default:
				invalidAddress( address );
		}
	}

/* === Computed Instance Fields === */

	// Attribute flags
	var palette_number(get, set):Int; // Bit 4
	public inline function get_palette_number():Int {
		return (attribute & (1 << 4)) >> 4;
	}
	public function set_palette_number(value:Int):Int {
		if(value == 0) {
			attribute &= ~(1 << 4);
			return 0;
		} else {
			attribute |= (1 << 4);
			return 1;
		}
	}

	var x_flip(get, set):Int; // But 5
	public inline function get_x_flip():Int {
		return (attribute & (1 << 5)) >> 5;
	}
	public function set_x_flip(value:Int):Int {
		if(value == 0) {
			attribute &= ~(1 << 5);
			return 0;
		} else {
			attribute |= (1 << 5);
			return 1;
		}
	}

	var y_flip(get, set):Int; // But 5
	public inline function get_y_flip():Int {
		return (attribute & (1 << 6)) >> 6;
	}
	public function set_y_flip(value:Int):Int {
		if(value == 0) {
			attribute &= ~(1 << 6);
			return 0;
		} else {
			attribute |= (1 << 6);
			return 1;
		}
	}

	var obj_to_bg_priority(get, set):Int; // But 5
	public inline function get_obj_to_bg_priority():Int {
		return (attribute & (1 << 7)) >> 7;
	}
	public function set_obj_to_bg_priority(value:Int):Int {
		if (value == 0) {
			attribute &= ~(1 << 7);
			return 0;
		} 
		else {
			attribute |= (1 << 7);
			return 1;
		}
	}

	/* === Instance Fields === */
	// Position
	var y:Int; // Byte 0
	var x:Int; // Byte 1

	var tile:Int; // Byte 2
	var attribute:Int; // Byte 3
}
