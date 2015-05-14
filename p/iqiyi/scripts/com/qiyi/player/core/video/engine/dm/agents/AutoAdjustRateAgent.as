package com.qiyi.player.core.video.engine.dm.agents
{
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
	
	public class AutoAdjustRateAgent extends EventDispatcher implements IDestroy
	{
		
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
		
		public function AutoAdjustRateAgent(param1:ICorePlayer)
		{
			this._log = Log.getLogger("com.qiyi.player.core.video.engine.dm.agents.AutoAdjustRateAgent");
			super();
			this._holder = param1;
			this._isStart = false;
			this._curAutoCount = 0;
			this._timeout = 0;
			this._timer = new Timer(10000);
			this._timer.addEventListener(TimerEvent.TIMER,this.onTimerHandler);
		}
		
		public function bind(param1:IRender, param2:Provider, param3:IMovie) : void
		{
			if(this._render)
			{
				this._render.removeEventListener(RenderEvent.Evt_RenderAreaChanged,this.onVideoResized);
			}
			if(this._provider)
			{
				this._provider.removeEventListener(ProviderEvent.Evt_WillLoad,this.onFileWillLoad);
			}
			this._render = param1;
			this._provider = param2;
			this._movie = param3;
			if(this._isStart)
			{
				this._render.addEventListener(RenderEvent.Evt_RenderAreaChanged,this.onVideoResized);
				this._provider.addEventListener(ProviderEvent.Evt_WillLoad,this.onFileWillLoad);
			}
		}
		
		public function start() : void
		{
			if(!this._isStart && this._holder.runtimeData.playerUseType == PlayerUseTypeEnum.MAIN)
			{
				this._isStart = true;
				this._curAutoCount = 0;
				if(!this._timer.running)
				{
					this._timer.start();
				}
				if(this._provider)
				{
					this._provider.addEventListener(ProviderEvent.Evt_WillLoad,this.onFileWillLoad);
				}
				if(this._render)
				{
					this._render.addEventListener(RenderEvent.Evt_RenderAreaChanged,this.onVideoResized);
				}
				this.updateDefinition(REASON_OPEN);
			}
		}
		
		public function stop() : void
		{
			if(this._isStart)
			{
				this._isStart = false;
				this._curAutoCount = 0;
				if(this._timer.running)
				{
					this._timer.stop();
				}
				if(this._provider)
				{
					this._provider.removeEventListener(ProviderEvent.Evt_WillLoad,this.onFileWillLoad);
				}
				if(this._render)
				{
					this._render.removeEventListener(RenderEvent.Evt_RenderAreaChanged,this.onVideoResized);
				}
			}
		}
		
		private function onVideoResized(param1:RenderEvent) : void
		{
			if(this._curAutoCount < MAX_AUTO_COUNT)
			{
				if(this._timeout == 0)
				{
					this._timeout = setTimeout(this.updateDefinition,2000,REASON_VIDEO_RESIZED);
				}
			}
		}
		
		private function onTimerHandler(param1:TimerEvent) : void
		{
			if(this._curAutoCount < MAX_AUTO_COUNT)
			{
				this.updateDefinition(REASON_TIMER_TEST);
			}
		}
		
		private function onFileWillLoad(param1:Event) : void
		{
			if(this._curAutoCount < MAX_AUTO_COUNT)
			{
				if(this._timeout == 0)
				{
					this._timeout = setTimeout(this.updateDefinition,1,REASON_WILL_LOAD);
				}
			}
		}
		
		private function updateDefinition(param1:int) : void
		{
			var _loc3:EnumItem = null;
			if(this._timeout != 0)
			{
				clearTimeout(this._timeout);
				this._timeout = 0;
			}
			this._log.debug("average speed : " + this._holder.runtimeData.currentAverageSpeed + ",s : " + this._holder.runtimeData.CDNStatus + ",allow auto up definition limit: " + this._holder.runtimeData.autoDefinitionlimit + ",smallWindowMode: " + this._holder.runtimeData.smallWindowMode);
			var _loc2:int = this._holder.runtimeData.currentAverageSpeed;
			if((!this._holder.runtimeData.smallWindowMode && !(_loc2 == 0) && this._render && this._provider && this._movie) && (this._movie.curDefinition) && !this._provider.loadingFailed)
			{
				this._detectedRate = null;
				_loc3 = this.downDefinition();
				if(_loc3)
				{
					if(_loc3 == this._movie.curDefinition.type)
					{
						this.checkReason(param1);
					}
				}
				else
				{
					_loc3 = this.upDefinition();
					if(_loc3)
					{
						if(_loc3 == this._movie.curDefinition.type)
						{
							this.checkReason(param1);
						}
					}
				}
				if(this._detectedRate)
				{
					Settings.instance.detectedRate = this._detectedRate;
				}
			}
		}
		
		private function checkReason(param1:int) : void
		{
			if(param1 == REASON_OPEN)
			{
				this._log.info("auto adjust rate success! reason : REASON_OPEN,auto count : " + this._curAutoCount);
			}
			else if(param1 == REASON_VIDEO_RESIZED)
			{
				this._curAutoCount++;
				this._log.info("auto adjust rate success! reason : REASON_VIDEO_RESIZED,auto count : " + this._curAutoCount);
			}
			else if(param1 == REASON_TIMER_TEST)
			{
				this._curAutoCount++;
				this._log.info("auto adjust rate success! reason : REASON_TIMER_TEST,auto count : " + this._curAutoCount);
			}
			else if(param1 == REASON_WILL_LOAD)
			{
				this._curAutoCount++;
				this._log.info("auto adjust rate success! reason : REASON_WILL_LOAD,auto count : " + this._curAutoCount);
			}
			
			
			
		}
		
		private function checkAndSetDetectedRate(param1:EnumItem) : void
		{
			var _loc2:* = 0;
			var _loc3:* = 0;
			if((param1) && !(param1 == DefinitionEnum.NONE))
			{
				if(this._detectedRate)
				{
					_loc2 = param1.id;
					if(param1 == DefinitionEnum.LIMIT)
					{
						_loc2 = 0;
					}
					_loc3 = this._detectedRate.id;
					if(this._detectedRate == DefinitionEnum.LIMIT)
					{
						_loc3 = 0;
					}
					if(_loc2 > _loc3)
					{
						this._detectedRate = param1;
					}
				}
				else
				{
					this._detectedRate = param1;
				}
			}
		}
		
		private function upDefinition() : EnumItem
		{
			var _loc1:EnumItem = null;
			var _loc2:EnumItem = this._holder.runtimeData.autoDefinitionlimit;
			if(this._movie == null || this._movie.curAudioTrack == null || this._movie.curDefinition == null || this._movie.curDefinition.type == null || _loc2 == null || _loc2 == DefinitionEnum.NONE)
			{
				return _loc1;
			}
			var _loc3:Rectangle = this._render.getRealArea();
			var _loc4:int = this._holder.runtimeData.currentAverageSpeed;
			if(_loc3 == null || _loc4 == 0)
			{
				return _loc1;
			}
			var _loc5:Array = DefinitionEnum.ITEMS;
			var _loc6:int = _loc5.indexOf(this._movie.curDefinition.type);
			if(this._movie.curDefinition.type == DefinitionEnum.LIMIT)
			{
				_loc6 = 0;
			}
			var _loc7:EnumItem = null;
			var _loc8:int = _loc5.indexOf(_loc2);
			while(_loc8 >= _loc6)
			{
				if(_loc8 == 0)
				{
					_loc7 = DefinitionEnum.LIMIT;
				}
				else
				{
					_loc7 = _loc5[_loc8];
				}
				if(_loc7)
				{
					if(_loc4 >= this.getSpeedValue(_loc7) && (this.checkRectangle(_loc7,_loc3.width,_loc3.height)))
					{
						this.checkAndSetDetectedRate(_loc7);
						if(this._movie.curAudioTrack.findDefinitionByType(_loc7,true))
						{
							if(this._holder.runtimeData.CDNStatus == 0 && !(_loc7 == this._movie.curDefinition.type))
							{
								dispatchEvent(new RateAgentEvent(RateAgentEvent.Evt_AutoAdjustRate,_loc7));
								_loc1 = _loc7;
							}
							return _loc1;
						}
					}
				}
				_loc8--;
			}
			return _loc1;
		}
		
		private function downDefinition() : EnumItem
		{
			var _loc1:EnumItem = null;
			if(this._movie == null || this._movie.curAudioTrack == null || this._movie.curDefinition == null || this._movie.curDefinition.type == null)
			{
				return _loc1;
			}
			var _loc2:Rectangle = this._render.getRealArea();
			var _loc3:int = this._holder.runtimeData.currentAverageSpeed;
			if(_loc2 == null || _loc3 == 0)
			{
				return _loc1;
			}
			var _loc4:Array = DefinitionEnum.ITEMS;
			var _loc5:int = _loc4.indexOf(this._movie.curDefinition.type);
			if(this._movie.curDefinition.type == DefinitionEnum.LIMIT)
			{
				_loc5 = 0;
			}
			var _loc6:EnumItem = null;
			var _loc7:EnumItem = null;
			var _loc8:* = false;
			var _loc9:int = _loc5;
			while(_loc9 >= 0)
			{
				if(_loc9 == 0)
				{
					_loc6 = DefinitionEnum.LIMIT;
				}
				else
				{
					_loc6 = _loc4[_loc9];
				}
				if(_loc6)
				{
					_loc8 = _loc3 >= this.getSpeedValue(_loc6) && (this.checkRectangle(_loc6,_loc2.width,_loc2.height));
					if(_loc8)
					{
						this.checkAndSetDetectedRate(_loc6);
					}
					if(this._movie.curAudioTrack.findDefinitionByType(_loc6,true))
					{
						_loc7 = _loc6;
						if(_loc8)
						{
							this._detectedRate = _loc6;
							if(_loc6 != this._movie.curDefinition.type)
							{
								dispatchEvent(new RateAgentEvent(RateAgentEvent.Evt_AutoAdjustRate,_loc6));
								_loc1 = _loc6;
							}
							return _loc1;
						}
					}
				}
				if(_loc9 == 0 && (_loc7))
				{
					if(_loc7 != this._movie.curDefinition.type)
					{
						dispatchEvent(new RateAgentEvent(RateAgentEvent.Evt_AutoAdjustRate,_loc7));
						_loc1 = _loc7;
					}
					return _loc1;
				}
				_loc9--;
			}
			return _loc1;
		}
		
		private function checkRectangle(param1:EnumItem, param2:int, param3:int) : Boolean
		{
			var _loc4:* = false;
			switch(param1)
			{
				case DefinitionEnum.STANDARD:
					_loc4 = param2 >= 480 || 480 - param2 < 80;
					break;
				case DefinitionEnum.HIGH:
					_loc4 = param2 >= 640 || 640 - param2 < 80;
					break;
				case DefinitionEnum.SUPER:
					_loc4 = param2 >= 1280 || 1280 - param2 < 80;
					break;
				case DefinitionEnum.SUPER_HIGH:
					_loc4 = param2 >= 1280 || 1280 - param2 < 80;
					if(_loc4)
					{
						_loc4 = param3 >= 720 || 720 - param3 < 80;
					}
					break;
				case DefinitionEnum.FULL_HD:
					_loc4 = param2 >= 1920 || 1920 - param2 < 80;
					if(_loc4)
					{
						_loc4 = param3 >= 1080 || 1080 - param3 < 80;
					}
					break;
				case DefinitionEnum.FOUR_K:
					_loc4 = param2 >= 4000 || 4000 - param2 < 80;
					if(_loc4)
					{
						_loc4 = param3 >= 2000 || 2000 - param3 < 80;
					}
					break;
				case DefinitionEnum.LIMIT:
					_loc4 = true;
					break;
			}
			return _loc4;
		}
		
		private function getSpeedValue(param1:EnumItem) : Number
		{
			var _loc2:Number = 0;
			switch(param1)
			{
				case DefinitionEnum.STANDARD:
					_loc2 = 300 * 1024 / 8;
					break;
				case DefinitionEnum.HIGH:
					_loc2 = 600 * 1024 / 8;
					break;
				case DefinitionEnum.SUPER:
					_loc2 = 1.1 * 1024 * 1024 / 8;
					break;
				case DefinitionEnum.SUPER_HIGH:
					_loc2 = 1.5 * 1024 * 1024 / 8;
					break;
				case DefinitionEnum.FULL_HD:
					_loc2 = 3 * 1024 * 1024 / 8;
					break;
				case DefinitionEnum.FOUR_K:
					_loc2 = 8 * 1024 * 1024 / 8;
					break;
				case DefinitionEnum.LIMIT:
					_loc2 = 0;
					break;
			}
			return _loc2;
		}
		
		public function destroy() : void
		{
			if(this._render)
			{
				this._render.removeEventListener(RenderEvent.Evt_RenderAreaChanged,this.onVideoResized);
				this._render = null;
			}
			this._holder = null;
			this._movie = null;
			if(this._provider)
			{
				this._provider.removeEventListener(ProviderEvent.Evt_WillLoad,this.onFileWillLoad);
				this._provider = null;
			}
			this._isStart = false;
			this._curAutoCount = 0;
			if(this._timer)
			{
				this._timer.removeEventListener(TimerEvent.TIMER,this.onTimerHandler);
				if(this._timer.running)
				{
					this._timer.stop();
				}
			}
			if(this._timeout != 0)
			{
				clearTimeout(this._timeout);
				this._timeout = 0;
			}
		}
	}
}
