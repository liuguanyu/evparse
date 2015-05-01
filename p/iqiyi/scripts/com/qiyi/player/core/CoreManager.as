package com.qiyi.player.core {
	import flash.events.EventDispatcher;
	import com.qiyi.player.base.pub.EnumItem;
	import com.qiyi.player.core.player.IPlayer;
	import com.qiyi.player.base.logging.ILogger;
	import flash.display.Stage;
	import flash.system.Capabilities;
	import com.iqiyi.components.global.GlobalStage;
	import com.qiyi.player.core.model.impls.pub.Settings;
	import com.qiyi.player.core.model.impls.pub.Statistics;
	import com.qiyi.player.base.uuid.UUIDManager;
	import com.qiyi.player.core.video.render.StageVideoManager;
	import com.qiyi.player.core.player.coreplayer.ICorePlayer;
	import com.qiyi.player.core.player.coreplayer.CorePlayer;
	import com.qiyi.player.base.logging.Log;
	
	public class CoreManager extends EventDispatcher {
		
		public function CoreManager(param1:SingletonClass) {
			this._log = Log.getLogger("com.qiyi.player.core.CoreManager");
			super();
			this._playerVec = new Vector.<IPlayer>();
		}
		
		public static const Evt_InitComplete:String = "evtInitComplete";
		
		private static var _instance:CoreManager;
		
		public static function getInstance() : CoreManager {
			if(_instance == null) {
				_instance = new CoreManager(new SingletonClass());
			}
			return _instance;
		}
		
		private var _inited:Boolean = false;
		
		private var _platform:EnumItem;
		
		private var _playerType:EnumItem;
		
		private var _playerVec:Vector.<IPlayer>;
		
		private var _flashP2PCoreURL:String = "";
		
		private var _log:ILogger;
		
		public function initialize(param1:Stage, param2:EnumItem, param3:EnumItem, param4:String) : Boolean {
			if(this._inited) {
				return true;
			}
			this._log.info("flash kernel(version: " + Version.VERSION + "." + Version.VERSION_DEV + ") initializing... ");
			var _loc5_:String = "systeminfo: os(" + Capabilities.os;
			_loc5_ = _loc5_ + ("), language(" + Capabilities.language);
			_loc5_ = _loc5_ + ("), flashplayer(" + Capabilities.version);
			_loc5_ = _loc5_ + ("), playerType(" + Capabilities.playerType);
			_loc5_ = _loc5_ + ("), debug(" + Capabilities.isDebugger);
			_loc5_ = _loc5_ + ("), hasStreamingVideo(" + Capabilities.hasStreamingVideo);
			_loc5_ = _loc5_ + ("), hasStreamingAudio(" + Capabilities.hasStreamingAudio);
			_loc5_ = _loc5_ + ("), maxLevelIDC(" + Capabilities.maxLevelIDC);
			_loc5_ = _loc5_ + ("), cpuArchitecture(" + Capabilities.cpuArchitecture);
			_loc5_ = _loc5_ + ")";
			this._log.info(_loc5_);
			this._platform = param2;
			this._playerType = param3;
			this._flashP2PCoreURL = param4;
			if(param1) {
				GlobalStage.initStage(param1);
			}
			Settings.loadFromCookies();
			Statistics.loadFromCookie();
			UUIDManager.instance.load();
			StageVideoManager.instance.initialize(param1);
			this._inited = true;
			return true;
		}
		
		public function createPlayer(param1:EnumItem) : IPlayer {
			var _loc2_:ICorePlayer = null;
			if(this._inited) {
				this._log.info("Core Create Player");
				_loc2_ = new CorePlayer();
				_loc2_.runtimeData.playerUseType = param1;
				_loc2_.runtimeData.playerType = this._playerType;
				_loc2_.runtimeData.platform = this._platform;
				_loc2_.runtimeData.flashP2PCoreURL = this._flashP2PCoreURL;
				this._playerVec.push(_loc2_);
				return _loc2_;
			}
			return null;
		}
		
		public function deletePlayer(param1:IPlayer) : void {
			var _loc2_:* = 0;
			var _loc3_:IPlayer = null;
			var _loc4_:* = 0;
			if(param1) {
				this._log.info("Core Delete Player");
				_loc2_ = this._playerVec.length;
				_loc3_ = null;
				_loc4_ = 0;
				while(_loc4_ < _loc2_) {
					_loc3_ = this._playerVec[_loc4_];
					if(_loc3_ == param1) {
						this._playerVec.splice(_loc4_,1);
						break;
					}
					_loc4_++;
				}
				param1.destroy();
			}
		}
		
		public function findPlayer(param1:String) : IPlayer {
			var _loc2_:int = this._playerVec.length;
			var _loc3_:IPlayer = null;
			var _loc4_:* = 0;
			while(_loc4_ < _loc2_) {
				_loc3_ = this._playerVec[_loc4_];
				if((_loc3_) && (_loc3_.movieModel) && _loc3_.movieModel.tvid == param1) {
					return _loc3_;
				}
				_loc4_++;
			}
			return null;
		}
	}
}
class SingletonClass extends Object {
	
	function SingletonClass() {
		super();
	}
}
