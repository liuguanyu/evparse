package com.qiyi.player.core.model.utils {
	import com.qiyi.player.base.pub.EnumItem;
	import com.qiyi.player.core.player.coreplayer.ICorePlayer;
	import com.qiyi.player.core.model.impls.pub.Settings;
	import com.qiyi.player.core.model.def.DefinitionEnum;
	
	public class DefinitionUtils extends Object {
		
		public function DefinitionUtils() {
			super();
		}
		
		private static var _definitionFilterList:Vector.<EnumItem> = null;
		
		public static function getCurrentDefinition(param1:ICorePlayer) : EnumItem {
			var _loc2_:EnumItem = Settings.instance.autoMatchRate?Settings.instance.detectedRate:Settings.instance.definition;
			if(param1.runtimeData.CDNStatus != 0) {
				if(param1.runtimeData.CDNStatus == 3) {
					_loc2_ = DefinitionEnum.STANDARD;
				} else if(param1.runtimeData.CDNStatus == 4) {
					_loc2_ = DefinitionEnum.LIMIT;
				} else if(Settings.instance.definition == DefinitionEnum.NONE || (Settings.instance.autoMatchRate)) {
					if(param1.runtimeData.CDNStatus == 1) {
						_loc2_ = DefinitionEnum.STANDARD;
					} else if(param1.runtimeData.CDNStatus == 2) {
						_loc2_ = DefinitionEnum.LIMIT;
					}
					
				}
				
				
			}
			return _loc2_;
		}
		
		public static function setDefinitionFilterList(param1:Vector.<EnumItem>) : void {
			_definitionFilterList = param1;
		}
		
		public static function inFilterPPByDefinitionID(param1:int) : Boolean {
			var _loc2_:* = 0;
			if(_definitionFilterList) {
				_loc2_ = 0;
				while(_loc2_ < _definitionFilterList.length) {
					if(_definitionFilterList[_loc2_].id == param1) {
						return true;
					}
					_loc2_++;
				}
				return false;
			}
			return param1 == DefinitionEnum.SUPER_HIGH.id || param1 == DefinitionEnum.FULL_HD.id || param1 == DefinitionEnum.FOUR_K.id;
		}
	}
}
