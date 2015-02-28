package random.littledudes.sprites;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxPoint;
import flixel.util.FlxColor;
import openfl.Assets;

/**
 * ...
 * @author Jack Bass
 */
class DudeSprite extends FlxSprite
{
	public var selected:Bool = false;

	public function new(x:Int = 0, y:Int = 0) 
	{
		super(x, y, Assets.getBitmapData("assets/images/littledude.png"));
		
		this.scale = new FlxPoint(2, 2);
	}
	
	override public function update()
	{
		if (this.selected)
		{
			this.color = FlxColor.RED;
		}
		else 
		{
			this.color = FlxColor.BLACK;
		}
	}
	
}