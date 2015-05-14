package com.qiyi.player.core.model.utils
{
	import com.qiyi.player.core.IDestroy;
	import com.qiyi.player.core.player.coreplayer.CorePlayer;
	import com.qiyi.player.core.model.IMovie;
	import com.qiyi.player.core.model.impls.Segment;
	import com.qiyi.player.core.model.impls.Keyframe;
	import com.qiyi.player.core.Config;
	
	public class Capturer extends Object implements IDestroy
	{
		
		private static const Date_Flag:int = 20101026;
		
		private var _holder:CorePlayer;
		
		public function Capturer(param1:CorePlayer)
		{
			super();
			this._holder = param1;
		}
		
		public function getCaptureURL(param1:Number, param2:int) : String
		{
			return this.getUrl(this._holder.movie,param1,param2);
		}
		
		private function getUrl(param1:IMovie, param2:Number, param3:int) : String
		{
			var _loc5:Segment = null;
			var _loc6:Vector.<Keyframe> = null;
			var _loc7:* = 0;
			var _loc8:* = NaN;
			var _loc9:* = NaN;
			var _loc10:* = NaN;
			var _loc11:Array = null;
			var _loc4:* = "";
			if((param1) && (param1.ready))
			{
				_loc5 = param1.getSegmentByTime(param2);
				if(_loc5)
				{
					_loc6 = _loc5.getCaptureKeyFrames(param2);
					_loc7 = _loc6.length;
					if(_loc7 > 0)
					{
						_loc8 = 0;
						_loc9 = 0;
						_loc10 = 0;
						if(_loc7 == 1)
						{
							_loc8 = _loc6[0].position;
							_loc9 = _loc5.totalBytes;
							_loc10 = param2 - _loc6[0].time;
						}
						else if(_loc7 == 2)
						{
							_loc8 = _loc6[0].position;
							_loc9 = _loc6[1].position;
							_loc10 = param2 - _loc6[0].time;
						}
						
						_loc4 = _loc5.url.replace(".f4v",".jpg");
						_loc11 = _loc4.split("/");
						_loc11[2] = Config.CAPTURE_URL;
						_loc4 = _loc11.join("/") + "?";
						_loc4 = _loc4 + ("start=" + _loc8);
						_loc4 = _loc4 + ("&end=" + _loc9);
						_loc4 = _loc4 + ("&time=" + _loc10);
						_loc4 = _loc4 + ("&mode=" + param3);
					}
				}
			}
			return _loc4;
		}
		
		public function destroy() : void
		{
		}
	}
}
