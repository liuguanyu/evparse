package com.qiyi.player.core.model.utils
{
	import com.qiyi.player.base.pub.EnumItem;
	import com.qiyi.player.core.player.coreplayer.ICorePlayer;
	import com.qiyi.player.core.model.impls.pub.Settings;
	import com.qiyi.player.core.model.def.DefinitionEnum;
	
	public class DefinitionUtils extends Object
	{
		
		private static var _definitionFilterList:Vector.<EnumItem> = null;
		
		public function DefinitionUtils()
		{
			super();
		}
		
		public static function getCurrentDefinition(param1:ICorePlayer) : EnumItem
		{
			var _loc2:EnumItem = Settings.instance.autoMatchRate?Settings.instance.detectedRate:Settings.instance.definition;
			if(param1.runtimeData.CDNStatus != 0)
			{
				if(param1.runtimeData.CDNStatus == 3)
				{
					_loc2 = DefinitionEnum.STANDARD;
				}
				else if(param1.runtimeData.CDNStatus == 4)
				{
					_loc2 = DefinitionEnum.LIMIT;
				}
				else if(Settings.instance.definition == DefinitionEnum.NONE || (Settings.instance.autoMatchRate))
				{
					if(param1.runtimeData.CDNStatus == 1)
					{
						_loc2 = DefinitionEnum.STANDARD;
					}
					else if(param1.runtimeData.CDNStatus == 2)
					{
						_loc2 = DefinitionEnum.LIMIT;
					}
					
				}
				
				
			}
			return _loc2;
		}
		
		public static function setDefinitionFilterList(param1:Vector.<EnumItem>) : void
		{
			_definitionFilterList = param1;
		}
		
		public static function inFilterPPByDefinitionID(param1:int) : Boolean
		{
			var _loc2:* = 0;
			if(_definitionFilterList)
			{
				_loc2 = 0;
				while(_loc2 < _definitionFilterList.length)
				{
					if(_definitionFilterList[_loc2].id == param1)
					{
						return true;
					}
					_loc2++;
				}
				return false;
			}
			return param1 == DefinitionEnum.SUPER_HIGH.id || param1 == DefinitionEnum.FULL_HD.id || param1 == DefinitionEnum.FOUR_K.id;
		}
	}
}
