package com.qiyi.player.core.video.engine.dm.agents
{
	import flash.events.EventDispatcher;
	import com.qiyi.player.core.IDestroy;
	import com.qiyi.player.core.player.coreplayer.ICorePlayer;
	import com.qiyi.player.core.video.decoder.IDecoder;
	import com.qiyi.player.core.video.render.IRender;
	import com.qiyi.player.core.video.engine.dm.provider.Provider;
	import com.qiyi.player.core.model.IMovie;
	import com.qiyi.player.base.logging.ILogger;
	import com.qiyi.player.core.model.impls.pub.Settings;
	import com.qiyi.player.core.video.events.RateAgentEvent;
	import flash.events.Event;
	import com.qiyi.player.core.model.IAudioTrackInfo;
	import com.qiyi.player.core.model.utils.DefinitionUtils;
	import com.qiyi.player.base.pub.EnumItem;
	import com.qiyi.player.core.model.def.DefinitionEnum;
	import com.qiyi.player.base.logging.Log;
	
	public class RateAgent extends EventDispatcher implements IDestroy
	{
		
		private var _holder:ICorePlayer;
		
		private var _decoder:IDecoder;
		
		private var _render:IRender;
		
		private var _provider:Provider;
		
		private var _movie:IMovie;
		
		private var _autoAdjustRateAgent:AutoAdjustRateAgent;
		
		private var _isBind:Boolean;
		
		private var _log:ILogger;
		
		public function RateAgent(param1:ICorePlayer)
		{
			this._log = Log.getLogger("com.qiyi.player.core.video.engine.dm.agents.RateAgent");
			super();
			this._holder = param1;
			this._isBind = false;
			this._autoAdjustRateAgent = new AutoAdjustRateAgent(this._holder);
		}
		
		public function bind(param1:IDecoder, param2:IRender, param3:Provider, param4:IMovie) : void
		{
			this._decoder = param1;
			this._render = param2;
			this._provider = param3;
			this._movie = param4;
			this._autoAdjustRateAgent.bind(param2,param3,this._movie);
			if(!this._isBind)
			{
				Settings.instance.addEventListener(Settings.Evt_AudioTrackChanged,this.onAudioTrackChanged);
				Settings.instance.addEventListener(Settings.Evt_DefinitionChanged,this.onDefinitionChanged);
				Settings.instance.addEventListener(Settings.Evt_AutoMatchChanged,this.onAutoMatchChanged);
				this._autoAdjustRateAgent.addEventListener(RateAgentEvent.Evt_AutoAdjustRate,this.onAutoAdjustRate);
				this._isBind = true;
			}
		}
		
		public function startAutoAdjustRate() : void
		{
			if(Settings.instance.autoMatchRate)
			{
				this._autoAdjustRateAgent.start();
			}
			else
			{
				this._autoAdjustRateAgent.stop();
			}
		}
		
		public function stopAutoAdjustRate() : void
		{
			this._autoAdjustRateAgent.stop();
		}
		
		public function destroy() : void
		{
			this._holder = null;
			this._decoder = null;
			this._render = null;
			this._provider = null;
			this._movie = null;
			this._isBind = false;
			this._autoAdjustRateAgent.removeEventListener(RateAgentEvent.Evt_AutoAdjustRate,this.onAutoAdjustRate);
			this._autoAdjustRateAgent.destroy();
			this._autoAdjustRateAgent = null;
			Settings.instance.removeEventListener(Settings.Evt_AudioTrackChanged,this.onAudioTrackChanged);
			Settings.instance.removeEventListener(Settings.Evt_DefinitionChanged,this.onDefinitionChanged);
			Settings.instance.removeEventListener(Settings.Evt_AutoMatchChanged,this.onAutoMatchChanged);
		}
		
		private function onDefinitionChanged(param1:Event) : void
		{
			var _loc2:* = false;
			var _loc3:IAudioTrackInfo = null;
			var _loc4:* = 0;
			if(!this._isBind)
			{
				return;
			}
			if(!Settings.instance.autoMatchRate)
			{
				if(this._movie.curDefinition == null || !(this._movie.curDefinition.type == Settings.instance.definition))
				{
					_loc2 = false;
					if((this._holder) && (this._holder.runtimeData.needFilterQualityDefinition))
					{
						_loc3 = this._movie.curAudioTrack;
						if(_loc3)
						{
							_loc4 = _loc3.definitionCount;
							if(_loc4 > 3)
							{
								_loc2 = true;
							}
							else if(_loc4 == 3)
							{
								if((DefinitionUtils.inFilterPPByDefinitionID(_loc3.findDefinitionInfoAt(0).type.id)) && (DefinitionUtils.inFilterPPByDefinitionID(_loc3.findDefinitionInfoAt(1).type.id)) && (DefinitionUtils.inFilterPPByDefinitionID(_loc3.findDefinitionInfoAt(2).type.id)))
								{
									_loc2 = false;
								}
								else
								{
									_loc2 = true;
								}
							}
							else if(_loc4 == 2)
							{
								if((DefinitionUtils.inFilterPPByDefinitionID(_loc3.findDefinitionInfoAt(0).type.id)) && (DefinitionUtils.inFilterPPByDefinitionID(_loc3.findDefinitionInfoAt(1).type.id)))
								{
									_loc2 = false;
								}
								else
								{
									_loc2 = true;
								}
							}
							else
							{
								_loc2 = false;
							}
							
							
						}
					}
					if((_loc2) && (Settings.instance.definition) && (DefinitionUtils.inFilterPPByDefinitionID(Settings.instance.definition.id)))
					{
						return;
					}
					this._log.info("definition changed:definition=" + Settings.instance.definition + ",s=" + this._holder.runtimeData.CDNStatus);
					this._movie.setCurDefinition(Settings.instance.definition);
					if((this._movie.curDefinition) && (this._movie.curDefinition.type))
					{
						this._holder.runtimeData.currentDefinition = this._movie.curDefinition.type.id.toString();
					}
					this._holder.runtimeData.vid = this._movie.vid;
					dispatchEvent(new RateAgentEvent(RateAgentEvent.Evt_DefinitionChanged,this._decoder.bufferLength * 1000));
				}
			}
		}
		
		private function onAutoAdjustRate(param1:RateAgentEvent) : void
		{
			var _loc3:* = 0;
			var _loc4:* = 0;
			if(!this._isBind)
			{
				return;
			}
			var _loc2:EnumItem = param1.data as EnumItem;
			if(this._movie.curDefinition == null || !(this._movie.curDefinition.type == _loc2))
			{
				if(this._provider.bufferLength - this._decoder.time > 130000)
				{
					if(_loc2 == DefinitionEnum.LIMIT)
					{
						dispatchEvent(new RateAgentEvent(RateAgentEvent.Evt_DefinitionChanged,-1));
						return;
					}
					if((this._movie.curDefinition) && (!(this._movie.curDefinition.type == DefinitionEnum.LIMIT)) && this._movie.curDefinition.type.id > _loc2.id)
					{
						dispatchEvent(new RateAgentEvent(RateAgentEvent.Evt_DefinitionChanged,-1));
						return;
					}
				}
				_loc3 = 0;
				_loc4 = 0;
				if((this._movie.curDefinition) && (this._movie.curDefinition.type))
				{
					_loc3 = this._movie.curDefinition.type.id;
				}
				this._log.info("auto definition before changed:definition=" + _loc2 + ",s=" + this._holder.runtimeData.CDNStatus);
				this._movie.setCurDefinition(_loc2);
				this._log.info("auto definition after changed:definition=" + this._movie.curDefinition.type + ",s=" + this._holder.runtimeData.CDNStatus);
				this._holder.runtimeData.vid = this._movie.vid;
				if((this._movie.curDefinition) && (this._movie.curDefinition.type))
				{
					this._holder.runtimeData.currentDefinition = this._movie.curDefinition.type.id.toString();
					_loc4 = this._movie.curDefinition.type.id;
				}
				this._holder.pingBack.sendAutoDefinition(_loc3,_loc4);
				dispatchEvent(new RateAgentEvent(RateAgentEvent.Evt_DefinitionChanged,this._decoder.bufferLength * 1000));
			}
		}
		
		private function onAudioTrackChanged(param1:Event) : void
		{
			if(!this._isBind)
			{
				return;
			}
			var _loc2:EnumItem = null;
			if((this._movie.curDefinition) && (this._movie.curDefinition.type))
			{
				_loc2 = this._movie.curDefinition.type;
			}
			else
			{
				_loc2 = DefinitionUtils.getCurrentDefinition(this._holder);
			}
			this._log.info("audioTrack changed:audio=" + Settings.instance.audioTrack + ",definition=" + _loc2 + ",s=" + this._holder.runtimeData.CDNStatus);
			this._movie.setCurAudioTrack(Settings.instance.audioTrack,_loc2);
			if((this._movie.curDefinition) && (this._movie.curDefinition.type))
			{
				this._holder.runtimeData.currentDefinition = this._movie.curDefinition.type.id.toString();
			}
			this._holder.runtimeData.vid = this._movie.vid;
			dispatchEvent(new RateAgentEvent(RateAgentEvent.Evt_AudioTrackChanged,this._decoder.bufferLength * 1000));
		}
		
		private function onAutoMatchChanged(param1:Event) : void
		{
			if(Settings.instance.autoMatchRate)
			{
				this._autoAdjustRateAgent.start();
			}
			else
			{
				this._autoAdjustRateAgent.stop();
			}
		}
	}
}
