package haxeboy.sid;

import haxe.io.Bytes;

import haxeboy.sid.input.impl.FileListener;

class FileInputDriver {
/* === Instance Fields === */

	public var fileListener : FileListener;
	private var handlers : Array<Bytes -> Void>;

	/* Constructor Function */
	public function new():Void {
		fileListener = new FileListener();
		handlers = new Array();
	}

/* === Instance Methods === */

	/**
	  * initialize [this] Driver
	  */
	public function init():Void {
		fileListener.init();
		fileListener.onFile = _fileIncoming;
	}

	/**
	  * register a handler
	  */
	public inline function onFile(handler : Bytes -> Void):Void {
		handlers.push( handler );
	}

	/**
	  * invoke all [handlers]
	  */
	private function _fileIncoming(data : Bytes):Void {
		for (f in handlers) {
			f( data );
		}
	}
}
