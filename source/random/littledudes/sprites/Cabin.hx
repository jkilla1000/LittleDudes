package random.littledudes.sprites;


import openfl.Assets;
import flixel.FlxSprite;

/**
 * ...
 * @author Jack Bass
 */
class Cabin extends FlxSprite
{

	private var isPlayer:Bool = false;
	
	public function new(X:Float=0, Y:Float=0, isPlayer:Bool) 
	{
		super(X, Y);
		
		if (isPlayer)
		{
			this.loadGraphic(Assets.getBitmapData("assets/images/cabin-blue.png"), false, 32, 32);
		}
		else
		{
			this.loadGraphic(Assets.getBitmapData("assets/images/cabin-red.png"), false, 32, 32);
		}
		
		this.scale.x = 2;
		this.scale.y = 2;
		
		
		this.isPlayer = isPlayer;
	}
	
}