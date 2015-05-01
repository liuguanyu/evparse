package com.qiyi.player.core.model.utils {
	import com.qiyi.player.core.IDestroy;
	import com.qiyi.player.core.player.coreplayer.CorePlayer;
	import com.qiyi.player.core.model.IMovie;
	import com.qiyi.player.core.model.impls.Segment;
	import com.qiyi.player.core.model.impls.Keyframe;
	import com.qiyi.player.core.Config;
	
	public class Capturer extends Object implements IDestroy {
		
		public function Capturer(param1:CorePlayer) {
			super();
			this._holder = param1;
		}
		
		private static const Date_Flag:int = 20101026;
		
		private var _holder:CorePlayer;
		
		public function getCaptureURL(param1:Number, param2:int) : String {
			return this.getUrl(this._holder.movie,param1,param2);
		}
		
		private function getUrl(param1:IMovie, param2:Number, param3:int) : String {
			var _loc5_:Segment = null;
			var _loc6_:Vector.<Keyframe> = null;
			var _loc7_:* = 0;
			var _loc8_:* = NaN;
			var _loc9_:* = NaN;
			var _loc10_:* = NaN;
			var _loc11_:Array = null;
			var _loc4_:* = "";
			if((param1) && (param1.ready)) {
				_loc5_ = param1.getSegmentByTime(param2);
				if(_loc5_) {
					_loc6_ = _loc5_.getCaptureKeyFrames(param2);
					_loc7_ = _loc6_.length;
					if(_loc7_ > 0) {
						_loc8_ = 0;
						_loc9_ = 0;
						_loc10_ = 0;
						if(_loc7_ == 1) {
							_loc8_ = _loc6_[0].position;
							_loc9_ = _loc5_.totalBytes;
							_loc10_ = param2 - _loc6_[0].time;
						} else if(_loc7_ == 2) {
							_loc8_ = _loc6_[0].position;
							_loc9_ = _loc6_[1].position;
							_loc10_ = param2 - _loc6_[0].time;
						}
						
						_loc4_ = _loc5_.url.replace(".f4v",".jpg");
						_loc11_ = _loc4_.split("/");
						_loc11_[2] = Config.CAPTURE_URL;
						_loc4_ = _loc11_.join("/") + "?";
						_loc4_ = _loc4_ + ("start=" + _loc8_);
						_loc4_ = _loc4_ + ("&end=" + _loc9_);
						_loc4_ = _loc4_ + ("&time=" + _loc10_);
						_loc4_ = _loc4_ + ("&mode=" + param3);
					}
				}
			}
			return _loc4_;
		}
		
		public function destroy() : void {
		}
	}
}
