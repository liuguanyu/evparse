package com.qiyi.player.base.p2p {
	public interface ISegment {
		
		function get url() : String;
		
		function get totalBytes() : Number;
		
		function get totalTime() : Number;
	}
}
