package com.qiyi.player.wonder.plugins.dock.view {
	import com.iqiyi.components.panelSystem.impls.BasePanel;
	import com.qiyi.player.wonder.common.status.Status;
	import com.qiyi.player.wonder.common.vo.UserInfoVO;
	import common.CommonBg;
	import dock.DockUI;
	import flash.display.SimpleButton;
	import com.iqiyi.components.global.GlobalStage;
	import gs.TweenLite;
	import com.qiyi.player.wonder.plugins.dock.DockDef;
	import flash.display.DisplayObjectContainer;
	import flash.display.DisplayObject;
	
	public class DockView extends BasePanel {
		
		public function DockView(param1:DisplayObjectContainer, param2:Status, param3:UserInfoVO) {
			super(NAME,param1);
			this._status = param2;
			this._userInfoVO = param3;
			this.initUI();
			this.updateLayout();
		}
		
		public static const NAME:String = "com.qiyi.player.wonder.plugins.dock.view.DockView";
		
		private var _status:Status;
		
		private var _userInfoVO:UserInfoVO;
		
		private var _bg:CommonBg;
		
		private var _dockUI:DockUI;
		
		public function get shareBtn() : SimpleButton {
			return this._dockUI.shareBtn;
		}
		
		public function get openLightBtn() : SimpleButton {
			return this._dockUI.openLightBtn;
		}
		
		public function get closeLightBtn() : SimpleButton {
			return this._dockUI.closeLightBtn;
		}
		
		public function get offlineWatchBtn() : SimpleButton {
			return this._dockUI.offlineWatchBtn;
		}
		
		public function onUserInfoChanged(param1:UserInfoVO) : void {
			this._userInfoVO = param1;
		}
		
		public function onAddStatus(param1:int) : void {
			var _loc2_:* = 0;
			this._status.addStatus(param1);
			switch(param1) {
				case DockDef.STATUS_OPEN:
					this.open();
					break;
				case DockDef.STATUS_SHOW:
					_loc2_ = GlobalStage.stage.stageWidth - this._bg.width;
					TweenLite.to(this,0.5,{
						"x":_loc2_,
						"onComplete":this.onTweenComplete
					});
					break;
				case DockDef.STATUS_OFFLINE_WATCH_ENABLE:
					this.updateLayout();
					break;
				case DockDef.STATUS_OFFLINE_WATCH_SHOW:
					this.updateLayout();
					break;
				case DockDef.STATUS_LIGHT_SHOW:
					this.updateLayout();
					break;
				case DockDef.STATUS_LIGHT_ON:
					this.updateLayout();
					break;
				case DockDef.STATUS_SHARE_SHOW:
					this.updateLayout();
					break;
			}
		}
		
		public function onRemoveStatus(param1:int) : void {
			var _loc2_:* = 0;
			this._status.removeStatus(param1);
			switch(param1) {
				case DockDef.STATUS_OPEN:
					this.close();
					break;
				case DockDef.STATUS_SHOW:
					_loc2_ = GlobalStage.stage.stageWidth;
					TweenLite.to(this,0.5,{
						"x":_loc2_,
						"onComplete":this.onTweenComplete
					});
					break;
				case DockDef.STATUS_OFFLINE_WATCH_ENABLE:
					this.updateLayout();
					break;
				case DockDef.STATUS_OFFLINE_WATCH_SHOW:
					this.updateLayout();
					break;
				case DockDef.STATUS_LIGHT_SHOW:
					this.updateLayout();
					break;
				case DockDef.STATUS_LIGHT_ON:
					this.updateLayout();
					break;
				case DockDef.STATUS_SHARE_SHOW:
					this.updateLayout();
					break;
			}
		}
		
		public function onResize(param1:int, param2:int) : void {
			if(this._status.hasStatus(DockDef.STATUS_SHOW)) {
				x = param1 - this._bg.width;
			} else {
				x = param1;
			}
			y = param2 / 2 - this._bg.height / 2;
		}
		
		override public function open(param1:DisplayObjectContainer = null) : void {
			if(!isOnStage) {
				super.open(param1);
				dispatchEvent(new DockEvent(DockEvent.Evt_Open));
			}
		}
		
		override public function close() : void {
			if(isOnStage) {
				super.close();
				dispatchEvent(new DockEvent(DockEvent.Evt_Close));
			}
		}
		
		override protected function onAddToStage() : void {
			super.onAddToStage();
		}
		
		override protected function onRemoveFromStage() : void {
			super.onRemoveFromStage();
		}
		
		private function initUI() : void {
			this._bg = new CommonBg();
			this._bg.width = 65;
			addChild(this._bg);
			this._dockUI = new DockUI();
			addChild(this._dockUI);
		}
		
		private function updateLayout() : void {
			var _loc1_:* = 0;
			_loc1_ = 56;
			var _loc2_:* = 2;
			var _loc3_:* = 0;
			var _loc4_:* = 5;
			var _loc5_:* = 0;
			var _loc6_:* = 1;
			if(this._status.hasStatus(DockDef.STATUS_SHARE_SHOW)) {
				this._dockUI.shareBtn.visible = true;
				this._dockUI.shareBtn.y = _loc5_;
				_loc5_ = _loc5_ + (_loc1_ + _loc2_ * 2 + _loc6_);
				_loc3_++;
			} else {
				this._dockUI.shareBtn.visible = false;
			}
			if(this._status.hasStatus(DockDef.STATUS_LIGHT_SHOW)) {
				if(this._status.hasStatus(DockDef.STATUS_LIGHT_ON)) {
					this._dockUI.openLightBtn.visible = false;
					this._dockUI.closeLightBtn.visible = true;
				} else {
					this._dockUI.openLightBtn.visible = true;
					this._dockUI.closeLightBtn.visible = false;
				}
				this._dockUI.openLightBtn.y = _loc5_;
				this._dockUI.closeLightBtn.y = _loc5_;
				_loc5_ = _loc5_ + (_loc1_ + _loc2_ * 2 + _loc6_);
				_loc3_++;
			} else {
				this._dockUI.openLightBtn.visible = false;
				this._dockUI.closeLightBtn.visible = false;
			}
			if(this._status.hasStatus(DockDef.STATUS_OFFLINE_WATCH_SHOW)) {
				if(this._status.hasStatus(DockDef.STATUS_OFFLINE_WATCH_ENABLE)) {
					this._dockUI.offlineWatchBtn.visible = true;
					this._dockUI.copyrightLimitBtn.visible = false;
				} else {
					this._dockUI.offlineWatchBtn.visible = false;
					this._dockUI.copyrightLimitBtn.visible = true;
				}
				this._dockUI.offlineWatchBtn.y = _loc5_;
				this._dockUI.copyrightLimitBtn.y = _loc5_;
				_loc5_ = _loc5_ + (_loc1_ + _loc2_ * 2 + _loc6_);
				_loc3_++;
			} else {
				this._dockUI.offlineWatchBtn.visible = false;
				this._dockUI.copyrightLimitBtn.visible = false;
			}
			var _loc7_:DisplayObject = null;
			_loc5_ = _loc1_ + _loc2_;
			var _loc8_:* = 0;
			while(_loc8_ < _loc4_ - 1) {
				_loc7_ = this._dockUI.getChildByName("line" + _loc8_);
				if(_loc8_ >= _loc3_ - 1) {
					_loc7_.visible = false;
				} else {
					_loc7_.visible = true;
					_loc7_.y = _loc5_;
					_loc5_ = _loc5_ + (_loc1_ + _loc2_ * 2 + _loc6_);
				}
				_loc8_++;
			}
			if(_loc3_ <= 0) {
				this._bg.height = 0;
			} else {
				this._bg.height = _loc3_ * (_loc1_ + _loc2_ * 2 + _loc6_) - _loc2_ * 2 - _loc6_;
			}
			this.onResize(GlobalStage.stage.stageWidth,GlobalStage.stage.stageHeight);
		}
		
		private function onTweenComplete() : void {
			this.onResize(GlobalStage.stage.stageWidth,GlobalStage.stage.stageHeight);
		}
	}
}
