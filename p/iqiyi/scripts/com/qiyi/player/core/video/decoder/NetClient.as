package com.qiyi.player.core.video.decoder
{
	public class NetClient extends Object
	{
		
		private var callback:Object;
		
		public function NetClient(param1:Object)
		{
			super();
			this.callback = param1;
		}
		
		private function forward(param1:Object, param2:String) : void
		{
			var _loc4:String = null;
			param1["type"] = param2;
			var _loc3:Object = new Object();
			for(_loc4 in param1)
			{
				_loc3[_loc4] = param1[_loc4];
			}
			this.callback.onMetaData(_loc3);
		}
		
		public function close(... rest) : void
		{
			this.forward({"close":true},"close");
		}
		
		public function onBWCheck(... rest) : Number
		{
			return 0;
		}
		
		public function onBWDone(... rest) : void
		{
			if(rest.length > 0)
			{
				this.forward({"bandwidth":rest[0]},"bandwidth");
			}
		}
		
		public function onCaption(param1:String, param2:Number) : void
		{
			this.forward({
				"captions":param1,
				"speaker":param2
			},"caption");
		}
		
		public function onCaptionInfo(param1:Object) : void
		{
			this.forward(param1,"captioninfo");
		}
		
		public function onCuePoint(param1:Object) : void
		{
			this.forward(param1,"cuepoint");
		}
		
		public function onFCSubscribe(param1:Object) : void
		{
			this.forward(param1,"fcsubscribe");
		}
		
		public function onHeaderData(param1:Object) : void
		{
			var _loc5:String = null;
			var _loc6:String = null;
			var _loc2:Object = new Object();
			var _loc3:* = "-";
			var _loc4:* = "_";
			for(_loc5 in param1)
			{
				_loc6 = _loc5.replace("-","_");
				_loc2[_loc6] = param1[_loc5];
			}
			this.forward(_loc2,"headerdata");
		}
		
		public function onID3(... rest) : void
		{
			this.forward(rest[0],"id3");
		}
		
		public function onImageData(param1:Object) : void
		{
			this.forward(param1,"imagedata");
		}
		
		public function onLastSecond(param1:Object) : void
		{
			this.forward(param1,"lastsecond");
		}
		
		public function onMetaData(param1:Object) : void
		{
			this.forward(param1,"metadata");
		}
		
		public function onPlayStatus(param1:Object) : void
		{
			if(param1.code == "NetStream.Play.Complete")
			{
				this.forward(param1,"complete");
			}
			else
			{
				this.forward(param1,"playstatus");
			}
		}
		
		public function onSDES(... rest) : void
		{
			this.forward(rest[0],"sdes");
		}
		
		public function onXMPData(... rest) : void
		{
			this.forward(rest[0],"xmp");
		}
		
		public function RtmpSampleAccess(... rest) : void
		{
			this.forward(rest[0],"rtmpsampleaccess");
		}
		
		public function onTextData(param1:Object) : void
		{
			this.forward(param1,"textdata");
		}
	}
}
