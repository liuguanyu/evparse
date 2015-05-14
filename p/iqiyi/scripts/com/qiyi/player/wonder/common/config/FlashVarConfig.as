package com.qiyi.player.wonder.common.config
{
	public class FlashVarConfig extends Object
	{
		
		public static const OWNER_PAGE:String = "page";
		
		public static const OWNER_CLIENT:String = "client";
		
		public static const OS_XP:String = "xp";
		
		public static const OS_WIN7:String = "win7";
		
		public static const OS_WIN8:String = "win8";
		
		public static const PAGE_OPEN_SRC_NONE:String = "0";
		
		public static const PAGE_OPEN_SRC_DIRECT:String = "1";
		
		public static const PAGE_OPEN_SRC_OTHER:String = "2";
		
		private static var _flashVarSource:Object;
		
		private static var _albumId:String = "";
		
		private static var _tvid:String = "0";
		
		private static var _vid:String = "";
		
		private static var _autoPlay:Boolean = true;
		
		private static var _isMemberMovie:Boolean = false;
		
		private static var _cyclePlay:Boolean = false;
		
		private static var _components:String = "fefff7e6";
		
		private static var _cupId:String = "";
		
		private static var _shareStartTime:int = -1;
		
		private static var _shareEndTime:int = -1;
		
		private static var _preloaderURL:String = "http://dispatcher.video.qiyi.com/dispn/player/preloader.swf";
		
		private static var _preloaderVipURL:String = "";
		
		private static var _exclusivePreloader:String = "";
		
		private static var _qiyiProducedPreloader:String = "";
		
		private static var _useGPU:Boolean = true;
		
		private static var _showBrand:Boolean = true;
		
		private static var _expandState:Boolean = false;
		
		private static var _tipDataURL:String = "http://static.qiyi.com/ext/tips/tipdata.xml";
		
		private static var _coop:String = "";
		
		private static var _owner:String = OWNER_PAGE;
		
		private static var _os:String = OS_WIN7;
		
		private static var _adPlayerURL:String = "";
		
		private static var _origin:String = "";
		
		private static var _passportID:String = "";
		
		private static var _playListID:String = "";
		
		private static var _isFloatPlayer:String = "";
		
		private static var _isheadmap:String = "";
		
		private static var _videoFrom:String = "";
		
		private static var _P00001:String = "";
		
		private static var _profileID:String = "";
		
		private static var _profileCookie:String = "";
		
		private static var _pageOpenSrc:String = PAGE_OPEN_SRC_NONE;
		
		private static var _outsite:Boolean = false;
		
		private static var _collectionID:String = "";
		
		private static var _imageUrl:String = "";
		
		private static var _exclusive:String = "";
		
		private static var _qiyiProduced:String = "";
		
		private static var _vfrm:String = "";
		
		private static var _webEventID:String = "";
		
		private static var _putBarrage:Boolean = true;
		
		private static var _openBarrage:Boolean = false;
		
		private static var _pageCTime:Number = 0;
		
		private static var _couponCode:String = "";
		
		private static var _couponVer:String = "";
		
		public function FlashVarConfig()
		{
			super();
		}
		
		public static function get couponCode() : String
		{
			return _couponCode;
		}
		
		public static function get couponVer() : String
		{
			return _couponVer;
		}
		
		public static function get pageCTime() : Number
		{
			return _pageCTime;
		}
		
		public static function get putBarrage() : Boolean
		{
			return _putBarrage;
		}
		
		public static function get openBarrage() : Boolean
		{
			return _openBarrage;
		}
		
		public static function get webEventID() : String
		{
			return _webEventID;
		}
		
		public static function get vfrm() : String
		{
			return _vfrm;
		}
		
		public static function get qiyiProduced() : String
		{
			return _qiyiProduced;
		}
		
		public static function get qiyiProducedPreloader() : String
		{
			return _qiyiProducedPreloader;
		}
		
		public static function get exclusive() : String
		{
			return _exclusive;
		}
		
		public static function get exclusivePreloader() : String
		{
			return _exclusivePreloader;
		}
		
		public static function get imageUrl() : String
		{
			return _imageUrl;
		}
		
		public static function get collectionID() : String
		{
			return _collectionID;
		}
		
		public static function get isheadmap() : String
		{
			return _isheadmap;
		}
		
		public static function get pageOpenSrc() : String
		{
			return _pageOpenSrc;
		}
		
		public static function set isheadmap(param1:String) : void
		{
			_isheadmap = param1;
		}
		
		public static function get isFloatPlayer() : String
		{
			return _isFloatPlayer;
		}
		
		public static function get playListID() : String
		{
			return _playListID;
		}
		
		public static function get videoFrom() : String
		{
			return _videoFrom;
		}
		
		public static function get flashVarSource() : Object
		{
			return _flashVarSource;
		}
		
		public static function get albumId() : String
		{
			return _albumId;
		}
		
		public static function get tvid() : String
		{
			return _tvid;
		}
		
		public static function get vid() : String
		{
			return _vid;
		}
		
		public static function get autoPlay() : Boolean
		{
			return _autoPlay;
		}
		
		public static function get isMemberMovie() : Boolean
		{
			return _isMemberMovie;
		}
		
		public static function get cyclePlay() : Boolean
		{
			return _cyclePlay;
		}
		
		public static function get components() : String
		{
			return _components;
		}
		
		public static function get cupId() : String
		{
			return _cupId;
		}
		
		public static function get shareStartTime() : int
		{
			return _shareStartTime;
		}
		
		public static function get shareEndTime() : int
		{
			return _shareEndTime;
		}
		
		public static function get preloaderURL() : String
		{
			return _preloaderURL;
		}
		
		public static function get preloaderVipURL() : String
		{
			return _preloaderVipURL;
		}
		
		public static function get useGPU() : Boolean
		{
			return _useGPU;
		}
		
		public static function get showBrand() : Boolean
		{
			return _showBrand;
		}
		
		public static function get expandState() : Boolean
		{
			return _expandState;
		}
		
		public static function get tipDataURL() : String
		{
			return _tipDataURL;
		}
		
		public static function get coop() : String
		{
			return _coop;
		}
		
		public static function get owner() : String
		{
			return _owner;
		}
		
		public static function get os() : String
		{
			return _os;
		}
		
		public static function get adPlayerURL() : String
		{
			return _adPlayerURL;
		}
		
		public static function get origin() : String
		{
			return _origin;
		}
		
		public static function get passportID() : String
		{
			return _passportID;
		}
		
		public static function get P00001() : String
		{
			return _P00001;
		}
		
		public static function get profileID() : String
		{
			return _profileID;
		}
		
		public static function get profileCookie() : String
		{
			return _profileCookie;
		}
		
		public static function get outsite() : Boolean
		{
			return _outsite;
		}
		
		public static function init(param1:Object) : void
		{
			if(param1)
			{
				if(param1.hasOwnProperty("cpnc"))
				{
					_couponCode = param1.cpnc;
				}
				if(param1.hasOwnProperty("cpnv"))
				{
					_couponVer = param1.cpnv;
				}
				if(param1.hasOwnProperty("outsite"))
				{
					_outsite = param1.outsite == "true";
				}
				if(param1.hasOwnProperty("albumId"))
				{
					_albumId = param1.albumId;
				}
				if(param1.hasOwnProperty("tvId"))
				{
					_tvid = param1.tvId;
				}
				if(param1.hasOwnProperty("definitionID"))
				{
					_vid = param1.definitionID;
				}
				if(param1.hasOwnProperty("autoplay"))
				{
					_autoPlay = param1.autoplay == "true";
				}
				if(param1.hasOwnProperty("isMember"))
				{
					_isMemberMovie = param1.isMember == "true";
				}
				if(param1.hasOwnProperty("cyclePlay"))
				{
					_cyclePlay = param1.cyclePlay == "true";
				}
				if(param1.hasOwnProperty("components"))
				{
					_components = param1.components;
				}
				if(param1.hasOwnProperty("cid"))
				{
					_cupId = param1.cid;
				}
				if(param1.hasOwnProperty("share_sTime"))
				{
					if(int(param1.share_sTime) >= 0)
					{
						_shareStartTime = int(param1.share_sTime) * 1000;
					}
				}
				if(param1.hasOwnProperty("share_eTime"))
				{
					if(int(param1.share_eTime) > 0)
					{
						_shareEndTime = int(param1.share_eTime) * 1000;
					}
				}
				if(param1.hasOwnProperty("preloader"))
				{
					_preloaderURL = param1.preloader;
				}
				if(param1.hasOwnProperty("vipPreloader"))
				{
					_preloaderVipURL = param1.vipPreloader;
				}
				if(param1.hasOwnProperty("gpu"))
				{
					_useGPU = param1.gpu == "true";
				}
				if(param1.hasOwnProperty("showBrand"))
				{
					_showBrand = param1.showBrand == "true";
				}
				if(param1.hasOwnProperty("expandState"))
				{
					_expandState = param1.expandState == "true";
				}
				if(param1.hasOwnProperty("tipdataurl"))
				{
					_tipDataURL = param1.tipdataurl;
				}
				if(param1.hasOwnProperty("coop"))
				{
					_coop = param1.coop;
				}
				if(param1.hasOwnProperty("owner"))
				{
					_owner = param1.owner;
				}
				if(param1.hasOwnProperty("os"))
				{
					_os = param1.os;
				}
				if(param1.hasOwnProperty("adurl"))
				{
					_adPlayerURL = param1.adurl;
				}
				if(param1.hasOwnProperty("origin"))
				{
					_origin = param1.origin;
				}
				if(param1.hasOwnProperty("passportID"))
				{
					_passportID = param1.passportID;
				}
				if(param1.hasOwnProperty("videoIsFromQidan"))
				{
					_videoFrom = param1.videoIsFromQidan;
				}
				if(param1.hasOwnProperty("playListID"))
				{
					_playListID = param1.playListID;
				}
				if(param1.hasOwnProperty("P00001"))
				{
					_P00001 = param1.P00001;
				}
				if(param1.hasOwnProperty("profileID"))
				{
					_profileID = param1.profileID;
				}
				if(param1.hasOwnProperty("profileCookie"))
				{
					_profileCookie = param1.profileCookie;
				}
				if(param1.hasOwnProperty("isFloatPlayer"))
				{
					_isFloatPlayer = param1.isFloatPlayer;
				}
				if(param1.hasOwnProperty("pageOpenSrc"))
				{
					_pageOpenSrc = param1.pageOpenSrc;
				}
				if(param1.hasOwnProperty("isheadmap"))
				{
					_isheadmap = param1.isheadmap;
				}
				if(param1.hasOwnProperty("collectionID"))
				{
					_collectionID = param1.collectionID;
				}
				if(param1.hasOwnProperty("imageUrl"))
				{
					_imageUrl = param1.imageUrl;
				}
				if(param1.hasOwnProperty("qiyiProduced"))
				{
					_qiyiProduced = param1.qiyiProduced;
				}
				if(param1.hasOwnProperty("qiyiProducedPreloader"))
				{
					_qiyiProducedPreloader = param1.qiyiProducedPreloader;
				}
				if(param1.hasOwnProperty("exclusive"))
				{
					_exclusive = param1.exclusive;
				}
				if(param1.hasOwnProperty("exclusivePreloader"))
				{
					_exclusivePreloader = param1.exclusivePreloader;
				}
				if(param1.hasOwnProperty("vfrm"))
				{
					_vfrm = param1.vfrm;
				}
				if(param1.hasOwnProperty("webEventID"))
				{
					_webEventID = param1.webEventID;
				}
				if(param1.hasOwnProperty("putbarrage"))
				{
					_putBarrage = int(param1.putbarrage) == 1?true:false;
				}
				if(param1.hasOwnProperty("openbarrage"))
				{
					_openBarrage = int(param1.openbarrage) == 1?true:false;
				}
				if(param1.hasOwnProperty("pageCTime"))
				{
					_pageCTime = Number(param1.pageCTime);
				}
				_flashVarSource = param1;
				if(_profileID == "" && !(_passportID == ""))
				{
					_profileID = _passportID;
				}
			}
		}
	}
}
