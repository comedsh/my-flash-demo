package{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.events.NetStatusEvent;
	import flash.media.Camera;
	import flash.media.Microphone;
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import flash.net.ObjectEncoding;
	import flash.net.Responder;
	
	import utils.SimpleButtonRectangle;
	
	/**
	 * 要使用这个用例，首先要配置 my-first-red5-example 的 red5-web.xml 使用 CustomMultiThreadApplicationAdapter 
	 */
	public class RtmpCustomVideoRecorder extends Sprite{

		private var resp:Responder = new Responder(onResult); 
		
		private var _video:Video;
		
		private var _cam:Camera;
		
		//private var _mic:Microphone;
		
		private var _nc:NetConnection;
		
		private var _ns:NetStream; 		
		
		private var b_start:SimpleButtonRectangle = new SimpleButtonRectangle("开始录制", 60, 20);
		
		private var b_stop:SimpleButtonRectangle = new SimpleButtonRectangle("停止录制", 60, 20);
		
		public function RtmpCustomVideoRecorder(){

			_cam=Camera.getCamera(); 
			
			_cam.setQuality(144000, 85); 
			
			_cam.setMode(320, 240, 15); 
			
			_cam.setKeyFrameInterval(60); 
			
			_video=new Video(); 
			
			_video.attachCamera(_cam); 
			
//			_mic=Microphone.getMicrophone(); 
//			
//			if(_mic != null){   
//				
//				_mic.setSilenceLevel(0,-1);   
//				
//				_mic.gain = 80; 
//				
//				_mic.setLoopBack(true); 
//				
//			} 			
			
			b_start.addEventListener(MouseEvent.CLICK,btStart); 
			
			b_stop.addEventListener(MouseEvent.CLICK,btStop); 

			b_start.x=0;
			b_start.y=220;
			
			b_stop.x=80;
			b_stop.y=220;
			
			addChild( _video ); 

			addChild( b_start );
			
			addChild( b_stop );
			
			initConn(); 
		}
		
		private function initConn():void{ 
			
			_nc=new NetConnection(); 
			
			_nc.objectEncoding = ObjectEncoding.AMF3; 
			
			_nc.client = this; 
			
			_nc.addEventListener( NetStatusEvent.NET_STATUS , netStatus ); 
			
			_nc.connect("rtmp://localhost/my-first-red5-example/", true); 
			
		} 
		
		private function publish():void { 
			
			if(_nc.connected){ 
				
				_ns=new NetStream(_nc); 
				
				// _ns.addEventListener( NetStatusEvent.NET_STATUS , netStatus ); 
				
				_ns.attachCamera(_cam); 
				
				// _ns.attachAudio(_mic); 
				
				_ns.publish("mystream", "live"); 
				
			} 
			
		} 
		
		private function netStatus ( event : NetStatusEvent ):void{ 
			
			if ( event.info.code == "NetConnection.Connect.Success"){
				
				publish();
				
			} 
			
		} 
		
		private function onResult(obj:Object):void{ 
			; 
		} 
		
		private function btStart(Event:MouseEvent):void{ 
			
			_nc.call("startRecord", new Responder(getInfor,onState), "mystream"); 
			
		}
		
		private function getInfor(reobj:Object):void { 
			
			trace("Server returning Infor: "+reobj);
			
		}
		
		private function onState(err:Object):void { 
			
			trace("Connection result error: "+err);
			
		} 
		
		private function btStop(Event:MouseEvent):void{ 
			
			_nc.call("stopRecord",new Responder(getInfor,onState));
			
		} 
		
		
	}
	

}









