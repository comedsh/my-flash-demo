/**
 * 最简单的基于ActionScript的RTMP推流器
 * Simplest AS3 RTMP Streamer
 *
 * 雷霄骅 Lei Xiaohua
 * leixiaohua1020@126.com
 * 中国传媒大学/数字电视技术
 * Communication University of China / Digital TV Technology
 * http://blog.csdn.net/leixiaohua1020
 * 
 * 本程序使用ActionScript3语言完成，推送本地摄像头的数据至RTMP流媒体服务器，
 * 是最简单的基于ActionScript3的推流器。
 *
 * This software is written in Actionscript3, it streams camera's video to
 * RTMP server.
 * It's the simplest RTMP streamer based on ActionScript3.
 * 
 */




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

	//import flash.media.H264Profile;  
	//import flash.media.H264VideoStreamSettings; 
	
	
	public class RtmpStreamPush extends Sprite
	{
		private var nc:NetConnection;
		
		private var ns:NetStream;
		
		private var ns_2:NetStream;
		
		private var video:Video;
		
		private var video_2:Video;
		
		private var cam:Camera;
		
		private var mic:Microphone;
		
		private var screen_w:int=320;
		
		private var screen_h:int=240;
		
		private var url:String = "rtmp://10.211.55.8/my-first-red5-example"
			
		private var streamName:String = "mystream";	
		
		private var liveShowBtn:SimpleButtonRectangle = new SimpleButtonRectangle("观看直播", 60, 20);
		
		public function RtmpStreamPush()
		{
			nc = new NetConnection();
			
			nc.addEventListener(NetStatusEvent.NET_STATUS, onNetStatus);
			
			nc.connect( url );
			
			liveShowBtn.addEventListener( MouseEvent.CLICK, playbackVideo );

			liveShowBtn.x = 80;
			
			liveShowBtn.y = 250;
			
			addChild( liveShowBtn );
			
		}
		
		
		private function onNetStatus(event:NetStatusEvent):void{
			
			trace( event.info.code );
			
			if(event.info.code == "NetConnection.Connect.Success"){
				
				publish();
				
				currentVideo();
				
				// playbackVideo();
			}
			
		}
		
		
		private function publish() : void{
			
			//Cam
			
			cam = Camera.getCamera();
			
			
			/**
			 * public function setMode(width:int, height:int, fps:Number, favorArea:Boolean = true):void  
			 *  width:int — The requested capture width, in pixels. The default value is 160.  
			 *  height:int — The requested capture height, in pixels. The default value is 120.  
			 *  fps:Number — The requested capture frame rate, in frames per second. The default value is 15.  
			 */
			cam.setMode(640, 480, 15);  
			
			/**
			 * public function setKeyFrameInterval(keyFrameInterval:int):void
			 * The number of video frames transmitted in full (called keyframes) instead of being interpolated by the video compression algorithm.
			 * The default value is 15, which means that every 15th frame is a keyframe. A value of 1 means that every frame is a keyframe. 
			 * The allowed values are 1 through 300. 
			 */
			cam.setKeyFrameInterval(25);
			
			/**
			 * public function setQuality(bandwidth:int, quality:int):void  
			 * bandwidth:int — Specifies the maximum amount of bandwidth that the current outgoing video feed can use, in bytes per second (bps).   
			 *    To specify that the video can use as much bandwidth as needed to maintain the value of quality, pass 0 for bandwidth.   
			 *    The default value is 16384.  
			 * quality:int — An integer that specifies the required level of picture quality, as determined by the amount of compression   
			 *     being applied to each video frame. Acceptable values range from 1 (lowest quality, maximum compression) to 100   
			 *    (highest quality, no compression). To specify that picture quality can vary as needed to avoid exceeding bandwidth,   
			 *    pass 0 for quality.  
			 */
			cam.setQuality(200000, 90); 
			
			/**
			 * public function setProfileLevel(profile:String, level:String):void
			 * Set profile and level for video encoding. 
			 * Possible values for profile are H264Profile.BASELINE and H264Profile.MAIN. Default value is H264Profile.BASELINE.
			 * Other values are ignored and results in an error.
			 * Supported levels are 1, 1b, 1.1, 1.2, 1.3, 2, 2.1, 2.2, 3, 3.1, 3.2, 4, 4.1, 4.2, 5, and 5.1.
			 * Level may be increased if required by resolution and frame rate.
			 */
			//var h264setting:H264VideoStreamSettings = new H264VideoStreamSettings();  
			// h264setting.setProfileLevel(H264Profile.MAIN, 4);   
			
			
			//Mic
			
			mic = Microphone.getMicrophone();
			
			/*
			* The encoded speech quality when using the Speex codec. Possible values are from 0 to 10. The default value is 6. 
			* Higher numbers represent higher quality but require more bandwidth, as shown in the following table. 
			* The bit rate values that are listed represent net bit rates and do not include packetization overhead. 
			* ------------------------------------------
			* Quality value | Required bit rate (kbps)
			*-------------------------------------------
			*      0        |       3.95 
			*      1        |       5.75 
			*      2        |       7.75 
			*      3        |       9.80 
			*      4        |       12.8 
			*      5        |       16.8 
			*      6        |       20.6 
			*      7        |       23.8 
			*      8        |       27.8 
			*      9        |       34.2 
			*      10       |       42.2 
			*-------------------------------------------
			*/
			mic.encodeQuality = 9;  
			
			/* The rate at which the microphone is capturing sound, in kHz. Acceptable values are 5, 8, 11, 22, and 44. The default value is 8 kHz   
			* if your sound capture device supports this value. Otherwise, the default value is the next available capture level above 8 kHz that   
			* your sound capture device supports, usually 11 kHz.  
			*
			*/
			mic.rate = 44;  
			
			
			ns = new NetStream(nc);
			//H.264 Setting
			//ns.videoStreamSettings = h264setting; 
			ns.attachCamera(cam);
			ns.attachAudio(mic);
			
			/* 
			    name 标识该视频流的名称,如果 type 值是 record，那么该视频会使用 name.flv 来保存
				type 用于指定如何发布该流的字符串。有效值是“record”、“append”、“appendWithGap”和“live”。默认值为“live”。
					如果传递“record”，则服务器将发布并录制实时数据，同时将录制的数据保存到名称与传递给 name 参数的值相匹配的新文件中。如果该文件存在，则覆盖该文件。
					如果传递“append”，则服务器将发布并录制实时数据，同时将录制的数据附加到名称与传递给 name 参数的值相匹配的文件中。如果未找到与 name 参数相匹配的文件，则创建一个文件。
					如果您传递“appendWithGap”，则会传递关于时间协调的其他信息，以帮助服务器在动态流式处理时确定正确的转换点。
					如果省略此参数或传递“live”，则服务器将发布实时数据而不进行录制。如果存在名称与传递给 name 参数的值相匹配的文件，则删除它。
			*/
			ns.publish( streamName, "live");
		}
		
		
		private function currentVideo():void {
			
			video = new Video( screen_w, screen_h );
			
			video.x = 0;
			
			video.y = 10;
			
			video.attachCamera( cam );
			
			addChild( video );
			
		}
		
		
		private function playbackVideo( Event : MouseEvent ):void{
			
			ns_2 = new NetStream( nc );
			
			ns_2.play( streamName );
			
			video_2 = new Video(screen_w, screen_h);
			
			video_2.x = screen_w + 10;
			
			video_2.y = 10;
			
			video_2.attachNetStream( ns_2 );
			
			addChild( video_2 );
			
		}
	}
}