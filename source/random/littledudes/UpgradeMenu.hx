package random.littledudes;

import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.util.FlxColor;
import openfl.Assets;

/**
 * ...
 * @author Jack Bass
 */
class UpgradeMenu extends FlxSubState
{
	
	public function new() 
	{
		super(FlxColor.TRANSPARENT);
		
		var guiBacking:FlxSprite = new FlxSprite();
		
		guiBacking.loadGraphic(Assets.getBitmapData("assets/images/menuBackground.png"), false, 400, 300);
		
		guiBacking.scrollFactor.x = 0;
		guiBacking.scrollFactor.y = 0;
		
		guiBacking.setPosition(200, 150);
		
		guiBacking.scale.x = 2;
		guiBacking.scale.y = 2;
		
		guiBacking.visible = true;
		
		this.add(guiBacking);
		
	}
	
}