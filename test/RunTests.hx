package;

import opcodes.*;

class RunTests extends haxe.unit.TestCase {

      public static function main() {
        var r = new haxe.unit.TestRunner();
        r.add(new LDTest());
        r.add(new INCTest());
        r.add(new DECTest());
        r.add(new RLCTest());
        r.run();
      }
}