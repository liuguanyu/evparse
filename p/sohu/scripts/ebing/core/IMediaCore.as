package ebing.core {
	public interface IMediaCore {
		
		function hardInit(param1:Object) : void;
		
		function softInit(param1:Object) : void;
		
		function resize(param1:Number, param2:Number) : void;
		
		function play(param1:* = null) : void;
		
		function stop(param1:* = null) : void;
		
		function sleep(param1:* = null) : void;
		
		function pause(param1:* = null) : void;
		
		function seek(param1:Number) : void;
		
		function playOrPause(param1:* = null) : void;
		
		function get filePlayedTime() : Number;
		
		function get fileTotTime() : Number;
		
		function get fileLoadedSize() : Number;
		
		function get fileTotSize() : Number;
		
		function get volume() : Number;
		
		function set volume(param1:Number) : void;
	}
}
