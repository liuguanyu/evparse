package com.qiyi.player.wonder.plugins.feedback.view.parts.copyrightexpired {
	import flash.display.Sprite;
	import com.qiyi.player.wonder.IDestroy;
	import feedback.CopyRightExpiredUI;
	import flash.text.TextField;
	import feedback.DownLoadBtn;
	import com.qiyi.player.wonder.plugins.recommend.model.RecommendVO;
	import flash.net.URLLoader;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLRequest;
	import com.adobe.serialization.json.JSON;
	import com.iqiyi.components.global.GlobalStage;
	import com.qiyi.player.wonder.plugins.feedback.FeedbackDef;
	import com.qiyi.player.wonder.plugins.feedback.view.FeedbackEvent;
	import com.qiyi.player.wonder.common.pingback.PingBack;
	import flash.net.navigateToURL;
	import com.qiyi.player.wonder.common.config.SystemConfig;
	import flash.display.DisplayObject;
	import com.qiyi.player.wonder.common.ui.FastCreator;
	
	public class CopyrightExpired extends Sprite implements IDestroy {
		
		public function CopyrightExpired(param1:String, param2:Boolean = true, param3:String = "") {
			super();
			this._copyRightExpiredUI = new CopyRightExpiredUI();
			addChild(this._copyRightExpiredUI);
			this._videoName = param3 != ""?param3:this._videoName;
			this._titleTF = param2?FastCreator.createLabel(TEXT_TITLE_EXPIRE,16777215,18):FastCreator.createLabel(TEXT_TITLE_ERROR,16777215,18);
			this._titleTF.x = (this._copyRightExpiredUI.width - this._titleTF.width) / 2;
			this._titleTF.y = -11;
			this._copyRightExpiredUI.addChild(this._titleTF);
			this._clientExtendTF = FastCreator.createLabel(TEXT_CLIENT_EXTEND,16777215,12);
			this._clientExtendTF.htmlText = TEXT_CLIENT_EXTEND;
			this._clientExtendTF.x = (this._copyRightExpiredUI.width - this._clientExtendTF.width) * 0.5;
			this._clientExtendTF.y = this._titleTF.y + this._titleTF.height + 10;
			this._copyRightExpiredUI.addChild(this._clientExtendTF);
			this._downLoadBtn = new DownLoadBtn();
			this._downLoadBtn.x = (this._copyRightExpiredUI.width - this._downLoadBtn.width) * 0.5;
			this._downLoadBtn.y = this._clientExtendTF.y + this._clientExtendTF.height + 20;
			this._copyRightExpiredUI.addChild(this._downLoadBtn);
			this._downLoadTF = FastCreator.createLabel(TEXT_DOWNLOAD_BTN,16777215,16);
			this._downLoadTF.selectable = this._downLoadTF.mouseEnabled = false;
			this._downLoadTF.x = this._downLoadBtn.x + 18;
			this._downLoadTF.y = this._downLoadBtn.y + (this._downLoadBtn.height - this._downLoadTF.height) * 0.5;
			this._copyRightExpiredUI.addChild(this._downLoadTF);
			this._describeTF = FastCreator.createLabel(TEXT_LINK,13421772,14);
			this._describeTF.x = (this._copyRightExpiredUI.width - this._describeTF.width) / 2;
			this._describeTF.y = this._downLoadBtn.y + this._downLoadBtn.height + 20;
			this._copyRightExpiredUI.addChild(this._describeTF);
			this._searchPart = new CopyrightExpiredSearchPart();
			this._searchPart.videoName = this._videoName;
			this._searchPart.addEventListener(FeedbackEvent.Evt_CopyrightSearchBtnClick,this.onSearchVideoClick);
			addChild(this._searchPart);
			this._listPart = new CopyrightExpiredListPart();
			this._listPart.addEventListener(FeedbackEvent.Evt_CopyrightRecItemClick,this.onEvtItemClick);
			addChild(this._listPart);
			this.requestRecommendList(param1);
		}
		
		private static const TEXT_TITLE_EXPIRE:String = "很抱歉，您所观看的视频已经下线";
		
		private static const TEXT_TITLE_ERROR:String = "很抱歉，您所观看的视频暂无法观看";
		
		private static const TEXT_CLIENT_EXTEND:String = "<font color=\'#699f00\'>爱奇艺视频桌面版</font>说不定还能看，去试试？";
		
		private static const TEXT_DOWNLOAD_BTN:String = "立刻下载安装";
		
		private static const TEXT_LINK:String = "如果您有其他问题，<a href=\'event:onTextEventClick\'><u>请告知我们</u></a> 我们将尽快查找原因。";
		
		private static const TEXT_RECOMMEND:String = "这些视频最近很火，赶紧看看吧";
		
		private var _videoName:String = "";
		
		private var _searchPart:CopyrightExpiredSearchPart;
		
		private var _listPart:CopyrightExpiredListPart;
		
		private var _copyRightExpiredUI:CopyRightExpiredUI;
		
		private var _titleTF:TextField;
		
		private var _describeTF:TextField;
		
		private var _clientExtendTF:TextField;
		
		private var _downLoadBtn:DownLoadBtn;
		
		private var _downLoadTF:TextField;
		
		private var _recommendJson:Object = null;
		
		private var _recommendVector:Vector.<RecommendVO>;
		
		public function get downLoadBtn() : DownLoadBtn {
			return this._downLoadBtn;
		}
		
		private function requestRecommendList(param1:String) : void {
			var _loc2_:URLLoader = new URLLoader();
			_loc2_.addEventListener(Event.COMPLETE,this.onCompleteHandler);
			_loc2_.addEventListener(IOErrorEvent.IO_ERROR,this.onErrorHander);
			_loc2_.addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.onErrorHander);
			_loc2_.load(new URLRequest(param1));
		}
		
		private function onCompleteHandler(param1:Event) : void {
			var item:RecommendVO = null;
			var i:uint = 0;
			var var_5:Event = param1;
			var urlLoader:URLLoader = var_5.target as URLLoader;
			try {
				this._recommendVector = new Vector.<RecommendVO>();
				this._recommendJson = com.adobe.serialization.json.JSON.decode(urlLoader.data);
				i = 0;
				while(i < this._recommendJson.mixinVideos.length) {
					item = new RecommendVO(i,this._recommendJson.mixinVideos[i]);
					this._recommendVector.push(item);
					i++;
				}
				this._listPart.recommendData = this._recommendVector;
				this.onResize(GlobalStage.stage.stageWidth,GlobalStage.stage.stageHeight);
			}
			catch(e:Error) {
			}
			urlLoader.removeEventListener(Event.COMPLETE,this.onCompleteHandler);
			urlLoader.removeEventListener(IOErrorEvent.IO_ERROR,this.onErrorHander);
			urlLoader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,this.onErrorHander);
			urlLoader = null;
		}
		
		private function onErrorHander(param1:Event) : void {
			var _loc2_:URLLoader = param1.target as URLLoader;
			_loc2_.removeEventListener(Event.COMPLETE,this.onCompleteHandler);
			_loc2_.removeEventListener(IOErrorEvent.IO_ERROR,this.onErrorHander);
			_loc2_.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,this.onErrorHander);
			_loc2_ = null;
		}
		
		public function get videoName() : String {
			return this._videoName;
		}
		
		public function set videoName(param1:String) : void {
			this._videoName = param1;
		}
		
		public function get linkTextField() : TextField {
			return this._describeTF;
		}
		
		public function onResize(param1:int, param2:int) : void {
			graphics.clear();
			graphics.beginFill(0);
			graphics.drawRect(0,0,param1,param2);
			graphics.endFill();
			this._searchPart.resize(param1,param2);
			this._searchPart.visible = param2 >= FeedbackDef.NUM_HEIGHT_SHOW_SEARCH_PART && param1 >= FeedbackDef.NUM_WIDTH_SHOW_SEARCH_PART?true:false;
			this._listPart.resize(param1,param2);
			this._listPart.visible = param2 >= FeedbackDef.NUM_HEIGHT_SHOW_LIST_PANEL && param1 >= FeedbackDef.NUM_WIDTH_SHOW_SEARCH_PART?true:false;
			this._copyRightExpiredUI.x = (param1 - this._copyRightExpiredUI.width) / 2;
			this._copyRightExpiredUI.y = param2 / 2 - this._copyRightExpiredUI.height * 0.5 - this._listPart.height * 0.5 * int(this._listPart.visible) - this._searchPart.height * 0.5 * int(this._searchPart.visible) + 30;
			this._searchPart.y = this._copyRightExpiredUI.y + this._copyRightExpiredUI.height;
			this._listPart.y = this._searchPart.y + 70;
		}
		
		private function onEvtItemClick(param1:FeedbackEvent) : void {
			var _loc6_:Object = null;
			var _loc2_:RecommendVO = param1.data as RecommendVO;
			var _loc3_:* = "";
			var _loc4_:* = "";
			var _loc5_:* = "";
			if(this._recommendJson) {
				_loc6_ = this._recommendJson.attribute;
				if((_loc6_) && (!(_loc6_.bkt == undefined) || !(_loc6_.bucket == undefined))) {
					_loc4_ = _loc6_.bkt != undefined?_loc6_.bkt:_loc6_.bucket;
				}
				if((_loc6_) && !(_loc6_.event_id == undefined)) {
					_loc3_ = _loc6_.event_id;
				}
				if((_loc6_) && !(_loc6_.area == undefined)) {
					_loc5_ = _loc6_.area;
				}
			}
			PingBack.getInstance().recommendClick4QiyuPing(_loc2_.albumID,_loc3_,_loc4_,_loc5_,_loc2_.seatID.toString(),_loc2_.playUrl,_loc2_.channel);
			navigateToURL(new URLRequest(_loc2_.playUrl),"_self");
		}
		
		private function onSearchVideoClick(param1:FeedbackEvent) : void {
			var _loc2_:* = SystemConfig.FEEDBACK_SEARCH_URL + encodeURIComponent(param1.data.toString()) + "?source=bqxx";
			navigateToURL(new URLRequest(_loc2_),"_blank");
		}
		
		public function destroy() : void {
			var _loc1_:DisplayObject = null;
			if((this._searchPart) && (this._searchPart.parent)) {
				this._searchPart.removeEventListener(FeedbackEvent.Evt_CopyrightSearchBtnClick,this.onSearchVideoClick);
				removeChild(this._searchPart);
				this._searchPart.destory();
				this._searchPart = null;
			}
			if((this._listPart) && (this._listPart.parent)) {
				this._listPart.removeEventListener(FeedbackEvent.Evt_CopyrightRecItemClick,this.onEvtItemClick);
				removeChild(this._listPart);
				this._listPart.destory();
				this._listPart = null;
			}
			if((this._copyRightExpiredUI) && (this._copyRightExpiredUI.parent)) {
				while(this._copyRightExpiredUI.numChildren > 0) {
					_loc1_ = this._copyRightExpiredUI.getChildAt(0);
					this._copyRightExpiredUI.removeChild(_loc1_);
					_loc1_ = null;
				}
				removeChild(this._copyRightExpiredUI);
				this._copyRightExpiredUI = null;
			}
			this._recommendJson = null;
			this._recommendVector = null;
		}
	}
}
