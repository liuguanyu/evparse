package com.qiyi.player.wonder.plugins.recommend.view {
	import com.iqiyi.components.panelSystem.impls.BasePanel;
	import com.qiyi.player.wonder.common.status.Status;
	import com.qiyi.player.wonder.common.vo.UserInfoVO;
	import com.qiyi.player.wonder.plugins.recommend.view.part.PlayFinishRecommend;
	import flash.display.Sprite;
	import common.CommonNormalScreenBtn;
	import flash.events.MouseEvent;
	import com.iqiyi.components.tooltip.ToolTip;
	import com.qiyi.player.wonder.plugins.recommend.model.RecommendVO;
	import com.iqiyi.components.global.GlobalStage;
	import com.qiyi.player.wonder.plugins.recommend.RecommendDef;
	import com.qiyi.player.wonder.body.BodyDef;
	import com.qiyi.player.wonder.common.sw.SwitchManager;
	import com.qiyi.player.wonder.common.sw.SwitchDef;
	import flash.display.DisplayObjectContainer;
	
	public class RecommendView extends BasePanel {
		
		public function RecommendView(param1:DisplayObjectContainer, param2:Status, param3:UserInfoVO) {
			super(NAME,param1);
			type = BodyDef.VIEW_TYPE_END_POPUP;
			this._status = param2;
			this._userInfoVO = param3;
			this.initPanel();
		}
		
		public static const NAME:String = "com.qiyi.player.wonder.plugins.recommend.view.RecommendView";
		
		private var _status:Status;
		
		private var _userInfoVO:UserInfoVO;
		
		private var _boardRecommend:PlayFinishRecommend;
		
		private var _boardRecommendBg:Sprite;
		
		private var _normalScreenBtn:CommonNormalScreenBtn;
		
		private function initPanel() : void {
			this._boardRecommendBg = new Sprite();
			this._boardRecommendBg.graphics.beginFill(0);
			this._boardRecommendBg.graphics.drawRect(0,0,1,1);
			this._boardRecommendBg.graphics.endFill();
			addChild(this._boardRecommendBg);
			this._normalScreenBtn = new CommonNormalScreenBtn();
			this._normalScreenBtn.addEventListener(MouseEvent.CLICK,this.onNormalScreen);
			ToolTip.getInstance().registerComponent(this._normalScreenBtn,"退出全屏");
		}
		
		public function recommendData(param1:Vector.<RecommendVO>, param2:uint = 0) : void {
			this.destroyBoardRecommend();
			this._boardRecommend = new PlayFinishRecommend(param1,param2);
			this._boardRecommend.addEventListener(RecommendEvent.Evt_OpenVideo,this.onItemClick);
			this._boardRecommend.addEventListener(RecommendEvent.Evt_CustomizeItemClick,this.onCustomizeItemClick);
			addChild(this._boardRecommend);
			this.onResize(GlobalStage.stage.stageWidth,GlobalStage.stage.stageHeight);
		}
		
		public function onUserInfoChanged(param1:UserInfoVO) : void {
			this._userInfoVO = param1;
		}
		
		public function onAddStatus(param1:int) : void {
			this._status.addStatus(param1);
			switch(param1) {
				case RecommendDef.STATUS_FINISH_RECOMMEND_OPEN:
					this.open();
					break;
			}
		}
		
		public function onRemoveStatus(param1:int) : void {
			this._status.removeStatus(param1);
			switch(param1) {
				case RecommendDef.STATUS_FINISH_RECOMMEND_OPEN:
					this.close();
					break;
			}
		}
		
		public function onResize(param1:int, param2:int) : void {
			var _loc3_:* = NaN;
			if(isOnStage) {
				this._boardRecommendBg.width = GlobalStage.stage.stageWidth;
				this._boardRecommendBg.height = GlobalStage.stage.stageHeight - BodyDef.VIDEO_BOTTOM_RESERVE;
				if(GlobalStage.isFullScreen()) {
					this._normalScreenBtn.x = GlobalStage.stage.stageWidth - this._normalScreenBtn.width;
					this._normalScreenBtn.y = 8;
					addChild(this._normalScreenBtn);
				} else if(this._normalScreenBtn.parent) {
					removeChild(this._normalScreenBtn);
				}
				
				if(this._boardRecommend) {
					_loc3_ = SwitchManager.getInstance().getStatus(SwitchDef.ID_SHOW_CONTROL_BAR_ISHIDE)?GlobalStage.stage.stageHeight:GlobalStage.stage.stageHeight - BodyDef.VIDEO_BOTTOM_RESERVE;
					this._boardRecommend.resize(param1,_loc3_);
					this._boardRecommend.x = (param1 - this._boardRecommend.showWidth) / 2;
					this._boardRecommend.y = (_loc3_ - this._boardRecommend.showHeight) / 2;
				}
			}
		}
		
		override public function open(param1:DisplayObjectContainer = null) : void {
			if(!isOnStage) {
				super.open(param1);
				dispatchEvent(new RecommendEvent(RecommendEvent.Evt_Finish_Open));
			}
		}
		
		override public function close() : void {
			if(isOnStage) {
				super.close();
				dispatchEvent(new RecommendEvent(RecommendEvent.Evt_Finish_Close));
			}
		}
		
		override protected function onAddToStage() : void {
			super.onAddToStage();
			this.onResize(GlobalStage.stage.stageWidth,GlobalStage.stage.stageHeight);
		}
		
		override protected function onRemoveFromStage() : void {
			super.onRemoveFromStage();
			this.destroyBoardRecommend();
		}
		
		private function destroyBoardRecommend() : void {
			if((this._boardRecommend) && (this._boardRecommend.parent)) {
				this._boardRecommend.removeEventListener(RecommendEvent.Evt_OpenVideo,this.onItemClick);
				this._boardRecommend.removeEventListener(RecommendEvent.Evt_CustomizeItemClick,this.onCustomizeItemClick);
				this._boardRecommend.destroy();
				removeChild(this._boardRecommend);
				this._boardRecommend = null;
			}
		}
		
		private function onItemClick(param1:RecommendEvent) : void {
			dispatchEvent(new RecommendEvent(RecommendEvent.Evt_OpenVideo,param1.data as RecommendVO));
		}
		
		private function onCustomizeItemClick(param1:RecommendEvent) : void {
			dispatchEvent(new RecommendEvent(RecommendEvent.Evt_CustomizeItemClick));
		}
		
		private function onNormalScreen(param1:MouseEvent) : void {
			GlobalStage.setNormalScreen();
		}
	}
}
