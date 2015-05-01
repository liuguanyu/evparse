package com.qiyi.player.wonder.plugins.controllbar.view.preview {
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.display.Bitmap;
	import flash.text.TextField;
	import flash.display.Loader;
	import flash.display.Shape;
	import common.CommonLoadingMC;
	import flash.filters.GlowFilter;
	import com.qiyi.player.wonder.common.ui.FastCreator;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.events.MouseEvent;
	import com.qiyi.player.wonder.plugins.controllbar.view.preview.image.PreviewImageLoader;
	import com.qiyi.player.wonder.plugins.controllbar.ControllBarDef;
	import flash.display.BitmapData;
	import com.qiyi.player.base.utils.Strings;
	import com.qiyi.player.wonder.common.utils.ConstUtils;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLRequest;
	import flash.display.DisplayObject;
	import com.qiyi.player.wonder.plugins.controllbar.view.ControllBarEvent;
	
	public class ImagePreviewItem extends Sprite {
		
		public function ImagePreviewItem() {
			super();
			this.initItem();
			this.useHandCursor = this.buttonMode = true;
		}
		
		private static const MERCHANDISE_IMG_SIZE:Point = new Point(33,33);
		
		private static const BORDER_LINE_SIZE:int = 2;
		
		private static const BG_ALPHA:Number = 0.8;
		
		private var _bitmap:Bitmap;
		
		private var _tfTimeAndTitle:TextField;
		
		private var _sprTimeAndTitle:Sprite;
		
		private var _loader:Loader;
		
		private var _lineShape:Shape;
		
		private var _imgContainer:Sprite;
		
		private var _imgMark:Sprite;
		
		private var _bg:Shape;
		
		private var _picLoadingMC:CommonLoadingMC;
		
		private var _focusTip:String = "";
		
		private var _imgUrl:String = "";
		
		private var _curTime:Number = -1;
		
		private var _imageIndex:int = 0;
		
		private var _isBigItem:Boolean = false;
		
		private var _isShowImage:Boolean = false;
		
		private var _index:int = 0;
		
		public function get imageIndex() : int {
			return this._imageIndex;
		}
		
		public function get curTime() : Number {
			return this._curTime;
		}
		
		public function get index() : int {
			return this._index;
		}
		
		public function set index(param1:int) : void {
			this._index = param1;
		}
		
		private function initItem() : void {
			this._bg = new Shape();
			this._imgContainer = new Sprite();
			this._imgMark = new Sprite();
			this._lineShape = new Shape();
			this._bitmap = new Bitmap();
			this._bitmap.filters = [new GlowFilter(0,1,4,4,2)];
			this._tfTimeAndTitle = FastCreator.createLabel("1",13421772,12,TextFieldAutoSize.CENTER);
			this._tfTimeAndTitle.defaultTextFormat = new TextFormat(FastCreator.FONT_MSYH,12,13421772,false,null,null,null,null,TextFieldAutoSize.CENTER);
			this._tfTimeAndTitle.multiline = true;
			this._tfTimeAndTitle.wordWrap = true;
			this._tfTimeAndTitle.mouseEnabled = this._tfTimeAndTitle.selectable = false;
			this._sprTimeAndTitle = new Sprite();
			this._sprTimeAndTitle.graphics.clear();
			this._sprTimeAndTitle.graphics.beginFill(16711680,0);
			this._sprTimeAndTitle.graphics.drawRect(0,0,1,1);
			this._sprTimeAndTitle.graphics.endFill();
			this._sprTimeAndTitle.useHandCursor = this._sprTimeAndTitle.buttonMode = true;
			this._sprTimeAndTitle.addEventListener(MouseEvent.CLICK,this.onGoodsClick);
			this._imgContainer.addEventListener(MouseEvent.CLICK,this.onGoodsClick);
			PreviewImageLoader.instance.addEventListener(PreviewImageLoader.COMPLETE,this.onImageLoaderComplete);
		}
		
		public function updateImageState(param1:Boolean, param2:Boolean) : void {
			this._isBigItem = param1;
			this._isShowImage = param2;
			if(this._isShowImage) {
				if(this._isBigItem) {
					addChild(this._bg);
					addChild(this._tfTimeAndTitle);
					addChild(this._sprTimeAndTitle);
					this._imgContainer.visible = true;
					if(this._imgContainer.parent) {
						setChildIndex(this._imgContainer,numChildren - 1);
					}
					this._tfTimeAndTitle.width = this._imgUrl == ""?ControllBarDef.IMAGE_PRE_BIG_WH_SIZE.x:ControllBarDef.IMAGE_PRE_FOCUS_TIP_SIZE.x;
					this._tfTimeAndTitle.text = this.getStringByTime();
					this._bg.filters = [new GlowFilter(0,1,20,20,1)];
					this._bg.graphics.clear();
					this._bg.graphics.beginFill(0,BG_ALPHA);
					if(this._tfTimeAndTitle.numLines <= 1 && this._imgUrl == "") {
						this._bg.graphics.drawRect(-BORDER_LINE_SIZE,-BORDER_LINE_SIZE,ControllBarDef.IMAGE_PRE_BIG_WH_SIZE.x + BORDER_LINE_SIZE * 2,ControllBarDef.IMAGE_PRE_BIG_WH_SIZE.y + ControllBarDef.IMAGE_PRE_TIME_SIZE.y + BORDER_LINE_SIZE * 2);
						this._bg.y = -(ControllBarDef.IMAGE_PRE_BIG_WH_SIZE.y - ControllBarDef.IMAGE_PRE_SMALL_SIZE.y) - ControllBarDef.IMAGE_PRE_TIME_SIZE.y;
					} else {
						this._bg.graphics.drawRect(-BORDER_LINE_SIZE,-BORDER_LINE_SIZE,ControllBarDef.IMAGE_PRE_BIG_WH_SIZE.x + BORDER_LINE_SIZE * 2,ControllBarDef.IMAGE_PRE_BIG_WH_SIZE.y + ControllBarDef.IMAGE_PRE_FOCUS_TIP_SIZE.y + BORDER_LINE_SIZE * 2);
						this._bg.y = -(ControllBarDef.IMAGE_PRE_BIG_WH_SIZE.y - ControllBarDef.IMAGE_PRE_SMALL_SIZE.y) - ControllBarDef.IMAGE_PRE_FOCUS_TIP_SIZE.y;
					}
					this._bg.x = -(ControllBarDef.IMAGE_PRE_BIG_WH_SIZE.x - ControllBarDef.IMAGE_PRE_SMALL_SIZE.x) * 0.5;
					this._bg.graphics.endFill();
					this._bitmap.width = ControllBarDef.IMAGE_PRE_BIG_WH_SIZE.x;
					this._bitmap.height = ControllBarDef.IMAGE_PRE_BIG_WH_SIZE.y;
					this._bitmap.y = this._bg.y;
					this._bitmap.x = -(ControllBarDef.IMAGE_PRE_BIG_WH_SIZE.x - ControllBarDef.IMAGE_PRE_SMALL_SIZE.x) * 0.5;
					this._tfTimeAndTitle.x = this._bg.x + (this._imgUrl == ""?0:ControllBarDef.IMAGE_PRE_BIG_WH_SIZE.x - ControllBarDef.IMAGE_PRE_FOCUS_TIP_SIZE.x);
					this._tfTimeAndTitle.y = this._bg.y + ControllBarDef.IMAGE_PRE_BIG_WH_SIZE.y;
					this._sprTimeAndTitle.width = this._tfTimeAndTitle.width;
					this._sprTimeAndTitle.height = this._tfTimeAndTitle.height;
					this._sprTimeAndTitle.x = this._tfTimeAndTitle.x;
					this._sprTimeAndTitle.y = this._tfTimeAndTitle.y;
				} else {
					this._imgContainer.visible = false;
					if(this._tfTimeAndTitle.parent) {
						removeChild(this._tfTimeAndTitle);
					}
					if(this._sprTimeAndTitle.parent) {
						removeChild(this._sprTimeAndTitle);
					}
					if(this._bg.parent) {
						removeChild(this._bg);
					}
					this._bitmap.width = ControllBarDef.IMAGE_PRE_SMALL_SIZE.x;
					this._bitmap.height = ControllBarDef.IMAGE_PRE_SMALL_SIZE.y;
					this._bitmap.y = 0;
					this._bitmap.x = 0;
				}
				addChild(this._bitmap);
				if(this._picLoadingMC) {
					this._picLoadingMC.x = this._bitmap.x + (this._bitmap.width - this._picLoadingMC.width) * 0.5;
					this._picLoadingMC.y = this._bitmap.y + (this._bitmap.height - this._picLoadingMC.height) * 0.5;
					addChild(this._picLoadingMC);
				}
			} else {
				if((this._picLoadingMC) && (this._picLoadingMC.parent)) {
					removeChild(this._picLoadingMC);
				}
				if(this._bitmap.parent) {
					removeChild(this._bitmap);
				}
				addChild(this._bg);
				addChild(this._tfTimeAndTitle);
				addChild(this._sprTimeAndTitle);
				this._imgContainer.visible = true;
				if(this._imgContainer.parent) {
					setChildIndex(this._imgContainer,numChildren - 1);
				}
				this._tfTimeAndTitle.width = this._focusTip == ""?ControllBarDef.IMAGE_PRE_TIME_SIZE.x:this._imgUrl == ""?ControllBarDef.IMAGE_PRE_BIG_WH_SIZE.x:ControllBarDef.IMAGE_PRE_FOCUS_TIP_SIZE.x;
				this._tfTimeAndTitle.text = this.getStringByTime();
				this._bg.graphics.clear();
				this._bg.graphics.beginFill(0,BG_ALPHA);
				if(this._tfTimeAndTitle.numLines <= 1 && this._imgUrl == "") {
					this._bg.graphics.drawRect(0,0,this._focusTip == ""?ControllBarDef.IMAGE_PRE_TIME_SIZE.x:ControllBarDef.IMAGE_PRE_BIG_WH_SIZE.x,ControllBarDef.IMAGE_PRE_TIME_SIZE.y);
				} else {
					this._bg.graphics.drawRect(0,0,this._focusTip == ""?ControllBarDef.IMAGE_PRE_TIME_SIZE.x:ControllBarDef.IMAGE_PRE_BIG_WH_SIZE.x,ControllBarDef.IMAGE_PRE_FOCUS_TIP_SIZE.y);
				}
				this._bg.y = ControllBarDef.IMAGE_PRE_SMALL_SIZE.y - this._bg.height;
				this._bg.x = -(ControllBarDef.IMAGE_PRE_BIG_WH_SIZE.x - ControllBarDef.IMAGE_PRE_SMALL_SIZE.x) * 0.5;
				this._bg.graphics.endFill();
				this._bg.filters = [];
				this._tfTimeAndTitle.y = this._bg.y;
				this._tfTimeAndTitle.x = this._bg.x + (this._imgUrl == ""?0:ControllBarDef.IMAGE_PRE_BIG_WH_SIZE.x - ControllBarDef.IMAGE_PRE_FOCUS_TIP_SIZE.x);
				this._sprTimeAndTitle.width = this._tfTimeAndTitle.width;
				this._sprTimeAndTitle.height = this._tfTimeAndTitle.height;
				this._sprTimeAndTitle.x = this._tfTimeAndTitle.x;
				this._sprTimeAndTitle.y = this._tfTimeAndTitle.y;
			}
		}
		
		public function updateImageIndex(param1:int, param2:String = "", param3:String = "", param4:Number = -1) : void {
			this._imageIndex = param1;
			this._focusTip = param2;
			this._imgUrl = param3;
			this._curTime = param4;
			var _loc5_:BitmapData = PreviewImageLoader.instance.getImageByIndex(param1);
			if(_loc5_) {
				this._bitmap.bitmapData = _loc5_;
				if(this._picLoadingMC) {
					this._picLoadingMC.stop();
					if(this._picLoadingMC.parent) {
						removeChild(this._picLoadingMC);
					}
					this._picLoadingMC = null;
				}
				this._bitmap.smoothing = true;
			} else {
				if(PreviewImageLoader.instance.getDefaultImage()) {
					this._bitmap.bitmapData = PreviewImageLoader.instance.getDefaultImage();
				}
				if(!this._picLoadingMC) {
					this._picLoadingMC = new CommonLoadingMC();
				}
			}
			this._tfTimeAndTitle.text = this.getStringByTime();
			if(this._imgUrl == "") {
				this.destroyLoader();
			} else {
				this.requestGoodsImage();
			}
		}
		
		private function getStringByTime() : String {
			var _loc1_:* = "";
			if(this._focusTip == "") {
				if(this._curTime < 0) {
					_loc1_ = Strings.formatAsTimeCode(this._imageIndex * 10,this._imageIndex * 10000 > ConstUtils.H_2_MS);
				} else {
					_loc1_ = Strings.formatAsTimeCode(this._curTime / 1000,this._curTime > ConstUtils.H_2_MS);
				}
			} else if(this._curTime < 0) {
				_loc1_ = Strings.formatAsTimeCode(this._imageIndex * 10,this._imageIndex * 10000 > ConstUtils.H_2_MS) + "  " + this._focusTip;
			} else {
				_loc1_ = Strings.formatAsTimeCode(this._curTime / 1000,this._curTime > ConstUtils.H_2_MS) + "  " + this._focusTip;
			}
			
			return _loc1_;
		}
		
		private function requestGoodsImage() : void {
			this.destroyLoader();
			if(this._imgUrl != "") {
				this._loader = new Loader();
				this._loader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.onLoaderCompleteEvent);
				this._loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,this.onError);
				this._loader.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.onError);
				this._loader.load(new URLRequest(this._imgUrl + "?r=" + Math.random()));
			}
		}
		
		private function onLoaderCompleteEvent(param1:Event) : void {
			if(this._imgUrl == "") {
				return;
			}
			if(this._loader) {
				this._imgContainer.x = this._bg.x + 3;
				this._imgContainer.y = this._bg.y + 3 + (this._bitmap.parent?ControllBarDef.IMAGE_PRE_BIG_WH_SIZE.y:0);
				this._imgContainer.graphics.clear();
				this._imgContainer.graphics.beginFill(6921984,0);
				this._imgContainer.graphics.drawRect(0,0,MERCHANDISE_IMG_SIZE.x,MERCHANDISE_IMG_SIZE.y);
				this._imgContainer.graphics.endFill();
				this._imgContainer.mouseChildren = false;
				addChild(this._imgContainer);
				this._imgContainer.mask = this._imgMark;
				this._imgMark.graphics.clear();
				this._imgMark.graphics.beginFill(16711680,1);
				this._imgMark.graphics.drawCircle(MERCHANDISE_IMG_SIZE.x * 0.5,MERCHANDISE_IMG_SIZE.x * 0.5,MERCHANDISE_IMG_SIZE.x * 0.5);
				this._imgMark.graphics.endFill();
				this._imgContainer.addChild(this._imgMark);
				this._loader.width = MERCHANDISE_IMG_SIZE.x;
				this._loader.height = MERCHANDISE_IMG_SIZE.y;
				this._imgContainer.addChild(this._loader);
				this._imgContainer.addChild(this._lineShape);
				this._lineShape.graphics.clear();
				this._lineShape.graphics.lineStyle(2,6921984,0.9);
				this._lineShape.graphics.drawCircle(MERCHANDISE_IMG_SIZE.x * 0.5,MERCHANDISE_IMG_SIZE.x * 0.5,MERCHANDISE_IMG_SIZE.x * 0.5 - 1);
				this._lineShape.graphics.endFill();
			}
		}
		
		private function onError(param1:Event) : void {
			this.destroyLoader();
		}
		
		private function destroyLoader() : void {
			var obj:DisplayObject = null;
			if((this._loader) && (this._loader.parent)) {
				try {
					this._loader.unload();
				}
				catch(e:Error) {
				}
				this._loader.contentLoaderInfo.removeEventListener(Event.COMPLETE,this.onLoaderCompleteEvent);
				this._loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,this.onError);
				this._loader.contentLoaderInfo.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,this.onError);
				this._loader.parent.removeChild(this._loader);
				this._loader = null;
			}
			if((this._imgContainer) && (this._imgContainer.parent)) {
				while(this._imgContainer.numChildren > 0) {
					obj = this._imgContainer.getChildAt(0);
					this._imgContainer.removeChild(obj);
				}
				this._imgContainer.parent.removeChild(this._imgContainer);
			}
		}
		
		private function onGoodsClick(param1:MouseEvent) : void {
			if(this._imgUrl == "") {
				return;
			}
			dispatchEvent(new ControllBarEvent(ControllBarEvent.Evt_ImagePreViewGoodsClick,this._curTime));
		}
		
		private function onImageLoaderComplete(param1:Event) : void {
			var _loc2_:BitmapData = PreviewImageLoader.instance.getImageByIndex(this._imageIndex);
			if(_loc2_) {
				this._bitmap.bitmapData = _loc2_;
				if(this._picLoadingMC) {
					this._picLoadingMC.stop();
					if(this._picLoadingMC.parent) {
						removeChild(this._picLoadingMC);
					}
					this._picLoadingMC = null;
				}
				this._bitmap.smoothing = true;
			}
			if(this._isBigItem) {
				this._bitmap.width = ControllBarDef.IMAGE_PRE_BIG_WH_SIZE.x;
				this._bitmap.height = ControllBarDef.IMAGE_PRE_BIG_WH_SIZE.y;
			} else {
				this._bitmap.width = ControllBarDef.IMAGE_PRE_SMALL_SIZE.x;
				this._bitmap.height = ControllBarDef.IMAGE_PRE_SMALL_SIZE.y;
			}
		}
		
		public function destroy() : void {
			var _loc1_:DisplayObject = null;
			PreviewImageLoader.instance.removeEventListener(PreviewImageLoader.COMPLETE,this.onImageLoaderComplete);
			if(this._bitmap) {
				if(this._bitmap.parent) {
					removeChild(this._bitmap);
				}
				this._bitmap.bitmapData = null;
				this._bitmap = null;
			}
			if(this._bg) {
				if(this._bg.parent) {
					removeChild(this._bg);
				}
				this._bg = null;
			}
			while(this._imgContainer.numChildren > 0) {
				this._imgContainer.removeEventListener(MouseEvent.CLICK,this.onGoodsClick);
				_loc1_ = this._imgContainer.getChildAt(0);
				if((_loc1_) && (_loc1_.parent)) {
					_loc1_.parent.removeChild(_loc1_);
					_loc1_ = null;
				}
			}
			if(this._tfTimeAndTitle) {
				if(this._tfTimeAndTitle.parent) {
					removeChild(this._tfTimeAndTitle);
				}
				this._tfTimeAndTitle = null;
			}
			if(this._sprTimeAndTitle) {
				this._sprTimeAndTitle.removeEventListener(MouseEvent.CLICK,this.onGoodsClick);
				if(this._sprTimeAndTitle.parent) {
					removeChild(this._sprTimeAndTitle);
				}
				this._sprTimeAndTitle = null;
			}
			if(this._picLoadingMC) {
				this._picLoadingMC.stop();
				if(this._picLoadingMC.parent) {
					removeChild(this._picLoadingMC);
				}
				this._picLoadingMC = null;
			}
		}
	}
}
