package com.qiyi.player.wonder.plugins.controllbar.view.preview
{
	import flash.display.Sprite;
	import gs.TweenLite;
	import com.qiyi.player.wonder.plugins.controllbar.ControllBarDef;
	import com.qiyi.player.wonder.plugins.controllbar.view.ControllBarEvent;
	import flash.events.MouseEvent;
	
	public class ImagePreview extends Sprite
	{
		
		private var _previewItemList:Vector.<ImagePreviewItem>;
		
		private var _curTime:Number = 0;
		
		private var _focusTip:String = "";
		
		private var _imgUrl:String = "";
		
		private var _isImageListShow:Boolean = false;
		
		private var _isMouseIn:Boolean = false;
		
		private var _isHavImageData:Boolean = false;
		
		public function ImagePreview()
		{
			super();
			this.initUI();
		}
		
		public function get isHavImageData() : Boolean
		{
			return this._isHavImageData;
		}
		
		public function set isHavImageData(param1:Boolean) : void
		{
			this._isHavImageData = param1;
		}
		
		public function get isMouseIn() : Boolean
		{
			return this._isMouseIn;
		}
		
		public function set isMouseIn(param1:Boolean) : void
		{
			this._isMouseIn = param1;
		}
		
		public function get isImageListShow() : Boolean
		{
			return this._isImageListShow;
		}
		
		public function set isImageListShow(param1:Boolean) : void
		{
			this._isImageListShow = param1;
		}
		
		private function initUI() : void
		{
			this._previewItemList = new Vector.<ImagePreviewItem>();
		}
		
		public function hide() : void
		{
			TweenLite.killTweensOf(this);
			this.alpha = 1;
			TweenLite.to(this,0.1,{
				"alpha":0,
				"y":this.y + 10,
				"onComplete":this.onComplete
			});
		}
		
		private function onComplete() : void
		{
			var _loc1:ImagePreviewItem = null;
			TweenLite.killTweensOf(this.onDelayedCall);
			this._isImageListShow = false;
			for each(_loc1 in this._previewItemList)
			{
				if((_loc1) && (_loc1.parent))
				{
					removeChild(_loc1);
				}
			}
		}
		
		public function updateCurTime(param1:int, param2:String = "", param3:String = "") : void
		{
			var _loc4:* = 0;
			var _loc5:* = 0;
			this._curTime = param1;
			this._focusTip = param2;
			this._imgUrl = param3;
			this.alpha = 1;
			if(this._isImageListShow)
			{
				this.showPreviewItemList();
			}
			else
			{
				TweenLite.killTweensOf(this.onDelayedCall);
				if(this._isHavImageData)
				{
					TweenLite.delayedCall(ControllBarDef.IMAGE_PRE_DELAYEDCALL / 1000,this.onDelayedCall);
				}
				_loc4 = Math.floor(this._previewItemList.length / 2);
				_loc5 = Math.round(this._curTime / 10000);
				this._previewItemList[_loc4].updateImageIndex(_loc5,this._focusTip,this._imgUrl,this._curTime);
				this._previewItemList[_loc4].updateImageState(true,this._isImageListShow);
				this._previewItemList[_loc4].x = -this._previewItemList[_loc4].width * 0.5 + (ControllBarDef.IMAGE_PRE_BIG_WH_SIZE.x - ControllBarDef.IMAGE_PRE_SMALL_SIZE.x) * 0.5;
				addChild(this._previewItemList[_loc4]);
			}
		}
		
		public function showPreviewItemList(param1:Boolean = false) : void
		{
			var _loc2:* = 0;
			var _loc3:* = 0;
			var _loc4:uint = 0;
			if(param1)
			{
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
			if(this._previewItemList.length > 0)
			{
				_loc2 = Math.floor(this._previewItemList.length / 2);
				_loc3 = Math.round(this._curTime / 10000);
				this._previewItemList[_loc2].updateImageIndex(_loc3,this._focusTip,this._imgUrl,this._curTime);
				this._previewItemList[_loc2].updateImageState(true,this._isImageListShow);
				this._previewItemList[_loc2].x = -this._previewItemList[_loc2].width * 0.5 + (ControllBarDef.IMAGE_PRE_BIG_WH_SIZE.x - ControllBarDef.IMAGE_PRE_SMALL_SIZE.x) * 0.5;
				addChild(this._previewItemList[_loc2]);
				_loc4 = 1;
				while(_loc4 < _loc2 + 1)
				{
					this._previewItemList[_loc2 - _loc4].x = this._previewItemList[_loc2].x - ControllBarDef.IMAGE_PRE_SMALL_SIZE.x * _loc4;
					this._previewItemList[_loc2 - _loc4].updateImageIndex(_loc3 - _loc4);
					this._previewItemList[_loc2 - _loc4].updateImageState(false,this._isImageListShow);
					addChild(this._previewItemList[_loc2 - _loc4]);
					this._previewItemList[_loc2 + _loc4].x = this._previewItemList[_loc2].x + ControllBarDef.IMAGE_PRE_SMALL_SIZE.x * _loc4;
					this._previewItemList[_loc2 + _loc4].updateImageIndex(_loc3 + _loc4);
					this._previewItemList[_loc2 + _loc4].updateImageState(false,this._isImageListShow);
					addChild(this._previewItemList[_loc2 + _loc4]);
					_loc4++;
				}
				setChildIndex(this._previewItemList[_loc2],numChildren - 1);
			}
		}
		
		private function onDelayedCall() : void
		{
			dispatchEvent(new ControllBarEvent(ControllBarEvent.Evt_ImagePreviewVedioShow,this._focusTip == ""));
		}
		
		public function onResize(param1:int, param2:int) : void
		{
			var _loc4:ImagePreviewItem = null;
			var _loc3:int = Math.ceil(param1 / ControllBarDef.IMAGE_PRE_SMALL_SIZE.x) * 2 + 1;
			while(this._previewItemList.length > 0)
			{
				_loc4 = this._previewItemList.pop();
				_loc4.removeEventListener(MouseEvent.ROLL_OVER,this.onItemRollOver);
				_loc4.removeEventListener(MouseEvent.ROLL_OUT,this.onItemRollOut);
				_loc4.removeEventListener(MouseEvent.CLICK,this.onItemClick);
				_loc4.removeEventListener(ControllBarEvent.Evt_ImagePreViewGoodsClick,this.onImagePreviewGoodsImgClick);
				if(_loc4.parent)
				{
					_loc4.parent.removeChild(_loc4);
				}
				_loc4.destroy();
				_loc4 = null;
			}
			var _loc5:* = 0;
			while(_loc5 < _loc3)
			{
				_loc4 = new ImagePreviewItem();
				_loc4.index = _loc5;
				this._previewItemList.push(_loc4);
				_loc4.addEventListener(MouseEvent.ROLL_OVER,this.onItemRollOver);
				_loc4.addEventListener(MouseEvent.ROLL_OUT,this.onItemRollOut);
				_loc4.addEventListener(MouseEvent.CLICK,this.onItemClick);
				_loc4.addEventListener(ControllBarEvent.Evt_ImagePreViewGoodsClick,this.onImagePreviewGoodsImgClick);
				_loc5++;
			}
		}
		
		private function onItemRollOver(param1:MouseEvent) : void
		{
			var _loc3:* = 0;
			this._isMouseIn = true;
			dispatchEvent(new ControllBarEvent(ControllBarEvent.Evt_ImagePreviewMouseStateChange));
			var _loc2:ImagePreviewItem = param1.target as ImagePreviewItem;
			if(_loc2)
			{
				_loc3 = 0;
				this._previewItemList[_loc2.index].updateImageState(true,this._isImageListShow);
				_loc3 = _loc2.index - 1;
				while(_loc3 > 0)
				{
					this._previewItemList[_loc3].updateImageState(false,this._isImageListShow);
					_loc3--;
				}
				_loc3 = _loc2.index + 1;
				while(_loc3 < this._previewItemList.length)
				{
					this._previewItemList[_loc3].updateImageState(false,this._isImageListShow);
					_loc3++;
				}
				setChildIndex(this._previewItemList[_loc2.index],numChildren - 1);
			}
		}
		
		private function onItemRollOut(param1:MouseEvent) : void
		{
			this._isMouseIn = false;
			dispatchEvent(new ControllBarEvent(ControllBarEvent.Evt_ImagePreviewMouseStateChange));
		}
		
		private function onItemClick(param1:MouseEvent) : void
		{
			var _loc3:* = NaN;
			this._isMouseIn = false;
			var _loc2:ImagePreviewItem = param1.currentTarget as ImagePreviewItem;
			if(_loc2)
			{
				_loc3 = _loc2.curTime > 0?_loc2.curTime:_loc2.imageIndex * 10000;
				dispatchEvent(new ControllBarEvent(ControllBarEvent.Evt_ImagePreItemClick,_loc3));
			}
		}
		
		private function onImagePreviewGoodsImgClick(param1:ControllBarEvent) : void
		{
			this._isMouseIn = false;
			dispatchEvent(new ControllBarEvent(ControllBarEvent.Evt_ImagePreViewGoodsClick,param1.data));
		}
	}
}
