package com.pplive.p2p
{
	import com.pplive.monitor.Monitable;
	import org.as3commons.logging.api.ILogger;
	import org.as3commons.logging.api.getLogger;
	import flash.utils.Dictionary;
	
	public class CacheManager extends Monitable
	{
		
		private static var logger:ILogger = getLogger(CacheManager);
		
		private var _resources:Dictionary;
		
		private var _memBound:uint;
		
		public function CacheManager(param1:uint)
		{
			super("ResourceManager");
			this._resources = new Dictionary();
			this._memBound = param1;
		}
		
		public function get memBound() : uint
		{
			return this._memBound;
		}
		
		public function set memBound(param1:uint) : void
		{
			this._memBound = param1;
			this.shrink();
		}
		
		public function getResource(param1:String) : ResourceCache
		{
			return this._resources[param1] as ResourceCache;
		}
		
		public function removeResource(param1:String) : void
		{
			if(this._resources[param1])
			{
				monitor.removeChild(this._resources[param1].monitor);
				delete this._resources[param1];
				true;
			}
		}
		
		public function addResource(param1:String, param2:ResourceCache) : void
		{
			if((param1) && (param2))
			{
				if(this._resources[param1])
				{
					monitor.removeChild(this._resources[param1].monitor);
				}
				this._resources[param1] = param2;
				param2.monitor.setAttr("rid",param1.toString());
				monitor.addChild(param2.monitor);
				this.shrink();
			}
		}
		
		public function createResource(param1:String, param2:uint, param3:uint) : ResourceCache
		{
			if(this._resources[param1])
			{
				return this._resources[param1];
			}
			this.shrink();
			var _loc4:ResourceCache = new ResourceCache(param2,param3);
			this._resources[param1] = _loc4;
			_loc4.monitor.setAttr("rid",param1.toString());
			monitor.addChild(_loc4.monitor);
			return _loc4;
		}
		
		public function shrink() : void
		{
			var _loc2:String = null;
			var _loc5:ResourceCache = null;
			var _loc1:uint = 0;
			for(_loc2 in this._resources)
			{
				_loc1 = _loc1 + this._resources[_loc2].memUsed;
			}
			if(_loc1 <= this._memBound)
			{
				return;
			}
			var _loc3:Vector.<String> = this.rids;
			_loc3.sort(this.upspeedCmp);
			var _loc4:uint = 0;
			while(_loc4 < _loc3.length)
			{
				_loc2 = _loc3[_loc4];
				_loc5 = this._resources[_loc2] as ResourceCache;
				if((_loc5.stat.droppable) && !_loc5.stat.isDownloading)
				{
					this.removeResource(_loc2);
					_loc1 = _loc1 - _loc5.memUsed;
					if(_loc1 <= this._memBound)
					{
						break;
					}
				}
				_loc4++;
			}
		}
		
		public function get rids() : Vector.<String>
		{
			var _loc2:String = null;
			var _loc1:Vector.<String> = new Vector.<String>();
			for(_loc2 in this._resources)
			{
				_loc1.push(_loc2);
			}
			return _loc1;
		}
		
		public function clear() : void
		{
			var _loc1:* = undefined;
			for(_loc1 in this._resources)
			{
				monitor.removeChild(this._resources[_loc1].monitor);
			}
			this._resources = new Dictionary();
		}
		
		private function upspeedCmp(param1:String, param2:String) : Number
		{
			return this._resources[param1].stat.uploadSpeed.getRecentSpeedInKBPS() - this._resources[param2].stat.uploadSpeed.getRecentSpeedInKBPS();
		}
		
		override public function updateMonitedAttributes(param1:Dictionary) : void
		{
			var _loc3:* = undefined;
			var _loc2:uint = 0;
			for(_loc3 in this._resources)
			{
				_loc2 = _loc2 + this._resources[_loc3].memUsed;
			}
			param1["mem-bound"] = this._memBound;
			param1["mem-used"] = _loc2;
		}
	}
}
