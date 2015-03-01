package random.littledudes.sprites;


import flixel.ui.FlxButton;
import flixel.util.FlxRect;
import openfl.Assets;
import flixel.FlxSprite;
import flixel.ui.FlxBar;
import flixel.util.FlxMath;
import flixel.util.FlxColor;
import flixel.FlxG;
import random.littledudes.UpgradeMenu;

/**
 * ...
 * @author Jack Bass
 */
class Cabin extends FlxSprite
{

	private var isPlayer:Bool = false;
	
	private var healthBar:FlxBar;
	
	private var timeBar:FlxBar;
	
	private var spawnTimeLeft:Float = 5.0;
	
	private var spawnTime:Float = 5.0;
	
	private var isSpawning:Bool = false;
	 
	
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
		
		this.origin.x = 32;
		this.origin.y = 32;
		
		this.health = 10000;
		
		this.healthBar = new FlxBar(0, 0, FlxBar.FILL_LEFT_TO_RIGHT, 64, 5, this, "health", 0, 100);
		
		this.healthBar.trackParent(-32, -48);
		
		this.healthBar.killOnEmpty = true;
		
		FlxG.state.add(this.healthBar);
		
		this.timeBar = new FlxBar(0, 0, FlxBar.FILL_LEFT_TO_RIGHT, 64, 5, this, "spawnTimeLeft", 0, 5.0);
		
		this.timeBar.trackParent( -32, -64);
		
		this.timeBar.killOnEmpty = false;
		
		this.timeBar.createFilledBar(FlxColor.TRANSPARENT, FlxColor.BLUE);
		
		this.isPlayer = isPlayer;
		
		if (this.isPlayer)
		{
			FlxG.state.add(this.timeBar);
		}
			
		this.immovable = true;

	}
	
	private function spawnDude()
	{
		
	}
	
	override public function update()
	{
		super.update();
		
		if (this.isPlayer)
		{
			if (FlxG.mouse.justPressed)
			{
					if (FlxMath.mouseInFlxRect(true, new FlxRect(this.x - this.width, this.y - this.height, this.width * 2, this.height * 2)))
					{
						FlxG.state.openSubState(new UpgradeMenu());
						
					}
			}
			
			if (this.isSpawning)
			{
			
				this.spawnTimeLeft -= FlxG.elapsed;
			
				if (this.spawnTimeLeft <= 0)
				{
					this.spawnDude();
					this.spawnTimeLeft = this.spawnTime;
				}
			}
			else 
			{
				this.spawnTimeLeft = this.spawnTime;
			}
		}
	}
	
}