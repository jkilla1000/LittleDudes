package random.littledudes.sprites;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.ui.FlxBar;
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
	
	public var movementSpeed:Int = 100;
	
	public var damage:Int = 20;
	
	public var attackRange:Int = 25;
	
	public var attackTime:Float = 0.5;
	
	private var timeSinceLastAttack:Float = 0;
	
	private var targetPosition:FlxPoint = new FlxPoint();
	
	private var moving:Bool = false;
	
	public var healthBar:FlxBar;
	
	public function new(x:Int = 0, y:Int = 0, faction:String = "Player") 
	{
		super(x, y, "assets/images/littledude.png");
		
		this.alive = true;
		
		this.health = 100;
		
		this.scale = new FlxPoint(2, 2);
		
		this.healthBar = new FlxBar(0, 0, FlxBar.FILL_LEFT_TO_RIGHT, 10, 2, this, "health");
		
		this.healthBar.trackParent(-3, -8);
		
		FlxG.state.add(this.healthBar);
		
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
		
		if (this.health <= 0)
		{
			this.alive = false;
			this.kill();
		}
		
		this.timeSinceLastAttack += FlxG.elapsed;
		
		super.update();
	}
	
	override public function kill()
	{
		this.healthBar.kill();
		super.kill();
	}
	
	public function setTargetPosition(x:Float, y:Float)
	{
		targetPosition.x = x;
		targetPosition.y = y;
		
		this.moving = true;
		
	}
	
	public function targetsInProximity(targets:Array<DudeSprite>)
	{
		var attackDamage:Float = this.damage / targets.length;
		
		if (this.timeSinceLastAttack >= this.attackTime)
		{
			for (target in targets)
			{
				target.health -= attackDamage;
			}
			this.timeSinceLastAttack = 0;
		}
		
	}
	
}