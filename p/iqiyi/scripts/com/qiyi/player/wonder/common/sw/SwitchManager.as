package com.qiyi.player.wonder.common.sw {
	import flash.utils.Dictionary;
	import com.qiyi.player.wonder.common.vo.UserInfoVO;
	
	public class SwitchManager extends Object {
		
		public function SwitchManager(param1:SingletonClass) {
			super();
			this._switchMap = new Dictionary();
			this._statusMap = new Dictionary();
		}
		
		private static var _instance:SwitchManager;
		
		public static function getInstance() : SwitchManager {
			if(_instance == null) {
				_instance = new SwitchManager(new SingletonClass());
			}
			return _instance;
		}
		
		private var _switchMap:Dictionary;
		
		private var _statusMap:Dictionary;
		
		public function setStatus(param1:int, param2:Boolean) : void {
			var _loc3_:ISwitch = null;
			if(param1 >= SwitchDef.ID_BEGIN && param1 < SwitchDef.ID_END) {
				this._statusMap[param1] = param2;
				_loc3_ = this._switchMap[param1];
				if(_loc3_) {
					_loc3_.onSwitchStatusChanged(param1,param2);
				}
			}
		}
		
		public function getStatus(param1:int) : Boolean {
			if(param1 >= SwitchDef.ID_BEGIN && param1 < SwitchDef.ID_END) {
				return this._statusMap[param1];
			}
			return false;
		}
		
		public function register(param1:ISwitch) : void {
			var _loc2_:Vector.<int> = param1.getSwitchID();
			var _loc3_:* = 0;
			var _loc4_:int = _loc2_.length;
			var _loc5_:* = 0;
			while(_loc5_ < _loc4_) {
				_loc3_ = _loc2_[_loc5_];
				this._switchMap[_loc3_] = param1;
				_loc5_++;
			}
		}
		
		public function unregister(param1:ISwitch) : void {
			var _loc2_:Vector.<int> = param1.getSwitchID();
			var _loc3_:* = 0;
			var _loc4_:int = _loc2_.length;
			var _loc5_:* = 0;
			while(_loc5_ < _loc4_) {
				_loc3_ = _loc2_[_loc5_];
				if(this._switchMap[_loc3_]) {
					this._switchMap[_loc3_] = null;
					delete this._switchMap[_loc3_];
					true;
				}
				_loc5_++;
			}
		}
		
		public function initByFlashVar(param1:String) : void {
			var _loc2_:* = 0;
			var _loc3_:String = null;
			var _loc4_:String = null;
			var _loc5_:String = null;
			var _loc6_:* = 0;
			var _loc7_:* = 0;
			if(param1) {
				_loc2_ = 0;
				_loc3_ = "";
				_loc2_ = 0;
				while(_loc2_ < param1.length) {
					_loc4_ = param1.substr(_loc2_,1);
					_loc4_ = "0x" + _loc4_;
					_loc5_ = Number(_loc4_).toString(2);
					_loc6_ = _loc5_.length;
					_loc7_ = 0;
					while(_loc7_ < 4 - _loc6_) {
						_loc5_ = "0" + _loc5_;
						_loc7_++;
					}
					_loc3_ = _loc3_ + _loc5_;
					_loc2_++;
				}
				_loc2_ = SwitchDef.ID_BEGIN;
				while(_loc2_ < SwitchDef.ID_END) {
					if(_loc2_ < _loc3_.length) {
						this._statusMap[_loc2_] = _loc3_.charAt(_loc2_) == "1";
					} else {
						this._statusMap[_loc2_] = false;
					}
					_loc2_++;
				}
			}
		}
		
		public function initByUserInfo(param1:UserInfoVO) : void {
			if(param1) {
			}
		}
	}
}
class SingletonClass extends Object {
	
	function SingletonClass() {
		super();
	}
}
