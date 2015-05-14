package com.qiyi.player.core.player
{
	import com.qiyi.player.base.pub.EnumItem;
	import com.qiyi.player.core.model.def.TryWatchEnum;
	import com.qiyi.player.core.model.def.DefinitionEnum;
	
	public class RuntimeData extends Object
	{
		
		public static var VInfoDisIP:String = "";
		
		public var playerType:EnumItem = null;
		
		public var platform:EnumItem = null;
		
		public var station:EnumItem = null;
		
		public var playerUseType:EnumItem = null;
		
		public var tvid:String = "";
		
		public var vid:String = "";
		
		public var originalVid:String = "";
		
		public var albumId:String = "";
		
		public var movieIsMember:Boolean = false;
		
		public var prepareToPlayEnd:int = -1;
		
		public var prepareToSkipPoint:int = -1;
		
		public var prepareLeaveSkipPoint:int = -1;
		
		public var currentDefinition:String = "";
		
		public var preDispatchArea:String = "";
		
		public var preAverageSpeed:int = 0;
		
		public var preDefinition:String = "";
		
		public var preErrorCode:String = "";
		
		public var currentUserIP:String = "";
		
		public var currentUserArea:String = "";
		
		public var bufferEmpty:int = 0;
		
		public var movieInfo:String = "";
		
		public var key:String = "";
		
		public var CDNStatus:int = -1;
		
		public var oversea:int = -1;
		
		public var stratusIP:String = "";
		
		public var userDisInfo:Object;
		
		public var userArea:String = "";
		
		public var smallOperators:Boolean = false;
		
		public var startPlayTime:int = -1;
		
		public var dispatcherServerTime:Number = 0;
		
		public var dispatchFlashRunTime:Number = 0;
		
		public var isTryWatch:Boolean = false;
		
		public var tryWatchType:EnumItem;
		
		public var tryWatchTime:int = 0;
		
		public var QY00001:String = "";
		
		public var skipTrailer:Boolean = false;
		
		public var authentication:Object;
		
		public var authenticationError:Boolean = false;
		
		public var authenticationTipType:int = -1;
		
		public var startFromHistory:Boolean = false;
		
		public var currentSpeed:int = 0;
		
		public var currentAverageSpeed:int = 0;
		
		public var retryCount:int = 0;
		
		public var originalStartTime:int = -1;
		
		public var originalEndTime:int = -1;
		
		public var endTime:int = 0;
		
		public var errorCode:int = 0;
		
		public var errorCodeValue:Object;
		
		public var supportGPU:Boolean = true;
		
		public var isPreload:Boolean = false;
		
		public var autoDefinitionlimit:EnumItem;
		
		public var cacheServerIP:String = "";
		
		public var vrsDomain:String = "";
		
		public var communicationlId:String = "afbe8fd3d73448c9";
		
		public var tg:String = "";
		
		public var recordHistory:Boolean = true;
		
		public var useHistory:Boolean = true;
		
		public var needFilterQualityDefinition:Boolean = false;
		
		public var openSelectPlay:Boolean = false;
		
		public var collectionID:String = "";
		
		public var userEnjoyableSubType:EnumItem = null;
		
		public var userEnjoyableDurationIndex:int = -1;
		
		public var openFlashP2P:Boolean = true;
		
		public var flashP2PCoreURL:String = "";
		
		public var smallWindowMode:Boolean = false;
		
		public var ugcAuthKey:String = "";
		
		public var serverTime:uint = 0;
		
		public var serverTimeGetTimer:uint = 0;
		
		public var thdKey:String = "";
		
		public var thdToken:String = "";
		
		public function RuntimeData()
		{
			this.userDisInfo = {};
			this.tryWatchType = TryWatchEnum.NONE;
			this.authentication = {};
			this.autoDefinitionlimit = DefinitionEnum.HIGH;
			super();
		}
	}
}
