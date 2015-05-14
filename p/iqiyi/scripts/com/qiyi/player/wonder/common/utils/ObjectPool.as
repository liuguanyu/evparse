package com.qiyi.player.wonder.common.utils
{
	import flash.utils.Dictionary;
	
	public class ObjectPool extends Object
	{
		
		private var _pool:Dictionary;
		
		public function ObjectPool()
		{
			super();
			this._pool = new Dictionary(true);
		}
		
		public function push(param1:*) : void
		{
			this._pool[param1] = null;
		}
		
		public function pop() : Object
		{
			var _loc1:Object = null;
			var _loc2:* = undefined;
			for(_loc2 in this._pool)
			{
				delete this._pool[_loc2];
				true;
				return _loc2;
			}
			return null;
		}
		
		public function get length() : int
		{
			var _loc2:* = undefined;
			var _loc1:* = 0;
			for(_loc2 in this._pool)
			{
				_loc1++;
			}
			_loc2 = null;
			return _loc1;
		}
	}
}
