package mbc;

import haxeboy.mbc.*;

import massive.munit.util.Timer;
import massive.munit.Assert;
import massive.munit.async.AsyncFactory;

/**
* Auto generated ExampleTest for MassiveUnit. 
* This is an example test class can be used as a template for writing normal and async tests 
* Refer to munit command line tool for more information (haxelib run munit)
*/
class ROMTest 
{
	private var timer:Timer;
	
	public function new() 
	{
		
	}

    @Test 
    public function test_ROM_ONLY_WRITE() {
        var rom = new ROM(false);

        try {
            rom.setValue(0xA000, 0x1);
        }
        catch(e: Dynamic) {
            Assert.areEqual(e, 'attempted RAM access on unsupported hardware');
            return;
        }
        
       throw 'should have thrown an error';
    }

    @Test
    function test_ROM_RAM_WRITE() {
        var rom = new ROM(true);

        rom.setValue(0xA000, 0x1);
        
        Assert.areEqual(0x1, rom.getValue(0xA000));
    }
}