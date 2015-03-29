package random.network;

/**
 * ...
 * @author Jack Bass
 */
class NetworkedDude
{

	public var health:Int = 100;
	
	public var movementSpeed:Int = 100;
	
	public var damage:Int = 20;
	
	public var attackRange:Int = 25;
	
	public var attackTime:Float = 0.5;
	
	public var x:Int;
	
	public var y:Int;
	
	public function new(x:Int, y:Int) 
	{
		this.x = x;
		this.y = y;
	}
	
	public function toString()
	{
		return "dude " + this.x + " " + this.y + " " + this.health + " " + this.movementSpeed + " " + this.damage + " " + this.attackRange + " " + this.attackTime + ";"; 
	}
	
}