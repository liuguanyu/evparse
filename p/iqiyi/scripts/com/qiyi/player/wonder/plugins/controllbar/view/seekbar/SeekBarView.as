package com.qiyi.player.wonder.plugins.controllbar.view.seekbar {
	import flash.display.Sprite;
	import controllbar.SeekBarBg;
	import flash.display.Shape;
	import controllbar.BackWardBtn;
	import controllbar.ForWardBtn;
	import controllbar.Slider;
	import com.qiyi.player.wonder.common.status.Status;
	import com.qiyi.player.wonder.plugins.controllbar.view.preview.ImagePreview;
	import flash.utils.Timer;
	import com.qiyi.player.core.model.ISkipPointInfo;
	import flash.display.SimpleButton;
	import com.iqiyi.components.global.GlobalStage;
	import gs.TweenLite;
	import com.qiyi.player.wonder.plugins.controllbar.ControllBarDef;
	import flash.events.MouseEvent;
	import com.qiyi.player.core.model.impls.FocusTip;
	import com.qiyi.player.wonder.plugins.controllbar.view.ControllBarEvent;
	import com.qiyi.player.wonder.plugins.controllbar.view.preview.image.PreviewImageLoader;
	import flash.geom.Point;
	import com.qiyi.player.wonder.common.pingback.PingBack;
	import com.qiyi.player.wonder.common.pingback.PingBackDef;
	import flash.events.TimerEvent;
	
	public class SeekBarView extends Sprite {
		
		public function SeekBarView(param1:Status) {
			this._imagePrePicUrlArr = [];
			this._viewPoints = new Vector.<FocusPoint>();
			this._merchandiseViewPoints = new Vector.<FocusPoint>();
			this._videoHeadTailTipPanel = new VideoHeadTailTipPanel();
			super();
			this._status = param1;
			this._timer = new Timer(40);
			this._seekBarBg = new SeekBarBg();
			this._seekBarBg.useHandCursor = this._seekBarBg.buttonMode = true;
			this._playBar = new Shape();
			this._loadBar = new Shape();
			this._filterShape = new Shape();
			this._mouseMoveShape = new Shape();
			this._backWardBtn = new BackWardBtn();
			this._forWardBtn = new ForWardBtn();
			this._slider = new Slider();
			this._slider.useHandCursor = this._slider.buttonMode = true;
			this._slider.mouseChildren = this._slider.mouseEnabled = false;
			this._forWardBtn.addEventListener(MouseEvent.MOUSE_DOWN,this.onForWardBtnMouseDown);
			this._backWardBtn.addEventListener(MouseEvent.MOUSE_DOWN,this.onBackWardBtnMouseDown);
			this._seekBarBg.addEventListener(MouseEvent.MOUSE_DOWN,this.onSeekBarBgDown);
			this._seekBarBg.addEventListener(MouseEvent.CLICK,this.onSeekBarBgClick);
			this._seekBarBg.addEventListener(MouseEvent.MOUSE_MOVE,this.onSeekBarBgMouseMove);
			this._seekBarBg.addEventListener(MouseEvent.ROLL_OVER,this.onSeekBarBgRollOver);
			this._seekBarBg.addEventListener(MouseEvent.ROLL_OUT,this.onSeekBarBgRollOut);
			this.initUI();
			this.onResize(GlobalStage.stage.stageWidth,GlobalStage.stage.stageHeight);
		}
		
		private static const BAR_NARROW_Y:int = 7;
		
		private static const BAR_WIDE_Y:int = -6;
		
		private static const TIME_WIDE:Number = 0.5;
		
		private static const TIME_NARROW:Number = 0.3;
		
		private static const FILTER_COLOUR:uint = 11879694;
		
		private var _seekBarBg:SeekBarBg;
		
		private var _playBar:Shape;
		
		private var _loadBar:Shape;
		
		private var _backWardBtn:BackWardBtn;
		
		private var _forWardBtn:ForWardBtn;
		
		private var _slider:Slider;
		
		private var _totalTime:int = 1;
		
		private var _currentTime:int;
		
		private var _bufferTime:int;
		
		private var _imagePrePicUrlArr:Array;
		
		private var _mouseDowned:Boolean = false;
		
		private var _mouseMoved:Boolean = false;
		
		private var _status:Status;
		
		private var _focusPointHead:FocusPoint = null;
		
		private var _focusPointTail:FocusPoint = null;
		
		private var _viewPoints:Vector.<FocusPoint>;
		
		private var _merchandiseViewPoints:Vector.<FocusPoint>;
		
		private var _videoHeadTailTipPanel:VideoHeadTailTipPanel;
		
		private var _imagePreview:ImagePreview;
		
		private var _timer:Timer;
		
		private var _seekCount:int = 0;
		
		private var _seekBtnDowned:Boolean = false;
		
		private var _seekTime:int;
		
		private var _seekClickCount:int;
		
		private var _isAlreadyLoadImageData:Boolean;
		
		private var _isMouseIn:Boolean = false;
		
		private var _filterData:Vector.<ISkipPointInfo>;
		
		private var _filterShape:Shape;
		
		private var _mouseMoveShape:Shape;
		
		public function get isMouseIn() : Boolean {
			return this._isMouseIn;
		}
		
		public function get forWardBtn() : SimpleButton {
			return this._forWardBtn;
		}
		
		public function get backWardBtn() : SimpleButton {
			return this._backWardBtn;
		}
		
		public function get seekTime() : int {
			return this._seekTime;
		}
		
		public function set seekTime(param1:int) : void {
			this._seekTime = param1;
		}
		
		public function get totalTime() : int {
			return this._totalTime;
		}
		
		public function get currentTime() : int {
			return this._currentTime;
		}
		
		public function get videoHeadTailTipPanel() : VideoHeadTailTipPanel {
			return this._videoHeadTailTipPanel;
		}
		
		public function get seekClickCount() : int {
			return this._seekClickCount;
		}
		
		public function onAddStatus(param1:int) : void {
			switch(param1) {
				case ControllBarDef.STATUS_SEEK_BAR_SHOW:
					this.visible = true;
					this.onResize(GlobalStage.stage.stageWidth,GlobalStage.stage.stageHeight);
					break;
				case ControllBarDef.STATUS_SEEK_BAR_THICK:
					this.killAllTweens();
					TweenLite.to(this._seekBarBg,TIME_WIDE,{
						"y":BAR_WIDE_Y,
						"height":ControllBarDef.BAR_WIDTH_WIDE,
						"onUpdate":this.onBarBgHeightChange,
						"onComplete":this.onSeekBarBgBlowUpComplete
					});
					break;
			}
		}
		
		public function onRemoveStatus(param1:int) : void {
			switch(param1) {
				case ControllBarDef.STATUS_SEEK_BAR_SHOW:
					this.visible = false;
					break;
				case ControllBarDef.STATUS_SEEK_BAR_THICK:
					this.killAllTweens();
					TweenLite.to(this._slider,TIME_NARROW,{"alpha":0});
					TweenLite.to(this._backWardBtn,TIME_NARROW,{
						"alpha":0,
						"x":-this._backWardBtn.width
					});
					TweenLite.to(this._forWardBtn,TIME_NARROW,{
						"alpha":0,
						"x":GlobalStage.stage.stageWidth
					});
					TweenLite.to(this._seekBarBg,TIME_NARROW,{
						"x":0,
						"width":GlobalStage.stage.stageWidth,
						"onUpdate":this.onBarBgHeightChange,
						"onComplete":this.onSeekBarBgLessenComplete
					});
					break;
			}
		}
		
		private function onBarBgHeightChange() : void {
			this.drawPlayBar(this._seekBarBg.x,this._seekBarBg.y,1 * this._seekBarBg.width * this._currentTime / this._totalTime,this._seekBarBg.height);
			this.drawLoadBar(this._seekBarBg.x,this._seekBarBg.y,1 * this._seekBarBg.width * this._bufferTime / this._totalTime,this._seekBarBg.height);
			this.drawFilterBar();
			if(this._focusPointHead) {
				this.onResizePoint(this._focusPointHead);
			}
			if(this._focusPointTail) {
				this.onResizePoint(this._focusPointTail);
			}
			var _loc1_:* = 0;
			while(_loc1_ < this._viewPoints.length) {
				this.onResizePoint(this._viewPoints[_loc1_]);
				_loc1_++;
			}
			var _loc2_:* = 0;
			while(_loc2_ < this._merchandiseViewPoints.length) {
				this.onResizePoint(this._merchandiseViewPoints[_loc2_]);
				_loc2_++;
			}
		}
		
		private function onSeekBarBgBlowUpComplete() : void {
			this.killAllTweens();
			TweenLite.to(this._seekBarBg,TIME_NARROW,{
				"x":this._backWardBtn.width,
				"width":GlobalStage.stage.stageWidth - this._backWardBtn.width * 2,
				"onUpdate":this.onBarBgHeightChange
			});
			TweenLite.to(this._slider,TIME_NARROW,{"alpha":1});
			TweenLite.to(this._backWardBtn,TIME_NARROW,{
				"alpha":1,
				"x":0
			});
			TweenLite.to(this._forWardBtn,TIME_NARROW,{
				"alpha":1,
				"x":GlobalStage.stage.stageWidth - this._forWardBtn.width,
				"onComplete":this.exResize,
				"onCompleteParams":[GlobalStage.stage.stageWidth,GlobalStage.stage.stageHeight]
			});
		}
		
		private function onSeekBarBgLessenComplete() : void {
			this.killAllTweens();
			TweenLite.to(this._seekBarBg,TIME_WIDE,{
				"y":BAR_NARROW_Y,
				"height":ControllBarDef.BAR_WIDTH_NARROW,
				"onUpdate":this.onBarBgHeightChange,
				"onComplete":this.exResize,
				"onCompleteParams":[GlobalStage.stage.stageWidth,GlobalStage.stage.stageHeight]
			});
		}
		
		private function drawPlayBar(param1:Number, param2:Number, param3:Number, param4:Number) : void {
			this._playBar.graphics.clear();
			this._playBar.graphics.beginFill(6523662,0.8);
			this._playBar.graphics.drawRect(param1,param2,param3 < 0?0:param3,param4);
			this._playBar.graphics.endFill();
		}
		
		private function drawLoadBar(param1:Number, param2:Number, param3:Number, param4:Number) : void {
			this._loadBar.graphics.clear();
			this._loadBar.graphics.beginFill(9671571,0.6);
			this._loadBar.graphics.drawRect(param1,param2,param3,param4);
			this._loadBar.graphics.endFill();
		}
		
		private function drawFilterBar() : void {
			var _loc1_:uint = 0;
			if(!(this._filterData == null) && this._filterData.length > 0) {
				this._filterShape.graphics.clear();
				this._filterShape.graphics.beginFill(FILTER_COLOUR,0.6);
				_loc1_ = 0;
				while(_loc1_ < this._filterData.length) {
					this.resizeSkipPart(this._filterData[_loc1_]);
					_loc1_++;
				}
				this._filterShape.graphics.endFill();
			}
		}
		
		private function killAllTweens() : void {
			TweenLite.killTweensOf(this._slider);
			TweenLite.killTweensOf(this._backWardBtn);
			TweenLite.killTweensOf(this._forWardBtn);
			TweenLite.killTweensOf(this._seekBarBg);
		}
		
		public function setHeadTailPoint(param1:int, param2:int) : void {
			if((this._focusPointHead) && (this._focusPointHead.parent)) {
				this._focusPointHead.removeEventListener(MouseEvent.ROLL_OVER,this.onFocusPointHeadTailRollOver);
				this._focusPointHead.removeEventListener(MouseEvent.ROLL_OUT,this.onFocusPointHeadTailRollOut);
				removeChild(this._focusPointHead);
			}
			if((this._focusPointTail) && (this._focusPointTail.parent)) {
				this._focusPointTail.removeEventListener(MouseEvent.ROLL_OVER,this.onFocusPointHeadTailRollOver);
				this._focusPointTail.removeEventListener(MouseEvent.ROLL_OUT,this.onFocusPointHeadTailRollOut);
				removeChild(this._focusPointTail);
			}
			if(param1 > 0) {
				this._focusPointHead = new FocusPoint();
				this._focusPointHead.buttonMode = true;
				this._focusPointHead.useHandCursor = true;
				this._focusPointHead.time = param1;
				this._focusPointHead.addEventListener(MouseEvent.ROLL_OVER,this.onFocusPointHeadTailRollOver);
				this._focusPointHead.addEventListener(MouseEvent.ROLL_OUT,this.onFocusPointHeadTailRollOut);
				addChild(this._focusPointHead);
			}
			if(param2 > 0) {
				this._focusPointTail = new FocusPoint();
				this._focusPointTail.buttonMode = true;
				this._focusPointTail.useHandCursor = true;
				this._focusPointTail.time = param2;
				this._focusPointTail.addEventListener(MouseEvent.ROLL_OVER,this.onFocusPointHeadTailRollOver);
				this._focusPointTail.addEventListener(MouseEvent.ROLL_OUT,this.onFocusPointHeadTailRollOut);
				addChild(this._focusPointTail);
			}
		}
		
		public function setViewPoints(param1:Vector.<FocusTip>) : void {
			var _loc3_:* = 0;
			var _loc4_:FocusPoint = null;
			var _loc2_:* = 0;
			if(this._viewPoints) {
				_loc3_ = this._viewPoints.length;
				_loc2_ = 0;
				while(_loc2_ < _loc3_) {
					this._viewPoints[_loc2_].removeEventListener(MouseEvent.ROLL_OVER,this.onViewPointRollOver);
					this._viewPoints[_loc2_].removeEventListener(MouseEvent.ROLL_OUT,this.onViewPointRollOut);
					this._viewPoints[_loc2_].addEventListener(MouseEvent.CLICK,this.onViewPointClick);
					removeChild(this._viewPoints[_loc2_]);
					_loc2_++;
				}
				this._viewPoints = new Vector.<FocusPoint>();
			}
			if(!(param1 == null) && param1.length > 0) {
				_loc2_ = 0;
				while(_loc2_ < param1.length) {
					_loc4_ = new FocusPoint();
					_loc4_.buttonMode = true;
					_loc4_.useHandCursor = true;
					_loc4_.time = param1[_loc2_].timestamp;
					_loc4_.content = param1[_loc2_].content;
					_loc4_.addEventListener(MouseEvent.ROLL_OVER,this.onViewPointRollOver);
					_loc4_.addEventListener(MouseEvent.ROLL_OUT,this.onViewPointRollOut);
					_loc4_.addEventListener(MouseEvent.CLICK,this.onViewPointClick);
					this._viewPoints.push(_loc4_);
					addChild(_loc4_);
					_loc2_++;
				}
			}
		}
		
		public function setMerchandiseViewPoints(param1:Array) : void {
			var _loc3_:* = 0;
			var _loc4_:FocusPoint = null;
			var _loc2_:* = 0;
			if(this._merchandiseViewPoints) {
				_loc3_ = this._merchandiseViewPoints.length;
				_loc2_ = 0;
				while(_loc2_ < _loc3_) {
					this._merchandiseViewPoints[_loc2_].removeEventListener(MouseEvent.ROLL_OVER,this.onViewPointRollOver);
					this._merchandiseViewPoints[_loc2_].removeEventListener(MouseEvent.ROLL_OUT,this.onViewPointRollOut);
					this._merchandiseViewPoints[_loc2_].addEventListener(MouseEvent.CLICK,this.onViewPointClick);
					removeChild(this._merchandiseViewPoints[_loc2_]);
					_loc2_++;
				}
				this._merchandiseViewPoints = new Vector.<FocusPoint>();
			}
			if(!(param1 == null) && param1.length > 0) {
				_loc2_ = 0;
				while(_loc2_ < param1.length) {
					_loc4_ = new FocusPoint();
					_loc4_.buttonMode = true;
					_loc4_.useHandCursor = true;
					_loc4_.time = Number(param1[_loc2_].startTime) * 1000;
					_loc4_.content = param1[_loc2_].promotion;
					_loc4_.imgUrl = param1[_loc2_].imgUrl;
					_loc4_.goodsUrl = param1[_loc2_].detailUrl;
					_loc4_.addEventListener(MouseEvent.ROLL_OVER,this.onViewPointRollOver);
					_loc4_.addEventListener(MouseEvent.ROLL_OUT,this.onViewPointRollOut);
					_loc4_.addEventListener(MouseEvent.CLICK,this.onViewPointClick);
					this._merchandiseViewPoints.push(_loc4_);
					addChild(_loc4_);
					_loc2_++;
				}
			}
		}
		
		public function setSkipPoints(param1:Vector.<ISkipPointInfo>) : void {
			this._filterData = param1;
			if(this._filterData) {
				this._filterShape.visible = false;
				this._loadBar.visible = true;
			} else {
				this._filterShape.visible = true;
				this._loadBar.visible = false;
			}
			this.onResize(GlobalStage.stage.stageWidth,GlobalStage.stage.stageHeight);
		}
		
		public function onResize(param1:int, param2:int) : void {
			this.killAllTweens();
			this.exResize(param1,param2);
			this._imagePreview.onResize(param1,param2);
		}
		
		private function exResize(param1:int, param2:int) : void {
			var _loc3_:* = 0;
			var _loc4_:* = 0;
			var _loc5_:uint = 0;
			if(this._status.hasStatus(ControllBarDef.STATUS_SEEK_BAR_THICK)) {
				this._slider.alpha = this._forWardBtn.alpha = this._backWardBtn.alpha = 1;
				this._backWardBtn.x = 0;
				this._seekBarBg.x = this._backWardBtn.width;
				this._seekBarBg.y = BAR_WIDE_Y;
				this._seekBarBg.width = param1 - this._backWardBtn.width * 2;
				this._seekBarBg.height = ControllBarDef.BAR_WIDTH_WIDE;
				this.drawLoadBar(this._seekBarBg.x,this._seekBarBg.y,1 * this._seekBarBg.width * this._bufferTime / this._totalTime,this._seekBarBg.height);
				this.drawPlayBar(this._seekBarBg.x,this._seekBarBg.y,1 * this._seekBarBg.width * this._currentTime / this._totalTime,this._seekBarBg.height);
				this._slider.x = this._seekBarBg.x + this._playBar.width - this._slider.width / 2;
				this._forWardBtn.x = param1 - this._forWardBtn.width;
				this.checkSliderBorder();
				if(this._focusPointHead) {
					this.onResizePoint(this._focusPointHead);
				}
				if(this._focusPointTail) {
					this.onResizePoint(this._focusPointTail);
				}
				_loc3_ = 0;
				while(_loc3_ < this._viewPoints.length) {
					this.onResizePoint(this._viewPoints[_loc3_]);
					_loc3_++;
				}
				_loc4_ = 0;
				while(_loc4_ < this._merchandiseViewPoints.length) {
					this.onResizePoint(this._merchandiseViewPoints[_loc4_]);
					_loc4_++;
				}
				if(!(this._filterData == null) && this._filterData.length > 0) {
					this._filterShape.graphics.clear();
					this._filterShape.graphics.beginFill(FILTER_COLOUR,0.6);
					_loc5_ = 0;
					while(_loc5_ < this._filterData.length) {
						this.resizeSkipPart(this._filterData[_loc5_]);
						_loc5_++;
					}
					this._filterShape.graphics.endFill();
				}
			} else {
				this._backWardBtn.x = -this._backWardBtn.width;
				this._seekBarBg.x = 0;
				this._seekBarBg.y = BAR_NARROW_Y;
				this._seekBarBg.width = param1;
				this._seekBarBg.height = ControllBarDef.BAR_WIDTH_NARROW;
				this.drawLoadBar(this._seekBarBg.x,this._seekBarBg.y,1 * this._seekBarBg.width * this._bufferTime / this._totalTime,this._seekBarBg.height);
				this.drawPlayBar(this._seekBarBg.x,this._seekBarBg.y,1 * this._seekBarBg.width * this._currentTime / this._totalTime,this._seekBarBg.height);
				this._forWardBtn.x = param1;
				this._slider.alpha = 0;
				if(this._focusPointHead) {
					this.onResizePoint(this._focusPointHead);
				}
				if(this._focusPointTail) {
					this.onResizePoint(this._focusPointTail);
				}
				_loc3_ = 0;
				while(_loc3_ < this._viewPoints.length) {
					this.onResizePoint(this._viewPoints[_loc3_]);
					_loc3_++;
				}
				_loc4_ = 0;
				while(_loc4_ < this._merchandiseViewPoints.length) {
					this.onResizePoint(this._merchandiseViewPoints[_loc4_]);
					_loc4_++;
				}
				if(!(this._filterData == null) && this._filterData.length > 0) {
					this._filterShape.graphics.clear();
					this._filterShape.graphics.beginFill(FILTER_COLOUR,0.6);
					_loc5_ = 0;
					while(_loc5_ < this._filterData.length) {
						this.resizeSkipPart(this._filterData[_loc5_]);
						_loc5_++;
					}
					this._filterShape.graphics.endFill();
				}
			}
		}
		
		public function setTotalTime(param1:int) : void {
			this._totalTime = param1;
		}
		
		public function setImagePrePicUrlArr(param1:Array) : void {
			this._imagePrePicUrlArr = param1;
			this._isAlreadyLoadImageData = false;
			if(this._imagePrePicUrlArr.length > 0) {
				this._imagePreview.isHavImageData = true;
			} else {
				this._imagePreview.isHavImageData = false;
			}
		}
		
		public function setCurrentTime(param1:int) : void {
			this._currentTime = param1;
		}
		
		public function onPlayerRunning(param1:int, param2:int, param3:Boolean = false) : void {
			this._currentTime = param1;
			this._bufferTime = param2;
			if(this._status.hasStatus(ControllBarDef.STATUS_SEEK_BAR_THICK)) {
				this.drawLoadBar(this._seekBarBg.x,this._seekBarBg.y,1 * this._seekBarBg.width * this._bufferTime / this._totalTime,this._seekBarBg.height);
				if(!this._mouseMoved && !this._seekBtnDowned && !param3) {
					this.drawPlayBar(this._seekBarBg.x,this._seekBarBg.y,1 * this._seekBarBg.width * this._currentTime / this._totalTime,this._seekBarBg.height);
				}
				if(!this._mouseDowned && !this._seekBtnDowned && !param3) {
					this._slider.x = this._seekBarBg.x + this._playBar.width - this._slider.width / 2;
					this.checkSliderBorder();
				}
			} else if(!this._seekBtnDowned && !param3) {
				this.drawLoadBar(this._seekBarBg.x,this._seekBarBg.y,1 * this._seekBarBg.width * this._bufferTime / this._totalTime,this._seekBarBg.height);
				this.drawPlayBar(this._seekBarBg.x,this._seekBarBg.y,1 * this._seekBarBg.width * this._currentTime / this._totalTime,this._seekBarBg.height);
			}
			
			if(!(this._filterData == null) && this._filterData.length > 0) {
				this._loadBar.visible = false;
				this._filterShape.visible = true;
			} else {
				this._loadBar.visible = true;
				this._filterShape.visible = false;
			}
			this._playBar.visible = true;
		}
		
		public function updateSeekBarView() : void {
			if(this._seekTime > this._totalTime) {
				this._seekTime = this._totalTime;
			}
			if(this._seekTime < 0) {
				this._seekTime = 0;
			}
			this.drawPlayBar(this._seekBarBg.x,this._seekBarBg.y,1 * this._seekBarBg.width * this._seekTime / this._totalTime,this._seekBarBg.height);
			this._slider.x = this._seekBarBg.x + this._playBar.width - this._slider.width / 2;
			this.checkSliderBorder();
		}
		
		public function hideImagePreview() : void {
			if(!this._isMouseIn && !this._imagePreview.isMouseIn && !this._mouseDowned) {
				this._imagePreview.hide();
				dispatchEvent(new ControllBarEvent(ControllBarEvent.Evt_ImagePreviewVedioShow,false));
			}
		}
		
		private function showImagePreview(param1:Number, param2:Number, param3:String = "", param4:String = "") : void {
			var _loc5_:uint = 0;
			if(!this._isAlreadyLoadImageData) {
				this._isAlreadyLoadImageData = true;
				_loc5_ = 0;
				while(_loc5_ < this._imagePrePicUrlArr.length) {
					PreviewImageLoader.instance.imgLoader(this._imagePrePicUrlArr[_loc5_]);
					_loc5_++;
				}
			}
			this._imagePreview.updateCurTime(param1,param3,param4);
			this._imagePreview.y = -ControllBarDef.IMAGE_PRE_SMALL_SIZE.y - ControllBarDef.BAR_WIDTH_NARROW - 3;
			this._imagePreview.x = param2;
			if(!this._imagePreview.parent) {
				addChildAt(this._imagePreview,0);
			}
		}
		
		private function onResizePoint(param1:FocusPoint) : void {
			var _loc2_:Number = this._seekBarBg.height * 0.4;
			param1.resize(_loc2_ > 2?2:_loc2_);
			param1.x = this._seekBarBg.x + param1.time / this._totalTime * this._seekBarBg.width;
			param1.y = this._seekBarBg.y + (this._seekBarBg.height - param1.height) / 2;
		}
		
		private function resizeSkipPart(param1:ISkipPointInfo) : void {
			if(param1.endTime <= param1.startTime) {
				return;
			}
			var _loc2_:int = this._seekBarBg.x + param1.startTime / this._totalTime * this._seekBarBg.width;
			var _loc3_:int = this._seekBarBg.y;
			var _loc4_:int = this._seekBarBg.height;
			var _loc5_:int = (param1.endTime - param1.startTime) / this._totalTime * this._seekBarBg.width;
			this._filterShape.graphics.drawRect(_loc2_,_loc3_,_loc5_,_loc4_);
		}
		
		private function onFocusPointHeadTailRollOver(param1:MouseEvent) : void {
			var _loc2_:FocusPoint = null;
			var _loc3_:* = 0;
			if(this._videoHeadTailTipPanel.parent == null) {
				_loc2_ = param1.currentTarget as FocusPoint;
				this._videoHeadTailTipPanel.y = localToGlobal(new Point(0,_loc2_.y - this._videoHeadTailTipPanel.height)).y;
				_loc3_ = localToGlobal(new Point(_loc2_.x + _loc2_.width / 2 - this._videoHeadTailTipPanel.width / 2,0)).x;
				if(_loc3_ <= 0) {
					_loc3_ = _loc3_ + 15;
				}
				if(_loc3_ >= GlobalStage.stage.stageWidth - this._videoHeadTailTipPanel.width - 1) {
					_loc3_ = GlobalStage.stage.stageWidth - this._videoHeadTailTipPanel.width - 5;
				}
				this._videoHeadTailTipPanel.x = _loc3_;
				this._videoHeadTailTipPanel.updateTip();
				GlobalStage.stage.addChild(this._videoHeadTailTipPanel);
				this._videoHeadTailTipPanel.addEventListener(MouseEvent.ROLL_OUT,this.onHeadTailTipPanelOut);
				this._isMouseIn = true;
				this._imagePreview.hide();
				dispatchEvent(new ControllBarEvent(ControllBarEvent.Evt_ImagePreviewVedioShow,false));
			}
		}
		
		private function onFocusPointHeadTailRollOut(param1:MouseEvent) : void {
			var _loc2_:FocusPoint = param1.currentTarget as FocusPoint;
			if(!(mouseX >= _loc2_.x + _loc2_.width / 2 - 4 && mouseX <= _loc2_.x + _loc2_.width / 2 + 4) || mouseY >= _loc2_.y) {
				this.onHeadTailTipPanelOut(null);
			}
		}
		
		private function onHeadTailTipPanelOut(param1:MouseEvent) : void {
			this._isMouseIn = false;
			this._videoHeadTailTipPanel.removeEventListener(MouseEvent.ROLL_OUT,this.onHeadTailTipPanelOut);
			if(this._videoHeadTailTipPanel.parent) {
				GlobalStage.stage.removeChild(this._videoHeadTailTipPanel);
			}
			TweenLite.delayedCall(ControllBarDef.IMAGE_PRE_DELAYEDCALL / 1000,this.hideImagePreview);
		}
		
		private function onForWardBtnMouseDown(param1:MouseEvent) : void {
			if(this._seekBtnDowned) {
				return;
			}
			GlobalStage.stage.addEventListener(MouseEvent.MOUSE_UP,this.onForWardBtnMouseUp);
			this._seekTime = this._currentTime;
			this._seekBtnDowned = true;
			TweenLite.delayedCall(1 * ControllBarDef.FF_BUTTONDOWNED_DELAY / 1000,this.onTimerStart,[true]);
			PingBack.getInstance().userActionPing(PingBackDef.FSTFRWRD);
		}
		
		private function onTimerStart(param1:Boolean) : void {
			if(!this._seekBtnDowned) {
				return;
			}
			TweenLite.killTweensOf(this.onTimerStart);
			if(param1) {
				this._timer.addEventListener(TimerEvent.TIMER,this.onForwardUpdateSeekBarView);
			} else {
				this._timer.addEventListener(TimerEvent.TIMER,this.onBackwardUpdateSeekBarView);
			}
			this._timer.start();
		}
		
		private function onForWardBtnMouseUp(param1:MouseEvent) : void {
			TweenLite.killTweensOf(this.onTimerStart);
			GlobalStage.stage.removeEventListener(MouseEvent.MOUSE_UP,this.onForWardBtnMouseUp);
			this._timer.stop();
			this._timer.removeEventListener(TimerEvent.TIMER,this.onForwardUpdateSeekBarView);
			this.onForwardUpdateSeekBarView(null);
			this._seekBtnDowned = false;
			this._seekClickCount++;
			dispatchEvent(new ControllBarEvent(ControllBarEvent.Evt_Seek,this._seekTime));
		}
		
		private function onBackWardBtnMouseDown(param1:MouseEvent) : void {
			if(this._seekBtnDowned) {
				return;
			}
			GlobalStage.stage.addEventListener(MouseEvent.MOUSE_UP,this.onBackWardBtnMouseUp);
			this._seekTime = this._currentTime;
			this._seekBtnDowned = true;
			TweenLite.delayedCall(1 * ControllBarDef.FF_BUTTONDOWNED_DELAY / 1000,this.onTimerStart,[false]);
			PingBack.getInstance().userActionPing(PingBackDef.REWIND);
		}
		
		private function onBackWardBtnMouseUp(param1:MouseEvent) : void {
			TweenLite.killTweensOf(this.onTimerStart);
			GlobalStage.stage.removeEventListener(MouseEvent.MOUSE_UP,this.onBackWardBtnMouseUp);
			this._timer.stop();
			this._timer.removeEventListener(TimerEvent.TIMER,this.onBackwardUpdateSeekBarView);
			this.onBackwardUpdateSeekBarView(null);
			this._seekBtnDowned = false;
			this._seekClickCount++;
			dispatchEvent(new ControllBarEvent(ControllBarEvent.Evt_Seek,this._seekTime));
		}
		
		private function onSeekBarBgDown(param1:MouseEvent) : void {
			GlobalStage.stage.addEventListener(MouseEvent.MOUSE_MOVE,this.onStageMouseMove);
			GlobalStage.stage.addEventListener(MouseEvent.MOUSE_UP,this.onStageMouseUp);
			this._mouseDowned = true;
			this.onStageMouseMove(param1);
		}
		
		private function onSeekBarBgClick(param1:MouseEvent) : void {
			var _loc2_:int = globalToLocal(new Point(param1.stageX,param1.stageY)).x - this._seekBarBg.x;
			var _loc3_:int = _loc2_ / this._seekBarBg.width * this._totalTime;
			dispatchEvent(new ControllBarEvent(ControllBarEvent.Evt_Seek,_loc3_));
			this._seekClickCount++;
		}
		
		private function onViewPointClick(param1:MouseEvent) : void {
			var _loc2_:FocusPoint = param1.currentTarget as FocusPoint;
			dispatchEvent(new ControllBarEvent(ControllBarEvent.Evt_Seek,_loc2_.time));
			this._seekClickCount++;
		}
		
		private function onStageMouseMove(param1:MouseEvent) : void {
			if(!this._mouseDowned) {
				return;
			}
			var _loc2_:Number = mouseX;
			if(_loc2_ < this._backWardBtn.width) {
				_loc2_ = 0;
			}
			if(_loc2_ > this._seekBarBg.x + this._seekBarBg.width) {
				_loc2_ = this._seekBarBg.x + this._seekBarBg.width;
			}
			this.drawPlayBar(this._seekBarBg.x,this._seekBarBg.y,_loc2_ - this._seekBarBg.x,this._seekBarBg.height);
			this._slider.x = _loc2_ - this._slider.width / 2;
			this.checkSliderBorder();
			this._mouseMoved = true;
			var _loc3_:int = 1 * (_loc2_ - this._seekBarBg.x) / this._seekBarBg.width * this._totalTime;
			if(_loc3_ > this._totalTime) {
				_loc3_ = this._totalTime;
			}
			if(_loc3_ < 0) {
				_loc3_ = 0;
			}
			this.showImagePreview(_loc3_,_loc2_);
			this.checkImagePreBound();
		}
		
		private function onStageMouseUp(param1:MouseEvent) : void {
			this._mouseDowned = false;
			this._mouseMoved = false;
			this._seekClickCount++;
			GlobalStage.stage.removeEventListener(MouseEvent.MOUSE_MOVE,this.onStageMouseMove);
			GlobalStage.stage.removeEventListener(MouseEvent.MOUSE_UP,this.onStageMouseUp);
			var _loc2_:int = 1 * this._playBar.width / this._seekBarBg.width * this._totalTime;
			dispatchEvent(new ControllBarEvent(ControllBarEvent.Evt_Seek,_loc2_));
			this.hideImagePreview();
		}
		
		private function onSeekBarBgMouseMove(param1:MouseEvent) : void {
			this._mouseMoveShape.graphics.clear();
			this._mouseMoveShape.graphics.beginFill(16777215,0.8);
			this._mouseMoveShape.graphics.drawRect(mouseX,this._seekBarBg.y,1,this._seekBarBg.height);
			this._mouseMoveShape.graphics.endFill();
			var _loc2_:int = 1 * (mouseX - this._seekBarBg.x) / this._seekBarBg.width * this._totalTime;
			this.showImagePreview(_loc2_,mouseX);
			this.checkImagePreBound();
		}
		
		private function onSeekBarBgRollOver(param1:MouseEvent) : void {
			TweenLite.killTweensOf(this.hideImagePreview);
			this._isMouseIn = true;
		}
		
		private function onViewPointRollOver(param1:MouseEvent) : void {
			TweenLite.killTweensOf(this.hideImagePreview);
			this._isMouseIn = true;
			this._mouseMoveShape.graphics.clear();
			var _loc2_:FocusPoint = param1.currentTarget as FocusPoint;
			this.showImagePreview(_loc2_.time,_loc2_.x + _loc2_.width / 2 - 2,_loc2_.content,_loc2_.imgUrl);
			this.checkImagePreBound(true);
		}
		
		private function checkImagePreBound(param1:Boolean = false) : void {
			var _loc2_:Number = 0;
			if((this._imagePreview.isImageListShow) || (param1)) {
				_loc2_ = this._imagePreview.x - ControllBarDef.IMAGE_PRE_BIG_WH_SIZE.x * 0.5;
				if(_loc2_ <= 0) {
					this._imagePreview.x = ControllBarDef.IMAGE_PRE_BIG_WH_SIZE.x * 0.5;
				}
				_loc2_ = this._imagePreview.x + ControllBarDef.IMAGE_PRE_BIG_WH_SIZE.x * 0.5;
				if(_loc2_ >= GlobalStage.stage.stageWidth) {
					this._imagePreview.x = GlobalStage.stage.stageWidth - ControllBarDef.IMAGE_PRE_BIG_WH_SIZE.x * 0.5;
				}
			} else {
				_loc2_ = this._imagePreview.x - ControllBarDef.IMAGE_PRE_TIME_SIZE.x * 0.5;
				if(_loc2_ <= 0) {
					this._imagePreview.x = ControllBarDef.IMAGE_PRE_TIME_SIZE.x * 0.5;
				}
				_loc2_ = this._imagePreview.x + ControllBarDef.IMAGE_PRE_TIME_SIZE.x * 0.5;
				if(_loc2_ >= GlobalStage.stage.stageWidth) {
					this._imagePreview.x = GlobalStage.stage.stageWidth - ControllBarDef.IMAGE_PRE_TIME_SIZE.x * 0.5;
				}
			}
		}
		
		private function onViewPointRollOut(param1:MouseEvent) : void {
			this._isMouseIn = false;
			TweenLite.delayedCall(ControllBarDef.IMAGE_PRE_DELAYEDCALL / 1000,this.hideImagePreview);
		}
		
		private function onSeekBarBgRollOut(param1:MouseEvent) : void {
			this._isMouseIn = false;
			this._mouseMoveShape.graphics.clear();
			TweenLite.delayedCall(ControllBarDef.IMAGE_PRE_DELAYEDCALL / 1000,this.hideImagePreview);
		}
		
		private function initUI() : void {
			this.initImagePreview();
			this._seekBarBg.y = BAR_NARROW_Y;
			this._slider.y = this._backWardBtn.y = this._forWardBtn.y = BAR_WIDE_Y;
			addChild(this._seekBarBg);
			addChild(this._loadBar);
			addChild(this._filterShape);
			addChild(this._playBar);
			addChild(this._backWardBtn);
			addChild(this._forWardBtn);
			addChild(this._mouseMoveShape);
			addChild(this._slider);
			this._loadBar.visible = false;
			this._playBar.visible = false;
		}
		
		private function initImagePreview() : void {
			this._imagePreview = new ImagePreview();
			this._imagePreview.addEventListener(ControllBarEvent.Evt_ImagePreviewMouseStateChange,this.onImagePreviewMouseStateChange);
			this._imagePreview.addEventListener(ControllBarEvent.Evt_ImagePreviewVedioShow,this.onImagePreviewVedioShow);
			this._imagePreview.addEventListener(ControllBarEvent.Evt_ImagePreItemClick,this.onImagePreItemClick);
			this._imagePreview.addEventListener(ControllBarEvent.Evt_ImagePreViewGoodsClick,this.onImagePreViewGoodsClick);
		}
		
		private function onImagePreviewMouseStateChange(param1:ControllBarEvent) : void {
			TweenLite.killTweensOf(this.hideImagePreview);
			TweenLite.delayedCall(ControllBarDef.IMAGE_PRE_DELAYEDCALL / 1000,this.hideImagePreview);
		}
		
		private function onImagePreviewVedioShow(param1:ControllBarEvent) : void {
			if(this._isMouseIn) {
				this._imagePreview.showPreviewItemList(true);
				this.checkImagePreBound(param1.data);
				dispatchEvent(new ControllBarEvent(ControllBarEvent.Evt_ImagePreviewVedioShow,true));
				PingBack.getInstance().userActionPing(PingBackDef.IMAGE_PREVIEW_SHOW);
			}
		}
		
		private function onImagePreItemClick(param1:ControllBarEvent) : void {
			this.hideImagePreview();
			dispatchEvent(new ControllBarEvent(ControllBarEvent.Evt_Seek,param1.data));
			PingBack.getInstance().userActionPing(PingBackDef.IMAGE_PREVIEW_CLICK);
		}
		
		private function onImagePreViewGoodsClick(param1:ControllBarEvent) : void {
			dispatchEvent(new ControllBarEvent(ControllBarEvent.Evt_ImagePreViewGoodsClick,param1.data));
		}
		
		private function onForwardUpdateSeekBarView(param1:TimerEvent) : void {
			this._seekTime = this._seekTime + 10000;
			this.updateSeekBarView();
		}
		
		private function onBackwardUpdateSeekBarView(param1:TimerEvent) : void {
			this._seekTime = this._seekTime - 10000;
			this.updateSeekBarView();
		}
		
		private function checkSliderBorder() : void {
			if(this._slider.x < this._seekBarBg.x) {
				this._slider.x = this._seekBarBg.x;
			}
			if(this._slider.x > this._seekBarBg.x + this._seekBarBg.width - this._slider.width / 2 - 5) {
				this._slider.x = this._seekBarBg.x + this._seekBarBg.width - this._slider.width / 2 - 5;
			}
		}
	}
}
