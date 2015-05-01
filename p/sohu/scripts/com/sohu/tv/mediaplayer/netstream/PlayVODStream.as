package com.sohu.tv.mediaplayer.netstream {
	import p2pstream.XNetStreamVODFactory;
	import com.sohu.tv.mediaplayer.PlayerConfig;
	import flash.net.NetStream;
	import flash.media.Video;
	import flash.net.NetConnection;
	import ebing.utils.*;
	import flash.events.*;
	import flash.utils.*;
	import flash.media.SoundTransform;
	import com.sohu.tv.mediaplayer.video.TvSohuVideo;
	import ebing.Utils;
	import flash.system.Capabilities;
	import com.sohu.tv.mediaplayer.Model;
	
	public class PlayVODStream extends TvSohuNetStream {
		
		public function PlayVODStream(param1:NetConnection, param2:Boolean = false, param3:Boolean = false, param4:uint = 0) {
			this._eventLisnterArray = new Array();
			this._nc = param1;
			super(param1,param2,param3);
			_clipNo = param4;
			if((factory.isSuccess) && (this.usingXNet)) {
				this._netstream = factory.newNetStreamVOD("sohu_" + PlayerConfig.caid,String(Model.getInstance().videoInfo.id),Number(Model.getInstance().videoInfo.data.totalBytes),Number(param4));
				this._usingXNet = true;
				this._netstream.addEventListener("SocketFail",this.onSocketFail);
				_is200 = param2;
				sysInit("start");
			} else {
				this._usingXNet = false;
				this._netstream = new NetStream(this._nc);
			}
		}
		
		public static var libaryURL:String = PlayerConfig.swfHost + "CloudaccVinfo.swf";
		
		public static var factory:XNetStreamVODFactory = XNetStreamVODFactory.defaultFactory;
		
		protected static var _currentVideoStream:Object = new Object();
		
		public static function init(param1:Function) : void {
			if(PlayerConfig.adReview == "ppweb") {
				libaryURL = "http://info.ppweb.com.cn/webp2p/vinfo/sohu.php";
			}
			factory.prepareProperties("libraryUrl",libaryURL);
			factory.prepareProperties("callBack",param1);
			factory.load(10000);
		}
		
		private var _netstream:NetStream;
		
		private var _cdnUrl:String;
		
		private var _video:Video = null;
		
		private var _isPause:Boolean = false;
		
		private var _isClose:Boolean = true;
		
		private var _socketFail:Boolean = false;
		
		private var _usingXNet:Boolean = true;
		
		private var _nc:NetConnection;
		
		private var _eventLisnterArray:Array;
		
		public function get usingXNet() : Boolean {
			return !this._socketFail && (this._usingXNet);
		}
		
		private function onSocketFail(param1:Event) : void {
			var _loc2_:NetStream = null;
			var _loc3_:* = 0;
			LogManager.msg("onSocketFail ux:" + this.usingXNet);
			if(this.usingXNet) {
				this._usingXNet = false;
				this._socketFail = true;
				_loc2_ = new NetStream(this._nc);
				_loc2_.backBufferTime = this._netstream.backBufferTime;
				_loc2_.bufferTime = this._netstream.bufferTime;
				_loc2_.bufferTimeMax = this._netstream.bufferTimeMax;
				_loc2_.checkPolicyFile = this._netstream.checkPolicyFile;
				_loc2_.client = this._netstream.client;
				_loc2_.inBufferSeek = this._netstream.inBufferSeek;
				_loc2_.maxPauseBufferTime = this._netstream.maxPauseBufferTime;
				_loc2_.soundTransform = this._netstream.soundTransform;
				this._netstream.close();
				if(this._video != null) {
					this._video.attachNetStream(_loc2_);
				}
				_loc3_ = 0;
				while(_loc3_ < this._eventLisnterArray.length) {
					if(this._eventLisnterArray[_loc3_].action == "add") {
						_loc2_.addEventListener(this._eventLisnterArray[_loc3_].type,this._eventLisnterArray[_loc3_].func);
					} else if(this._eventLisnterArray[_loc3_].action == "remove") {
						_loc2_.removeEventListener(this._eventLisnterArray[_loc3_].type,this._eventLisnterArray[_loc3_].func);
					}
					
					this._netstream.removeEventListener(this._eventLisnterArray[_loc3_].type,this._eventLisnterArray[_loc3_].func);
					_loc3_++;
				}
				this._netstream = _loc2_;
				if(!(this._cdnUrl == null) && this._isClose == false) {
					_loc2_.play(this._cdnUrl);
					if(this._isPause) {
						_loc2_.pause();
					}
				}
			}
		}
		
		override public function get bufferLength() : Number {
			return this._netstream.bufferLength;
		}
		
		override public function get bufferTime() : Number {
			return this._netstream.bufferTime;
		}
		
		override public function set bufferTime(param1:Number) : void {
			this._netstream.bufferTime = param1;
		}
		
		override public function get bytesLoaded() : uint {
			return this._netstream.bytesLoaded;
		}
		
		override public function get bytesTotal() : uint {
			return this._netstream.bytesTotal;
		}
		
		override public function get client() : Object {
			return this._netstream.client;
		}
		
		override public function set client(param1:Object) : void {
			this._netstream.client = param1;
		}
		
		override public function get time() : Number {
			return this._netstream.time;
		}
		
		override public function get checkPolicyFile() : Boolean {
			return this._netstream.checkPolicyFile;
		}
		
		override public function get currentFPS() : Number {
			return this._netstream.currentFPS;
		}
		
		override public function get objectEncoding() : uint {
			return this._netstream.objectEncoding;
		}
		
		override public function get soundTransform() : SoundTransform {
			return this._netstream.soundTransform;
		}
		
		override public function set soundTransform(param1:SoundTransform) : void {
			this._netstream.soundTransform = param1;
		}
		
		override public function receiveAudio(param1:Boolean) : void {
			this._netstream.receiveAudio(param1);
		}
		
		override public function receiveVideo(param1:Boolean) : void {
			this._netstream.receiveVideo(param1);
		}
		
		public function pause1() : void {
			this._isPause = true;
			this._netstream.pause();
		}
		
		public function resume1() : void {
			this._isPause = false;
			this._netstream.resume();
		}
		
		public function close1() : void {
			this._isClose = true;
			this._netstream.close();
		}
		
		override public function togglePause() : void {
			this._netstream.togglePause();
		}
		
		override public function seek(param1:Number) : void {
			this._netstream.seek(param1);
		}
		
		public function play1(... rest) : void {
			var _loc2_:RegExp = null;
			var _loc3_:RegExp = null;
			var _loc4_:RegExp = null;
			this._isPause = false;
			this._isClose = false;
			this._cdnUrl = rest[0];
			LogManager.msg("play1 ux:" + this.usingXNet + " su:" + _smallSuppliers);
			if(this.usingXNet) {
				if(this._cdnUrl.indexOf("http://127.0.0.1") == 0 || (_smallSuppliers)) {
					this._netstream.close();
					this.onSocketFail(null);
					this._netstream.play(this._cdnUrl);
					return;
				}
				if(this._cdnUrl.indexOf("start=") > 0) {
					_loc2_ = new RegExp("start=([0-9])+&");
					_loc3_ = new RegExp("&start=([0-9])+");
					_loc4_ = new RegExp("start=([0-9])+");
					this._netstream.play(this._cdnUrl.replace(_loc2_,"").replace(_loc3_,"").replace(_loc4_,""),this._cdnUrl.replace(_loc2_,"").replace(_loc3_,"").replace(_loc4_,""),_dragTime);
				} else {
					this._netstream.play(this._cdnUrl,this._cdnUrl);
				}
			} else {
				this._netstream.play(this._cdnUrl);
			}
		}
		
		public function attachVideoToStream(param1:Video) : void {
			this._video = param1;
			if(TvSohuVideo.predictMode == TvSohuVideo.STG_VIDEO_MODE) {
				param1["attachSvdCurStream"](this._netstream);
			} else {
				param1.attachNetStream(this._netstream);
			}
			_currentVideoStream[this._video] = this._netstream;
		}
		
		override public function addEventListener(param1:String, param2:Function, param3:Boolean = false, param4:int = 0, param5:Boolean = false) : void {
			var _loc6_:Object = new Object();
			_loc6_.action = "add";
			_loc6_.type = param1;
			_loc6_.func = param2;
			this._eventLisnterArray.push(_loc6_);
			this._netstream.addEventListener(param1,param2);
		}
		
		override public function removeEventListener(param1:String, param2:Function, param3:Boolean = false) : void {
			var _loc4_:Object = new Object();
			_loc4_.action = "remove";
			_loc4_.type = param1;
			_loc4_.func = param2;
			this._eventLisnterArray.push(_loc4_);
			this._netstream.removeEventListener(param1,param2);
		}
		
		override public function dispatchEvent(param1:Event) : Boolean {
			return this._netstream.dispatchEvent(param1);
		}
		
		override public function willTrigger(param1:String) : Boolean {
			return this._netstream.willTrigger(param1);
		}
		
		override public function hasEventListener(param1:String) : Boolean {
			return this._netstream.hasEventListener(param1);
		}
		
		override protected function doPlay(param1:String) : void {
			var url:String = param1;
			_isnp = true;
			_cdnuse = getTimer();
			gotMetaData = false;
			var plat:String = "";
			var boo:Boolean = url.split("?").length > 1;
			var vid:String = PlayerConfig.currentVid != ""?"&vid=" + PlayerConfig.currentVid:"";
			var uid:String = PlayerConfig.userId != ""?"&uid=" + PlayerConfig.userId:"";
			var ta:String = PlayerConfig.ta_jm != ""?"&ta=" + escape(PlayerConfig.ta_jm):"";
			var otherParameters:String = "";
			var newInfoStr:String = (PlayerConfig.lqd != ""?"&oth=" + PlayerConfig.lqd:"") + (PlayerConfig.lcode != ""?"&cd=" + PlayerConfig.lcode:"") + "&sz=" + (PlayerConfig.clientWidth + "_" + PlayerConfig.clientHeight) + "&md=" + PlayerConfig.cdnMd + (PlayerConfig.ugu != ""?"&ugu=" + PlayerConfig.ugu:"") + (PlayerConfig.ugcode != ""?"&ugcode=" + PlayerConfig.ugcode:"");
			if((_hasP2P) || !_is200) {
				plat = "&plat=" + escape(Utils.cleanTrim("flash_" + Capabilities.os + "_ifox"));
			} else {
				plat = "&plat=" + escape(Utils.cleanTrim("flash_" + Capabilities.os));
				otherParameters = vid + "&tvid=" + PlayerConfig.tvid + uid + ta + newInfoStr;
			}
			var tempid:String = "";
			var cc:String = String(PlayerConfig.catcode).substr(0,3);
			if(cc == "115") {
				tempid = "&tempid=115";
			}
			if(boo) {
				url = url + (PlayerConfig.channel != ""?"&ch=" + PlayerConfig.channel:"") + (PlayerConfig.catcode != ""?"&catcode=" + PlayerConfig.catcode:"") + (!(PlayerConfig.vrsPlayListId == "") && (PlayerConfig.isSendPID)?"&pid=" + PlayerConfig.vrsPlayListId:"") + tempid + "&prod=flash&pt=1" + plat + (_cdnNt != ""?"&n=" + _cdnNt:"") + (_cdnArea != ""?"&a=" + _cdnArea:"") + (PlayerConfig.clientIp != ""?"&cip=" + PlayerConfig.clientIp:"") + otherParameters + "&uuid=" + PlayerConfig.uuid + "&url=" + (PlayerConfig.currentPageUrl == ""?escape(PlayerConfig.outReferer):escape(PlayerConfig.currentPageUrl));
			} else {
				url = url + (PlayerConfig.channel != ""?"?ch=" + PlayerConfig.channel:"") + (PlayerConfig.catcode != ""?"&catcode=" + PlayerConfig.catcode:"") + (!(PlayerConfig.vrsPlayListId == "") && (PlayerConfig.isSendPID)?"&pid=" + PlayerConfig.vrsPlayListId:"") + tempid + "&prod=flash&pt=1" + plat + (_cdnNt != ""?"&n=" + _cdnNt:"") + (_cdnArea != ""?"&a=" + _cdnArea:"") + (PlayerConfig.clientIp != ""?"&cip=" + PlayerConfig.clientIp:"") + otherParameters + "&uuid=" + PlayerConfig.uuid + "&url=" + (PlayerConfig.currentPageUrl == ""?escape(PlayerConfig.outReferer):escape(PlayerConfig.currentPageUrl));
			}
			if(_isPlay) {
				this.play1(url);
			} else {
				this.play1(url);
				this.pause();
				this.seek(0);
			}
			_playUrl = url;
			bufferNum = 0;
			var re:RegExp = new RegExp("start=");
			_isDrag = re.test(url)?true:false;
			if(_isWriteLog) {
				LogManager.msg("段号：" + _clipNo + " 最终播放地址：" + url);
			}
			clearCdnTimeout(false);
			var limit:int = 0;
			if(_hasP2P) {
				limit = _p2pTimeLimit;
			} else if(_is200) {
				limit = _cdn200TimeLimit;
			} else {
				limit = _cdn301TimeLimit;
			}
			
			_cdnTimeoutId = setTimeout(function():void {
				close();
				dispatchEvent(new NetStatusEvent(NetStatusEvent.NET_STATUS,false,false,{"code":"CDNTimeout"}));
			},limit * 1000);
		}
		
		override public function close() : void {
			this.close1();
			super.close();
		}
		
		public function get ppwebNs() : NetStream {
			return this._netstream;
		}
		
		override public function pause() : void {
			_isPlay = false;
			this.pause1();
		}
		
		override public function resume() : void {
			_isPlay = true;
			this.resume1();
		}
	}
}
