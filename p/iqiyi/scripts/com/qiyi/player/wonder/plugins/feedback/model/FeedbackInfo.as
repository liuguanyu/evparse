package com.qiyi.player.wonder.plugins.feedback.model
{
	public class FeedbackInfo extends Object
	{
		
		private static var _instance:FeedbackInfo;
		
		private var _entry:String = "";
		
		private var _vid:String = "";
		
		private var _title:String = "";
		
		private var _volume:uint = 0;
		
		private var _logCookie:String = "";
		
		private var _playerVersion:String = "";
		
		private var _channelId:String = "";
		
		private var _userInfo:Object = null;
		
		private var _country:String = "";
		
		private var _city:String = "";
		
		private var _ip:String = "";
		
		private var _isp:String = "";
		
		private var _ticket:String = "";
		
		public function FeedbackInfo()
		{
			super();
		}
		
		public static function get instance() : FeedbackInfo
		{
			return _instance = _instance || new FeedbackInfo();
		}
		
		public function get ticket() : String
		{
			return this._ticket;
		}
		
		public function set ticket(param1:String) : void
		{
			this._ticket = param1;
		}
		
		public function get userInfo() : Object
		{
			return this._userInfo;
		}
		
		public function set userInfo(param1:Object) : void
		{
			this._ip = param1.data.ip;
			this._country = param1.data.country;
			this._city = param1.data.city;
			this._isp = param1.data.isp;
			this._userInfo = param1;
		}
		
		public function updataVideoInfo(param1:String, param2:String, param3:String, param4:uint, param5:String, param6:String, param7:String) : void
		{
			this._entry = param1;
			this._vid = param2;
			this._title = param3;
			this._volume = param4;
			this._logCookie = param5;
			this._playerVersion = param6;
			this._channelId = param7;
		}
		
		public function get isp() : String
		{
			return this._isp;
		}
		
		public function get ip() : String
		{
			return this._ip;
		}
		
		public function get city() : String
		{
			return this._city;
		}
		
		public function get country() : String
		{
			return this._country;
		}
		
		public function get channelId() : String
		{
			return this._channelId;
		}
		
		public function get playerVersion() : String
		{
			return this._playerVersion;
		}
		
		public function get logCookie() : String
		{
			return this._logCookie;
		}
		
		public function get volume() : uint
		{
			return this._volume;
		}
		
		public function get title() : String
		{
			return this._title;
		}
		
		public function get vid() : String
		{
			return this._vid;
		}
		
		public function get entry() : String
		{
			return this._entry;
		}
	}
}
