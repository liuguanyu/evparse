package com.qiyi.player.core.model.impls {
	import com.qiyi.player.base.p2p.ISegment;
	import com.qiyi.player.core.IDestroy;
	import com.qiyi.player.core.player.coreplayer.ICorePlayer;
	
	public class Segment extends Object implements ISegment, IDestroy {
		
		public function Segment(param1:ICorePlayer, param2:String, param3:int, param4:Number, param5:Number, param6:String, param7:Number, param8:Number) {
			var _loc9_:Array = null;
			var _loc10_:String = null;
			var _loc11_:String = null;
			super();
			this._holder = param1;
			this._vid = param2;
			this._index = param3;
			this._startTime = param4;
			this._startPosition = param5;
			this._url = param6;
			if(!(this._url == "") && !(this._url == null)) {
				if((this._holder) && (!(this._holder.runtimeData.cacheServerIP == "")) && !(this._holder.runtimeData.cacheServerIP == null)) {
					_loc10_ = "http://" + this._holder.runtimeData.cacheServerIP + "/";
					this._url = this._url.replace(new RegExp("http:\\/\\/(\\w|\\.)*\\/"),_loc10_);
				}
				_loc9_ = this._url.split("/");
				if((_loc9_) && _loc9_.length > 0) {
					_loc11_ = _loc9_[_loc9_.length - 1];
					_loc9_ = _loc11_.split(".");
					if((_loc9_) && _loc9_.length > 0) {
						this._rid = _loc9_[0];
					}
				}
			}
			this._totalBytes = param7;
			this._totalTime = param8;
			this._endTime = this._startTime + this._totalTime;
		}
		
		private var _vid:String;
		
		private var _rid:String;
		
		private var _index:int;
		
		private var _keyframes:Vector.<Keyframe>;
		
		private var _firstKeyframe:Keyframe;
		
		private var _url:String;
		
		private var _startTime:Number;
		
		private var _startPosition:Number;
		
		private var _endTime:Number;
		
		private var _totalTime:Number;
		
		private var _totalBytes:Number;
		
		private var _currentKeyframeIndex:int = 0;
		
		private var _keyframeInited:Boolean = false;
		
		private var _keyframeAdjusted:Boolean = false;
		
		private var _holder:ICorePlayer;
		
		public function get vid() : String {
			return this._vid;
		}
		
		public function get currentKeyframe() : Keyframe {
			if(this._keyframes) {
				return this._keyframes[this._currentKeyframeIndex];
			}
			return null;
		}
		
		public function get keyframeInited() : Boolean {
			return this._keyframeInited;
		}
		
		public function get keyframeAdjusted() : Boolean {
			return this._keyframeAdjusted;
		}
		
		public function get startPosition() : Number {
			return this._startPosition;
		}
		
		public function get index() : int {
			return this._index;
		}
		
		public function get keyframes() : Vector.<Keyframe> {
			return this._keyframes;
		}
		
		public function get firstKeyframe() : Keyframe {
			return this._firstKeyframe;
		}
		
		public function get url() : String {
			return this._url;
		}
		
		public function get rid() : String {
			return this._rid;
		}
		
		public function get totalTime() : Number {
			return this._totalTime;
		}
		
		public function get startTime() : Number {
			return this._startTime;
		}
		
		public function get endTime() : Number {
			return this._endTime;
		}
		
		public function get totalBytes() : Number {
			return this._totalBytes;
		}
		
		public function getCaptureKeyFrames(param1:Number) : Vector.<Keyframe> {
			var _loc3_:Keyframe = null;
			var _loc4_:Keyframe = null;
			var _loc5_:* = 0;
			var _loc6_:* = 0;
			var _loc2_:Vector.<Keyframe> = new Vector.<Keyframe>();
			if(this._keyframes) {
				_loc3_ = null;
				_loc4_ = null;
				_loc5_ = this._keyframes.length;
				_loc6_ = 1;
				while(_loc6_ < _loc5_) {
					_loc4_ = this._keyframes[_loc6_];
					if(_loc4_.time >= param1) {
						_loc2_.push(this._keyframes[_loc6_ - 1]);
						_loc2_.push(this._keyframes[_loc6_]);
						break;
					}
					if(_loc6_ == _loc5_ - 1) {
						_loc2_.push(this._keyframes[_loc6_]);
						break;
					}
					_loc6_++;
				}
			}
			return _loc2_;
		}
		
		public function setKeyframesByXML(param1:XML, param2:Boolean) : void {
			var keyframe:Keyframe = null;
			var times:XMLList = null;
			var pos:XMLList = null;
			var i:int = 0;
			var n:int = 0;
			var var_32:XML = param1;
			var var_33:Boolean = param2;
			if(var_32 == null || (this._keyframes)) {
				return;
			}
			try {
				times = var_32.times.value;
				pos = var_32.filepositions.value;
				this._keyframes = new Vector.<Keyframe>(times.length());
				i = 1;
				n = times.length();
				while(i < n) {
					keyframe = new Keyframe();
					keyframe.index = Number(times[i].@id) - 1;
					if(var_33) {
						keyframe.position = Number(pos[i].toString());
						keyframe.time = Number(times[i].toString()) * 1000;
						if(i == 1) {
							this._startTime = keyframe.time;
							this._endTime = this._startTime + this._totalTime;
						}
						keyframe.segmentTime = keyframe.time - this._startTime;
						if(keyframe.segmentTime < 0) {
							keyframe.segmentTime = 0;
						}
					} else {
						keyframe.position = Number(pos[i].toString()) + 30;
						keyframe.segmentTime = Number(times[i].toString()) * 1000;
						keyframe.time = keyframe.segmentTime + this._startTime;
					}
					if(i != 1) {
						this._keyframes[i - 1].lenTime = keyframe.segmentTime - this._keyframes[i - 1].segmentTime;
						this._keyframes[i - 1].lenPos = keyframe.position - this._keyframes[i - 1].position;
					}
					this._keyframes[i] = keyframe;
					i++;
				}
				this._keyframes[this._keyframes.length - 1].lenTime = this.totalTime - this._keyframes[this._keyframes.length - 1].segmentTime;
				this._keyframes[this._keyframes.length - 1].lenPos = this.totalBytes - this._keyframes[this._keyframes.length - 1].position;
				this._keyframes.shift();
				this._firstKeyframe = new Keyframe();
				this._firstKeyframe.segmentTime = 0;
				if(var_33) {
					this._firstKeyframe.position = Number(pos[0].toString());
				} else {
					this._firstKeyframe.position = Number(pos[0].toString()) + 30;
				}
				this._keyframeAdjusted = var_33;
				this._keyframeInited = true;
			}
			catch(e:Error) {
			}
		}
		
		public function setKeyframesByObject(param1:Object) : void {
			var keyframe:Keyframe = null;
			var times:Array = null;
			var pos:Array = null;
			var i:int = 0;
			var n:int = 0;
			var var_32:Object = param1;
			if((this._keyframes) || (var_32 == null) || var_32.keyframes == null) {
				return;
			}
			try {
				times = var_32.keyframes.times;
				pos = var_32.keyframes.filepositions;
				if((times && pos) && (times.length > 0) && pos.length > 0) {
					if(this._index == 0) {
						this._keyframeAdjusted = true;
					} else if(int(Number(times[1]) * 1000) == 0) {
						this._keyframeAdjusted = false;
					} else {
						this._keyframeAdjusted = true;
					}
					
					this._keyframes = new Vector.<Keyframe>(times.length);
					i = 1;
					n = times.length;
					while(i < n) {
						keyframe = new Keyframe();
						keyframe.index = i - 1;
						keyframe.position = Number(pos[i]);
						if(this._keyframeAdjusted) {
							keyframe.time = Number(times[i]) * 1000;
							if(i == 1) {
								this._startTime = keyframe.time;
								this._endTime = this._startTime + this._totalTime;
							}
							keyframe.segmentTime = keyframe.time - this._startTime;
							if(keyframe.segmentTime < 0) {
								keyframe.segmentTime = 0;
							}
						} else {
							keyframe.segmentTime = Number(times[i]) * 1000;
							keyframe.time = keyframe.segmentTime + this._startTime;
						}
						if(i != 1) {
							this._keyframes[i - 1].lenTime = keyframe.segmentTime - this._keyframes[i - 1].segmentTime;
							this._keyframes[i - 1].lenPos = keyframe.position - this._keyframes[i - 1].position;
						}
						this._keyframes[i] = keyframe;
						i++;
					}
					this._keyframes[this._keyframes.length - 1].lenTime = this.totalTime - this._keyframes[this._keyframes.length - 1].segmentTime;
					this._keyframes[this._keyframes.length - 1].lenPos = this.totalBytes - this._keyframes[this._keyframes.length - 1].position;
					this._keyframes.shift();
					this._firstKeyframe = new Keyframe();
					this._firstKeyframe.segmentTime = 0;
					this._firstKeyframe.position = Number(pos[0]);
				}
				this._keyframeInited = true;
			}
			catch(e:Error) {
			}
		}
		
		public function getKeyframeByTime(param1:Number) : Keyframe {
			var _loc2_:* = 0;
			var _loc3_:* = 0;
			if(this._keyframes == null) {
				return null;
			}
			if(param1 < this._startTime) {
				return this._keyframes[0];
			}
			if(param1 <= this._endTime) {
				_loc2_ = 1;
				_loc3_ = this._keyframes.length;
				while(_loc2_ < _loc3_) {
					if(this._keyframes[_loc2_].time >= param1) {
						return Math.abs(this._keyframes[_loc2_].time - param1) > Math.abs(this._keyframes[_loc2_ - 1].time - param1)?this._keyframes[_loc2_ - 1]:this._keyframes[_loc2_];
					}
					_loc2_++;
				}
			}
			return this._keyframes[this._keyframes.length - 1];
		}
		
		public function getKeyframeByPosition(param1:Number) : Keyframe {
			var _loc2_:* = 0;
			var _loc3_:* = 0;
			if(this._keyframes == null) {
				return null;
			}
			if(param1 >= 0 && param1 < this.totalBytes) {
				_loc2_ = 1;
				_loc3_ = this._keyframes.length;
				while(_loc2_ < _loc3_) {
					if(this._keyframes[_loc2_].position == param1) {
						return this._keyframes[_loc2_];
					}
					if(this._keyframes[_loc2_].position > param1) {
						return this._keyframes[_loc2_ - 1];
					}
					_loc2_++;
				}
			}
			return this._keyframes[this._keyframes.length - 1];
		}
		
		public function seek(param1:Number) : void {
			var _loc2_:Keyframe = this.getKeyframeByTime(param1);
			if(_loc2_) {
				this._currentKeyframeIndex = _loc2_.index;
				if((this._holder) && (this._holder.runtimeData.originalEndTime > 0) && _loc2_.time > this._holder.runtimeData.originalEndTime) {
					this._currentKeyframeIndex--;
				}
				_loc2_ = this._keyframes[this._currentKeyframeIndex];
				if(this._totalBytes - _loc2_.position < 10000) {
					this._currentKeyframeIndex--;
				}
			}
		}
		
		public function destroy() : void {
		}
	}
}
