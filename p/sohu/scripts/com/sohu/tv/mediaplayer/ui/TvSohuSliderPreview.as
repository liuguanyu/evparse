package com.sohu.tv.mediaplayer.ui {
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import ebing.Utils;
	import com.greensock.*;
	import com.greensock.easing.*;
	import com.sohu.tv.mediaplayer.stat.*;
	import ebing.controls.*;
	import ebing.events.*;
	import flash.events.*;
	import flash.utils.*;
	import flash.text.TextFieldAutoSize;
	import com.sohu.tv.mediaplayer.PlayerConfig;
	import flash.filters.GlowFilter;
	import flash.display.Bitmap;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.display.BitmapData;
	
	public class TvSohuSliderPreview extends SliderPreview {
		
		public function TvSohuSliderPreview(param1:Object) {
			this._line = new MovieClip();
			this._dotClass = param1.skin.dotClass;
			this._dotsBtnArr = new Array();
			this._spDotsBtn = new Sprite();
			this._previewTip2_mc = param1.skin.previewTip2;
			this._commonPPBg_mc = param1.skin.commonPPBg;
			if(param1.skin.multiImgPreview) {
				this._multiImgPreview = param1.skin.multiImgPreview;
			}
			if(param1.skin.newPreviewTip) {
				this._newPreviewTip = param1.skin.newPreviewTip;
			}
			if(param1.skin.line) {
				this._line = param1.skin.line;
			}
			super(param1);
			if(!(PlayerConfig.pvpic == null) && (PlayerConfig.isPreviewPic)) {
				this._isShowPicPreview = true;
			}
		}
		
		private static const DOLLOP_WIDTH_WIDE:uint = 15;
		
		private static const DOLLOP_WIDTH_NARROW:uint = 5;
		
		private static const DOLLOP_HEIGHT_WIDE:uint = 14;
		
		private static const DOLLOP_HEIGHT_NARROW:uint = 4;
		
		private static const DOLLOP_NARROW_Y:int = 10;
		
		private static const DOLLOP_WIDE_Y:int = 0;
		
		private static const SLIDER_NARROW_Y:int = 11;
		
		private static const SLIDER_WIDE_Y:int = 1;
		
		private static const DOTS_NARROW_Y:int = 9;
		
		private static const DOTS_WIDE_Y:int = 1;
		
		private static const DOTS_WIDTH_WIDE:uint = 12;
		
		private static const DOTS_WIDTH_NARROW:uint = 6;
		
		private static const TIME_WIDE:Number = 0.1;
		
		private static const TIME_NARROW:Number = 0.1;
		
		public static const SLIDER_WIDTH_WIDE:uint = 12;
		
		public static const SLIDER_WIDTH_NARROW:uint = 2;
		
		private static const STATUS_SLIDER_THICK:int = 0;
		
		private static const STATUS_SLIDER_SHOW:int = 1;
		
		private var _dotClass:Class;
		
		private var _dotsBtnArr:Array;
		
		private var _previewTip2_mc:MovieClip;
		
		private var _isOver:Boolean = false;
		
		private var _dotSeekTIme:Number = 0;
		
		private var _commonPPBg_mc:MovieClip;
		
		private var _height:Number = 0;
		
		private var _hidePT2TimeoutId:Number = 0;
		
		private var _spDotsBtn:Sprite;
		
		private var _previewPicCore:TvSohuPicPreview;
		
		private var _currentTime:Number = 0;
		
		private var _multiImgPreview:MovieClip;
		
		private var _maskMultiSp:Sprite;
		
		private var _isShowPic:Boolean = false;
		
		private var _newPreviewTip;
		
		private var _allPicObj:Object;
		
		private var _DotsTimeArr:Array;
		
		private var prevY:Number = 0;
		
		private var curY:Number = 0;
		
		private var _hideNewPreview:Boolean = false;
		
		private var _isMove:Boolean = true;
		
		private var _isKeyboard:Boolean = false;
		
		private var _line:MovieClip;
		
		private var _width:Number = 0;
		
		private var tipBgX:Number = 0;
		
		private var _sliderDiffHeight:Number = 0;
		
		private var _dotsIsai:Boolean = false;
		
		private var _sliderOverId:Number = 0;
		
		private var _isShowPicPreview:Boolean = false;
		
		private var _isAdMode:Boolean = false;
		
		private var _clickTimes:Number = 0;
		
		override protected function addEvent() : void {
			super.addEvent();
			this._previewTip2_mc.addEventListener(MouseEvent.MOUSE_OUT,function(param1:MouseEvent):void {
				dotOutHandler();
				dispatchEvent(new Event("newPreOut"));
			});
			this._previewTip2_mc.addEventListener(MouseEvent.MOUSE_OVER,function(param1:MouseEvent):void {
				clearTimeout(_hidePT2TimeoutId);
				dispatchEvent(new Event("newPreOver"));
			});
		}
		
		override protected function newFunc() : void {
			super.newFunc();
		}
		
		override protected function sysInit(param1:String) : void {
			super.sysInit(param1);
			Utils.drawRect(_hit_spr,0,0,1,_middle_mc.height + 11,16777215,0);
			_hit_spr.y = _hit_spr.y - 4;
		}
		
		public function get hitSpr() : Sprite {
			return _hit_spr;
		}
		
		override protected function drawSkin() : void {
			addChild(this._commonPPBg_mc);
			this._commonPPBg_mc.x = this._commonPPBg_mc.y = 0;
			super.drawSkin();
			if(this._line != null) {
				_container.addChild(this._line);
				_container.swapChildren(this._line,_dollop_btn);
				_container.swapChildren(this._line,_hit_spr);
				this._line.y = _hit_spr.y;
			}
			if(this._previewTip2_mc != null) {
				addChild(this._previewTip2_mc);
				this._previewTip2_mc.visible = false;
				this._previewTip2_mc.x = this._previewTip2_mc.y = 0;
				this._previewTip2_mc.title_txt.autoSize = TextFieldAutoSize.LEFT;
			}
			var _loc1_:Number = Utils.getMaxWidth([_back_btn,_forward_btn,_container,this._commonPPBg_mc]);
			var _loc2_:Number = Utils.getMaxHeight([_back_btn,_forward_btn,_container,this._commonPPBg_mc]);
			Utils.setCenterByNumber(_back_btn,_loc1_,_loc2_);
			Utils.setCenterByNumber(_forward_btn,_loc1_,_loc2_);
			Utils.setCenterByNumber(_container,_loc1_,_loc2_);
			_container.x = 1;
			_forward_btn.visible = _back_btn.visible = false;
			this._height = this._sliderDiffHeight = _loc2_;
			if(this._newPreviewTip != null) {
				addChildAt(this._newPreviewTip,0);
				this._newPreviewTip.addEventListener(MouseEvent.MOUSE_OVER,this.newPreOver);
				this._newPreviewTip.addEventListener(MouseEvent.MOUSE_OUT,this.newPreOut);
				this._newPreviewTip.visible = false;
				this._newPreviewTip.x = this._newPreviewTip.y = 0;
				this._previewPicCore = new TvSohuPicPreview();
				if(this._isShowPicPreview) {
					this._previewPicCore.hardInit({
						"bigPicUrl":PlayerConfig.pvpic.big,
						"smallPicUrl":PlayerConfig.pvpic.small
					});
				} else {
					this._previewPicCore.hardInit();
				}
				this._previewPicCore.addEventListener("smallComplete",this.smallComplete);
				this._previewPicCore.addEventListener("bigComplete",this.bigComplete);
				this._newPreviewTip.picPreviewBg.visible = true;
				this._newPreviewTip.isaiMc.visible = false;
				this._newPreviewTip.picPreviewBg.tipBg.width = this._previewPicCore.bWidth + 4;
				this._newPreviewTip.picPreviewBg.tipBg.height = this._previewPicCore.bHeight + 4;
				this._newPreviewTip.picPreviewBg.shadow.width = this._newPreviewTip.picPreviewBg.shadowline.width = this._previewPicCore.bWidth;
				this._newPreviewTip.picPreviewBg.shadow.height = this._previewPicCore.bHeight;
				this.tipBgX = this._newPreviewTip.picPreviewBg.tipBg.x;
				this._newPreviewTip.picPreviewBg.tipBg.x = this._newPreviewTip.picPreviewBg.tipBg.x + (160 - this._previewPicCore.bWidth) / 2;
				this._newPreviewTip.picPreviewBg.shadow.x = this._newPreviewTip.picPreviewBg.tipBg.x + 1;
				this._newPreviewTip.picPreviewBg.shadow.y = this._newPreviewTip.picPreviewBg.tipBg.y - this._newPreviewTip.picPreviewBg.tipBg.height + 4;
				this._newPreviewTip.picPreviewBg.shadow.addEventListener(MouseEvent.MOUSE_OVER,this.shadowOver);
				this._newPreviewTip.picPreviewBg.shadow.addEventListener(MouseEvent.MOUSE_OUT,this.shadowOut);
				this._newPreviewTip.picPreviewBg.shadow.alpha = 1;
				this._newPreviewTip.picPreviewBg.titleTxt.width = this._previewPicCore.bWidth + 6;
				this._newPreviewTip.picPreviewBg.titleTxt.x = this._newPreviewTip.picPreviewBg.tipBg.x + 12;
				this._newPreviewTip.picPreviewBg.titleTxt.visible = false;
				this._newPreviewTip.picPreviewBg.time_txt.x = this._newPreviewTip.picPreviewBg.shadowline.x = this._newPreviewTip.picPreviewBg.tipBg.x + 1;
				this._newPreviewTip.picPreviewBg.previewMore.x = this._newPreviewTip.picPreviewBg.shadowline.x + this._newPreviewTip.picPreviewBg.shadow.width - this._newPreviewTip.picPreviewBg.previewMore.width;
				if(this._multiImgPreview != null) {
					addChildAt(this._multiImgPreview,0);
					this._maskMultiSp = new Sprite();
					Utils.drawRect(this._maskMultiSp,0,0,this._previewPicCore.bWidth,this._previewPicCore.bHeight,0,1);
					this._multiImgPreview.bigPreviewMc.imgBg.width = this._previewPicCore.bHeight + 4;
					this._multiImgPreview.bigPreviewMc.imgBg.height = this._previewPicCore.bHeight + 4;
					this._multiImgPreview.bigPreviewMc.addChild(this._maskMultiSp);
					this._maskMultiSp.x = this._multiImgPreview.bigPreviewMc.imgBg.x + 1.5;
					this._maskMultiSp.y = this._multiImgPreview.bigPreviewMc.imgBg.y - this._multiImgPreview.bigPreviewMc.imgBg.height + 3;
					this._multiImgPreview.bigPreviewMc.y = 0;
					this._multiImgPreview.visible = false;
					this._multiImgPreview.x = 0;
					this._multiImgPreview.y = this._newPreviewTip.y + 2;
					this._multiImgPreview.bigPreviewMc.shadowline.width = this._previewPicCore.bWidth;
					Utils.setCenter(this._multiImgPreview.bigPreviewMc.time_txt,this._multiImgPreview.bigPreviewMc.shadowline);
				}
			}
		}
		
		private function resizeNewPreviewTip() : void {
			this._newPreviewTip.picPreviewBg.tipBg.x = this.tipBgX;
			this._newPreviewTip.picPreviewBg.tipBg.width = this._previewPicCore.bWidth + 4;
			this._newPreviewTip.picPreviewBg.tipBg.height = this._previewPicCore.bHeight + 4;
			this._newPreviewTip.picPreviewBg.shadow.width = this._newPreviewTip.picPreviewBg.shadowline.width = this._previewPicCore.bWidth;
			this._newPreviewTip.picPreviewBg.shadow.height = this._previewPicCore.bHeight;
			this._newPreviewTip.picPreviewBg.tipBg.x = this._newPreviewTip.picPreviewBg.tipBg.x + (160 - this._previewPicCore.bWidth) / 2;
			this._newPreviewTip.picPreviewBg.shadow.x = this._newPreviewTip.picPreviewBg.tipBg.x + 1;
			this._newPreviewTip.picPreviewBg.shadow.y = this._newPreviewTip.picPreviewBg.tipBg.y - this._newPreviewTip.picPreviewBg.tipBg.height + 4;
			this._newPreviewTip.picPreviewBg.shadow.alpha = 1;
			this._newPreviewTip.picPreviewBg.titleTxt.width = this._previewPicCore.bWidth + 6;
			this._newPreviewTip.picPreviewBg.titleTxt.x = this._newPreviewTip.picPreviewBg.tipBg.x + 12;
			this._newPreviewTip.picPreviewBg.time_txt.x = this._newPreviewTip.picPreviewBg.shadowline.x = this._newPreviewTip.picPreviewBg.tipBg.x + 1;
			this._newPreviewTip.picPreviewBg.previewMore.x = this._newPreviewTip.picPreviewBg.shadowline.x + this._newPreviewTip.picPreviewBg.shadow.width - this._newPreviewTip.picPreviewBg.previewMore.width;
			if(this._multiImgPreview != null) {
				this._maskMultiSp.width = this._previewPicCore.bWidth;
				this._maskMultiSp.height = this._previewPicCore.bHeight;
				this._multiImgPreview.bigPreviewMc.imgBg.width = this._previewPicCore.bHeight + 4;
				this._multiImgPreview.bigPreviewMc.imgBg.height = this._previewPicCore.bHeight + 4;
				this._maskMultiSp.x = this._multiImgPreview.bigPreviewMc.imgBg.x + 1.5;
				this._maskMultiSp.y = this._multiImgPreview.bigPreviewMc.imgBg.y - this._multiImgPreview.bigPreviewMc.imgBg.height + 3;
				this._multiImgPreview.bigPreviewMc.y = 0;
				this._multiImgPreview.x = 0;
				this._multiImgPreview.y = this._newPreviewTip.y + 2;
				this._multiImgPreview.bigPreviewMc.shadowline.width = this._previewPicCore.bWidth;
				Utils.setCenter(this._multiImgPreview.bigPreviewMc.time_txt,this._multiImgPreview.bigPreviewMc.shadowline);
			}
		}
		
		public function downLoadPic() : void {
			if(this._previewPicCore != null) {
				if(!(PlayerConfig.pvpic.big == null) && !(PlayerConfig.pvpic.big == "") && !(PlayerConfig.pvpic.small == null) && !(PlayerConfig.pvpic.small == "")) {
					this._previewPicCore.hardInit({
						"bigPicUrl":PlayerConfig.pvpic.big,
						"smallPicUrl":PlayerConfig.pvpic.small
					});
					this._previewPicCore.startLoadPic();
				}
				if(this._newPreviewTip != null) {
					this._previewPicCore.initPicArr();
					this._newPreviewTip.picPreviewBg.shadow.buttonMode = this._newPreviewTip.picPreviewBg.shadow.useHandCursor = false;
					this._newPreviewTip.picPreviewBg.previewMore.removeEventListener(MouseEvent.CLICK,this.goToFlatWall);
					this._newPreviewTip.picPreviewBg.shadow.removeEventListener(MouseEvent.CLICK,this.goToFlatWall);
					this.resizeNewPreviewTip();
				}
			}
		}
		
		private function shadowOver(param1:MouseEvent) : void {
			this._newPreviewTip.picPreviewBg.shadow.alpha = 1;
		}
		
		private function shadowOut(param1:MouseEvent) : void {
			this._newPreviewTip.picPreviewBg.shadow.alpha = 1;
		}
		
		public function clearPreviewPic() : void {
			if(this._multiImgPreview != null) {
				while(this._multiImgPreview.smallPreviewMc.numChildren) {
					this._multiImgPreview.smallPreviewMc.removeChildAt(0);
				}
			}
			if(this._newPreviewTip != null) {
				this._previewPicCore.initPicArr();
				this._newPreviewTip.picPreviewBg.shadow.buttonMode = this._newPreviewTip.picPreviewBg.shadow.useHandCursor = false;
				this._newPreviewTip.picPreviewBg.previewMore.removeEventListener(MouseEvent.CLICK,this.goToFlatWall);
				this._newPreviewTip.picPreviewBg.shadow.removeEventListener(MouseEvent.CLICK,this.goToFlatWall);
				this.resizeNewPreviewTip();
			}
		}
		
		override public function set enabled(param1:Boolean) : void {
			super.enabled = param1;
			var _loc2_:* = 0;
			if(param1) {
				_middle_mc.visible = true;
				this._isAdMode = false;
			}
			if(!this._isAdMode) {
				if(this._dotsBtnArr.length > 0) {
					_loc2_ = 0;
					while(_loc2_ < this._dotsBtnArr.length) {
						this._dotsBtnArr[_loc2_].btn.buttonMode = true;
						this._dotsBtnArr[_loc2_].btn.useHandCursor = true;
						this._dotsBtnArr[_loc2_].btn.addEventListener(MouseEventUtil.CLICK,this.dotClickHandler);
						_loc2_++;
					}
				}
				if(!(PlayerConfig.pvpic == null) && (PlayerConfig.isPreviewPic)) {
					this._isShowPicPreview = true;
					if(_previewTip_mc != null) {
						_previewTip_mc.visible = false;
					}
				}
			} else {
				if(this._dotsBtnArr.length > 0) {
					_loc2_ = 0;
					while(_loc2_ < this._dotsBtnArr.length) {
						this._dotsBtnArr[_loc2_].btn.buttonMode = false;
						this._dotsBtnArr[_loc2_].btn.useHandCursor = false;
						this._dotsBtnArr[_loc2_].btn.removeEventListener(MouseEventUtil.CLICK,this.dotClickHandler);
						_loc2_++;
					}
				}
				this._isShowPicPreview = false;
			}
		}
		
		public function set isAdMode(param1:Boolean) : void {
			this._isAdMode = param1;
		}
		
		override public function backward() : void {
			this._isKeyboard = true;
			super.backward();
		}
		
		override public function forward() : void {
			this._isKeyboard = true;
			super.forward();
		}
		
		override protected function downHandler(param1:MouseEventUtil) : void {
			super.downHandler(param1);
			switch(param1.target) {
				case _forward_btn:
					if(!this._isKeyboard) {
						SendRef.getInstance().sendPQVPC("fun_yangli205733_PL_C_ForwardMouse");
					}
					this._isKeyboard = false;
					break;
				case _back_btn:
					if(!this._isKeyboard) {
						SendRef.getInstance().sendPQVPC("fun_yangli205733_PL_C_BackwardMouse");
					}
					this._isKeyboard = false;
					break;
				case _dollop_btn:
					if(!(this._newPreviewTip == null) && (this._isShowPicPreview)) {
						this._newPreviewTip.visible = false;
						if(!this._hideNewPreview) {
							this._multiImgPreview.visible = true;
						}
						this.getMultiImgStatus();
						this.getMultiPositionPic(this._currentTime);
						this._isOver = true;
					}
					SendRef.getInstance().sendPQVPC("fun_yangli205733_PL_C_ClickDragProgress");
					this.clickTimes();
					break;
				case _hit_spr:
					SendRef.getInstance().sendPQVPC("fun_yangli205733_PL_C_ClickProgress");
					this.clickTimes();
					break;
			}
		}
		
		private function clickTimes() : void {
			if(this._clickTimes < 2) {
				this._clickTimes++;
			} else {
				dispatchEvent(new Event("proKeyboardTip"));
				this._clickTimes = 0;
			}
		}
		
		override protected function upHandler(param1:MouseEventUtil) : void {
			switch(param1.target) {
				case _dollop_btn:
					if(!(this._newPreviewTip == null) && (this._isShowPicPreview)) {
						this._multiImgPreview.visible = false;
						while(this._multiImgPreview.bigPreviewMc.bitMapMc.numChildren) {
							this._multiImgPreview.bigPreviewMc.bitMapMc.removeChildAt(0);
						}
						this._isOver = false;
					}
					if(!_isSliderEnd) {
						dispatch(SliderEventUtil.SLIDE_END,{
							"sign":0,
							"rate":_topRate_num
						});
					}
					stage.removeEventListener(MouseEvent.MOUSE_MOVE,this.moveHandler);
					break;
				case _forward_btn:
					clearTimeout(_mouseDownId);
					clearInterval(_exeId);
					_seekNum = -1;
					if(!_ttt) {
						this.speedForward(true);
					} else {
						_ttt = false;
						dispatch(SliderEventUtil.SLIDE_END,{
							"sign":0,
							"rate":_topRate_num
						});
					}
					break;
				case _back_btn:
					clearTimeout(_mouseDownId);
					clearInterval(_exeId);
					_seekNum = -1;
					if(!_ttt) {
						this.speedBack(true);
					} else {
						_ttt = false;
						dispatch(SliderEventUtil.SLIDE_END,{
							"sign":0,
							"rate":_topRate_num
						});
					}
					break;
			}
		}
		
		override protected function moveHandler(param1:MouseEvent) : void {
			super.moveHandler(param1);
			var _loc2_:Number = _container.mouseX;
			dispatch(SliderEventUtil.SLIDER_PREVIEW_RATE,{"rate":getTopRate(_loc2_)});
			if(!(this._newPreviewTip == null) && (this._isShowPicPreview)) {
				if(param1.buttonDown) {
					this.getMultiImgStatus();
					this.getMultiPositionPic(this._currentTime);
				}
			}
		}
		
		override protected function speedForward(param1:Boolean = false) : void {
			if(_seekNum == -1) {
				_seekNum = _dollop_btn.x + _dollop_btn.width / 2;
			}
			_seekNum = param1?_seekNum + 10:_seekNum + 1;
			if(param1) {
				dispatchEvent(new Event("forward"));
			} else {
				doSlide(_seekNum,0);
			}
		}
		
		override protected function speedBack(param1:Boolean = false) : void {
			if(_seekNum == -1) {
				_seekNum = _dollop_btn.x + _dollop_btn.width / 2;
			}
			_seekNum = param1?_seekNum - 10:_seekNum - 1;
			if(param1) {
				dispatchEvent(new Event("backward"));
			} else {
				doSlide(_seekNum,0);
			}
		}
		
		public function setDots(param1:Array) : void {
			var _loc2_:uint = 0;
			var _loc3_:uint = 0;
			while(this._spDotsBtn.numChildren) {
				this._spDotsBtn.removeChildAt(0);
			}
			this._DotsTimeArr = new Array();
			if(!(param1 == null) && param1.length >= 1) {
				_loc2_ = 0;
				_loc3_ = 0;
				while(_loc3_ < param1.length) {
					this._dotsBtnArr[_loc3_] = {
						"btn":null,
						"rate":0,
						"time":0,
						"id":"",
						"title":"",
						"type":"",
						"isUpOrDown":false
					};
					this._DotsTimeArr[_loc3_] = {
						"time":0,
						"type":"",
						"title":"",
						"isai":"0"
					};
					this._dotsBtnArr[_loc3_].btn = new ButtonUtil({"skin":new this._dotClass()});
					if(this._dotsBtnArr[_loc3_].btn.skin["num_txt"] != null) {
						if(param1[_loc3_].type == "s") {
							this._dotsBtnArr[_loc3_].btn.skin["num_txt"].text = "S";
						} else if(param1[_loc3_].type == "e") {
							this._dotsBtnArr[_loc3_].btn.skin["num_txt"].text = "E";
						}
						
					}
					this._dotsBtnArr[_loc3_].btn.obj = {"index":_loc3_};
					this._dotsBtnArr[_loc3_].btn.addEventListener(MouseEventUtil.CLICK,this.dotClickHandler);
					this._dotsBtnArr[_loc3_].btn.addEventListener(MouseEventUtil.MOUSE_OVER,this.dotOverHandler);
					this._dotsBtnArr[_loc3_].btn.addEventListener(MouseEventUtil.MOUSE_OUT,this.dotOutHandler);
					this._dotsBtnArr[_loc3_].rate = param1[_loc3_].rate;
					this._dotsBtnArr[_loc3_].time = param1[_loc3_].time;
					this._dotsBtnArr[_loc3_].id = param1[_loc3_].id;
					this._dotsBtnArr[_loc3_].title = param1[_loc3_].title;
					this._dotsBtnArr[_loc3_].type = param1[_loc3_].type;
					this._dotsBtnArr[_loc3_].isai = param1[_loc3_].isai;
					this._spDotsBtn.addChildAt(this._dotsBtnArr[_loc3_].btn,0);
					Utils.setCenter(this._dotsBtnArr[_loc3_].btn,_bottom_mc);
					this._dotsBtnArr[_loc3_].btn.x = Math.round(this._dotsBtnArr[_loc3_].rate * _bottom_mc.width + _dollop_btn.width / 2);
					this._DotsTimeArr[_loc3_].time = param1[_loc3_].time;
					this._DotsTimeArr[_loc3_].type = param1[_loc3_].type;
					this._DotsTimeArr[_loc3_].title = param1[_loc3_].title;
					_loc3_++;
				}
				_container.addChild(this._spDotsBtn);
				_container.setChildIndex(_dollop_btn,_container.numChildren - 1);
			}
		}
		
		public function removeDotsBtn() : void {
			while(this._spDotsBtn.numChildren) {
				this._spDotsBtn.removeChildAt(0);
			}
			this._DotsTimeArr = [];
			this._allPicObj = null;
			this._isMove = true;
			this._isShowPicPreview = false;
		}
		
		public function get allPicObj() : Object {
			return this._allPicObj;
		}
		
		public function get dotSeekTime() : Number {
			return this._dotSeekTIme;
		}
		
		private function dotClickHandler(param1:MouseEventUtil) : void {
			this._dotSeekTIme = this._dotsBtnArr[param1.target.obj.index].time;
			dispatchEvent(new Event("dot_seek"));
		}
		
		private function dotOverHandler(param1:MouseEventUtil) : void {
			var _loc2_:Array = new Array();
			var _loc3_:* = 0;
			var _loc4_:MovieClip = new MovieClip();
			var _loc5_:MovieClip = new MovieClip();
			var _loc6_:Number = _container.x + param1.currentTarget.x;
			if(!(this._newPreviewTip == null) && (this._isShowPicPreview)) {
				clearTimeout(this._hidePT2TimeoutId);
				if(this._dotsBtnArr[param1.target.obj.index].isai == "1") {
					this._dotsIsai = true;
					this._newPreviewTip.picPreviewBg.visible = false;
					this._newPreviewTip.isaiMc.title_txt.htmlText = Utils.fomatTime(this._dotsBtnArr[param1.target.obj.index].time) + " " + this._dotsBtnArr[param1.target.obj.index].title;
					if(this._dotsBtnArr[param1.target.obj.index].title.length > 12) {
						this._newPreviewTip.isaiMc.tipBg.height = this._newPreviewTip.isaiMc.title_txt.textHeight + 25;
						this._newPreviewTip.isaiMc.title_txt.y = this._newPreviewTip.isaiMc.tipBg.y - this._newPreviewTip.isaiMc.tipBg.height + 11;
					} else {
						this._newPreviewTip.isaiMc.tipBg.height = this._newPreviewTip.isaiMc.title_txt.textHeight + 18;
						this._newPreviewTip.isaiMc.title_txt.y = this._newPreviewTip.isaiMc.tipBg.y - this._newPreviewTip.isaiMc.tipBg.height + 11;
					}
					_loc3_ = 0;
					while(_loc3_ < this._newPreviewTip.isaiMc.typeIcon.numChildren) {
						_loc4_ = this._newPreviewTip.isaiMc.typeIcon.getChildAt(_loc3_) as MovieClip;
						_loc4_.visible = false;
						_loc2_.push(_loc4_);
						_loc3_++;
					}
					_loc5_ = _loc2_[this._dotsBtnArr[param1.target.obj.index].type] as MovieClip;
					_loc5_.visible = true;
					this._newPreviewTip.isaiMc.typeIcon.x = this._newPreviewTip.isaiMc.tipBg.x - 13;
					this._newPreviewTip.isaiMc.typeIcon.y = this._newPreviewTip.isaiMc.tipBg.y - this._newPreviewTip.isaiMc.tipBg.height - 13;
					this._newPreviewTip.isaiMc.visible = true;
					SendRef.getInstance().sendPQDrog("http://click.hd.sohu.com.cn/s.gif?type=fun_yangli205733_bfqhdbjd&s=" + PlayerConfig.stype + "&_=" + new Date().getTime());
				} else {
					this._dotsIsai = false;
					this._newPreviewTip.picPreviewBg.visible = true;
					this._newPreviewTip.isaiMc.visible = false;
					this._newPreviewTip.picPreviewBg.titleTxt.visible = true;
					this._newPreviewTip.picPreviewBg.titleTxt.htmlText = this._dotsBtnArr[param1.target.obj.index].title;
					this._newPreviewTip.picPreviewBg.titleTxt.filters = new Array(new GlowFilter(0,1,2,2,255));
					if(this._dotsBtnArr[param1.target.obj.index].title.length > 12) {
						this._newPreviewTip.picPreviewBg.titleTxt.height = this._newPreviewTip.picPreviewBg.titleTxt.textHeight + 12;
						this._newPreviewTip.picPreviewBg.tipBg.height = this._previewPicCore.bHeight + 4 + this._newPreviewTip.picPreviewBg.titleTxt.height + 3;
						Utils.setCenter(this._newPreviewTip.picPreviewBg.titleTxt,this._newPreviewTip.picPreviewBg.tipBg);
						this._newPreviewTip.picPreviewBg.titleTxt.y = this._newPreviewTip.picPreviewBg.shadow.y - this._newPreviewTip.picPreviewBg.titleTxt.textHeight - 8;
					} else {
						this._newPreviewTip.picPreviewBg.titleTxt.height = this._newPreviewTip.picPreviewBg.titleTxt.textHeight + 12;
						this._newPreviewTip.picPreviewBg.tipBg.height = this._previewPicCore.bHeight + 4 + this._newPreviewTip.picPreviewBg.titleTxt.height;
						Utils.setCenter(this._newPreviewTip.picPreviewBg.titleTxt,this._newPreviewTip.picPreviewBg.tipBg);
						this._newPreviewTip.picPreviewBg.titleTxt.y = this._newPreviewTip.picPreviewBg.shadow.y - this._newPreviewTip.picPreviewBg.titleTxt.textHeight - 4;
					}
				}
			} else {
				this._isOver = true;
				clearTimeout(this._hidePT2TimeoutId);
				if(_loc6_ - this._previewTip2_mc.width / 2 > 0) {
					this._previewTip2_mc.x = _loc6_;
					if(stage.stageWidth - _loc6_ < this._previewTip2_mc.width / 2) {
						this._previewTip2_mc.x = stage.stageWidth - this._previewTip2_mc.width / 2 + 5;
					}
				} else if(this._dotsBtnArr[param1.target.obj.index].isai == "1") {
					this._previewTip2_mc.x = this._previewTip2_mc.width / 2 - 5 + 13;
				} else {
					this._previewTip2_mc.x = this._previewTip2_mc.width / 2 - 5;
				}
				
				this._previewTip2_mc.title_txt.htmlText = Utils.fomatTime(this._dotsBtnArr[param1.target.obj.index].time) + " " + this._dotsBtnArr[param1.target.obj.index].title;
				if(this._dotsBtnArr[param1.target.obj.index].title.length > 12) {
					this._previewTip2_mc.title_txt.x = Math.round(this._previewTip2_mc.tipBg.x + (this._previewTip2_mc.tipBg.width - this._previewTip2_mc.title_txt.textWidth) / 2);
					this._previewTip2_mc.tipBg.height = this._previewTip2_mc.title_txt.textHeight + 25;
					this._previewTip2_mc.title_txt.y = this._previewTip2_mc.tipBg.y - this._previewTip2_mc.tipBg.height + 11;
				} else {
					this._previewTip2_mc.title_txt.x = -76;
					this._previewTip2_mc.tipBg.height = this._previewTip2_mc.title_txt.textHeight + 18;
					this._previewTip2_mc.title_txt.y = this._previewTip2_mc.tipBg.y - this._previewTip2_mc.tipBg.height + 11;
				}
				if(this._dotsBtnArr[param1.target.obj.index].isai == "1") {
					_loc3_ = 0;
					while(_loc3_ < this._previewTip2_mc.typeIcon.numChildren) {
						_loc4_ = this._previewTip2_mc.typeIcon.getChildAt(_loc3_) as MovieClip;
						_loc4_.visible = false;
						_loc2_.push(_loc4_);
						_loc3_++;
					}
					_loc5_ = _loc2_[this._dotsBtnArr[param1.target.obj.index].type] as MovieClip;
					_loc5_.visible = true;
					this._previewTip2_mc.typeIcon.x = this._previewTip2_mc.tipBg.x - 13;
					this._previewTip2_mc.typeIcon.y = this._previewTip2_mc.tipBg.y - this._previewTip2_mc.tipBg.height - 13;
					this._previewTip2_mc.typeIcon.visible = true;
					SendRef.getInstance().sendPQDrog("http://click.hd.sohu.com.cn/s.gif?type=fun_yangli205733_bfqhdbjd&s=" + PlayerConfig.stype + "&_=" + new Date().getTime());
				} else {
					this._previewTip2_mc.typeIcon.visible = false;
				}
				this.tb();
			}
		}
		
		private function tb() : void {
			this._previewTip2_mc.visible = true;
		}
		
		private function dotOutHandler(param1:* = null) : void {
			this._dotsIsai = false;
			if(!(param1 == null) && (this._dotsBtnArr[param1.target.obj.index].type == "s" || this._dotsBtnArr[param1.target.obj.index].type == "e")) {
				this.hidePreviewTip2();
			} else {
				clearTimeout(this._hidePT2TimeoutId);
				this._hidePT2TimeoutId = setTimeout(this.hidePreviewTip2,100);
			}
		}
		
		private function hidePreviewTip2() : void {
			this._isOver = false;
			this._previewTip2_mc.visible = false;
			stage.addEventListener(MouseEvent.MOUSE_MOVE,this.sliderMoveHandler);
			stage.dispatchEvent(new MouseEvent(MouseEvent.MOUSE_MOVE));
			if(!(this._newPreviewTip == null) && !(PlayerConfig.pvpic == null) && (PlayerConfig.isPreviewPic)) {
				this._newPreviewTip.picPreviewBg.tipBg.width = this._previewPicCore.bWidth + 4;
				this._newPreviewTip.picPreviewBg.tipBg.height = this._previewPicCore.bHeight + 4;
				this._newPreviewTip.isaiMc.visible = false;
				this._newPreviewTip.picPreviewBg.titleTxt.visible = false;
				this._newPreviewTip.picPreviewBg.titleTxt.htmlText = "";
				this._newPreviewTip.picPreviewBg.visible = true;
				this._newPreviewTip.visible = false;
			}
		}
		
		private function goToFlatWall(param1:MouseEvent) : void {
			this._newPreviewTip.visible = false;
			dispatchEvent(new Event("wall3DOpen"));
		}
		
		private function newPreOver(param1:MouseEvent) : void {
			clearTimeout(this._hidePT2TimeoutId);
			this._isMove = false;
			if(!this._hideNewPreview) {
				this._newPreviewTip.visible = true;
				dispatchEvent(new Event("newPreOver"));
			}
		}
		
		private function newPreOut(param1:MouseEvent) : void {
			this.dotOutHandler();
			this._isMove = true;
			this._newPreviewTip.visible = false;
			dispatchEvent(new Event("newPreOut"));
		}
		
		override protected function sliderOverHandler(param1:MouseEvent) : void {
			var evt:MouseEvent = param1;
			this._sliderOverId = setTimeout(function():void {
				stage.addEventListener(MouseEvent.MOUSE_MOVE,sliderMoveHandler);
				stage.dispatchEvent(new MouseEvent(MouseEvent.MOUSE_MOVE));
			},100);
		}
		
		override protected function sliderMoveHandler(param1:MouseEvent) : void {
			var _loc2_:Number = _container.mouseX;
			this.prevY = this.curY;
			this.curY = stage.mouseY;
			if(!(this._newPreviewTip == null) && (this._isShowPicPreview)) {
				this._newPreviewTip.y = _hit_spr.y;
				if(this.mouseX - this._newPreviewTip.width / 2 > 0) {
					this._newPreviewTip.x = this.mouseX;
					if(stage.stageWidth - this.mouseX < this._newPreviewTip.width / 2) {
						if(160 - this._previewPicCore.bWidth > 0) {
							this._newPreviewTip.picPreviewBg.tipBg.x = this.tipBgX + (160 - this._previewPicCore.bWidth);
							Utils.setCenter(this._newPreviewTip.picPreviewBg.titleTxt,this._newPreviewTip.picPreviewBg.tipBg);
							this._newPreviewTip.picPreviewBg.titleTxt.y = this._newPreviewTip.picPreviewBg.shadow.y - this._newPreviewTip.picPreviewBg.titleTxt.textHeight - 8;
							this._newPreviewTip.picPreviewBg.shadow.x = this._newPreviewTip.picPreviewBg.tipBg.x + 1;
							this._newPreviewTip.picPreviewBg.time_txt.x = this._newPreviewTip.picPreviewBg.shadowline.x = this._newPreviewTip.picPreviewBg.tipBg.x + 1;
							this._newPreviewTip.picPreviewBg.previewMore.x = this._newPreviewTip.picPreviewBg.shadowline.x + this._newPreviewTip.picPreviewBg.shadow.width - this._newPreviewTip.picPreviewBg.previewMore.width;
						}
						this._newPreviewTip.x = stage.stageWidth - this._newPreviewTip.width / 2 + 5;
					} else if(160 - this._previewPicCore.bWidth > 0) {
						this._newPreviewTip.picPreviewBg.tipBg.x = this.tipBgX + (160 - this._previewPicCore.bWidth) / 2;
						Utils.setCenter(this._newPreviewTip.picPreviewBg.titleTxt,this._newPreviewTip.picPreviewBg.tipBg);
						this._newPreviewTip.picPreviewBg.titleTxt.y = this._newPreviewTip.picPreviewBg.shadow.y - this._newPreviewTip.picPreviewBg.titleTxt.textHeight - 8;
						this._newPreviewTip.picPreviewBg.shadow.x = this._newPreviewTip.picPreviewBg.tipBg.x + 1;
						this._newPreviewTip.picPreviewBg.time_txt.x = this._newPreviewTip.picPreviewBg.shadowline.x = this._newPreviewTip.picPreviewBg.tipBg.x + 1;
						this._newPreviewTip.picPreviewBg.previewMore.x = this._newPreviewTip.picPreviewBg.shadowline.x + this._newPreviewTip.picPreviewBg.shadow.width - this._newPreviewTip.picPreviewBg.previewMore.width;
					}
					
				} else if(this._dotsIsai) {
					this._newPreviewTip.x = this._newPreviewTip.width / 2 - 5 + 13;
				} else {
					if(160 - this._previewPicCore.bWidth > 0) {
						this._newPreviewTip.picPreviewBg.tipBg.x = this.tipBgX;
						Utils.setCenter(this._newPreviewTip.picPreviewBg.titleTxt,this._newPreviewTip.picPreviewBg.tipBg);
						this._newPreviewTip.picPreviewBg.titleTxt.y = this._newPreviewTip.picPreviewBg.shadow.y - this._newPreviewTip.picPreviewBg.titleTxt.textHeight - 8;
						this._newPreviewTip.picPreviewBg.shadow.x = this._newPreviewTip.picPreviewBg.tipBg.x + 1;
						this._newPreviewTip.picPreviewBg.time_txt.x = this._newPreviewTip.picPreviewBg.shadowline.x = this._newPreviewTip.picPreviewBg.tipBg.x + 1;
						this._newPreviewTip.picPreviewBg.previewMore.x = this._newPreviewTip.picPreviewBg.shadowline.x + this._newPreviewTip.picPreviewBg.shadow.width - this._newPreviewTip.picPreviewBg.previewMore.width;
					}
					this._newPreviewTip.x = this._newPreviewTip.width / 2 - 5;
				}
				
			} else if(this.mouseX - _previewTip_mc.width / 2 > 0) {
				if(stage.stageWidth - this.mouseX < _previewTip_mc.width / 2) {
					_previewTip_mc.y = _hit_spr.y;
					_previewTip_mc.x = this.mouseX - _previewTip_mc.width / 2 + 1;
				} else {
					_previewTip_mc.y = _hit_spr.y;
					_previewTip_mc.x = this.mouseX;
				}
			} else {
				_previewTip_mc.y = _hit_spr.y;
				_previewTip_mc.x = this.mouseX + _previewTip_mc.width / 2 - 1;
			}
			
			if((_container.hitTestPoint(stage.mouseX,stage.mouseY)) && !this._isOver) {
				if(this._line != null) {
					this._line.x = _container.mouseX;
					this._line.visible = true;
				}
				if(!(this._newPreviewTip == null) && (this._isShowPicPreview)) {
					_previewTip_mc.visible = false;
					if(!this._hideNewPreview && !this._newPreviewTip.visible) {
						this._newPreviewTip.visible = true;
						this._newPreviewTip.gotoAndPlay(2);
					}
					if(!(this._multiImgPreview == null) && (this._multiImgPreview.visible)) {
						this._newPreviewTip.visible = false;
					}
				} else if(this._previewTip2_mc.visible) {
					_previewTip_mc.visible = false;
				} else {
					_previewTip_mc.visible = true;
				}
				
			} else {
				stage.removeEventListener(MouseEvent.MOUSE_MOVE,this.sliderMoveHandler);
				if(this._line != null) {
					this._line.visible = false;
				}
				if(!this._isShowPicPreview) {
					_previewTip_mc.visible = false;
				} else if(!(this.prevY > this.curY) && !(this._newPreviewTip == null) && (this._newPreviewTip.visible)) {
					this._newPreviewTip.visible = false;
					this._newPreviewTip.gotoAndStop(1);
				}
				
			}
			dispatch(SliderEventUtil.SLIDER_PREVIEW_RATE,{"rate":getTopRate(_loc2_)});
		}
		
		public function sliderOutHandler() : void {
			if(this._line != null) {
				this._line.visible = false;
			}
			if(_previewTip_mc != null) {
				_previewTip_mc.visible = false;
			}
			if(!(this._newPreviewTip == null) && (this._isShowPicPreview)) {
				this._newPreviewTip.visible = false;
			}
		}
		
		private function getPositionPic(param1:Number) : void {
			var _loc2_:Bitmap = new Bitmap();
			if(this._newPreviewTip.picPreviewBg.bitMapMc.getChildByName("currBitMap") != null) {
				this._newPreviewTip.picPreviewBg.bitMapMc.removeChild(this._newPreviewTip.picPreviewBg.bitMapMc.getChildByName("currBitMap"));
			}
			var _loc3_:Number = param1;
			var _loc4_:Number = 0;
			if(this._previewPicCore.arrayBigBlocks.length > 0) {
				if(PlayerConfig.totalDuration - _loc3_ < this._previewPicCore.timeLimit) {
					_loc4_ = this._previewPicCore.arrayBigBlocks.length - 1;
				} else {
					_loc4_ = Math.floor(_loc3_ / this._previewPicCore.timeLimit);
				}
				_loc2_ = this._previewPicCore.arrayBigBlocks[_loc4_];
			}
			_loc2_.name = "currBitMap";
			this._newPreviewTip.picPreviewBg.bitMapMc.addChild(_loc2_);
			this._newPreviewTip.picPreviewBg.bitMapMc.x = this._newPreviewTip.picPreviewBg.tipBg.x + 1;
			this._newPreviewTip.picPreviewBg.bitMapMc.y = this._newPreviewTip.picPreviewBg.tipBg.y - (this._previewPicCore.bHeight + 4) + 4;
		}
		
		private function getMultiPositionPic(param1:Number) : void {
			var _loc2_:Bitmap = new Bitmap();
			var _loc3_:Number = param1;
			var _loc4_:Number = 0;
			if(this._previewPicCore.arrayBigBlocks.length > 0) {
				if(PlayerConfig.totalDuration - _loc3_ < this._previewPicCore.timeLimit) {
					_loc4_ = this._previewPicCore.arrayBigBlocks.length - 1;
				} else {
					_loc4_ = Math.floor(_loc3_ / this._previewPicCore.timeLimit);
				}
				_loc2_ = this._previewPicCore.arrayBigBlocks[_loc4_];
			}
			_loc2_.name = "currBitMap";
			this._multiImgPreview.bigPreviewMc.bitMapMc.addChild(_loc2_);
			this._multiImgPreview.bigPreviewMc.bitMapMc.setChildIndex(_loc2_,this._multiImgPreview.bigPreviewMc.bitMapMc.numChildren - 1);
			this._multiImgPreview.bigPreviewMc.bitMapMc.x = this._maskMultiSp.x;
			this._multiImgPreview.bigPreviewMc.bitMapMc.y = this._maskMultiSp.y;
			this._multiImgPreview.bigPreviewMc.bitMapMc.mask = this._maskMultiSp;
			this._multiImgPreview.smallPreviewMc.x = this._multiImgPreview.smallPreviewMc.x - _loc4_ * this._previewPicCore.bWidth * 0.8;
		}
		
		private function smallComplete(param1:Event) : void {
			var _loc2_:* = 0;
			var _loc3_:Bitmap = null;
			var _loc4_:Sprite = null;
			if(this._previewPicCore.arraySmallBlocks.length > 0) {
				_loc2_ = 0;
				while(_loc2_ < this._previewPicCore.totalBlocks) {
					_loc3_ = new Bitmap();
					_loc4_ = new Sprite();
					_loc3_ = this._previewPicCore.arraySmallBlocks[_loc2_];
					Utils.drawRect(_loc4_,0,0,_loc3_.width,_loc3_.height + 4,0,1);
					this._multiImgPreview.smallPreviewMc.addChild(_loc4_);
					this._multiImgPreview.smallPreviewMc.addChild(_loc3_);
					_loc3_.x = _loc2_ * this._previewPicCore.bWidth;
					_loc4_.x = _loc3_.x;
					_loc4_.y = _loc3_.y - 2;
					_loc2_++;
				}
			}
			this._multiImgPreview.smallPreviewMc.scaleX = this._multiImgPreview.smallPreviewMc.scaleY = 0.8;
			this._multiImgPreview.smallPreviewMc.y = this._multiImgPreview.bigPreviewMc.y - this._multiImgPreview.bigPreviewMc.imgBg.height + 3 + (this._multiImgPreview.bigPreviewMc.imgBg.height - this._multiImgPreview.smallPreviewMc.height) / 2;
		}
		
		private function bigComplete(param1:Event) : void {
			this._allPicObj = {
				"bytes":this._previewPicCore.bigPicBytes,
				"picW":this._previewPicCore.bWidth,
				"picH":this._previewPicCore.bHeight,
				"timeLimit":this._previewPicCore.timeLimit,
				"totalBlocks":this._previewPicCore.totalBlocks,
				"totalDuration":PlayerConfig.totalDuration,
				"Dots":this._DotsTimeArr
			};
			if(this._newPreviewTip != null) {
				this._newPreviewTip.picPreviewBg.shadow.buttonMode = this._newPreviewTip.picPreviewBg.shadow.useHandCursor = true;
				this._newPreviewTip.picPreviewBg.previewMore.addEventListener(MouseEvent.CLICK,this.goToFlatWall);
				this._newPreviewTip.picPreviewBg.shadow.addEventListener(MouseEvent.CLICK,this.goToFlatWall);
			}
			this.getPositionPic(this._currentTime);
		}
		
		override public function set previewTip(param1:String) : void {
			if(_previewTip_mc != null) {
				_previewTip_mc.time_txt.text = param1;
			}
			if(!(this._newPreviewTip == null) && (this._isShowPicPreview)) {
				this._newPreviewTip.picPreviewBg.time_txt.text = param1;
				if(this._multiImgPreview != null) {
					this._multiImgPreview.bigPreviewMc.time_txt.text = param1;
				}
			}
		}
		
		private function getMultiImgStatus() : void {
			this._multiImgPreview.bigPreviewMc.x = (stage.stageWidth - this._multiImgPreview.bigPreviewMc.width) / 2;
			this._multiImgPreview.smallPreviewMc.x = this._multiImgPreview.bigPreviewMc.x;
		}
		
		public function set currentTime(param1:Number) : void {
			this._currentTime = param1;
			try {
				if(this._isMove) {
					this.getPositionPic(this._currentTime);
				}
			}
			catch(e:Error) {
			}
		}
		
		private function ioErrorHandler(param1:IOErrorEvent) : void {
		}
		
		override public function resize(param1:Number) : void {
			var _loc2_:uint = 0;
			this._commonPPBg_mc.width = param1;
			super.resize(param1);
			if(!(this._dotsBtnArr == null) && this._dotsBtnArr.length > 0) {
				while(_loc2_ < this._dotsBtnArr.length) {
					Utils.setCenter(this._dotsBtnArr[_loc2_].btn,_bottom_mc);
					this._dotsBtnArr[_loc2_].btn.x = Math.round(this._dotsBtnArr[_loc2_].rate * (_bottom_mc.width - _dollop_btn.width) + _dollop_btn.width / 2);
					_loc2_++;
				}
			}
		}
		
		public function onSliderWideStatus(param1:int) : void {
			var _loc2_:* = 0;
			switch(param1) {
				case STATUS_SLIDER_SHOW:
					this.visible = true;
					this.bgResize(stage.stageWidth);
					break;
				case STATUS_SLIDER_THICK:
					this.killAllTweens();
					if(!(this._dotsBtnArr == null) && this._dotsBtnArr.length > 0) {
						_loc2_ = 0;
						while(_loc2_ < this._dotsBtnArr.length) {
							TweenLite.to(this._dotsBtnArr[_loc2_].btn,TIME_WIDE,{
								"y":DOTS_WIDE_Y,
								"width":DOTS_WIDTH_WIDE,
								"height":DOTS_WIDTH_WIDE,
								"onUpdate":this.onSliderHeightChange
							});
							_loc2_++;
						}
					}
					TweenLite.to(this._dollop_btn,TIME_WIDE,{
						"alpha":1,
						"y":DOLLOP_WIDE_Y,
						"width":DOLLOP_WIDTH_WIDE,
						"height":DOLLOP_HEIGHT_WIDE,
						"onUpdate":this.onSliderHeightChange
					});
					TweenLite.to(this._top_mc,TIME_WIDE,{
						"y":SLIDER_WIDE_Y,
						"height":SLIDER_WIDTH_WIDE,
						"onUpdate":this.onSliderHeightChange
					});
					TweenLite.to(this._middle_mc,TIME_WIDE,{
						"y":SLIDER_WIDE_Y,
						"height":SLIDER_WIDTH_WIDE,
						"onUpdate":this.onSliderHeightChange
					});
					TweenLite.to(this._bottom_mc,TIME_WIDE,{
						"y":SLIDER_WIDE_Y,
						"height":SLIDER_WIDTH_WIDE,
						"onUpdate":this.onSliderHeightChange,
						"onComplete":this.bgResize,
						"onCompleteParams":[stage.stageWidth]
					});
					break;
			}
		}
		
		public function onSliderNarrowStatus(param1:int) : void {
			var _loc2_:* = 0;
			switch(param1) {
				case STATUS_SLIDER_SHOW:
					this.visible = true;
					this.smResize(stage.stageWidth);
					break;
				case STATUS_SLIDER_THICK:
					this._sliderDiffHeight = this._height - SLIDER_WIDTH_NARROW;
					this.killAllTweens();
					TweenLite.to(this._dollop_btn,TIME_WIDE,{
						"alpha":0,
						"y":DOLLOP_NARROW_Y,
						"width":DOLLOP_WIDTH_NARROW,
						"height":DOLLOP_HEIGHT_NARROW,
						"onUpdate":this.onSliderHeightChange
					});
					if(!(this._dotsBtnArr == null) && this._dotsBtnArr.length > 0) {
						_loc2_ = 0;
						while(_loc2_ < this._dotsBtnArr.length) {
							TweenLite.to(this._dotsBtnArr[_loc2_].btn,TIME_WIDE,{
								"y":DOTS_NARROW_Y,
								"width":DOTS_WIDTH_NARROW,
								"height":DOTS_WIDTH_NARROW,
								"onUpdate":this.onSliderHeightChange
							});
							_loc2_++;
						}
					}
					TweenLite.to(this._top_mc,TIME_WIDE,{
						"y":SLIDER_NARROW_Y,
						"height":SLIDER_WIDTH_NARROW,
						"onUpdate":this.onSliderHeightChange
					});
					TweenLite.to(this._middle_mc,TIME_WIDE,{
						"y":SLIDER_NARROW_Y,
						"height":SLIDER_WIDTH_NARROW,
						"onUpdate":this.onSliderHeightChange
					});
					TweenLite.to(this._bottom_mc,TIME_WIDE,{
						"y":SLIDER_NARROW_Y,
						"height":SLIDER_WIDTH_NARROW,
						"onUpdate":this.onSliderHeightChange,
						"onComplete":this.smResize,
						"onCompleteParams":[stage.stageWidth]
					});
					break;
			}
		}
		
		private function onSliderHeightChange() : void {
			this.topRate = topRate;
			middleRate = middleRate;
		}
		
		private function bgResize(param1:Number) : void {
			var _loc2_:* = 0;
			this._commonPPBg_mc.width = param1;
			_bottom_mc.width = param1;
			_bottom_mc.height = _middle_mc.height = _top_mc.height = SLIDER_WIDTH_WIDE;
			_bottom_mc.x = _middle_mc.x = _top_mc.x = 0;
			_bottom_mc.y = _middle_mc.y = _top_mc.y = SLIDER_WIDE_Y;
			_dollop_btn.width = DOLLOP_WIDTH_WIDE;
			_dollop_btn.height = DOLLOP_HEIGHT_WIDE;
			_dollop_btn.y = DOLLOP_WIDE_Y;
			_dollop_btn.alpha = 1;
			if(!(this._dotsBtnArr == null) && this._dotsBtnArr.length > 0) {
				_loc2_ = 0;
				while(_loc2_ < this._dotsBtnArr.length) {
					this._dotsBtnArr[_loc2_].btn.width = this._dotsBtnArr[_loc2_].btn.height = DOTS_WIDTH_WIDE;
					this._dotsBtnArr[_loc2_].btn.y = DOTS_WIDE_Y;
					_loc2_++;
				}
			}
		}
		
		private function smResize(param1:Number) : void {
			var _loc2_:* = 0;
			this._commonPPBg_mc.width = param1;
			_bottom_mc.width = param1;
			_bottom_mc.height = _middle_mc.height = _top_mc.height = SLIDER_WIDTH_NARROW;
			_bottom_mc.x = _middle_mc.x = _top_mc.x = 0;
			_bottom_mc.y = _middle_mc.y = _top_mc.y = SLIDER_NARROW_Y;
			_dollop_btn.width = DOLLOP_WIDTH_NARROW;
			_dollop_btn.height = DOLLOP_HEIGHT_NARROW;
			_dollop_btn.y = DOLLOP_NARROW_Y;
			_dollop_btn.alpha = 0;
			if(!(this._dotsBtnArr == null) && this._dotsBtnArr.length > 0) {
				_loc2_ = 0;
				while(_loc2_ < this._dotsBtnArr.length) {
					this._dotsBtnArr[_loc2_].btn.width = this._dotsBtnArr[_loc2_].btn.height = DOTS_WIDTH_NARROW;
					this._dotsBtnArr[_loc2_].btn.y = DOTS_NARROW_Y;
					_loc2_++;
				}
			}
		}
		
		private function killAllTweens() : void {
			var _loc1_:* = 0;
			TweenLite.killTweensOf(this._dollop_btn);
			TweenLite.killTweensOf(this._top_mc);
			TweenLite.killTweensOf(this._middle_mc);
			TweenLite.killTweensOf(this._bottom_mc);
			if(!(this._dotsBtnArr == null) && this._dotsBtnArr.length > 0) {
				_loc1_ = 0;
				while(_loc1_ < this._dotsBtnArr.length) {
					TweenLite.killTweensOf(this._dotsBtnArr[_loc1_].btn);
					_loc1_++;
				}
			}
		}
		
		override public function set topRate(param1:Number) : void {
			super.topRate = param1;
		}
		
		public function get dollopBtn() : ButtonUtil {
			return _dollop_btn;
		}
		
		public function get sliderDiffHeight() : Number {
			return this._sliderDiffHeight;
		}
		
		override public function get height() : Number {
			return this._height;
		}
		
		public function set adMode(param1:Boolean) : void {
			_middle_mc.visible = !param1;
		}
		
		public function set hideNewPreview(param1:Boolean) : void {
			this._hideNewPreview = param1;
		}
		
		private function drawCloseBtn(param1:Number, param2:Number, param3:uint, param4:uint) : Sprite {
			var _loc5_:Sprite = new Sprite();
			var _loc6_:TextField = new TextField();
			var _loc7_:TextFormat = new TextFormat();
			_loc7_.color = param4;
			_loc7_.size = 12;
			_loc6_.autoSize = TextFieldAutoSize.LEFT;
			_loc6_.defaultTextFormat = _loc7_;
			_loc6_.selectable = false;
			_loc6_.text = "预览墙";
			_loc5_.addChild(_loc6_);
			Utils.drawRoundRect(_loc5_,0,0,param1,param2,6,param3,0.3);
			Utils.setCenter(_loc6_,_loc5_);
			_loc6_.y = _loc6_.y - 1;
			return _loc5_;
		}
		
		private function getTxtBitmap(param1:TextField) : Bitmap {
			var _loc2_:Sprite = new Sprite();
			_loc2_.addChild(param1);
			var _loc3_:BitmapData = new BitmapData(param1.width,param1.height,true,0);
			_loc3_.draw(_loc2_);
			var _loc4_:Bitmap = new Bitmap(_loc3_);
			return _loc4_;
		}
	}
}
