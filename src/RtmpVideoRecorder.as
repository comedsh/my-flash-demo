package {
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.events.NetStatusEvent;
	import flash.media.Camera;
	import flash.media.Microphone;
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import utils.SimpleButtonRectangle;
	
	public class RtmpVideoRecorder extends Sprite	{
		
		private var nc:NetConnection;
		
		private var ns:NetStream;
		
		private var liveUrl:String = "rtmp://localhost/my-first-red5-example";
		
		private var video:Video;
		
		private var cam:Camera;
		
		private var mic:Microphone;
		
		// the filename storing the video recording.
		
		private var defaultFilename:String = "record";
		
		private var btnPublish:SimpleButtonRectangle = new SimpleButtonRectangle("开始录制", 60, 20);
		
		private var btnStop:SimpleButtonRectangle = new SimpleButtonRectangle("停止录制", 60, 20);
		
		private var btnPlay:SimpleButtonRectangle = new SimpleButtonRectangle("视频回放", 60, 20);
		
		public function RtmpVideoRecorder():void{
			
			btnPublish.addEventListener(MouseEvent.CLICK, onPublishClick);
			
			btnStop.addEventListener(MouseEvent.CLICK, onStopHandler);
			
			btnPlay.addEventListener(MouseEvent.CLICK, onPlayHandler);
			
			video = new Video();
			
			cam = Camera.getCamera();
			
			cam.setMode(640, 480, 15);  
			
			cam.setKeyFrameInterval(25);
			
			cam.setQuality(200000, 75); 
			
			mic = Microphone.getMicrophone();
			
			if( cam == null ){
				
				trace("没检测到视频摄像头");
				
			}else{
				
				video.attachCamera( cam );
				
			}
			
			video.x=0;
			video.y=0;
			
			btnPublish.x=0;
			btnPublish.y=250;
			
			btnStop.x=80;
			btnStop.y=250;
			
			btnPlay.x=160;
			btnPlay.y=250;
			
			addChild( video );
			
			addChild( btnPublish );
			
			addChild( btnStop );
			
			addChild( btnPlay );
			
		}
		
		private function onStatusHandler(evt:NetStatusEvent):void{
			
			trace(evt.info.code);
			
			if(evt.info.code=="NetConnection.Connect.Success") {
				
				ns=new NetStream(nc);
				
				ns.addEventListener(NetStatusEvent.NET_STATUS, onStatusHandler);
				
				ns.client=new CustomClient();
				
			}
			
		}
		
		private function onPublishClick(evt:MouseEvent):void{
			
			nc=new NetConnection();
			
			nc.addEventListener(NetStatusEvent.NET_STATUS,onPublishStatusHandler);
			
			nc.connect( liveUrl );
			
		}
		
		private function onPublishStatusHandler(evt:NetStatusEvent):void
		{
			if(evt.info.code=="NetConnection.Connect.Success")
			{
				ns=new NetStream(nc);
				
				ns.addEventListener(NetStatusEvent.NET_STATUS,onPublishStatusHandler);
				
				ns.client=new CustomClient();
				
				ns.attachCamera(cam);
				
				ns.attachAudio(mic);
				
				ns.publish( defaultFilename, "record");
				
			}
		}
		
		private function onStopHandler(evt:MouseEvent):void{
			nc.close();
		}
		
		private function onPlayHandler(evt:MouseEvent):void{
			
			nc=new NetConnection();
			
			nc.addEventListener(NetStatusEvent.NET_STATUS,onPlayStatusHandler);
			
			nc.connect( liveUrl );
			
		}
		
		private function onPlayStatusHandler(evt:NetStatusEvent):void{
			
			if(evt.info.code=="NetConnection.Connect.Success")
			{
				ns=new NetStream(nc);
				
				ns.addEventListener(NetStatusEvent.NET_STATUS,onPlayStatusHandler);
				
				ns.client = new CustomClient();
				
				video = new Video();
				
				video.attachNetStream(ns);
				
				ns.play( defaultFilename, 0 );
				
				addChild(video);
				
			}
		}
	}
}

class CustomClient { 
	
	public function onMetaData(info:Object):void { 
	} 
	
	public function onCuePoint(info:Object):void{ 
	} 
} 