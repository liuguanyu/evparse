package com.qiyi.player.user {
	public interface IUser {
		
		function get passportID() : String;
		
		function get P00001() : String;
		
		function get profileID() : String;
		
		function get profileCookie() : String;
		
		function get nickName() : String;
		
		function get id() : String;
		
		function get type() : int;
		
		function get level() : int;
		
		function get limitationType() : int;
		
		function set tvid(param1:String) : void;
		
		function openHeartBeat() : void;
		
		function closeHeartBeat() : void;
	}
}
