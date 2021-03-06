package random.littledudes.sprites;

import flixel.FlxSprite;
import flixel.util.FlxPoint;
import openfl.Assets;

/**
 * ...
 * @author Jack Bass
 */
class ClickSprite extends FlxSprite
{

	public function new() 
	{
		super(0, 0);
		
		this.loadGraphic(Assets.getBitmapData("assets/images/clickanim.png"), true, 16, 16, true);
		this.scale.x = 2;
		this.scale.y = 2;
		this.origin.x = 16;
		this.origin.y = 16;
		this.animation.add("idle", [7], 8, true);
		this.animation.add("play", [0, 1, 2, 3, 4, 5, 6, 7], 24, false);
		this.animation.play("idle", true);
		
		this.visible = false;
	}
	
	public function playAt(x:Float, y:Float)
	{
		this.visible = false;
		this.setPosition(x, y);
		this.visible = true;
		this.animation.play("play", true);
	}
	
}