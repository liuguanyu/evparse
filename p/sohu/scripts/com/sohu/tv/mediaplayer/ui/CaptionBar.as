package com.sohu.tv.mediaplayer.ui {
	import flash.display.Sprite;
	import ebing.Utils;
	import flash.text.*;
	import flash.filters.*;
	import ebing.utils.*;
	
	public class CaptionBar extends Sprite {
		
		public function CaptionBar(param1:String, param2:String, param3:String, param4:String) {
			super();
			this._sCaptionPath = param1;
			this._nCaptionPath = param2;
			this._eCaptionPath = param3;
			this._ceCaptionPath = param4;
			this.newFunc();
			this.drawSkin();
			this.addEvent();
			this._sText.autoSize = this._nText.autoSize = this._eText.autoSize = TextFieldAutoSize.LEFT;
			this._sText.multiline = this._nText.multiline = this._eText.multiline = true;
			this._sText.antiAliasType = AntiAliasType.ADVANCED;
			this._sText.selectable = this._nText.selectable = this._eText.selectable = false;
			this._sText.wordWrap = true;
			this._bg.alpha = 0;
			var _loc5_:GlowFilter = new GlowFilter(0,1,3,3,2,1,false,false);
			this._sText.filters = [_loc5_];
			this._dragTip_txt.filters = [_loc5_];
			_loc5_.color = 10066329;
			_loc5_.blurX = _loc5_.blurY = 8;
			this._bg.filters = [_loc5_];
			this.captionColor = 16777215;
			this._dragTip_txt.textColor = 16777215;
			this._dragTip_txt.autoSize = TextFieldAutoSize.LEFT;
			this._dragTip_txt.visible = false;
		}
		
		private var _bg:Sprite;
		
		private var _sText:TextField;
		
		private var _nText:TextField;
		
		private var _eText:TextField;
		
		private var _isSCaption:Boolean = false;
		
		private var _isNCaption:Boolean = false;
		
		private var _isECaption:Boolean = false;
		
		private var _isCECaption:Boolean = false;
		
		private var _sCaptionPath:String = "";
		
		private var _nCaptionPath:String = "";
		
		private var _eCaptionPath:String = "";
		
		private var _ceCaptionPath:String = "";
		
		private var _sSrt:Srt;
		
		private var _nSrt:Srt;
		
		private var _eSrt:Srt;
		
		private var _ceSrt:Srt;
		
		private var _width:Number = 1;
		
		private var _height:Number = 30;
		
		private var _captionSizeRate:Number = 0.7;
		
		private var _captionAlpha:Number = 1;
		
		private var _pt:Number = 0;
		
		private var _captionColor:Number = 0;
		
		private var _captionVer:String = "0";
		
		private var _dragTip_txt:TextField;
		
		private var _py:Number = 0.85;
		
		private var _isDragState:Boolean = false;
		
		private function newFunc() : void {
			this._sText = new TextField();
			this._nText = new TextField();
			this._eText = new TextField();
			this._sSrt = new Srt();
			this._nSrt = new Srt();
			this._eSrt = new Srt();
			this._ceSrt = new Srt();
			this._dragTip_txt = new TextField();
		}
		
		private function drawSkin() : void {
			this._bg = new Sprite();
			Utils.drawRect(this._bg,0,0,this._width,this._height,0,1);
			addChild(this._bg);
			this._dragTip_txt.text = "按住左键以调整字幕位置";
			addChild(this._dragTip_txt);
			addChild(this._sText);
			addChild(this._nText);
			addChild(this._eText);
		}
		
		private function addEvent() : void {
		}
		
		public function set py(param1:Number) : void {
			this._py = param1;
		}
		
		public function get py() : Number {
			return this._py;
		}
		
		public function playProgress(param1:* = null) : void {
			if(param1 != null) {
				this._pt = param1.obj.nowTime * 1000;
			}
			var _loc2_:* = "";
			if(this._isSCaption) {
				_loc2_ = this._sSrt.getText(this._pt);
				_loc2_ = _loc2_ == ""?" ":_loc2_;
			}
			if(this._isNCaption) {
				_loc2_ = this._nSrt.getText(this._pt);
				_loc2_ = _loc2_ == ""?" ":_loc2_;
			}
			if(this._isECaption) {
				_loc2_ = this._eSrt.getText(this._pt);
				_loc2_ = _loc2_ == ""?" ":_loc2_;
			}
			if(this._isCECaption) {
				_loc2_ = this._ceSrt.getText(this._pt);
				_loc2_ = _loc2_ == ""?" ":_loc2_;
			}
			var _loc3_:RegExp = new RegExp("\\r");
			_loc2_ = _loc2_.replace(_loc3_,"");
			this._sText.text = _loc2_;
			var _loc4_:TextFormat = new TextFormat();
			_loc4_.size = parent["core"].videoContainer.height * this._captionSizeRate / 10 - 2;
			_loc4_.font = "_sans";
			_loc4_.bold = true;
			_loc4_.align = TextFormatAlign.CENTER;
			this._sText.setTextFormat(_loc4_);
			this._height = this._sText.textHeight + 3;
			this._bg.height = this._height;
			if(_loc2_ == " " && this._bg.alpha == 0 || this._captionVer == "0") {
				this.visible = false;
			} else {
				this.visible = true;
			}
		}
		
		public function get sText() : TextField {
			return this._sText;
		}
		
		public function get captionVer() : String {
			return this._captionVer;
		}
		
		public function set captionVer(param1:String) : void {
			this._captionVer = param1;
			if(param1 == "1") {
				this._isSCaption = true;
				this._isCECaption = this._isNCaption = this._isECaption = false;
				if(!this._sSrt.hasData) {
					this._sSrt.loadSrtFile(this._sCaptionPath);
				}
			} else if(param1 == "2") {
				this._isNCaption = true;
				this._isCECaption = this._isSCaption = this._isECaption = false;
				if(!this._nSrt.hasData) {
					this._nSrt.loadSrtFile(this._nCaptionPath);
				}
			} else if(param1 == "3") {
				this._isECaption = true;
				this._isCECaption = this._isSCaption = this._isNCaption = false;
				if(!this._eSrt.hasData) {
					this._eSrt.loadSrtFile(this._eCaptionPath);
				}
			} else if(param1 == "4") {
				this._isCECaption = true;
				this._isSCaption = this._isNCaption = this._isECaption = false;
				if(!this._ceSrt.hasData) {
					this._ceSrt.loadSrtFile(this._ceCaptionPath);
				}
			} else if(param1 == "0") {
				this._isSCaption = this._isNCaption = this._isECaption = false;
			}
			
			
			
			
		}
		
		public function set captionColor(param1:Number) : void {
			this._captionColor = this._sText.textColor = this._nText.textColor = this._eText.textColor = param1;
		}
		
		public function get captionColor() : Number {
			return this._captionColor;
		}
		
		public function set captionAlpha(param1:Number) : void {
			this._captionAlpha = param1;
			this._sText.alpha = this._nText.alpha = this._eText.alpha = this._captionAlpha;
		}
		
		public function set captionSizeRate(param1:Number) : void {
			this._captionSizeRate = param1;
			this.playProgress();
		}
		
		public function resize(param1:Number) : void {
			this._width = param1;
			this._bg.width = this._width;
			this._sText.width = this._nText.width = this._eText.width = this._width;
			Utils.setCenter(this._dragTip_txt,this._bg);
			this._dragTip_txt.y = -this._dragTip_txt.height;
		}
		
		public function showDragBg() : void {
			this._dragTip_txt.visible = true;
			this._bg.alpha = 0.4;
		}
		
		public function hideDragBg() : void {
			this._dragTip_txt.visible = false;
			this._bg.alpha = 0;
		}
		
		public function get isDragState() : Boolean {
			return this._isDragState;
		}
		
		public function set isDragState(param1:Boolean) : void {
			this._isDragState = param1;
		}
		
		public function get bg() : Sprite {
			return this._bg;
		}
		
		override public function get height() : Number {
			return this._bg.height;
		}
		
		public function get captionAlpha() : Number {
			return this._captionAlpha;
		}
		
		public function get captionSizeRate() : Number {
			return this._captionSizeRate;
		}
	}
}
