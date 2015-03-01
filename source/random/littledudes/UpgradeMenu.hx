package random.littledudes;

import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.text.FlxTextField;
import flixel.util.FlxColor;
import flixel.ui.FlxButton;
import flixel.FlxG;
import openfl.Assets;

import random.littledudes.sprites.Cabin;

/**
 * ...
 * @author Jack Bass
 */
class UpgradeMenu extends FlxSubState
{	
	
	var toggleTroopsText:FlxTextField;
	var troopHealthText:FlxTextField;
	var troopRangeText:FlxTextField;
	var troopDamageText:FlxTextField;
	var troopSpeedText:FlxTextField;
	var troopTimeText:FlxTextField;
	
	
	public function new() 
	{
		super(FlxColor.TRANSPARENT);
		
		FlxG.camera.zoom = 1;
		
		var guiBacking:FlxSprite = new FlxSprite();
		
		var closeButton:FlxButton = new FlxButton(0, 0, "Close", function () { FlxG.state.closeSubState(); } );
		
		var toggleTroopsButton:FlxButton = new FlxButton(0, 0, "Toggle", function () { Cabin.isSpawning = !Cabin.isSpawning; } );
		
		troopHealthText = new FlxTextField(0, 0, 200, "Troop Health: " + Cabin.dudeHealth, 12);
		
		troopRangeText = new FlxTextField(0, 0, 200, "Troop Range: " + Cabin.dudeAttackRange, 12);
		
		troopDamageText = new FlxTextField(0, 0, 200, "Troop Damage: " + Cabin.dudeAttackDamage, 12);
		
		troopSpeedText = new FlxTextField(0, 0, 200, "Troop Speed: " + Cabin.dudeMovementSpeed, 12);
		
		troopTimeText = new FlxTextField(0, 0, 200, "Troop Spawn Time: " + Cabin.spawnTime+"Seconds", 12);
		
		toggleTroopsText = new FlxTextField(0, 0, 200, "Spawning Troops: " + Cabin.isSpawning, 12);
		
		var troopHealthButton = new FlxButton(0, 0, "$" + 100 * Reg.healthUpgradeLevel, function () { Reg.healthUpgradeLevel++; Cabin.dudeHealth += 5; } );
		
		var troopRangeButton = new FlxButton(0, 0, "$" + 50 * Reg.rangeUpgradeLevel, function () { Reg.rangeUpgradeLevel++; Cabin.dudeAttackRange += 5; } );
		
		var troopDamageButton = new FlxButton(0, 0, "$" + 150 * Reg.damageUpgradeLevel, function () { Reg.damageUpgradeLevel++; Cabin.dudeAttackDamage += 10; } );
		
		var troopSpeedButton = new FlxButton(0, 0, "$" + 100 * Reg.speedUpgradeLevel, function () { Reg.speedUpgradeLevel++; Cabin.dudeMovementSpeed += 10; } );
		
		var troopTimeButton = new FlxButton(0, 0, (Reg.timeUpgradeLevel == 4)? "Maxed Out":("$" + 150 * Reg.timeUpgradeLevel), function () { if (Reg.timeUpgradeLevel != 4) { Reg.timeUpgradeLevel++; Cabin.spawnTime -= 1;}} ); 
		
		toggleTroopsButton.setPosition(300, 100);
		
		troopHealthButton.setPosition(300, 150);
		
		troopDamageButton.setPosition(300, 200);
		
		troopSpeedButton.setPosition(300, 250);
		
		troopTimeButton.setPosition(300, 350);
		
		troopRangeButton.setPosition(300, 300);
		
		toggleTroopsText.scrollFactor.x = 0;
		toggleTroopsText.scrollFactor.y = 0;
		
		toggleTroopsText.setPosition(75, 100);
		
		troopHealthText.scrollFactor.x = 0;
		troopHealthText.scrollFactor.y = 0;
		
		troopHealthText.setPosition(75, 150);
		
		troopDamageText.scrollFactor.x = 0;
		troopDamageText.scrollFactor.y = 0;
		
		troopDamageText.setPosition(75, 200);
		
		troopSpeedText.scrollFactor.x = 0;
		troopSpeedText.scrollFactor.y = 0;
		
		troopSpeedText.setPosition(75, 250);
		
		troopRangeText.scrollFactor.x = 0;
		troopRangeText.scrollFactor.y = 0;
		
		troopRangeText.setPosition(75, 300);
		
		troopTimeText.scrollFactor.x = 0;
		troopTimeText.scrollFactor.y = 0;
		
		troopTimeText.setPosition(75, 350);
		
		
		
		closeButton.setPosition(400 - closeButton.width / 2, 550 - closeButton.height);
		
		guiBacking.loadGraphic(Assets.getBitmapData("assets/images/menuBackground.png"), false, 400, 300);
		
		guiBacking.scrollFactor.x = 0;
		guiBacking.scrollFactor.y = 0;
		
		guiBacking.setPosition(200, 150);
		
		guiBacking.scale.x = 2;
		guiBacking.scale.y = 2;
		
		guiBacking.visible = true;
		
		this.add(guiBacking);
		this.add(toggleTroopsText);
		this.add(toggleTroopsButton);
		this.add(troopHealthText);
		this.add(troopDamageText);
		this.add(troopSpeedText);
		this.add(troopRangeText);
		this.add(troopRangeButton);
		this.add(troopDamageButton);
		this.add(troopSpeedButton);
		this.add(troopHealthButton);
		this.add(troopTimeButton);
		this.add(closeButton);
		
		
	}
	
	override public function update()
	{
		super.update();
		
		this.toggleTroopsText.text = "Spawning Troops: " + Cabin.isSpawning;
		this.troopDamageText.text = "Troop Damage: " + Cabin.dudeAttackDamage;
		this.troopHealthText.text = "Troop Health: " + Cabin.dudeHealth;
		this.troopRangeText.text = "Troop Range: " + Cabin.dudeAttackRange;
		this.troopTimeText.text = "Troop Spawn Time: " + Cabin.spawnTime+"Seconds";
		this.troopSpeedText.text = "Troop Speed: " + Cabin.dudeMovementSpeed;
	}
	
}