package random.littledudes;

import flixel.FlxG;
import flixel.FlxSubState;
import flixel.text.FlxTextField;
import flixel.util.FlxColor;

/**
 * ...
 * @author RandomMan
 */
class LoseSubState extends FlxSubState
{

	public function new() 
	{
		super(FlxColor.TRANSPARENT);
		
		FlxG.camera.zoom = 1;
		
		var loseText = new FlxTextField(0, 0, 220, "Game Over", 32);
		loseText.scrollFactor.x = 0;
		loseText.scrollFactor.y = 0;
		loseText.setPosition((FlxG.camera.width / 2) - (loseText.width / 2), (FlxG.camera.height / 2) - loseText.height);
		loseText.color = FlxColor.BLACK;
		
		
		this.add(loseText);
		
	}
	
}