package com.qiyi.player.core.player
{
	import flash.events.IEventDispatcher;
	import com.qiyi.player.core.IDestroy;
	import com.qiyi.player.core.model.IReadStatus;
	import flash.display.Sprite;
	import com.qiyi.player.core.view.ILayer;
	import com.qiyi.player.core.model.IStrategy;
	import com.qiyi.player.core.model.IMovieModel;
	import com.qiyi.player.core.model.IMovieInfo;
	import com.qiyi.player.base.pub.EnumItem;
	import flash.geom.Rectangle;
	import com.qiyi.player.core.video.engine.dm.provider.MediaData;
	
	public interface IPlayer extends IEventDispatcher, IDestroy, IReadStatus
	{
		
		function initialize(param1:Sprite, param2:Boolean = true) : void;
		
		function get isPreload() : Boolean;
		
		function set isPreload(param1:Boolean) : void;
		
		function get layer() : ILayer;
		
		function get strategy() : IStrategy;
		
		function set needFilterQualityDefinition(param1:Boolean) : void;
		
		function get needFilterQualityDefinition() : Boolean;
		
		function get uuid() : String;
		
		function get videoEventID() : String;
		
		function set visits(param1:String) : void;
		
		function get movieModel() : IMovieModel;
		
		function get movieInfo() : IMovieInfo;
		
		function get errorCode() : int;
		
		function get errorCodeValue() : Object;
		
		function get authenticationResult() : Object;
		
		function get authenticationError() : Boolean;
		
		function get authenticationTipType() : int;
		
		function get accStatus() : EnumItem;
		
		function get status() : EnumItem;
		
		function get currentTime() : int;
		
		function get bufferTime() : int;
		
		function get loadComplete() : Boolean;
		
		function get currentSpeed() : int;
		
		function get currentAverageSpeed() : int;
		
		function get playingDuration() : int;
		
		function get waitingDuration() : int;
		
		function get stopReason() : EnumItem;
		
		function get isTryWatch() : Boolean;
		
		function get tryWatchType() : EnumItem;
		
		function get tryWatchTime() : int;
		
		function get frameRate() : int;
		
		function get settingArea() : Rectangle;
		
		function get realArea() : Rectangle;
		
		function set autoDefinitionlimit(param1:EnumItem) : void;
		
		function get openSelectPlay() : Boolean;
		
		function set openSelectPlay(param1:Boolean) : void;
		
		function set pbSource(param1:String) : void;
		
		function set pbCoop(param1:String) : void;
		
		function set pbPlayListID(param1:String) : void;
		
		function set pbVVFrom(param1:String) : void;
		
		function set pbVFrm(param1:String) : void;
		
		function set pbVVFromtp(param1:String) : void;
		
		function set pbVfm(param1:String) : void;
		
		function set pbSrc(param1:String) : void;
		
		function set pbOpenBarrage(param1:Boolean) : void;
		
		function set pbIsStarBarrage(param1:Boolean) : void;
		
		function set smallWindowMode(param1:Boolean) : void;
		
		function get VInfoDisIP() : String;
		
		function set ugcAuthKey(param1:String) : void;
		
		function set thdKey(param1:String) : void;
		
		function set thdToken(param1:String) : void;
		
		function get serverTime() : uint;
		
		function loadMovie(param1:LoadMovieParams) : void;
		
		function startLoad() : void;
		
		function stopLoad() : void;
		
		function play() : void;
		
		function pause(param1:int = 0) : void;
		
		function resume() : void;
		
		function seek(param1:uint, param2:int = 0) : void;
		
		function replay() : void;
		
		function refresh() : void;
		
		function clearSurface() : void;
		
		function stop() : void;
		
		function setArea(param1:int, param2:int, param3:int, param4:int) : void;
		
		function setPuman(param1:Boolean) : void;
		
		function setZoom(param1:int) : void;
		
		function setEnjoyableSubType(param1:EnumItem, param2:int = -1) : void;
		
		function sequenceReadDataFrom(param1:int) : MediaData;
		
		function startLoadMeta() : void;
		
		function startLoadHistory() : void;
		
		function startLoadP2PCore() : void;
		
		function setADRemainTime(param1:int) : void;
		
		function getCaptureURL(param1:Number = -1, param2:int = 1) : String;
	}
}
