package com.qiyi.player.wonder.plugins.feedback.view.parts.copyrightexpired
{
	import flash.display.Sprite;
	import com.qiyi.player.wonder.plugins.recommend.model.RecommendVO;
	import common.CommonPageTurningArrow;
	import flash.events.MouseEvent;
	import gs.TweenLite;
	import com.qiyi.player.wonder.plugins.feedback.view.FeedbackEvent;
	
	public class CopyrightExpiredListPart extends Sprite
	{
		
		private static const GAP_OF_ITEM:uint = 12;
		
		private static const GAP_OF_BTN:uint = 50;
		
		private static const GAP_OF_SIDES:uint = 50;
		
		private static const ITEM_HEIGHT:uint = 110;
		
		private static const PAGE_TURNING_TIME:uint = 5;
		
		private var _recommendData:Vector.<RecommendVO> = null;
		
		private var _itemVector:Vector.<CopyrightExpiredRecommendItem> = null;
		
		private var _currPage:uint = 0;
		
		private var _maxPage:uint = 0;
		
		private var _maxShowItem:uint = 0;
		
		private var _leftArrow:CommonPageTurningArrow;
		
		private var _rightArrow:CommonPageTurningArrow;
		
		private var _listContainer:Sprite;
		
		private var _listContainerMask:Sprite;
		
		private var _isMove:Boolean = false;
		
		public function CopyrightExpiredListPart()
		{
			super();
			this._itemVector = new Vector.<CopyrightExpiredRecommendItem>();
			this._recommendData = new Vector.<RecommendVO>();
			this.initPanel();
		}
		
		public function get recommendData() : Vector.<RecommendVO>
		{
			return this._recommendData;
		}
		
		public function set recommendData(param1:Vector.<RecommendVO>) : void
		{
			var _loc2:CopyrightExpiredRecommendItem = null;
			var _loc3:uint = 0;
			this._recommendData = param1;
			if(this._recommendData)
			{
				_loc3 = 0;
				while(_loc3 < this._recommendData.length)
				{
					_loc2 = new CopyrightExpiredRecommendItem(this._recommendData[_loc3]);
					_loc2.x = (_loc2.width + GAP_OF_ITEM) * _loc3 + GAP_OF_ITEM * 0.5;
					this._itemVector.push(_loc2);
					this._listContainer.addChild(_loc2);
					_loc2.addEventListener(MouseEvent.CLICK,this.onItemMouseClick);
					_loc3++;
				}
			}
			TweenLite.to(this,PAGE_TURNING_TIME,{"onComplete":this.onAutoPageTurn});
		}
		
		private function initPanel() : void
		{
			this._listContainer = new Sprite();
			this._listContainer.graphics.beginFill(16711680,0);
			this._listContainer.graphics.drawRect(0,0,1,1);
			this._listContainer.graphics.endFill();
			addChild(this._listContainer);
			this._listContainerMask = new Sprite();
			this._listContainerMask.graphics.beginFill(16711680,0.5);
			this._listContainerMask.graphics.drawRect(0,0,1,1);
			this._listContainerMask.graphics.endFill();
			addChild(this._listContainerMask);
			this._listContainer.mask = this._listContainerMask;
			this._leftArrow = new CommonPageTurningArrow();
			this._leftArrow.buttonMode = true;
			this._leftArrow.useHandCursor = true;
			this._leftArrow.addEventListener(MouseEvent.ROLL_OVER,this.onLeftArrowOver);
			this._leftArrow.addEventListener(MouseEvent.ROLL_OUT,this.onLeftArrowOut);
			this._leftArrow.addEventListener(MouseEvent.CLICK,this.onLeftArrowClick);
			this._leftArrow.scaleX = -1;
			addChild(this._leftArrow);
			this._rightArrow = new CommonPageTurningArrow();
			this._rightArrow.buttonMode = true;
			this._rightArrow.useHandCursor = true;
			this._rightArrow.addEventListener(MouseEvent.ROLL_OVER,this.onRightArrowOver);
			this._rightArrow.addEventListener(MouseEvent.ROLL_OUT,this.onRightArrowOut);
			this._rightArrow.addEventListener(MouseEvent.CLICK,this.onRightArrowClick);
			addChild(this._rightArrow);
		}
		
		private function onItemMouseClick(param1:MouseEvent) : void
		{
			var _loc2:CopyrightExpiredRecommendItem = param1.target as CopyrightExpiredRecommendItem;
			if(_loc2)
			{
				dispatchEvent(new FeedbackEvent(FeedbackEvent.Evt_CopyrightRecItemClick,_loc2.data));
			}
		}
		
		private function onLeftArrowClick(param1:MouseEvent = null) : void
		{
			var _loc2:* = 0;
			TweenLite.killTweensOf(this);
			if(this._currPage > 0 && !this._isMove)
			{
				this._currPage = this._currPage - 1;
				this._isMove = true;
				_loc2 = this._listContainer.x + (CopyrightExpiredRecommendItem.ITEM_WIDTH + GAP_OF_ITEM) * this._maxShowItem;
				TweenLite.to(this._listContainer,0.5,{
					"x":_loc2,
					"onComplete":this.onTweenComplete
				});
			}
		}
		
		private function onLeftArrowOver(param1:MouseEvent) : void
		{
			this._leftArrow.gotoAndStop(2);
		}
		
		private function onLeftArrowOut(param1:MouseEvent) : void
		{
			this._leftArrow.gotoAndStop(1);
		}
		
		private function onRightArrowClick(param1:MouseEvent = null) : void
		{
			var _loc2:* = 0;
			TweenLite.killTweensOf(this);
			if(this._currPage < this._maxPage && !this._isMove)
			{
				this._currPage = this._currPage + 1;
				this._isMove = true;
				_loc2 = this._listContainer.x - (CopyrightExpiredRecommendItem.ITEM_WIDTH + GAP_OF_ITEM) * this._maxShowItem;
				TweenLite.to(this._listContainer,0.5,{
					"x":_loc2,
					"onComplete":this.onTweenComplete
				});
			}
		}
		
		private function onRightArrowOver(param1:MouseEvent) : void
		{
			this._rightArrow.gotoAndStop(2);
		}
		
		private function onRightArrowOut(param1:MouseEvent) : void
		{
			this._rightArrow.gotoAndStop(1);
		}
		
		private function onTweenComplete() : void
		{
			this._isMove = false;
			TweenLite.killTweensOf(this);
			TweenLite.killTweensOf(this._listContainer);
			if(this._currPage <= 0)
			{
				this.enableLeftArrow(false);
			}
			else
			{
				this.enableLeftArrow(true);
			}
			if(this._currPage >= this._maxPage)
			{
				this.enableRightArrow(false);
			}
			else
			{
				this.enableRightArrow(true);
			}
			TweenLite.to(this,PAGE_TURNING_TIME,{"onComplete":this.onAutoPageTurn});
		}
		
		private function onAutoPageTurn() : void
		{
			TweenLite.killTweensOf(this);
			this.onRightArrowClick();
		}
		
		private function enableLeftArrow(param1:Boolean) : void
		{
			if(param1)
			{
				this._leftArrow.gotoAndStop(1);
				this._leftArrow.mouseChildren = true;
				this._leftArrow.mouseEnabled = true;
				if(!this._leftArrow.hasEventListener(MouseEvent.ROLL_OVER))
				{
					this._leftArrow.addEventListener(MouseEvent.ROLL_OVER,this.onLeftArrowOver);
					this._leftArrow.addEventListener(MouseEvent.ROLL_OUT,this.onLeftArrowOut);
				}
			}
			else
			{
				this._leftArrow.removeEventListener(MouseEvent.ROLL_OVER,this.onLeftArrowOver);
				this._leftArrow.removeEventListener(MouseEvent.ROLL_OUT,this.onLeftArrowOut);
				this._leftArrow.mouseChildren = false;
				this._leftArrow.mouseEnabled = false;
				this._leftArrow.gotoAndStop(3);
			}
		}
		
		private function enableRightArrow(param1:Boolean) : void
		{
			if(param1)
			{
				this._rightArrow.gotoAndStop(1);
				this._rightArrow.mouseChildren = true;
				this._rightArrow.mouseEnabled = true;
				if(!this._rightArrow.hasEventListener(MouseEvent.ROLL_OVER))
				{
					this._rightArrow.addEventListener(MouseEvent.ROLL_OVER,this.onRightArrowOver);
					this._rightArrow.addEventListener(MouseEvent.ROLL_OUT,this.onRightArrowOut);
				}
			}
			else
			{
				this._rightArrow.removeEventListener(MouseEvent.ROLL_OVER,this.onRightArrowOver);
				this._rightArrow.removeEventListener(MouseEvent.ROLL_OUT,this.onRightArrowOut);
				this._rightArrow.mouseChildren = false;
				this._rightArrow.mouseEnabled = false;
				this._rightArrow.gotoAndStop(3);
			}
		}
		
		public function resize(param1:Number, param2:Number) : void
		{
			var _loc3:* = NaN;
			var _loc4:* = NaN;
			this._isMove = false;
			this._currPage = 0;
			this._maxShowItem = Math.floor((param1 - GAP_OF_SIDES * 2 - GAP_OF_BTN * 2) / (CopyrightExpiredRecommendItem.ITEM_WIDTH + GAP_OF_ITEM));
			_loc3 = GAP_OF_BTN * 2 + this._maxShowItem * (CopyrightExpiredRecommendItem.ITEM_WIDTH + GAP_OF_ITEM);
			_loc4 = (param1 - _loc3) / 2;
			this._leftArrow.x = _loc4 + this._leftArrow.width + (GAP_OF_BTN - this._leftArrow.width) / 2;
			this._rightArrow.x = _loc4 + _loc3 - this._rightArrow.width - (GAP_OF_BTN - this._leftArrow.width) / 2;
			this._leftArrow.y = this._rightArrow.y = (ITEM_HEIGHT - this._rightArrow.height) * 0.5 - 5;
			this._listContainer.x = _loc4 + GAP_OF_BTN;
			this._listContainerMask.x = _loc4 + GAP_OF_BTN;
			this._listContainerMask.width = _loc3 - GAP_OF_BTN * 2;
			this._listContainerMask.height = ITEM_HEIGHT;
			this._maxPage = Math.ceil(this._recommendData.length / this._maxShowItem) - 1;
			if(this._currPage <= 0)
			{
				this.enableLeftArrow(false);
			}
			else
			{
				this.enableLeftArrow(true);
			}
			if(this._currPage >= this._maxPage)
			{
				this.enableRightArrow(false);
			}
			else
			{
				this.enableRightArrow(true);
			}
		}
		
		public function destory() : void
		{
			var _loc1:CopyrightExpiredRecommendItem = null;
			if((this._listContainerMask) && (this._listContainerMask.parent))
			{
				this._listContainerMask.graphics.clear();
				removeChild(this._listContainerMask);
				this._listContainerMask = null;
			}
			if((this._leftArrow) && (this._leftArrow.parent))
			{
				this._leftArrow.removeEventListener(MouseEvent.ROLL_OVER,this.onLeftArrowOver);
				this._leftArrow.removeEventListener(MouseEvent.ROLL_OUT,this.onLeftArrowOut);
				this._leftArrow.removeEventListener(MouseEvent.CLICK,this.onLeftArrowClick);
				removeChild(this._leftArrow);
				this._leftArrow = null;
			}
			if((this._rightArrow) && (this._rightArrow.parent))
			{
				this._rightArrow.removeEventListener(MouseEvent.ROLL_OVER,this.onRightArrowOver);
				this._rightArrow.removeEventListener(MouseEvent.ROLL_OUT,this.onRightArrowOut);
				this._rightArrow.removeEventListener(MouseEvent.CLICK,this.onRightArrowClick);
				removeChild(this._rightArrow);
				this._rightArrow = null;
			}
			if(this._itemVector)
			{
				while(this._itemVector.length > 0)
				{
					_loc1 = this._itemVector.shift();
					if(_loc1.parent)
					{
						_loc1.parent.removeChild(_loc1);
					}
					_loc1.removeEventListener(MouseEvent.CLICK,this.onItemMouseClick);
					_loc1.destroy();
					_loc1 = null;
				}
			}
			if((this._listContainer) && (this._listContainer.parent))
			{
				this._listContainer.graphics.clear();
				removeChild(this._listContainer);
				this._listContainer = null;
			}
		}
	}
}
