package haxeboy.sid.input.impl;

import haxe.io.Bytes;
import haxe.io.BytesData;

import js.html.Event;
import js.html.File;
import js.html.FileReader;
import js.html.FileList;
import js.html.InputElement;
import js.html.InputEvent;
import js.html.ArrayBuffer;
import js.Browser;

class JavaScriptFileListener extends FileListenerImpl {
/* === Instance Fields === */

	// the file input we're listening to
	public var input : InputElement;

	/* Constructor Function */
	public function new():Void {
		super();

		input = cast Browser.document.getElementById( 'rom-input' );
	}

	override function init():Void {
		input.addEventListener('change', function(event : InputEvent) {
			var fileList:Null<FileList> = cast(event.target, InputElement).files;
			if (fileList != null && fileList.length > 0) {
				var file:Null<File> = fileList.item( 0 );
				if (file != null) {
					transpose_and_broadcast_file( file );
				}
			}
		});
	}

	/**
	  * read the File into a Bytes
	  */
	private function transpose_and_broadcast_file(file : File):Void {
		// haxe.io.Bytes is built around haxe.io.BytesData
		// on the js target haxe.io.BytesData is a typedef alias for js.html.ArrayBuffer
		var reader:FileReader = new FileReader();
		reader.addEventListener('load', function(event : Event) {
			var result:Null<Dynamic> = cast(event.target, FileReader).result;
			if (result != null && Std.is(result, ArrayBuffer)) {
				var ab:ArrayBuffer = cast(result, ArrayBuffer);
				var data:Bytes = Bytes.ofData( ab );
				onFile( data );
			}
		});
		reader.readAsArrayBuffer( file );
	}
}
