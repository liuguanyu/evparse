package com.sohu.tv.mediaplayer.video {
	import flash.media.SoundTransform;
	import ebing.core.*;
	import flash.events.*;
	import flash.utils.*;
	import ebing.events.*;
	
	public class TvSohuSimpleVideoCore extends SimpleVideoCore {
		
		public function TvSohuSimpleVideoCore(param1:Object) {
			if(param1.index != null) {
				this._id = param1.index;
			}
			super(param1);
		}
		
		private var _id:int = 0;
		
		private var _mask:String = "n";
		
		override protected function newFunc() : void {
			_timer = new Timer(100,0);
			if(!_timer.hasEventListener(TimerEvent.TIMER)) {
				_timer.addEventListener(TimerEvent.TIMER,this.timerHandler);
			}
			_soundTransform = new SoundTransform();
		}
		
		public function onLastSecond(param1:*) : void {
		}
		
		public function get id() : int {
			return this._id;
		}
		
		override public function softInit(param1:Object) : void {
			this._mask = "n";
			super.softInit(param1);
		}
		
		override protected function onNetStatus(param1:NetStatusEvent) : void {
			if(param1.info.code == "NetStream.Play.Stop" && Math.abs(_ns.time - _totTime) > 1 && _sysStatus_str == "3") {
				_stopFlag_boo = false;
				dispatch(MediaEvent.PLAY_ABEND,{
					"playedTime":_ns.time,
					"totTime":_totTime
				});
				this.stop("noevent");
			} else if(param1.info.code == "NetStream.Play.Stop") {
				if(_stopFlag_boo) {
					this._mask = this._mask + ("-s2_" + getTimer());
					this.judgeStop();
				} else {
					_stopFlag_boo = true;
					this._mask = "s1_" + getTimer();
				}
			} else {
				super.onNetStatus(param1);
			}
			
		}
		
		override protected function timerHandler(param1:TimerEvent) : void {
			aboutTime();
			aboutDownload();
			if(!(_totTime == 0) && Math.ceil(_ns.time * 10) >= Math.floor(_totTime * 10)) {
				if(_stopFlag_boo) {
					this._mask = this._mask + ("-t2_" + getTimer());
					this.judgeStop();
				} else {
					_stopFlag_boo = true;
					this._mask = "t1_" + getTimer();
				}
			}
			param1.updateAfterEvent();
		}
		
		override public function stop(param1:* = null) : void {
			if(_sysStatus_str != "5") {
				_sysStatus_str = "5";
				_timer.stop();
				_ns.seek(0);
				_ns.close();
				if(param1 != "noevent") {
					if(_finish_boo) {
						dispatch(MediaEvent.STOP,{
							"finish":true,
							"mask":this._mask
						});
						_finish_boo = false;
					} else {
						dispatch(MediaEvent.STOP,{
							"finish":false,
							"mask":this._mask
						});
					}
				}
			}
		}
		
		override protected function judgeStop() : void {
			clearTimeout(_stopTimeout);
			if(_sysStatus_str != "5") {
				if(_isLoop) {
					setTimeout(function():void {
						seek(0);
					},1000);
				} else {
					_finish_boo = true;
					_stopFlag_boo = false;
					this.stop();
				}
			}
		}
	}
}
