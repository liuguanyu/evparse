package com.qiyi.player.core.video.render
{
	import flash.events.IEventDispatcher;
	import com.qiyi.player.core.IDestroy;
	import com.qiyi.player.base.pub.EnumItem;
	import com.qiyi.player.core.video.engine.IEngine;
	import com.qiyi.player.core.video.decoder.IDecoder;
	import com.qiyi.player.core.model.IMovie;
	import flash.geom.Rectangle;
	
	public interface IRender extends IEventDispatcher, IDestroy
	{
		
		function get accStatus() : EnumItem;
		
		function bind(param1:IEngine, param2:IDecoder, param3:IMovie) : void;
		
		function releaseBind() : void;
		
		function tryUseGPU() : void;
		
		function tryUpGPUDepth() : void;
		
		function clearVideo() : void;
		
		function setRect(param1:int, param2:int, param3:int, param4:int) : void;
		
		function setZoom(param1:int) : void;
		
		function getSettingArea() : Rectangle;
		
		function getRealArea() : Rectangle;
		
		function setPuman(param1:Boolean) : void;
		
		function setVideoDisplaySettings(param1:int, param2:int) : void;
		
		function setVideoRate(param1:int, param2:int) : void;
	}
}
