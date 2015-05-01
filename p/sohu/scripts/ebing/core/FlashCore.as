package ebing.core {
	import flash.display.Sprite;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import flash.media.Video;
	import flash.display.Loader;
	import flash.events.*;
	import flash.utils.*;
	import ebing.events.MediaEvent;
	import ebing.net.LoaderUtil;
	import ebing.Utils;
	
	public class FlashCore extends Sprite implements IMediaCore {
		
		public function FlashCore(param1:Object) {
			super();
			this.hardInit(param1);
		}
		
		protected var _sysStatus_str:String = "5";
		
		protected var _width_num:Number;
		
		protected var _height_num:Number;
		
		protected var _minWidth_num:Number;
		
		protected var _minHeight_num:Number;
		
		protected var _skin;
		
		protected var _frame_c:Sprite;
		
		protected var _wave_arr:Array;
		
		protected var _buffer:Number;
		
		protected var _timeLimit:Number;
		
		protected var _url:String;
		
		protected var _nc:NetConnection;
		
		protected var _ns:NetStream;
		
		protected var _video:Video;
		
		protected var _fileTotTime:Number = 0;
		
		protected var _filePlayedTime:Number = 0;
		
		protected var _finish_boo:Boolean = false;
		
		protected var _bg_spr:Sprite;
		
		protected var _stopFlag_boo:Boolean;
		
		protected var _timer:Timer;
		
		protected var _volume:Number;
		
		protected var _swf:Loader;
		
		protected var _fileTotSize:Number = 0;
		
		protected var _fileLoadedSize:Number = 0;
		
		protected var _getTime:Number = 0;
		
		protected var _mask:Sprite;
		
		private var _ttt:Boolean = false;
		
		protected var _connected:Boolean = false;
		
		public function hardInit(param1:Object) : void {
			this._width_num = param1.width;
			this._height_num = param1.height;
			this._timeLimit = param1.limitTime;
			this.sysInit("start");
		}
		
		public function softInit(param1:Object) : void {
			this._url = param1.url;
			this._fileTotTime = param1.time;
			this._fileTotSize = param1.size;
		}
		
		protected function sysInit(param1:String = null) : void {
			this._fileLoadedSize = this._fileTotSize = this._filePlayedTime = this._fileTotTime = 0;
			this._finish_boo = false;
			this._stopFlag_boo = false;
			if(param1 == "start") {
				this.newFunc();
				this.drawSkin();
				this.addEvent();
			}
			this._connected = false;
		}
		
		public function seek(param1:Number) : void {
		}
		
		protected function swfProgressHnadler(param1:ProgressEvent) : void {
			trace("********************************************************++++++++++++++++++++++++++++++++++++++++evt.target.bytesLoaded:" + param1.target.bytesLoaded,"evt.target.bytesTotal:" + param1.target.bytesTotal);
			if(param1.target.bytesTotal > 0) {
				this.dispatch(MediaEvent.LOAD_PROGRESS,{
					"nowSize":param1.target.bytesLoaded,
					"totSize":param1.target.bytesTotal
				});
			}
		}
		
		protected function swfHandler(param1:Object) : void {
			if(param1.info == "success") {
				this._swf = param1.data;
				this.dispatch(MediaEvent.START);
				this._timer.start();
				this._getTime = getTimer();
				addChild(this._swf);
				addChild(this._mask);
				this._swf.mask = this._mask;
				this.resize(this._width_num,this._height_num);
			} else if(param1.info == "timeout") {
				this.dispatch(MediaEvent.CONNECT_TIMEOUT);
				this._sysStatus_str = "5";
			} else {
				trace("+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++***********************************");
				this.dispatch(MediaEvent.NOTFOUND);
			}
			
		}
		
		public function play(param1:* = null) : void {
			if(this._sysStatus_str == "5") {
				new LoaderUtil().load(this._timeLimit,this.swfHandler,this.swfProgressHnadler,this._url);
			}
			if(this._sysStatus_str == "4") {
				this._getTime = getTimer() - this._filePlayedTime;
			}
			this._sysStatus_str = "3";
			this.dispatch(MediaEvent.PLAY);
		}
		
		public function pause(param1:* = null) : void {
			this._sysStatus_str = "4";
			if(param1 != "0") {
				this.dispatch(MediaEvent.PAUSE,{"isHard":(param1 == null?false:true)});
			}
		}
		
		public function sleep(param1:* = null) : void {
			this.pause("0");
		}
		
		public function stop(param1:* = null) : void {
			this._timer.stop();
			this._sysStatus_str = "5";
			if(this._finish_boo) {
				this.dispatch(MediaEvent.STOP,{"finish":true});
				this._finish_boo = false;
			} else {
				this.dispatch(MediaEvent.STOP,{"finish":false});
			}
			try {
				this._swf.contentLoaderInfo.sharedEvents.dispatchEvent(new Event("ad_closed"));
			}
			catch(e:Error) {
			}
		}
		
		public function playOrPause(param1:* = null) : void {
			if(this._sysStatus_str == "4") {
				this.play();
			} else if(this._sysStatus_str == "3") {
				this.pause(param1);
			}
			
		}
		
		public function onMetaData(param1:Object) : void {
		}
		
		protected function timerHandler(param1:TimerEvent) : void {
			this.aboutTime(param1.target.delay);
			this.aboutDownload();
			if(Math.ceil(this._filePlayedTime * 10) >= Math.floor(this._fileTotTime * 10)) {
				this._finish_boo = true;
				if(this._sysStatus_str != "5") {
					this.stop();
				}
			}
			param1.updateAfterEvent();
		}
		
		public function destroy() : void {
			this._timer.stop();
			this._timer.removeEventListener(TimerEvent.TIMER,this.timerHandler);
			this._timer = null;
			removeChild(this._swf);
			this._swf = null;
		}
		
		protected function aboutTime(param1:Number) : void {
			if(!(this._swf == null) && this._sysStatus_str == "3") {
				this._filePlayedTime = getTimer() - this._getTime;
				this.dispatch(MediaEvent.PLAY_PROGRESS,{
					"nowTime":this._filePlayedTime / 1000,
					"totTime":this._fileTotTime / 1000
				});
			}
		}
		
		protected function aboutDownload() : void {
		}
		
		protected function newFunc() : void {
			this._timer = new Timer(100,0);
			if(!this._timer.hasEventListener(TimerEvent.TIMER)) {
				this._timer.addEventListener(TimerEvent.TIMER,this.timerHandler);
			}
		}
		
		protected function drawSkin() : void {
			this._bg_spr = new Sprite();
			Utils.drawRect(this._bg_spr,0,0,this._width_num,this._height_num,0,1);
			addChild(this._bg_spr);
		}
		
		protected function addEvent() : void {
		}
		
		public function resize(param1:Number, param2:Number) : void {
			var K1026035576CE979F9D4C27894EE6BDE6ED440D373566K:Number = NaN;
			var K102603F24F9BF3420149E3AC27B8EA7438E66E373566K:Number = NaN;
			var K102603F8F23E0F3EBC4A268E1B5613E4FEC487373566K:Number = NaN;
			var K1026037850482A38BE4ECEA65CBE571D4C215C373566K:Number = NaN;
			var w:Number = param1;
			var h:Number = param2;
			trace("+++++++++++++++++++---");
			this._width_num = this._bg_spr.width = w;
			this._height_num = this._bg_spr.height = h;
			try {
				if(this._swf.contentLoaderInfo != null) {
					K1026035576CE979F9D4C27894EE6BDE6ED440D373566K = this._swf.contentLoaderInfo.width;
					K102603F24F9BF3420149E3AC27B8EA7438E66E373566K = this._swf.contentLoaderInfo.height;
					K102603F8F23E0F3EBC4A268E1B5613E4FEC487373566K = 0;
					K1026037850482A38BE4ECEA65CBE571D4C215C373566K = 0;
					if(!this._ttt) {
						this._ttt = true;
						this._mask = new Sprite();
						Utils.drawRect(this._mask,0,0,K1026035576CE979F9D4C27894EE6BDE6ED440D373566K,K102603F24F9BF3420149E3AC27B8EA7438E66E373566K,0,0);
						addChild(this._mask);
						this._swf.mask = this._mask;
					}
					if(K1026035576CE979F9D4C27894EE6BDE6ED440D373566K / K102603F24F9BF3420149E3AC27B8EA7438E66E373566K > this._width_num / this._height_num) {
						K1026037850482A38BE4ECEA65CBE571D4C215C373566K = this._width_num / K1026035576CE979F9D4C27894EE6BDE6ED440D373566K * K102603F24F9BF3420149E3AC27B8EA7438E66E373566K;
						K102603F8F23E0F3EBC4A268E1B5613E4FEC487373566K = this._width_num;
					} else if(K1026035576CE979F9D4C27894EE6BDE6ED440D373566K / K102603F24F9BF3420149E3AC27B8EA7438E66E373566K < this._width_num / this._height_num) {
						K102603F8F23E0F3EBC4A268E1B5613E4FEC487373566K = this._height_num / K102603F24F9BF3420149E3AC27B8EA7438E66E373566K * K1026035576CE979F9D4C27894EE6BDE6ED440D373566K;
						K1026037850482A38BE4ECEA65CBE571D4C215C373566K = this._height_num;
					} else {
						K102603F8F23E0F3EBC4A268E1B5613E4FEC487373566K = this._width_num;
						K1026037850482A38BE4ECEA65CBE571D4C215C373566K = this._height_num;
					}
					
					this._mask.scaleX = this._swf.scaleX = K102603F8F23E0F3EBC4A268E1B5613E4FEC487373566K / K1026035576CE979F9D4C27894EE6BDE6ED440D373566K;
					this._mask.scaleY = this._swf.scaleY = K1026037850482A38BE4ECEA65CBE571D4C215C373566K / K102603F24F9BF3420149E3AC27B8EA7438E66E373566K;
					this._mask.x = this._swf.x = Math.round(this._width_num - K102603F8F23E0F3EBC4A268E1B5613E4FEC487373566K) / 2;
					this._mask.y = this._swf.y = Math.round(this._height_num - K1026037850482A38BE4ECEA65CBE571D4C215C373566K) / 2;
				}
			}
			catch(evt:*) {
				trace("FlashCore resize" + evt);
			}
		}
		
		protected function setEleStatus() : void {
		}
		
		protected function dispatch(param1:String, param2:Object = null) : void {
			var _loc3_:MediaEvent = new MediaEvent(param1);
			_loc3_.obj = param2;
			dispatchEvent(_loc3_);
		}
		
		public function get filePlayedTime() : Number {
			return this._ns.time;
		}
		
		public function get fileTotTime() : Number {
			return this._fileTotTime;
		}
		
		public function get fileLoadedSize() : Number {
			return this._ns.bytesLoaded;
		}
		
		public function get fileTotSize() : Number {
			return this._ns.bytesTotal;
		}
		
		public function get volume() : Number {
			return this._volume;
		}
		
		public function set volume(param1:Number) : void {
			this._volume = param1;
		}
	}
}
