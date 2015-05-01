package com.qiyi.player.wonder.plugins.videolink.model {
	import org.puremvc.as3.patterns.proxy.Proxy;
	import com.qiyi.player.wonder.common.status.IStatus;
	import com.qiyi.player.wonder.common.status.Status;
	import com.qiyi.player.wonder.plugins.videolink.VideoLinkDef;
	
	public class VideoLinkProxy extends Proxy implements IStatus {
		
		public function VideoLinkProxy(param1:Object = null) {
			this._downLagTimesArr = [];
			super(NAME,param1);
			this._status = new Status(VideoLinkDef.STATUS_BEGIN,VideoLinkDef.STATUS_END);
			this._status.addStatus(VideoLinkDef.STATUS_VIEW_INIT);
		}
		
		public static const NAME:String = "com.qiyi.player.wonder.plugins.videolink.model.VideoLinkProxy";
		
		private var _status:Status;
		
		private var _downLagTimesArr:Array;
		
		private var _videoLinkVector:Vector.<VideoLinkInfo>;
		
		private var _isHasLink:Boolean = false;
		
		public function get status() : Status {
			return this._status;
		}
		
		public function addStatus(param1:int, param2:Boolean = true) : void {
			if(param1 >= VideoLinkDef.STATUS_BEGIN && param1 < VideoLinkDef.STATUS_END && !this._status.hasStatus(param1)) {
				if(param1 == VideoLinkDef.STATUS_OPEN && !this._status.hasStatus(VideoLinkDef.STATUS_VIEW_INIT)) {
					this._status.addStatus(VideoLinkDef.STATUS_VIEW_INIT);
					sendNotification(VideoLinkDef.NOTIFIC_ADD_STATUS,VideoLinkDef.STATUS_VIEW_INIT);
				}
				this._status.addStatus(param1);
				if(param2) {
					sendNotification(VideoLinkDef.NOTIFIC_ADD_STATUS,param1);
				}
			}
		}
		
		public function removeStatus(param1:int, param2:Boolean = true) : void {
			if(param1 >= VideoLinkDef.STATUS_BEGIN && param1 < VideoLinkDef.STATUS_END && (this._status.hasStatus(param1))) {
				this._status.removeStatus(param1);
				if(param2) {
					sendNotification(VideoLinkDef.NOTIFIC_REMOVE_STATUS,param1);
				}
			}
		}
		
		public function hasStatus(param1:int) : Boolean {
			return this._status.hasStatus(param1);
		}
		
		public function get isHasLink() : Boolean {
			return this._isHasLink;
		}
		
		public function set isHasLink(param1:Boolean) : void {
			this._isHasLink = param1;
		}
		
		public function addVideoLinkInfo(param1:Vector.<VideoLinkInfo>) : void {
			this.clearVideoLinkInfo();
			this._videoLinkVector = param1;
			if(this._videoLinkVector.length > 0) {
				this._isHasLink = true;
			}
		}
		
		public function getVideoLinkInfoByCurrentTime(param1:int) : VideoLinkInfo {
			var _loc2_:VideoLinkInfo = null;
			if(this._videoLinkVector == null) {
				return null;
			}
			for each(_loc2_ in this._videoLinkVector) {
				if(param1 >= int(_loc2_.startTime) && param1 <= int(_loc2_.endTime)) {
					return _loc2_;
				}
			}
			return null;
		}
		
		public function resetIsShow() : void {
			var _loc1_:VideoLinkInfo = null;
			for each(_loc1_ in this._videoLinkVector) {
				_loc1_.isShow = false;
			}
		}
		
		private function clearVideoLinkInfo() : void {
			var _loc1_:VideoLinkInfo = null;
			if(this._videoLinkVector) {
				while(this._videoLinkVector.length > 0) {
					_loc1_ = this._videoLinkVector.shift();
					_loc1_.destroy();
					_loc1_ = null;
				}
				this._videoLinkVector.length = 0;
				this._videoLinkVector = null;
			}
		}
		
		public function lagDownClient(param1:int) : Boolean {
			var _loc2_:uint = new Date().time;
			this._downLagTimesArr.push(_loc2_);
			var _loc3_:* = 0;
			while(_loc3_ < this._downLagTimesArr.length) {
				if(_loc2_ - this._downLagTimesArr[_loc3_] > param1) {
					this._downLagTimesArr.splice(_loc3_,1);
				}
				_loc3_++;
			}
			if(this._downLagTimesArr.length >= VideoLinkDef.MAX_DOWN_CLIENT_STUCK) {
				this._downLagTimesArr.length = 0;
				return true;
			}
			return false;
		}
	}
}
