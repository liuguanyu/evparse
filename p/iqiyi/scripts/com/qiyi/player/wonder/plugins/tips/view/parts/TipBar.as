package com.qiyi.player.wonder.plugins.tips.view.parts
{
	import flash.display.Sprite;
	import common.CommonCloseBtn;
	import flash.geom.Matrix;
	import flash.display.GradientType;
	import gs.TweenLite;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	import flash.events.Event;
	import flash.events.TextEvent;
	import flash.text.TextField;
	import flash.text.StyleSheet;
	import flash.display.DisplayObject;
	
	public class TipBar extends Sprite
	{
		
		private var textCacheAsBitmap:Boolean = false;
		
		protected var tipContainer:Sprite;
		
		protected var _btnClose:CommonCloseBtn;
		
		protected var defaultCSS:String = "p{color:#ffffff;font-size:14;font-family:微软雅黑} .light{color:#83A80B;} a{color:#83A80B;}a:hover{color:#ffffff;text-decoration:underline} a:active{color:#ffffff;text-decoration:underline}";
		
		private var currTipId:String;
		
		private var _matrix:Matrix;
		
		private var hideTimeoutId:int;
		
		public function TipBar(param1:Boolean = false)
		{
			super();
			this._matrix = new Matrix();
			this.textCacheAsBitmap = param1;
			this.tipContainer = new Sprite();
			this.tipContainer.x = 5;
			addChild(this.tipContainer);
			this._btnClose = new CommonCloseBtn();
			this._btnClose.y = 1;
			addChild(this._btnClose);
			this._btnClose.addEventListener(MouseEvent.CLICK,this.onMouseClick);
			this.addEventListener(Event.ADDED_TO_STAGE,this.onAddStage);
		}
		
		public function setCloseBtnVisible(param1:Boolean) : void
		{
			this._btnClose.visible = param1;
		}
		
		private function drawBackGround(param1:Number, param2:Number = 30) : void
		{
			this.graphics.clear();
			this._matrix.createGradientBox(param1,param2);
			var _loc3:Array = [0,0];
			var _loc4:Array = [0.8,0];
			this.graphics.beginGradientFill(GradientType.LINEAR,_loc3,_loc4,null,this._matrix);
			this.graphics.drawRect(0,0,param1 + 100,param2);
			this.graphics.endFill();
			this._btnClose.x = param1 - this._btnClose.width - 100;
			this.x = -param1;
			TweenLite.killTweensOf(this);
			TweenLite.to(this,0.5,{
				"x":0,
				"onComplete":this.onMoveComplete
			});
		}
		
		private function onMoveComplete() : void
		{
			TweenLite.killTweensOf(this);
		}
		
		public function resize(param1:Number, param2:Number = 30) : void
		{
		}
		
		public function destory() : void
		{
			if(stage)
			{
				stage.removeEventListener(KeyboardEvent.KEY_DOWN,this.onKeyDown);
			}
			this._btnClose.removeEventListener(MouseEvent.CLICK,this.onMouseClick);
			this.removeAllTip();
		}
		
		function showTip(param1:String) : int
		{
			var _loc5:String = null;
			var _loc2:Object = TipManager.getItem(param1);
			var _loc3:Object = TipManager.getItem(this.currentTipId);
			var _loc4:int = this.getMaxLevel();
			if((_loc2) && int(_loc2.type) == 1)
			{
				if((_loc2) && (_loc2.level) && int(_loc2.level) >= _loc4)
				{
					this.removeAllTip();
					if((_loc2) && (_loc2.message))
					{
						TipManager.addLog("TipManager:  show tip " + param1);
						TipManager.clearConflict(param1);
						this.createTip(param1,_loc2.message);
					}
					this.visible = true;
					clearTimeout(this.hideTimeoutId);
					if((_loc2.duration) && int(_loc2.duration) == -1)
					{
						return TipManager.TIP_SHOW_STATUS_OK;
					}
					this.hideTimeoutId = setTimeout(this.hideTip,_loc2.duration?int(_loc2.duration) * 1000:8000);
					return TipManager.TIP_SHOW_STATUS_OK;
				}
			}
			else if((_loc2) && int(_loc2.type) == 2)
			{
				if((_loc2) && (_loc2.level) && int(_loc2.level) > _loc4)
				{
					if((_loc3 && _loc3.type && _loc2.type) && (int(_loc3.type) < int(_loc2.type)) && (_loc2.force == undefined || !(_loc2.force == "true")))
					{
						TipManager.addLog("TipManager: " + param1 + " conflict because of type");
						TipManager.addConflict(param1);
						TipManager.checkNextConflict();
						return TipManager.TIP_SHOW_STATUS_CONFLICTED;
					}
					this.removeAllTip();
					if((_loc2) && (_loc2.message))
					{
						_loc5 = "false";
						if(_loc3)
						{
							_loc5 = "true";
						}
						TipManager.addLog("TipManager:  show tip " + param1 + "maxlevel " + _loc4 + " curr " + _loc5);
						TipManager.clearConflict(param1);
						this.createTip(param1,_loc2.message);
					}
					this.visible = true;
					clearTimeout(this.hideTimeoutId);
					if((_loc2.duration) && int(_loc2.duration) == -1)
					{
						return TipManager.TIP_SHOW_STATUS_OK;
					}
					this.hideTimeoutId = setTimeout(this.hideTip,_loc2.duration?int(_loc2.duration) * 1000:8000);
					return TipManager.TIP_SHOW_STATUS_OK;
				}
				TipManager.addLog("TipManager: " + param1 + " conflict because of level");
				TipManager.addConflict(param1);
				TipManager.checkNextConflict();
				return TipManager.TIP_SHOW_STATUS_CONFLICTED;
			}
			
			return TipManager.TIP_SHOW_STATUS_CONFLICTED;
		}
		
		function hideTip() : void
		{
			var _loc1:TipEvent = new TipEvent(TipEvent.Hide);
			_loc1.tipId = this.currTipId;
			this.visible = false;
			this.removeAllTip();
			this.currTipId = "";
			TipManager.instance.dispatchEvent(_loc1);
		}
		
		function get currentTipId() : String
		{
			return this.currTipId;
		}
		
		function showInstantTip(param1:String, param2:String) : void
		{
			this.removeAllTip();
			this.createTip(param1,param2);
		}
		
		private function onAddStage(param1:Event) : void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE,this.onAddStage);
			stage.addEventListener(KeyboardEvent.KEY_DOWN,this.onKeyDown);
		}
		
		private function onMouseClick(param1:MouseEvent) : void
		{
			this.hideTip();
			var _loc2:TipEvent = new TipEvent(TipEvent.Close);
			_loc2.tipId = this.currTipId;
			TipManager.instance.dispatchEvent(_loc2);
		}
		
		private function onKeyDown(param1:KeyboardEvent) : void
		{
			if((param1.ctrlKey) && (param1.altKey) && param1.charCode == 116)
			{
				TipManager.TipDebugInfo();
			}
		}
		
		private function onLinkHandler(param1:TextEvent) : void
		{
			var _loc4:TipEvent = null;
			var _loc5:Object = null;
			var _loc2:String = param1.text;
			var _loc3:Object = this.getEvent(_loc2);
			if(_loc2.substr(0,7) == "ASEvent")
			{
				_loc4 = new TipEvent(TipEvent.ASEvent,_loc3);
				_loc4.tipId = this.currTipId;
			}
			else if(_loc2.substr(0,7) == "JSEvent")
			{
				_loc4 = new TipEvent(TipEvent.JSEvent,_loc3);
				_loc4.tipId = this.currTipId;
			}
			else if(_loc2 != "")
			{
				_loc5 = new Object();
				_loc5.url = _loc2;
				_loc4 = new TipEvent(TipEvent.LinkEvent,_loc5);
				_loc4.tipId = this.currTipId;
			}
			
			
			if(_loc4)
			{
				TipManager.instance.dispatchEvent(_loc4);
			}
		}
		
		private function createTip(param1:String, param2:String) : void
		{
			var _loc7:String = null;
			if(getChildByName(param1))
			{
				return;
			}
			var _loc3:TextField = new TextField();
			if(this.textCacheAsBitmap)
			{
				_loc3.cacheAsBitmap = true;
			}
			this.tipContainer.addChild(_loc3);
			_loc3.name = param1;
			_loc3.selectable = false;
			var _loc4:StyleSheet = new StyleSheet();
			_loc4.parseCSS(this.defaultCSS);
			_loc3.styleSheet = _loc4;
			var param2:* = "<p>" + param2 + "</p>";
			param2 = param2.replace(new RegExp("<span>","g"),"<span class=\"light\">");
			param2 = param2.replace(new RegExp("<a ","g"),"<a target=\"_blank\" ");
			var _loc5:Object = TipManager.getAttribute();
			if(_loc5)
			{
				for(_loc7 in _loc5)
				{
					param2 = param2.replace("#" + _loc7 + "#",_loc5[_loc7]);
				}
			}
			_loc3.htmlText = param2;
			_loc3.width = _loc3.textWidth + 10;
			_loc3.height = _loc3.textHeight + 6;
			_loc3.y = 2;
			_loc3.addEventListener(TextEvent.LINK,this.onLinkHandler);
			this.currTipId = param1;
			var _loc6:TipEvent = new TipEvent(TipEvent.Show,null);
			_loc6.tipId = this.currTipId;
			TipManager.instance.dispatchEvent(_loc6);
			TipManager.addLog("TipManager: show tip is  " + this.currTipId);
			TipManager.addShowCount(this.currTipId);
			TipManager.addProSubUpdateTipCount(this.currTipId);
			this.drawBackGround(_loc3.width + 200);
		}
		
		private function removeAllTip() : void
		{
			var _loc1:DisplayObject = null;
			while(this.tipContainer.numChildren > 0)
			{
				_loc1 = this.tipContainer.getChildAt(0);
				_loc1.removeEventListener(TextEvent.LINK,this.onLinkHandler);
				this.tipContainer.removeChild(_loc1);
				_loc1 = null;
			}
		}
		
		private function getMaxLevel() : int
		{
			var _loc3:TextField = null;
			var _loc4:String = null;
			var _loc5:Object = null;
			var _loc1:* = 0;
			var _loc2:* = 0;
			while(_loc2 < this.tipContainer.numChildren)
			{
				_loc3 = this.tipContainer.getChildAt(_loc2) as TextField;
				_loc4 = _loc3.name;
				_loc5 = TipManager.getItem(_loc4);
				if((_loc5) && (_loc5.level))
				{
					if(_loc1 < int(_loc5.level))
					{
						_loc1 = int(_loc5.level);
					}
				}
				_loc2++;
			}
			return _loc1;
		}
		
		private function getEvent(param1:String) : Object
		{
			var _loc5:String = null;
			var _loc6:Array = null;
			var _loc7:String = null;
			var _loc8:* = 0;
			var _loc2:Object = new Object();
			var _loc3:RegExp = new RegExp("\\(.*?\\)");
			var _loc4:Array = param1.match(_loc3);
			if((_loc4) && _loc4.length > 0)
			{
				_loc5 = String(_loc4[0]);
				_loc5 = _loc5.replace(new RegExp("\\("),"");
				_loc5 = _loc5.replace(new RegExp("\\)"),"");
				_loc6 = _loc5.split(",");
				_loc7 = _loc6[0];
				_loc2.eventName = _loc7;
				_loc2.eventParams = "";
				_loc8 = 1;
				while(_loc8 < _loc6.length)
				{
					_loc2.eventParams = _loc2.eventParams + _loc6[_loc8];
					_loc8++;
				}
			}
			return _loc2;
		}
	}
}
