package random.littledudes.server;
import sys.net.Socket;

/**
 * ...
 * @author Jack Bass
 */
class NetworkedClient
{

	public var cabinX:Int;
	public var cabinY:Int;
	public var cabinHealth:Int;
	
	public var name:String = "noname";
	public var ip:Int;
	public var socket:Socket;
	
	public var id:Int;
	
	public var dudes:Array<NetworkedDude> = new Array<NetworkedDude>();
	
	public function new(cabinX:Int, cabinY:Int, cabinHealth:Int = 10000)
	{
		this.cabinX = cabinX;
		this.cabinY = cabinY;
		this.cabinHealth = cabinHealth;
	}
	
	public function getIdentifier() : String
	{
		return "[" + this.ip + "/" + this.name + "]: ";
	}
	
	public function toString() : String
	{
		return "cabin " + cabinX + " " + cabinY + " " + cabinHealth + "\n";
	}
	
}