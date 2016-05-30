package
{
	import flash.display.Sprite;
	import flash.net.NetConnection;
	import flash.net.Responder;

	public class NetConnectionCall extends Sprite{
		
		private var nc:NetConnection = new NetConnection();
		
		private var responder:Responder;
		
		public function NetConnectionCall(){
			
			nc.connect("rtmp://localhost/my-first-red5-example"); 
				
			nc.call("login", new Responder(result, fault) ); 			
			
		}
		
		private function result(data:String):void{
			
			trace("call success, the returned value is " + data);
			
		}
		
		private function fault(info:Object):void{
			
			trace("call failed, an error thrown");
			
		}
	}
}