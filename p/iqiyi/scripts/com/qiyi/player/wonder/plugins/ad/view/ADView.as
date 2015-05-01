package com.qiyi.player.wonder.plugins.ad.view {
	import com.iqiyi.components.panelSystem.impls.BasePanel;
	import com.qiyi.player.wonder.common.status.Status;
	import com.qiyi.player.wonder.common.vo.UserInfoVO;
	import com.qiyi.cupid.adplayer.CupidAdPlayer;
	import com.qiyi.player.base.logging.ILogger;
	import com.qiyi.player.wonder.plugins.ad.ADDef;
	import com.qiyi.cupid.adplayer.events.AdPlayerEvent;
	import com.qiyi.cupid.adplayer.base.CupidParam;
	import com.iqiyi.components.global.GlobalStage;
	import flash.events.MouseEvent;
	import gs.TweenLite;
	import flash.utils.getTimer;
	import flash.display.DisplayObjectContainer;
	import com.qiyi.player.base.logging.Log;
	
	public class ADView extends BasePanel {
		
		public function ADView(param1:DisplayObjectContainer, param2:Status, param3:UserInfoVO) {
			this._log = Log.getLogger("com.qiyi.player.wonder.plugins.ad.view.ADView");
			super(NAME,param1);
			this._status = param2;
			this._userInfoVO = param3;
			this.onResize(GlobalStage.stage.stageWidth,GlobalStage.stage.stageHeight);
		}
		
		public static const NAME:String = "com.qiyi.player.wonder.plugins.ad.view.ADView";
		
		private var _status:Status;
		
		private var _userInfoVO:UserInfoVO;
		
		private var _adPlayer:CupidAdPlayer;
		
		private var _adDepot:String = "0";
		
		private var _lastMouseMove:int = 0;
		
		private var _dockShowFlag:Boolean = false;
		
		private var _log:ILogger;
		
		public function get adDepot() : String {
			return this._adDepot;
		}
		
		public function get adPlayer() : CupidAdPlayer {
			return this._adPlayer;
		}
		
		public function onUserInfoChanged(param1:UserInfoVO) : void {
			this._userInfoVO = param1;
		}
		
		public function onAddStatus(param1:int) : void {
			this._status.addStatus(param1);
			switch(param1) {
				case ADDef.STATUS_OPEN:
					this.open();
					break;
			}
		}
		
		public function onRemoveStatus(param1:int) : void {
			this._status.removeStatus(param1);
			switch(param1) {
				case ADDef.STATUS_OPEN:
					this.close();
					break;
			}
		}
		
		public function onResize(param1:int, param2:int) : void {
			var _loc3_:Object = null;
			if(this._adPlayer) {
				_loc3_ = new Object();
				_loc3_.v_x = 0;
				_loc3_.v_y = 0;
				_loc3_.width = param1;
				_loc3_.height = param2;
				_loc3_.v_w = param1;
				_loc3_.v_h = _loc3_.height;
				this._adPlayer.dispatchEvent(new AdPlayerEvent(AdPlayerEvent.VIDEO_CHANGE_SIZE,_loc3_));
			}
		}
		
		public function createAdPlayer(param1:CupidParam) : void {
			if(this._adPlayer) {
				this.unloadAdPlayer();
			}
			this._log.info("loading adplayer...");
			this._adPlayer = new CupidAdPlayer(param1);
			this._adPlayer.addEventListener(AdPlayerEvent.ADPLAYER_LOADING_SUCCESS,this.onAdLoadSuccess);
			this._adPlayer.addEventListener(AdPlayerEvent.ADPLAYER_LOADING_FAILURE,this.onAdLoadFailed);
			this._adPlayer.addEventListener(AdPlayerEvent.ADPLAYER_AD_START,this.onAdStartPlay);
			this._adPlayer.addEventListener(AdPlayerEvent.CONTROL_VIDEO_PAUSE,this.onAdAskVideoPause);
			this._adPlayer.addEventListener(AdPlayerEvent.CONTROL_VIDEO_RESUME,this.onAdAskVideoResume);
			this._adPlayer.addEventListener(AdPlayerEvent.CONTROL_VIDEO_START_LOADING,this.onAdAskVideoStartLoad);
			this._adPlayer.addEventListener(AdPlayerEvent.CONTROL_VIDEO_START,this.onAdAskVideoStartPlay);
			this._adPlayer.addEventListener(AdPlayerEvent.CONTROL_VIDEO_END,this.onAdAskVideoEnd);
			this._adPlayer.addEventListener(AdPlayerEvent.ADPLAYER_AD_BLOCK,this.onAdBlock);
			this._adPlayer.load();
		}
		
		public function unloadAdPlayer() : void {
			if(this._adPlayer == null) {
				return;
			}
			this._log.info("unload adplayer....");
			this._adPlayer.removeEventListener(AdPlayerEvent.ADPLAYER_LOADING_SUCCESS,this.onAdLoadSuccess);
			this._adPlayer.removeEventListener(AdPlayerEvent.ADPLAYER_LOADING_FAILURE,this.onAdLoadFailed);
			this._adPlayer.removeEventListener(AdPlayerEvent.ADPLAYER_AD_START,this.onAdStartPlay);
			this._adPlayer.removeEventListener(AdPlayerEvent.CONTROL_VIDEO_PAUSE,this.onAdAskVideoPause);
			this._adPlayer.removeEventListener(AdPlayerEvent.CONTROL_VIDEO_RESUME,this.onAdAskVideoResume);
			this._adPlayer.removeEventListener(AdPlayerEvent.CONTROL_VIDEO_START_LOADING,this.onAdAskVideoStartLoad);
			this._adPlayer.removeEventListener(AdPlayerEvent.CONTROL_VIDEO_START,this.onAdAskVideoStartPlay);
			this._adPlayer.removeEventListener(AdPlayerEvent.CONTROL_VIDEO_END,this.onAdAskVideoEnd);
			this._adPlayer.removeEventListener(AdPlayerEvent.ADPLAYER_AD_BLOCK,this.onAdBlock);
			this._adPlayer.dispatchEvent(new AdPlayerEvent(AdPlayerEvent.VIDEO_FORCE_AD_STOP));
			this._adPlayer.destroy();
			this._adPlayer = null;
			GlobalStage.stage.removeEventListener(MouseEvent.MOUSE_MOVE,this.onMouseMove);
			TweenLite.killTweensOf(this.showLeftAD);
			dispatchEvent(new ADEvent(ADEvent.Evt_AdUnloaded));
		}
		
		public function onUpdateCurrentTime(param1:int) : void {
			if(this._adPlayer) {
				this._adPlayer.dispatchEvent(new AdPlayerEvent(AdPlayerEvent.VIDEO_TIME_CHANGE,param1 / 1000));
			}
		}
		
		public function onSwitchPre() : void {
			if(this._adPlayer) {
				this._adPlayer.dispatchEvent(new AdPlayerEvent(AdPlayerEvent.VIDEO_VIEW_SWITCH));
			}
		}
		
		public function onPreloadNextAD(param1:Object) : void {
			if(this._adPlayer) {
				this._adPlayer.dispatchEvent(new AdPlayerEvent(AdPlayerEvent.PRELOAD_AD_NEXT,param1));
			}
		}
		
		public function onVideoStop() : void {
			if(this._adPlayer) {
				this._adPlayer.dispatchEvent(new AdPlayerEvent(AdPlayerEvent.VIDEO_PLAY_OVER));
			}
		}
		
		public function onResume() : void {
			if(this._adPlayer) {
				this._adPlayer.dispatchEvent(new AdPlayerEvent(AdPlayerEvent.VIDEO_RESUME));
			}
		}
		
		public function onPause() : void {
			if(this._adPlayer) {
				this._adPlayer.dispatchEvent(new AdPlayerEvent(AdPlayerEvent.VIDEO_PAUSE));
			}
		}
		
		public function onLightStateChanged(param1:Boolean) : void {
			if(this._adPlayer) {
				if(param1) {
					this._adPlayer.dispatchEvent(new AdPlayerEvent(AdPlayerEvent.VIDEO_LIGHT_TURN_ON));
				} else {
					this._adPlayer.dispatchEvent(new AdPlayerEvent(AdPlayerEvent.VIDEO_LIGHT_TURN_OFF));
				}
			}
		}
		
		public function onVolumeChanged(param1:int) : void {
			if(this._adPlayer) {
				this._adPlayer.dispatchEvent(new AdPlayerEvent(AdPlayerEvent.VIDEO_CHANGE_VOLUME,param1));
			}
		}
		
		public function onFullScreenChanged(param1:Boolean) : void {
			if(this._adPlayer) {
				if(param1) {
					this._adPlayer.dispatchEvent(new AdPlayerEvent(AdPlayerEvent.VIDEO_FULLSCREEN));
				} else {
					this._adPlayer.dispatchEvent(new AdPlayerEvent(AdPlayerEvent.VIDEO_NORMALSCREEN));
				}
			}
		}
		
		public function onDockShowChanged(param1:Boolean) : void {
			if(this._dockShowFlag == param1) {
				return;
			}
			this._dockShowFlag = param1;
			if(this._adPlayer) {
				if(param1) {
					this._lastMouseMove = 0;
					GlobalStage.stage.addEventListener(MouseEvent.MOUSE_MOVE,this.onMouseMove);
					TweenLite.delayedCall(1,this.showLeftAD);
				} else {
					GlobalStage.stage.removeEventListener(MouseEvent.MOUSE_MOVE,this.onMouseMove);
					TweenLite.killTweensOf(this.showLeftAD);
					this._adPlayer.dispatchEvent(new AdPlayerEvent(AdPlayerEvent.VIDEO_DOCK_HIDE));
				}
			}
		}
		
		private function showLeftAD() : void {
			GlobalStage.stage.removeEventListener(MouseEvent.MOUSE_MOVE,this.onMouseMove);
			if(this._adPlayer) {
				if(getTimer() - this._lastMouseMove < 200) {
					this._adPlayer.dispatchEvent(new AdPlayerEvent(AdPlayerEvent.VIDEO_DOCK_SHOW));
				}
			}
		}
		
		public function onPopupOpen() : void {
			if(this._adPlayer) {
				this._adPlayer.dispatchEvent(new AdPlayerEvent(AdPlayerEvent.VIDEO_DIALOG_POPUP));
			}
		}
		
		public function onPopupClose() : void {
			if(this._adPlayer) {
				this._adPlayer.dispatchEvent(new AdPlayerEvent(AdPlayerEvent.VIDEO_DIALOG_CLOSE));
			}
		}
		
		public function onCurInfoChanged(param1:Object) : void {
			if(this._adPlayer) {
				this._adPlayer.dispatchEvent(new AdPlayerEvent(AdPlayerEvent.VIDEO_INFO,param1));
			}
		}
		
		public function onPreInfoChanged(param1:Object) : void {
			if(this._adPlayer) {
				this._adPlayer.dispatchEvent(new AdPlayerEvent(AdPlayerEvent.NEXT_VIDEO_INFO,param1));
			}
		}
		
		public function onSendNotific(param1:Object) : void {
			if(this._adPlayer) {
				this._adPlayer.dispatchEvent(new AdPlayerEvent(AdPlayerEvent.VIDEO_NOTIFICATION,param1));
			}
		}
		
		override public function open(param1:DisplayObjectContainer = null) : void {
			if(!isOnStage) {
				super.open(param1);
				dispatchEvent(new ADEvent(ADEvent.Evt_Open));
			}
		}
		
		override public function close() : void {
			if(isOnStage) {
				super.close();
				dispatchEvent(new ADEvent(ADEvent.Evt_Close));
			}
		}
		
		override protected function onAddToStage() : void {
			super.onAddToStage();
		}
		
		override protected function onRemoveFromStage() : void {
			super.onRemoveFromStage();
		}
		
		private function onAdLoadSuccess(param1:AdPlayerEvent) : void {
			var _loc2_:Object = {};
			_loc2_.tvid = param1.data.tvId;
			_loc2_.vid = param1.data.videoId;
			_loc2_.version = param1.data.data;
			dispatchEvent(new ADEvent(ADEvent.Evt_LoadSuccess,_loc2_));
		}
		
		private function onAdLoadFailed(param1:AdPlayerEvent) : void {
			var _loc2_:Object = {};
			_loc2_.tvid = param1.data.tvId;
			_loc2_.vid = param1.data.videoId;
			dispatchEvent(new ADEvent(ADEvent.Evt_LoadFailed,_loc2_));
		}
		
		private function onAdStartPlay(param1:AdPlayerEvent) : void {
			var _loc2_:Object = {};
			_loc2_.tvid = param1.data.tvId;
			_loc2_.vid = param1.data.videoId;
			dispatchEvent(new ADEvent(ADEvent.Evt_StartPlay,_loc2_));
		}
		
		private function onAdAskVideoPause(param1:AdPlayerEvent) : void {
			var _loc2_:Object = {};
			_loc2_.tvid = param1.data.tvId;
			_loc2_.vid = param1.data.videoId;
			dispatchEvent(new ADEvent(ADEvent.Evt_AskVideoPause,_loc2_));
		}
		
		private function onAdAskVideoResume(param1:AdPlayerEvent) : void {
			var _loc2_:Object = {};
			_loc2_.tvid = param1.data.tvId;
			_loc2_.vid = param1.data.videoId;
			dispatchEvent(new ADEvent(ADEvent.Evt_AskVideoResume,_loc2_));
		}
		
		private function onAdAskVideoStartLoad(param1:AdPlayerEvent) : void {
			var _loc2_:Object = {};
			_loc2_.tvid = param1.data.tvId;
			_loc2_.vid = param1.data.videoId;
			_loc2_.delay = param1.data.data;
			dispatchEvent(new ADEvent(ADEvent.Evt_AskVideoStartLoad,_loc2_));
		}
		
		private function onAdAskVideoStartPlay(param1:AdPlayerEvent) : void {
			var _loc2_:Object = {};
			_loc2_.tvid = param1.data.tvId;
			_loc2_.vid = param1.data.videoId;
			if(param1.data.data) {
				_loc2_.viewPoints = param1.data.data.viewPoints;
			}
			dispatchEvent(new ADEvent(ADEvent.Evt_AskVideoStartPlay,_loc2_));
		}
		
		private function onAdAskVideoEnd(param1:AdPlayerEvent) : void {
			this._adDepot = param1.data.data as String;
			var _loc2_:Object = {};
			_loc2_.tvid = param1.data.tvId;
			_loc2_.vid = param1.data.videoId;
			dispatchEvent(new ADEvent(ADEvent.Evt_AskVideoEnd,_loc2_));
		}
		
		private function onAdBlock(param1:AdPlayerEvent) : void {
			var _loc2_:Object = {};
			_loc2_.tvid = param1.data.tvId;
			_loc2_.vid = param1.data.videoId;
			if(param1.data.hasOwnProperty("isCidErr")) {
				_loc2_.isCidErr = Boolean(param1.data.isCidErr);
			} else {
				_loc2_.isCidErr = false;
			}
			dispatchEvent(new ADEvent(ADEvent.Evt_AdBlock,_loc2_));
		}
		
		private function onMouseMove(param1:MouseEvent) : void {
			this._lastMouseMove = getTimer();
		}
	}
}
