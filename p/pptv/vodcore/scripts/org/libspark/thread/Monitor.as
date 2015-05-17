package org.libspark.thread
{
	import flash.utils.clearTimeout;
	import flash.utils.Dictionary;
	import flash.utils.setTimeout;
	
	public class Monitor extends Object implements IMonitor
	{
		
		private var _timeoutList:Dictionary;
		
		private var _waitors:Array;
		
		public function Monitor()
		{
			super();
		}
		
		private function timeoutHandler(param1:Thread) : void
		{
			if(_waitors == null || _waitors.length < 1)
			{
				return;
			}
			var _loc2:int = _waitors.indexOf(param1);
			if(_loc2 == -1)
			{
				return;
			}
			_waitors.splice(_loc2,1);
			param1.monitorTimeout(this);
		}
		
		public function wait(param1:uint = 0) : void
		{
			var _loc2:Thread = Thread.getCurrentThread();
			_loc2.monitorWait(!(param1 == 0),this);
			getWaitors().push(_loc2);
			if(param1 != 0)
			{
				registerTimeout(_loc2,param1);
			}
		}
		
		private function unregisterTimeout(param1:Thread) : void
		{
			if(_timeoutList == null)
			{
				return;
			}
			var _loc2:Object = _timeoutList[param1];
			if(_loc2 != null)
			{
				clearTimeout(uint(_loc2));
				delete _timeoutList[param1];
				true;
			}
		}
		
		private function getWaitors() : Array
		{
			return _waitors || (_waitors = []);
		}
		
		public function notify() : void
		{
			if(_waitors == null || _waitors.length < 1)
			{
				return;
			}
			var _loc1:Thread = Thread(_waitors.shift());
			unregisterTimeout(_loc1);
			_loc1.monitorWakeup(this);
		}
		
		public function leave(param1:Thread) : void
		{
			if(_waitors == null || _waitors.length < 1)
			{
				return;
			}
			var _loc2:int = _waitors.indexOf(param1);
			if(_loc2 == -1)
			{
				return;
			}
			_waitors.splice(_loc2,1);
			unregisterTimeout(param1);
		}
		
		private function registerTimeout(param1:Thread, param2:uint) : void
		{
			if(_timeoutList == null)
			{
				_timeoutList = new Dictionary();
			}
			_timeoutList[param1] = setTimeout(timeoutHandler,param2,param1);
		}
		
		public function notifyAll() : void
		{
			var ex:Object = null;
			var thread:Thread = null;
			if(_waitors == null || _waitors.length < 1)
			{
				return;
			}
			ex = null;
			for each(thread in _waitors)
			{
				unregisterTimeout(thread);
				try
				{
					thread.monitorWakeup(this);
				}
				catch(e:Object)
				{
					if(ex == null)
					{
						ex = e;
					}
					continue;
				}
			}
			_waitors.length = 0;
			if(ex != null)
			{
				throw ex;
			}
			else
			{
				return;
			}
		}
	}
}
