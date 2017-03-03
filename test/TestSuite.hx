import massive.munit.TestSuite;

import ExampleTest;
import mbc.ROMTest;
import opcodes.ADDTest;
import opcodes.CALLTest;
import opcodes.DECTest;
import opcodes.INCTest;
import opcodes.LDTest;
import opcodes.MiscOpcodesTest;
import opcodes.OpcodeTest;
import opcodes.RLCTest;
import opcodes.RRCTest;

/**
 * Auto generated Test Suite for MassiveUnit.
 * Refer to munit command line tool for more information (haxelib run munit)
 */

class TestSuite extends massive.munit.TestSuite
{		

	public function new()
	{
		super();

		add(ExampleTest);
		add(mbc.ROMTest);
		add(opcodes.ADDTest);
		add(opcodes.CALLTest);
		add(opcodes.DECTest);
		add(opcodes.INCTest);
		add(opcodes.LDTest);
		add(opcodes.MiscOpcodesTest);
		add(opcodes.OpcodeTest);
		add(opcodes.RLCTest);
		add(opcodes.RRCTest);
	}
}
