package com.qiyi.player.wonder.plugins.tips.view.parts {
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
	
	public class TipBar extends Sprite {
		
		public function TipBar(param1:Boolean = false) {
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
		
		private var textCacheAsBitmap:Boolean = false;
		
		protected var tipContainer:Sprite;
		
		protected var _btnClose:CommonCloseBtn;
		
		protected var defaultCSS:String = "p{color:#ffffff;font-size:14;font-family:微软雅黑} .light{color:#83A80B;} a{color:#83A80B;}a:hover{color:#ffffff;text-decoration:underline} a:active{color:#ffffff;text-decoration:underline}";
		
		private var currTipId:String;
		
		private var _matrix:Matrix;
		
		public function setCloseBtnVisible(param1:Boolean) : void {
			this._btnClose.visible = param1;
		}
		
		private function drawBackGround(param1:Number, param2:Number = 30) : void {
			this.graphics.clear();
			this._matrix.createGradientBox(param1,param2);
			var _loc3_:Array = [0,0];
			var _loc4_:Array = [0.8,0];
			this.graphics.beginGradientFill(GradientType.LINEAR,_loc3_,_loc4_,null,this._matrix);
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
		
		private function onMoveComplete() : void {
			TweenLite.killTweensOf(this);
		}
		
		public function resize(param1:Number, param2:Number = 30) : void {
		}
		
		public function destory() : void {
			if(stage) {
				stage.removeEventListener(KeyboardEvent.KEY_DOWN,this.onKeyDown);
			}
			this._btnClose.removeEventListener(MouseEvent.CLICK,this.onMouseClick);
			this.removeAllTip();
		}
		
		private var hideTimeoutId:int;
		
		function showTip(param1:String) : int {
			var _loc5_:String = null;
			var _loc2_:Object = TipManager.getItem(param1);
			var _loc3_:Object = TipManager.getItem(this.currentTipId);
			var _loc4_:int = this.getMaxLevel();
			if((_loc2_) && int(_loc2_.type) == 1) {
				if((_loc2_) && (_loc2_.level) && int(_loc2_.level) >= _loc4_) {
					this.removeAllTip();
					if((_loc2_) && (_loc2_.message)) {
						TipManager.addLog("TipManager:  show tip " + param1);
						TipManager.clearConflict(param1);
						this.createTip(param1,_loc2_.message);
					}
					this.visible = true;
					clearTimeout(this.hideTimeoutId);
					if((_loc2_.duration) && int(_loc2_.duration) == -1) {
						return TipManager.TIP_SHOW_STATUS_OK;
					}
					this.hideTimeoutId = setTimeout(this.hideTip,_loc2_.duration?int(_loc2_.duration) * 1000:8000);
					return TipManager.TIP_SHOW_STATUS_OK;
				}
			} else if((_loc2_) && int(_loc2_.type) == 2) {
				if((_loc2_) && (_loc2_.level) && int(_loc2_.level) > _loc4_) {
					if((_loc3_ && _loc3_.type && _loc2_.type) && (int(_loc3_.type) < int(_loc2_.type)) && (_loc2_.force == undefined || !(_loc2_.force == "true"))) {
						TipManager.addLog("TipManager: " + param1 + " conflict because of type");
						TipManager.addConflict(param1);
						TipManager.checkNextConflict();
						return TipManager.TIP_SHOW_STATUS_CONFLICTED;
					}
					this.removeAllTip();
					if((_loc2_) && (_loc2_.message)) {
						_loc5_ = "false";
						if(_loc3_) {
							_loc5_ = "true";
						}
						TipManager.addLog("TipManager:  show tip " + param1 + "maxlevel " + _loc4_ + " curr " + _loc5_);
						TipManager.clearConflict(param1);
						this.createTip(param1,_loc2_.message);
					}
					this.visible = true;
					clearTimeout(this.hideTimeoutId);
					if((_loc2_.duration) && int(_loc2_.duration) == -1) {
						return TipManager.TIP_SHOW_STATUS_OK;
					}
					this.hideTimeoutId = setTimeout(this.hideTip,_loc2_.duration?int(_loc2_.duration) * 1000:8000);
					return TipManager.TIP_SHOW_STATUS_OK;
				}
				TipManager.addLog("TipManager: " + param1 + " conflict because of level");
				TipManager.addConflict(param1);
				TipManager.checkNextConflict();
				return TipManager.TIP_SHOW_STATUS_CONFLICTED;
			}
			
			return TipManager.TIP_SHOW_STATUS_CONFLICTED;
		}
		
		function hideTip() : void {
			var _loc1_:TipEvent = new TipEvent(TipEvent.Hide);
			_loc1_.tipId = this.currTipId;
			this.visible = false;
			this.removeAllTip();
			this.currTipId = "";
			TipManager.instance.dispatchEvent(_loc1_);
		}
		
		function get currentTipId() : String {
			return this.currTipId;
		}
		
		function showInstantTip(param1:String, param2:String) : void {
			this.removeAllTip();
			this.createTip(param1,param2);
		}
		
		private function onAddStage(param1:Event) : void {
			this.removeEventListener(Event.ADDED_TO_STAGE,this.onAddStage);
			stage.addEventListener(KeyboardEvent.KEY_DOWN,this.onKeyDown);
		}
		
		private function onMouseClick(param1:MouseEvent) : void {
			this.hideTip();
			var _loc2_:TipEvent = new TipEvent(TipEvent.Close);
			_loc2_.tipId = this.currTipId;
			TipManager.instance.dispatchEvent(_loc2_);
		}
		
		private function onKeyDown(param1:KeyboardEvent) : void {
			if((param1.ctrlKey) && (param1.altKey) && param1.charCode == 116) {
				TipManager.TipDebugInfo();
			}
		}
		
		private function onLinkHandler(param1:TextEvent) : void {
			var _loc4_:TipEvent = null;
			var _loc5_:Object = null;
			var _loc2_:String = param1.text;
			var _loc3_:Object = this.getEvent(_loc2_);
			if(_loc2_.substr(0,7) == "ASEvent") {
				_loc4_ = new TipEvent(TipEvent.ASEvent,_loc3_);
				_loc4_.tipId = this.currTipId;
			} else if(_loc2_.substr(0,7) == "JSEvent") {
				_loc4_ = new TipEvent(TipEvent.JSEvent,_loc3_);
				_loc4_.tipId = this.currTipId;
			} else if(_loc2_ != "") {
				_loc5_ = new Object();
				_loc5_.url = _loc2_;
				_loc4_ = new TipEvent(TipEvent.LinkEvent,_loc5_);
				_loc4_.tipId = this.currTipId;
			}
			
			
			if(_loc4_) {
				TipManager.instance.dispatchEvent(_loc4_);
			}
		}
		
		private function createTip(param1:String, param2:String) : void {
			var _loc7_:String = null;
			if(getChildByName(param1)) {
				return;
			}
			var _loc3_:TextField = new TextField();
			if(this.textCacheAsBitmap) {
				_loc3_.cacheAsBitmap = true;
			}
			this.tipContainer.addChild(_loc3_);
			_loc3_.name = param1;
			_loc3_.selectable = false;
			var _loc4_:StyleSheet = new StyleSheet();
			_loc4_.parseCSS(this.defaultCSS);
			_loc3_.styleSheet = _loc4_;
			var param2:* = "<p>" + param2 + "</p>";
			param2 = param2.replace(new RegExp("<span>","g"),"<span class=\"light\">");
			param2 = param2.replace(new RegExp("<a ","g"),"<a target=\"_blank\" ");
			var _loc5_:Object = TipManager.getAttribute();
			if(_loc5_) {
				for(_loc7_ in _loc5_) {
					param2 = param2.replace("#" + _loc7_ + "#",_loc5_[_loc7_]);
				}
			}
			_loc3_.htmlText = param2;
			_loc3_.width = _loc3_.textWidth + 10;
			_loc3_.height = _loc3_.textHeight + 6;
			_loc3_.y = 2;
			_loc3_.addEventListener(TextEvent.LINK,this.onLinkHandler);
			this.currTipId = param1;
			var _loc6_:TipEvent = new TipEvent(TipEvent.Show,null);
			_loc6_.tipId = this.currTipId;
			TipManager.instance.dispatchEvent(_loc6_);
			TipManager.addLog("TipManager: show tip is  " + this.currTipId);
			TipManager.addShowCount(this.currTipId);
			TipManager.addProSubUpdateTipCount(this.currTipId);
			this.drawBackGround(_loc3_.width + 200);
		}
		
		private function removeAllTip() : void {
			var _loc1_:DisplayObject = null;
			while(this.tipContainer.numChildren > 0) {
				_loc1_ = this.tipContainer.getChildAt(0);
				_loc1_.removeEventListener(TextEvent.LINK,this.onLinkHandler);
				this.tipContainer.removeChild(_loc1_);
				_loc1_ = null;
			}
		}
		
		private function getMaxLevel() : int {
			var _loc3_:TextField = null;
			var _loc4_:String = null;
			var _loc5_:Object = null;
			var _loc1_:* = 0;
			var _loc2_:* = 0;
			while(_loc2_ < this.tipContainer.numChildren) {
				_loc3_ = this.tipContainer.getChildAt(_loc2_) as TextField;
				_loc4_ = _loc3_.name;
				_loc5_ = TipManager.getItem(_loc4_);
				if((_loc5_) && (_loc5_.level)) {
					if(_loc1_ < int(_loc5_.level)) {
						_loc1_ = int(_loc5_.level);
					}
				}
				_loc2_++;
			}
			return _loc1_;
		}
		
		private function getEvent(param1:String) : Object {
			var _loc5_:String = null;
			var _loc6_:Array = null;
			var _loc7_:String = null;
			var _loc8_:* = 0;
			var _loc2_:Object = new Object();
			var _loc3_:RegExp = new RegExp("\\(.*?\\)");
			var _loc4_:Array = param1.match(_loc3_);
			if((_loc4_) && _loc4_.length > 0) {
				_loc5_ = String(_loc4_[0]);
				_loc5_ = _loc5_.replace(new RegExp("\\("),"");
				_loc5_ = _loc5_.replace(new RegExp("\\)"),"");
				_loc6_ = _loc5_.split(",");
				_loc7_ = _loc6_[0];
				_loc2_.eventName = _loc7_;
				_loc2_.eventParams = "";
				_loc8_ = 1;
				while(_loc8_ < _loc6_.length) {
					_loc2_.eventParams = _loc2_.eventParams + _loc6_[_loc8_];
					_loc8_++;
				}
			}
			return _loc2_;
		}
	}
}
