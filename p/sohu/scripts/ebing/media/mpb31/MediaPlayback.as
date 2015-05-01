package ebing.media.mpb31 {
	import com.greensock.*;
	import com.greensock.easing.*;
	import ebing.controls.*;
	import ebing.controls.s1.*;
	import ebing.events.*;
	import ebing.net.*;
	import ebing.utils.*;
	import flash.display.*;
	import flash.events.*;
	import flash.utils.*;
	import ebing.core.vc31.VideoCore;
	import ebing.Utils;
	import flash.ui.Mouse;
	
	public class MediaPlayback extends Sprite {
		
		public function MediaPlayback() {
			super();
		}
		
		protected var _width:Number;
		
		protected var _height:Number;
		
		protected var _parObj:Object;
		
		protected var _cover_c:Sprite;
		
		protected var _core;
		
		protected var _corePath:String = "";
		
		protected var _coverImgPath:String = "";
		
		protected var _skinPath:String = "";
		
		protected var _isHide:Boolean;
		
		protected var _seekTime:Number = 0;
		
		protected var _hardInitHandler:Function;
		
		protected var _progress_sld:SliderUtil;
		
		protected var _volume_sld:VolumeBar;
		
		protected var _play_btn:ButtonUtil;
		
		protected var _startPlay_btn:ButtonUtil;
		
		protected var _pause_btn:ButtonUtil;
		
		protected var _fullScreen_btn:ButtonUtil;
		
		protected var _normalScreen_btn:ButtonUtil;
		
		protected var _cinema_btn:ButtonUtil;
		
		protected var _window_btn:ButtonUtil;
		
		protected var _ctrlBarBg_spr;
		
		protected var _timeDisplay:Sprite;
		
		protected var _tipDisplay:Sprite;
		
		protected var _skin;
		
		protected var _skinData:XML;
		
		protected var _timeout_to:Timeout;
		
		protected var _hitArea_spr:Sprite;
		
		protected var _hideTween:TweenLite;
		
		protected var _showTween:TweenLite;
		
		protected var _showBar_boo:Boolean = false;
		
		private var K102606DCD83677FC334392AE66EF40F9806F81373569K:String = "";
		
		protected var _function:Function;
		
		protected var _fileNowTime:Number = 0;
		
		protected var _fileTotTime:Number = 0;
		
		protected var _ctrlBar_c:Sprite;
		
		protected var _skinMap:HashMap;
		
		protected var _isDrag:Boolean = true;
		
		protected var _tipTextTimeout:uint = 0;
		
		protected var _skinLoaderInfo:LoaderInfo;
		
		public function hardInit(param1:Object) : void {
			this._parObj = param1;
			this._width = this._parObj.width;
			this._height = this._parObj.height;
			this._corePath = this._parObj.core;
			this._isHide = this._parObj.isHide;
			this._skinPath = this._parObj.skinPath;
			this._hardInitHandler = this._parObj.hardInitHandler;
			this.registerUi();
			this.loadCore();
		}
		
		protected function sysInit(param1:String = null) : void {
			if(param1 == "start") {
				this.newFunc();
				this.drawSkin();
				this.addEvent();
				this._hardInitHandler({"info":"success"});
			}
			this._showBar_boo = false;
			this._seekTime = 0;
			if(this._skin != null) {
				this.playProgress({"obj":{
					"nowTime":0,
					"totTime":0,
					"isSeek":false
				}});
				this.loadProgress({"obj":{
					"nowSize":0,
					"totSize":0
				}});
				this._fullScreen_btn.enabled = false;
				this._normalScreen_btn.enabled = false;
				this._volume_sld.rate = this._core.volume;
			}
		}
		
		protected function addEvent() : void {
			this._core.addEventListener(MediaEvent.PLAY,this.onPlay);
			this._core.addEventListener(MediaEvent.PAUSE,this.onPause);
			this._core.addEventListener(MediaEvent.STOP,this.onStop);
			this._core.addEventListener(MediaEvent.START,this.onStart);
			this._core.addEventListener(MediaEvent.PLAYED,this.onPlayed);
			this._core.addEventListener(MediaEvent.FULL,this.bufferFull);
			this._core.addEventListener(MediaEvent.BUFFER_EMPTY,this.bufferEmpty);
			this._core.addEventListener(MediaEvent.PLAY_PROGRESS,this.playProgress);
			this._core.addEventListener(MediaEvent.LOAD_PROGRESS,this.loadProgress);
			this._core.addEventListener(MediaEvent.NOTFOUND,this.mediaNotfound);
			this._core.addEventListener(MediaEvent.DRAG_START,this.dragStart);
			this._core.addEventListener(MediaEvent.DRAG_END,this.dragEnd);
			this._core.addEventListener(MediaEvent.CONNECTING,this.mediaConnecting);
			this._startPlay_btn.addEventListener(MouseEventUtil.MOUSE_UP,this.startPlayMouseUp);
			this._play_btn.addEventListener(MouseEventUtil.MOUSE_UP,this.playMouseUp);
			this._pause_btn.addEventListener(MouseEventUtil.MOUSE_UP,this.pauseMouseUp);
			this._progress_sld.addEventListener(SliderEventUtil.SLIDER_RATE,this.progressSlide);
			this._progress_sld.addEventListener(SliderEventUtil.SLIDE_START,this.progressSlideStart);
			this._progress_sld.addEventListener(SliderEventUtil.SLIDE_END,this.progressSlideEnd);
			this._volume_sld.slider.addEventListener(SliderEventUtil.SLIDER_RATE,this.volumeSlide);
			this._volume_sld.slider.addEventListener(SliderEventUtil.SLIDE_END,this.volumeSlideEnd);
			this._fullScreen_btn.addEventListener(MouseEventUtil.CLICK,this.fullMouseClick);
			this._normalScreen_btn.addEventListener(MouseEventUtil.CLICK,this.exitFullMouseClick);
			this._hitArea_spr.addEventListener(MouseEvent.CLICK,this.hitAreaClick);
			this._hitArea_spr.addEventListener(MouseEvent.DOUBLE_CLICK,this.hitAreaDClick);
			this._ctrlBarBg_spr.addEventListener(MouseEvent.MOUSE_UP,this.ctrlBarBgUp);
			this._timeout_to.addEventListener(Timeout.TIMEOUT,this.hideBar);
			stage.addEventListener(FullScreenEvent.FULL_SCREEN,this.onFullScreenChange);
		}
		
		protected function loadCore() : void {
			this.coreHandler({
				"info":"success",
				"data":{"content":new VideoCore({
					"doInit":true,
					"width":this._width,
					"height":this._height,
					"buffer":this._parObj.buffer
				})}
			});
		}
		
		protected function coreHandler(param1:Object) : void {
			if(param1.info == "success") {
				this._core = param1.data.content;
				this.coreLoadSuccess();
			} else if(param1.info == "timeout") {
				this.coreLoadTimeout();
			} else {
				this.coreLoadIoError();
			}
			
		}
		
		protected function coreLoadSuccess() : void {
			trace("内核加载成功！");
			this._cover_c = new Sprite();
			addChild(this._core);
			this._core.x = this._core.y = 0;
			addChild(this._cover_c);
			this.loadSkin();
		}
		
		protected function coreLoadTimeout() : void {
			trace("内核加载超时！");
			this._hardInitHandler({"info":"timeout"});
		}
		
		protected function coreLoadIoError() : void {
			trace("内核加载IO错误！");
			this._hardInitHandler({"info":"ioerror"});
		}
		
		protected function onFullScreenChange(param1:FullScreenEvent) : void {
		}
		
		protected function volumeSlideEnd(param1:SliderEventUtil) : void {
			this._core.saveVolume();
		}
		
		protected function volumeSlide(param1:SliderEventUtil) : void {
			this._core.volume = param1.obj.rate;
		}
		
		protected function startPlayMouseUp(param1:MouseEventUtil) : void {
			this._core.play();
		}
		
		protected function playMouseUp(param1:MouseEventUtil) : void {
			this._core.play();
		}
		
		protected function pauseMouseUp(param1:MouseEventUtil) : void {
			this._core.pause(param1);
		}
		
		protected function progressSlide(param1:SliderEventUtil) : void {
			this.seek(param1);
		}
		
		protected function progressSlideStart(param1:SliderEventUtil) : void {
			this._core.sleep();
		}
		
		protected function progressSlideEnd(param1:SliderEventUtil) : void {
			this.seekEnd(param1);
		}
		
		protected function fullMouseClick(param1:MouseEventUtil = null) : void {
			this._core.changeScreenMode();
			this._skinMap.getValue("fullScreenBtn").e = this._skinMap.getValue("fullScreenBtn").v = false;
			this._skinMap.getValue("normalScreenBtn").e = this._skinMap.getValue("normalScreenBtn").v = true;
			this.setSkinState();
		}
		
		protected function exitFullMouseClick(param1:MouseEventUtil = null) : void {
			this._core.changeScreenMode();
			this._skinMap.getValue("fullScreenBtn").e = this._skinMap.getValue("fullScreenBtn").v = true;
			this._skinMap.getValue("normalScreenBtn").e = this._skinMap.getValue("normalScreenBtn").v = false;
			this.setSkinState();
		}
		
		protected function hitAreaClick(param1:MouseEvent) : void {
			this._core.playOrPause();
		}
		
		protected function hitAreaDClick(param1:MouseEvent) : void {
			this._hitArea_spr.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
			this._core.changeScreenMode();
		}
		
		public function seek(param1:* = null) : void {
			var _loc2_:Number = param1 is Number?param1:param1.obj.rate;
			var _loc3_:Number = this._core.fileTotTime;
			var _loc4_:Number = Math.round(_loc3_ * _loc2_);
			this._core.dispatch(MediaEvent.PLAY_PROGRESS,{
				"nowTime":_loc4_,
				"totTime":_loc3_,
				"isSeek":true
			});
			if(!(param1 is Number) && param1.obj.sign == 0) {
				if(Math.abs(_loc4_ - this._seekTime) >= 6) {
					this._seekTime = _loc4_;
					this._core.seek(this._seekTime,param1.obj.sign);
				}
			} else {
				this._seekTime = _loc4_;
				this._core.seek(this._seekTime);
			}
		}
		
		protected function seekEnd(param1:SliderEventUtil) : void {
			var _loc2_:* = false;
			var _loc3_:Object = param1.obj;
			if(_loc3_.sign == 0) {
				this.seek(_loc3_.rate);
			}
			_loc2_;
			_loc2_ = true;
			this._core.play();
		}
		
		protected function volumeSeek(param1:*) : void {
			this._core.volume = param1.target.volumeSliderRate;
		}
		
		protected function newFunc() : void {
			this._timeout_to = new Timeout(3);
		}
		
		public function resize(param1:Number, param2:Number) : void {
			var param1:Number = param1 < 0?1:param1;
			var param2:Number = param2 < 0?1:param2;
			var _loc3_:Number = param1;
			var _loc4_:Number = param2;
			this._width = param1;
			this._height = param2;
			if(stage.displayState == "fullScreen") {
				if(this._skin != null) {
					this.startTween();
				}
			} else if((this._isHide) && !(this._skin == null)) {
				this.startTween();
			} else if(this._skin != null) {
				_loc4_ = param2 - this.ctrlBarBg.height;
				this.stopTween();
			}
			
			
			this._core.resize(_loc3_,_loc4_);
			if(!(this._cover_c.width == 0) && !(this._cover_c.height == 0)) {
				Utils.prorata(this._cover_c,_loc3_,_loc4_);
				Utils.setCenter(this._cover_c,this._core);
			}
			this.setSkinState();
		}
		
		public function showCover() : void {
			trace("showCover method in MediaPlayback","_coverImgPath:" + this._coverImgPath,"_cover_c.numChildren:" + this._cover_c.numChildren);
			if(!(this._coverImgPath == "") && this._cover_c.numChildren == 0) {
				new LoaderUtil().load(3,function(param1:Object):void {
					if(param1.info == "success") {
						trace("coverimg load success");
						_cover_c.addChild(param1.data);
						_cover_c.visible = true;
						resize(_width,_height);
					}
				},null,this._coverImgPath);
			} else if(this._cover_c.numChildren > 0) {
				this._cover_c.visible = true;
			}
			
		}
		
		public function softInit(param1:Object) : void {
			var _loc2_:String = param1.filePath;
			var _loc3_:String = param1.fileTime;
			var _loc4_:String = param1.fileSize;
			var _loc5_:String = param1.skinPath;
			this._isDrag = param1.isDrag;
			this._coverImgPath = param1.cover;
			this._core.initMedia({
				"size":_loc4_,
				"time":_loc3_,
				"flv":_loc2_,
				"isDrag":this._isDrag
			});
		}
		
		protected function loadSkin(param1:String = "") : void {
			if(this._skin == null) {
				new LoaderUtil().load(20,this.skinHandler,null,param1 == ""?this._skinPath:param1);
			}
		}
		
		protected function registerUi() : void {
			this._skinMap = new HashMap();
			this.register("playBtn",{
				"e":true,
				"v":true
			});
			this.register("startPlayBtn",{
				"e":true,
				"v":true
			});
			this.register("pauseBtn",{
				"e":false,
				"v":false
			});
			this.register("progressBar",{
				"e":false,
				"v":true,
				"totTime":0
			});
			this.register("volumeBar",{
				"e":false,
				"v":true
			});
			this.register("fullScreenBtn",{
				"e":false,
				"v":true
			});
			this.register("normalScreenBtn",{
				"e":false,
				"v":false
			});
			this.register("hitAreaBtn",{
				"e":false,
				"v":true
			});
			this.register("lightBar",{
				"e":false,
				"v":true
			});
			this.register("timeDisplay",{
				"e":false,
				"v":true
			});
			this.register("tipDisplay",{
				"e":false,
				"v":false,
				"text":""
			});
		}
		
		protected function register(param1:String, param2:Object) : void {
			if(!this._skinMap.containsKey(param1)) {
				this._skinMap.put(param1,param2);
			}
		}
		
		protected function skinHandler(param1:Object) : void {
			if(param1.info == "success") {
				trace("皮肤加载成功!");
				if(this._skin != null) {
					this.removeSkin();
				}
				this._skin = param1.data.content;
				this._skinLoaderInfo = param1.loaderinfo;
				this.sysInit("start");
			} else if(param1.info == "timeout") {
				trace("皮肤加载超时!");
			} else {
				trace("皮肤加载IoError!");
			}
			
		}
		
		protected function removeSkin() : void {
		}
		
		protected function drawSkin() : void {
			var _loc6_:Object = null;
			var _loc11_:Object = null;
			var _loc12_:* = undefined;
			var _loc1_:Array = this._skinMap.keys();
			var _loc2_:uint = 0;
			while(_loc2_ < _loc1_.length) {
				for(_loc12_ in this._skin.status[_loc1_[_loc2_]]) {
					this._skinMap.getValue(_loc1_[_loc2_])[_loc12_] = this._skin.status[_loc1_[_loc2_]][_loc12_];
				}
				_loc2_++;
			}
			this._ctrlBarBg_spr = this._skin["ctrlBg_mc"];
			this._ctrlBarBg_spr.x = 0;
			this._ctrlBarBg_spr.y = 0;
			this._hitArea_spr = new Sprite();
			Utils.drawRect(this._hitArea_spr,0,0,this._width,this._height,16777215,0);
			this._hitArea_spr.buttonMode = this._hitArea_spr.useHandCursor = true;
			this._hitArea_spr.useHandCursor = true;
			this._play_btn = new ButtonUtil({"skin":this._skin["play_btn"]});
			this._startPlay_btn = new ButtonUtil({"skin":this._skin["startPlay_btn"]});
			this._pause_btn = new ButtonUtil({"skin":this._skin["pause_btn"]});
			this._fullScreen_btn = new ButtonUtil({"skin":this._skin["fullScreen_btn"]});
			this._normalScreen_btn = new ButtonUtil({"skin":this._skin["normalScreen_btn"]});
			this._cinema_btn = new ButtonUtil({"skin":this._skin["cinema_btn"]});
			this._window_btn = new ButtonUtil({"skin":this._skin["window_btn"]});
			this._timeDisplay = this._skin["time_mc"];
			this._tipDisplay = this._skin["status_mc"];
			var _loc3_:ButtonUtil = new ButtonUtil({"skin":this._skin["pro_btn"]});
			var _loc4_:ButtonUtil = new ButtonUtil({"skin":this._skin["forward_btn"]});
			var _loc5_:ButtonUtil = new ButtonUtil({"skin":this._skin["back_btn"]});
			_loc6_ = {
				"top":this._skin["proTop_mc"],
				"middle":this._skin["proMiddle_mc"],
				"bottom":this._skin["proBottom_mc"],
				"dollop":_loc3_
			};
			this._progress_sld = new SliderUtil({
				"skin":_loc6_,
				"isDrag":this._isDrag
			});
			var _loc7_:ButtonUtil = new ButtonUtil({"skin":this._skin["muteVol_btn"]});
			var _loc8_:ButtonUtil = new ButtonUtil({"skin":this._skin["comebackVol_btn"]});
			var _loc9_:ButtonUtil = new ButtonUtil({"skin":this._skin["dollopVol_btn"]});
			var _loc10_:ButtonUtil = new ButtonUtil({"skin":this._skin["continueVol_btn"]});
			_loc11_ = {
				"top":this._skin["volTop_mc"],
				"middle":this._skin["volMiddle_mc"],
				"bottom":this._skin["volBottom_mc"],
				"previewTip":this._skin["volPeviewTip_mc"],
				"dollop":_loc9_,
				"muteBtn":_loc7_,
				"comebackBtn":_loc8_
			};
			this._volume_sld = new VolumeBar({"skin":_loc11_});
			this._ctrlBar_c = new Sprite();
			addChild(this._hitArea_spr);
			this._ctrlBar_c.addChild(this._ctrlBarBg_spr);
			this._ctrlBar_c.addChild(this._pause_btn);
			this._ctrlBar_c.addChild(this._play_btn);
			this._ctrlBar_c.addChild(this._normalScreen_btn);
			this._ctrlBar_c.addChild(this._fullScreen_btn);
			this._ctrlBar_c.addChild(this._progress_sld);
			this._ctrlBar_c.addChild(this._volume_sld);
			this._ctrlBar_c.addChild(this._tipDisplay);
			this._ctrlBar_c.addChild(this._timeDisplay);
			this._ctrlBar_c.addChild(this._cinema_btn);
			this._ctrlBar_c.addChild(this._window_btn);
			this._ctrlBar_c.addChild(this._startPlay_btn);
			addChild(this._ctrlBar_c);
			this.resize(this._width,this._height);
		}
		
		protected function tipText(param1:String, param2:uint = 0) : void {
			var msg:String = param1;
			var timeout:uint = param2;
			if(msg != "") {
				this._tipDisplay["status_txt"].text = msg;
				this._tipDisplay.visible = true;
				if(timeout > 0) {
					clearTimeout(this._tipTextTimeout);
					this._tipTextTimeout = setTimeout(function():void {
						tipText("");
					},timeout * 1000);
				}
			} else {
				this._tipDisplay.visible = false;
			}
		}
		
		protected function setSkinState() : void {
			var _loc1_:Object = null;
			var _loc2_:* = NaN;
			var _loc3_:* = NaN;
			if(this._skin != null) {
				_loc1_ = new Object();
				this._hitArea_spr.width = this._core.width;
				this._hitArea_spr.height = this._core.height;
				this._hitArea_spr.x = this._core.x;
				this._hitArea_spr.y = this._core.y;
				_loc2_ = this._hitArea_spr.width - this._ctrlBarBg_spr.width;
				_loc3_ = this._ctrlBarBg_spr.width = this._hitArea_spr.width;
				this._ctrlBarBg_spr.y = 0;
				this._ctrlBar_c.x = this._hitArea_spr.x;
				if(!this._showBar_boo) {
					this._ctrlBar_c.y = this._hitArea_spr.y + this._hitArea_spr.height;
				} else {
					this._ctrlBar_c.y = this._hitArea_spr.y + this._hitArea_spr.height - this._ctrlBarBg_spr.height;
				}
				_loc1_ = this._skinMap.getValue("playBtn");
				this._play_btn.x = _loc1_.x = _loc1_.x + (_loc1_.r?_loc2_:0);
				this._play_btn.y = _loc1_.y;
				this._play_btn.visible = (_loc1_.v) && _loc3_ > _loc1_.w;
				this._play_btn.enabled = _loc1_.e;
				_loc1_ = this._skinMap.getValue("startPlayBtn");
				this._startPlay_btn.x = 10;
				this._startPlay_btn.y = -this._startPlay_btn.height - 10;
				this._startPlay_btn.visible = (_loc1_.v) && _loc3_ > _loc1_.w;
				this._startPlay_btn.enabled = _loc1_.e;
				_loc1_ = this._skinMap.getValue("pauseBtn");
				this._pause_btn.x = _loc1_.x = _loc1_.x + (_loc1_.r?_loc2_:0);
				this._pause_btn.y = _loc1_.y;
				this._pause_btn.visible = (_loc1_.v) && _loc3_ > _loc1_.w;
				this._pause_btn.enabled = _loc1_.e;
				_loc1_ = this._skinMap.getValue("progressBar");
				this._progress_sld.x = _loc1_.x = _loc1_.x + (_loc1_.r?_loc2_:0);
				this._progress_sld.y = _loc1_.y;
				this._progress_sld.resize(this._progress_sld.width + _loc2_);
				this._progress_sld.enabled = _loc1_.e;
				this._progress_sld.topRate = _loc1_.topRate;
				_loc1_ = this._skinMap.getValue("timeDisplay");
				this._timeDisplay.x = _loc1_.x = _loc1_.x + (_loc1_.r?_loc2_:0);
				this._timeDisplay.y = _loc1_.y;
				_loc1_ = this._skinMap.getValue("tipDisplay");
				this._tipDisplay.x = _loc1_.x = _loc1_.x + (_loc1_.r?_loc2_:0);
				this._tipDisplay.y = _loc1_.y;
				this._tipDisplay.visible = (_loc1_.v) && _loc3_ > _loc1_.w;
				this._tipDisplay["status_txt"].text = _loc1_.text == null?"":_loc1_.text;
				_loc1_ = this._skinMap.getValue("volumeBar");
				this._volume_sld.x = _loc1_.x = _loc1_.x + (_loc1_.r?_loc2_:0);
				this._volume_sld.y = _loc1_.y;
				this._volume_sld.visible = (_loc1_.v) && _loc3_ > _loc1_.w;
				this._volume_sld.enabled = _loc1_.e;
				_loc1_ = this._skinMap.getValue("fullScreenBtn");
				this._fullScreen_btn.x = _loc1_.x = _loc1_.x + (_loc1_.r?_loc2_:0);
				this._fullScreen_btn.y = _loc1_.y;
				this._fullScreen_btn.visible = (_loc1_.v) && _loc3_ > _loc1_.w;
				this._fullScreen_btn.enabled = _loc1_.e;
				_loc1_ = this._skinMap.getValue("normalScreenBtn");
				this._normalScreen_btn.x = _loc1_.x = _loc1_.x + (_loc1_.r?_loc2_:0);
				this._normalScreen_btn.y = _loc1_.y;
				this._normalScreen_btn.visible = (_loc1_.v) && _loc3_ > _loc1_.w;
				this._normalScreen_btn.enabled = _loc1_.e;
			}
		}
		
		protected function hideBar(param1:*) : void {
			var evt:* = param1;
			if(this._skin != null) {
				if(!this._ctrlBarBg_spr.hitTestPoint(stage.mouseX,stage.mouseY + 2)) {
					Mouse.hide();
					this._hideTween = TweenLite.to(this._ctrlBar_c,0.5,{
						"y":this._height,
						"ease":Quad.easeOut,
						"onComplete":function():void {
							_showBar_boo = false;
						}
					});
				}
			}
		}
		
		protected function showBar(param1:MouseEvent) : void {
			if(this._skin != null) {
				this._timeout_to.restart();
				Mouse.show();
				if(!this._showBar_boo) {
					this._showBar_boo = true;
					this._showTween = TweenLite.to(this._ctrlBar_c,0.5,{
						"y":this._height - this._ctrlBarBg_spr.height,
						"ease":Quad.easeOut
					});
				}
			}
		}
		
		protected function startTween() : void {
			if(!this.hasEventListener(MouseEvent.MOUSE_MOVE)) {
				this.addEventListener(MouseEvent.MOUSE_MOVE,this.showBar);
				this._timeout_to.start();
			}
		}
		
		protected function stopTween() : void {
			this._timeout_to.stop();
			this.removeEventListener(MouseEvent.MOUSE_MOVE,this.showBar);
			this._showBar_boo = false;
			Mouse.show();
			try {
				TweenLite.killTweensOf(this._ctrlBar_c);
			}
			catch(evt:Error) {
				trace("MediaPlayback stopTween");
			}
		}
		
		protected function onPlay(param1:Event) : void {
			this._skinMap.getValue("playBtn").v = this._skinMap.getValue("playBtn").e = false;
			this._skinMap.getValue("pauseBtn").v = this._skinMap.getValue("pauseBtn").e = true;
			this._skinMap.getValue("startPlayBtn").v = this._skinMap.getValue("startPlayBtn").e = false;
			this._skinMap.getValue("tipDisplay").text = "";
			this._skinMap.getValue("tipDisplay").v = false;
			this.setSkinState();
		}
		
		protected function onPause(param1:Event) : void {
			this._skinMap.getValue("playBtn").v = this._skinMap.getValue("playBtn").e = true;
			this._skinMap.getValue("pauseBtn").v = this._skinMap.getValue("pauseBtn").e = false;
			this._skinMap.getValue("startPlayBtn").v = this._skinMap.getValue("startPlayBtn").e = true;
			this._skinMap.getValue("tipDisplay").v = false;
			this._skinMap.getValue("tipDisplay").text = "";
			this.setSkinState();
		}
		
		protected function onStop(param1:* = "") : void {
			this._skinMap.getValue("playBtn").v = this._skinMap.getValue("playBtn").e = true;
			this._skinMap.getValue("pauseBtn").v = this._skinMap.getValue("pauseBtn").e = false;
			this._skinMap.getValue("startPlayBtn").v = this._skinMap.getValue("startPlayBtn").e = true;
			this._skinMap.getValue("tipDisplay").v = true;
			this.setSkinState();
			this.sysInit();
		}
		
		protected function onStart(param1:Event = null) : void {
			this._cover_c.visible = false;
			var _loc2_:String = stage.displayState;
			this._skinMap.getValue("progressBar").e = true;
			this._skinMap.getValue("volumeBar").e = true;
			this._skinMap.getValue("playBtn").e = true;
			this._skinMap.getValue("pauseBtn").e = true;
			this.setSkinState();
		}
		
		protected function onPlayed(param1:Event = null) : void {
			this._skinMap.getValue("tipDisplay").v = false;
			this.onStart();
		}
		
		protected function bufferEmpty(param1:Event) : void {
		}
		
		protected function bufferFull(param1:Event) : void {
			this._skinMap.getValue("tipDisplay").v = false;
			this._skinMap.getValue("tipDisplay").text = "";
			this.setSkinState();
		}
		
		protected function dragStart(param1:* = null) : void {
			this._skinMap.getValue("progressBar").e = false;
			this.setSkinState();
		}
		
		protected function dragEnd(param1:* = null) : void {
			this._skinMap.getValue("progressBar").e = true;
			this.setSkinState();
		}
		
		protected function playProgress(param1:*) : void {
			this._skinMap.getValue("progressBar").totTime = param1.obj.totTime;
			if(this._skin != null) {
				if(!param1.obj.isSeek) {
					this._progress_sld.topRate = param1.obj.nowTime / param1.obj.totTime;
				}
				this._timeDisplay["time_txt"].text = Utils.fomatTime(Math.round(param1.obj.nowTime)) + "/" + Utils.fomatTime(Math.floor(param1.obj.totTime));
			}
		}
		
		protected function loadProgress(param1:*) : void {
			if(this._skin != null) {
				this._progress_sld.middleRate = param1.obj.nowSize / param1.obj.totSize;
			}
		}
		
		protected function mediaNotfound(param1:*) : void {
			this._skinMap.getValue("tipDisplay").text = "";
			this._skinMap.getValue("tipDisplay").v = true;
			this.setSkinState();
		}
		
		protected function mediaConnecting(param1:*) : void {
		}
		
		protected function ctrlBarBgUp(param1:MouseEvent) : void {
		}
		
		public function get ctrlBarBg() : DisplayObject {
			return this._ctrlBarBg_spr;
		}
		
		public function get isHide() : Boolean {
			return this._isHide;
		}
		
		public function set isDrag(param1:Boolean) : void {
			this._isDrag = param1;
			if(this._skin != null) {
				this._progress_sld.isDrag = param1;
			}
		}
		
		public function get core() : * {
			return this._core;
		}
	}
}
