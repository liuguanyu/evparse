package com.sohu.tv.mediaplayer.ui.events {
	import flash.events.Event;
	
	public class PanelEvent extends Event {
		
		public function PanelEvent(param1:String, param2:Boolean = true, param3:Boolean = false) {
			super(param1,param2,param3);
		}
		
		public static const READY:String = "READY";
		
		public static const INITED:String = "INITED";
		
		public static const CLOSED:String = "CLOSED";
		
		public static const OPEN_LIKE_PANEL:String = "OPEN_LIKE_PANEL";
		
		public static const LIGHT_VAL_CHANGE:String = "LIGHT_VAL_CHANGE";
		
		public static const CONTRAST_VAL_CHANGE:String = "CONTRAST_VAL_CHANGE";
		
		public static const SCALE_SELECTED:String = "SCALE_SELECTED";
		
		public static const ROTATE_SCR:String = "ROTATE_SCR";
		
		public static const ACCELERATED_CHANGE:String = "ACCELERATED_CHANGE";
		
		public var lightVal:Number = 0;
		
		public var contrastVal:Number = 0;
		
		public var scaleRate:Number;
		
		public var rotateVal:Number;
		
		public var toStgVd:Boolean = false;
		
		override public function clone() : Event {
			var _loc1_:PanelEvent = new PanelEvent(type,bubbles,cancelable);
			_loc1_.lightVal = this.lightVal;
			_loc1_.contrastVal = this.contrastVal;
			_loc1_.scaleRate = this.scaleRate;
			_loc1_.rotateVal = this.rotateVal;
			_loc1_.toStgVd = this.toStgVd;
			return _loc1_;
		}
	}
}
