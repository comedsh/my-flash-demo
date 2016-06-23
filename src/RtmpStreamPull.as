/**
 * 最简单的基于ActionScript的RTMP播放器
 * Simplest AS3 RTMP Player
 *
 * 雷霄骅 Lei Xiaohua
 * leixiaohua1020@126.com
 * 中国传媒大学/数字电视技术
 * Communication University of China / Digital TV Technology
 * http://blog.csdn.net/leixiaohua1020
 * 
 * 本程序使用ActionScript3语言完成，播放RTMP服务器上的流媒体
 * 是最简单的基于ActionScript3的播放器。
 *
 * This software is written in Actionscript3, it plays stream
 * on RTMP server
 * It's the simplest RTMP player based on ActionScript3.
 * 
 */
package {
	
	import flash.display.Sprite;
	import flash.events.NetStatusEvent;
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	
	
	public class RtmpStreamPull extends Sprite
	{
		
		private var nc:NetConnection;
		
		private var ns:NetStream;
		
		private var video:Video;
		
		//private var url:String = "rtmp://10.211.55.8/live";
		
		private var url:String = "rtmp://127.0.0.1/my-first-red5-example";
		
		private var streamName:String = "mystream"; // LIVE
		
		// private var streamName:String = "h264_mp3"; // VOD
		
		// for fixing the error: text=Error #2095: flash.net.NetStream 无法调用回调 onMetaData, error=ReferenceError: Error #1069: 在 flash.net.NetStream 上找不到属性 onMetaData，且没有默认值
		private var customClient:Object = new Object();
		
		public function RtmpStreamPull()
		{
			
			nc = new NetConnection();
			
			nc.addEventListener( NetStatusEvent.NET_STATUS, netStatusHandler );
			
			nc.connect( url );
			
			// for fixing the error: text=Error #2095:
			customClient.onMetaData = metaDataHandler;
			
		}
		
		private function netStatusHandler(event:NetStatusEvent):void
		{
			
			trace("event.info.level: " + event.info.level + "\n", "event.info.code: " + event.info.code);
			
			switch (event.info.code)
			{
				
				case "NetConnection.Connect.Success":
					
					displayVideo( nc );
					
					break;

				case "NetStream.Play.Reset":
					
					break;				

				case "NetStream.Play.Start":
					
					break;
				
				case "NetConnection.Connect.Failed":
					
					break;
				
				case "NetConnection.Connect.Rejected":
					
					break;
				
				case "NetStream.Play.Stop":
				
					break;
				
				case "NetStream.Play.StreamNotFound":
				
					break;
				
			}
			
			
		}
		
		// play a recorded stream on the server
		private function displayVideo(nc:NetConnection):void {
			
			trace("display video")
			
			ns = new NetStream( nc );
			
			// 设置 buffer time 的时间为 60 秒 - 目的是为了测试 RED5 - 实现进度 6: 2016-06-11, 疑问.. 增大客户端的缓冲来避免播放卡顿的现象..
			// 注意，如果设置缓冲时间过长，本地客户端播放等待的时间也会更长.. 
			// ns.bufferTime = 10;  
			
			ns.addEventListener( NetStatusEvent.NET_STATUS, netStatusHandler );
			
			ns.client = customClient;
			
			video = new Video( 320, 240 );
			
			video.attachNetStream( ns );
			
			// -2 means live or vod
			ns.play( streamName, -2, -1, false );
			
			addChild( video );
			
		}
		
		//onMetaData回调函数的事件 
		private function metaDataHandler(infoObject:Object):void {} 
		
		// create a playlist on the server
		/*
		private function doPlaylist(nc:NetConnection):void {
		ns = new NetStream(nc);
		ns.addEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
		
		video = new Video();
		video.attachNetStream(ns);
		
		// Play the first 3 seconds of the video
		ns.play( "bikes", 0, 3, true );
		// Play from 20 seconds on
		ns.play( "bikes", 20, -1, false);
		// End on frame 5
		ns.play( "bikes", 5, 0, false );
		addChild(video);
		}
		*/
	}
}