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
import random.network.NetworkedDude;

import haxe.Serializer;

import neko.vm.Thread;

import sys.net.Host;
import sys.net.Socket;

/**
 * ...
 * @author Jack Bass
 */
class GameState extends FlxState
{
	public var playerCabin:Cabin;
	public var enemyCabins:Map<Int, Cabin> = new Map<Int, Cabin>();
	
	private var lastX:Int = 0;
	private var lastY:Int = 0;
	private var cameraScrollSpeed = 10;
	private var clickAnimation:ClickSprite;
	private var selecting:Bool = false;
	private var selectionBox:FlxRect = new FlxRect(0, 0, 1, 1);
	private var selectedDudes:Array<DudeSprite> = new Array<DudeSprite>();
	private var dudesById:Map<Int, DudeSprite> = new Map<Int, DudeSprite>();
	private var dudesByFaction:Map<String, FlxTypedGroup<DudeSprite>> = new Map<String, FlxTypedGroup<DudeSprite>>();
	
	private var isConnected = false;
	
	private static var SERVER_PORT = 6728;
	
	var socket:Socket;
	
	var connectionThread:Thread;
	var gameThread:Thread;
	
	public function addDude(dude:NetworkedDude)
	{
		this.socket.write("new" + dude.toString());
	}
	
	private function attemptConnection()
	{
		this.isConnected = true;
		
		try 
		{
			this.socket.connect(new Host("localhost"), 6728);
		}
		catch (e:Dynamic) 
		{
			trace("Failed to connect to server");
			this.isConnected = false;
			Sys.exit(1234);
		}
		
		
		this.socket.setFastSend(true);
		
		this.socket.setTimeout(0.1);
		
	}
	
	private function updateConnection()
	{
		var input = "timeout";
		
		
		try 
		{
			input = this.socket.input.readLine();
		
		}
		catch (e:Dynamic)
		{
			
		}
		
		if (input != "timeout")
		{
			
			for (message in input.split(";"))
			{
				
				if (StringTools.startsWith(message, "newdude"))
				{
					var splitMessage = message.split(" ");
					var dude = new DudeSprite(Std.parseFloat(splitMessage[2]), Std.parseFloat(splitMessage[3]), Factions.Player);
					dude.ID = Std.parseInt(splitMessage[1]);
					dude.health = Std.parseInt(splitMessage[4]);
					dude.damage = Std.parseInt(splitMessage[5]);
					dude.attackRange = Std.parseInt(splitMessage[6]);
					dude.attackTime = Std.parseFloat(splitMessage[7]);
					this.dudesById.set(dude.ID, dude);
					this.dudesByFaction.get(Factions.Player).add(dude);
				}
				else if (StringTools.startsWith(message, "newenemydude"))
				{
					trace("Registered a dude"); 
					var splitMessage = message.split(" ");
					var dude = new DudeSprite(Std.parseFloat(splitMessage[2]), Std.parseFloat(splitMessage[3]), Factions.Enemy);
					dude.ID = Std.parseInt(splitMessage[1]);
					dude.health = Std.parseInt(splitMessage[4]);
					dude.damage = Std.parseInt(splitMessage[5]);
					dude.attackRange = Std.parseInt(splitMessage[6]);
					dude.attackTime = Std.parseFloat(splitMessage[7]);
					this.dudesById.set(dude.ID, dude);
					this.dudesByFaction.get(Factions.Enemy).add(dude);
				}
				else if (StringTools.startsWith(message, "settarget"))
				{
					var splitMessage = message.split(" ");
					var id = Std.parseInt(splitMessage[1]);
					this.dudesById.get(id).setTargetPosition(Std.parseFloat(splitMessage[2]), Std.parseFloat(splitMessage[3]));
				}
				else if (StringTools.startsWith(message, "playercabin"))
				{
					var splitMessage = message.split(" ");
					this.playerCabin = new Cabin(Std.parseInt(splitMessage[1]), Std.parseInt(splitMessage[2]), true);
					playerCabin.health = Std.parseInt(splitMessage[3]);
					this.add(playerCabin);
					FlxG.camera.scroll.set(this.playerCabin.x-FlxG.width/2, this.playerCabin.y-FlxG.height/2);
				}
				else if (StringTools.startsWith(message, "enemycabin"))
				{
					var splitMessage = message.split(" ");
					var id = Std.parseInt(splitMessage[1]);
					var cabin = new Cabin(Std.parseInt(splitMessage[2]), Std.parseInt(splitMessage[3]), false);
					cabin.health = Std.parseInt(splitMessage[4]);
					this.enemyCabins.set(id, cabin);
					this.add(cabin);
				}
			}
		}
	}
	
	private function startClientConnection()
	{
		this.attemptConnection();
		
		this.gameThread.sendMessage("");
		
		while (this.isConnected)
		{
			var threadMessage = Thread.readMessage(false);
			
			if (threadMessage == "disconnect")
			{
				this.socket.close();
				this.isConnected = false;
			}
			else
			{
				if (threadMessage != null)
					this.socket.write(threadMessage);
				this.updateConnection();
			}
		}
		
	}
	
	override public function create()
	{
		this.set_bgColor(FlxColor.WHITE); 
		
		this.dudesByFaction.set(Factions.Player, new FlxTypedGroup<DudeSprite>());
		this.dudesByFaction.set(Factions.Enemy, new FlxTypedGroup<DudeSprite>());

		this.clickAnimation = new ClickSprite();
		
		this.add(this.dudesByFaction.get(Factions.Player));
		this.add(this.dudesByFaction.get(Factions.Enemy));
		
		
		this.add(this.clickAnimation);
		
		this.persistentUpdate = true;
		
		this.socket = new Socket();
		
		this.gameThread = Thread.current();
		this.connectionThread = Thread.create(this.startClientConnection);
		
		
		Thread.readMessage(true);
		
		this.connectionThread.sendMessage("requestcabins;requestdudes;");
	
		
		FlxG.console.addCommand(["goto"], function (x, y, other:Array<Dynamic>) { FlxG.camera.scroll.x = Std.parseFloat(x); FlxG.camera.scroll.y = Std.parseFloat(y);}, "test", "test2", 2, 3);
		
		super.create();
	}
	
	override public function update()
	{
		
		super.update();
		
		if (FlxG.keys.justPressed.N)
		{
			FlxG.camera.scroll.set(this.playerCabin.x-FlxG.width/2, this.playerCabin.y-FlxG.height/2);
		}
		
		
		
		//sort and collide the "dudes".
		
		this.dudesByFaction.get(Factions.Player).sort(FlxSort.byY, FlxSort.ASCENDING);
		
		FlxG.collide(this.playerCabin, this.dudesByFaction.get(Factions.Player));
		FlxG.collide(this.dudesByFaction.get(Factions.Player), this.dudesByFaction.get(Factions.Player));
		FlxG.collide(this.dudesByFaction.get(Factions.Player), this.dudesByFaction.get(Factions.Enemy));
		
		
		//Play the click animation, and set the movement target for the dudes.
		
		if (FlxG.mouse.justReleasedRight)
		{
			this.clickAnimation.playAt(FlxG.mouse.getWorldPosition().x, FlxG.mouse.getWorldPosition().y);
			
			var averageX:Float = 0;
			var averageY:Float = 0;
			
			for (dude in this.selectedDudes)
			{
				averageX += dude.getMidpoint().x / this.selectedDudes.length;
				averageY += dude.getMidpoint().y / this.selectedDudes.length;
			}
			
			for (dude in this.selectedDudes)
			{
				var targetX = dude.getMidpoint().x + (FlxG.mouse.getWorldPosition().x - averageX);
				var targetY = dude.getMidpoint().y + (FlxG.mouse.getWorldPosition().y - averageY);
				
				this.connectionThread.sendMessage("settarget " + dude.ID + " " + targetX + " " + targetY + " ;");
				
				dude.setTargetPosition(targetX, targetY);
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
		if (this.subState == null)
			FlxG.camera.zoom = Math.max(1, Math.min(FlxG.camera.zoom + FlxG.mouse.wheel / 10, 2));
		
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
			if (sprite.isOnScreen())
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
			
			}
		});
		
		this.dudesByFaction.get(Factions.Enemy).forEachAlive(function (sprite:DudeSprite)
		{
			if (sprite.isOnScreen())
			{
				var boundingBox = new FlxRect(sprite.getMidpoint().x - sprite.attackRange, sprite.getMidpoint().y - sprite.attackRange, sprite.attackRange * 2, sprite.attackRange * 2);
			
				var targetsInRange:Array<DudeSprite> = [];
			
				this.dudesByFaction.get(Factions.Player).forEachAlive(function (enemySprite:DudeSprite)
				{
					if (boundingBox.containsFlxPoint(enemySprite.getMidpoint()))
					{
						targetsInRange.push(enemySprite);
					}
				});
			
				sprite.targetsInProximity(targetsInRange);
			
			}
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
	
	override public function destroy()
	{
		if (this.connectionThread != null)
			this.connectionThread.sendMessage("disconnect");
	}
	
	
}