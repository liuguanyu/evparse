package com.qiyi.player.wonder.plugins.tips.view {
	import com.iqiyi.components.panelSystem.impls.BasePanel;
	import com.qiyi.player.wonder.common.status.Status;
	import com.qiyi.player.wonder.common.vo.UserInfoVO;
	import com.qiyi.player.wonder.plugins.tips.view.parts.TipBar;
	import com.iqiyi.components.global.GlobalStage;
	import gs.TweenLite;
	import com.qiyi.player.wonder.plugins.tips.TipsDef;
	import flash.display.DisplayObjectContainer;
	import com.qiyi.player.wonder.common.config.FlashVarConfig;
	
	public class TipsView extends BasePanel {
		
		public function TipsView(param1:DisplayObjectContainer, param2:Status, param3:UserInfoVO) {
			super(NAME,param1);
			this._status = param2;
			this._userInfoVO = param3;
			this._tipBar = new TipBar(FlashVarConfig.owner == FlashVarConfig.OWNER_CLIENT);
			this._tipBar.visible = false;
			addChild(this._tipBar);
			this.onResize(GlobalStage.stage.stageWidth,GlobalStage.stage.stageHeight);
		}
		
		public static const NAME:String = "com.qiyi.player.wonder.plugins.tips.view.TipsView";
		
		private var _status:Status;
		
		private var _userInfoVO:UserInfoVO;
		
		private var _tipBar:TipBar;
		
		private var _gap:int;
		
		public function get tipBar() : TipBar {
			return this._tipBar;
		}
		
		public function setCloseBtnVisible(param1:Boolean) : void {
			this._tipBar.setCloseBtnVisible(param1);
		}
		
		public function setGap(param1:int) : void {
			this._gap = param1;
			var _loc2_:int = GlobalStage.stage.stageHeight - this._tipBar.height - this._gap;
			TweenLite.to(this,0.5,{
				"y":_loc2_,
				"onComplete":this.onTweenComplete
			});
		}
		
		public function onUserInfoChanged(param1:UserInfoVO) : void {
			this._userInfoVO = param1;
		}
		
		public function onAddStatus(param1:int) : void {
			this._status.addStatus(param1);
			switch(param1) {
				case TipsDef.STATUS_OPEN:
					this.open();
					break;
			}
		}
		
		public function onRemoveStatus(param1:int) : void {
			this._status.removeStatus(param1);
			switch(param1) {
				case TipsDef.STATUS_OPEN:
					this.close();
					break;
			}
		}
		
		public function onResize(param1:int, param2:int) : void {
			this._tipBar.resize(param1);
			y = GlobalStage.stage.stageHeight - this._tipBar.height - this._gap;
		}
		
		override public function open(param1:DisplayObjectContainer = null) : void {
			if(!isOnStage) {
				super.open(param1);
				dispatchEvent(new TipsEvent(TipsEvent.Evt_Open));
			}
		}
		
		override public function close() : void {
			if(isOnStage) {
				super.close();
				dispatchEvent(new TipsEvent(TipsEvent.Evt_Close));
			}
		}
		
		override protected function onAddToStage() : void {
			super.onAddToStage();
		}
		
		override protected function onRemoveFromStage() : void {
			super.onRemoveFromStage();
		}
		
		private function onTweenComplete() : void {
			y = GlobalStage.stage.stageHeight - this._tipBar.height - this._gap;
		}
	}
}
