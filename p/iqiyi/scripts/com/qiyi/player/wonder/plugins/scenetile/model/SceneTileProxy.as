package com.qiyi.player.wonder.plugins.scenetile.model {
	import org.puremvc.as3.patterns.proxy.Proxy;
	import com.qiyi.player.wonder.common.status.IStatus;
	import com.qiyi.player.wonder.common.status.Status;
	import com.qiyi.player.base.logging.ILogger;
	import flash.net.URLLoader;
	import flash.utils.Dictionary;
	import com.qiyi.player.wonder.common.utils.ObjectPool;
	import com.qiyi.player.wonder.plugins.scenetile.model.barrage.actor.BarrageStarInteractInfo;
	import com.qiyi.player.wonder.plugins.scenetile.model.barrage.socket.BarrageSocket;
	import com.qiyi.player.base.pub.EnumItem;
	import com.qiyi.player.wonder.plugins.scenetile.SceneTileDef;
	import flash.external.ExternalInterface;
	import com.adobe.serialization.json.JSON;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import com.qiyi.player.wonder.plugins.scenetile.view.barragepart.BarrageExpressionImage;
	import com.qiyi.player.wonder.common.config.SystemConfig;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	import com.qiyi.player.wonder.plugins.scenetile.model.barrage.BarrageInfo;
	import com.qiyi.player.wonder.common.event.CommonEvent;
	import com.qiyi.player.wonder.body.model.JavascriptAPIProxy;
	import com.qiyi.player.wonder.body.model.PlayerProxy;
	import com.qiyi.player.base.logging.Log;
	import com.qiyi.player.wonder.common.config.FlashVarConfig;
	
	public class SceneTileProxy extends Proxy implements IStatus {
		
		public function SceneTileProxy(param1:Object = null) {
			this._log = Log.getLogger(NAME);
			this._barrageData = new Dictionary();
			this._isBarrageOpen = FlashVarConfig.openBarrage;
			super(NAME,param1);
			this._status = new Status(SceneTileDef.STATUS_BEGIN,SceneTileDef.STATUS_END);
			this._status.addStatus(SceneTileDef.STATUS_TOOL_VIEW_INIT);
			if(FlashVarConfig.putBarrage) {
				this.initbarrage();
			}
		}
		
		public static const NAME:String = "com.qiyi.player.wonder.plugins.scenetile.model.SceneTileProxy";
		
		private var _status:Status;
		
		private var _lastPlayingDuration:int = 0;
		
		private var _lifePlayingDuration:int = 0;
		
		private var _lotteryShowTime:int = -1;
		
		private var _log:ILogger;
		
		private var _curDataParagraph:uint = 0;
		
		private var _preLoadDataParagraph:uint = 0;
		
		private var _isLoading:Boolean = false;
		
		private var _loader:URLLoader;
		
		private var _barrageData:Dictionary;
		
		private var _vecOP:ObjectPool;
		
		private var _barrageItemOP:ObjectPool;
		
		private var _curShowTime:int = 0;
		
		private var _isBarrageOpen:Boolean;
		
		private var _barrageAlpha:uint = 90;
		
		private var _barrageIsFilterImage:Boolean = false;
		
		private var _starInteractInfo:BarrageStarInteractInfo;
		
		private var _barrageSocket:BarrageSocket;
		
		private var _scoreLoader:URLLoader;
		
		private var _tvid:String = "";
		
		private var _ppuid:String = "";
		
		private var _uid:String = "";
		
		private var _pru:String = "";
		
		private var _curScoreNum:Number = 0;
		
		private var _isOpenAtMidway:Boolean = false;
		
		private var _isOpenAtFinish:Boolean = false;
		
		private var _isScored:Boolean = false;
		
		private var _selectedScore:int = -1;
		
		private var _limitDifinition:EnumItem = null;
		
		public function get limitDifinition() : EnumItem {
			return this._limitDifinition;
		}
		
		public function set limitDifinition(param1:EnumItem) : void {
			this._limitDifinition = param1;
		}
		
		private function initbarrage() : void {
			this._status.addStatus(SceneTileDef.STATUS_BARRAGE_VIEW_INIT);
			this._vecOP = new ObjectPool();
			this._barrageItemOP = new ObjectPool();
			this.getBarrageSettingFromJSCookies();
			this._barrageSocket = new BarrageSocket();
			this._starInteractInfo = new BarrageStarInteractInfo();
			this._starInteractInfo.addEventListener(BarrageStarInteractInfo.Evt_LoaderBarrageInteractInfoComplete,this.onLoaderBIIComplete);
			this._barrageSocket.addEventListener(BarrageSocket.Evt_BarrageSocketReceiveData,this.onReceiveData);
			this._barrageSocket.addEventListener(BarrageSocket.Evt_BarrageSocketConnected,this.onConnected);
			this._barrageSocket.addEventListener(BarrageSocket.Evt_BarrageSocketClose,this.onClose);
		}
		
		public function get barrageSocket() : BarrageSocket {
			return this._barrageSocket;
		}
		
		public function get starInteractInfo() : BarrageStarInteractInfo {
			return this._starInteractInfo;
		}
		
		public function get selectedScore() : int {
			return this._selectedScore;
		}
		
		public function set selectedScore(param1:int) : void {
			this._selectedScore = param1;
		}
		
		public function get isScored() : Boolean {
			return this._isScored;
		}
		
		public function set isScored(param1:Boolean) : void {
			this._isScored = param1;
		}
		
		public function get isOpenAtFinish() : Boolean {
			return this._isOpenAtFinish;
		}
		
		public function set isOpenAtFinish(param1:Boolean) : void {
			this._isOpenAtFinish = param1;
		}
		
		public function get isOpenAtMidway() : Boolean {
			return this._isOpenAtMidway;
		}
		
		public function set isOpenAtMidway(param1:Boolean) : void {
			this._isOpenAtMidway = param1;
		}
		
		public function get curScoreNum() : Number {
			return this._curScoreNum;
		}
		
		public function get barrageIsFilterImage() : Boolean {
			return this._barrageIsFilterImage;
		}
		
		public function set barrageIsFilterImage(param1:Boolean) : void {
			this._barrageIsFilterImage = param1;
		}
		
		public function get barrageAlpha() : uint {
			return this._barrageAlpha;
		}
		
		public function set barrageAlpha(param1:uint) : void {
			this._barrageAlpha = param1;
		}
		
		public function get preLoadDataParagraph() : uint {
			return this._preLoadDataParagraph;
		}
		
		public function set preLoadDataParagraph(param1:uint) : void {
			this._preLoadDataParagraph = param1;
		}
		
		public function get isBarrageOpen() : Boolean {
			return this._isBarrageOpen;
		}
		
		public function set isBarrageOpen(param1:Boolean) : void {
			this._isBarrageOpen = param1;
			sendNotification(SceneTileDef.NOTIFIC_STAR_HEAD_SHOW);
		}
		
		public function get curDataParagraph() : uint {
			return this._curDataParagraph;
		}
		
		public function set curDataParagraph(param1:uint) : void {
			this._curDataParagraph = param1;
		}
		
		public function get lastPlayingDuration() : int {
			return this._lastPlayingDuration;
		}
		
		public function set lastPlayingDuration(param1:int) : void {
			this._lastPlayingDuration = param1;
		}
		
		public function get lifePlayingDuration() : int {
			return this._lifePlayingDuration;
		}
		
		public function set lifePlayingDuration(param1:int) : void {
			this._lifePlayingDuration = param1;
		}
		
		public function get lotteryShowTime() : int {
			return this._lotteryShowTime;
		}
		
		public function set lotteryShowTime(param1:int) : void {
			this._lotteryShowTime = param1;
		}
		
		public function get status() : Status {
			return this._status;
		}
		
		public function addStatus(param1:int, param2:Boolean = true) : void {
			if(param1 >= SceneTileDef.STATUS_BEGIN && param1 < SceneTileDef.STATUS_END && !this._status.hasStatus(param1)) {
				if(param1 == SceneTileDef.STATUS_TOOL_OPEN && !this._status.hasStatus(SceneTileDef.STATUS_TOOL_VIEW_INIT)) {
					this._status.addStatus(SceneTileDef.STATUS_TOOL_VIEW_INIT);
					sendNotification(SceneTileDef.NOTIFIC_ADD_STATUS,SceneTileDef.STATUS_TOOL_VIEW_INIT);
				} else if(param1 == SceneTileDef.STATUS_BARRAGE_OPEN && !this._status.hasStatus(SceneTileDef.STATUS_BARRAGE_VIEW_INIT)) {
					this._status.addStatus(SceneTileDef.STATUS_BARRAGE_VIEW_INIT);
					sendNotification(SceneTileDef.NOTIFIC_ADD_STATUS,SceneTileDef.STATUS_BARRAGE_VIEW_INIT);
				} else if(param1 == SceneTileDef.STATUS_SCORE_OPEN && !this._status.hasStatus(SceneTileDef.STATUS_SCORE_VIEW_INIT)) {
					this._status.addStatus(SceneTileDef.STATUS_SCORE_VIEW_INIT);
					sendNotification(SceneTileDef.NOTIFIC_ADD_STATUS,SceneTileDef.STATUS_SCORE_VIEW_INIT);
				} else if(param1 == SceneTileDef.STATUS_STREAM_LIMIT_OPEN && !this._status.hasStatus(SceneTileDef.STATUS_STREAM_LIMIT_VIEW_INIT)) {
					this._status.addStatus(SceneTileDef.STATUS_STREAM_LIMIT_VIEW_INIT);
					sendNotification(SceneTileDef.NOTIFIC_ADD_STATUS,SceneTileDef.STATUS_STREAM_LIMIT_VIEW_INIT);
				}
				
				
				
				this._status.addStatus(param1);
				if(param2) {
					sendNotification(SceneTileDef.NOTIFIC_ADD_STATUS,param1);
				}
			}
		}
		
		public function removeStatus(param1:int, param2:Boolean = true) : void {
			if(param1 >= SceneTileDef.STATUS_BEGIN && param1 < SceneTileDef.STATUS_END && (this._status.hasStatus(param1))) {
				this._status.removeStatus(param1);
				if(param2) {
					sendNotification(SceneTileDef.NOTIFIC_REMOVE_STATUS,param1);
				}
			}
		}
		
		public function hasStatus(param1:int) : Boolean {
			return this._status.hasStatus(param1);
		}
		
		public function requestLogin() : void {
			var dataProvider:Object = null;
			this._log.debug("call js callJsLogin ");
			try {
				dataProvider = new Object();
				dataProvider.type = "requestLogin";
				ExternalInterface.call("lib.swf.notice",com.adobe.serialization.json.JSON.encode(dataProvider));
			}
			catch(error:Error) {
				_log.debug("call js callJsLogin error");
			}
		}
		
		public function requestBarrageData(param1:uint, param2:String) : void {
			var var_29:uint = param1;
			var var_8:String = param2;
			if(this._preLoadDataParagraph == var_29) {
				return;
			}
			try {
				if(this._loader) {
					this._loader.removeEventListener(Event.COMPLETE,this.onCompleteHandler);
					this._loader.removeEventListener(IOErrorEvent.IO_ERROR,this.onErrorHander);
					this._loader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,this.onErrorHander);
					this._loader.close();
					this._loader = null;
				}
			}
			catch(e:Error) {
			}
			if(this._curDataParagraph == var_29) {
				return;
			}
			BarrageExpressionImage.instance.init();
			this.clearBarrageData();
			var str:String = "0000" + var_8;
			var url:String = SystemConfig.BARRAGE_DATA_URL + str.substr(str.length - 4,2) + "/" + str.substr(str.length - 2,2) + "/" + var_8 + "_" + SceneTileDef.BARRAGE_REQUEST_INTERVAL_TIME / 1000 + "_" + var_29 + ".z?rn=" + Math.random();
			this._loader = new URLLoader();
			this._loader.dataFormat = URLLoaderDataFormat.BINARY;
			this._loader.addEventListener(Event.COMPLETE,this.onCompleteHandler);
			this._loader.addEventListener(IOErrorEvent.IO_ERROR,this.onErrorHander);
			this._loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.onErrorHander);
			this._loader.load(new URLRequest(url));
			this._preLoadDataParagraph = var_29;
			this._log.debug("SceneTileProxy request barrage data :" + url);
		}
		
		private function onCompleteHandler(param1:Event) : void {
			var str:String = null;
			var xml:XML = null;
			var var_5:Event = param1;
			this._curDataParagraph = this._preLoadDataParagraph;
			var data:ByteArray = this._loader.data as ByteArray;
			try {
				data.uncompress();
				str = data.readMultiByte(data.length,"utf-8");
				xml = new XML(data);
				if(xml.code == "A00000") {
					this.analyzeXmlBarrageData(xml);
				}
				this._log.debug("SceneTileProxy request barrage data back code :" + xml.code);
			}
			catch(e:Error) {
				_log.debug("SceneTileProxy request barrage data : error");
			}
		}
		
		private function onErrorHander(param1:*) : void {
			this._log.debug("SceneTileProxy request data : error");
		}
		
		private function analyzeXmlBarrageData(param1:XML) : void {
			var _loc2_:Vector.<BarrageInfo> = null;
			var _loc3_:BarrageInfo = null;
			var _loc4_:XML = null;
			var _loc5_:XML = null;
			for each(_loc4_ in param1.data.entry) {
				_loc2_ = this._vecOP.pop() as Vector.<BarrageInfo>;
				if(_loc2_ == null) {
					_loc2_ = new Vector.<BarrageInfo>();
				}
				for each(_loc5_ in _loc4_.list.bulletInfo) {
					_loc3_ = this._barrageItemOP.pop() as BarrageInfo;
					if(_loc3_ == null) {
						_loc3_ = new BarrageInfo();
					}
					_loc3_.update(_loc5_.contentId,_loc5_.showTime,_loc5_.content,_loc5_.likes,_loc5_.font == undefined?SceneTileDef.BARRAGE_DEFAULT_FONT_SIZE:_loc5_.font,_loc5_.color == undefined?SceneTileDef.BARRAGE_DEFAULT_FONT_COLOR:_loc5_.color,_loc5_.position == undefined?SceneTileDef.BARRAGE_POSITION_NONE:_loc5_.position,_loc5_.contentType == undefined?SceneTileDef.BARRAGE_CONTENT_TYPE_NONE:_loc5_.contentType,_loc5_.background == undefined?SceneTileDef.BARRAGE_BG_TYPE_NONE:_loc5_.background,_loc5_.userInfo == undefined?null:_loc5_.userInfo);
					_loc2_.push(_loc3_);
				}
				this._barrageData[uint(_loc4_.int)] = _loc2_;
			}
		}
		
		private function clearBarrageData() : void {
			var _loc1_:Vector.<BarrageInfo> = null;
			var _loc2_:BarrageInfo = null;
			var _loc3_:* = undefined;
			for(_loc3_ in this._barrageData) {
				_loc1_ = this._barrageData[_loc3_] as Vector.<BarrageInfo>;
				while(_loc1_.length > 0) {
					_loc2_ = _loc1_.pop();
					this._barrageItemOP.push(_loc2_);
				}
				this._vecOP.push(_loc1_);
				delete this._barrageData[_loc3_];
				true;
			}
		}
		
		public function getBarrageData(param1:int) : Vector.<BarrageInfo> {
			var _loc3_:Vector.<BarrageInfo> = null;
			var _loc4_:uint = 0;
			if(this._curShowTime == param1) {
				return null;
			}
			this._curShowTime = param1;
			var _loc2_:Vector.<BarrageInfo> = this._barrageData[param1];
			if((_loc2_) && (this._barrageSocket.connected)) {
				_loc3_ = new Vector.<BarrageInfo>();
				_loc4_ = 0;
				while(_loc4_ < _loc2_.length) {
					if(_loc2_[_loc4_].contentType != SceneTileDef.BARRAGE_CONTENT_TYPE_STAR) {
						_loc3_.push(_loc2_[_loc4_]);
					}
					_loc4_++;
				}
				return _loc3_;
			}
			return _loc2_;
		}
		
		private function onReceiveData(param1:CommonEvent) : void {
			var list:Array = null;
			var vec:Vector.<BarrageInfo> = null;
			var barrageInfo:BarrageInfo = null;
			var obj:Object = null;
			var arr:Array = null;
			var jsArr:Array = null;
			var i:int = 0;
			var javascriptAPIProxy:JavascriptAPIProxy = null;
			var k:uint = 0;
			var var_5:CommonEvent = param1;
			try {
				list = var_5.data as Array;
				if((list) && list.length > 0) {
					vec = new Vector.<BarrageInfo>();
					jsArr = new Array();
					i = 0;
					while(i < list.length) {
						if(list[i].TVLType == BarrageSocket.TVL_TYPE_MULTICAST) {
							obj = com.adobe.serialization.json.JSON.decode(list[i].TVLContent);
							if(obj.data) {
								arr = obj.data as Array;
								k = 0;
								while(k < arr.length) {
									barrageInfo = this._barrageItemOP.pop() as BarrageInfo;
									if(barrageInfo == null) {
										barrageInfo = new BarrageInfo();
									}
									barrageInfo.update(arr[k].contentId,arr[k].showTime,arr[k].content,arr[k].likes,arr[k].font == undefined?SceneTileDef.BARRAGE_DEFAULT_FONT_SIZE:arr[k].font,arr[k].color == undefined?SceneTileDef.BARRAGE_DEFAULT_FONT_COLOR:arr[k].color,arr[k].position == undefined?SceneTileDef.BARRAGE_POSITION_NONE:arr[k].position,arr[k].contentType == undefined?SceneTileDef.BARRAGE_CONTENT_TYPE_NONE:arr[k].contentType,arr[k].background == undefined?SceneTileDef.BARRAGE_BG_TYPE_NONE:arr[k].background,arr[k].userInfo == undefined?null:arr[k].userInfo);
									vec.push(barrageInfo);
									k++;
								}
							}
							jsArr.push(obj);
						}
						i++;
					}
					javascriptAPIProxy = facade.retrieveProxy(JavascriptAPIProxy.NAME) as JavascriptAPIProxy;
					if(vec.length > 0) {
						javascriptAPIProxy.callJsBarrageReceiveData(jsArr);
					}
					sendNotification(SceneTileDef.NOTIFIC_RECEIVE_BARRAGE_INFO,vec);
				}
			}
			catch(error:Error) {
			}
		}
		
		private function onConnected(param1:CommonEvent) : void {
			this.onLoaderBIIComplete();
			sendNotification(SceneTileDef.NOTIFIC_STAR_HEAD_SHOW);
		}
		
		private function onClose(param1:CommonEvent) : void {
			this.onLoaderBIIComplete();
			sendNotification(SceneTileDef.NOTIFIC_STAR_HEAD_SHOW);
		}
		
		private function onLoaderBIIComplete(param1:CommonEvent = null) : void {
			var _loc2_:JavascriptAPIProxy = facade.retrieveProxy(JavascriptAPIProxy.NAME) as JavascriptAPIProxy;
			_loc2_.callJsSetBarrageInteractInfo(this._starInteractInfo.starInteractObj,this._barrageSocket.connected);
			var _loc3_:PlayerProxy = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
			if(_loc3_) {
				_loc3_.curActor.isStarBarrage = _loc3_.preActor.isStarBarrage = this._barrageSocket.connected;
			}
		}
		
		public function getBarrageSettingFromJSCookies() : void {
			var str:String = null;
			var obj:Object = null;
			try {
				str = ExternalInterface.call("Q.cookie.get","QC118");
				if(str) {
					obj = com.adobe.serialization.json.JSON.decode(str);
					if(!(obj == null) && !(obj.opacity == null) && !(obj.opacity == undefined)) {
						this._barrageAlpha = uint(obj.opacity) < 50 || uint(obj.opacity) > 100?SceneTileDef.BARRAGE_DEFAULT_ALPHA:uint(obj.opacity);
					}
					if(!(obj == null) && !(obj.isFilterImage == null) && !(obj.isFilterImage == undefined)) {
						this._barrageIsFilterImage = obj.isFilterImage == "1"?true:false;
					}
				}
			}
			catch(error:Error) {
			}
		}
		
		public function requestScored(param1:String, param2:String, param3:String, param4:String) : void {
			var var_8:String = param1;
			var var_30:String = param2;
			var var_18:String = param3;
			var var_31:String = param4;
			this._tvid = var_8;
			this._ppuid = var_30;
			this._uid = var_18;
			this._pru = var_31;
			try {
				if(this._scoreLoader) {
					this._scoreLoader.removeEventListener(Event.COMPLETE,this.onScoredCompleteHandler);
					this._scoreLoader.removeEventListener(IOErrorEvent.IO_ERROR,this.onErrorHander);
					this._scoreLoader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,this.onErrorHander);
					this._scoreLoader.close();
					this._scoreLoader = null;
				}
			}
			catch(e:Error) {
			}
			var url:String = SystemConfig.MOVIE_SCORE_URL + "scored" + "?entity_ids=" + this._tvid + "&ppuid=" + var_30 + "&uid=" + var_18 + "&pru=" + var_31 + "&rn=" + Math.random();
			this._scoreLoader = new URLLoader();
			this._scoreLoader.addEventListener(Event.COMPLETE,this.onScoredCompleteHandler);
			this._scoreLoader.addEventListener(IOErrorEvent.IO_ERROR,this.onErrorHander);
			this._scoreLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.onErrorHander);
			this._scoreLoader.load(new URLRequest(url));
			this._log.debug("SceneTileProxy request scored data :" + url);
		}
		
		private function onScoredCompleteHandler(param1:Event) : void {
			var obj:Object = null;
			var var_5:Event = param1;
			var urlLoader:URLLoader = var_5.target as URLLoader;
			try {
				obj = com.adobe.serialization.json.JSON.decode(urlLoader.data);
				if(obj.code == "A00000" && obj.data[0].scored == 0) {
					this.requestCurScore();
				}
				this._log.debug("SceneTileProxy request scored data back code :" + obj.data[0].scored);
			}
			catch(e:Error) {
				_log.debug("SceneTileProxy request scored data : error");
			}
		}
		
		private function requestCurScore() : void {
			try {
				if(this._scoreLoader) {
					this._scoreLoader.removeEventListener(Event.COMPLETE,this.onScoreCompleteHandler);
					this._scoreLoader.removeEventListener(IOErrorEvent.IO_ERROR,this.onErrorHander);
					this._scoreLoader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,this.onErrorHander);
					this._scoreLoader.close();
					this._scoreLoader = null;
				}
			}
			catch(e:Error) {
			}
			var url:String = SystemConfig.MOVIE_SCORE_URL + "score" + "?entity_ids=" + this._tvid + "&ppuid=" + this._ppuid + "&uid=" + this._uid + "&pru=" + this._pru + "&rn=" + Math.random();
			this._scoreLoader = new URLLoader();
			this._scoreLoader.addEventListener(Event.COMPLETE,this.onScoreCompleteHandler);
			this._scoreLoader.addEventListener(IOErrorEvent.IO_ERROR,this.onErrorHander);
			this._scoreLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.onErrorHander);
			this._scoreLoader.load(new URLRequest(url));
			this._log.debug("SceneTileProxy request score data :" + url);
		}
		
		private function onScoreCompleteHandler(param1:Event) : void {
			var obj:Object = null;
			var var_5:Event = param1;
			var urlLoader:URLLoader = var_5.target as URLLoader;
			try {
				obj = com.adobe.serialization.json.JSON.decode(urlLoader.data);
				if(obj.code == "A00000") {
					if((obj.data) && (obj.data[0])) {
						this._curScoreNum = Number(obj.data[0].score);
					}
					this.addStatus(SceneTileDef.STATUS_SCORE_OPEN);
				}
				this._log.debug("SceneTileProxy request score data back code :" + obj.data[0].scored);
			}
			catch(e:Error) {
				_log.debug("SceneTileProxy request score data : error");
			}
		}
	}
}
