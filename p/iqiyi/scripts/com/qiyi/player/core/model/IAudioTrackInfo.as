package com.qiyi.player.core.model {
	import com.qiyi.player.base.pub.EnumItem;
	
	public interface IAudioTrackInfo {
		
		function get isDefault() : Boolean;
		
		function get type() : EnumItem;
		
		function get definitionCount() : int;
		
		function findDefinitionInfoAt(param1:int) : IDefinitionInfo;
		
		function findDefinitionInfoByType(param1:EnumItem, param2:Boolean = false) : IDefinitionInfo;
	}
}
