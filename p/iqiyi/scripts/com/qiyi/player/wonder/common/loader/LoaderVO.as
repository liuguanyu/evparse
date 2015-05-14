package com.qiyi.player.wonder.common.loader
{
	public class LoaderVO extends Object
	{
		
		private var _url:String = "";
		
		private var _sucFun:Function = null;
		
		private var _errorFun:Function = null;
		
		private var _type:String = "";
		
		private var _retry:uint = 0;
		
		private var _alreadyTry:uint = 0;
		
		public function LoaderVO(param1:String, param2:Function, param3:Function, param4:String, param5:uint = 0)
		{
			super();
			this._url = param1;
			this._sucFun = param2;
			this._errorFun = param3;
			this._type = param4;
			this._retry = param5;
		}
		
		public function get sucFun() : Function
		{
			return this._sucFun;
		}
		
		public function get errorFun() : Function
		{
			return this._errorFun;
		}
		
		public function get alreadyTry() : uint
		{
			return this._alreadyTry;
		}
		
		public function set alreadyTry(param1:uint) : void
		{
			this._alreadyTry = param1;
		}
		
		public function get retry() : uint
		{
			return this._retry;
		}
		
		public function get type() : String
		{
			return this._type;
		}
		
		public function get url() : String
		{
			return this._url;
		}
		
		public function destroy() : void
		{
			this._url = null;
			this._sucFun = null;
			this._errorFun = null;
			this._type = null;
			this._retry = 0;
		}
	}
}
