package haxeboy.core;

class OAM implements MemoryMappable {
    var sprites:Array<SpriteAttribute>;

    public function new() {
        sprites = [];
        for(i in 0...40) {
            sprites.push(new SpriteAttribute());
        }
    }

    public function getValue(address:Int):Int {
        var num_sprite:Int = Math.floor(address/40);
        return sprites[num_sprite].getValue(address - num_sprite * 40);
    }

    public function setValue(address:Int, value:Int) {
        var num_sprite:Int = Math.floor(address/40);
        sprites[num_sprite].setValue(address - num_sprite * 40, value);
    }
}
