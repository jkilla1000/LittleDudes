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

	public var faction:String = null;
	
	var movementSpeed:Int = 100;
	
	private var targetPosition:FlxPoint = new FlxPoint();
	
	private var moving:Bool = false;
	
	public function new(x:Int = 0, y:Int = 0, faction:String = "Player") 
	{
		super(x, y, AssetBin.dudeSprite);
		
		this.alive = true;
		
		this.health = 100;
		
		this.scale = new FlxPoint(2, 2);
		
		this.faction = faction;
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
		
		this.velocity.x = 0;
		this.velocity.y = 0;
		
		if (this.moving)
		{
			this.velocity.x = (this.x > this.targetPosition.x)? -this.movementSpeed : this.movementSpeed;
			this.velocity.y = (this.y > this.targetPosition.y)? -this.movementSpeed : this.movementSpeed;
			
			if (this.x >= this.targetPosition.x - 10 && this.x <= this.targetPosition.x + 10)
			{
				this.velocity.x = 0;
			}
			
			if (this.y >= this.targetPosition.y - 10 && this.y <= this.targetPosition.y + 10)
			{
				this.velocity.y =  0;
			}
		}
		
		super.update();
	}
	
	public function setTargetPosition(x:Float, y:Float)
	{
		targetPosition.x = x;
		targetPosition.y = y;
		
		this.moving = true;
		
		
		
	}
	
}