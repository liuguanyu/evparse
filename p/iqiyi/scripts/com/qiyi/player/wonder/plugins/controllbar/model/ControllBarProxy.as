package com.qiyi.player.wonder.plugins.controllbar.model {
	import org.puremvc.as3.patterns.proxy.Proxy;
	import com.qiyi.player.wonder.common.status.IStatus;
	import com.qiyi.player.wonder.common.status.Status;
	import com.qiyi.player.wonder.plugins.controllbar.ControllBarDef;
	import com.qiyi.player.wonder.plugins.controllbar.view.preview.image.PreviewImageLoader;
	
	public class ControllBarProxy extends Proxy implements IStatus {
		
		public function ControllBarProxy(param1:Object = null) {
			super(NAME,param1);
			this._status = new Status(ControllBarDef.STATUS_BEGIN,ControllBarDef.STATUS_END);
			this._status.addStatus(ControllBarDef.STATUS_VIEW_INIT);
			this._status.addStatus(ControllBarDef.STATUS_FULL_SCREEN_BTN_SHOW);
			PreviewImageLoader.instance.init();
		}
		
		public static const NAME:String = "com.qiyi.player.wonder.plugins.controllbar.model.ControllBarProxy";
		
		private var _status:Status;
		
		private var _playerLightOn:Boolean = true;
		
		private var _keyDownSeeking:Boolean = false;
		
		private var _keyDownVolume:Boolean = false;
		
		private var _isFullScreen:Boolean = false;
		
		private var _definitionBtnX:Number;
		
		private var _filterBtnX:Number;
		
		private var _definitionBtnY:Number;
		
		private var _seekCount:uint = 0;
		
		private var _isFirstPlay:Boolean = false;
		
		public function get isFirstPlay() : Boolean {
			return this._isFirstPlay;
		}
		
		public function set isFirstPlay(param1:Boolean) : void {
			this._isFirstPlay = param1;
		}
		
		public function get seekCount() : uint {
			return this._seekCount;
		}
		
		public function set seekCount(param1:uint) : void {
			this._seekCount = param1;
		}
		
		public function get filterBtnX() : Number {
			return this._filterBtnX;
		}
		
		public function set filterBtnX(param1:Number) : void {
			this._filterBtnX = param1;
		}
		
		public function get definitionBtnX() : Number {
			return this._definitionBtnX;
		}
		
		public function set definitionBtnX(param1:Number) : void {
			this._definitionBtnX = param1;
		}
		
		public function get definitionBtnY() : Number {
			return this._definitionBtnY;
		}
		
		public function set definitionBtnY(param1:Number) : void {
			this._definitionBtnY = param1;
		}
		
		public function get status() : Status {
			return this._status;
		}
		
		public function get playerLightOn() : Boolean {
			return this._playerLightOn;
		}
		
		public function set playerLightOn(param1:Boolean) : void {
			this._playerLightOn = param1;
		}
		
		public function get keyDownSeeking() : Boolean {
			return this._keyDownSeeking;
		}
		
		public function set keyDownSeeking(param1:Boolean) : void {
			this._keyDownSeeking = param1;
		}
		
		public function get keyDownVolume() : Boolean {
			return this._keyDownVolume;
		}
		
		public function set keyDownVolume(param1:Boolean) : void {
			this._keyDownVolume = param1;
		}
		
		public function get isFullScreen() : Boolean {
			return this._isFullScreen;
		}
		
		public function set isFullScreen(param1:Boolean) : void {
			this._isFullScreen = param1;
		}
		
		public function addStatus(param1:int, param2:Boolean = true) : void {
			if(param1 >= ControllBarDef.STATUS_BEGIN && param1 < ControllBarDef.STATUS_END && !this._status.hasStatus(param1)) {
				if(param1 == ControllBarDef.STATUS_OPEN && !this._status.hasStatus(ControllBarDef.STATUS_VIEW_INIT)) {
					this._status.addStatus(ControllBarDef.STATUS_VIEW_INIT);
					sendNotification(ControllBarDef.NOTIFIC_ADD_STATUS,ControllBarDef.STATUS_VIEW_INIT);
				}
				switch(param1) {
					case ControllBarDef.STATUS_TRIGGER_BTN_SHOW:
						this._status.removeStatus(ControllBarDef.STATUS_LOAD_BTN_SHOW);
						this._status.removeStatus(ControllBarDef.STATUS_LOAD_TIPS_SHOW);
						this._status.removeStatus(ControllBarDef.STATUS_REPLAY_BTN_SHOW);
						this._status.removeStatus(ControllBarDef.STATUS_TRIGGER_BTN_PAUSE);
						break;
					case ControllBarDef.STATUS_LOAD_BTN_SHOW:
						this._status.removeStatus(ControllBarDef.STATUS_TRIGGER_BTN_SHOW);
						this._status.removeStatus(ControllBarDef.STATUS_TRIGGER_BTN_PAUSE);
						this._status.removeStatus(ControllBarDef.STATUS_REPLAY_BTN_SHOW);
						break;
					case ControllBarDef.STATUS_REPLAY_BTN_SHOW:
						this._status.removeStatus(ControllBarDef.STATUS_TRIGGER_BTN_SHOW);
						this._status.removeStatus(ControllBarDef.STATUS_TRIGGER_BTN_PAUSE);
						this._status.removeStatus(ControllBarDef.STATUS_LOAD_BTN_SHOW);
						this._status.removeStatus(ControllBarDef.STATUS_LOAD_TIPS_SHOW);
						break;
					case ControllBarDef.STATUS_TRIGGER_BTN_PAUSE:
						this._status.removeStatus(ControllBarDef.STATUS_TRIGGER_BTN_SHOW);
						this._status.removeStatus(ControllBarDef.STATUS_LOAD_BTN_SHOW);
						this._status.removeStatus(ControllBarDef.STATUS_LOAD_TIPS_SHOW);
						this._status.removeStatus(ControllBarDef.STATUS_REPLAY_BTN_SHOW);
						break;
				}
				this._status.addStatus(param1);
				if(param2) {
					sendNotification(ControllBarDef.NOTIFIC_ADD_STATUS,param1);
				}
			}
		}
		
		public function removeStatus(param1:int, param2:Boolean = true) : void {
			if(param1 >= ControllBarDef.STATUS_BEGIN && param1 < ControllBarDef.STATUS_END && (this._status.hasStatus(param1))) {
				this._status.removeStatus(param1);
				if(param2) {
					sendNotification(ControllBarDef.NOTIFIC_REMOVE_STATUS,param1);
				}
			}
		}
		
		public function hasStatus(param1:int) : Boolean {
			return this._status.hasStatus(param1);
		}
	}
}
