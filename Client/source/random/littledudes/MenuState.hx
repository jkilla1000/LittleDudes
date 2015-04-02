package random.littledudes;

import flixel.FlxG;
import flixel.FlxState;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;
import flixel.addons.ui.FlxInputText;

/**
 * ...
 * @author RandomMan
 */
class MenuState extends FlxState
{
	var ipInput:FlxInputText;
	var portInput:FlxInputText;
	
	private function connectFunction()
	{
		var gameState = new GameState(ipInput.text, portInput.text);
		
		FlxG.switchState(gameState);
	}
	
	override public function create()
	{
		super.create();

		this.set_bgColor(FlxColor.WHITE);
		
		ipInput = new FlxInputText(100, 100, 400, "localhost", 16, FlxColor.WHITE, FlxColor.BLUE);
		portInput = new FlxInputText(100, 200, 400, "6728", 16, FlxColor.WHITE, FlxColor.BLUE);
		var continueButton = new FlxButton(100, 250, "Connect", connectFunction);
		
		this.add(ipInput);
		this.add(portInput);
		this.add(continueButton);
		
	}
	
}