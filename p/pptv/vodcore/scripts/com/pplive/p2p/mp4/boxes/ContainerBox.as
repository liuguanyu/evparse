package com.pplive.p2p.mp4.boxes
{
	import flash.utils.ByteArray;
	
	public class ContainerBox extends Box
	{
		
		public var subBoxes:Vector.<Box>;
		
		public function ContainerBox()
		{
			this.subBoxes = new Vector.<Box>();
			super();
		}
		
		override public function parse(param1:ByteArray, param2:uint) : void
		{
			var _loc3:Box = null;
			while(param1.position < param2)
			{
				_loc3 = parseBox(param1,param2);
				if(_loc3 == null)
				{
					throw new InvalidBoxError();
				}
				else
				{
					this.subBoxes.push(_loc3);
					continue;
				}
			}
		}
		
		public function getChild(param1:String) : Box
		{
			var _loc2:Box = null;
			for each(_loc2 in this.subBoxes)
			{
				if(_loc2.type == param1)
				{
					return _loc2;
				}
			}
			return null;
		}
		
		public function getDescendant(param1:Array) : Box
		{
			var _loc3:String = null;
			var _loc2:Box = this;
			while(true)
			{
				for each(_loc3 in param1)
				{
					if(!(_loc2 is ContainerBox))
					{
						break;
					}
					_loc2 = (_loc2 as ContainerBox).getChild(_loc3);
					if(_loc2 != null)
					{
						continue;
					}
					return _loc2;
				}
			}
			return null;
		}
	}
}
