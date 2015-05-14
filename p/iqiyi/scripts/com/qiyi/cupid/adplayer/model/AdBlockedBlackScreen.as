package com.qiyi.cupid.adplayer.model
{
	import flash.display.Sprite;
	import com.qiyi.cupid.adplayer.utils.StringUtils;
	import com.qiyi.cupid.adplayer.utils.URLParser;
	import com.qiyi.cupid.adplayer.view.components.AdBlockTips;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import com.qiyi.cupid.adplayer.events.AdBlockedBlackScreenEvent;
	
	public class AdBlockedBlackScreen extends Sprite
	{
		
		public static const CAN_SHOW:Boolean = true;
		
		private static const HOST_BLACKLIST:Array = ["adtchrome.qiniudn.com"];
		
		private const WITH_COUNTDOWN:Boolean = false;
		
		private var _adBlockTips:AdBlockTips;
		
		private var _countdown:NoSkipAdTips;
		
		private var _showTimer:Timer;
		
		private var _blackScreenDuration:int = 60;
		
		private var _timeRemain:int = 60;
		
		private var _initWidth:Number;
		
		private var _initHeight:Number;
		
		public function AdBlockedBlackScreen(param1:Number, param2:Number, param3:int = 60)
		{
			super();
			this.visible = false;
			this._initWidth = param1;
			this._initHeight = param2;
			this._blackScreenDuration = param3;
			this.initialise();
		}
		
		public static function isInBlacklist(param1:String) : Boolean
		{
			if(!param1)
			{
				return false;
			}
			if(StringUtils.beginsWith(param1,"chrome-extension://"))
			{
				return true;
			}
			var _loc2:URLParser = new URLParser(param1);
			var _loc3:String = _loc2.getHost();
			return !(HOST_BLACKLIST.indexOf(_loc3) == -1);
		}
		
		private function initialise() : void
		{
			this._adBlockTips = new AdBlockTips();
			this._countdown = new NoSkipAdTips();
			this.resize(this._initWidth,this._initHeight);
			addChild(this._adBlockTips);
			addChild(this._countdown);
		}
		
		public function show() : void
		{
			if(this.WITH_COUNTDOWN)
			{
				this._timeRemain = this._blackScreenDuration;
				this._countdown.countdown.text = this._timeRemain.toString();
				this._showTimer = new Timer(1000,this._blackScreenDuration);
				this._showTimer.addEventListener(TimerEvent.TIMER,this.onShowTimer);
				this._showTimer.addEventListener(TimerEvent.TIMER_COMPLETE,this.onShowTimerComplete);
				this._showTimer.start();
			}
			else
			{
				this._countdown.visible = false;
			}
			this.visible = true;
		}
		
		private function onShowTimer(param1:TimerEvent) : void
		{
			this._timeRemain--;
			if(this._countdown)
			{
				this._countdown.countdown.text = this._timeRemain.toString();
			}
		}
		
		private function onShowTimerComplete(param1:TimerEvent) : void
		{
			this.clearShowTimer();
			var _loc2:AdBlockedBlackScreenEvent = new AdBlockedBlackScreenEvent(AdBlockedBlackScreenEvent.BLACK_SCREEN_COMPLETE);
			this.dispatchEvent(_loc2);
		}
		
		private function clearShowTimer() : void
		{
			if(this._showTimer)
			{
				this._showTimer.removeEventListener(TimerEvent.TIMER,this.onShowTimer);
				this._showTimer.removeEventListener(TimerEvent.TIMER_COMPLETE,this.onShowTimerComplete);
				this._showTimer.stop();
				this._showTimer = null;
			}
		}
		
		public function resize(param1:Number, param2:Number) : void
		{
			this._initWidth = param1;
			this._initHeight = param2;
			if(this._adBlockTips)
			{
				this._adBlockTips.x = (this._initWidth - this._adBlockTips.width) / 2;
				this._adBlockTips.y = (this._initHeight - this._adBlockTips.height) / 2;
			}
			if(this._countdown)
			{
				this._countdown.x = this._initWidth - 29 - 10;
				this._countdown.y = 20;
			}
			this.redraw(param1,param2);
		}
		
		private function redraw(param1:Number, param2:Number) : void
		{
			this.graphics.clear();
			this.graphics.beginFill(0);
			this.graphics.drawRect(0,0,param1,param2);
			this.graphics.endFill();
		}
		
		private function clearCountdown() : void
		{
			if(this._countdown)
			{
				if(contains(this._countdown))
				{
					removeChild(this._countdown);
				}
				this._countdown = null;
			}
		}
		
		private function clearAdErrorTips() : void
		{
			if(this._adBlockTips)
			{
				if(contains(this._adBlockTips))
				{
					removeChild(this._adBlockTips);
				}
				this._adBlockTips = null;
			}
		}
		
		public function destroy() : void
		{
			this.clearShowTimer();
			this.clearCountdown();
			this.clearAdErrorTips();
		}
	}
}
