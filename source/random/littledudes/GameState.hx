package random.littledudes ;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxSpriteGroup;
import flixel.util.FlxColor;
import flixel.util.FlxPoint;
import flixel.util.FlxSort;
import flixel.util.FlxRect;
import flixel.util.FlxColorUtil;
import random.littledudes.sprites.ClickSprite;
import random.littledudes.sprites.DudeSprite;

/**
 * ...
 * @author Jack Bass
 */
class GameState extends FlxState
{
	private var clickAnimation:ClickSprite;
	private var selecting:Bool = false;
	private var selectionBox:FlxRect = new FlxRect(0, 0, 1, 1);
	var dudes:FlxSpriteGroup = new FlxSpriteGroup();
	
	override public function create()
	{
		this.set_bgColor(FlxColor.WHITE);
		
		this.dudes.add(new DudeSprite(100, 100));
		
		this.clickAnimation = new ClickSprite();
		
		this.add(this.dudes);
		
		this.add(this.clickAnimation);
		
		super.create();
	}
	
	override public function update()
	{
		this.dudes.sort(FlxSort.byY, FlxSort.ASCENDING);
		
		FlxG.collide(this.dudes, this.dudes);
		
		if (FlxG.mouse.justReleasedRight)
		{
			this.clickAnimation.playAt(FlxG.mouse.screenX, FlxG.mouse.screenY);
		}
		
		if (FlxG.mouse.justPressed)
		{
			this.selecting = true;
		}
		
		if (FlxG.mouse.justReleased)
		{
			this.selecting = false;
		}
		
		if (this.selecting)
		{
			
			this.selectionBox.setSize(FlxG.mouse.screenX - this.selectionBox.x, FlxG.mouse.screenY - this.selectionBox.y);
		}
		else
		{
			this.selectionBox.x = FlxG.mouse.screenX;
			this.selectionBox.y = FlxG.mouse.screenY;
		}
		
		super.update();
	}
	
	override public function draw()
	{
		super.draw();
		
		if (this.selecting)
		{
			FlxG.camera.canvas.graphics.beginFill(FlxColor.BLUE, 0.5);
			FlxG.camera.canvas.graphics.drawRect(this.selectionBox.x, this.selectionBox.y, this.selectionBox.width, this.selectionBox.height);
			FlxG.camera.canvas.graphics.endFill();
		}
	}
	
}