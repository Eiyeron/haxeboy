package;

import haxeboy.Gameboy;

class Main {

    var gameboy:Gameboy;

    public function new() {
        gameboy = new Gameboy();
    }

    static public function main() {
        var app = new Main();
    }
}