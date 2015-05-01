package com.sohu.tv.mediaplayer.ui {
	import flash.text.TextField;
	import flash.text.TextFormat;
	import com.greensock.*;
	import com.greensock.easing.*;
	import com.sohu.tv.mediaplayer.stat.*;
	import flash.display.*;
	import flash.events.*;
	import flash.net.*;
	import flash.utils.*;
	import ebing.Utils;
	import flash.external.ExternalInterface;
	import com.sohu.tv.mediaplayer.PlayerConfig;
	import ebing.external.Eif;
	import com.sohu.tv.mediaplayer.p2p.P2PExplorer;
	import flash.text.TextFieldAutoSize;
	
	public class TipHistory extends TvSohuPanel {
		
		public function TipHistory(param1:MovieClip) {
			super(param1);
			_owner = this;
			this._tipData = new Array();
			this._jumpHistoryTip = _skin.jumpHistoryTip_txt;
			this._bg = _skin.bg_mc;
			_owner.visible = _isOpen;
			this._hitArea = _skin.hitArea_btn;
			this._ok_btn = _skin.ok_btn;
			this._no_btn = _skin.no_btn;
			this._cancelJump_btn = _skin.cancelJump_btn;
			this._setting_btn = _skin.setting_btn;
			this._toStartAndPlay_btn = _skin.toStartAndPlay_btn;
			this._hitArea.useHandCursor = this._hitArea.buttonMode = true;
			this._fat = new TextFormat();
			this._textMask = new Sprite();
			this._textMask1 = new Sprite();
			this._textMask2 = new Sprite();
			this._jumpHistoryTip.autoSize = TextFieldAutoSize.LEFT;
			Utils.drawRect(this._textMask,0,0,1,this._bg.height,0,0);
			addChild(this._textMask);
			this._textMask.x = this._jumpHistoryTip.x;
			this._textMask.y = 0;
			this._jumpHistoryTip.mask = this._textMask;
			this._hitArea.addEventListener(MouseEvent.MOUSE_OVER,this.mouseOver);
			this._hitArea.addEventListener(MouseEvent.CLICK,this.mouseClick);
			this._ok_btn.addEventListener(MouseEvent.CLICK,this.mouseClick);
			this._hitArea.addEventListener(MouseEvent.MOUSE_OUT,this.mouseOut);
			this._no_btn.addEventListener(MouseEvent.CLICK,this.close);
			this._toStartAndPlay_btn.visible = _close_btn.visible = false;
			this._so = SharedObject.getLocal("playHistory","/");
			this._so.addEventListener(AsyncErrorEvent.ASYNC_ERROR,this.soAsyncError);
			this._iFoxSo = SharedObject.getLocal("iFoxMarkTip","/");
			this._iFoxSo.addEventListener(AsyncErrorEvent.ASYNC_ERROR,this.soAsyncError);
			this._vipUserSo = SharedObject.getLocal("vipUserTip","/");
			this._vipUserSo.addEventListener(AsyncErrorEvent.ASYNC_ERROR,this.soAsyncError);
			this._svdUserSo = SharedObject.getLocal("svdUserTip","/");
			this._svdUserSo.addEventListener(AsyncErrorEvent.ASYNC_ERROR,this.soAsyncError);
			this._volumeKeyboardSo = SharedObject.getLocal("tipVolKeyboard","/");
			this._volumeKeyboardSo.addEventListener(AsyncErrorEvent.ASYNC_ERROR,this.soAsyncError);
			this._progressKeyboardSo = SharedObject.getLocal("tipProKeyboard","/");
			this._progressKeyboardSo.addEventListener(AsyncErrorEvent.ASYNC_ERROR,this.soAsyncError);
			this._jumpHistoryTip.addEventListener(TextEvent.LINK,this.linkHandler);
			this._cancelJump_btn.visible = this._setting_btn.visible = false;
		}
		
		public static const SEEK:String = "seekkk";
		
		public static const TOSTART_BTN_ONCLICK:String = "tostart_btn_onclick";
		
		private var _playHistory:Object;
		
		private var _jumpHistoryTip:TextField;
		
		private var _bg:Sprite;
		
		private var _playedTime:Number = 30;
		
		private var _isChecked:Boolean = false;
		
		private var _isShowHdToCommonTip:Boolean = false;
		
		private var _isShowCommonToHd:Boolean = false;
		
		private var _isShowToSuper:Boolean = false;
		
		private var _isShowPayTip:Boolean = false;
		
		private var _hitArea:Sprite;
		
		private var _fat:TextFormat;
		
		private var _hideOwnerLimit:Number = 20000.0;
		
		private var _hideOwnerId:Number = 0;
		
		private var _ok_btn:SimpleButton;
		
		private var _no_btn:SimpleButton;
		
		private var _cancelJump_btn:SimpleButton;
		
		private var _setting_btn:SimpleButton;
		
		private var _toStartAndPlay_btn:SimpleButton;
		
		private var _so:SharedObject;
		
		private var _iFoxSo:SharedObject;
		
		private var _vipUserSo:SharedObject;
		
		private var _volumeKeyboardSo:SharedObject;
		
		private var _progressKeyboardSo:SharedObject;
		
		private var _tipData:Array;
		
		private var _textMask:Sprite;
		
		private var _isJECChecked:Boolean;
		
		private var _currentState:String = "historyTip";
		
		private var _currentTextNumber:Number = 0;
		
		private var _currentText;
		
		private var _nextText;
		
		private var _textMask1:Sprite;
		
		private var _textMask2:Sprite;
		
		private var _isCSTipShown:Boolean = false;
		
		private var _isIfoxVipTip:Boolean = false;
		
		private var _isShowAddSpeedTip:Boolean = false;
		
		private var _isShowAddSpeedTip2:Boolean = false;
		
		private var _isShowVipUserTip:Boolean = false;
		
		private var _isMidAdTip:Boolean = false;
		
		private var _nextTitle:String = "";
		
		private var _isEssenceTip:Boolean = false;
		
		private var _uvrObj:Object;
		
		private var _isExtremeTip:Boolean = false;
		
		private var _isOpenSVDTip:Boolean = false;
		
		private var _svdUserSo:SharedObject;
		
		private var _isShowVolKeyboardTip:Boolean = false;
		
		private var _isShowProKeyboardTip:Boolean = false;
		
		private function cancelJumpHandler() : void {
			dispatchEvent(new Event("cancelJump"));
			this.close();
		}
		
		private function settingHandler() : void {
			dispatchEvent(new Event("setting"));
			this.close();
		}
		
		private function soAsyncError(param1:AsyncErrorEvent) : void {
		}
		
		private function mouseOver(param1:MouseEvent) : void {
			this._fat.color = 8898549;
			this._jumpHistoryTip.setTextFormat(this._fat);
		}
		
		private function toStartAndPlay() : void {
			_owner.dispatchEvent(new Event(TOSTART_BTN_ONCLICK));
			this.close();
		}
		
		private function mouseClick(param1:MouseEvent) : void {
			if(this._currentState == "historyTip") {
				if(String(this._playHistory.success) == "2") {
					Utils.openWindow(this._playHistory.url,"_self");
				} else if(String(this._playHistory.success) == "1") {
					_owner.dispatchEvent(new Event(SEEK));
					this.close();
				} else if(String(this._playHistory.success) == "4") {
					ExternalInterface.call("swfGotoNewPage");
				}
				
				
			}
			if(this._currentState == "commonToHdTip") {
				dispatchEvent(new Event("commonToHd"));
				this.close();
			} else if(this._currentState == "toSuperTip") {
				dispatchEvent(new Event("toSuper"));
				this.close();
			}
			
		}
		
		private function hdToCommon() : void {
			dispatchEvent(new Event("hdToCommon"));
			this.close();
		}
		
		private function videoToPause() : void {
			parent["core"].pause();
			this.close();
		}
		
		private function mouseOut(param1:MouseEvent) : void {
			this._fat.color = 16777215;
			this._jumpHistoryTip.setTextFormat(this._fat);
		}
		
		private function linkHandler(param1:TextEvent) : void {
			switch(param1.text) {
				case "1":
					this.toStartAndPlay();
					break;
				case "2":
					this.cancelJumpHandler();
					break;
				case "3":
					this.settingHandler();
					break;
				case "4":
					this.hdToCommon();
					break;
				case "5":
					this.videoToPause();
					break;
				case "6":
					dispatchEvent(new Event("exitFullScreen"));
					SendRef.getInstance().sendPQDrog("http://click.hd.sohu.com.cn/s.gif?type=fun_yangli205733_PL_S_GoonWatch&s=" + PlayerConfig.stype + "&_=" + new Date().getTime());
					Utils.openWindow(this._playHistory.url,"_self");
					break;
				case "7":
					if((Eif.available) && (PlayerConfig.isPartner)) {
						ExternalInterface.call("playerIsBuy");
					} else {
						Utils.openWindow("http://store.tv.sohu.com/web/view/buy.do?pid=" + PlayerConfig.vrsPlayListId + "&vid=" + PlayerConfig.vid + "&spayid=110112");
					}
					break;
				case "8":
					switch(this._currentState) {
						case "addSpeedTip":
							SendRef.getInstance().sendPQDrog("http://click.hd.sohu.com.cn/s.gif?type=yangli205733_PL_S_SetupiFox&s=" + PlayerConfig.stype + "&_=" + new Date().getTime());
							break;
						case "newAddSpeedTip":
							SendRef.getInstance().sendPQDrog("http://click.hd.sohu.com.cn/s.gif?type=yangli205733_PL_S_ChooseiFox&s=" + PlayerConfig.stype + "&_=" + new Date().getTime());
							break;
					}
					if(!PlayerConfig.isLongVideo || (PlayerConfig.isMyTvVideo)) {
						Utils.openWindow("http://p2p.hd.sohu.com.cn/dcs.do?f=1&s=1045");
					} else {
						Utils.openWindow("http://p2p.hd.sohu.com.cn/dcs.do?f=1&s=1002");
					}
					break;
				case "9":
					dispatchEvent(new Event("imovie"));
					break;
				case "10":
					SendRef.getInstance().sendPQVPC("fun_ player_clickifox");
					Utils.openWindow("http://p2p.hd.sohu.com/dcs.do?f=1&s=1052");
					break;
				case "11":
					SendRef.getInstance().sendPQDrog("http://click.hd.sohu.com.cn/s.gif?type=fun_haoli202921_lbwlbdj&s=" + PlayerConfig.stype + "&_=" + new Date().getTime());
					if(!(this._uvrObj == null) && !(this._uvrObj.url == null) && !(this._uvrObj.url == "")) {
						Utils.openWindow(this._uvrObj.url);
					}
					break;
				case "13":
					SendRef.getInstance().sendPQDrog("http://click.hd.sohu.com.cn/s.gif?type=yangli205733_PL_S_ChoosePay&s=" + PlayerConfig.stype + "&_=" + new Date().getTime());
					Utils.openWindow("http://tv.sohu.com/s2014/kdjs/index.shtml");
					break;
			}
		}
		
		public function showHdToCommon() : void {
			if(!_isOpen && !(_skin == null)) {
				this._currentState = "hdToCommonTip";
				this._isShowHdToCommonTip = true;
				this._jumpHistoryTip.htmlText = "播放不流畅？建议您切换到<a href=\"event:4\"><font color=\'#e73c31\'><u>流畅版</u></font></a>或<a href=\"event:5\"><font color=\'#e73c31\'>暂停一会儿</u></font></a>继续观看";
				this._ok_btn.visible = this._no_btn.visible = this._hitArea.visible = this._setting_btn.visible = this._cancelJump_btn.visible = this._toStartAndPlay_btn.visible = false;
				_close_btn.visible = this._jumpHistoryTip.visible = true;
				this._hideOwnerLimit = 15 * 1000;
				this.open();
			}
		}
		
		public function showCommonToHd() : void {
			if(!_isOpen && !(_skin == null)) {
				this._currentState = "commonToHdTip";
				this._isShowCommonToHd = true;
				this._jumpHistoryTip.text = "您的网速很好，建议您切换到高清版，是否现在切换？";
				this._hitArea.visible = this._setting_btn.visible = this._cancelJump_btn.visible = _close_btn.visible = this._toStartAndPlay_btn.visible = false;
				this._ok_btn.visible = this._no_btn.visible = this._jumpHistoryTip.visible = true;
				this._hideOwnerLimit = 18 * 1000;
				this.open();
			}
		}
		
		public function showToSuper() : void {
			if(!_isOpen && !(_skin == null) && !PlayerConfig.isHideTip) {
				this._currentState = "toSuperTip";
				this._isShowToSuper = true;
				this._jumpHistoryTip.text = "您的网速非常好，建议您切换到超高清版，是否现在切换？";
				this._hitArea.visible = this._setting_btn.visible = this._cancelJump_btn.visible = _close_btn.visible = this._toStartAndPlay_btn.visible = false;
				this._ok_btn.visible = this._no_btn.visible = this._jumpHistoryTip.visible = true;
				this._hideOwnerLimit = 18 * 1000;
				this.open();
			}
		}
		
		public function showPayTip() : void {
			if(!_isOpen && !(_skin == null) && !PlayerConfig.isHideTip) {
				this._currentState = "payVideoTip";
				this._isShowPayTip = true;
				if(PlayerConfig.previewTime > 300 && PlayerConfig.previewTime <= 600) {
					this._jumpHistoryTip.htmlText = "您可以免费试看10分钟，购买后可看完整版，<a href=\"event:7\"><font color=\'#ff0000\'><u>立即购买</u></font></a>";
				} else if(PlayerConfig.previewTime > 0 && PlayerConfig.previewTime <= 300) {
					this._jumpHistoryTip.htmlText = "您可以免费试看5分钟，购买后可看完整版，<a href=\"event:7\"><font color=\'#ff0000\'><u>立即购买</u></font></a>";
				} else {
					this._jumpHistoryTip.htmlText = "您可以免费试看" + Math.round(PlayerConfig.previewTime / 60) + "分钟，购买后可看完整版，<a href=\"event:7\"><font color=\'#ff0000\'><u>立即购买</u></font></a>";
				}
				
				this._ok_btn.visible = this._no_btn.visible = this._hitArea.visible = this._setting_btn.visible = this._cancelJump_btn.visible = this._toStartAndPlay_btn.visible = false;
				_close_btn.visible = this._jumpHistoryTip.visible = true;
				this._hideOwnerLimit = -1;
				this.open();
			}
		}
		
		public function showIfoxVipTip() : void {
			if(!_isOpen && !(_skin == null) && !PlayerConfig.isHideTip) {
				this._currentState = "iFoxVipTip";
				this._isIfoxVipTip = true;
				this._jumpHistoryTip.htmlText = "您正在享受<font color=\'#FF0000\'>搜狐影音</font>新手礼包提供的VIP去广告服务";
				this._ok_btn.visible = this._no_btn.visible = this._hitArea.visible = this._setting_btn.visible = this._cancelJump_btn.visible = this._toStartAndPlay_btn.visible = false;
				_close_btn.visible = this._jumpHistoryTip.visible = true;
				this._hideOwnerLimit = 15 * 1000;
				this.open();
			}
		}
		
		public function showMidAdTip() : void {
			if(!_isOpen && !(_skin == null) && !PlayerConfig.isHideTip) {
				this._currentState = "midAdTip";
				this._isMidAdTip = true;
				this._jumpHistoryTip.htmlText = "即将播放广告，广告回来精彩继续";
				this._ok_btn.visible = this._no_btn.visible = this._hitArea.visible = this._setting_btn.visible = this._cancelJump_btn.visible = this._toStartAndPlay_btn.visible = false;
				_close_btn.visible = this._jumpHistoryTip.visible = true;
				this._hideOwnerLimit = 5 * 1000;
				this.open();
			}
		}
		
		public function showAddSpeedTip() : void {
			if(!_isOpen && !(_skin == null) && !PlayerConfig.isHideTip) {
				this._currentState = "addSpeedTip";
				this._isShowAddSpeedTip = true;
				this._jumpHistoryTip.htmlText = "播放不流畅，建议您<a href=\"event:8\"><font color=\'#e73c31\'><u>安装搜狐影音</u></font></a>，<font color=\'#FF0000\'><b>95%</b></font>的用户都说好!";
				this._ok_btn.visible = this._no_btn.visible = this._hitArea.visible = this._setting_btn.visible = this._cancelJump_btn.visible = this._toStartAndPlay_btn.visible = false;
				_close_btn.visible = this._jumpHistoryTip.visible = true;
				this._hideOwnerLimit = 15 * 1000;
				this.open();
				SendRef.getInstance().sendPQDrog("http://click.hd.sohu.com.cn/s.gif?type=yangli205733_PL_S_iFoxRecommend&s=" + PlayerConfig.stype + "&_=" + new Date().getTime());
			}
		}
		
		public function showNewAddSpeedTip() : void {
			if(!_isOpen && !(_skin == null) && !PlayerConfig.isHideTip) {
				this._currentState = "newAddSpeedTip";
				this._jumpHistoryTip.htmlText = "<a href=\"event:8\"><font color=\'#FF0000\'><u>安装搜狐影音</u></font></a>免费加速或<a href=\"event:13\"><font color=\'#FF0000\'><u>变身加速会员</u></font></a>，从此看视频不卡顿";
				this._ok_btn.visible = this._no_btn.visible = this._hitArea.visible = this._setting_btn.visible = this._cancelJump_btn.visible = this._toStartAndPlay_btn.visible = false;
				_close_btn.visible = this._jumpHistoryTip.visible = true;
				this._hideOwnerLimit = 15 * 1000;
				this.open();
				SendRef.getInstance().sendPQDrog("http://click.hd.sohu.com.cn/s.gif?type=yangli205733_PL_S_iFoxPay&s=" + PlayerConfig.stype + "&_=" + new Date().getTime());
			}
		}
		
		public function showAddSpeedTip2() : void {
			var _loc1_:Date = null;
			var _loc2_:String = null;
			if(!_isOpen && !(_skin == null) && !PlayerConfig.isHideTip) {
				this._currentState = "addSpeedTip2";
				this._isShowAddSpeedTip2 = true;
				this._jumpHistoryTip.htmlText = "搜狐影音，免费赠送VIP会员 " + "<a href=\"event:10\"><font color=\'#FF0000\'><u>立即下载</u></font></a>";
				this._ok_btn.visible = this._no_btn.visible = this._hitArea.visible = this._setting_btn.visible = this._cancelJump_btn.visible = this._toStartAndPlay_btn.visible = false;
				_close_btn.visible = this._jumpHistoryTip.visible = true;
				this._hideOwnerLimit = 15 * 1000;
				this._iFoxSo.clear();
				_loc1_ = new Date();
				this._iFoxSo.data.ts = _loc1_.getFullYear() + "-" + _loc1_.getMonth() + "-" + _loc1_.getDate();
				try {
					_loc2_ = this._iFoxSo.flush();
					if(_loc2_ == SharedObjectFlushStatus.PENDING) {
						this._iFoxSo.addEventListener(NetStatusEvent.NET_STATUS,this.onStatusShare);
					} else if(_loc2_ == SharedObjectFlushStatus.FLUSHED) {
					}
					
				}
				catch(e:Error) {
				}
				this.open();
			}
			if(!_isOpen && !(_skin == null) && !PlayerConfig.isHideTip) {
				return;
			}
		}
		
		private function showEnjoyVipTip() : void {
			var _loc1_:Date = null;
			var _loc2_:String = null;
			if(!_isOpen && !(_skin == null) && !PlayerConfig.isHideTip) {
				this._currentState = "vipUserTip";
				this._isShowVipUserTip = true;
				this._jumpHistoryTip.htmlText = "尊敬的搜狐视频会员，您正在享受去广告特权";
				this._ok_btn.visible = this._no_btn.visible = this._hitArea.visible = this._setting_btn.visible = this._cancelJump_btn.visible = this._toStartAndPlay_btn.visible = false;
				_close_btn.visible = this._jumpHistoryTip.visible = true;
				this._hideOwnerLimit = 5 * 1000;
				this._vipUserSo.clear();
				_loc1_ = new Date();
				this._vipUserSo.data.ts = _loc1_.getFullYear() + "-" + _loc1_.getMonth() + "-" + _loc1_.getDate();
				try {
					_loc2_ = this._vipUserSo.flush();
					if(_loc2_ == SharedObjectFlushStatus.PENDING) {
						this._vipUserSo.addEventListener(NetStatusEvent.NET_STATUS,this.onStatusShare);
					} else if(_loc2_ == SharedObjectFlushStatus.FLUSHED) {
					}
					
				}
				catch(e:Error) {
				}
				this.open();
			}
			if(!_isOpen && !(_skin == null) && !PlayerConfig.isHideTip) {
				return;
			}
		}
		
		public function showVolKeyboardTip() : void {
			var _loc1_:Date = null;
			var _loc2_:String = null;
			if(!_isOpen && !(_skin == null) && !PlayerConfig.isHideTip) {
				this._currentState = "volKeyboardTip";
				this._isShowVolKeyboardTip = true;
				this._jumpHistoryTip.htmlText = "键盘\'↑\'\'↓\'可调节音量";
				this._ok_btn.visible = this._no_btn.visible = this._hitArea.visible = this._setting_btn.visible = this._cancelJump_btn.visible = this._toStartAndPlay_btn.visible = false;
				_close_btn.visible = this._jumpHistoryTip.visible = true;
				this._hideOwnerLimit = 15 * 1000;
				this._volumeKeyboardSo.clear();
				_loc1_ = new Date();
				this._volumeKeyboardSo.data.td = _loc1_.getFullYear() + "-" + _loc1_.getMonth() + "-" + _loc1_.getDate();
				try {
					_loc2_ = this._volumeKeyboardSo.flush();
					if(_loc2_ == SharedObjectFlushStatus.PENDING) {
						this._volumeKeyboardSo.addEventListener(NetStatusEvent.NET_STATUS,this.onStatusShare);
					} else if(_loc2_ == SharedObjectFlushStatus.FLUSHED) {
					}
					
				}
				catch(e:Error) {
				}
				this.open();
				SendRef.getInstance().sendPQDrog("http://click.hd.sohu.com.cn/s.gif?type=PL_S_TipsVolumeBar_201502&s=" + PlayerConfig.stype + "&_=" + new Date().getTime());
			}
			if(!_isOpen && !(_skin == null) && !PlayerConfig.isHideTip) {
				return;
			}
		}
		
		public function showProKeyboardTip() : void {
			var _loc1_:Date = null;
			var _loc2_:String = null;
			if(!_isOpen && !(_skin == null) && !PlayerConfig.isHideTip) {
				this._currentState = "proKeyboardTip";
				this._isShowProKeyboardTip = true;
				this._jumpHistoryTip.htmlText = "键盘\'←\'\'→\'可快进/快退";
				this._ok_btn.visible = this._no_btn.visible = this._hitArea.visible = this._setting_btn.visible = this._cancelJump_btn.visible = this._toStartAndPlay_btn.visible = false;
				_close_btn.visible = this._jumpHistoryTip.visible = true;
				this._hideOwnerLimit = 15 * 1000;
				this._progressKeyboardSo.clear();
				_loc1_ = new Date();
				this._progressKeyboardSo.data.dt = _loc1_.getFullYear() + "-" + _loc1_.getMonth() + "-" + _loc1_.getDate();
				try {
					_loc2_ = this._progressKeyboardSo.flush();
					if(_loc2_ == SharedObjectFlushStatus.PENDING) {
						this._progressKeyboardSo.addEventListener(NetStatusEvent.NET_STATUS,this.onStatusShare);
					} else if(_loc2_ == SharedObjectFlushStatus.FLUSHED) {
					}
					
				}
				catch(e:Error) {
				}
				this.open();
				SendRef.getInstance().sendPQDrog("http://click.hd.sohu.com.cn/s.gif?type=PL_S_TipsProgressBar_201502&s=" + PlayerConfig.stype + "&_=" + new Date().getTime());
			}
			if(!_isOpen && !(_skin == null) && !PlayerConfig.isHideTip) {
				return;
			}
		}
		
		public function showEssenceTip(param1:Object) : void {
			if(!_isOpen && !(_skin == null) && !PlayerConfig.isHideTip) {
				this._uvrObj = param1;
				this._currentState = "isEssenceTip";
				this._isEssenceTip = true;
				this._jumpHistoryTip.htmlText = "观看" + PlayerConfig.videoTitle + "精华版" + "为你节省" + (!(this._uvrObj == null) && !(this._uvrObj.len == null)?this._uvrObj.len:"") + "分钟  " + "<a href=\"event:11\"><font color=\'#FF0000\'><u>立即观看</u></font></a>";
				this._ok_btn.visible = this._no_btn.visible = this._hitArea.visible = this._setting_btn.visible = this._cancelJump_btn.visible = this._toStartAndPlay_btn.visible = false;
				_close_btn.visible = this._jumpHistoryTip.visible = true;
				this._hideOwnerLimit = 10 * 1000;
				this.open();
				SendRef.getInstance().sendPQDrog("http://click.hd.sohu.com.cn/s.gif?type=fun_haoli202921_lbwlbzs&s=" + PlayerConfig.stype + "&_=" + new Date().getTime());
			}
		}
		
		public function showExtremeTip() : void {
			if(!_isOpen && !(_skin == null) && !PlayerConfig.isHideTip) {
				this._currentState = "extremeTip";
				this._isExtremeTip = true;
				this._jumpHistoryTip.htmlText = "如果您的机器性能不是杠杠的，可能会卡顿哦";
				this._ok_btn.visible = this._no_btn.visible = this._hitArea.visible = this._setting_btn.visible = this._cancelJump_btn.visible = this._toStartAndPlay_btn.visible = false;
				_close_btn.visible = this._jumpHistoryTip.visible = true;
				this._hideOwnerLimit = 3 * 1000;
				this.open();
			}
		}
		
		public function showOpenSVDTip() : void {
			if(!_isOpen && !(_skin == null) && !PlayerConfig.isHideTip) {
				this._currentState = "openSVDTip";
				this._isOpenSVDTip = true;
				this._jumpHistoryTip.htmlText = "检测到播放不流畅，稍后会为您刷新页面，开启加速（可在右键菜单中关闭）";
				this._ok_btn.visible = this._no_btn.visible = this._hitArea.visible = this._setting_btn.visible = this._cancelJump_btn.visible = this._toStartAndPlay_btn.visible = false;
				_close_btn.visible = this._jumpHistoryTip.visible = true;
				this._hideOwnerLimit = 15 * 1000;
				this.open();
				SendRef.getInstance().sendPQDrog("http://click.hd.sohu.com.cn/s.gif?type=fun_yangli205733_PL_S_GPUSpeedUp&s=" + PlayerConfig.stype + "&_=" + new Date().getTime());
			}
		}
		
		public function get isShowVolKeyboardTip() : Boolean {
			return this._isShowVolKeyboardTip;
		}
		
		public function get isShowProKeyboardTip() : Boolean {
			return this._isShowProKeyboardTip;
		}
		
		public function get isShowHdToCommonTip() : Boolean {
			return this._isShowHdToCommonTip;
		}
		
		public function get isShowCommonToHd() : Boolean {
			return this._isShowCommonToHd;
		}
		
		public function get isShowToSuper() : Boolean {
			return this._isShowToSuper;
		}
		
		public function get isShowAddSpeedTip() : Boolean {
			return this._isShowAddSpeedTip;
		}
		
		public function get isJECChecked() : Boolean {
			return this._isJECChecked;
		}
		
		public function get isShowPayTip() : Boolean {
			return this._isShowPayTip;
		}
		
		public function set isShowPayTip(param1:Boolean) : void {
			this._isShowPayTip = param1;
		}
		
		public function get isIfoxVipTip() : Boolean {
			return this._isIfoxVipTip;
		}
		
		public function get isExtremeTip() : Boolean {
			return this._isExtremeTip;
		}
		
		public function get isOpenSVDTip() : Boolean {
			return this._isOpenSVDTip;
		}
		
		public function get isEssenceTip() : Boolean {
			return this._isEssenceTip;
		}
		
		public function get isMidAdTip() : Boolean {
			return this._isMidAdTip;
		}
		
		public function set isMidAdTip(param1:Boolean) : void {
			this._isMidAdTip = param1;
		}
		
		public function showJumpEndCaption() : void {
			if(!this._isJECChecked && !(_skin == null) && !PlayerConfig.isHideTip) {
				this._currentState = "jumpECTip";
				this._isJECChecked = true;
				this._jumpHistoryTip.htmlText = "马上为您跳过片尾（<a href=\"event:2\"><font color=\'#e73c31\'><u>取消跳过</u></font></a>）" + (this._nextTitle == ""?"":"，继续播放" + this._nextTitle);
				this._toStartAndPlay_btn.visible = false;
				this._jumpHistoryTip.visible = _close_btn.visible = true;
				this._setting_btn.visible = this._cancelJump_btn.visible = this._hitArea.visible = this._ok_btn.visible = this._no_btn.visible = false;
				this._hideOwnerLimit = 15 * 1000;
				this.open();
			}
		}
		
		public function showIMoviePayTip() : void {
			if(!_isOpen && !(_skin == null) && !PlayerConfig.isHideTip) {
				this._currentState = "payVideoTip";
				this._isShowPayTip = true;
				this._jumpHistoryTip.htmlText = "您正在免费试看前10分钟，购买后可观看全片，<a href=\"event:9\"><font color=\'#e73c31\'><u>立即购买</u></font></a>";
				this._ok_btn.visible = this._no_btn.visible = this._hitArea.visible = this._setting_btn.visible = this._cancelJump_btn.visible = this._toStartAndPlay_btn.visible = false;
				_close_btn.visible = this._jumpHistoryTip.visible = true;
				this._hideOwnerLimit = -1;
				this.open();
			}
		}
		
		public function hideJumpEndCaption() : void {
			if((_isOpen) && !(_skin == null) && !PlayerConfig.isHideTip) {
				this._isJECChecked = false;
				this.close();
			}
		}
		
		public function showNextTitle() : void {
			if(!_isOpen && !(_skin == null) && !(this._nextTitle == "") && !PlayerConfig.isHideTip) {
				this._currentState = "nextTitleTip";
				this._jumpHistoryTip.htmlText = "即将播放：" + this._nextTitle;
				this._toStartAndPlay_btn.visible = false;
				this._jumpHistoryTip.visible = _close_btn.visible = true;
				this._setting_btn.visible = this._cancelJump_btn.visible = this._hitArea.visible = this._ok_btn.visible = this._no_btn.visible = false;
				this._hideOwnerLimit = 15 * 1000;
				this.open();
			}
		}
		
		public function set nextTitle(param1:String) : void {
			this._nextTitle = param1;
		}
		
		public function checkAndTip() : void {
			var _loc1_:uint = 0;
			var _loc2_:Date = null;
			var _loc3_:String = null;
			var _loc4_:Date = null;
			var _loc5_:String = null;
			if(!(_skin == null) && !PlayerConfig.isHideTip) {
				if(!this._isChecked) {
					this._isChecked = true;
					if(PlayerConfig.flashCookieLastTime > 0) {
						this._currentState = "historyTip";
						this._hideOwnerLimit = 15 * 1000;
						this._jumpHistoryTip.htmlText = "已为您续播到上次观看时间" + Utils.fomatTime(Math.round(Number(PlayerConfig.flashCookieLastTime))) + "，您也可以<a href=\"event:1\"><font color=\'#e73c31\'><u>从头观看</u></font></a>";
						this._jumpHistoryTip.visible = _close_btn.visible = true;
						this._toStartAndPlay_btn.visible = this._hitArea.visible = this._ok_btn.visible = this._no_btn.visible = false;
						this.open();
					} else if((Eif.available) && (ExternalInterface.available)) {
						this._currentState = "historyTip";
						this._playHistory = ExternalInterface.call("getVrsPlayerHistory",PlayerConfig.vid,PlayerConfig.pid,0,0,PlayerConfig.videoTitle);
						if(!(this._playHistory == null) && String(this._playHistory.success) == "2") {
							this._jumpHistoryTip.htmlText = "您上次观看到《" + this._playHistory.title + "》" + Utils.fomatTime(Math.round(Number(this._playHistory.lastTime))) + "处，您可以<a href=\"event:6\"><font color=\'#e73c31\'><u>继续观看</u></font></a>";
							_loc1_ = 0;
							while(_loc1_ < this._playHistory.title.length * 2) {
								if(!this._jumpHistoryTip.hitTestObject(_close_btn)) {
									break;
								}
								this._jumpHistoryTip.htmlText = "您上次观看到《" + Utils.maxCharsLimit(this._playHistory.title,this._playHistory.title.length * 2 - _loc1_,true) + "》" + Utils.fomatTime(Math.round(Number(this._playHistory.lastTime))) + "处，您可以<a href=\"event:6\"><font color=\'#e73c31\'><u>继续观看</u></font></a>";
								_loc1_++;
							}
							this._hitArea.visible = this._ok_btn.visible = this._no_btn.visible = this._toStartAndPlay_btn.visible = false;
							_close_btn.visible = this._jumpHistoryTip.visible = true;
							this._hideOwnerLimit = 20 * 1000;
							this.open();
						} else if(!(this._playHistory == null) && String(this._playHistory.success) == "5" && PlayerConfig.tempLastTime > 0) {
							this._currentState = "historyTip";
							this._jumpHistoryTip.text = "已经为您定位到（" + Utils.fomatTime(Math.round(Number(PlayerConfig.tempLastTime))) + ")";
							this._jumpHistoryTip.visible = this._toStartAndPlay_btn.visible = _close_btn.visible = true;
							this._hitArea.visible = this._ok_btn.visible = this._no_btn.visible = false;
							this._hideOwnerLimit = 15 * 1000;
							this.open();
						} else if(!(this._playHistory == null) && String(this._playHistory.success) == "1" && PlayerConfig.tempLastTime > 0) {
							this._currentState = "historyTip";
							this._jumpHistoryTip.htmlText = "已为您续播到上次观看时间" + Utils.fomatTime(Math.round(Number(PlayerConfig.tempLastTime))) + "，您也可以<a href=\"event:1\"><font color=\'#e73c31\'><u>从头观看</u></font></a>";
							this._jumpHistoryTip.visible = _close_btn.visible = true;
							this._toStartAndPlay_btn.visible = this._hitArea.visible = this._ok_btn.visible = this._no_btn.visible = false;
							this._hideOwnerLimit = 15 * 1000;
							this.open();
						} else if(!(this._playHistory == null) && String(this._playHistory.success) == "4") {
							this._currentState = "historyTip";
							this._jumpHistoryTip.visible = true;
							this._jumpHistoryTip.text = "您上次已经观看到该影片的片尾，是否接着看下一集？";
							this._hideOwnerLimit = 18 * 1000;
							this.open();
						} else if(PlayerConfig.preludeTime > 0) {
							this._currentState = "historyTip";
							this._jumpHistoryTip.htmlText = "已为您跳过片头！<a href=\"event:3\"><font color=\'#e73c31\'><u>设置</u></font></a>";
							this._jumpHistoryTip.visible = _close_btn.visible = true;
							this._toStartAndPlay_btn.visible = this._hitArea.visible = this._ok_btn.visible = this._no_btn.visible = false;
							this._hideOwnerLimit = 15 * 1000;
							this.open();
						}
						
						
						
						
					}
					
					if((PlayerConfig.isSohuDomain) && (PlayerConfig.isFms) && !PlayerConfig.isLive && !this._isCSTipShown && !_isOpen) {
						this.showCannotSpeedupTip();
					}
					if((PlayerConfig.isVipUser) && !PlayerConfig.isFee && !this._isShowVipUserTip) {
						_loc2_ = new Date();
						_loc3_ = _loc2_.getFullYear() + "-" + _loc2_.getMonth() + "-" + _loc2_.getDate();
						if(_loc3_ != String(this._vipUserSo.data.ts)) {
							this.showEnjoyVipTip();
						}
					}
					if(!(P2PExplorer.getInstance().hasP2P || (Eif.available) && (ExternalInterface.call("sohuHD.install.isInstall"))) && !this._isShowAddSpeedTip2 && !PlayerConfig.isFms) {
						_loc4_ = new Date();
						_loc5_ = _loc4_.getFullYear() + "-" + _loc4_.getMonth() + "-" + _loc4_.getDate();
						if(_loc5_ != String(this._iFoxSo.data.ts)) {
							this.showAddSpeedTip2();
							SendRef.getInstance().sendPQVPC("fun_player_showifox");
						}
					}
				}
			}
		}
		
		public function playProgress(param1:*) : void {
			var _loc4_:String = null;
			var _loc5_:* = false;
			var _loc6_:uint = 0;
			var _loc7_:Object = null;
			var _loc8_:Array = null;
			var _loc2_:Number = param1.obj.nowTime;
			var _loc3_:Number = param1.obj.totTime;
			if((Eif.available) && (ExternalInterface.available)) {
				if(Math.abs(_loc2_ - this._playedTime) >= 30) {
					_loc4_ = "";
					if(!(this._so.data.list == undefined) && !(this._so.data.list == null)) {
						_loc5_ = false;
						_loc6_ = 0;
						while(_loc6_ < this._so.data.list.length) {
							if(this._so.data.list[_loc6_].vid == PlayerConfig.vid) {
								_loc5_ = true;
								if(this._so.data.list[_loc6_].playedTime != _loc2_) {
									this._so.data.list[_loc6_].playedTime = _loc2_;
									try {
										_loc4_ = this._so.flush();
										if(_loc4_ == SharedObjectFlushStatus.PENDING) {
											this._so.addEventListener(NetStatusEvent.NET_STATUS,this.onStatusShare);
										} else if(_loc4_ == SharedObjectFlushStatus.FLUSHED) {
										}
										
									}
									catch(e:Error) {
									}
									break;
								}
							}
							_loc6_++;
						}
						if(!_loc5_) {
							_loc7_ = {
								"vid":PlayerConfig.vid,
								"playedTime":_loc2_
							};
							if(this._so.data.list.length < 20) {
								this._so.data.list.push(_loc7_);
								try {
									_loc4_ = this._so.flush();
									if(_loc4_ == SharedObjectFlushStatus.PENDING) {
										this._so.addEventListener(NetStatusEvent.NET_STATUS,this.onStatusShare);
									} else if(_loc4_ == SharedObjectFlushStatus.FLUSHED) {
									}
									
								}
								catch(e:Error) {
								}
							} else {
								this._so.data.list.shift();
								this._so.data.list.push(_loc7_);
								try {
									_loc4_ = this._so.flush();
									if(_loc4_ == SharedObjectFlushStatus.PENDING) {
										this._so.addEventListener(NetStatusEvent.NET_STATUS,this.onStatusShare);
									} else if(_loc4_ == SharedObjectFlushStatus.FLUSHED) {
									}
									
								}
								catch(e:Error) {
								}
							}
						}
						if(_loc5_) {
						}
					} else {
						_loc8_ = [{
							"vid":PlayerConfig.vid,
							"playedTime":_loc2_
						}];
						this._so.data.list = _loc8_;
						try {
							_loc4_ = this._so.flush();
							if(_loc4_ == SharedObjectFlushStatus.PENDING) {
								this._so.addEventListener(NetStatusEvent.NET_STATUS,this.onStatusShare);
							} else if(_loc4_ == SharedObjectFlushStatus.FLUSHED) {
							}
							
						}
						catch(e:Error) {
						}
					}
					if(!(this._so.data.list == undefined) && !(this._so.data.list == null)) {
						if(PlayerConfig.preludeTime > 0) {
							if(Math.abs(_loc2_ - PlayerConfig.preludeTime) >= 15) {
								this.writeCookie(_loc2_,_loc3_);
							}
						} else {
							this.writeCookie(_loc2_,_loc3_);
						}
					} else if(PlayerConfig.preludeTime > 0) {
						if(Math.abs(_loc2_ - PlayerConfig.preludeTime) >= 15) {
							this.writeCookie(_loc2_,_loc3_);
						}
					} else {
						this.writeCookie(_loc2_,_loc3_);
					}
					
				}
			}
		}
		
		private function onStatusShare(param1:NetStatusEvent) : void {
			if(param1.info.code != "SharedObject.Flush.Success") {
				if(param1.info.code == "SharedObject.Flush.Failed") {
				}
			}
			param1.target.removeEventListener(NetStatusEvent.NET_STATUS,this.onStatusShare);
		}
		
		private function writeCookie(param1:Number, param2:Number) : void {
			this._playedTime = Math.round(param1);
			if((Eif.available) && (ExternalInterface.available)) {
				ExternalInterface.call("getVrsPlayerHistory",PlayerConfig.vid,PlayerConfig.pid,param1,param2,PlayerConfig.videoTitle);
			}
		}
		
		public function resize(param1:Number) : void {
			var _loc2_:Number = param1 - this._bg.width;
			this._bg.width = param1;
			_close_btn.x = _close_btn.x + _loc2_;
			this._hitArea.width = this._hitArea.width + _loc2_;
			this._ok_btn.x = this._ok_btn.x + _loc2_;
			this._no_btn.x = this._no_btn.x + _loc2_;
			this._toStartAndPlay_btn.x = this._toStartAndPlay_btn.x + _loc2_;
			this._cancelJump_btn.x = this._cancelJump_btn.x + _loc2_;
			this._setting_btn.x = this._setting_btn.x + _loc2_;
			this._textMask1.width = this._textMask2.width = this._textMask.width = _close_btn.x - this._textMask.x;
		}
		
		public function get breakPoint() : Number {
			return Number(this._playHistory.lastTime);
		}
		
		private function showCannotSpeedupTip() : void {
			this._isCSTipShown = true;
			this._currentState = "cannotSpeedupTip";
			this._jumpHistoryTip.visible = _close_btn.visible = true;
			this._toStartAndPlay_btn.visible = this._hitArea.visible = this._ok_btn.visible = this._no_btn.visible = false;
			this._jumpHistoryTip.text = "因版权方要求当前视频不能通过搜狐影音加速，请您谅解";
			this._hideOwnerLimit = 10 * 1000;
			this.open();
		}
		
		private function tweenComplete() : void {
			/*
			 * Decompilation error
			 * Code may be obfuscated
			 * Deobfuscation is activated but decompilation still failed. If the file is NOT obfuscated, disable "Automatic deobfuscation" for better results.
			 * Error type: TranslateException
			 */
			throw new flash.errors.IllegalOperationError("Not decompiled due to error");
		}
		
		public function get currentState() : String {
			return this._currentState;
		}
		
		override public function close(param1:* = null) : void {
			var _loc2_:Date = new Date();
			var _loc3_:* = "";
			if(param1 != null) {
				if(this._isEssenceTip) {
					SendRef.getInstance().sendPQDrog("http://click.hd.sohu.com.cn/s.gif?type=fun_haoli202921_lbwlbgb&s=" + PlayerConfig.stype + "&_=" + new Date().getTime());
				}
			}
			if(this._isOpenSVDTip) {
				this._svdUserSo.clear();
				this._svdUserSo.data.svdTag = "1";
				try {
					_loc3_ = this._svdUserSo.flush();
					if(_loc3_ == SharedObjectFlushStatus.PENDING) {
						this._svdUserSo.addEventListener(NetStatusEvent.NET_STATUS,this.onStatusShare);
					} else if(_loc3_ == SharedObjectFlushStatus.FLUSHED) {
					}
					
				}
				catch(e:Error) {
				}
				if(Eif.available) {
					ExternalInterface.call("swfOpen3D");
				}
			}
			if(this._isOpenSVDTip) {
				super.close(param1);
				dispatchEvent(new Event(Event.CLOSE));
				this._isMidAdTip = this._isShowAddSpeedTip2 = this._isShowVipUserTip = this._isEssenceTip = false;
				this._uvrObj = {};
				return;
			}
			super.close(param1);
			dispatchEvent(new Event(Event.CLOSE));
			this._isMidAdTip = this._isShowAddSpeedTip2 = this._isShowVipUserTip = this._isEssenceTip = false;
			this._uvrObj = {};
		}
		
		public function set isExtremeTip(param1:Boolean) : void {
			this._isExtremeTip = param1;
		}
		
		override public function get height() : Number {
			return this._bg.height;
		}
		
		override public function open(param1:* = null) : void {
			var evt:* = param1;
			super.open();
			clearTimeout(this._hideOwnerId);
			if(this._hideOwnerLimit > 0) {
				this._hideOwnerId = setTimeout(function():void {
					if((PlayerConfig.isFms) && !PlayerConfig.isLive && !_isCSTipShown && !PlayerConfig.isHideTip) {
						showCannotSpeedupTip();
					} else {
						close();
					}
				},this._hideOwnerLimit);
			}
			dispatchEvent(new Event(Event.OPEN));
		}
	}
}
