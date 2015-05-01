package com.sohu.tv.mediaplayer.video {
	import flash.net.NetStream;
	
	public class TvSohuVideoInfo extends Object {
		
		public function TvSohuVideoInfo() {
			super();
		}
		
		private static var svdLen:int = -1;
		
		private static var colorSpace:Vector.<String> = new Vector.<String>();
		
		private var stm:NetStream;
		
		private var renderStat:String = "unknown";
		
		private var color:String = "";
		
		public function getVideoFps() : int {
			return this.stm?this.stm.currentFPS:-1;
		}
		
		public function getDropFrames() : int {
			return this.stm?this.stm.info.droppedFrames:-1;
		}
		
		public function getKbps() : String {
			var _loc1_:* = 0;
			if(this.stm) {
				_loc1_ = this.stm.info.playbackBytesPerSecond / 1000 * 8;
				return _loc1_ + "";
			}
			return "-1";
		}
		
		public function getColorSpace() : Vector.<String> {
			return colorSpace;
		}
		
		public function getCurColor() : String {
			return this.color;
		}
		
		public function getRenderStat() : String {
			return this.renderStat;
		}
		
		public function getSvdLen() : int {
			return svdLen;
		}
		
		public function dispose() : void {
			this.stm = null;
		}
		
		protected function _updateTarget(param1:NetStream) : void {
			this.stm = param1;
		}
		
		protected function _setRenderStat(param1:String) : void {
			this.renderStat = param1;
		}
		
		protected function _setSvdLen(param1:int) : void {
			svdLen = param1;
		}
		
		protected function _setCurColor(param1:String) : void {
			this.color = param1;
		}
		
		protected function _setColorSpace(param1:Vector.<String>) : void {
			colorSpace = param1;
		}
	}
}
