package random.littledudes.server;

/**
 * ...
 * @author Jack Bass
 */
class NetworkedDude
{
	static var numDudes = 0;
	

	public var x:Int = 0;
	public var y:Int = 0;
	public var health:Int = 100;
	public var movementSpeed:Int = 100;
	public var damage:Int = 20;
	public var attackRange:Int = 25;
	public var attackTime:Float = 0.5;
	
	
	public var id:Int;
	
	public function new(x:Int = 0, y:Int = 0) 
	{
		this.x = x;
		this.y = y;
		this.id = numDudes;
		numDudes++;
	}
	
	
	public function toString()
	{
		return "dude " + this.id + " " + this.x + " " + this.y + " " + this.health + " " + this.movementSpeed + " " + this.damage + " " + this.attackRange + " " + this.attackTime + ";"; 
	}
}