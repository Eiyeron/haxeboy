package haxeboy.sid.input.impl;

@:forward
abstract FileListener (FileListenerImpl) {
	/* Constructor Function */
	public inline function new():Void {
		this = new FLClass(); 
	}
}

#if js

typedef FLClass = haxeboy.sid.input.impl.JavaScriptFileListener;

#else

typedef FLClass = haxeboy.sid.input.impl.FileListenerImpl;

#end
