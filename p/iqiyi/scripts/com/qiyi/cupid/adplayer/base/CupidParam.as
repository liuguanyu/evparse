package com.qiyi.cupid.adplayer.base
{
	import flash.events.IEventDispatcher;
	import flash.display.DisplayObjectContainer;
	
	public class CupidParam extends Object
	{
		
		public var videoPlayerVersion:String;
		
		public var playerUrl:String;
		
		public var videoId:String;
		
		public var tvId:String;
		
		public var channelId:int;
		
		public var collectionId:String;
		
		public var playerId:String;
		
		public var albumId:String;
		
		public var dispatcher:IEventDispatcher;
		
		public var cacheMachineIp:String;
		
		public var adContainer:DisplayObjectContainer;
		
		public var stageWidth:Number;
		
		public var stageHeight:Number;
		
		public var userId:String = "";
		
		public var webEventId:String = "";
		
		public var videoEventId:String = "";
		
		public var vipRight:String = "0";
		
		public var terminal:String = "";
		
		public var duration:Number = 0;
		
		public var passportId:String = "";
		
		public var passportCookie:String = "";
		
		public var videoDefinitionId:Number = 0;
		
		public var passportKey:String = "";
		
		public var baiduMainVideo:String = "1";
		
		public var disablePreroll:Boolean = false;
		
		public var disableSkipAd:Boolean = false;
		
		public var enableVideoCore:Boolean = false;
		
		public var volume:Number = 80;
		
		public var videoIndex:int;
		
		public var isUGC:Boolean = false;
		
		public var couponCode:String;
		
		public var couponVer:String;
		
		public var videoPlaySecondsOfDay:int;
		
		public function CupidParam()
		{
			super();
		}
		
		public function toObject() : Object
		{
			var _loc1:* = "videoPlayerVersion playerUrl videoId tvId channelId collectionId " + "playerId albumId adContainer stageWidth stageHeight userId webEventId dispatcher " + "cacheMachineIp videoEventId vipRight terminal duration passportId passportCookie " + "videoDefinitionId passportKey baiduMainVideo disablePreroll disableSkipAd " + "enableVideoCore volume videoIndex isUGC couponCode couponVer videoPlaySecondsOfDay";
			var _loc2:Object = {};
			var _loc3:Array = _loc1.split(" ");
			var _loc4:* = 0;
			while(_loc4 < _loc3.length)
			{
				_loc2[_loc3[_loc4]] = this[_loc3[_loc4]] + "";
				_loc4++;
			}
			return _loc2;
		}
	}
}
