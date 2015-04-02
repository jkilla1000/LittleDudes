package random.littledudes.server;

import haxe.io.Bytes;
import haxe.Serializer;
import neko.Lib;
import neko.vm.Thread;
import sys.net.Host;
import sys.net.Socket;
import neko.net.ThreadServer;

/**
 * ...
 * @author Jack Bass
 */

typedef Message = {
  var str : String;
}

/*
 *	Message structure.
 * 
 * 	playercabin x y health;
 * 	enemycabin id x y health;
 *  damagecabin id damage;
 *  damageplayercabin damage;
 *  newdude id x y health speed damage range attkTime;
 *  newenemydude id x y health speed damage range attkTime;
 *  damagedude id damage;
 *  settarget id tx ty
 *  settarget [ids]
 *  killcabin id;
 *  killdude id;
 * 
 * 
 * 
*/

 
class Server extends ThreadServer<NetworkedClient, Message>
{	
	private static var nl = "\n";
	
	var clients : Array<NetworkedClient> = new Array<NetworkedClient>();
	
	var totalPastClients = 0;
	
	function registerClientDude(c : NetworkedClient, d : NetworkedDude)
	{
		Lib.println(c.getIdentifier() + " Registered a dude.");
		
		for (client in clients)
		{
			if (client.id == c.id)
			{
				this.sendData(client.socket, ("new" + d.toString() + nl));
			}
			else
			{
				this.sendData(client.socket, ("newenemy" + d.toString() + nl));
			}
		}
	}
	
	override function clientConnected( s : Socket) : NetworkedClient
	{
		var client = new NetworkedClient(Std.int((Math.random() * 5000) - 2500), Std.int((Math.random() * 5000 - 2500)));
		client.socket = s;
		client.socket.setFastSend(true);
		client.ip = s.peer().host.ip;
		
		client.id = totalPastClients;
		
		for (c in this.clients)
		{
			this.sendData(c.socket, "enemycabin " + client.id + " " + client.cabinX + " " + client.cabinY + " " + client.cabinHealth + ";" + nl);
		}
		
		this.clients.push(client);
		
		Lib.println("Client " + client.ip + " connected.");
		
		totalPastClients++;
		
		return client;
	}
	
	override function readClientMessage(c : NetworkedClient, buf:Bytes, pos:Int, len:Int)
	{
		  // find out if there's a full message, and if so, how long it is.
		var complete = false;
		var cpos = pos;
		while (cpos < (pos+len) && !complete)
		{
		 //check for a period/full stop (i.e.:  "." ) to signify a complete message 
		  complete = (buf.get(cpos) == 59);
		  cpos++;
		}

		// no full message
		if( !complete ) return null;

		// got a full message, return it
		var msg:String = buf.getString(pos, cpos-pos);
		return {msg: {str: msg}, bytes: cpos-pos};
	}
	
	override function clientMessage(c : NetworkedClient, msg : Message)
	{
		Lib.println(c.getIdentifier() + msg.str);
		
		for (message in msg.str.split(";"))
		{
			if (StringTools.startsWith(message, "damagedude"))
			{
				var splitMessage = message.split(" ");
				
				var dude = NetworkedDude.dudesById.get(Std.parseInt(splitMessage[1]));
				
				dude.health -= Std.parseInt(splitMessage[2]);
				
				for (client in this.clients)
				{
					this.sendData(client.socket, message + nl);
					trace(message);
				}
				
			}
			else if (StringTools.startsWith(message, "setname"))
			{
				c.name = message.split(" ")[1];
			}
			else if (StringTools.startsWith(message, "newdude"))
			{
				var splitMessage = message.split(" ");
				
				var dude = new NetworkedDude(Std.parseInt(splitMessage[1]), Std.parseInt(splitMessage[2]));
				dude.health = Std.parseInt(splitMessage[3]);
				dude.movementSpeed = Std.parseInt(splitMessage[4]);
				dude.damage = Std.parseInt(splitMessage[5]);
				dude.attackRange = Std.parseInt(splitMessage[6]);
				dude.attackTime = Std.parseFloat(splitMessage[7]);
				
				c.dudes.push(dude);
				
				registerClientDude(c, dude);
			}
			else if (StringTools.startsWith(message, "requestcabins"))
			{
				var message = "";
				
				Lib.println(c.getIdentifier() + " Requested cabin info");
				
				for (client in this.clients)
				{
					if (c.id == client.id)
					{
						message += "playercabin " + client.id + " " + client.cabinX + " " + client.cabinY + " " + client.cabinHealth + ";";
					}
					else
					{
						message += "enemycabin " + client.id + " " + client.cabinX + " " + client.cabinY + " " + client.cabinHealth + ";";
					}
				}
				
				message += nl;
				
				this.sendData(c.socket, message);
			}
			else if (StringTools.startsWith(message, "requestdudes"))
			{
				Lib.println(c.getIdentifier() + " Requested dude info");
				
				var dudeInfo = "";
				
				for (client in clients)
				{
					if (client.id != c.id)
					{
						for (dude in client.dudes)
						{
							dudeInfo += "newenemy" + dude.toString();
						}
					}
				}
				
				dudeInfo += nl;
				
				this.sendData(c.socket, dudeInfo);
			}
			else if (StringTools.startsWith(message, "settarget"))
			{
				var splitMessage = message.split(" ");
				var dude = NetworkedDude.dudesById.get(Std.parseInt(splitMessage[1]));
				
				dude.x = Std.parseInt(splitMessage[2]);
				dude.y = Std.parseInt(splitMessage[3]);
				
				for (client in clients)
				{
					if (client.id != c.id)
					{
						this.sendData(client.socket, message + nl);
					}
				}
			}
		}
	}
	
	override function onError(e : Dynamic, stack)
	{
		Lib.println(e);
	}
	
	override function clientDisconnected( c : NetworkedClient)
	{
		this.clients.remove(c);
		
		var message =  "killcabin " + c.id + " ;";
		
		for (dude in c.dudes)
		{
			message += "killdude " + dude.id + ";";
		}
		
		message += nl;
		
		for (client in clients)
		{
			this.sendData(client.socket, message);
		}
		Lib.println("Client " + c.getIdentifier() + " disconnected.");
	}
	
	override function update()
	{
		for (client in this.clients)
		{
			this.sendData(client.socket, "tick" + nl);
		}
	}
	
	static function main() 
	{	
		var server = new Server();
		server.listen = 2;
		trace(Host.localhost());
		server.run("192.168.1.176", 6728);
	}
}