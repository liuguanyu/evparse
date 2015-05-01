package com.qiyi.player.wonder.plugins.videolink.model {
	import flash.geom.Rectangle;
	
	public class VideoLinkInfo extends Object {
		
		public function VideoLinkInfo(param1:Object) {
			super();
			if(param1) {
				this._videoLinkID = param1.id == undefined?"":param1.id;
				this._startTime = param1.bt == undefined?"":param1.bt;
				this._endTime = param1.et == undefined?"":param1.et;
				this._linktype = param1.tp == undefined?"":param1.tp;
				this._btnType = param1.bn == undefined?"":param1.bn;
				if(param1.de) {
					this._title = param1.de.t == undefined?"":param1.de.t;
					this._titleUrl = param1.de.tl == undefined?"":param1.de.tl;
					this._picUrl = param1.de.pic == undefined?"":param1.de.pic;
					this._subTitle = param1.de.st == undefined?"":param1.de.st;
					this._subTitleUrl = param1.de.stl == undefined?"":param1.de.stl;
					this._describe = param1.de.cm == undefined?"":param1.de.cm;
					this._describeUrl = param1.de.cml == undefined?"":param1.de.cml;
				}
			}
		}
		
		private var _isShow:Boolean = false;
		
		private var _videoLinkID:String = "";
		
		private var _linktype:String = "";
		
		private var _startTime:String = "";
		
		private var _endTime:String = "";
		
		private var _title:String = "";
		
		private var _titleUrl:String = "";
		
		private var _picUrl:String = "";
		
		private var _btnType:String = "";
		
		private var _subTitle:String = "";
		
		private var _subTitleUrl:String = "";
		
		private var _describe:String = "";
		
		private var _describeUrl:String = "";
		
		private var _leftArea:Rectangle = null;
		
		private var _rightArea:Rectangle = null;
		
		public function get isShow() : Boolean {
			return this._isShow;
		}
		
		public function set isShow(param1:Boolean) : void {
			this._isShow = param1;
		}
		
		public function get startTime() : String {
			return this._startTime;
		}
		
		public function get endTime() : String {
			return this._endTime;
		}
		
		public function get linktype() : String {
			return this._linktype;
		}
		
		public function get title() : String {
			return this._title;
		}
		
		public function get titleUrl() : String {
			return this._titleUrl;
		}
		
		public function get picUrl() : String {
			return this._picUrl;
		}
		
		public function get btnType() : String {
			return this._btnType;
		}
		
		public function get subTitle() : String {
			return this._subTitle;
		}
		
		public function get subTitleUrl() : String {
			return this._subTitleUrl;
		}
		
		public function get describe() : String {
			return this._describe;
		}
		
		public function get describeUrl() : String {
			return this._describeUrl;
		}
		
		public function get leftArea() : Rectangle {
			return this._leftArea;
		}
		
		public function get rightArea() : Rectangle {
			return this._rightArea;
		}
		
		public function destroy() : void {
			this._isShow = false;
		}
	}
}
