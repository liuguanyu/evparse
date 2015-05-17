package
{
	import flash.display.Sprite;
	import com.pplive.util.LogTarget;
	import com.pplive.vod.events.*;
	import com.pplive.play.*;
	import flash.events.Event;
	import com.pplive.p2p.P2PServices;
	import flash.system.Security;
	
	public class flashCoreSprite extends Sprite
	{
		
		public function flashCoreSprite()
		{
			super();
			Security.allowDomain("*");
			Security.allowInsecureDomain("*");
			addEventListener(Event.ADDED_TO_STAGE,this.onAddToStage);
		}
		
		public function getEventTypePLAY_START() : String
		{
			return PlayStatusEvent.PLAY_START;
		}
		
		public function getEventTypePLAY_FAILED() : String
		{
			return PlayStatusEvent.PLAY_FAILED;
		}
		
		public function getEventTypePLAY_COMPLETE() : String
		{
			return PlayStatusEvent.PLAY_COMPLETE;
		}
		
		public function getEventTypePLAY_SEEK_NOTIFY() : String
		{
			return PlayStatusEvent.PLAY_SEEK_NOTIFY;
		}
		
		public function getEventTypePLAY_PAUSED() : String
		{
			return PlayStatusEvent.PLAY_PAUSED;
		}
		
		public function getEventTypeBUFFER_EMPTY() : String
		{
			return PlayStatusEvent.BUFFER_EMPTY;
		}
		
		public function getEventTypeBUFFER_FULL() : String
		{
			return PlayStatusEvent.BUFFER_FULL;
		}
		
		public function getEventTypeKERNEL_DETECTED() : String
		{
			return PlayStatusEvent.KERNEL_DETECTED;
		}
		
		public function getEventTypeSWITCH_FT() : String
		{
			return PlayStatusEvent.SWITCH_FT;
		}
		
		public function getEventTypePLAY_PROGRESS() : String
		{
			return PlayProgressEvent.PLAY_PROGRESS;
		}
		
		public function getEventTypePLAY_RESULT() : String
		{
			return PlayResultEvent.PLAY_RESULT;
		}
		
		public function getEventTypeP2P_DAC_LOG() : String
		{
			return DacLogEvent.P2P_DAC_LOG;
		}
		
		public function getEventTypeDETECT_KERNEL_LOG() : String
		{
			return DacLogEvent.DETECT_KERNEL_LOG;
		}
		
		public function getVersion() : String
		{
			return Version.version;
		}
		
		public function createLivePlayManager() : IPlayManager
		{
			return new PlayManager();
		}
		
		public function start() : void
		{
			LogTarget.useBufferTarget(2000);
		}
		
		public function getLogStatements() : Vector.<String>
		{
			return LogTarget.statements;
		}
		
		public function createVODPlayManager(param1:String, param2:String, param3:String, param4:String, param5:uint, param6:Array, param7:Vector.<String>, param8:Boolean = false, param9:String = "", param10:String = "type=web.fpp", param11:String = "0", param12:String = null) : IPlayManager
		{
			var _loc13:PlayInfo = this.createPlayInfo(param1,param2,param3,param4,param5,param6,param7,param8,param9,param10,param11,param12);
			return new P2PPlayManager(_loc13);
		}
		
		public function createMultiResolutionVodPlayManager(param1:Vector.<Object>, param2:String = "0", param3:String = null) : IPlayManager
		{
			var _loc5:Object = null;
			var _loc4:Vector.<PlayInfo> = new Vector.<PlayInfo>();
			for each(_loc5 in param1)
			{
				_loc4.push(this.createPlayInfo(_loc5.host,_loc5.fileName,_loc5.key,_loc5.variables,_loc5.bwType,_loc5.segments,_loc5.backupHosts,_loc5.isVip,_loc5.k,_loc5.type,_loc5.ft,param3));
			}
			return new MultiSolutionPlayManager(_loc4,param2);
		}
		
		private function createPlayInfo(param1:String, param2:String, param3:String, param4:String, param5:uint, param6:Array, param7:Vector.<String>, param8:Boolean = false, param9:String = "", param10:String = "type=web.fpp", param11:String = "0", param12:String = null) : PlayInfo
		{
			var _loc16:SegmentInfo = null;
			var _loc13:Vector.<SegmentInfo> = new Vector.<SegmentInfo>();
			var _loc14:uint = 0;
			var _loc15:uint = param6.length;
			while(_loc14 < _loc15)
			{
				_loc16 = new SegmentInfo(null,param6[_loc14].duration,param6[_loc14].filesize,param6[_loc14].headlength);
				_loc13.push(_loc16);
				_loc14++;
			}
			return new PlayInfo(param1,param2,param3,param4,param5,_loc13,param7,param8,param9,param10,param11,param12);
		}
		
		private function onAddToStage(param1:Event) : void
		{
			P2PServices.start();
		}
	}
}
