package com.qiyi.player.wonder.common.sw {
	public interface ISwitch {
		
		function getSwitchID() : Vector.<int>;
		
		function onSwitchStatusChanged(param1:int, param2:Boolean) : void;
	}
}
