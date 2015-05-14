package com.qiyi.player.core.model.utils
{
	public class Status extends Object
	{
		
		private var _statusVector:Vector.<Boolean>;
		
		private var _begin:int;
		
		private var _end:int;
		
		public function Status(param1:int, param2:int)
		{
			super();
			this._begin = param1;
			this._end = param2;
			this._statusVector = new Vector.<Boolean>(this._end);
			var _loc3:* = 0;
			while(_loc3 < this._end)
			{
				this._statusVector[_loc3] = false;
				_loc3++;
			}
		}
		
		public function addStatus(param1:int) : void
		{
			if(param1 >= this._begin && param1 < this._end)
			{
				this._statusVector[param1] = true;
			}
		}
		
		public function removeStatus(param1:int) : void
		{
			if(param1 >= this._begin && param1 < this._end)
			{
				this._statusVector[param1] = false;
			}
		}
		
		public function hasStatus(param1:int) : Boolean
		{
			if(param1 >= this._begin && param1 < this._end)
			{
				return this._statusVector[param1];
			}
			return false;
		}
		
		public function clone() : Status
		{
			var _loc1:Status = new Status(this._begin,this._end);
			var _loc2:int = this._begin;
			while(_loc2 < this._end)
			{
				if(this.hasStatus(_loc2))
				{
					_loc1.addStatus(_loc2);
				}
				else
				{
					_loc1.removeStatus(_loc2);
				}
				_loc2++;
			}
			return _loc1;
		}
	}
}
