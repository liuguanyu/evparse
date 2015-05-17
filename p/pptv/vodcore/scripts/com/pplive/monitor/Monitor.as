package com.pplive.monitor
{
	import flash.utils.Dictionary;
	
	public class Monitor extends Object
	{
		
		public static var root:Monitor = new Monitor("monitor",null);
		
		protected var _name:String;
		
		protected var _monitable:IMonitable;
		
		protected var _monitedAttrs:Dictionary;
		
		protected var _children:Array;
		
		public function Monitor(param1:String, param2:IMonitable)
		{
			this._monitedAttrs = new Dictionary();
			this._children = new Array();
			super();
			this._name = param1;
			this._monitable = param2;
		}
		
		public function addChild(param1:Monitor) : void
		{
			if(this._children.indexOf(param1) < 0)
			{
				this._children.push(param1);
			}
		}
		
		public function removeChild(param1:Monitor) : void
		{
			var _loc2:int = this._children.indexOf(param1);
			if(_loc2 >= 0)
			{
				this._children.splice(_loc2,1);
			}
		}
		
		public function setAttr(param1:String, param2:*) : void
		{
			this._monitedAttrs[param1] = param2;
		}
		
		public function getAttr(param1:String) : *
		{
			return this._monitedAttrs[param1];
		}
		
		public function delAttr(param1:String) : void
		{
			delete this._monitedAttrs[param1];
			true;
		}
		
		public function getMonitedInfoInXML() : XML
		{
			var _loc2:* = undefined;
			var _loc3:uint = 0;
			var _loc4:uint = 0;
			var _loc1:XML = new XML("<" + this._name + "/>");
			if(this._monitable)
			{
				this._monitable.updateMonitedAttributes(this._monitedAttrs);
			}
			for(_loc2 in this._monitedAttrs)
			{
				_loc1["@" + _loc2] = this._monitedAttrs[_loc2] == null?"":this._monitedAttrs[_loc2].toString();
			}
			_loc3 = 0;
			_loc4 = this._children.length;
			while(_loc3 < _loc4)
			{
				_loc1.appendChild(this._children[_loc3].getMonitedInfoInXML());
				_loc3++;
			}
			return _loc1;
		}
	}
}
