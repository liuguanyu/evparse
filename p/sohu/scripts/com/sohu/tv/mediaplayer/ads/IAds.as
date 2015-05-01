package com.sohu.tv.mediaplayer.ads {
	public interface IAds {
		
		function play() : void;
		
		function destroy() : void;
		
		function get state() : String;
	}
}
