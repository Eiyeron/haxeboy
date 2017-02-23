package haxeboy.io;

using haxeboy.core.Tools;

@:enum
abstract PaletteColor(Int) from Int to Int {
    var White = 0;
    var LightGray = 1;
    var DarkGray = 2;
    var Black = 3;
}

abstract Palette(Int) from Int to Int {
    public function getColor(index:Int):Int {
        if(index.inRange(0, 3)) {
            return (this & (0x3 << (index * 2)));
        }
        else {
            return 0;
        }
    }

    public inline function setColor(index:Int, value:PaletteColor){
        if(index.inRange(0, 3)) {
            // Removing the precedent color at this index
            this &= ~(0x3 << (index * 2));
            // Setting the new color
            this |= (value <<(index * 2));
        }
    }
}