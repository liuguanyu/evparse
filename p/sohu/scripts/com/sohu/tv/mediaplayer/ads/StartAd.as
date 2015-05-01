package com.sohu.tv.mediaplayer.ads {
	import ebing.net.LoaderUtil;
	import com.sohu.tv.mediaplayer.net.TvSohuURLLoaderUtil;
	import flash.net.SharedObject;
	import flash.media.SoundTransform;
	import com.sohu.tv.mediaplayer.ui.SoundIcon;
	import flash.display.*;
	import flash.text.*;
	import com.adobe.images.*;
	import com.sohu.tv.mediaplayer.stat.*;
	import com.sohu.tv.mediaplayer.video.*;
	import flash.events.*;
	import flash.utils.*;
	import ebing.Utils;
	import ebing.events.MediaEvent;
	import ebing.net.JSON;
	import com.sohu.tv.mediaplayer.PlayerConfig;
	import com.sohu.tv.mediaplayer.p2p.P2PExplorer;
	import flash.external.ExternalInterface;
	import ebing.external.Eif;
	import ebing.net.URLLoaderUtil;
	
	public class StartAd extends EventDispatcher implements IAds {
		
		public function StartAd(param1:Object) {
			super();
			this._owner = this;
			this.hardInit(param1);
		}
		
		public static const TO_HAS_SOUND_ICON:String = "to_has_sound_icon";
		
		public static const TO_NO_SOUND_ICON:String = "to_no_sound_icon";
		
		public static const CHECK_ADS_TIME:String = "http://v.aty.sohu.com/ct";
		
		public static function drawCloseBtn(param1:Number, param2:uint, param3:uint) : Sprite {
			var _loc4_:Number = int(param1 / 5);
			var _loc5_:Number = param1 / 2;
			var _loc6_:Number = _loc5_;
			var _loc7_:int = int(param1 / 5);
			var _loc8_:Sprite = new Sprite();
			var _loc9_:TextField = new TextField();
			var _loc10_:TextFormat = new TextFormat();
			_loc10_.color = param3;
			_loc10_.size = 12;
			_loc9_.autoSize = TextFieldAutoSize.LEFT;
			_loc9_.defaultTextFormat = _loc10_;
			_loc9_.selectable = false;
			_loc9_.text = "付费去广告";
			_loc9_.x = 5;
			_loc8_.addChild(_loc9_);
			_loc8_.graphics.beginFill(4473924,0);
			_loc8_.graphics.drawRect(0,0,_loc8_.width,_loc8_.height);
			_loc8_.graphics.endFill();
			return _loc8_;
		}
		
		private static function drawSquareCloseBtn(param1:Number, param2:uint, param3:uint, param4:int) : Sprite {
			var _loc5_:Number = int(param1 / 5);
			var _loc6_:Number = param1 / 2;
			var _loc7_:Number = _loc6_;
			var _loc8_:int = int(param1 / 5);
			var _loc9_:Sprite = new Sprite();
			var _loc10_:Sprite = new Sprite();
			_loc10_.graphics.beginFill(param2,0);
			_loc10_.graphics.drawCircle(_loc7_,_loc7_,_loc6_);
			_loc10_.graphics.endFill();
			_loc10_.graphics.lineStyle(_loc5_,param3,1,false,"normal",CapsStyle.NONE);
			_loc10_.graphics.moveTo(_loc8_,_loc8_);
			_loc10_.graphics.lineTo(param1 - _loc8_,param1 - _loc8_);
			_loc10_.graphics.moveTo(_loc8_,param1 - _loc8_);
			_loc10_.graphics.lineTo(param1 - _loc8_,_loc8_);
			_loc9_.addChild(_loc10_);
			_loc10_.y = (_loc9_.height - _loc10_.height) / 2;
			_loc9_.graphics.beginFill(param2,param4);
			_loc9_.graphics.drawRect(0,0,_loc9_.width,_loc9_.height);
			_loc9_.graphics.endFill();
			return _loc9_;
		}
		
		protected var _adPath:String = "";
		
		protected var _adStatUrl:String;
		
		protected var _adClickUrl:String;
		
		protected var _adList:Array;
		
		protected var _currentIndex:uint;
		
		protected var _downloadIndex:uint;
		
		protected var _width:Number;
		
		protected var _height:Number;
		
		protected var _container:Sprite;
		
		protected var _swfAdLoader:LoaderUtil;
		
		protected var _state:String = "no";
		
		protected var _owner:StartAd;
		
		protected var _adNowTime:uint;
		
		protected var _adTotTime:uint;
		
		protected var _adTimeout:uint = 0;
		
		protected var _adPlayError:uint = 0;
		
		protected var _adDownloadError:uint = 0;
		
		protected var _interVarId:Number;
		
		protected var _temTime:uint;
		
		protected var _statSender:TvSohuURLLoaderUtil;
		
		protected var _isShown:Boolean = false;
		
		protected var _countText:TextField;
		
		protected var _countDown:Sprite;
		
		private var _isDispatchEvent:Boolean;
		
		private var _hasAd:Boolean = false;
		
		private var _volume:Number = 0;
		
		private var _so:SharedObject;
		
		private var _soundTransform:SoundTransform;
		
		private var _adTimeoutId:Number = 0;
		
		private var _adBeginTime:uint = 0;
		
		protected var _closeBtnUp:Sprite;
		
		protected var _closeBtnOver:Sprite;
		
		protected var _close_btn:Sprite;
		
		protected var _removeAdMc:Sprite;
		
		private var _iFoxPanel;
		
		private var _isMute:Boolean;
		
		private var _tempTimer1:Number = 0;
		
		private var _tempTimer2:Number = 0;
		
		private var _isAutoPlayAd:Boolean;
		
		private var _isAdSelect:Boolean = false;
		
		private var _isVpaidAd:Boolean = false;
		
		private var _isPIPAd:Boolean = false;
		
		private var _isNoDetailClasss:Boolean = false;
		
		private var soundIcon:SoundIcon;
		
		private var _isAdTip:Boolean = false;
		
		private var _adTipContainer:Sprite;
		
		private var _adTipCloseBtn:Sprite;
		
		private var _adTipTimeout:Number = 0;
		
		private var _tipBg:Sprite;
		
		private var _tipTxt:TextField;
		
		private var _isFinishLoaded:Boolean = false;
		
		private var _isFFSendPQ:Boolean = false;
		
		private var _skipAdsTime:Number = 0;
		
		private var _skipAdsDuration:Number = 0;
		
		private var _isAdPlay:Boolean = false;
		
		private var _endTime:uint = 0;
		
		private var _ebt:String = "";
		
		private var _btnUi:ButtonUi;
		
		private var _bitUi:BitUi;
		
		public var ADS_VM_PATH:String = "";
		
		private var _isCheckAdPlay:Boolean = false;
		
		public function hardInit(param1:Object) : void {
			this._width = param1.width;
			this._height = param1.height;
			this.sysInit("start");
		}
		
		public function get container() : Sprite {
			return this._container;
		}
		
		public function set container(param1:Sprite) : void {
			this._container = param1;
		}
		
		protected function initAdList(param1:Object, param2:uint) : void {
			var tem:Array = null;
			var funObj:Object = null;
			var json:Object = param1;
			var i:uint = param2;
			this._adList[i] = {
				"adPath":"",
				"duration":"",
				"adClickUrl":"",
				"adStatUrl":"",
				"adClickStatUrl":"",
				"adPlayOverStatUrl":"",
				"func":null,
				"adSfunc":null,
				"adEfunc":null,
				"adArrPB":null,
				"isExcluded":false,
				"callTime":null,
				"adType":"",
				"playState":"no",
				"loadState":"no",
				"ad":null,
				"hitArea":new MovieClip(),
				"detail":new Sprite(),
				"errTip":new Sprite()
			};
			this._adList[i].adPath = json[i][0];
			this._adList[i].adType = Utils.getType(json[i][0].split("?")[0],".");
			this._adList[i].duration = json[i][1];
			this._adList[i].hasSound = true;
			this._adList[i].thirdAds = "";
			this._adList[i].startLoadTime = this._adList[i].endLoadTime = 0;
			this._adList[i].startPlayTime = this._adList[i].endPlayTime = 0;
			this._adList[i].adStartTime = this._adList[i].adPlayedTime2 = 0;
			this._adList[i].errtype = "";
			this._adList[i].isLoadErr = false;
			this._adList[i].isSendPQ = false;
			this._adList[i].isSendAdPlayStock = false;
			this._adList[i].isSendAdStopStock = false;
			if(json[i].length >= 3 && !(json[i][2] == null) && !(json[i][2] == "")) {
				this._adList[i].adClickUrl = json[i][2];
			}
			if(json[i].length >= 4 && !(json[i][3] == null) && !(json[i][3] == "")) {
				this._adList[i].adStatUrl = json[i][3];
			}
			if(json[i].length >= 5 && !(json[i][4] == null) && !(json[i][4] == "")) {
				tem = json[i][4].split("|");
				this._adList[i].func = tem[0];
				tem.shift();
				this._adList[i].callTime = tem.length == 0?[0]:tem;
			}
			if(json[i].length >= 6 && !(json[i][5] == null) && !(json[i][5] == "")) {
				this._adList[i].adPlayOverStatUrl = json[i][5];
			}
			if(json[i].length >= 7 && !(json[i][6] == null) && !(json[i][6] == "")) {
				this._adList[i].adClickStatUrl = json[i][6];
			}
			if(json[i].length >= 8 && !(json[i][7] == null) && !(json[i][7] == "")) {
				this._adList[i].hasSound = json[i][7] == "0"?false:true;
			}
			if(json[i].length >= 9 && !(json[i][8] == null) && !(json[i][8] == "")) {
				this._adList[i].thirdAds = json[i][8];
			}
			if(json[i].length >= 10 && !(json[i][9] == null) && !(json[i][9] == "")) {
				funObj = Object(json[i][9]);
				if(!(funObj.sfunc == null) && !(funObj.sfunc == "")) {
					this._adList[i].adSfunc = funObj.sfunc;
				}
				if(!(funObj.efunc == null) && !(funObj.efunc == "")) {
					this._adList[i].adEfunc = funObj.efunc;
				}
			}
			if(json[i].length >= 11 && !(json[i][10] == null) && !(json[i][10] == "")) {
				if(json[i][10] == "1") {
					this._isAdSelect = true;
				} else if(json[i][10] == "2") {
					this._isVpaidAd = true;
				} else if(json[i][10] == "3") {
					this._isPIPAd = true;
				}
				
				
			}
			if(json[i].length >= 12 && !(json[i][11] == null) && !(json[i][11] == "")) {
				this._adList[i].adArrPB = json[i][11];
			}
			if(json[i].length >= 13 && !(json[i][12] == null) && !(json[i][12] == "") && json[i][12] == "1") {
				this._adList[i].isExcluded = true;
			}
			this._adTotTime = this._adTotTime + this._adList[i].duration;
			this._adList[i].hitArea.index = i;
			Utils.drawRect(this._adList[i].hitArea,1,1,this._width,this._height,16777215,0);
			this._adList[i].hitArea.buttonMode = true;
			this._adList[i].hitArea.addEventListener(MouseEvent.CLICK,this.adClickHandler);
			if(this._adList[i].adType == "swf") {
				try {
					this._adList[i].ad = new TvSohuFlashCore({
						"width":this._width,
						"height":this._height,
						"limitTime":(this._isVpaidAd?15:5),
						"isVpaidAd":this._isVpaidAd,
						"index":i,
						"isPIPAd":this._isPIPAd,
						"isThirdAds":this._adList[i].thirdAds
					});
				}
				catch(evt:*) {
				}
			} else {
				try {
					this._adList[i].ad = new TvSohuSimpleVideoCore({
						"width":this._width,
						"height":this._height,
						"buffer":1,
						"limitTime":5,
						"index":i
					});
				}
				catch(evt:*) {
				}
			}
			if(this._adList[i].adType == "swf") {
				this._adList[i].ad.softInit({
					"url":this._adList[i].adPath,
					"time":this._adList[i].duration * 1000
				});
				this._adList[i].ad.addEventListener(MediaEvent.LOAD_PROGRESS,this.adLoadProgress);
				this._adList[i].ad.addEventListener(MediaEvent.STOP,this.adStop);
				this._adList[i].ad.addEventListener(MediaEvent.START,this.adStart);
				this._adList[i].ad.addEventListener(MediaEvent.PLAYED,this.adPlayed);
				this._adList[i].ad.addEventListener(MediaEvent.NOTFOUND,this.adLoadError);
				this._adList[i].ad.addEventListener(MediaEvent.CONNECT_TIMEOUT,this.adConnectTimeOut);
				this._adList[i].ad.addEventListener(MediaEvent.PLAY_ABEND,this.adPlayError);
				this._adList[i].ad.visible = false;
				this._adList[i].hitArea.visible = false;
				this._adList[i].detail.visible = false;
				this._adList[i].errTip = new LoadAdErrorTip({
					"url":this._adList[i].adPath,
					"time":this._adList[i].duration,
					"width":this._width,
					"height":this._height,
					"index":i
				});
				this._adList[i].errTip.addEventListener(MediaEvent.STOP,this.adStop);
				this._adList[i].errTip.addEventListener(MediaEvent.START,this.adStart);
				this._adList[i].errTip.addEventListener(MediaEvent.PLAY_PROGRESS,this.adPlayProgress);
				this._adList[i].errTip.addEventListener(MediaEvent.LOAD_PROGRESS,this.adLoadProgress);
				if(this._adList[i].adType == "swf") {
					if(this._isPIPAd) {
						this._adList[i].ad.loadSwf();
						this._adList[i].ad.visible = true;
					}
					this._adList[i].ad.addEventListener("allowFlash",function(param1:Event):void {
						_adList[i].hitArea.visible = false;
					});
					this._adList[i].ad.addEventListener("ad_click",function(param1:Event):void {
						_adList[i].hitArea.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
					});
					this._adList[i].ad.addEventListener("pauseFlash",function(param1:Event):void {
						_adList[i].ad.pause();
						stopTimeOut();
					});
					this._adList[i].ad.addEventListener("resumeFlash",function(param1:Event):void {
						_adList[i].ad.swfStart();
						startTimeOut();
					});
					this._adList[i].ad.addEventListener("closeFlash",function(param1:Event):void {
						if(_adList[i].playState != "end") {
							if(_adList[i].adStartTime > 0) {
								_skipAdsTime = _skipAdsTime + (new Date().getTime() - _adList[i].adStartTime);
							}
							_skipAdsDuration = _skipAdsDuration + _adList[i].duration;
							_adList[i].playState = "end";
						}
					});
				}
				this._container.addChild(this._adList[i].ad);
				this._container.addChild(this._adList[i].detail);
				this._container.addChild(this._adList[i].hitArea);
				this._container.addChild(this._adList[i].errTip);
				if(this._adList[i].adPath != "") {
					AdLog.msg("第 " + i + " 广告地址：" + this._adList[i].adPath + "：：时长：" + this._adList[i].duration + "：：" + (this._adList[i].hasSound?"有声广告":"无声广告") + "：：是否排斥控制栏广告 ： " + (this._adList[i].isExcluded?"yes":"no") + "  ");
				} else {
					AdLog.msg("第 " + i + " 空广告" + "：：" + (this._adList[i].hasSound?"有声广告":"无声广告") + "：：是否排斥控制栏广告 ： " + (this._adList[i].isExcluded?"yes":"no") + "  ");
				}
				return;
			}
			this._adList[i].ad.softInit({
				"url":this._adList[i].adPath,
				"time":this._adList[i].duration * 1000
			});
			this._adList[i].ad.addEventListener(MediaEvent.LOAD_PROGRESS,this.adLoadProgress);
			this._adList[i].ad.addEventListener(MediaEvent.STOP,this.adStop);
			this._adList[i].ad.addEventListener(MediaEvent.START,this.adStart);
			this._adList[i].ad.addEventListener(MediaEvent.PLAYED,this.adPlayed);
			this._adList[i].ad.addEventListener(MediaEvent.NOTFOUND,this.adLoadError);
			this._adList[i].ad.addEventListener(MediaEvent.CONNECT_TIMEOUT,this.adConnectTimeOut);
			this._adList[i].ad.addEventListener(MediaEvent.PLAY_ABEND,this.adPlayError);
			this._adList[i].ad.visible = false;
			this._adList[i].hitArea.visible = false;
			this._adList[i].detail.visible = false;
			this._adList[i].errTip = new LoadAdErrorTip({
				"url":this._adList[i].adPath,
				"time":this._adList[i].duration,
				"width":this._width,
				"height":this._height,
				"index":i
			});
			this._adList[i].errTip.addEventListener(MediaEvent.STOP,this.adStop);
			this._adList[i].errTip.addEventListener(MediaEvent.START,this.adStart);
			this._adList[i].errTip.addEventListener(MediaEvent.PLAY_PROGRESS,this.adPlayProgress);
			this._adList[i].errTip.addEventListener(MediaEvent.LOAD_PROGRESS,this.adLoadProgress);
			if(this._adList[i].adType == "swf") {
				if(this._isPIPAd) {
					this._adList[i].ad.loadSwf();
					this._adList[i].ad.visible = true;
				}
				this._adList[i].ad.addEventListener("allowFlash",function(param1:Event):void {
					_adList[i].hitArea.visible = false;
				});
				this._adList[i].ad.addEventListener("ad_click",function(param1:Event):void {
					_adList[i].hitArea.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
				});
				this._adList[i].ad.addEventListener("pauseFlash",function(param1:Event):void {
					_adList[i].ad.pause();
					stopTimeOut();
				});
				this._adList[i].ad.addEventListener("resumeFlash",function(param1:Event):void {
					_adList[i].ad.swfStart();
					startTimeOut();
				});
				this._adList[i].ad.addEventListener("closeFlash",function(param1:Event):void {
					if(_adList[i].playState != "end") {
						if(_adList[i].adStartTime > 0) {
							_skipAdsTime = _skipAdsTime + (new Date().getTime() - _adList[i].adStartTime);
						}
						_skipAdsDuration = _skipAdsDuration + _adList[i].duration;
						_adList[i].playState = "end";
					}
				});
			}
			this._container.addChild(this._adList[i].ad);
			this._container.addChild(this._adList[i].detail);
			this._container.addChild(this._adList[i].hitArea);
			this._container.addChild(this._adList[i].errTip);
			if(this._adList[i].adPath != "") {
				AdLog.msg("第 " + i + " 广告地址：" + this._adList[i].adPath + "：：时长：" + this._adList[i].duration + "：：" + (this._adList[i].hasSound?"有声广告":"无声广告") + "：：是否排斥控制栏广告 ： " + (this._adList[i].isExcluded?"yes":"no") + "  ");
			} else {
				AdLog.msg("第 " + i + " 空广告" + "：：" + (this._adList[i].hasSound?"有声广告":"无声广告") + "：：是否排斥控制栏广告 ： " + (this._adList[i].isExcluded?"yes":"no") + "  ");
			}
		}
		
		public function set detailClass(param1:Class) : void {
			var _loc3_:Sprite = null;
			var _loc2_:uint = 0;
			while(_loc2_ < this._adList.length) {
				_loc3_ = new param1();
				if((this._isNoDetailClasss) || (this._isVpaidAd) || (this._isPIPAd)) {
					_loc3_.visible = false;
				} else {
					_loc3_.visible = true;
				}
				this._adList[_loc2_].detail.addChild(_loc3_);
				_loc2_++;
			}
			this.resize(this._width,this._height);
		}
		
		public function set isNoDetailClasss(param1:Boolean) : void {
			this._isNoDetailClasss = param1;
		}
		
		public function set isAdTip(param1:Boolean) : void {
			this._isAdTip = param1;
		}
		
		private function showAdTip() : void {
			var _loc1_:TextFormat = new TextFormat();
			_loc1_.size = 14;
			_loc1_.leading = 10;
			_loc1_.font = "宋体";
			_loc1_.align = TextFormatAlign.LEFT;
			this._tipBg = new Sprite();
			Utils.drawRect(this._tipBg,0,0,this._width,30,0,0.6);
			this._adTipContainer.addChild(this._tipBg);
			this._tipTxt = new TextField();
			this._tipTxt.height = 20;
			this._tipTxt.y = this._tipTxt.x = 5;
			this._tipTxt.text = "因版权原因，该剧暂时不能跳过广告，我们正在积极解决。";
			this._tipTxt.setTextFormat(_loc1_);
			this._tipTxt.textColor = 15132390;
			this._adTipContainer.addChild(this._tipTxt);
			this._adTipCloseBtn = new Sprite();
			var _loc2_:Sprite = new Sprite();
			var _loc3_:Sprite = new Sprite();
			_loc2_ = drawSquareCloseBtn(15,0,10461087,0);
			_loc3_ = drawSquareCloseBtn(15,16711680,16777215,1);
			_loc2_.name = "btnUp";
			_loc3_.name = "btnOver";
			this._adTipCloseBtn.addChild(_loc2_);
			this._adTipCloseBtn.addChild(_loc3_);
			this._adTipCloseBtn.addEventListener(MouseEvent.MOUSE_OVER,this.tipCloseBtnOver);
			this._adTipCloseBtn.addEventListener(MouseEvent.MOUSE_OUT,this.tipCloseBtnOut);
			this._adTipCloseBtn.addEventListener(MouseEvent.MOUSE_UP,this.tipCloseBtnUp);
			Utils.setCenter(this._adTipCloseBtn,this._tipBg);
			this._adTipCloseBtn.dispatchEvent(new MouseEvent(MouseEvent.MOUSE_OUT));
			this._adTipCloseBtn.buttonMode = true;
			this._adTipCloseBtn.useHandCursor = true;
			this._adTipCloseBtn.mouseChildren = false;
			this._adTipContainer.addChild(this._adTipCloseBtn);
			this.resizeAdTip();
		}
		
		public function softInit(param1:Object) : void {
			var json:Object = null;
			var i:uint = 0;
			var obj:Object = param1;
			this._tempTimer1 = new Date().getTime();
			var startAdPar:String = obj.adPar;
			if((startAdPar == "") && (obj.selectedVideo) && !(obj.selectedVideo == null)) {
				startAdPar = "[]";
			}
			if(startAdPar != "") {
				try {
					json = new ebing.net.JSON().parse(startAdPar.replace(new RegExp("\'","g"),"\""));
					if((obj.selectedVideo) && !(obj.selectedVideo == null)) {
						json.unshift(obj.selectedVideo);
					}
					json = json.filter(function(param1:*, param2:int, param3:Array):Boolean {
						if(param1.length >= 8 && !(param1[7] == null) && !(param1[7] == "")) {
							return !TvSohuAds.getInstance().isFrequencyLimit(param1[7]);
						}
						return true;
					});
					i = 0;
					while(i < json.length) {
						this.initAdList(json,i);
						i++;
					}
					this._container.addChild(this._countDown);
					this._countDown.visible = false;
					this._container.addChild(this._adTipContainer);
					this._adTipContainer.visible = false;
				}
				catch(evt:*) {
					ErrorSenderPQ.getInstance().sendPQStat({
						"error":PlayerConfig.ADINFO_PARSE_ERROR,
						"code":PlayerConfig.REALVV_CODE
					});
				}
			}
			if(startAdPar != "") {
				return;
			}
		}
		
		protected function adClickHandler(param1:MouseEvent) : void {
			var _loc2_:String = this._adList[param1.target["index"]].adClickUrl;
			if(_loc2_ != "") {
				Utils.openWindow(_loc2_);
			}
			this._statSender.multiSend(this._adList[param1.target["index"]].adClickStatUrl);
		}
		
		protected function sysInit(param1:String = null) : void {
			if(param1 == "start") {
				this.newFunc();
				this.drawSkin();
				this.addEvent();
			}
			this._adNowTime = this._adTotTime = this._adTimeout = this._adPlayError = this._adDownloadError = this._skipAdsTime = this._skipAdsDuration = this._endTime = 0;
			this._state = "no";
			this._hasAd = false;
			var _loc2_:uint = 0;
			while(_loc2_ < this._adList.length) {
				this._adList[_loc2_].adSfunc = null;
				this._adList[_loc2_].adEfunc = null;
				_loc2_++;
			}
			this._isAdSelect = this._isFFSendPQ = this._isAdPlay = this._isPIPAd = this._isVpaidAd = this._isCheckAdPlay = false;
		}
		
		protected function drawSkin() : void {
			this._countDown = new Sprite();
			this._adTipContainer = new Sprite();
			var _loc1_:Sprite = new Sprite();
			Utils.drawRoundRect(_loc1_,0,0,120,20,5,0,0.8);
			this._countText = new TextField();
			this._countText.textColor = 16777215;
			this._countText.autoSize = TextFieldAutoSize.LEFT;
			this._countText.x = 5;
			this._countText.y = 0.2;
			_loc1_.addChild(this._countText);
			this.soundIcon = new SoundIcon();
			this.soundIcon.x = _loc1_.width - this.soundIcon.width - 3;
			this.soundIcon.y = _loc1_.height - this.soundIcon.height - 2.5;
			_loc1_.addChild(this.soundIcon);
			this.soundIcon.addEventListener(MouseEvent.MOUSE_DOWN,this.soundIconClickHandler);
			this._removeAdMc = new Sprite();
			Utils.drawRoundRect(this._removeAdMc,0,0,75,20,5,0,0.8);
			this._close_btn = new Sprite();
			this._closeBtnUp = drawCloseBtn(15,0,16777215);
			this._closeBtnOver = drawCloseBtn(15,0,16711680);
			this._close_btn.addChild(this._closeBtnUp);
			this._close_btn.addChild(this._closeBtnOver);
			this._closeBtnOver.visible = false;
			this._close_btn.buttonMode = this._close_btn.useHandCursor = true;
			this._close_btn.mouseChildren = false;
			this._close_btn.visible = true;
			this._close_btn.addEventListener(MouseEvent.MOUSE_OVER,this.mouseOverHandler);
			this._close_btn.addEventListener(MouseEvent.MOUSE_OUT,this.mouseOutHandler);
			this._close_btn.addEventListener(MouseEvent.MOUSE_UP,this.mouseUpHandler);
			this._close_btn.y = (this._removeAdMc.height - this._close_btn.height) / 2 - 0.5;
			this._removeAdMc.addChild(this._close_btn);
			this._removeAdMc.x = _loc1_.width + 5;
			this._countDown.addChild(_loc1_);
			this._countDown.addChild(this._removeAdMc);
			this.resize(this._width,this._height);
		}
		
		protected function mouseOverHandler(param1:MouseEvent) : void {
			this._closeBtnOver.visible = true;
			this._closeBtnUp.visible = false;
		}
		
		protected function mouseOutHandler(param1:MouseEvent) : void {
			this._closeBtnOver.visible = false;
			this._closeBtnUp.visible = true;
		}
		
		public function pause() : void {
			if((this._adList[this._currentIndex].errTip.errStatusSp.visible) && this._adList[this._currentIndex].errTip.tipFlagState == "play") {
				this._adList[this._currentIndex].errTip.pause();
			} else {
				this._adList[this._currentIndex].ad.pause();
			}
			this.stopTimeOut();
		}
		
		public function resume() : void {
			if((this._adList[this._currentIndex].errTip.errStatusSp.visible) && this._adList[this._currentIndex].errTip.tipFlagState == "pause") {
				this._adList[this._currentIndex].errTip.reStart();
			} else if(this._adList[this._currentIndex].adType == "swf") {
				this._adList[this._currentIndex].ad.swfStart();
			} else {
				this._adList[this._currentIndex].ad.play();
			}
			
			this.startTimeOut();
		}
		
		protected function mouseUpHandler(param1:MouseEvent) : void {
			param1.target.buttonMode = param1.target.useHandCursor = false;
			this._close_btn.removeEventListener(MouseEvent.MOUSE_UP,this.mouseUpHandler);
			this.pause();
			this.showIFoxPanel();
			SendRef.getInstance().sendPQ("PL_S_CloseAD");
			dispatchEvent(new Event("openIFoxPanel"));
		}
		
		public function resetPlay() : void {
			this.resume();
			this._close_btn.buttonMode = this._close_btn.useHandCursor = true;
			this._close_btn.addEventListener(MouseEvent.MOUSE_UP,this.mouseUpHandler);
		}
		
		public function showIFoxPanel(param1:* = null) : void {
			var evt:* = param1;
			if(this._iFoxPanel == null) {
				new LoaderUtil().load(10,function(param1:Object):void {
					var obj:Object = param1;
					if(obj.info == "success") {
						_iFoxPanel = obj.data.content;
						_container.addChild(_iFoxPanel);
						_iFoxPanel.init(P2PExplorer.getInstance().hasP2P);
						_iFoxPanel.addEventListener("closeIFoxPanel",function(param1:Event):void {
							resetPlay();
						});
						_iFoxPanel.addEventListener("close_startAd",function(param1:Event):void {
							close();
							dispatch(TvSohuAdsEvent.SCREENFINISH);
						});
						resize(_width,_height);
						showIFoxPanel();
					} else {
						resetPlay();
					}
				},null,PlayerConfig.swfHost + "panel/IFoxPanelLogin.swf");
			} else if(this._iFoxPanel.isOpen) {
				this._iFoxPanel.close();
			} else {
				this._container.setChildIndex(this._iFoxPanel,this._container.numChildren - 1);
				this._iFoxPanel.open();
			}
			
		}
		
		protected function adPlayProgress(param1:MediaEvent) : void {
			var nowTime:Number = NaN;
			var b:Number = NaN;
			var t:Number = NaN;
			var i:uint = 0;
			var arr:Array = null;
			var k:int = 0;
			var evt:MediaEvent = param1;
			if(evt.obj.nowTime != 0) {
				if(!this._isAdPlay) {
					this._isAdPlay = true;
					this._adList[this._currentIndex].adStartTime = new Date().getTime();
				}
				if(this._adList[this._currentIndex].startPlayTime == 0) {
					this._adList[this._currentIndex].startPlayTime = getTimer();
				}
				this._adList[this._currentIndex].adPlayedTime2 = evt.obj.nowTime;
				nowTime = this._adNowTime + evt.obj.nowTime;
				b = Math.ceil(this._adTotTime - nowTime);
				t = b < 0?0:b;
				if(!this._isAdSelect && !this._isVpaidAd && !this._isPIPAd) {
					this._countText.selectable = false;
					this._countText.htmlText = "广告剩余 " + "<font color=\'#ff0000\' size=\'13\' face=\'宋体\'><B>" + (String(t).length == 1?"0" + t:t) + "</B></font>" + " 秒";
					this._countDown.visible = true;
				}
				if(this._isAdTip) {
					this._isAdTip = false;
					this.showAdTip();
					this._removeAdMc.visible = this._close_btn.visible = false;
					this._adTipContainer.visible = true;
					this._container.setChildIndex(this._adTipContainer,this._container.numChildren - 1);
					this.resize(this._width,this._height);
					this._adTipTimeout = setTimeout(function():void {
						clearTimeout(_adTipTimeout);
						_adTipContainer.visible = false;
					},1000 * 20);
				}
				this.dispatch(TvSohuAdsEvent.SCREEN_PLAY_PROGRESS,{
					"isSeek":false,
					"nowTime":nowTime,
					"totTime":this._adTotTime
				});
				this.adPingback();
				if((ExternalInterface.available) && !(this._adList[this._currentIndex].func == null)) {
					i = 0;
					while(i < this._adList[this._currentIndex].callTime.length) {
						if(evt.obj.nowTime >= this._adList[this._currentIndex].callTime[i]) {
							ExternalInterface.call(this._adList[this._currentIndex].func,Math.round(evt.obj.nowTime));
							this._adList[this._currentIndex].callTime.splice(i,1);
							break;
						}
						i++;
					}
				}
				if(this._adList[this._currentIndex].adArrPB != null) {
					arr = this._adList[this._currentIndex].adArrPB;
					k = 0;
					while(k < arr.length) {
						if(evt.obj.nowTime >= Number(arr[k].t)) {
							AdLog.msg("第 " + this._currentIndex + " 广告：" + arr);
							AdLog.msg("上报地址：" + arr[k].v);
							this._statSender.multiSend(arr[k].v);
							arr.splice(k,1);
							break;
						}
						k++;
					}
				}
			}
		}
		
		protected function adStart(param1:MediaEvent) : void {
			this._adList[this._downloadIndex].endLoadTime = getTimer() - this._adList[this._downloadIndex].startLoadTime;
			if(!this._isShown) {
				this._isShown = true;
				this.dispatch(TvSohuAdsEvent.SCREENSHOWN);
			}
		}
		
		protected function adPlayed(param1:MediaEvent) : void {
			this._tempTimer2 = new Date().getTime();
			if(this._currentIndex == 0) {
				if(!(this._adList[this._currentIndex].adPath == "") && !(this._tempTimer1 == 0)) {
					PlayerConfig.adgetSpend = this._tempTimer2 - this._tempTimer1;
				} else {
					PlayerConfig.adgetSpend = -1;
				}
			}
			this._tempTimer1 = this._tempTimer2 = 0;
		}
		
		protected function addEvent() : void {
		}
		
		protected function adLoadProgress(param1:MediaEvent) : void {
			if(param1.obj.nowSize >= param1.obj.totSize) {
				if(this._adList[this._downloadIndex].loadState != "end") {
					this.adLoaded();
				}
			}
		}
		
		protected function adLoaded() : void {
			this._adList[this._downloadIndex].loadState = "end";
			this._adList[this._downloadIndex].ad.removeEventListener(MediaEvent.LOAD_PROGRESS,this.adLoadProgress);
			PlayerConfig.startAdLoadTime = getTimer() - this._adBeginTime;
			if(this._downloadIndex < this._adList.length - 1) {
				AdLog.msg(this._downloadIndex + 1 + " :: downloadAd");
				this.downloadAd(this._downloadIndex + 1);
			} else {
				AdLog.msg(" :: TvSohuAdsEvent.START_AD_LOADED");
				if(!this._isFinishLoaded) {
					this.dispatch(TvSohuAdsEvent.START_AD_LOADED);
					this._isFinishLoaded = true;
				}
			}
		}
		
		protected function adLoadError(param1:MediaEvent) : void {
			var _loc2_:int = param1.target.id;
			this._adList[_loc2_].isLoadErr = true;
			AdLog.msg(_loc2_ + " :: adLoadError : evt.type : " + param1.type + "   ::  playState   ::   " + this._adList[_loc2_].playState);
			param1.target.removeEventListener(MediaEvent.STOP,this.adStop);
			param1.target.removeEventListener(MediaEvent.CONNECT_TIMEOUT,this.adConnectTimeOut);
			param1.target.removeEventListener(MediaEvent.PLAY_ABEND,this.adPlayError);
			this._adList[this._downloadIndex].errtype = param1.type;
			this._adList[this._downloadIndex].errTip.loadTip();
			if(this._adList[_loc2_].playState == "playing") {
				AdLog.msg(_loc2_ + " :: errTip.play()");
				this._adList[_loc2_].errTip.play();
			}
			this.sendAdPQ(this._downloadIndex);
		}
		
		protected function adConnectTimeOut(param1:MediaEvent) : void {
			AdLog.msg(this._downloadIndex + "：ConnectTimeOut ");
			this._adList[this._downloadIndex].errtype = param1.type;
			this._adTimeout = this._adTimeout + this._adList[this._downloadIndex].duration;
			if(this._adList[this._downloadIndex].playState == "playing" || this._adList[this._downloadIndex].playState == "end") {
				this.adStop();
			}
			this.sendAdPQ(this._downloadIndex);
		}
		
		protected function adPlayError(param1:MediaEvent) : void {
			AdLog.msg(this._currentIndex + "：PlayError：evt.type：" + param1.type);
			this._adList[this._currentIndex].errtype = param1.type + "_pt:" + param1.obj.playedTime + "-tt:" + param1.obj.totTime;
			this._adPlayError = this._adPlayError + this._adList[this._currentIndex].duration;
			if(this._adList[this._currentIndex].playState == "playing") {
				this.adStop();
			}
		}
		
		protected function adStop(param1:MediaEvent = null) : void {
			var _loc2_:Array = null;
			var _loc3_:* = 0;
			this._adList[this._currentIndex].errtype = param1 != null?param1.type + ":" + param1.obj.mask:this._adList[this._currentIndex].errtype;
			if(!(this._adList[this._currentIndex].errtyp == null) && this._adList[this._currentIndex].errtype == MediaEvent.STOP && Math.abs(this._adList[this._currentIndex].ad.fileTotTime - this._adList[this._currentIndex].duration) > 3) {
				this._adList[this._currentIndex].errtype = "downloadError";
				this._adDownloadError = this._adDownloadError + this._adList[this._currentIndex].duration;
				AdLog.msg(this._currentIndex + "：downloadError : _adDownloadError" + this._adDownloadError);
			}
			this._adNowTime = this._adNowTime + this._adList[this._currentIndex].duration;
			this._adList[this._currentIndex].endPlayTime = getTimer();
			this._adList[this._currentIndex].ad.removeEventListener(MediaEvent.PLAY_PROGRESS,this.adPlayProgress);
			if(!(this._adList[this._currentIndex].adArrPB == null) && this._adList[this._currentIndex].adArrPB.length > 0) {
				_loc2_ = this._adList[this._currentIndex].adArrPB;
				_loc3_ = 0;
				while(_loc3_ < _loc2_.length) {
					this._statSender.multiSend(_loc2_[_loc3_].v);
					_loc2_.splice(_loc3_,1);
					_loc3_++;
				}
			}
			this.sendAdPQ(this._currentIndex);
			this._adList[this._currentIndex].ad.visible = false;
			this._adList[this._currentIndex].detail.visible = false;
			this._adList[this._currentIndex].hitArea.visible = false;
			this._adList[this._currentIndex].playState = "end";
			if(this._currentIndex < this._adList.length - 1) {
				this.sendAdStopStock(this._currentIndex);
				if(!(this._adList[this._currentIndex].adPlayOverStatUrl == "") && !(this._adList[this._currentIndex].adEfunc == null) && (ExternalInterface.available)) {
					ExternalInterface.call(this._adList[this._currentIndex].adEfunc,this._adList[this._currentIndex].duration,this._adList[this._currentIndex].adPlayOverStatUrl);
				} else {
					this._statSender.multiSend(this._adList[this._currentIndex].adPlayOverStatUrl);
				}
				AdLog.msg(this._currentIndex + 1 + "：：playAd");
				this.playAd(this._currentIndex + 1);
			} else {
				if(this._currentIndex == this._adList.length - 1) {
					if(!(this._adList[this._currentIndex].adPlayOverStatUrl == "") && !(this._adList[this._currentIndex].adEfunc == null) && (ExternalInterface.available)) {
						ExternalInterface.call(this._adList[this._currentIndex].adEfunc,this._adList[this._currentIndex].duration,this._adList[this._currentIndex].adPlayOverStatUrl);
					} else {
						AdLog.msg("第" + this._currentIndex + "条" + (this._adList[this._currentIndex].adPath != ""?"有广告":"为空广告") + "：pingback : " + this._adList[this._currentIndex].adPlayOverStatUrl);
						this._statSender.multiSendAndCallBack(this._adList[this._currentIndex].adPlayOverStatUrl,this.vmCallBack);
					}
					this.sendAdStopStock(this._currentIndex);
				}
				AdLog.msg("关闭广告");
				if(!this._isFinishLoaded) {
					this.dispatch(TvSohuAdsEvent.START_AD_LOADED);
					this._isFinishLoaded = true;
				}
				this.close();
				this.dispatch(TvSohuAdsEvent.SCREENFINISH);
				this.checkAdPlayTime("finish","v.aty");
			}
		}
		
		private function sendAdPQ(param1:uint) : void {
			try {
				if(!(this._adList[param1].adPath == "") && !this._adList[param1].isSendPQ) {
					InforSender.getInstance().sendCustomMesg("http://vm.aty.sohu.com/qs?stime=" + this._adList[param1].endLoadTime + "&errtype=" + this._adList[param1].errtype + "&adtype=" + this._adList[param1].adType + "&uuid=" + PlayerConfig.uuid + "&userid=" + PlayerConfig.userId + "&totad=" + this._adList.length + "&currad=" + (param1 + 1) + "&vid=" + PlayerConfig.vid + "&out=" + PlayerConfig.domainProperty + "&type=oad" + "&adurl=" + escape(escape(this._adList[param1].adPath)) + "&pageUrl=" + escape(PlayerConfig.currentPageUrl == ""?escape(PlayerConfig.outReferer):escape(PlayerConfig.currentPageUrl)));
					this._adList[param1].isSendPQ = true;
				}
			}
			catch(evt:*) {
			}
		}
		
		protected function close() : void {
			var i:uint = 0;
			PlayerConfig.startAdPlayTime = getTimer() - this._adBeginTime;
			clearTimeout(this._adTimeoutId);
			clearTimeout(this._adTipTimeout);
			this._adTipContainer.visible = false;
			this._removeAdMc.visible = this._close_btn.visible = true;
			this._state = "end";
			this._container.visible = false;
			i = 0;
			while(i < this._adList.length) {
				this._adList[i].ad.removeEventListener(MediaEvent.LOAD_PROGRESS,this.adLoadProgress);
				this._adList[i].ad.removeEventListener(MediaEvent.PLAY_PROGRESS,this.adPlayProgress);
				this._adList[i].ad.removeEventListener(MediaEvent.STOP,this.adStop);
				this._adList[i].ad.removeEventListener(MediaEvent.START,this.adStart);
				this._adList[i].ad.removeEventListener(MediaEvent.PLAYED,this.adPlayed);
				this._adList[i].ad.removeEventListener(MediaEvent.NOTFOUND,this.adLoadError);
				this._adList[i].ad.removeEventListener(MediaEvent.CONNECT_TIMEOUT,this.adConnectTimeOut);
				this._adList[i].ad.removeEventListener(MediaEvent.PLAY_ABEND,this.adPlayError);
				this._adList[i].errTip.removeEventListener(MediaEvent.STOP,this.adStop);
				this._adList[i].errTip.removeEventListener(MediaEvent.START,this.adStart);
				this._adList[i].errTip.removeEventListener(MediaEvent.PLAY_PROGRESS,this.adPlayProgress);
				this._adList[i].errTip.removeEventListener(MediaEvent.LOAD_PROGRESS,this.adLoadProgress);
				if(this._adList[i].adType == "swf") {
					this._adList[i].ad.removeEventListener("allowFlash",function(param1:Event):void {
						_adList[i].hitArea.visible = false;
					});
					this._adList[i].ad.removeEventListener("ad_click",function(param1:Event):void {
						_adList[i].hitArea.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
					});
					this._adList[i].ad.removeEventListener("pauseFlash",function(param1:Event):void {
						_adList[i].ad.pause();
						stopTimeOut();
					});
					this._adList[i].ad.removeEventListener("resumeFlash",function(param1:Event):void {
						_adList[i].ad.swfStart();
						startTimeOut();
					});
					this._adList[i].ad.swfStop();
				} else {
					this._adList[i].ad.stop();
				}
				try {
					this._container.removeChild(this._adList[i].ad);
					this._container.removeChild(this._adList[i].detail);
					this._container.removeChild(this._adList[i].hitArea);
					this._container.removeChild(this._adList[i].errTip);
				}
				catch(evt:*) {
				}
				i++;
			}
		}
		
		public function unshiftList(param1:Array) : void {
			this._adList.unshift(new Object());
			this.initAdList([param1],0);
		}
		
		public function play() : void {
			if((Eif.available) && (ExternalInterface.available)) {
				ExternalInterface.call("showFlashGames",PlayerConfig.vid,PlayerConfig.userId,this._adTotTime);
			}
			this._currentIndex = this._downloadIndex = 0;
			PlayerConfig.startAdTime = this._adTotTime;
			this.resize(this._width,this._height);
			this._container.visible = true;
			this.startTimeOut();
			var _loc1_:String = Utils.getBrowserCookie("fee_status");
			var _loc2_:String = Utils.getBrowserCookie("fee_ifox");
			var _loc3_:String = !(_loc1_ == "") || !(_loc2_ == "") && (P2PExplorer.getInstance().hasP2P)?"&vu=" + (_loc1_ != ""?_loc1_:_loc2_):"";
			var _loc4_:* = false;
			var _loc5_:* = 0;
			while(_loc5_ < this._adList.length) {
				if(this._adList[_loc5_].adPath != "") {
					_loc4_ = true;
					break;
				}
				_loc5_++;
			}
			if(!(_loc3_ == "") && !_loc4_) {
				PlayerConfig.isVipUser = true;
			}
		}
		
		private function vmCallBack(param1:String) : void {
			AdLog.msg("vmCallBack : " + param1);
			this.ADS_VM_PATH = param1;
			this.checkAdPlayTime("finish","vm.aty");
		}
		
		protected function checkAdPlayTime(param1:String, param2:String) : void {
			var boo:Boolean = false;
			var loadPath:String = null;
			var isHasAd:Boolean = false;
			var flag:String = param1;
			var source:String = param2;
			if(!this._isCheckAdPlay) {
				this._isCheckAdPlay = true;
				boo = source == "vm.aty"?true:false;
				loadPath = boo?this.ADS_VM_PATH + "&ran=" + PlayerConfig.userId:CHECK_ADS_TIME + "?vid=" + PlayerConfig.vid + "&uid=" + PlayerConfig.userId + "&m=" + new Date().getTime();
				AdLog.msg("验证请求地址 : " + loadPath);
				isHasAd = (this._adList[this._adList.length - 1]) && !(this._adList[this._adList.length - 1].adPath == "")?true:false;
				new URLLoaderUtil().load(10,function(param1:Object):void {
					var num:uint = 0;
					var allAdTime:Number = NaN;
					var k:int = 0;
					var _adUrl:String = null;
					var _adSerTime:String = null;
					var _adPlayedTime1:String = null;
					var _adPlayedTime2:String = null;
					var i:int = 0;
					var obj:Object = param1;
					AdLog.msg("请求接口：" + source + " : : 返回状态 ： " + obj.info + " : : 返回数据：" + obj.data);
					if(obj.info == "success") {
						try {
							_endTime = boo?uint(_bitUi.decryptBase64(obj.data,[PlayerConfig.vid,PlayerConfig.userId.substr(0,8)])):uint(_btnUi.drawBar(obj.data,PlayerConfig.vid,PlayerConfig.userId.substr(0,8)));
						}
						catch(evt:*) {
							if(!boo) {
								dispatch(TvSohuAdsEvent.START_AD_ILLEGAL);
							}
							AdLog.msg("广告返回数据decoderror");
							InforSender.getInstance().sendMesg(InforSender.FF,0,"","","http://pb.hd.sohu.com.cn/hdpb.gif",0,{
								"num":"2",
								"errType":"decoderror",
								"loadType":source,
								"hasAd":isHasAd
							});
						}
						AdLog.msg("_endTime:" + _endTime + "|_ebt:" + uint(_ebt));
						num = (_endTime - uint(_ebt)) / 1000 + 3;
						allAdTime = 0;
						k = 0;
						while(k < _adList.length) {
							allAdTime = allAdTime + _adList[k].duration;
							k++;
						}
						AdLog.msg("num:" + num + "|_skipAdsTime:" + _skipAdsTime / 1000);
						AdLog.msg("allAdTime:" + allAdTime + "|_adTimeout:" + _adTimeout + "|_adPlayError:" + _adPlayError + "|_adDownloadError:" + _adDownloadError + "|_skipAdsDuration:" + _skipAdsDuration);
						if(num - _skipAdsTime / 1000 >= allAdTime - _adTimeout - _adPlayError - _adDownloadError - _skipAdsDuration) {
							AdLog.msg(num - _skipAdsTime / 1000 + "|" + (allAdTime - _adTimeout - _adPlayError - _adDownloadError - _skipAdsDuration) + "：合法！！flag : " + flag);
						} else {
							AdLog.msg(num - _skipAdsTime / 1000 + "|" + (allAdTime - _adTimeout - _adPlayError - _adDownloadError - _skipAdsDuration) + "：不合法！！flag : " + flag);
							PlayerConfig.ILLEGALMSG = "2";
							dispatch(TvSohuAdsEvent.START_AD_ILLEGAL);
							_adUrl = "";
							_adSerTime = "";
							_adPlayedTime1 = "";
							_adPlayedTime2 = "";
							i = 0;
							while(i < _adList.length) {
								if(_adList[i].adPath != "") {
									_adUrl = _adUrl + (_adList[i].adPath + "|");
									_adSerTime = _adSerTime + (_adList[i].duration + "|");
									_adPlayedTime1 = _adPlayedTime1 + ((_adList[i].endPlayTime - _adList[i].startPlayTime) / 1000 + "_" + _adList[i].errtype + "|");
									_adPlayedTime2 = _adPlayedTime2 + (_adList[_currentIndex].adPlayedTime2 + "|");
								} else {
									_adUrl = _adUrl + "|";
									_adSerTime = _adSerTime + "|";
									_adPlayedTime1 = _adPlayedTime1 + "|";
									_adPlayedTime2 = _adPlayedTime2 + "|";
								}
								i++;
							}
							InforSender.getInstance().sendMesg(InforSender.FF,0,"","","http://pb.hd.sohu.com.cn/hdpb.gif",0,{
								"num":"0",
								"errType":"pb2",
								"serTimeNum1":uint(_ebt),
								"serTimeNum2":_endTime,
								"clientTime":allAdTime - _adTimeout - _adPlayError - _adDownloadError - _skipAdsDuration,
								"adUrl":escape(_adUrl),
								"adSerTime":escape(_adSerTime),
								"adPlayedTime1":escape(_adPlayedTime1),
								"adPlayedTime2":escape(_adPlayedTime2),
								"flag":flag,
								"loadType":source,
								"hasAd":isHasAd
							});
							ErrorSenderPQ.getInstance().sendDebugInfo({
								"url":"http://um.hd.sohu.com/u.gif",
								"type":"ad",
								"code":PlayerConfig.ADINFO_PB2_ERROR,
								"error":"pb2",
								"debuginfo":AdLog.getMsg(),
								"sid":PlayerConfig.sid,
								"uid":PlayerConfig.userId,
								"time":new Date().getTime()
							});
						}
					} else {
						if(!boo) {
							dispatch(TvSohuAdsEvent.START_AD_ILLEGAL);
						}
						AdLog.msg("请求广告数据失败！原因：" + obj.info);
						InforSender.getInstance().sendMesg(InforSender.FF,0,"","","http://pb.hd.sohu.com.cn/hdpb.gif",0,{
							"num":"2",
							"errType":obj.info,
							"loadType":source,
							"hasAd":isHasAd
						});
						ErrorSenderPQ.getInstance().sendDebugInfo({
							"url":"http://um.hd.sohu.com/u.gif",
							"type":"ad",
							"code":PlayerConfig.ADINFO_PB2_ERROR,
							"error":"pb1",
							"debuginfo":AdLog.getMsg(),
							"sid":PlayerConfig.sid,
							"uid":PlayerConfig.userId,
							"time":new Date().getTime()
						});
					}
					if(obj.info == "success") {
						return;
					}
				},loadPath);
			}
		}
		
		private function startTimeOut() : void {
			this._adTimeoutId = setTimeout(this.adTimeout,(this._adTotTime + PlayerConfig.startAdTimeOut) * 1000);
			if((this._adList[this._currentIndex]) && this._adList[this._currentIndex].playState == "no") {
				this._state = "playing";
				this._adBeginTime = getTimer();
				if(!this._isPIPAd) {
					AdLog.msg(this._downloadIndex + " :: downloadAd");
					this.downloadAd(this._downloadIndex);
				}
				AdLog.msg(this._currentIndex + " :: playAd");
				this.playAd(this._currentIndex);
			}
		}
		
		private function stopTimeOut() : void {
			clearTimeout(this._adTimeoutId);
		}
		
		private function adTimeout() : void {
			Utils.debug("广告超时了！！！");
			this.close();
			this.dispatch(TvSohuAdsEvent.SCREEN_LOAD_FAILED);
			this.checkAdPlayTime("timeout","v.aty");
		}
		
		protected function downloadAd(param1:uint) : void {
			this._downloadIndex = param1;
			this._adList[this._downloadIndex].startLoadTime = getTimer();
			if(!(this._adList[param1].adPath == "") && !(this._adList[param1].playState == "playing") && !(this._adList[param1].playState == "end")) {
				this._adList[param1].loadState = "loading";
				this._adList[param1].ad.play();
				this._adList[param1].ad.pause();
			} else {
				this.adLoaded();
			}
		}
		
		protected function playAd(param1:uint) : void {
			this._currentIndex = param1;
			this.initVolume();
			if(this._adList[param1].adPath != "") {
				this._adList[param1].ad.addEventListener(MediaEvent.PLAY_PROGRESS,this.adPlayProgress);
				this._adList[param1].detail.visible = this._adList[param1].ad.visible = true;
				if(this._adList[param1].adClickUrl != "") {
					this._adList[param1].hitArea.visible = true;
				} else {
					this._adList[param1].hitArea.visible = false;
				}
				this._adList[param1].playState = "playing";
				if(this._adList[param1].adType == "swf" && (this._adList[param1].isLoadErr)) {
					AdLog.msg(param1 + " :: errTip.play()");
					this._adList[param1].errTip.play();
				} else {
					this._adList[param1].ad.play();
				}
			} else {
				this.adPingback();
				this.adStop();
			}
		}
		
		private function adPingback() : void {
			if(!(this._adList[this._currentIndex].adStatUrl == "") && !(this._adList[this._currentIndex].adSfunc == null) && (ExternalInterface.available)) {
				ExternalInterface.call(this._adList[this._currentIndex].adSfunc,0,this._adList[this._currentIndex].adStatUrl);
			} else if(this._adList[this._currentIndex].adStatUrl != "") {
				this._statSender.multiSend(this._adList[this._currentIndex].adStatUrl);
			}
			
			this.sendAdPlayStock(this._currentIndex);
			this._adList[this._currentIndex].adStatUrl = "";
		}
		
		protected function sendAdPlayStock(param1:uint) : void {
			var _loc2_:String = null;
			try {
				if(!this._adList[param1].isSendAdPlayStock && !(this._adList[param1].adStatUrl == "")) {
					_loc2_ = this._adList[param1].adStatUrl.split("?").length > 1?this._adList[param1].adStatUrl.split("?")[1]:"";
					this.sendAdStock(param1,"oad","b",_loc2_);
					this._adList[param1].isSendAdPlayStock = true;
				}
			}
			catch(evt:*) {
			}
		}
		
		protected function sendAdStopStock(param1:uint) : void {
			var _loc2_:String = null;
			try {
				if(!this._adList[param1].isSendAdStopStock && !(this._adList[param1].adPath == "") && !(this._adList[param1].adPlayOverStatUrl == "")) {
					_loc2_ = this._adList[param1].adPlayOverStatUrl.split("?").length > 1?this._adList[param1].adPlayOverStatUrl.split("?")[1]:"";
					this.sendAdStock(param1,"oad","a",_loc2_);
					this._adList[param1].isSendAdStopStock = true;
				}
			}
			catch(evt:*) {
			}
		}
		
		protected function sendAdStock(param1:uint, param2:String, param3:String, param4:String = "") : void {
			var _loc5_:String = param4 != ""?"&" + param4:"";
			var _loc6_:String = this._adList[param1].adPath != ""?"act":"na";
			InforSender.getInstance().sendCustomMesg("http://wl.hd.sohu.com/s.gif?prod=flash&systype=" + (PlayerConfig.isHotOrMy?"0":"1") + "&cid=" + PlayerConfig.catcode + "&log=" + _loc6_ + "&from=" + PlayerConfig.domainProperty + "&3th=" + (this._adList[param1].thirdAds == "" || this._adList[param1].thirdAds == "0"?"0":"1") + "&adTime=" + this._adList[param1].duration + "&adType=" + this._adList[param1].adType + "&dmpt=" + param2 + "&po=" + param3 + "&adUrl=" + (this._adList[param1].adPath != ""?escape(this._adList[param1].adPath):"") + _loc5_);
		}
		
		public function destroy() : void {
			this.close();
			this.sysInit("start");
			this._container.visible = false;
			this._isShown = false;
			this._isFinishLoaded = false;
		}
		
		public function get state() : String {
			return this._state;
		}
		
		public function get isAutoPlayAd() : Boolean {
			return this._isAutoPlayAd;
		}
		
		public function set isAutoPlayAd(param1:Boolean) : void {
			this._isAutoPlayAd = param1;
		}
		
		public function set ebt(param1:String) : void {
			this._ebt = param1;
		}
		
		protected function newFunc() : void {
			this._adList = new Array();
			this._statSender = new TvSohuURLLoaderUtil();
			this._soundTransform = new SoundTransform();
			this._btnUi = new ButtonUi();
			this._bitUi = new BitUi();
		}
		
		public function resize(param1:Number, param2:Number) : void {
			this._width = param1 < 0?0:param1;
			this._height = param2 < 0?0:param2;
			if(this._iFoxPanel != null) {
				this._iFoxPanel.resize(this._width,this._height);
				Utils.setCenterByNumber(this._iFoxPanel,this._width,this._height);
			}
			var _loc3_:uint = 0;
			while(_loc3_ < this._adList.length) {
				this._adList[_loc3_].hitArea.width = this._width;
				this._adList[_loc3_].hitArea.height = this._height;
				this._adList[_loc3_].detail.x = 0;
				if(this._adList[_loc3_].detail.numChildren > 0) {
					this._adList[_loc3_].detail.getChildAt(this._adList[_loc3_].detail.numChildren - 1).detail_mc.x = this._width - this._adList[_loc3_].detail.getChildAt(this._adList[_loc3_].detail.numChildren - 1).detail_mc.width;
				}
				this._adList[_loc3_].detail.y = this._height - this._adList[_loc3_].detail.height - 8;
				this._adList[_loc3_].ad.resize(this._width,this._height);
				this._adList[_loc3_].errTip.resize(this._width,this._height);
				_loc3_++;
			}
			this._countDown.x = this._width - this._countDown.width - 5 + ((this._removeAdMc.visible) && (this._close_btn.visible)?0:75);
			this._countDown.y = 2;
			this.resizeAdTip();
		}
		
		private function resizeAdTip() : void {
			if(!(this._adTipContainer == null) && !(this._tipBg == null) && !(this._tipTxt == null) && !(this._adTipCloseBtn == null)) {
				this._tipBg.width = this._tipTxt.width = this._width;
				this._adTipCloseBtn.x = Math.round(this._width - this._adTipCloseBtn.width / 2 - 15);
				this._adTipContainer.y = this._height - this._adTipContainer.height;
				this._adTipContainer.x = 0;
			}
		}
		
		public function get hasAd() : Boolean {
			if(!PlayerConfig.HIDESTARTAD) {
				if(this._adList.length > 0 && (TvSohuAds.getInstance().hasAds)) {
					this._hasAd = true;
				} else {
					this._hasAd = false;
				}
			}
			return this._hasAd;
		}
		
		public function get adPath() : String {
			var _loc2_:uint = 0;
			var _loc1_:* = "";
			while(_loc2_ < this._adList.length) {
				_loc1_ = _loc1_ + (this._adList[_loc2_].adPath + ",");
				_loc2_++;
			}
			_loc1_ = _loc1_.substr(_loc1_.length - 2,1);
			return _loc1_;
		}
		
		public function saveVolume() : void {
			PlayerConfig.advolume = this._volume;
		}
		
		protected function onStatusShare(param1:NetStatusEvent) : void {
			if(param1.info.code != "SharedObject.Flush.Success") {
				if(param1.info.code == "SharedObject.Flush.Failed") {
				}
			}
			this._so.removeEventListener(NetStatusEvent.NET_STATUS,this.onStatusShare);
		}
		
		public function initVolume() : void {
			var _loc1_:Number = 0;
			if((!(this._adList[this._currentIndex] == null)) && (this._adList[this._currentIndex].hasSound) && !this._isMute) {
				if(PlayerConfig.advolume != null) {
					_loc1_ = Number(PlayerConfig.advolume);
				} else {
					_loc1_ = 0.5;
				}
			} else {
				_loc1_ = 0;
			}
			if(PlayerConfig.isMute) {
				_loc1_ = 0;
			}
			this._volume = _loc1_;
			this._adList[this._currentIndex].ad.volume = this._volume;
			this._soundTransform.volume = this._volume;
			if(this._volume == 0) {
				this.soundIcon.soundState = false;
			} else {
				this.soundIcon.soundState = true;
			}
		}
		
		public function set isMute(param1:Boolean) : void {
			this._isMute = param1;
		}
		
		public function set volume(param1:Number) : void {
			this._volume = param1;
			this._soundTransform.volume = this._volume;
			var _loc2_:uint = 0;
			while(_loc2_ < this._adList.length) {
				this._adList[_loc2_].ad.volume = this._volume;
				_loc2_++;
			}
			this.saveVolume();
			if(this._volume == 0) {
				this.soundIcon.soundState = false;
			} else {
				this.soundIcon.soundState = true;
			}
		}
		
		public function get volume() : Number {
			return this._volume;
		}
		
		public function get isExcluded() : Boolean {
			var _loc1_:* = false;
			if(this._adList[this._currentIndex].isExcluded) {
				_loc1_ = true;
			}
			return _loc1_;
		}
		
		protected function dispatch(param1:String, param2:Object = null) : void {
			var _loc3_:TvSohuAdsEvent = new TvSohuAdsEvent(param1);
			_loc3_.obj = param2;
			dispatchEvent(_loc3_);
		}
		
		private function soundIconClickHandler(param1:MouseEvent) : void {
			if(this.soundIcon.soundState) {
				dispatchEvent(new Event(TO_HAS_SOUND_ICON));
			} else {
				dispatchEvent(new Event(TO_NO_SOUND_ICON));
			}
		}
		
		private function tipCloseBtnOver(param1:MouseEvent) : void {
			this._adTipCloseBtn.getChildByName("btnUp").visible = false;
			this._adTipCloseBtn.getChildByName("btnOver").visible = true;
		}
		
		private function tipCloseBtnOut(param1:MouseEvent) : void {
			this._adTipCloseBtn.getChildByName("btnUp").visible = true;
			this._adTipCloseBtn.getChildByName("btnOver").visible = false;
		}
		
		private function tipCloseBtnUp(param1:MouseEvent) : void {
			param1.target.buttonMode = param1.target.useHandCursor = false;
			this._adTipCloseBtn.removeEventListener(MouseEvent.MOUSE_UP,this.tipCloseBtnUp);
			clearTimeout(this._adTipTimeout);
			this._adTipContainer.visible = false;
		}
	}
}
