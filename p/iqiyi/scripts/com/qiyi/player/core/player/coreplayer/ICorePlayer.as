package com.qiyi.player.core.player.coreplayer
{
	import com.qiyi.player.core.player.IPlayer;
	import com.qiyi.player.core.model.IWriteStatus;
	import com.qiyi.player.core.model.IMovie;
	import com.qiyi.player.core.history.History;
	import com.qiyi.player.core.player.RuntimeData;
	import com.qiyi.player.core.model.utils.PingBack;
	import flash.net.NetStreamInfo;
	
	public interface ICorePlayer extends IPlayer, IWriteStatus
	{
		
		function get movie() : IMovie;
		
		function get history() : History;
		
		function get runtimeData() : RuntimeData;
		
		function get pingBack() : PingBack;
		
		function get decoderInfo() : NetStreamInfo;
	}
}
