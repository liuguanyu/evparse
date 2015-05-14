package com.qiyi.player.wonder.plugins.scenetile.view.barragepart
{
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.display.MovieClip;
	import flash.display.Bitmap;
	import flash.display.Shape;
	import flash.text.TextField;
	import flash.filters.GlowFilter;
	import com.qiyi.player.wonder.plugins.scenetile.model.barrage.BarrageInfo;
	import com.iqiyi.components.global.GlobalStage;
	import flash.display.BitmapData;
	import com.qiyi.player.wonder.plugins.scenetile.SceneTileDef;
	import scenetile.BarrageRainbow;
	import scenetile.BarrageKiwi;
	import flash.events.Event;
	import flash.text.TextFieldType;
	import flash.text.TextFieldAutoSize;
	import com.qiyi.player.wonder.common.ui.FastCreator;
	import flash.display.DisplayObject;
	import scenetile.BarrageGreenColorBG;
	import scenetile.BarrageBlackColorBG;
	import scenetile.BarrageGreyColorBG;
	import scenetile.BarrageLightBlueColorBG;
	import scenetile.BarragePaleBlueColorBG;
	import scenetile.BarragePinkColorBG;
	
	public class BarrageItem extends Sprite
	{
		
		private static const HEAD_SIZE:Point = new Point(43,43);
		
		private static const FONT_COLOR:uint = 11003435;
		
		private static const FONT_SIZE:uint = 24;
		
		private static const FACE_TEXT_LEN:int = 5;
		
		private static const BARRAGE_BG_GAP:int = 10;
		
		private var _barrageBG:MovieClip;
		
		private var _barrageBGDec:MovieClip;
		
		private var _starHeadImg:Bitmap;
		
		private var _starHeadImgMask:Sprite;
		
		private var _depictShape:Shape;
		
		private var _depictTF:TextField;
		
		private var _glowFilter:GlowFilter;
		
		private var _barrageInfo:BarrageInfo;
		
		private var _row:uint = 0;
		
		private var _isSelfSend:Boolean = false;
		
		private var _isFilterImage:Boolean = false;
		
		private var _preBarrageItem:BarrageItem = null;
		
		private var _isFastComplete:Boolean = false;
		
		public function BarrageItem()
		{
			super();
			this._glowFilter = new GlowFilter(0,1,2,2,5);
			this.mouseChildren = false;
		}
		
		public function get isFilterImage() : Boolean
		{
			return this._isFilterImage;
		}
		
		public function set isFilterImage(param1:Boolean) : void
		{
			this._isFilterImage = param1;
		}
		
		public function get preBarrageItem() : BarrageItem
		{
			return this._preBarrageItem;
		}
		
		public function set preBarrageItem(param1:BarrageItem) : void
		{
			this._preBarrageItem = param1;
		}
		
		public function get isSelfSend() : Boolean
		{
			return this._isSelfSend;
		}
		
		public function set isSelfSend(param1:Boolean) : void
		{
			this._isSelfSend = param1;
		}
		
		public function get row() : uint
		{
			return this._row;
		}
		
		public function set row(param1:uint) : void
		{
			this._row = param1;
			this.onResize(GlobalStage.stage.stageWidth,GlobalStage.stage.stageHeight);
		}
		
		public function get barrageInfo() : BarrageInfo
		{
			return this._barrageInfo;
		}
		
		public function onResize(param1:int, param2:int) : void
		{
			this.removeDepictLayer();
			if(GlobalStage.isFullScreen())
			{
				this.y = (this._row + 1) * 60 - 20;
			}
			else
			{
				this.y = this._row * 60 - 20;
			}
		}
		
		public function set barrageInfo(param1:BarrageInfo) : void
		{
			var _loc2:BitmapData = null;
			if(this._barrageInfo)
			{
				this._barrageInfo.update(param1.contentId,param1.showTime,param1.content,param1.likes,param1.fontSize,param1.fontColor,param1.position,param1.contentType,param1.bgType,param1.userInfo);
			}
			else
			{
				this._barrageInfo = param1;
			}
			if(this._barrageBGDec)
			{
				if(this._barrageBGDec.parent)
				{
					this._barrageBGDec.parent.removeChild(this._barrageBGDec);
				}
				this._barrageBGDec = null;
			}
			if(this._barrageBG)
			{
				if(this._barrageBG.parent)
				{
					this._barrageBG.parent.removeChild(this._barrageBG);
				}
				this._barrageBG = null;
			}
			if(this._starHeadImg)
			{
				if(this._starHeadImg.parent)
				{
					this._starHeadImg.parent.removeChild(this._starHeadImg);
				}
				this._starHeadImg = null;
			}
			if(this._starHeadImgMask)
			{
				if(this._starHeadImgMask.parent)
				{
					this._starHeadImgMask.parent.removeChild(this._starHeadImgMask);
				}
				this._starHeadImgMask = null;
			}
			if(this._barrageInfo.contentType == SceneTileDef.BARRAGE_CONTENT_TYPE_STAR)
			{
				_loc2 = null;
				if((this._barrageInfo.userInfo) && (this._barrageInfo.userInfo.picS))
				{
					_loc2 = BarrageStarHeadImage.instance.getHeadImageByUrl(this._barrageInfo.userInfo.picS);
				}
				this._starHeadImg = new Bitmap();
				this._starHeadImgMask = new Sprite();
				if(_loc2)
				{
					this._starHeadImg.bitmapData = _loc2;
					this._starHeadImg.width = this._starHeadImg.height = HEAD_SIZE.x;
					this._starHeadImgMask.graphics.beginFill(16776960,0.8);
					this._starHeadImgMask.graphics.drawRoundRect(0,0,HEAD_SIZE.x,HEAD_SIZE.y,10,10);
					this._starHeadImgMask.graphics.endFill();
					this._starHeadImg.mask = this._starHeadImgMask;
				}
				else
				{
					BarrageStarHeadImage.instance.addEventListener(BarrageStarHeadImage.COMPLETE,this.onHeadImgComplete);
				}
				this._barrageBG = this.getBGType(this._barrageInfo.bgType);
				if(this._barrageBG)
				{
					this._barrageBG.alpha = 0.5;
				}
				if(this._barrageInfo.bgType == SceneTileDef.BARRAGE_BG_TYPE_PALEBLUE)
				{
					this._barrageBGDec = new BarrageRainbow();
				}
				else if(this._barrageInfo.bgType == SceneTileDef.BARRAGE_BG_TYPE_GREY)
				{
					this._barrageBGDec = new BarrageKiwi();
				}
				
			}
			this.update();
			if(this._barrageInfo.contentType == SceneTileDef.BARRAGE_CONTENT_TYPE_STAR)
			{
				if(this._starHeadImgMask)
				{
					addChildAt(this._starHeadImgMask,0);
				}
				if(this._starHeadImg)
				{
					addChildAt(this._starHeadImg,0);
				}
				if(this._barrageBG)
				{
					addChildAt(this._barrageBG,0);
				}
				if(this._barrageBGDec)
				{
					this._barrageBGDec.y = 1;
					addChild(this._barrageBGDec);
				}
			}
			graphics.clear();
			if((this._isSelfSend) && numChildren > 0)
			{
				graphics.lineStyle(2,FONT_COLOR,1);
				graphics.drawRect(-2,-2,width + 4,height + 4);
			}
		}
		
		private function onHeadImgComplete(param1:Event) : void
		{
			var _loc2:BitmapData = null;
			if(this._barrageInfo.userInfo.picS)
			{
				_loc2 = BarrageStarHeadImage.instance.getHeadImageByUrl(this._barrageInfo.userInfo.picS);
			}
			if(_loc2)
			{
				BarrageStarHeadImage.instance.removeEventListener(BarrageStarHeadImage.COMPLETE,this.onHeadImgComplete);
				this._starHeadImg.bitmapData = _loc2;
				this._starHeadImg.width = this._starHeadImg.height = HEAD_SIZE.x;
				this._starHeadImgMask.graphics.beginFill(16711680,0.8);
				this._starHeadImgMask.graphics.drawRoundRect(0,0,HEAD_SIZE.x,HEAD_SIZE.y,10,10);
				this._starHeadImgMask.graphics.endFill();
				this._starHeadImg.mask = this._starHeadImgMask;
			}
		}
		
		public function update() : void
		{
			var _loc1:* = 0;
			var _loc2:String = null;
			var _loc3:String = null;
			var _loc4:String = null;
			var _loc5:String = null;
			var _loc6:BitmapData = null;
			var _loc7:* = 0;
			var _loc8:* = 0;
			if(this._barrageInfo)
			{
				_loc1 = this._barrageInfo.content.length;
				_loc2 = "";
				_loc3 = "";
				_loc4 = "";
				_loc5 = "";
				_loc6 = null;
				_loc7 = 0;
				while(_loc7 < _loc1)
				{
					_loc3 = this._barrageInfo.content.charAt(_loc7);
					if(_loc3 == "[")
					{
						_loc8 = 0;
						while(_loc8 < FACE_TEXT_LEN)
						{
							if(_loc7 + _loc8 < _loc1)
							{
								_loc5 = this._barrageInfo.content.charAt(_loc7 + _loc8);
								if(!(_loc8 == 0) && _loc5 == "[")
								{
									_loc2 = _loc2 + _loc4;
									_loc4 = "";
									_loc4 = _loc4 + _loc5;
									_loc7 = _loc7 + _loc8;
									_loc8 = 0;
								}
								else
								{
									_loc4 = _loc4 + _loc5;
									if(_loc8 == FACE_TEXT_LEN - 1)
									{
										_loc6 = BarrageExpressionImage.instance.getBitmapdataByContent(_loc4);
										if(_loc6 == null)
										{
											_loc2 = _loc2 + _loc4;
										}
										_loc7 = _loc7 + _loc8;
										_loc4 = "";
										break;
									}
								}
								if(_loc8 == FACE_TEXT_LEN - 1)
								{
									_loc2 = _loc2 + _loc4;
									_loc7 = _loc7 + _loc8;
									_loc4 = "";
								}
								_loc8++;
								continue;
							}
							_loc2 = _loc2 + _loc4;
							_loc7 = _loc7 + _loc8;
							_loc4 = "";
							break;
						}
						if((_loc6) && !this._isFilterImage)
						{
							if(_loc2)
							{
								this.createTextField(_loc2);
								_loc2 = "";
							}
							this.createBitmap(_loc6);
							_loc6 = null;
						}
					}
					else
					{
						_loc2 = _loc2 + _loc3;
					}
					_loc7++;
				}
				if(_loc2)
				{
					this.createTextField(_loc2);
					_loc2 = "";
				}
				this.layout();
			}
		}
		
		private function createTextField(param1:String) : void
		{
			var _loc2:TextField = new TextField();
			_loc2.type = TextFieldType.DYNAMIC;
			_loc2.selectable = false;
			_loc2.autoSize = TextFieldAutoSize.LEFT;
			_loc2.defaultTextFormat = FastCreator.createTextFormat("微软雅黑",this.getFontSizeBySign(this._barrageInfo.fontSize),int("0x" + this._barrageInfo.fontColor),false);
			_loc2.text = param1;
			this._glowFilter.color = this._barrageInfo.fontColor == "000000" || this._barrageInfo.fontColor == "undefined"?16777215:0;
			_loc2.filters = null;
			_loc2.filters = [this._glowFilter];
			addChild(_loc2);
		}
		
		private function createBitmap(param1:BitmapData) : void
		{
			var _loc2:Bitmap = new Bitmap(param1);
			addChild(_loc2);
		}
		
		private function layout() : void
		{
			var _loc1:DisplayObject = null;
			var _loc2:Number = 0;
			var _loc3:int = this._barrageInfo.contentType == SceneTileDef.BARRAGE_CONTENT_TYPE_STAR?BARRAGE_BG_GAP + HEAD_SIZE.x:0;
			var _loc4:* = 0;
			_loc4 = 0;
			while(_loc4 < numChildren)
			{
				_loc1 = getChildAt(_loc4);
				_loc2 = _loc2 > _loc1.height?_loc2:_loc1.height;
				if(this._barrageBG)
				{
					_loc2 = _loc2 > this._barrageBG.height?_loc2:this._barrageBG.height;
				}
				_loc4++;
			}
			_loc4 = 0;
			while(_loc4 < numChildren)
			{
				_loc1 = getChildAt(_loc4);
				_loc1.x = _loc3;
				_loc1.y = (_loc2 - _loc1.height) / 2;
				_loc3 = _loc3 + _loc1.width;
				_loc4++;
			}
			if(this._barrageBG)
			{
				this._barrageBG.width = _loc3 + BARRAGE_BG_GAP * 2 + (this._barrageBGDec?this._barrageBGDec.width:0) - HEAD_SIZE.x;
				this._barrageBG.x = HEAD_SIZE.x;
			}
			if(this._barrageBGDec)
			{
				if(this._barrageInfo.bgType == SceneTileDef.BARRAGE_BG_TYPE_PALEBLUE)
				{
					this._barrageBGDec.y = 1;
					this._barrageBGDec.x = _loc3 + BARRAGE_BG_GAP * 2 + 12;
				}
				else if(this._barrageInfo.bgType == SceneTileDef.BARRAGE_BG_TYPE_GREY)
				{
					this._barrageBGDec.y = -5;
					this._barrageBGDec.x = _loc3 + BARRAGE_BG_GAP * 2 + 12;
				}
				
			}
		}
		
		public function updateAlpha(param1:uint) : void
		{
			if(param1 > 0)
			{
				this.alpha = param1 / 100;
			}
			else
			{
				this.alpha = SceneTileDef.BARRAGE_DEFAULT_ALPHA / 100;
			}
		}
		
		public function updateCoordinateOnStar(param1:Number = -10000) : void
		{
			if(this._barrageInfo.contentType == SceneTileDef.BARRAGE_CONTENT_TYPE_STAR)
			{
				if(this.x > param1)
				{
					this.x = this.x - SceneTileDef.BARRAGE_ROW_SPEED[this._row - 1];
				}
			}
			else
			{
				this.x = this.x - SceneTileDef.BARRAGE_ROW_SPEED[this._row - 1];
			}
		}
		
		public function updateCoordinate() : void
		{
			var _loc1:Number = 0;
			var _loc2:Number = GlobalStage.stage.stageWidth / 2 + this.row * 50;
			if(this.x < 0 && Math.abs(this.x) / this.width >= SceneTileDef.BARRAGE_DELETE_PERCENT / 100)
			{
				_loc1 = SceneTileDef.BARRAGE_OUT_FLY_SPEED;
				this.x = this.x - _loc1;
				return;
			}
			if(this._preBarrageItem)
			{
				if(this._preBarrageItem.x + this._preBarrageItem.width + SceneTileDef.BARRAGE_ITEM_GAP < GlobalStage.stage.stageWidth / 2)
				{
					_loc2 = GlobalStage.stage.stageWidth / 2 + this.row * 50;
				}
				else
				{
					_loc2 = this._preBarrageItem.x + this._preBarrageItem.width + SceneTileDef.BARRAGE_ITEM_GAP;
				}
			}
			if(this._isFastComplete)
			{
				_loc1 = SceneTileDef.BARRAGE_ROW_SPEED[this._row - 1];
				this.x = this.x - _loc1;
				return;
			}
			if(this.x - SceneTileDef.BARRAGE_IN_FLY_SPEED <= _loc2)
			{
				_loc1 = this.x - _loc2;
				this._isFastComplete = true;
				this.x = this.x - _loc1;
			}
			else
			{
				_loc1 = SceneTileDef.BARRAGE_IN_FLY_SPEED;
				this.x = this.x - _loc1;
			}
		}
		
		public function addDepictLayer() : void
		{
			if(!this._isSelfSend)
			{
				this._depictTF = FastCreator.createLabel("点击回复",16777215,18,TextFieldAutoSize.LEFT);
				this._depictTF.x = (this.width - this._depictTF.width) / 2;
				this._depictTF.y = (this.height - this._depictTF.height) / 2;
				this._depictTF.mouseEnabled = this._depictTF.selectable = false;
				this._depictShape = new Shape();
				this._depictShape.graphics.beginFill(0,0.8);
				this._depictShape.graphics.drawRect(this.width < this._depictTF.width?this._depictTF.x:0,0,this.width < this._depictTF.width?this._depictTF.width:this.width,this.height);
				this._depictShape.graphics.endFill();
				addChild(this._depictShape);
				addChild(this._depictTF);
			}
		}
		
		public function removeDepictLayer() : void
		{
			if((this._depictShape) && (this._depictShape.parent))
			{
				this._depictShape.graphics.clear();
				removeChild(this._depictShape);
				this._depictShape = null;
			}
			if((this._depictTF) && (this._depictTF.parent))
			{
				removeChild(this._depictTF);
				this._depictTF = null;
			}
		}
		
		private function getFontSizeBySign(param1:uint) : uint
		{
			var _loc2:uint = 0;
			while(_loc2 < SceneTileDef.BARRAGE_FONT_SIZE_SIGN_ARRAY.length)
			{
				if(param1 == SceneTileDef.BARRAGE_FONT_SIZE_SIGN_ARRAY[_loc2])
				{
					return SceneTileDef.BARRAGE_FONT_SIZE_ARRAY[_loc2];
				}
				_loc2++;
			}
			return SceneTileDef.BARRAGE_FONT_SIZE_ARRAY[SceneTileDef.BARRAGE_FONT_SIZE_ARRAY.length - 1];
		}
		
		private function getBGType(param1:uint) : MovieClip
		{
			var _loc2:MovieClip = null;
			switch(param1)
			{
				case SceneTileDef.BARRAGE_BG_TYPE_GREEN:
					_loc2 = new BarrageGreenColorBG();
					break;
				case SceneTileDef.BARRAGE_BG_TYPE_BLACK:
					_loc2 = new BarrageBlackColorBG();
					break;
				case SceneTileDef.BARRAGE_BG_TYPE_GREY:
					_loc2 = new BarrageGreyColorBG();
					break;
				case SceneTileDef.BARRAGE_BG_TYPE_LIGHTBLUE:
					_loc2 = new BarrageLightBlueColorBG();
					break;
				case SceneTileDef.BARRAGE_BG_TYPE_PALEBLUE:
					_loc2 = new BarragePaleBlueColorBG();
					break;
				case SceneTileDef.BARRAGE_BG_TYPE_PINK:
					_loc2 = new BarragePinkColorBG();
					break;
			}
			return _loc2;
		}
		
		public function clear() : void
		{
			var _loc1:DisplayObject = null;
			BarrageStarHeadImage.instance.removeEventListener(BarrageStarHeadImage.COMPLETE,this.onHeadImgComplete);
			this._preBarrageItem = null;
			this._isSelfSend = false;
			this._isFastComplete = false;
			this._barrageInfo = null;
			this._row = 0;
			graphics.clear();
			while(numChildren > 0)
			{
				_loc1 = removeChildAt(0);
				_loc1 = null;
			}
		}
	}
}
