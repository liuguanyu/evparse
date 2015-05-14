package com.qiyi.player.core.model.impls
{
	import flash.events.EventDispatcher;
	import com.qiyi.player.core.model.IMovieInfo;
	import com.qiyi.player.core.IDestroy;
	import com.qiyi.player.core.model.impls.subtitle.Language;
	import com.qiyi.player.base.pub.EnumItem;
	import flash.utils.Timer;
	import com.qiyi.player.core.player.coreplayer.ICorePlayer;
	import com.qiyi.player.core.model.events.MovieEvent;
	import com.qiyi.player.base.utils.Utility;
	import com.qiyi.player.core.model.def.ChannelEnum;
	import com.adobe.serialization.json.JSON;
	import com.qiyi.player.core.model.def.LanguageEnum;
	
	public class MovieInfo extends EventDispatcher implements IMovieInfo, IDestroy
	{
		
		private var _info:String;
		
		private var _infoJSON:Object;
		
		private var _subtitles:Vector.<Language>;
		
		private var _chains:Array;
		
		private var _defaultSubtitle:Language;
		
		private var _focusTips:Vector.<FocusTip>;
		
		private var _channel:EnumItem;
		
		private var _pageUrl:String;
		
		private var _title:String;
		
		private var _albumName:String;
		
		private var _albumUrl:String;
		
		private var _source:String;
		
		private var _allSet:int;
		
		private var _allowDownload:Boolean;
		
		private var _nextUrl:String;
		
		private var _subTitle:String;
		
		private var _ptUrl:String;
		
		private var _isShare:Boolean;
		
		private var _isFullShare:Boolean;
		
		private var _qiyiProduced:Boolean;
		
		private var _putBarrage:Boolean;
		
		private var _ready:Boolean;
		
		private var _previewImageUrl:String;
		
		private var _timer:Timer;
		
		private var _pingBackFlag:Boolean;
		
		private var _holder:ICorePlayer;
		
		public function MovieInfo(param1:ICorePlayer)
		{
			super();
			this._ready = false;
			this._pingBackFlag = false;
			this._channel = ChannelEnum.NONE;
			this._pageUrl = "";
			this._ptUrl = "";
			this._title = "";
			this._albumName = "";
			this._albumUrl = "";
			this._nextUrl = "";
			this._subTitle = "";
			this._qiyiProduced = false;
			this._putBarrage = true;
			this._holder = param1;
		}
		
		public function get info() : String
		{
			return this._info;
		}
		
		public function get infoJSON() : Object
		{
			return this._infoJSON;
		}
		
		public function get share() : Boolean
		{
			return this._isShare;
		}
		
		public function get fullShare() : Boolean
		{
			return this._isFullShare;
		}
		
		public function get subtitles() : Vector.<Language>
		{
			return this._subtitles;
		}
		
		public function get subTitle() : String
		{
			return this._subTitle;
		}
		
		public function get chains() : Array
		{
			return this._chains;
		}
		
		public function get defaultSubtitle() : Language
		{
			return this._defaultSubtitle;
		}
		
		public function get focusTips() : Vector.<FocusTip>
		{
			return this._focusTips;
		}
		
		public function get channel() : EnumItem
		{
			return this._channel;
		}
		
		public function get pageUrl() : String
		{
			return this._pageUrl;
		}
		
		public function get ptUrl() : String
		{
			return this._ptUrl;
		}
		
		public function get title() : String
		{
			return this._title;
		}
		
		public function get albumName() : String
		{
			return this._albumName;
		}
		
		public function get albumUrl() : String
		{
			return this._albumUrl;
		}
		
		public function get allSet() : int
		{
			return this._allSet;
		}
		
		public function get allowDownload() : Boolean
		{
			return this._allowDownload;
		}
		
		public function get nextUrl() : String
		{
			return this._nextUrl;
		}
		
		public function get qiyiProduced() : Boolean
		{
			return this._qiyiProduced;
		}
		
		public function get putBarrage() : Boolean
		{
			return this._putBarrage;
		}
		
		public function get source() : String
		{
			return this._source;
		}
		
		public function get ready() : Boolean
		{
			return this._ready;
		}
		
		public function get previewImageUrl() : String
		{
			return this._previewImageUrl;
		}
		
		public function startInitByInfo(param1:Object) : void
		{
			if(param1)
			{
				this._infoJSON = param1;
				this.parse();
				this._ready = true;
				dispatchEvent(new MovieEvent(MovieEvent.Evt_Ready));
			}
		}
		
		private function parse() : void
		{
			var _loc4:Language = null;
			var _loc5:FocusTip = null;
			this._channel = Utility.getItemById(ChannelEnum.ITEMS,int(this._infoJSON.c));
			this._pageUrl = this._infoJSON.vu.toString();
			this._title = this._infoJSON.vn.toString();
			this._albumName = this._infoJSON.an.toString();
			this._albumUrl = this._infoJSON.au.toString();
			this._allSet = int(this._infoJSON.es.toString());
			this._nextUrl = this._infoJSON.nurl.toString();
			this._subTitle = this._infoJSON.subt.toString();
			this._isShare = int(this._infoJSON["is"]) == 1;
			this._isFullShare = int(this._infoJSON.ifs) == 1;
			this._ptUrl = this._infoJSON.pturl.toString();
			this._allowDownload = !(int(this._infoJSON.idl) == 0);
			this._source = this._infoJSON.hasOwnProperty("s")?this._infoJSON.s:"";
			this._previewImageUrl = this._infoJSON.hasOwnProperty("previewImageUrl")?this._infoJSON.previewImageUrl:"";
			if(this._infoJSON.hasOwnProperty("qiyiProduced"))
			{
				this._qiyiProduced = int(this._infoJSON.qiyiProduced) == 1;
			}
			if(this._infoJSON.hasOwnProperty("isPopup"))
			{
				this._putBarrage = int(this._infoJSON.isPopup) == 1;
			}
			else
			{
				this._putBarrage = true;
			}
			this._info = com.adobe.serialization.json.JSON.encode(this._infoJSON);
			this._subtitles = new Vector.<Language>();
			var _loc1:Array = this._infoJSON.stl.stl as Array;
			var _loc2:String = this._infoJSON.stl.d.toString();
			var _loc3:Object = null;
			for each(_loc3 in _loc1)
			{
				_loc4 = new Language();
				_loc4.isDefault = int(_loc3.pre) == 1;
				_loc4.url = _loc2 + _loc3.l.toString();
				_loc4.lang = Utility.getItemById(LanguageEnum.ITEMS,int(_loc3.lid));
				this._subtitles.push(_loc4);
				if(_loc4.isDefault)
				{
					this._defaultSubtitle = _loc4;
				}
			}
			this._focusTips = new Vector.<FocusTip>();
			_loc1 = this._infoJSON.fl as Array;
			for each(_loc3 in _loc1)
			{
				_loc5 = new FocusTip();
				_loc5.index = this._focusTips.length;
				_loc5.timestamp = Number(_loc3.t.toString()) * 1000;
				_loc5.content = _loc3.c.toString();
				this._focusTips.push(_loc5);
			}
			if(this._infoJSON.tpl is Array)
			{
				this._chains = this._infoJSON.tpl;
			}
		}
		
		public function destroy() : void
		{
			this._info = null;
			this._infoJSON = null;
			this._channel = ChannelEnum.NONE;
			this._subtitles = null;
			this._chains = null;
			this._defaultSubtitle = null;
			this._focusTips = null;
			this._ready = false;
			this._pingBackFlag = false;
			this._holder = null;
		}
	}
}
