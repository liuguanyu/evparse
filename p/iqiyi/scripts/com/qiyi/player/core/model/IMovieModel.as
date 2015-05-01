package com.qiyi.player.core.model {
	import com.qiyi.player.base.pub.EnumItem;
	import com.qiyi.player.core.model.impls.Keyframe;
	import com.qiyi.player.core.model.impls.ScreenInfo;
	
	public interface IMovieModel {
		
		function get curAudioTrackInfo() : IAudioTrackInfo;
		
		function get curDefinitionInfo() : IDefinitionInfo;
		
		function get tvid() : String;
		
		function get vid() : String;
		
		function get nextTvid() : String;
		
		function get nextVid() : String;
		
		function get albumId() : String;
		
		function get status() : String;
		
		function get source() : Object;
		
		function get ipLimited() : Boolean;
		
		function get duration() : Number;
		
		function get streamType() : EnumItem;
		
		function get screenType() : EnumItem;
		
		function get screenInfoCount() : int;
		
		function get skipPointInfoCount() : int;
		
		function get curEnjoyableSubDurationIndex() : int;
		
		function get width() : int;
		
		function get height() : int;
		
		function get titlesTime() : Number;
		
		function get trailerTime() : Number;
		
		function get member() : Boolean;
		
		function get logoId() : String;
		
		function get logoPosition() : int;
		
		function get ctgId() : int;
		
		function get channelID() : int;
		
		function get audioTrackCount() : int;
		
		function get forceAD() : Boolean;
		
		function get uploaderID() : String;
		
		function get exclusive() : Boolean;
		
		function get curEnjoyableSubType() : EnumItem;
		
		function get qualityDefinitionControlType() : EnumItem;
		
		function get qualityDefinitionControlList() : Array;
		
		function get qualityDefinitionControlTimeRange() : Object;
		
		function getKeyframeByTime(param1:Number) : Keyframe;
		
		function getAudioTrackInfoAt(param1:int) : IAudioTrackInfo;
		
		function getAudioTrackInfoByType(param1:EnumItem) : IAudioTrackInfo;
		
		function getScreenInfoAt(param1:int) : ScreenInfo;
		
		function getSkipPointInfoAt(param1:int) : ISkipPointInfo;
		
		function hasVid(param1:String) : Boolean;
		
		function getVidByDefinition(param1:EnumItem, param2:Boolean = false) : String;
		
		function hasEnjoyableSubType(param1:EnumItem) : Boolean;
		
		function getEnjoyableSubDurationList(param1:EnumItem) : Array;
		
		function hasDefinitionByType(param1:EnumItem) : Boolean;
	}
}
