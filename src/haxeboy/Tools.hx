package haxeboy;

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
}