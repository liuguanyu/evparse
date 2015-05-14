package com.qiyi.player.wonder.plugins.continueplay.model
{
	import com.qiyi.player.core.player.LoadMovieParams;
	import com.qiyi.player.wonder.common.config.FlashVarConfig;
	
	public class ContinueInfo extends Object
	{
		
		private var _loadMovieParams:LoadMovieParams;
		
		private var _playCount:int = 0;
		
		private var _isPlaging:Boolean = false;
		
		private var _imageURL:String = "";
		
		private var _title:String = "";
		
		private var _describe:String = "";
		
		private var _curSet:int = 1;
		
		private var _cupId:String;
		
		private var _index:int = 0;
		
		private var _isAdVideo:Boolean = false;
		
		private var _publishTime:String = "";
		
		private var _channelID:uint = 0;
		
		private var _exclusive:String = "";
		
		private var _qiyiProduced:String = "";
		
		private var _vfrm:String = "";
		
		public function ContinueInfo()
		{
			this._cupId = FlashVarConfig.cupId;
			super();
			this._loadMovieParams = new LoadMovieParams();
		}
		
		public function get qiyiProduced() : String
		{
			return this._qiyiProduced;
		}
		
		public function set qiyiProduced(param1:String) : void
		{
			this._qiyiProduced = param1;
		}
		
		public function get vfrm() : String
		{
			return this._vfrm;
		}
		
		public function set vfrm(param1:String) : void
		{
			this._vfrm = param1;
		}
		
		public function get exclusive() : String
		{
			return this._exclusive;
		}
		
		public function set exclusive(param1:String) : void
		{
			this._exclusive = param1;
		}
		
		public function get publishTime() : String
		{
			return this._publishTime;
		}
		
		public function set publishTime(param1:String) : void
		{
			this._publishTime = param1;
		}
		
		public function get loadMovieParams() : LoadMovieParams
		{
			return this._loadMovieParams;
		}
		
		public function get playCount() : int
		{
			return this._playCount;
		}
		
		public function get isPlaging() : Boolean
		{
			return this._isPlaging;
		}
		
		public function set isPlaging(param1:Boolean) : void
		{
			this._isPlaging = param1;
		}
		
		public function get imageURL() : String
		{
			return this._imageURL;
		}
		
		public function set imageURL(param1:String) : void
		{
			this._imageURL = param1;
		}
		
		public function get title() : String
		{
			return this._title;
		}
		
		public function set title(param1:String) : void
		{
			this._title = param1;
		}
		
		public function get describe() : String
		{
			return this._describe;
		}
		
		public function set describe(param1:String) : void
		{
			this._describe = param1;
		}
		
		public function get curSet() : int
		{
			return this._curSet;
		}
		
		public function set curSet(param1:int) : void
		{
			this._curSet = param1;
		}
		
		public function get cupId() : String
		{
			return this._cupId;
		}
		
		public function set cupId(param1:String) : void
		{
			if(param1 == null || param1 == "")
			{
				this._cupId = FlashVarConfig.cupId;
			}
			else
			{
				this._cupId = param1;
			}
		}
		
		public function get index() : int
		{
			return this._index;
		}
		
		public function set index(param1:int) : void
		{
			this._index = param1;
		}
		
		public function get isAdVideo() : Boolean
		{
			return this._isAdVideo;
		}
		
		public function set isAdVideo(param1:Boolean) : void
		{
			this._isAdVideo = param1;
		}
		
		public function addPlayCount() : void
		{
			this._playCount++;
		}
		
		public function get channelID() : uint
		{
			return this._channelID;
		}
		
		public function set channelID(param1:uint) : void
		{
			this._channelID = param1;
		}
	}
}
