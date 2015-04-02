package random.littledudes.sprites;

import flixel.FlxSprite;
import flixel.FlxG;
import flixel.util.FlxSpriteUtil;
import flixel.util.FlxPoint;
import flixel.util.FlxMath;
import flixel.util.FlxColor;

/**
 * ...
 * @author RandomMan
 */
class CabinIndicatorSprite extends FlxSprite
{
	
	private var cabin:Cabin;
	private var multFactor:Float;
	
	public function new(cabin:Cabin) 
	{
		super();
		this.makeGraphic(16, 16, FlxColor.TRANSPARENT);
		FlxSpriteUtil.drawTriangle(this, 0, 0, 16, FlxColor.BLACK);
		this.offset.x = 8;
		this.offset.y = 8;
		this.scrollFactor.x = 0;
		this.scrollFactor.y = 0;
		this.cabin = cabin;
		this.multFactor = Math.min(FlxG.camera.width / 2, FlxG.camera.height / 2);
		this.antialiasing = true;
	}
	
	override public function update()
	{
		super.update();
		
		if (this.cabin.isOnScreen(FlxG.camera))
		{
			this.visible = false;
		}
		else
		{
			this.visible = true;
			var centerScreenWorld = new FlxPoint(FlxG.camera.scroll.x + FlxG.camera.width / 2, FlxG.camera.scroll.y + FlxG.camera.height / 2); 
			var cabinAngle = Math.atan2(this.cabin.y - centerScreenWorld.y, this.cabin.x - centerScreenWorld.x);
			this.setPosition(Math.cos(cabinAngle) * ((this.camera.width / 2)-this.width/2) + this.camera.width / 2 , Math.sin(cabinAngle) * ((this.camera.height/2)-this.height/2) + this.camera.height / 2);
			this.angle = cabinAngle*(180/Math.PI)+90;
		}
		
		if (!this.cabin.alive)
		{
			this.kill();
		}
	}
	
}