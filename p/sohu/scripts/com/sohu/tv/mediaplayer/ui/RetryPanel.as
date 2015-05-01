package com.sohu.tv.mediaplayer.ui {
	import flash.display.*;
	import com.sohu.tv.mediaplayer.stat.*;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import com.sohu.tv.mediaplayer.PlayerConfig;
	
	public class RetryPanel extends TvSohuPanel {
		
		public function RetryPanel(param1:MovieClip) {
			_owner = this;
			super(param1);
			this.addEvent();
		}
		
		public static const RETRY:String = "retry";
		
		private function addEvent() : void {
			_skin.close_btn.addEventListener(MouseEvent.MOUSE_UP,close);
			_skin.retry_btn.addEventListener(MouseEvent.MOUSE_UP,function(param1:MouseEvent):void {
				close();
				dispatchEvent(new Event(RETRY));
			});
			_skin.feedback_btn.addEventListener(MouseEvent.MOUSE_UP,function(param1:MouseEvent):void {
				if(!PlayerConfig.isPartner) {
					ErrorSenderPQ.getInstance().sendFeedback();
				}
			});
		}
	}
}
