package com.qiyi.player.wonder.plugins.controllbar.view.preview {
	import flash.display.Sprite;
	import gs.TweenLite;
	import com.qiyi.player.wonder.plugins.controllbar.ControllBarDef;
	import com.qiyi.player.wonder.plugins.controllbar.view.ControllBarEvent;
	import flash.events.MouseEvent;
	
	public class ImagePreview extends Sprite {
		
		public function ImagePreview() {
			super();
			this.initUI();
		}
		
		private var _previewItemList:Vector.<ImagePreviewItem>;
		
		private var _curTime:Number = 0;
		
		private var _focusTip:String = "";
		
		private var _imgUrl:String = "";
		
		private var _isImageListShow:Boolean = false;
		
		private var _isMouseIn:Boolean = false;
		
		private var _isHavImageData:Boolean = false;
		
		public function get isHavImageData() : Boolean {
			return this._isHavImageData;
		}
		
		public function set isHavImageData(param1:Boolean) : void {
			this._isHavImageData = param1;
		}
		
		public function get isMouseIn() : Boolean {
			return this._isMouseIn;
		}
		
		public function set isMouseIn(param1:Boolean) : void {
			this._isMouseIn = param1;
		}
		
		public function get isImageListShow() : Boolean {
			return this._isImageListShow;
		}
		
		public function set isImageListShow(param1:Boolean) : void {
			this._isImageListShow = param1;
		}
		
		private function initUI() : void {
			this._previewItemList = new Vector.<ImagePreviewItem>();
		}
		
		public function hide() : void {
			TweenLite.killTweensOf(this);
			this.alpha = 1;
			TweenLite.to(this,0.1,{
				"alpha":0,
				"y":this.y + 10,
				"onComplete":this.onComplete
			});
		}
		
		private function onComplete() : void {
			var _loc1_:ImagePreviewItem = null;
			TweenLite.killTweensOf(this.onDelayedCall);
			this._isImageListShow = false;
			for each(_loc1_ in this._previewItemList) {
				if((_loc1_) && (_loc1_.parent)) {
					removeChild(_loc1_);
				}
			}
		}
		
		public function updateCurTime(param1:int, param2:String = "", param3:String = "") : void {
			var _loc4_:* = 0;
			var _loc5_:* = 0;
			this._curTime = param1;
			this._focusTip = param2;
			this._imgUrl = param3;
			this.alpha = 1;
			if(this._isImageListShow) {
				this.showPreviewItemList();
			} else {
				TweenLite.killTweensOf(this.onDelayedCall);
				if(this._isHavImageData) {
					TweenLite.delayedCall(ControllBarDef.IMAGE_PRE_DELAYEDCALL / 1000,this.onDelayedCall);
				}
				_loc4_ = Math.floor(this._previewItemList.length / 2);
				_loc5_ = Math.round(this._curTime / 10000);
				this._previewItemList[_loc4_].updateImageIndex(_loc5_,this._focusTip,this._imgUrl,this._curTime);
				this._previewItemList[_loc4_].updateImageState(true,this._isImageListShow);
				this._previewItemList[_loc4_].x = -this._previewItemList[_loc4_].width * 0.5 + (ControllBarDef.IMAGE_PRE_BIG_WH_SIZE.x - ControllBarDef.IMAGE_PRE_SMALL_SIZE.x) * 0.5;
				addChild(this._previewItemList[_loc4_]);
			}
		}
		
		public function showPreviewItemList(param1:Boolean = false) : void {
			var _loc2_:* = 0;
			var _loc3_:* = 0;
			var _loc4_:uint = 0;
			if(param1) {
				TweenLite.killTweensOf(this);
				TweenLite.killTweensOf(this.onDelayedCall);
				this._isImageListShow = true;
				this.y = this.y + 10;
				this.alpha = 0;
				TweenLite.to(this,0.2,{
					"alpha":1,
					"y":this.y - 10
				});
			}
			if(this._previewItemList.length > 0) {
				_loc2_ = Math.floor(this._previewItemList.length / 2);
				_loc3_ = Math.round(this._curTime / 10000);
				this._previewItemList[_loc2_].updateImageIndex(_loc3_,this._focusTip,this._imgUrl,this._curTime);
				this._previewItemList[_loc2_].updateImageState(true,this._isImageListShow);
				this._previewItemList[_loc2_].x = -this._previewItemList[_loc2_].width * 0.5 + (ControllBarDef.IMAGE_PRE_BIG_WH_SIZE.x - ControllBarDef.IMAGE_PRE_SMALL_SIZE.x) * 0.5;
				addChild(this._previewItemList[_loc2_]);
				_loc4_ = 1;
				while(_loc4_ < _loc2_ + 1) {
					this._previewItemList[_loc2_ - _loc4_].x = this._previewItemList[_loc2_].x - ControllBarDef.IMAGE_PRE_SMALL_SIZE.x * _loc4_;
					this._previewItemList[_loc2_ - _loc4_].updateImageIndex(_loc3_ - _loc4_);
					this._previewItemList[_loc2_ - _loc4_].updateImageState(false,this._isImageListShow);
					addChild(this._previewItemList[_loc2_ - _loc4_]);
					this._previewItemList[_loc2_ + _loc4_].x = this._previewItemList[_loc2_].x + ControllBarDef.IMAGE_PRE_SMALL_SIZE.x * _loc4_;
					this._previewItemList[_loc2_ + _loc4_].updateImageIndex(_loc3_ + _loc4_);
					this._previewItemList[_loc2_ + _loc4_].updateImageState(false,this._isImageListShow);
					addChild(this._previewItemList[_loc2_ + _loc4_]);
					_loc4_++;
				}
				setChildIndex(this._previewItemList[_loc2_],numChildren - 1);
			}
		}
		
		private function onDelayedCall() : void {
			dispatchEvent(new ControllBarEvent(ControllBarEvent.Evt_ImagePreviewVedioShow,this._focusTip == ""));
		}
		
		public function onResize(param1:int, param2:int) : void {
			var _loc4_:ImagePreviewItem = null;
			var _loc3_:int = Math.ceil(param1 / ControllBarDef.IMAGE_PRE_SMALL_SIZE.x) * 2 + 1;
			while(this._previewItemList.length > 0) {
				_loc4_ = this._previewItemList.pop();
				_loc4_.removeEventListener(MouseEvent.ROLL_OVER,this.onItemRollOver);
				_loc4_.removeEventListener(MouseEvent.ROLL_OUT,this.onItemRollOut);
				_loc4_.removeEventListener(MouseEvent.CLICK,this.onItemClick);
				_loc4_.removeEventListener(ControllBarEvent.Evt_ImagePreViewGoodsClick,this.onImagePreviewGoodsImgClick);
				if(_loc4_.parent) {
					_loc4_.parent.removeChild(_loc4_);
				}
				_loc4_.destroy();
				_loc4_ = null;
			}
			var _loc5_:* = 0;
			while(_loc5_ < _loc3_) {
				_loc4_ = new ImagePreviewItem();
				_loc4_.index = _loc5_;
				this._previewItemList.push(_loc4_);
				_loc4_.addEventListener(MouseEvent.ROLL_OVER,this.onItemRollOver);
				_loc4_.addEventListener(MouseEvent.ROLL_OUT,this.onItemRollOut);
				_loc4_.addEventListener(MouseEvent.CLICK,this.onItemClick);
				_loc4_.addEventListener(ControllBarEvent.Evt_ImagePreViewGoodsClick,this.onImagePreviewGoodsImgClick);
				_loc5_++;
			}
		}
		
		private function onItemRollOver(param1:MouseEvent) : void {
			var _loc3_:* = 0;
			this._isMouseIn = true;
			dispatchEvent(new ControllBarEvent(ControllBarEvent.Evt_ImagePreviewMouseStateChange));
			var _loc2_:ImagePreviewItem = param1.target as ImagePreviewItem;
			if(_loc2_) {
				_loc3_ = 0;
				this._previewItemList[_loc2_.index].updateImageState(true,this._isImageListShow);
				_loc3_ = _loc2_.index - 1;
				while(_loc3_ > 0) {
					this._previewItemList[_loc3_].updateImageState(false,this._isImageListShow);
					_loc3_--;
				}
				_loc3_ = _loc2_.index + 1;
				while(_loc3_ < this._previewItemList.length) {
					this._previewItemList[_loc3_].updateImageState(false,this._isImageListShow);
					_loc3_++;
				}
				setChildIndex(this._previewItemList[_loc2_.index],numChildren - 1);
			}
		}
		
		private function onItemRollOut(param1:MouseEvent) : void {
			this._isMouseIn = false;
			dispatchEvent(new ControllBarEvent(ControllBarEvent.Evt_ImagePreviewMouseStateChange));
		}
		
		private function onItemClick(param1:MouseEvent) : void {
			var _loc3_:* = NaN;
			this._isMouseIn = false;
			var _loc2_:ImagePreviewItem = param1.currentTarget as ImagePreviewItem;
			if(_loc2_) {
				_loc3_ = _loc2_.curTime > 0?_loc2_.curTime:_loc2_.imageIndex * 10000;
				dispatchEvent(new ControllBarEvent(ControllBarEvent.Evt_ImagePreItemClick,_loc3_));
			}
		}
		
		private function onImagePreviewGoodsImgClick(param1:ControllBarEvent) : void {
			this._isMouseIn = false;
			dispatchEvent(new ControllBarEvent(ControllBarEvent.Evt_ImagePreViewGoodsClick,param1.data));
		}
	}
}
