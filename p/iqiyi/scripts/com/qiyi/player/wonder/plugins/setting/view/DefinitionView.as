package com.qiyi.player.wonder.plugins.setting.view {
	import com.iqiyi.components.panelSystem.impls.BasePanel;
	import com.qiyi.player.wonder.common.status.Status;
	import com.qiyi.player.wonder.common.vo.UserInfoVO;
	import common.CommonBg;
	import com.qiyi.player.wonder.plugins.setting.view.parts.DefinitionItem;
	import com.qiyi.player.base.pub.EnumItem;
	import flash.display.Sprite;
	import com.qiyi.player.wonder.plugins.setting.SettingDef;
	import com.qiyi.player.core.model.def.DefinitionEnum;
	import flash.display.DisplayObjectContainer;
	import com.qiyi.player.wonder.body.BodyDef;
	import flash.events.MouseEvent;
	import gs.TweenLite;
	
	public class DefinitionView extends BasePanel {
		
		public function DefinitionView(param1:DisplayObjectContainer, param2:Status, param3:UserInfoVO) {
			super(NAME,param1);
			this._status = param2;
			this._userInfoVO = param3;
			type = BodyDef.VIEW_TYPE_POPUP;
			this._bg = new CommonBg();
			this._bg.width = SettingDef.DEFINITION_PANEL_WIDTH;
			addChild(this._bg);
			this._maskSprite = new Sprite();
			addChild(this._maskSprite);
		}
		
		public static const NAME:String = "com.qiyi.player.wonder.plugins.setting.view.DefinitionView";
		
		private var _status:Status;
		
		private var _userInfoVO:UserInfoVO;
		
		private var _bg:CommonBg;
		
		private var _definitionDataVector:Array;
		
		private var _itemVector:Vector.<DefinitionItem>;
		
		private var _currentSelectedItem:EnumItem;
		
		private var _currendVid:int;
		
		private var _maskSprite:Sprite;
		
		public function initUI(param1:Number, param2:Number, param3:Array, param4:Array, param5:EnumItem, param6:int) : void {
			var _loc7_:DefinitionItem = null;
			this._currentSelectedItem = param5;
			this._currendVid = param6;
			this._bg.height = SettingDef.DEFINITION_PANEL_ITEM_HEIGHT * (param3.length + param4.length) + 5;
			this._bg.x = param1;
			this._bg.y = param2 - this._bg.height + 13;
			this._itemVector = new Vector.<DefinitionItem>();
			var _loc8_:uint = 0;
			while(_loc8_ < param4.length) {
				_loc7_ = new DefinitionItem(param4[_loc8_],true);
				_loc7_.x = param1;
				_loc7_.y = param2 - this._bg.height + 13 + _loc8_ * SettingDef.DEFINITION_PANEL_ITEM_HEIGHT;
				if(this._currentSelectedItem == DefinitionEnum.NONE && param4[_loc8_].id == 0) {
					_loc7_.isSelected = true;
				} else if(this._currentSelectedItem == null && param4[_loc8_].id == this._currendVid) {
					_loc7_.isSelected = true;
				}
				
				if(this._currendVid == param4[_loc8_].id) {
					_loc7_.isVid = true;
				}
				addChild(_loc7_);
				this._itemVector.push(_loc7_);
				_loc8_++;
			}
			var _loc9_:uint = 0;
			while(_loc9_ < param3.length) {
				_loc7_ = new DefinitionItem(param3[_loc9_],false);
				_loc7_.x = param1;
				_loc7_.y = param2 - this._bg.height + 13 + (param4.length + _loc9_) * SettingDef.DEFINITION_PANEL_ITEM_HEIGHT;
				if(this._currentSelectedItem == DefinitionEnum.NONE && param3[_loc9_].id == 0) {
					_loc7_.isSelected = true;
				} else if(this._currentSelectedItem == null && param3[_loc9_].id == this._currendVid) {
					_loc7_.isSelected = true;
				}
				
				if(this._currendVid == param3[_loc9_].id) {
					_loc7_.isVid = true;
				}
				addChild(_loc7_);
				this._itemVector.push(_loc7_);
				_loc9_++;
			}
		}
		
		public function setSelectedItem(param1:EnumItem) : void {
			var _loc2_:DefinitionItem = null;
			for each(_loc2_ in this._itemVector) {
				_loc2_.isSelected = false;
				if(param1.id == _loc2_.data.id) {
					_loc2_.isSelected = true;
				}
			}
		}
		
		public function setChangeVidComplete(param1:EnumItem) : void {
			var _loc2_:DefinitionItem = null;
			if(this._itemVector == null) {
				return;
			}
			for each(_loc2_ in this._itemVector) {
				_loc2_.isVid = false;
				if(param1.id == _loc2_.data.id) {
					_loc2_.isVid = true;
				}
			}
		}
		
		private function destroyItem() : void {
			var _loc1_:DefinitionItem = null;
			if(this._itemVector == null) {
				return;
			}
			for each(_loc1_ in this._itemVector) {
				_loc1_.destroy();
				removeChild(_loc1_);
				_loc1_ = null;
			}
			this._itemVector.length = 0;
			this._itemVector = null;
		}
		
		public function onAddStatus(param1:int) : void {
			this._status.addStatus(param1);
			switch(param1) {
				case SettingDef.STATUS_DEFINITION_OPEN:
					this.open();
					break;
			}
		}
		
		public function onRemoveStatus(param1:int) : void {
			this._status.removeStatus(param1);
			switch(param1) {
				case SettingDef.STATUS_DEFINITION_OPEN:
					this.close();
					break;
			}
		}
		
		public function onUserInfoChanged(param1:UserInfoVO) : void {
			this._userInfoVO = param1;
		}
		
		override public function open(param1:DisplayObjectContainer = null) : void {
			if(!isOnStage) {
				super.open(param1);
				dispatchEvent(new SettingEvent(SettingEvent.Evt_DefinitionOpen));
			}
		}
		
		override public function close() : void {
			if(isOnStage) {
				super.close();
				dispatchEvent(new SettingEvent(SettingEvent.Evt_DefinitionClose));
			}
		}
		
		override protected function onAddToStage() : void {
			super.onAddToStage();
			this._maskSprite.graphics.clear();
			this._maskSprite.graphics.beginFill(16711680,0);
			this._maskSprite.graphics.drawRect(this._bg.x,this._bg.y,SettingDef.DEFINITION_PANEL_WIDTH,this._bg.height + BodyDef.VIDEO_BOTTOM_RESERVE);
			this._maskSprite.graphics.endFill();
			addEventListener(MouseEvent.ROLL_OUT,this.onMaskRollOut);
			addEventListener(MouseEvent.CLICK,this.onViewClick);
			alpha = 0;
			TweenLite.to(this,BodyDef.POPUP_TWEEN_TIME / 1000,{"alpha":1});
		}
		
		override protected function onRemoveFromStage() : void {
			super.onRemoveFromStage();
			this._maskSprite.graphics.clear();
			removeEventListener(MouseEvent.ROLL_OUT,this.onMaskRollOut);
			removeEventListener(MouseEvent.CLICK,this.onViewClick);
			this.destroyItem();
			TweenLite.killTweensOf(this);
		}
		
		private function onMaskRollOut(param1:MouseEvent) : void {
			this.close();
		}
		
		private function onViewClick(param1:MouseEvent) : void {
			if(param1.target is DefinitionItem) {
				this.setSelectedItem(param1.target.data);
				dispatchEvent(new SettingEvent(SettingEvent.Evt_DefinitionChangeClick,param1.target.data));
			}
			this.close();
		}
	}
}