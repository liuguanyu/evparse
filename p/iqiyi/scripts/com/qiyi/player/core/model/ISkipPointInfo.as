package com.qiyi.player.core.model {
	import com.qiyi.player.base.pub.EnumItem;
	
	public interface ISkipPointInfo {
		
		function get startTime() : int;
		
		function get endTime() : int;
		
		function get skipPointType() : EnumItem;
	}
}
