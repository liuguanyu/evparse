package com.qiyi.player.core.video.engine.dm.agents {
	import flash.events.EventDispatcher;
	import com.qiyi.player.core.IDestroy;
	import com.qiyi.player.core.player.coreplayer.ICorePlayer;
	import com.qiyi.player.core.video.engine.dm.provider.Provider;
	import com.qiyi.player.core.video.render.IRender;
	import com.qiyi.player.core.model.IMovie;
	import flash.utils.Timer;
	import com.qiyi.player.base.pub.EnumItem;
	import com.qiyi.player.base.logging.ILogger;
	import com.qiyi.player.core.video.events.RenderEvent;
	import com.qiyi.player.core.video.events.ProviderEvent;
	import com.qiyi.player.core.player.def.PlayerUseTypeEnum;
	import flash.utils.setTimeout;
	import flash.events.TimerEvent;
	import flash.events.Event;
	import flash.utils.clearTimeout;
	import com.qiyi.player.core.model.impls.pub.Settings;
	import com.qiyi.player.core.model.def.DefinitionEnum;
	import flash.geom.Rectangle;
	import com.qiyi.player.core.video.events.RateAgentEvent;
	import com.qiyi.player.base.logging.Log;
	
	public class AutoAdjustRateAgent extends EventDispatcher implements IDestroy {
		
		public function AutoAdjustRateAgent(param1:ICorePlayer) {
			this._log = Log.getLogger("com.qiyi.player.core.video.engine.dm.agents.AutoAdjustRateAgent");
			super();
			this._holder = param1;
			this._isStart = false;
			this._curAutoCount = 0;
			this._timeout = 0;
			this._timer = new Timer(10000);
			this._timer.addEventListener(TimerEvent.TIMER,this.onTimerHandler);
		}
		
		private static const MAX_AUTO_COUNT:int = 5;
		
		private static const REASON_OPEN:int = 1;
		
		private static const REASON_VIDEO_RESIZED:int = 2;
		
		private static const REASON_TIMER_TEST:int = 3;
		
		private static const REASON_WILL_LOAD:int = 4;
		
		private var _holder:ICorePlayer;
		
		private var _provider:Provider;
		
		private var _render:IRender;
		
		private var _movie:IMovie;
		
		private var _isStart:Boolean;
		
		private var _timer:Timer;
		
		private var _timeout:uint;
		
		private var _curAutoCount:int;
		
		private var _detectedRate:EnumItem;
		
		private var _log:ILogger;
		
		public function bind(param1:IRender, param2:Provider, param3:IMovie) : void {
			if(this._render) {
				this._render.removeEventListener(RenderEvent.Evt_RenderAreaChanged,this.onVideoResized);
			}
			if(this._provider) {
				this._provider.removeEventListener(ProviderEvent.Evt_WillLoad,this.onFileWillLoad);
			}
			this._render = param1;
			this._provider = param2;
			this._movie = param3;
			if(this._isStart) {
				this._render.addEventListener(RenderEvent.Evt_RenderAreaChanged,this.onVideoResized);
				this._provider.addEventListener(ProviderEvent.Evt_WillLoad,this.onFileWillLoad);
			}
		}
		
		public function start() : void {
			if(!this._isStart && this._holder.runtimeData.playerUseType == PlayerUseTypeEnum.MAIN) {
				this._isStart = true;
				this._curAutoCount = 0;
				if(!this._timer.running) {
					this._timer.start();
				}
				if(this._provider) {
					this._provider.addEventListener(ProviderEvent.Evt_WillLoad,this.onFileWillLoad);
				}
				if(this._render) {
					this._render.addEventListener(RenderEvent.Evt_RenderAreaChanged,this.onVideoResized);
				}
				this.updateDefinition(REASON_OPEN);
			}
		}
		
		public function stop() : void {
			if(this._isStart) {
				this._isStart = false;
				this._curAutoCount = 0;
				if(this._timer.running) {
					this._timer.stop();
				}
				if(this._provider) {
					this._provider.removeEventListener(ProviderEvent.Evt_WillLoad,this.onFileWillLoad);
				}
				if(this._render) {
					this._render.removeEventListener(RenderEvent.Evt_RenderAreaChanged,this.onVideoResized);
				}
			}
		}
		
		private function onVideoResized(param1:RenderEvent) : void {
			if(this._curAutoCount < MAX_AUTO_COUNT) {
				if(this._timeout == 0) {
					this._timeout = setTimeout(this.updateDefinition,2000,REASON_VIDEO_RESIZED);
				}
			}
		}
		
		private function onTimerHandler(param1:TimerEvent) : void {
			if(this._curAutoCount < MAX_AUTO_COUNT) {
				this.updateDefinition(REASON_TIMER_TEST);
			}
		}
		
		private function onFileWillLoad(param1:Event) : void {
			if(this._curAutoCount < MAX_AUTO_COUNT) {
				if(this._timeout == 0) {
					this._timeout = setTimeout(this.updateDefinition,1,REASON_WILL_LOAD);
				}
			}
		}
		
		private function updateDefinition(param1:int) : void {
			var _loc3_:EnumItem = null;
			if(this._timeout != 0) {
				clearTimeout(this._timeout);
				this._timeout = 0;
			}
			this._log.debug("average speed : " + this._holder.runtimeData.currentAverageSpeed + ",s : " + this._holder.runtimeData.CDNStatus + ",allow auto up definition limit: " + this._holder.runtimeData.autoDefinitionlimit + ",smallWindowMode: " + this._holder.runtimeData.smallWindowMode);
			var _loc2_:int = this._holder.runtimeData.currentAverageSpeed;
			if((!this._holder.runtimeData.smallWindowMode && !(_loc2_ == 0) && this._render && this._provider && this._movie) && (this._movie.curDefinition) && !this._provider.loadingFailed) {
				this._detectedRate = null;
				_loc3_ = this.downDefinition();
				if(_loc3_) {
					if(_loc3_ == this._movie.curDefinition.type) {
						this.checkReason(param1);
					}
				} else {
					_loc3_ = this.upDefinition();
					if(_loc3_) {
						if(_loc3_ == this._movie.curDefinition.type) {
							this.checkReason(param1);
						}
					}
				}
				if(this._detectedRate) {
					Settings.instance.detectedRate = this._detectedRate;
				}
			}
		}
		
		private function checkReason(param1:int) : void {
			if(param1 == REASON_OPEN) {
				this._log.info("auto adjust rate success! reason : REASON_OPEN,auto count : " + this._curAutoCount);
			} else if(param1 == REASON_VIDEO_RESIZED) {
				this._curAutoCount++;
				this._log.info("auto adjust rate success! reason : REASON_VIDEO_RESIZED,auto count : " + this._curAutoCount);
			} else if(param1 == REASON_TIMER_TEST) {
				this._curAutoCount++;
				this._log.info("auto adjust rate success! reason : REASON_TIMER_TEST,auto count : " + this._curAutoCount);
			} else if(param1 == REASON_WILL_LOAD) {
				this._curAutoCount++;
				this._log.info("auto adjust rate success! reason : REASON_WILL_LOAD,auto count : " + this._curAutoCount);
			}
			
			
			
		}
		
		private function checkAndSetDetectedRate(param1:EnumItem) : void {
			var _loc2_:* = 0;
			var _loc3_:* = 0;
			if((param1) && !(param1 == DefinitionEnum.NONE)) {
				if(this._detectedRate) {
					_loc2_ = param1.id;
					if(param1 == DefinitionEnum.LIMIT) {
						_loc2_ = 0;
					}
					_loc3_ = this._detectedRate.id;
					if(this._detectedRate == DefinitionEnum.LIMIT) {
						_loc3_ = 0;
					}
					if(_loc2_ > _loc3_) {
						this._detectedRate = param1;
					}
				} else {
					this._detectedRate = param1;
				}
			}
		}
		
		private function upDefinition() : EnumItem {
			var _loc1_:EnumItem = null;
			var _loc2_:EnumItem = this._holder.runtimeData.autoDefinitionlimit;
			if(this._movie == null || this._movie.curAudioTrack == null || this._movie.curDefinition == null || this._movie.curDefinition.type == null || _loc2_ == null || _loc2_ == DefinitionEnum.NONE) {
				return _loc1_;
			}
			var _loc3_:Rectangle = this._render.getRealArea();
			var _loc4_:int = this._holder.runtimeData.currentAverageSpeed;
			if(_loc3_ == null || _loc4_ == 0) {
				return _loc1_;
			}
			var _loc5_:Array = DefinitionEnum.ITEMS;
			var _loc6_:int = _loc5_.indexOf(this._movie.curDefinition.type);
			if(this._movie.curDefinition.type == DefinitionEnum.LIMIT) {
				_loc6_ = 0;
			}
			var _loc7_:EnumItem = null;
			var _loc8_:int = _loc5_.indexOf(_loc2_);
			while(_loc8_ >= _loc6_) {
				if(_loc8_ == 0) {
					_loc7_ = DefinitionEnum.LIMIT;
				} else {
					_loc7_ = _loc5_[_loc8_];
				}
				if(_loc7_) {
					if(_loc4_ >= this.getSpeedValue(_loc7_) && (this.checkRectangle(_loc7_,_loc3_.width,_loc3_.height))) {
						this.checkAndSetDetectedRate(_loc7_);
						if(this._movie.curAudioTrack.findDefinitionByType(_loc7_,true)) {
							if(this._holder.runtimeData.CDNStatus == 0 && !(_loc7_ == this._movie.curDefinition.type)) {
								dispatchEvent(new RateAgentEvent(RateAgentEvent.Evt_AutoAdjustRate,_loc7_));
								_loc1_ = _loc7_;
							}
							return _loc1_;
						}
					}
				}
				_loc8_--;
			}
			return _loc1_;
		}
		
		private function downDefinition() : EnumItem {
			var _loc1_:EnumItem = null;
			if(this._movie == null || this._movie.curAudioTrack == null || this._movie.curDefinition == null || this._movie.curDefinition.type == null) {
				return _loc1_;
			}
			var _loc2_:Rectangle = this._render.getRealArea();
			var _loc3_:int = this._holder.runtimeData.currentAverageSpeed;
			if(_loc2_ == null || _loc3_ == 0) {
				return _loc1_;
			}
			var _loc4_:Array = DefinitionEnum.ITEMS;
			var _loc5_:int = _loc4_.indexOf(this._movie.curDefinition.type);
			if(this._movie.curDefinition.type == DefinitionEnum.LIMIT) {
				_loc5_ = 0;
			}
			var _loc6_:EnumItem = null;
			var _loc7_:EnumItem = null;
			var _loc8_:* = false;
			var _loc9_:int = _loc5_;
			while(_loc9_ >= 0) {
				if(_loc9_ == 0) {
					_loc6_ = DefinitionEnum.LIMIT;
				} else {
					_loc6_ = _loc4_[_loc9_];
				}
				if(_loc6_) {
					_loc8_ = _loc3_ >= this.getSpeedValue(_loc6_) && (this.checkRectangle(_loc6_,_loc2_.width,_loc2_.height));
					if(_loc8_) {
						this.checkAndSetDetectedRate(_loc6_);
					}
					if(this._movie.curAudioTrack.findDefinitionByType(_loc6_,true)) {
						_loc7_ = _loc6_;
						if(_loc8_) {
							this._detectedRate = _loc6_;
							if(_loc6_ != this._movie.curDefinition.type) {
								dispatchEvent(new RateAgentEvent(RateAgentEvent.Evt_AutoAdjustRate,_loc6_));
								_loc1_ = _loc6_;
							}
							return _loc1_;
						}
					}
				}
				if(_loc9_ == 0 && (_loc7_)) {
					if(_loc7_ != this._movie.curDefinition.type) {
						dispatchEvent(new RateAgentEvent(RateAgentEvent.Evt_AutoAdjustRate,_loc7_));
						_loc1_ = _loc7_;
					}
					return _loc1_;
				}
				_loc9_--;
			}
			return _loc1_;
		}
		
		private function checkRectangle(param1:EnumItem, param2:int, param3:int) : Boolean {
			var _loc4_:* = false;
			switch(param1) {
				case DefinitionEnum.STANDARD:
					_loc4_ = param2 >= 480 || 480 - param2 < 80;
					break;
				case DefinitionEnum.HIGH:
					_loc4_ = param2 >= 640 || 640 - param2 < 80;
					break;
				case DefinitionEnum.SUPER:
					_loc4_ = param2 >= 1280 || 1280 - param2 < 80;
					break;
				case DefinitionEnum.SUPER_HIGH:
					_loc4_ = param2 >= 1280 || 1280 - param2 < 80;
					if(_loc4_) {
						_loc4_ = param3 >= 720 || 720 - param3 < 80;
					}
					break;
				case DefinitionEnum.FULL_HD:
					_loc4_ = param2 >= 1920 || 1920 - param2 < 80;
					if(_loc4_) {
						_loc4_ = param3 >= 1080 || 1080 - param3 < 80;
					}
					break;
				case DefinitionEnum.FOUR_K:
					_loc4_ = param2 >= 4000 || 4000 - param2 < 80;
					if(_loc4_) {
						_loc4_ = param3 >= 2000 || 2000 - param3 < 80;
					}
					break;
				case DefinitionEnum.LIMIT:
					_loc4_ = true;
					break;
			}
			return _loc4_;
		}
		
		private function getSpeedValue(param1:EnumItem) : Number {
			var _loc2_:Number = 0;
			switch(param1) {
				case DefinitionEnum.STANDARD:
					_loc2_ = 300 * 1024 / 8;
					break;
				case DefinitionEnum.HIGH:
					_loc2_ = 600 * 1024 / 8;
					break;
				case DefinitionEnum.SUPER:
					_loc2_ = 1.1 * 1024 * 1024 / 8;
					break;
				case DefinitionEnum.SUPER_HIGH:
					_loc2_ = 1.5 * 1024 * 1024 / 8;
					break;
				case DefinitionEnum.FULL_HD:
					_loc2_ = 3 * 1024 * 1024 / 8;
					break;
				case DefinitionEnum.FOUR_K:
					_loc2_ = 8 * 1024 * 1024 / 8;
					break;
				case DefinitionEnum.LIMIT:
					_loc2_ = 0;
					break;
			}
			return _loc2_;
		}
		
		public function destroy() : void {
			if(this._render) {
				this._render.removeEventListener(RenderEvent.Evt_RenderAreaChanged,this.onVideoResized);
				this._render = null;
			}
			this._holder = null;
			this._movie = null;
			if(this._provider) {
				this._provider.removeEventListener(ProviderEvent.Evt_WillLoad,this.onFileWillLoad);
				this._provider = null;
			}
			this._isStart = false;
			this._curAutoCount = 0;
			if(this._timer) {
				this._timer.removeEventListener(TimerEvent.TIMER,this.onTimerHandler);
				if(this._timer.running) {
					this._timer.stop();
				}
			}
			if(this._timeout != 0) {
				clearTimeout(this._timeout);
				this._timeout = 0;
			}
		}
	}
}
