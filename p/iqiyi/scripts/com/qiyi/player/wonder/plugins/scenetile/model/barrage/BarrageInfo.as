package com.qiyi.player.wonder.plugins.scenetile.model.barrage
{
	import flash.utils.ByteArray;
	
	public class BarrageInfo extends Object
	{
		
		private var _contentId:String = "";
		
		private var _showTime:int = 0;
		
		private var _content:String = "";
		
		private var _likes:int = 0;
		
		private var _userInfo:Object = null;
		
		private var _fontSize:uint = 30;
		
		private var _fontColor:String = "ffffff";
		
		private var _position:uint = 0;
		
		private var _contentType:uint = 0;
		
		private var _bgType:uint = 100;
		
		public function BarrageInfo()
		{
			super();
		}
		
		public function get userInfo() : Object
		{
			return this._userInfo;
		}
		
		public function get bgType() : uint
		{
			return this._bgType;
		}
		
		public function get contentType() : uint
		{
			return this._contentType;
		}
		
		public function get position() : uint
		{
			return this._position;
		}
		
		public function get fontColor() : String
		{
			return this._fontColor;
		}
		
		public function get fontSize() : uint
		{
			return this._fontSize;
		}
		
		public function get likes() : int
		{
			return this._likes;
		}
		
		public function get content() : String
		{
			return this._content;
		}
		
		public function get showTime() : int
		{
			return this._showTime;
		}
		
		public function get contentId() : String
		{
			return this._contentId;
		}
		
		public function update(param1:String, param2:int, param3:String, param4:int, param5:uint, param6:String, param7:uint, param8:uint, param9:uint, param10:Object = null) : void
		{
			this._content = param3;
			this._contentId = param1;
			this._likes = param4;
			this._showTime = param2;
			this._fontSize = param5;
			this._fontColor = param6;
			this._position = param7 > 3?0:param7;
			this._contentType = param8;
			this._bgType = param9;
			this._userInfo = param10;
		}
		
		public function clone() : BarrageInfo
		{
			var _loc1:ByteArray = new ByteArray();
			_loc1.writeObject(this);
			_loc1.position = 0;
			var _loc2:BarrageInfo = _loc1.readObject() as BarrageInfo;
			return _loc2;
		}
	}
}
