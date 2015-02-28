package random.littledudes ;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxTypedGroup;
import flixel.util.FlxColor;
import flixel.util.FlxPoint;
import flixel.util.FlxSort;
import flixel.util.FlxRect;
import flixel.util.FlxColorUtil;
import flixel.util.FlxMath;
import random.littledudes.sprites.Cabin;
import random.littledudes.sprites.ClickSprite;
import random.littledudes.sprites.DudeSprite;

/**
 * ...
 * @author Jack Bass
 */
class GameState extends FlxState
{
	public var playerCabin:Cabin;
	public var enemyCabin:Cabin;
	
	private var lastX:Int = 0;
	private var lastY:Int = 0;
	private var cameraScrollSpeed = 10;
	private var clickAnimation:ClickSprite;
	private var selecting:Bool = false;
	private var selectionBox:FlxRect = new FlxRect(0, 0, 1, 1);
	private var selectedDudes:Array<DudeSprite> = new Array<DudeSprite>();
	var dudesByFaction:Map<String, FlxTypedGroup<DudeSprite>> = new Map<String, FlxTypedGroup<DudeSprite>>();
	
	override public function create()
	{
		this.set_bgColor(FlxColor.WHITE); 
		
		this.dudesByFaction.set(Factions.Player, new FlxTypedGroup<DudeSprite>());
		this.dudesByFaction.set(Factions.Enemy, new FlxTypedGroup<DudeSprite>());

		for (y in 0...50)
		{
			this.dudesByFaction.get(Factions.Player).add(new DudeSprite(100, 10+y*10, Factions.Player));
		}
		
		for (y in 0...50)
		{
			this.dudesByFaction.get(Factions.Enemy).add(new DudeSprite(300, 10+y*10, Factions.Enemy));
		}
		
		this.clickAnimation = new ClickSprite();
		
		this.add(this.dudesByFaction.get(Factions.Player));
		this.add(this.dudesByFaction.get(Factions.Enemy));
		
		this.playerCabin = new Cabin( -100, 100, true);
		this.enemyCabin = new Cabin(1000, 100, false);
		
		this.add(playerCabin);
		this.add(enemyCabin);
		
		this.add(this.clickAnimation);
		
		super.create();
	}
	
	override public function update()
	{
		super.update();
		
		//sort and collide the "dudes".
		
		this.dudesByFaction.get(Factions.Player).sort(FlxSort.byY, FlxSort.ASCENDING);
		
		FlxG.collide(this.playerCabin, this.dudesByFaction.get(Factions.Player));
		FlxG.collide(this.dudesByFaction.get(Factions.Player), this.dudesByFaction.get(Factions.Player));
		FlxG.collide(this.dudesByFaction.get(Factions.Player), this.dudesByFaction.get(Factions.Enemy));
		
		//Play the click animation, and set the movement target for the dudes.
		
		if (FlxG.mouse.justReleasedRight)
		{
			this.clickAnimation.playAt(FlxG.mouse.getWorldPosition().x, FlxG.mouse.getWorldPosition().y);
			
			for (dude in this.selectedDudes)
			{
				dude.setTargetPosition(FlxG.mouse.getWorldPosition().x, FlxG.mouse.getWorldPosition().y);
			}
		}
		
		//Scroll the screen with middle mouse.
		
		if (FlxG.mouse.justPressedMiddle)
		{
			this.lastX = FlxG.mouse.screenX;
			this.lastY = FlxG.mouse.screenY;
		}
		
		if (FlxG.mouse.pressedMiddle)
		{
			FlxG.camera.scroll.x += this.lastX - FlxG.mouse.screenX;
			FlxG.camera.scroll.y += this.lastY - FlxG.mouse.screenY;
			
			
			this.lastX = FlxG.mouse.screenX;
			this.lastY = FlxG.mouse.screenY;
		}
		
		//Set the selected sprites and selection box.
		
		if (FlxG.mouse.justPressed)
		{
			this.selecting = true;
			if (!FlxG.keys.pressed.SHIFT)
			{
				this.selectedDudes = [];
				this.dudesByFaction.get(Factions.Player).forEachAlive(function (sprite:DudeSprite)
				{
					sprite.selected = false;
				});
			}
		}
		
		if (FlxG.mouse.justReleased)
		{
			this.selecting = false;
			
			this.dudesByFaction.get(Factions.Player).forEachAlive(function (sprite:DudeSprite)
			{
				if (sprite.selected)
				{
					this.selectedDudes.push(sprite);
				}
			});
		}
		
		if (this.selecting)
		{
			this.selectionBox.setSize(FlxG.mouse.screenX - this.selectionBox.x, FlxG.mouse.screenY - this.selectionBox.y);
			
			this.dudesByFaction.get(Factions.Player).forEachAlive(function (sprite:DudeSprite)
			{
				var pos:FlxPoint = sprite.getScreenXY();
			
				var rectX:Float = (this.selectionBox.width < 0)? this.selectionBox.x + this.selectionBox.width : this.selectionBox.x;
				var rectY:Float = (this.selectionBox.height < 0)? this.selectionBox.y + this.selectionBox.height : this.selectionBox.y;
				var rectWidth:Float = (this.selectionBox.width < 0)? this.selectionBox.x - rectX : this.selectionBox.width;
				var rectHeight:Float = (this.selectionBox.height < 0)? this.selectionBox.y - rectY : this.selectionBox.height;
				
				if ((pos.x >= rectX && pos.x <= rectX+rectWidth) && (pos.y >= rectY && pos.y <= rectY+rectHeight))
				{
					sprite.selected = true;
				}
				else if (!FlxG.keys.pressed.SHIFT) 
				{
					sprite.selected = false;
				}
			});
			
		}
		else
		{
			this.selectionBox.x = FlxG.mouse.screenX;
			this.selectionBox.y = FlxG.mouse.screenY;
		}
		
		//Allow the camearas to be scrolled by the arrow keys.
		
		if (FlxG.keys.pressed.UP)
		{
			FlxG.camera.scroll.y -= this.cameraScrollSpeed;
		}
		else if (FlxG.keys.pressed.DOWN)
		{
			FlxG.camera.scroll.y += this.cameraScrollSpeed;
		}
		
		if (FlxG.keys.pressed.RIGHT)
		{
			FlxG.camera.scroll.x += this.cameraScrollSpeed;
		}
		else if (FlxG.keys.pressed.LEFT)
		{
			FlxG.camera.scroll.x -= this.cameraScrollSpeed;
		}
		
		//Check attack shit
		
		this.dudesByFaction.get(Factions.Player).forEachAlive(function (sprite:DudeSprite)
		{
			var boundingBox = new FlxRect(sprite.getMidpoint().x - sprite.attackRange, sprite.getMidpoint().y - sprite.attackRange, sprite.attackRange * 2, sprite.attackRange * 2);
			
			var targetsInRange:Array<DudeSprite> = [];
			
			this.dudesByFaction.get(Factions.Enemy).forEachAlive(function (enemySprite:DudeSprite)
			{
				if (boundingBox.containsFlxPoint(enemySprite.getMidpoint()))
				{
					targetsInRange.push(enemySprite);
				}
			});
			
			sprite.targetsInProximity(targetsInRange);
			
			
		});
	}
	
	override public function draw()
	{
		super.draw();
		
		//Draw the selection box.
		
		if (this.selecting)
		{
			
			#if flash
			var rectX:Float = (this.selectionBox.width < 0)? this.selectionBox.x + this.selectionBox.width : this.selectionBox.x;
			var rectY:Float = (this.selectionBox.height < 0)? this.selectionBox.y + this.selectionBox.height : this.selectionBox.y;
			var rectWidth:Float = (this.selectionBox.width < 0)? this.selectionBox.x - rectX : this.selectionBox.width;
			var rectHeight:Float = (this.selectionBox.height < 0)? this.selectionBox.y - rectY : this.selectionBox.height;
			FlxG.camera.buffer.fillRect(new flash.geom.Rectangle(rectX, rectY, rectWidth, rectHeight), 0x880000FF);
			#elseif html5
			var rectX:Float = (this.selectionBox.width < 0)? this.selectionBox.x + this.selectionBox.width : this.selectionBox.x;
			var rectY:Float = (this.selectionBox.height < 0)? this.selectionBox.y + this.selectionBox.height : this.selectionBox.y;
			var rectWidth:Float = (this.selectionBox.width < 0)? this.selectionBox.x - rectX : this.selectionBox.width;
			var rectHeight:Float = (this.selectionBox.height < 0)? this.selectionBox.y - rectY : this.selectionBox.height;
			FlxG.camera.buffer.fillRect(new flash.geom.Rectangle(rectX, rectY, rectWidth, rectHeight), 0x880000FF);
			#else
			FlxG.camera.canvas.graphics.beginFill(FlxColor.BLUE, 0.5);
			FlxG.camera.canvas.graphics.drawRect(this.selectionBox.x, this.selectionBox.y, this.selectionBox.width, this.selectionBox.height);
			FlxG.camera.canvas.graphics.endFill();
			#end
		}
	}
	
}