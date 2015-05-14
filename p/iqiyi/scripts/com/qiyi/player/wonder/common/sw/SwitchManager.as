package com.qiyi.player.wonder.common.sw
{
	import flash.utils.Dictionary;
	import com.qiyi.player.wonder.common.vo.UserInfoVO;
	
	public class SwitchManager extends Object
	{
		
		private static var _instance:SwitchManager;
		
		private var _switchMap:Dictionary;
		
		private var _statusMap:Dictionary;
		
		public function SwitchManager(param1:SingletonClass)
		{
			super();
			this._switchMap = new Dictionary();
			this._statusMap = new Dictionary();
		}
		
		public static function getInstance() : SwitchManager
		{
			if(_instance == null)
			{
				_instance = new SwitchManager(new SingletonClass());
			}
			return _instance;
		}
		
		public function setStatus(param1:int, param2:Boolean) : void
		{
			var _loc3:ISwitch = null;
			if(param1 >= SwitchDef.ID_BEGIN && param1 < SwitchDef.ID_END)
			{
				this._statusMap[param1] = param2;
				_loc3 = this._switchMap[param1];
				if(_loc3)
				{
					_loc3.onSwitchStatusChanged(param1,param2);
				}
			}
		}
		
		public function getStatus(param1:int) : Boolean
		{
			if(param1 >= SwitchDef.ID_BEGIN && param1 < SwitchDef.ID_END)
			{
				return this._statusMap[param1];
			}
			return false;
		}
		
		public function register(param1:ISwitch) : void
		{
			var _loc2:Vector.<int> = param1.getSwitchID();
			var _loc3:* = 0;
			var _loc4:int = _loc2.length;
			var _loc5:* = 0;
			while(_loc5 < _loc4)
			{
				_loc3 = _loc2[_loc5];
				this._switchMap[_loc3] = param1;
				_loc5++;
			}
		}
		
		public function unregister(param1:ISwitch) : void
		{
			var _loc2:Vector.<int> = param1.getSwitchID();
			var _loc3:* = 0;
			var _loc4:int = _loc2.length;
			var _loc5:* = 0;
			while(_loc5 < _loc4)
			{
				_loc3 = _loc2[_loc5];
				if(this._switchMap[_loc3])
				{
					this._switchMap[_loc3] = null;
					delete this._switchMap[_loc3];
					true;
				}
				_loc5++;
			}
		}
		
		public function initByFlashVar(param1:String) : void
		{
			var _loc2:* = 0;
			var _loc3:String = null;
			var _loc4:String = null;
			var _loc5:String = null;
			var _loc6:* = 0;
			var _loc7:* = 0;
			if(param1)
			{
				_loc2 = 0;
				_loc3 = "";
				_loc2 = 0;
				while(_loc2 < param1.length)
				{
					_loc4 = param1.substr(_loc2,1);
					_loc4 = "0x" + _loc4;
					_loc5 = Number(_loc4).toString(2);
					_loc6 = _loc5.length;
					_loc7 = 0;
					while(_loc7 < 4 - _loc6)
					{
						_loc5 = "0" + _loc5;
						_loc7++;
					}
					_loc3 = _loc3 + _loc5;
					_loc2++;
				}
				_loc2 = SwitchDef.ID_BEGIN;
				while(_loc2 < SwitchDef.ID_END)
				{
					if(_loc2 < _loc3.length)
					{
						this._statusMap[_loc2] = _loc3.charAt(_loc2) == "1";
					}
					else
					{
						this._statusMap[_loc2] = false;
					}
					_loc2++;
				}
			}
		}
		
		public function initByUserInfo(param1:UserInfoVO) : void
		{
			if(param1)
			{
			}
		}
	}
}

class SingletonClass extends Object
{
	
	function SingletonClass()
	{
		super();
	}
}
