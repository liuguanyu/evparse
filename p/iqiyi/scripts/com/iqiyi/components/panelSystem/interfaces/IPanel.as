package com.iqiyi.components.panelSystem.interfaces {
	import flash.events.IEventDispatcher;
	import flash.display.DisplayObjectContainer;
	import flash.geom.Rectangle;
	
	public interface IPanel extends IEventDispatcher {
		
		function get type() : int;
		
		function set type(param1:int) : void;
		
		function get name() : String;
		
		function get isOpen() : Boolean;
		
		function get isOnStage() : Boolean;
		
		function get hasCover() : Boolean;
		
		function set hasCover(param1:Boolean) : void;
		
		function open(param1:DisplayObjectContainer = null) : void;
		
		function close() : void;
		
		function toTop() : void;
		
		function toBottom() : void;
		
		function setPosition(param1:int, param2:int) : void;
		
		function setSize(param1:int, param2:int) : void;
		
		function setCoverArea(param1:Rectangle) : void;
		
		function destroy() : void;
	}
}
