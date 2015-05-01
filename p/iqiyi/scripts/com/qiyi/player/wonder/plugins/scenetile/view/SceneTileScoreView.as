package com.qiyi.player.wonder.plugins.scenetile.view {
	import com.iqiyi.components.panelSystem.impls.BasePanel;
	import com.qiyi.player.wonder.common.status.Status;
	import com.qiyi.player.wonder.common.vo.UserInfoVO;
	import com.qiyi.player.wonder.plugins.scenetile.view.scorepart.ScorePanel;
	import com.qiyi.player.wonder.plugins.scenetile.view.scorepart.ScoreSuccessPanel;
	import gs.TweenLite;
	import com.qiyi.player.wonder.plugins.scenetile.SceneTileDef;
	import com.qiyi.player.wonder.body.BodyDef;
	import flash.display.DisplayObjectContainer;
	import com.iqiyi.components.global.GlobalStage;
	
	public class SceneTileScoreView extends BasePanel {
		
		public function SceneTileScoreView(param1:DisplayObjectContainer, param2:Status, param3:UserInfoVO) {
			super(NAME,param1);
			type = BodyDef.VIEW_TYPE_POPUP;
			this._status = param2;
			this._userInfoVO = param3;
		}
		
		public static const NAME:String = "com.qiyi.player.wonder.plugins.scenetile.view.SceneTileScoreView";
		
		private var _status:Status;
		
		private var _userInfoVO:UserInfoVO;
		
		private var _scorePanel:ScorePanel;
		
		private var _scoreSuccessPanel:ScoreSuccessPanel;
		
		public function onUserInfoChanged(param1:UserInfoVO) : void {
			this._userInfoVO = param1;
		}
		
		public function onAddStatus(param1:int) : void {
			this._status.addStatus(param1);
			switch(param1) {
				case SceneTileDef.STATUS_SCORE_OPEN:
					TweenLite.delayedCall(SceneTileDef.SCORE_SHOW_TIME,this.close);
					this.open();
					dispatchEvent(new SceneTileEvent(SceneTileEvent.Evt_ScoreOpen));
					break;
				case SceneTileDef.STATUS_SCORE_SUCCESS_OPEN:
					TweenLite.delayedCall(SceneTileDef.SCORE_SHOW_TIME,this.close);
					this.open();
					dispatchEvent(new SceneTileEvent(SceneTileEvent.Evt_ScoreSuccessOpen));
					break;
			}
		}
		
		public function onRemoveStatus(param1:int) : void {
			this._status.removeStatus(param1);
			switch(param1) {
				case SceneTileDef.STATUS_SCORE_OPEN:
					this.destoryPanel();
					this.close();
					break;
				case SceneTileDef.STATUS_SCORE_SUCCESS_OPEN:
					this.destoryPanel();
					this.close();
					break;
			}
		}
		
		public function onResize(param1:int, param2:int) : void {
			if((this._scorePanel) && (this._scorePanel.parent)) {
				y = param2 - BodyDef.VIDEO_BOTTOM_RESERVE - this._scorePanel.height - 40;
			}
			if((this._scoreSuccessPanel) && (this._scoreSuccessPanel.parent)) {
				y = param2 - BodyDef.VIDEO_BOTTOM_RESERVE - this._scoreSuccessPanel.height - 40;
			}
		}
		
		override public function open(param1:DisplayObjectContainer = null) : void {
			if(!isOnStage) {
				super.open(param1);
			}
		}
		
		override public function close() : void {
			if(isOnStage) {
				super.close();
				TweenLite.killTweensOf(this.close);
				dispatchEvent(new SceneTileEvent(SceneTileEvent.Evt_ScoreClose));
			}
		}
		
		override protected function onAddToStage() : void {
			super.onAddToStage();
		}
		
		override protected function onRemoveFromStage() : void {
			super.onRemoveFromStage();
		}
		
		public function initScorePanel(param1:String, param2:Number) : void {
			this.destoryPanel();
			if(!this._scorePanel) {
				this._scorePanel = new ScorePanel(param1,param2);
				this._scorePanel.addEventListener(SceneTileEvent.Evt_ScoreClose,this.onScorePanelClose);
				this._scorePanel.addEventListener(SceneTileEvent.Evt_ScoreHeartClick,this.onScoreHeartClick);
				addChild(this._scorePanel);
				this.onResize(GlobalStage.stage.stageWidth,GlobalStage.stage.stageHeight);
			}
		}
		
		public function initScoreSuccessPanel(param1:Boolean) : void {
			this.destoryPanel();
			if(!this._scoreSuccessPanel) {
				this._scoreSuccessPanel = new ScoreSuccessPanel(param1);
				this._scoreSuccessPanel.addEventListener(SceneTileEvent.Evt_ScoreClose,this.onScorePanelClose);
				addChild(this._scoreSuccessPanel);
				this.onResize(GlobalStage.stage.stageWidth,GlobalStage.stage.stageHeight);
			}
		}
		
		private function destoryPanel() : void {
			if((this._scorePanel) && (this._scorePanel.parent)) {
				this._scorePanel.removeEventListener(SceneTileEvent.Evt_ScoreClose,this.onScorePanelClose);
				this._scorePanel.removeEventListener(SceneTileEvent.Evt_ScoreHeartClick,this.onScoreHeartClick);
				this._scorePanel.destory();
				this._scorePanel.parent.removeChild(this._scorePanel);
				this._scorePanel = null;
			}
			if((this._scoreSuccessPanel) && (this._scoreSuccessPanel.parent)) {
				this._scoreSuccessPanel.removeEventListener(SceneTileEvent.Evt_ScoreClose,this.onScorePanelClose);
				this._scoreSuccessPanel.destory();
				this._scoreSuccessPanel.parent.removeChild(this._scoreSuccessPanel);
				this._scoreSuccessPanel = null;
			}
		}
		
		private function onScoreHeartClick(param1:SceneTileEvent) : void {
			dispatchEvent(new SceneTileEvent(SceneTileEvent.Evt_ScoreHeartClick,param1.data));
		}
		
		private function onScorePanelClose(param1:SceneTileEvent) : void {
			this.close();
		}
	}
}
