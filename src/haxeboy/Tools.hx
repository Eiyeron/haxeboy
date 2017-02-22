package haxeboy;

import haxe.macro.Expr;
import haxe.macro.Context;

using haxe.macro.ExprTools;

/*
   mixin class containing useful utility methods
 */
class Tools {
	/**
	 * Check that [n] is in range [min]-[max]
	 */
	public static inline function inRange<T:Float>(n:T, min:T, max:T):Bool {
		return (n >= min && n <= max);
	}

	/**
	  * react to unexpected [address] input
	  */
	public static macro function invalidAddress(address : ExprOf<Int>) {
		// for now, we'll just trace it
		// eventaully, perhaps throw an error?
		var msg:ExprOf<String> = (macro 'the address ' + $address + ' is not valid here');
		return macro {
			trace( $msg );
		};
	}
}
