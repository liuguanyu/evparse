package com.pplive.p2p.connection
{
	import com.pplive.util.SpeedMeter;
	import com.pplive.p2p.Util;
	
	public class PCStat extends Object
	{
		
		public var uploadSpeedMeter:SpeedMeter;
		
		public var downloadSpeedMeter:SpeedMeter;
		
		public var maxUploadSpeed:int;
		
		public var maxDownloadSpeed:int;
		
		public function PCStat()
		{
			this.uploadSpeedMeter = new SpeedMeter();
			this.downloadSpeedMeter = new SpeedMeter();
			super();
			this.uploadSpeedMeter.resume();
			this.downloadSpeedMeter.resume();
		}
		
		public function destroy() : void
		{
			this.uploadSpeedMeter.destory();
			this.downloadSpeedMeter.destory();
		}
		
		public function onTimer() : void
		{
			this.maxUploadSpeed = Util.max(this.maxUploadSpeed,this.uploadSpeedMeter.getRecentSpeedInKBPS(3));
			this.maxDownloadSpeed = Util.max(this.maxDownloadSpeed,this.downloadSpeedMeter.getRecentSpeedInKBPS(3));
		}
	}
}
