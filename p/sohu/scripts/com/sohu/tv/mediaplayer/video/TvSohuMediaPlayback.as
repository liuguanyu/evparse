package com.sohu.tv.mediaplayer.video {
	import com.greensock.*;
	import com.greensock.easing.*;
	import com.sohu.tv.mediaplayer.ads.*;
	import com.sohu.tv.mediaplayer.stat.*;
	import com.sohu.tv.mediaplayer.ui.*;
	import ebing.controls.*;
	import ebing.events.*;
	import ebing.media.mpb31.*;
	import ebing.net.*;
	import ebing.utils.*;
	import flash.display.*;
	import flash.events.*;
	import flash.net.*;
	import flash.system.*;
	import flash.text.*;
	import flash.utils.*;
	import com.sohu.tv.mediaplayer.PlayerConfig;
	import ebing.Utils;
	import ebing.external.Eif;
	import flash.external.ExternalInterface;
	import com.sohu.tv.mediaplayer.Model;
	import flash.geom.Rectangle;
	import com.sohu.tv.mediaplayer.ui.events.PanelEvent;
	import flash.filters.ColorMatrixFilter;
	import com.sohu.tv.mediaplayer.p2p.P2PExplorer;
	import flash.ui.Mouse;
	import flash.filters.BlurFilter;
	import flash.filters.BitmapFilterQuality;
	import flash.filters.BitmapFilter;
	import flash.filters.GlowFilter;
	
	public class TvSohuMediaPlayback extends MediaPlayback {
		
		public function TvSohuMediaPlayback() {
			this._dropFramesArr = new Array();
			this._owner = this;
			super();
		}
		
		private static var singleton:TvSohuMediaPlayback;
		
		public static const HD_BUTTON_MOUSEUP:String = "hd_button_mouseup";
		
		public static const COMMON_BUTTON_MOUSEUP:String = "common_button_mouseup";
		
		public static const SUPER_BUTTON_MOUSEUP:String = "super_button_mouseup";
		
		public static const ORI_BUTTON_MOUSEUP:String = "ori_button_mouseup";
		
		public static const EXTREME_BUTTON_MOUSEUP:String = "extreme_button_mouseup";
		
		public static function getInstance() : TvSohuMediaPlayback {
			if(singleton == null) {
				singleton = new TvSohuMediaPlayback();
			}
			return singleton;
		}
		
		private var _selectorStartAdContainer:Sprite;
		
		private var _ctrlAdContainer:Sprite;
		
		private var _topAdContainer:Sprite;
		
		private var _bottomAdContainer:Sprite;
		
		private var _startAdContainer:Sprite;
		
		private var _topLogoAdContainer:Sprite;
		
		private var _logoAdContainer:Sprite;
		
		private var _pauseAdContainer:Sprite;
		
		private var _endAdContainer:Sprite;
		
		private var _middleAdContainer:Sprite;
		
		private var _adContainer:Sprite;
		
		private var _sogouAdContainer:Sprite;
		
		private var _titleText:TextField;
		
		private var _topSideBar:Sprite;
		
		private var _topSideBarBg:Sprite;
		
		private var _topPerSp:Sprite;
		
		private var _rightSideBar:Sprite;
		
		private var _next_btn:ButtonUtil;
		
		private var _caption_btn:ButtonUtil;
		
		private var _share_btn:ButtonUtil;
		
		private var _download_btn:ButtonUtil;
		
		private var _miniWin_btn:ButtonUtil;
		
		private var _sharePanel;
		
		private var _captionPanel;
		
		private var _likePanel;
		
		private var _highlightPanel;
		
		private var _retryPanel:RetryPanel;
		
		private var _playHistoryPanel;
		
		private var _transition_mc:MovieClip;
		
		private var _rightSideBarTimeout_to:Timeout;
		
		private var _normalScreen3_btn:ButtonUtil;
		
		private var _sogou_btn:ButtonUtil;
		
		protected var _tween:TweenLite;
		
		private var _preLoadPanel;
		
		private var _isCinema:Boolean = false;
		
		private var _lightRate:Number = 0.5;
		
		private var _contrastRate:Number = 0.5;
		
		private var _saturationRate:Number = 0.5;
		
		private var _displayRate:Number = 1;
		
		private var _resetTimeLimit:Timeout;
		
		protected var _showBsbId:Number = 0;
		
		private var _showSetPId:Number = 0;
		
		private var _showSetPAutoId:Number = 0;
		
		private var _isPreLoadPanel:Boolean = false;
		
		private var _tipHistory:TipHistory;
		
		private var _lightBar:ButtonUtil;
		
		private var _lightSliderRate:Number = 0;
		
		private var _showBufferRate:Number = 0;
		
		private var _playedTime1:Number = 0;
		
		private var _playedTime30:Number = 0;
		
		private var _playedTime10:Number = 0;
		
		private var _playedTime3:Number = 0;
		
		private var _playedTime60:Number = 0;
		
		private var _playedTime4:Number = 0;
		
		private var _dfForPlayedTime60:Number = 0;
		
		private var _tvSohuLogo_btn:ButtonUtil;
		
		private var _isFbChecked:Boolean = false;
		
		private var _videoInfoPanel:VideoInfoPanel;
		
		private var _settingPanel;
		
		private var _sogouPanel;
		
		private var _p2pLogPanel;
		
		private var _mofunengPanel;
		
		private var _softInitObj:Object;
		
		private var _rtmpeUrl:String;
		
		private var _onPuaeStatId:Number = 0;
		
		private var _firstPlay:Boolean = false;
		
		private var _captionBar:CaptionBar;
		
		private var _watermark_c:Sprite;
		
		private var _timer_c:Sprite;
		
		private var _rightBarBg:Sprite;
		
		private var _activity;
		
		private var _danmu;
		
		private var _tmBarContainer:Sprite;
		
		private var _loadSkinRetryNum:uint = 3;
		
		private var _ttttt:TvSohuFMSCore;
		
		private var _ncConnectError:Boolean = false;
		
		private var _panelArr:Array;
		
		private var _filterArr:Array;
		
		private var _isJumpEndCaption:Boolean = true;
		
		private var _isJumpStartCaption:Boolean = true;
		
		private var _isViewTimer:Boolean = true;
		
		private var _searchBar;
		
		private var _isCapDrag:Boolean = false;
		
		private var _firstSet:Boolean = true;
		
		private var _isFB:String = "";
		
		private var _showTipTimeout:Number = 0;
		
		private var _isFirstConnect:Boolean = true;
		
		private var _notify_buffer:uint = 0;
		
		private var _num:uint = 0;
		
		private var _playedTime:Number = 0;
		
		private var _bfTotNum:Array;
		
		private var _owner:TvSohuMediaPlayback;
		
		protected var _definitionBar:TvSohuMultiButton;
		
		private var _replay_btn:ButtonUtil;
		
		private var _langSetBar:ButtonUtil;
		
		private var _turnOnWider_btn:ButtonUtil;
		
		private var _turnOffWider_btn:ButtonUtil;
		
		private var _albumBtn:TvSohuMultiButton;
		
		private var _ktvCore;
		
		private var _playListPanel;
		
		private var _isPlayListOk:Boolean = false;
		
		private var _barrageBtn:TvSohuButton;
		
		private var _broundPageCut;
		
		private var _topPer50_btn:ButtonUtil;
		
		private var _topPer75_btn:ButtonUtil;
		
		private var _topPer100_btn:ButtonUtil;
		
		private var _isShowNextTitle:Boolean = false;
		
		private var _oriSongBtn:ButtonUtil;
		
		private var _vocSongBtn:ButtonUtil;
		
		private var _saveIsHide:Boolean = false;
		
		private var _mpbAutoPlay:Boolean = false;
		
		private var _flatWall3D;
		
		private var streamState:String = "";
		
		private var startDragTime:uint = 0;
		
		protected var _definitionSlider:DefinitionSettingPanel;
		
		private var _ctrlShow:Bitmap;
		
		private var slidePreviewTime:uint = 0;
		
		private var _more;
		
		private var _liveCoreVersion:String = "";
		
		protected var _ctrlBtn_sp:Sprite;
		
		private var _isMyTvRotate:Boolean = false;
		
		private var _isMyTvDefinition:Boolean = false;
		
		private var _isShowPreview:Boolean = false;
		
		private var _func:Function;
		
		private var _cueTipPanel;
		
		private var _wmTipPanel;
		
		private var _isShownLogoAd:Boolean = false;
		
		private var _isShownBottomAd:Boolean = false;
		
		private var _stage:Stage;
		
		private var _isSendDFS:Boolean = false;
		
		private var _tempDropFrames:uint = 0;
		
		private var _dropFramesArr:Array;
		
		private var _isLoadRecomm:Boolean = false;
		
		private var _isSwitchVideos:Boolean = false;
		
		private var _isEssenceTip:Boolean = false;
		
		private var _hisRecommend;
		
		private var _hisRecommObj:Object;
		
		private var _isShownPauseAd:Boolean = true;
		
		private var _acmePanel;
		
		private var _isEsc:Boolean = true;
		
		private var _isUncaught:Boolean = false;
		
		private var _uncaughtError:String = "";
		
		private var _dropFramesNum:Number = 0;
		
		private var _dfForLoadedNum:Number = 0;
		
		private var _dfForSo:SharedObject;
		
		private var _isSendDfForSo:Boolean = false;
		
		private var _addDropFramesNum:Number = 0;
		
		private var _isSvdUserTip:Boolean = false;
		
		private var _licenseText:TextField;
		
		override public function hardInit(param1:Object) : void {
			this._selectorStartAdContainer = param1.selectorStartAdContainer;
			this._startAdContainer = param1.startAdContainer;
			this._endAdContainer = param1.endAdContainer;
			this._middleAdContainer = param1.middleAdContainer;
			if(param1.stage != null) {
				this._stage = param1.stage;
			}
			super.hardInit(param1);
		}
		
		override protected function sysInit(param1:String = null) : void {
			super.sysInit(param1);
			if(_skin != null) {
				this.playProgress({"obj":{
					"nowTime":0,
					"totTime":PlayerConfig.totalDuration,
					"isSeek":false
				}});
				this._lightBar.enabled = this._langSetBar.enabled = this._definitionBar.enabled = this._barrageBtn.enabled = this._oriSongBtn.enabled = this._vocSongBtn.enabled = this._albumBtn.enabled = this._albumBtn.visible = false;
				_skinMap.getValue("fullScreenBtn").e = _skinMap.getValue("normalScreenBtn").e = true;
				_fullScreen_btn.enabled = _normalScreen_btn.enabled = true;
				if((PlayerConfig.isKTVVideo) && !(this._ktvCore == null) && PlayerConfig.ktvMode == "oa") {
					_volume_sld.rate = this._ktvCore.audioCore.volume;
				}
			}
		}
		
		override protected function coreHandler(param1:Object) : void {
			var obj:Object = param1;
			this._ctrlAdContainer = new Sprite();
			this._topAdContainer = new Sprite();
			this._bottomAdContainer = new Sprite();
			this._logoAdContainer = new Sprite();
			this._topLogoAdContainer = new Sprite();
			this._pauseAdContainer = new Sprite();
			this._adContainer = new Sprite();
			this._sogouAdContainer = new Sprite();
			super.coreHandler(obj);
			if(obj.info == "success") {
				addChild(this._adContainer);
				this._adContainer.addChild(this._logoAdContainer);
				this._adContainer.addChild(this._topLogoAdContainer);
				this._adContainer.addChild(this._topAdContainer);
				this._adContainer.addChild(this._endAdContainer);
				this._adContainer.addChild(this._middleAdContainer);
				this._adContainer.addChild(this._selectorStartAdContainer);
				this._adContainer.addChild(this._startAdContainer);
				this._adContainer.addChild(this._pauseAdContainer);
				TvSohuAds.getInstance().logoAd.container = this._logoAdContainer;
				TvSohuAds.getInstance().topLogoAd.container = this._topLogoAdContainer;
				TvSohuAds.getInstance().ctrlBarAd.container = this._ctrlAdContainer;
				TvSohuAds.getInstance().sogouAd.container = this._sogouAdContainer;
				TvSohuAds.getInstance().pauseAd.container = this._pauseAdContainer;
				TvSohuAds.getInstance().topAd.container = this._topAdContainer;
				TvSohuAds.getInstance().bottomAd.container = this._bottomAdContainer;
				TvSohuAds.getInstance().endAd.container = this._endAdContainer;
				TvSohuAds.getInstance().middleAd.container = this._middleAdContainer;
				TvSohuAds.getInstance().pauseAd.addEventListener(TvSohuAdsEvent.PAUSESHOWN,this.pauseAdShown);
				TvSohuAds.getInstance().pauseAd.addEventListener(TvSohuAdsEvent.PAUSECLOSED,this.pauseAdClosed);
				TvSohuAds.getInstance().sogouAd.addEventListener(TvSohuAdsEvent.SOGOUSHOWN,this.sogouAdShown);
				TvSohuAds.getInstance().bottomAd.addEventListener(TvSohuAdsEvent.BOTTOMSHOWN,this.bottomAdShown);
				TvSohuAds.getInstance().bottomAd.addEventListener(TvSohuAdsEvent.BOTTOMHIDE,this.bottomAdHide);
				TvSohuAds.getInstance().topAd.addEventListener(TvSohuAdsEvent.TOPSHOWN,this.setAdsState);
				TvSohuAds.getInstance().ctrlBarAd.addEventListener(TvSohuAdsEvent.CTRLBARSHOWN,this.setAdsState);
				TvSohuAds.getInstance().startAd.addEventListener(TvSohuAdsEvent.SCREEN_PLAY_PROGRESS,this.adPlayProgress);
				TvSohuAds.getInstance().startAd.addEventListener("to_has_sound_icon",this.adsVolume);
				TvSohuAds.getInstance().startAd.addEventListener("to_no_sound_icon",this.adsMute);
				TvSohuAds.getInstance().startAd.addEventListener("openIFoxPanel",this.openIFoxPanel);
				TvSohuAds.getInstance().startAd.addEventListener(TvSohuAdsEvent.SCREENFINISH,this.screenAdFinish);
				TvSohuAds.getInstance().startAd.addEventListener(TvSohuAdsEvent.SCREENSHOWN,this.startAdShown);
				TvSohuAds.getInstance().startAd.addEventListener(TvSohuAdsEvent.SCREEN_LOAD_FAILED,this.adsLoadFailed);
				TvSohuAds.getInstance().middleAd.addEventListener(TvSohuAdsEvent.MIDDLESHOWN,this.middleAdShown);
				TvSohuAds.getInstance().middleAd.addEventListener(TvSohuAdsEvent.MIDDLEFINISH,this.middleAdFinish);
				TvSohuAds.getInstance().middleAd.addEventListener(TvSohuAdsEvent.SCREEN_LOAD_FAILED,this.adsLoadFailed);
				TvSohuAds.getInstance().middleAd.addEventListener(TvSohuAdsEvent.SCREEN_PLAY_PROGRESS,this.adPlayProgress);
				TvSohuAds.getInstance().middleAd.addEventListener("to_has_sound_icon",this.adsVolume);
				TvSohuAds.getInstance().middleAd.addEventListener("to_no_sound_icon",this.adsMute);
				TvSohuAds.getInstance().endAd.addEventListener("to_has_sound_icon",this.adsVolume);
				TvSohuAds.getInstance().endAd.addEventListener("to_no_sound_icon",this.adsMute);
				TvSohuAds.getInstance().endAd.addEventListener(TvSohuAdsEvent.SCREEN_PLAY_PROGRESS,this.adPlayProgress);
				TvSohuAds.getInstance().endAd.addEventListener(TvSohuAdsEvent.ENDFINISH,this.endAdFinish);
				TvSohuAds.getInstance().endAd.addEventListener(TvSohuAdsEvent.SCREENSHOWN,this.endAdShown);
				TvSohuAds.getInstance().endAd.addEventListener(TvSohuAdsEvent.SCREEN_LOAD_FAILED,this.adsLoadFailed);
				TvSohuAds.getInstance().logoAd.addEventListener(TvSohuAdsEvent.LOGOSHOWN,this.logoAdShown);
				TvSohuAds.getInstance().logoAd.addEventListener(TvSohuAdsEvent.LOGOFINISH,this.logoAdFinish);
				TvSohuAds.getInstance().topLogoAd.addEventListener(TvSohuAdsEvent.LOGOSHOWN,this.setAdsState);
			}
			if(PlayerConfig.watermarkPath != "") {
				this._watermark_c = new Sprite();
				addChild(this._watermark_c);
				this._watermark_c.visible = false;
				new LoaderUtil().load(10,function(param1:Object):void {
					var _loc2_:uint = 0;
					var _loc3_:uint = 0;
					if(param1.info == "success") {
						_loc2_ = _watermark_c.numChildren;
						_loc3_ = 0;
						while(_loc3_ < _loc2_) {
							_watermark_c.removeChildAt(_loc3_);
							_loc3_++;
						}
						param1.data.content.smoothing = true;
						_watermark_c.addChild(param1.data);
					}
				},null,PlayerConfig.watermarkPath,new LoaderContext(true));
			}
		}
		
		private function setWatermark() : void {
			var _loc1_:* = NaN;
			var _loc2_:* = NaN;
			var _loc3_:* = NaN;
			var _loc4_:* = NaN;
			if(!(this._watermark_c == null) && !(this._watermark_c.width == 0) && !(this._watermark_c.height == 0) && !(_core.videoContainer.width == 0) && !(_core.videoContainer.height == 0)) {
				_loc1_ = _core.videoContainer.width * 0.16;
				_loc2_ = _loc1_ / this._watermark_c.getChildAt(0)["contentLoaderInfo"].width;
				_loc3_ = this._watermark_c.getChildAt(0)["contentLoaderInfo"].height * _loc2_;
				_loc4_ = _loc3_ / this._watermark_c.getChildAt(0)["contentLoaderInfo"].height;
				if(_loc3_ / _core.videoContainer.height > 0.16) {
					_loc3_ = _core.videoContainer.height * 0.16;
					_loc4_ = _loc3_ / this._watermark_c.getChildAt(0)["contentLoaderInfo"].height;
					_loc1_ = this._watermark_c.getChildAt(0)["contentLoaderInfo"].width * _loc4_;
					_loc2_ = _loc1_ / this._watermark_c.getChildAt(0)["contentLoaderInfo"].width;
				}
				this._watermark_c.width = _loc1_;
				this._watermark_c.height = _loc3_;
				if(PlayerConfig.watermarkPos == "left-top") {
					this._watermark_c.x = Math.round(_core.x + _core.videoContainer.x + _loc2_ * (PlayerConfig.vid == PlayerConfig.superVid?32:20));
					this._watermark_c.y = Math.round(_core.y + _core.videoContainer.y + _loc4_ * (PlayerConfig.vid == PlayerConfig.superVid?32:20));
				} else if(PlayerConfig.watermarkPos == "right-top") {
					this._watermark_c.x = Math.round(_core.x + _core.videoContainer.x + _core.videoContainer.width - (this._watermark_c.width + _loc2_ * (PlayerConfig.vid == PlayerConfig.superVid?32:20)));
					this._watermark_c.y = Math.round(_core.y + _core.videoContainer.y + _loc4_ * (PlayerConfig.vid == PlayerConfig.superVid?32:20));
				} else if(PlayerConfig.watermarkPos == "left-bottom") {
					this._watermark_c.x = Math.round(_core.x + _core.videoContainer.x + _loc2_ * (PlayerConfig.vid == PlayerConfig.superVid?32:20));
					this._watermark_c.y = Math.round(_core.videoContainer.y + _core.videoContainer.height - this._watermark_c.height - _loc4_ * (PlayerConfig.vid == PlayerConfig.superVid?32:20));
				} else if(PlayerConfig.watermarkPos == "right-bottom") {
					this._watermark_c.x = Math.round(_core.x + _core.videoContainer.x + _core.videoContainer.width - (this._watermark_c.width + _loc2_ * (PlayerConfig.vid == PlayerConfig.superVid?32:20)));
					this._watermark_c.y = Math.round(_core.videoContainer.y + _core.videoContainer.height - this._watermark_c.height - _loc4_ * (PlayerConfig.vid == PlayerConfig.superVid?32:20));
				}
				
				
				
				this._watermark_c.visible = true;
			}
		}
		
		public function setAdsState(param1:TvSohuAdsEvent = null) : void {
			var _loc7_:* = NaN;
			var _loc2_:Number = 0;
			var _loc3_:Number = _core.width;
			var _loc4_:Number = _core.height;
			var _loc5_:Number = _core.videoContainer.width;
			var _loc6_:Number = _core.videoContainer.height;
			TvSohuAds.getInstance().logoAd.container.x = _core.videoContainer.x + _loc5_ - TvSohuAds.getInstance().logoAd.width - 5;
			TvSohuAds.getInstance().logoAd.container.y = _core.videoContainer.y + _loc6_ - TvSohuAds.getInstance().logoAd.height - 5;
			if(_skin != null) {
				if(TvSohuAds.getInstance().logoAd.container.y + TvSohuAds.getInstance().logoAd.height > stage.stageHeight - _ctrlBarBg_spr.height) {
					TvSohuAds.getInstance().logoAd.container.y = stage.stageHeight - _ctrlBarBg_spr.height - TvSohuAds.getInstance().logoAd.height - _progress_sld["sliderDiffHeight"];
				}
			}
			Utils.debug("vx:" + _core.videoContainer.x + " coreMetaWidth:" + _loc5_ + " logoAd.width:" + TvSohuAds.getInstance().logoAd.width);
			TvSohuAds.getInstance().logoAd.changeAd();
			TvSohuAds.getInstance().topLogoAd.container.x = _loc3_ - TvSohuAds.getInstance().topLogoAd.width - 6;
			if(stage.displayState == StageDisplayState.FULL_SCREEN || (PlayerConfig.isBrowserFullScreen)) {
				if(TvSohuAds.getInstance().topAd.hasAd) {
					TvSohuAds.getInstance().topLogoAd.container.y = TvSohuAds.getInstance().topAd.container.height;
				} else {
					TvSohuAds.getInstance().topLogoAd.container.y = 28;
				}
			} else {
				TvSohuAds.getInstance().topLogoAd.container.y = 6;
			}
			TvSohuAds.getInstance().topLogoAd.changeAd();
			TvSohuAds.getInstance().pauseAd.changeSize(_loc3_,_loc4_);
			TvSohuAds.getInstance().pauseAd.container.x = Math.round(_loc3_ / 2 - TvSohuAds.getInstance().pauseAd.width / 2);
			TvSohuAds.getInstance().pauseAd.container.y = Math.round(_loc4_ / 2 - TvSohuAds.getInstance().pauseAd.height / 2);
			if(!(TvSohuAds.getInstance().pauseAd.adAlign == "") && TvSohuAds.getInstance().pauseAd.adAlign == "d") {
				TvSohuAds.getInstance().pauseAd.container.y = _loc4_ - (TvSohuAds.getInstance().pauseAd.height + (!(_skin == null) && stage.displayState == "fullScreen"?_ctrlBarBg_spr.height:0));
			}
			TvSohuAds.getInstance().selectorStartAd.resize(_loc3_,_loc4_);
			TvSohuAds.getInstance().startAd.resize(_loc3_,_loc4_);
			TvSohuAds.getInstance().endAd.resize(_loc3_,_loc4_);
			TvSohuAds.getInstance().middleAd.resize(_loc3_,_loc4_);
			TvSohuAds.getInstance().sogouAd.resize(_loc3_,0);
			TvSohuAds.getInstance().sogouAd.container.y = -TvSohuAds.getInstance().sogouAd.height;
			TvSohuAds.getInstance().bottomAd.resize(_loc3_,0);
			TvSohuAds.getInstance().bottomAd.container.y = -TvSohuAds.getInstance().bottomAd.height;
			TvSohuAds.getInstance().topAd.resize(_loc3_,0);
			if(_skin != null) {
				if((TvSohuAds.getInstance().ctrlBarAd.hasAd) && TvSohuAds.getInstance().ctrlBarAd.state == "no") {
					TvSohuAds.getInstance().ctrlBarAd.play();
				} else {
					TvSohuAds.getInstance().ctrlBarAd.pingback();
				}
				if(TvSohuAds.getInstance().ctrlBarAd.hasAd) {
					TvSohuAds.getInstance().ctrlBarAd.changeAd();
					_loc7_ = 0;
					if(this._barrageBtn.visible) {
						_loc7_ = this._barrageBtn.x - (_timeDisplay.x + _timeDisplay.width);
					} else if(PlayerConfig.isKTVVideo) {
						_loc7_ = this._oriSongBtn.x - (_timeDisplay.x + _timeDisplay.width);
					} else {
						_loc7_ = _volume_sld.x - (_timeDisplay.x + _timeDisplay.width);
					}
					
					TvSohuAds.getInstance().ctrlBarAd.container.x = Math.round(_timeDisplay.x + _timeDisplay.width + _loc7_ / 2 - TvSohuAds.getInstance().ctrlBarAd.width / 2);
					TvSohuAds.getInstance().ctrlBarAd.container.y = _skinMap.getValue("ctrlBarAd").y;
					if(TvSohuAds.getInstance().ctrlBarAd.container.visible) {
						if(_loc7_ < TvSohuAds.getInstance().ctrlBarAd.metaWidth) {
							TvSohuAds.getInstance().ctrlBarAd.container.x = Math.round(_timeDisplay.x + _timeDisplay.width);
							TvSohuAds.getInstance().ctrlBarAd.width = _loc7_;
							TvSohuAds.getInstance().ctrlBarAd.normalAd_c.width = TvSohuAds.getInstance().ctrlBarAd.width;
							TvSohuAds.getInstance().ctrlBarAd.normalAd_c.height = TvSohuAds.getInstance().ctrlBarAd.height;
							if(_loc7_ < 160) {
								TvSohuAds.getInstance().ctrlBarAd.container.visible = false;
								TvSohuAds.getInstance().ctrlBarAd.container.alpha = 0;
							} else {
								TvSohuAds.getInstance().ctrlBarAd.container.visible = true;
								TvSohuAds.getInstance().ctrlBarAd.container.alpha = 100;
							}
						} else {
							TvSohuAds.getInstance().ctrlBarAd.width = TvSohuAds.getInstance().ctrlBarAd.metaWidth;
							TvSohuAds.getInstance().ctrlBarAd.normalAd_c.width = TvSohuAds.getInstance().ctrlBarAd.width;
							TvSohuAds.getInstance().ctrlBarAd.normalAd_c.height = TvSohuAds.getInstance().ctrlBarAd.height;
							TvSohuAds.getInstance().ctrlBarAd.container.visible = true;
							TvSohuAds.getInstance().ctrlBarAd.container.alpha = 100;
						}
					}
				}
			}
		}
		
		private function startAdShown(param1:TvSohuAdsEvent) : void {
			if(!(this._playListPanel == null) && (this._playListPanel.isOpen)) {
				this._playListPanel.close();
			}
			if(!(this._settingPanel == null) && (this._settingPanel.visible)) {
				this._settingPanel.close();
			}
			this.setSkinState();
		}
		
		private function middleAdShown(param1:TvSohuAdsEvent) : void {
			_core.pause(0);
			this.setAdsState();
			if(!(this._playListPanel == null) && (this._playListPanel.isOpen)) {
				this._playListPanel.close();
			}
			if(!(this._settingPanel == null) && (this._settingPanel.visible)) {
				this._settingPanel.close();
			}
			this.setSkinState();
			if((Eif.available) && !(PlayerConfig.onMAdShown == "")) {
				LogManager.msg("展示中插广告回调js方法：:" + PlayerConfig.onMAdShown);
				ExternalInterface.call(PlayerConfig.onMAdShown);
			}
		}
		
		private function middleAdFinish(param1:TvSohuAdsEvent) : void {
			PlayerConfig.advolume = null;
			_core.play();
			_volume_sld.rate = _core.volume;
			if(TvSohuAds.getInstance().ctrlBarAd.hasAd) {
				TvSohuAds.getInstance().ctrlBarAd.container.visible = true;
				TvSohuAds.getInstance().ctrlBarAd.container.alpha = 100;
			}
			this.setSkinState();
			if((Eif.available) && !(PlayerConfig.onMAdFinish == "")) {
				LogManager.msg("中插广告播放结束回调js方法：:" + PlayerConfig.onMAdFinish);
				ExternalInterface.call(PlayerConfig.onMAdFinish);
			}
		}
		
		private function logoAdShown(param1:TvSohuAdsEvent) : void {
			this._isShownLogoAd = true;
			if(this._cueTipPanel != null) {
				this._cueTipPanel.visible = false;
			}
			this.setSkinState();
		}
		
		private function logoAdFinish(param1:TvSohuAdsEvent) : void {
			this._isShownLogoAd = false;
			if(this._cueTipPanel != null) {
				this._cueTipPanel.visible = true;
			}
			this.setSkinState();
		}
		
		private function endAdShown(param1:TvSohuAdsEvent) : void {
			if(!(this._playListPanel == null) && (this._playListPanel.isOpen)) {
				this._playListPanel.close();
			}
			if(!(this._settingPanel == null) && (this._settingPanel.visible)) {
				this._settingPanel.close();
			}
			this.setSkinState();
		}
		
		private function endAdFinish(param1:TvSohuAdsEvent) : void {
			PlayerConfig.advolume = null;
			_volume_sld.rate = _core.volume;
			if(TvSohuAds.getInstance().ctrlBarAd.hasAd) {
				TvSohuAds.getInstance().ctrlBarAd.container.visible = true;
				TvSohuAds.getInstance().ctrlBarAd.container.alpha = 100;
			}
			this.sysInit();
		}
		
		override protected function dragStart(param1:* = null) : void {
			super.dragStart(param1);
		}
		
		override protected function dragEnd(param1:* = null) : void {
			super.dragEnd(param1);
		}
		
		private function screenAdFinish(param1:TvSohuAdsEvent) : void {
			if(_skin != null) {
				PlayerConfig.advolume = null;
				_volume_sld.rate = _core.volume;
				if(TvSohuAds.getInstance().ctrlBarAd.hasAd) {
					TvSohuAds.getInstance().ctrlBarAd.container.visible = true;
					TvSohuAds.getInstance().ctrlBarAd.container.alpha = 100;
				}
				this.setSkinState();
			}
		}
		
		private function adsLoadFailed(param1:TvSohuAdsEvent) : void {
			if(_skin != null) {
				PlayerConfig.advolume = null;
				_volume_sld.rate = _core.volume;
			}
		}
		
		private function adsVolume(param1:Event) : void {
			param1.target.volume = 0.5;
			if(_skin != null) {
				_volume_sld.rate = 0.5;
				this.setSkinState();
			}
		}
		
		private function adsMute(param1:Event) : void {
			param1.target.volume = 0;
			if(_skin != null) {
				_volume_sld.rate = 0;
				this.setSkinState();
			}
		}
		
		private function openIFoxPanel(param1:Event) : void {
			if(!(_skin == null) && stage.displayState == "fullScreen") {
				_normalScreen_btn.dispatchEvent(new MouseEventUtil(MouseEventUtil.CLICK));
			}
		}
		
		override protected function onPlayed(param1:Event = null) : void {
			var jsVideoInfo:Object = null;
			var evt:Event = param1;
			super.onPlayed(evt);
			if(_skin != null) {
				if(PlayerConfig.h2644kVid == PlayerConfig.currentVid && !this._tipHistory.isExtremeTip) {
					this._tipHistory.showExtremeTip();
				} else {
					this._tipHistory.checkAndTip();
				}
			}
			if((PlayerConfig.isKTVVideo) && PlayerConfig.ktvMode == "oa") {
				this._oriSongBtn.dispatchEvent(new MouseEventUtil(MouseEventUtil.CLICK));
			}
			if(this._timer_c.numChildren == 0) {
				new LoaderUtil().load(10,function(param1:Object):void {
					var _loc2_:* = undefined;
					if(param1.info == "success") {
						_loc2_ = param1.data;
						_loc2_.name = "timeMc";
						_timer_c.addChild(_loc2_);
						setSkinState();
					}
				},null,PlayerConfig.swfHost + "other/time.swf");
			}
			if(!(PlayerConfig.cueTipEpInfo == null) && PlayerConfig.cueTipEpInfo.length >= 1) {
				this.showCueTip();
			}
			if(PlayerConfig.cooperator == "MofunEnglish") {
				this.showMofunEnglishPanel();
			}
			if(!(PlayerConfig.wmDataInfo == null) && (PlayerConfig.isWmVideo) || !(PlayerConfig.isai == "") && PlayerConfig.isai == "1") {
				if(Eif.available) {
					jsVideoInfo = this.getJSVarObj("_videoInfo");
					PlayerConfig.visitorId = !(jsVideoInfo == null) && !(jsVideoInfo.visitor_id == null) && !(jsVideoInfo.visitor_id == "") && !(jsVideoInfo.visitor_id == "0")?jsVideoInfo.visitor_id:"";
				}
				if(PlayerConfig.showPgcModule) {
					this.showWmTip();
				}
			}
			if(Utils.getBrowserCookie("fee_channel") == "3") {
				new URLLoaderUtil().load(10,function(param1:Object):void {
					var _loc2_:Object = null;
					if(param1.info == "success") {
						_loc2_ = new JSON().parse(param1.data);
					}
				},"http://store.tv.sohu.com/web/speed/tvSpeed.do?nt=" + PlayerConfig.isp);
			}
			if(PlayerConfig.isShowTanmu) {
				this.showTanmu();
			}
		}
		
		private function showTanmu() : void {
			var context:LoaderContext = null;
			if(this._danmu == null) {
				context = new LoaderContext();
				context.securityDomain = SecurityDomain.currentDomain;
				context.applicationDomain = new ApplicationDomain(ApplicationDomain.currentDomain);
				new LoaderUtil().load(10,function(param1:Object):void {
					if(param1.info == "success") {
						_danmu = param1.data.content;
						_owner.addChildAt(_danmu,_owner.getChildIndex(_core) + 1);
						_danmu.init(_core.width,_core.height,PlayerConfig.vid,PlayerConfig.isMyTvVideo?"sohu_ugc_player":"sohu_vrs_player",3,PlayerConfig.danmuDefaultStatus == "2"?true:false,PlayerConfig.vrsPlayListId != ""?PlayerConfig.vrsPlayListId:PlayerConfig.pid,PlayerConfig.passportUID,PlayerConfig.isMyTvVideo?PlayerConfig.myTvUserId:"",PlayerConfig.totalDuration,"m",120);
						_danmu.addEventListener("__onTmDataGet",onTmDataComplete);
						_danmu.addEventListener("__onTmDataErr",onTmDataFailHandler);
						_danmu.addEventListener("__onTmNoData",onTmDataFailHandler);
						_danmu.addEventListener("__onTmDataFailed",onTmDataFailHandler);
						setSkinState();
						_danmu.play();
						if((PlayerConfig.isShowTanmu) && !PlayerConfig.isSohuDomain) {
							_skinMap.getValue("barrageBtn").e = _skinMap.getValue("barrageBtn").v = true;
							_barrageBtn.clicked = _danmu.getTmShow();
						}
					}
				},null,PlayerConfig.TANMU_SWF_URL,context);
			}
		}
		
		private function onTmDataComplete(param1:*) : void {
			LogManager.msg("TTTTTTYYYYYYYUUUUUUUUUUUUUUUUUUUU:" + param1["data"]);
		}
		
		private function onTmDataFailHandler(param1:*) : void {
			LogManager.msg("UUUUUUUUUUUUUUUUUUUUvalue:" + param1.data.value + " text:" + param1.data.text);
		}
		
		override protected function volumeSlideEnd(param1:SliderEventUtil) : void {
			var _loc2_:SharedObject = null;
			var _loc3_:String = null;
			if((TvSohuAds.getInstance().startAd.hasAd) && TvSohuAds.getInstance().startAd.state == "playing") {
				TvSohuAds.getInstance().startAd.saveVolume();
			} else if((TvSohuAds.getInstance().endAd.hasAd) && TvSohuAds.getInstance().endAd.state == "playing") {
				TvSohuAds.getInstance().endAd.saveVolume();
			} else if((TvSohuAds.getInstance().middleAd.hasAd) && TvSohuAds.getInstance().middleAd.state == "playing") {
				TvSohuAds.getInstance().middleAd.saveVolume();
			} else if(!PlayerConfig.isKTVVideo || (PlayerConfig.isKTVVideo) && PlayerConfig.ktvMode == "va") {
				_core.saveVolume();
			} else {
				if((PlayerConfig.isKTVVideo) && !(this._ktvCore == null) && PlayerConfig.ktvMode == "oa") {
					_loc2_ = SharedObject.getLocal("so","/");
					_loc2_.data.volume = this._ktvCore.audioCore.volume;
					try {
						_loc3_ = _loc2_.flush();
						if(_loc3_ == SharedObjectFlushStatus.PENDING) {
							if(!_loc2_.hasEventListener(NetStatusEvent.NET_STATUS)) {
								_loc2_.addEventListener(NetStatusEvent.NET_STATUS,this.onStatusShare);
							}
						} else if(_loc3_ == SharedObjectFlushStatus.FLUSHED) {
						}
						
					}
					catch(e:Error) {
					}
				}
				if((PlayerConfig.isKTVVideo) && !(this._ktvCore == null) && PlayerConfig.ktvMode == "oa") {
				}
			}
			
			
			
		}
		
		override protected function volumeSlide(param1:SliderEventUtil) : void {
			if((TvSohuAds.getInstance().startAd.hasAd) && TvSohuAds.getInstance().startAd.state == "playing") {
				TvSohuAds.getInstance().startAd.volume = param1.obj.rate;
			} else if((TvSohuAds.getInstance().endAd.hasAd) && TvSohuAds.getInstance().endAd.state == "playing") {
				TvSohuAds.getInstance().endAd.volume = param1.obj.rate;
			} else if((TvSohuAds.getInstance().middleAd.hasAd) && TvSohuAds.getInstance().middleAd.state == "playing") {
				TvSohuAds.getInstance().middleAd.volume = param1.obj.rate;
			} else if(!PlayerConfig.isKTVVideo || (PlayerConfig.isKTVVideo) && PlayerConfig.ktvMode == "va") {
				_core.volume = param1.obj.rate;
			}
			
			
			
			if((PlayerConfig.isKTVVideo) && !(this._ktvCore == null)) {
				if(PlayerConfig.ktvMode == "oa") {
					this._ktvCore.audioCore.volume = param1.obj.rate;
				}
			}
		}
		
		override protected function loadCore() : void {
			var ele:Object = null;
			var gslbUrl:String = null;
			ele = {
				"width":_width,
				"height":_height,
				"buffer":_parObj.buffer,
				"isWriteLog":true,
				"stage":this._stage
			};
			if(PlayerConfig.isFms) {
				gslbUrl = "http://" + PlayerConfig.gslbIp + "/?prot=2&type=1&" + Math.random();
				LogManager.msg("开始请求FMS调度url:" + gslbUrl);
				new URLLoaderUtil().load(10,function(param1:Object):void {
					var _loc2_:String = null;
					var _loc3_:String = null;
					var _loc4_:Array = null;
					if(param1.info == "success") {
						LogManager.msg("FMS调度成功:" + param1.data);
						_loc2_ = param1.data;
						_loc3_ = "";
						_loc4_ = _loc2_.split("|");
						_loc3_ = _loc4_[0];
						if(!PlayerConfig.isLive) {
							_loc3_ = _loc3_.substring(0,_loc3_.length - 1);
						}
						PlayerConfig.cdnIp = _loc4_[0];
						PlayerConfig.cdnId = _loc4_[1];
						PlayerConfig.clientIp = _loc4_[2];
					} else {
						LogManager.msg("FMS调度失败，失败原因:" + param1.info + " 超时时限：" + param1.target.timeLimit + " FMS连接地址使用：rtmpe://stream.vod.itc.cn");
						PlayerConfig.all700ErrNo++;
						if(param1.info == "ioError") {
							ErrorSenderPQ.getInstance().sendPQStat({
								"error":PlayerConfig.GSLB_ERROR_FAILED,
								"code":PlayerConfig.GSLB_CODE,
								"split":0,
								"dom":gslbUrl,
								"drag":-1,
								"allno":1,
								"all700no":PlayerConfig.all700ErrNo,
								"errno":1,
								"datarate":0
							});
						} else if(param1.info == "timeout") {
							ErrorSenderPQ.getInstance().sendPQStat({
								"error":PlayerConfig.GSLB_ERROR_TIMEOUT,
								"code":PlayerConfig.GSLB_CODE,
								"split":0,
								"dom":gslbUrl,
								"drag":-1,
								"allno":1,
								"all700no":PlayerConfig.all700ErrNo,
								"errno":1,
								"datarate":0
							});
						}
						
						_loc3_ = "rtmpe://stream.vod.itc.cn";
					}
					if(!(_loc3_ == "") && !(_loc3_ == null)) {
						ele.doInit = false;
						ele.rtmpeUrl = _loc3_ + (PlayerConfig.isLive?"/live":":80/vod/");
						_rtmpeUrl = ele.rtmpeUrl;
						ele.hardInitHandler = onCoreHardInit;
						_ttttt = new TvSohuFMSCore(ele);
						PlayerConfig.currentCore = "TvSohuFMSCore";
						_ttttt.addEventListener(MediaEvent.NC_RETRY_FAILED,ncRetryFailed);
						_ttttt.hardInit(ele);
					} else {
						LogManager.msg("FMS服务器IP异常：" + _loc3_);
					}
				},gslbUrl);
			} else if(PlayerConfig.isAlbumVideo) {
				new LoaderUtil().load(10,function(param1:Object):void {
					var _loc2_:* = undefined;
					if(param1.info == "success") {
						LogManager.msg("*****************AlbumCore加载成功:");
						_loc2_ = param1.data.content;
						_loc2_.initData(Model.getInstance().videoInfo.data);
						coreHandler({
							"info":"success",
							"data":{"content":_loc2_}
						});
					} else {
						LogManager.msg("AlbumCore加载失败");
					}
				},null,PlayerConfig.swfHost + "otherCore/AlbumCore.swf");
			} else if(PlayerConfig.isLive) {
				new LoaderUtil().load(10,function(param1:Object):void {
					var liveCore:* = undefined;
					var obj:Object = param1;
					if(obj.info == "success") {
						LogManager.msg("LiveCore加载成功:");
						liveCore = obj.data.content;
						if(!PlayerConfig.isP2PLive) {
							liveCore.initP2P(function():void {
								liveCore.init({
									"buffer":3,
									"width":1,
									"height":1,
									"isWriteLog":true
								});
								coreHandler({
									"info":"success",
									"data":{"content":liveCore}
								});
							});
						} else {
							liveCore.init({
								"buffer":3,
								"width":1,
								"height":1,
								"isWriteLog":true
							});
							coreHandler({
								"info":"success",
								"data":{"content":liveCore}
							});
						}
						try {
							if(!(liveCore.PLCoreVersion == null) && !(liveCore.PLCoreVersion == "")) {
								_liveCoreVersion = liveCore.PLCoreVersion;
								LogManager.msg("PLCoreVersion:" + _liveCoreVersion);
								dispatchEvent(new Event("liveCoreVer"));
							}
						}
						catch(evt:*) {
						}
					} else {
						LogManager.msg("LiveCore加载失败");
					}
					if(obj.info == "success") {
						return;
					}
				},null,PlayerConfig.swfHost + "otherCore/PLVideoCore.swf");
			} else {
				ele.doInit = true;
				ele.isWriteLog = true;
				PlayerConfig.currentCore = "TvSohuVideoCore";
				this.coreHandler({
					"info":"success",
					"data":{"content":new TvSohuVideoCore(ele)}
				});
			}
			
			
		}
		
		override protected function coreLoadSuccess() : void {
			if(_core != null) {
				addChild(_core);
			}
			if(_cover_c == null) {
				_cover_c = new Sprite();
				_core.x = _core.y = 0;
				addChild(_cover_c);
			}
			this.loadSkin();
		}
		
		private function onCoreHardInit(param1:Object) : void {
			if(param1.info == "success") {
				this.coreHandler({
					"info":"success",
					"data":{"content":this._ttttt}
				});
			} else if(param1.info == "timeout") {
			}
			
		}
		
		override public function softInit(param1:Object) : void {
			this._softInitObj = param1;
			var _loc2_:String = param1.filePath;
			var _loc3_:String = param1.fileTime;
			var _loc4_:String = param1.fileSize;
			var _loc5_:Boolean = param1.is200;
			_isDrag = param1.isDrag;
			_coverImgPath = param1.cover;
			this._isPreLoadPanel = false;
			if(_skin != null) {
				_progress_sld.isDrag = _isDrag;
			}
			_core.initMedia({
				"size":_loc4_,
				"time":_loc3_,
				"flv":_loc2_,
				"isDrag":_isDrag,
				"is200":_loc5_
			});
			if(!(PlayerConfig.myTvRotate == 0) && !this._isMyTvRotate) {
				_core.setR(PlayerConfig.myTvRotate);
				this._isMyTvRotate = true;
			} else if(PlayerConfig.myTvRotate == 0 && (this._isMyTvRotate)) {
				_core.setR(0);
				this._isMyTvRotate = false;
			}
			
			if(!(PlayerConfig.myTvDefinition == "") && PlayerConfig.myTvDefinition == "16:9" && !this._isMyTvDefinition) {
				_core.displayTo16_9();
				this._isMyTvDefinition = true;
			} else if(!(PlayerConfig.myTvDefinition == "") && PlayerConfig.myTvDefinition == "4:3") {
				_core.displayTo4_3();
				this._isMyTvDefinition = true;
			} else if(PlayerConfig.myTvDefinition == "" && (this._isMyTvDefinition)) {
				_core.displayToMeta();
				this._isMyTvDefinition = false;
			}
			
			
			this._playedTime1 = this._playedTime30 = this._playedTime3 = this._playedTime4 = this._playedTime60 = this._playedTime10 = this._dfForPlayedTime60 = 0;
			this._dropFramesArr = [];
			this._isShownLogoAd = this._isShownBottomAd = false;
			this._isShownPauseAd = true;
			this._isSendDFS = this._isLoadRecomm = this._isEssenceTip = this._isUncaught = this._isSendDfForSo = this._isSvdUserTip = false;
			this._hisRecommObj = {};
			this._tempDropFrames = 0;
			this._dropFramesNum = 0;
			this._dfForLoadedNum = 0;
			this._addDropFramesNum = 0;
			this._uncaughtError = "";
		}
		
		private function playOrPause(param1:Event) : void {
			var evt:Event = param1;
			if(_core.streamState == "stop") {
				_startPlay_btn.dispatchEvent(new MouseEvent(MouseEvent.MOUSE_UP));
			} else if((!PlayerConfig.autoPlay && TvSohuAds.getInstance().startAd.hasAd && !TvSohuAds.getInstance().startAd.isAutoPlayAd) && (!this._mpbAutoPlay) && TvSohuAds.getInstance().startAd.state == "no") {
				TvSohuAds.getInstance().startAd.play();
				dispatchEvent(new Event("ChangeAutoPlay"));
				this._mpbAutoPlay = true;
			} else {
				if(_core.streamState == "pause") {
					SendRef.getInstance().sendPQDrog("http://click.hd.sohu.com.cn/s.gif?type=fun_yangli205733_PL_S_Play&s=" + PlayerConfig.stype + "&_=" + new Date().getTime());
				} else if(_core.streamState == "play") {
					SendRef.getInstance().sendPQDrog("http://click.hd.sohu.com.cn/s.gif?type=fun_yangli205733_PL_S_Pause&s=" + PlayerConfig.stype + "&_=" + new Date().getTime());
				}
				
				_core.playOrPause(evt);
			}
			
			if((PlayerConfig.isJump) && PlayerConfig.apiKey == "" && _core.streamState == "pause") {
				try {
					if(!PlayerConfig.isPartner) {
						if(!(PlayerConfig.filePrimaryReferer == null) && !(PlayerConfig.filePrimaryReferer == "")) {
							Utils.openWindow(PlayerConfig.filePrimaryReferer);
						}
						SendRef.getInstance().sendPQVPC("PL_S_GotoTV");
					}
				}
				catch(evt:SecurityError) {
				}
			}
			if((PlayerConfig.isJump) && PlayerConfig.apiKey == "" && _core.streamState == "pause") {
				return;
			}
		}
		
		override protected function addEvent() : void {
			super.addEvent();
			_core.addEventListener(MediaEvent.RETRY_FAILED,this.fileRetryFailed);
			_core.addEventListener("NS.Play.Start",function(param1:Event):void {
				if(_core.videoArr[_core.downloadIndex].ns.hasP2P) {
					checkXXX();
				}
			});
			this._replay_btn.addEventListener(MouseEventUtil.MOUSE_UP,this.replay);
			this._next_btn.addEventListener(MouseEventUtil.MOUSE_UP,this.nextClickHandler);
			this._share_btn.addEventListener(MouseEventUtil.MOUSE_UP,this.sharePanel);
			this._download_btn.addEventListener(MouseEvent.MOUSE_UP,this.downloadVideo);
			this._miniWin_btn.addEventListener(MouseEventUtil.CLICK,this.miniWinMouseClick);
			this._sogou_btn.addEventListener(MouseEventUtil.MOUSE_UP,this.showSogouPanel);
			this._turnOnWider_btn.addEventListener(MouseEventUtil.MOUSE_UP,this.cinemaMouseClick);
			this._turnOffWider_btn.addEventListener(MouseEventUtil.MOUSE_UP,this.windowMouseClick);
			this._rightSideBarTimeout_to.addEventListener(Timeout.TIMEOUT,this.hideSideBar);
			this._caption_btn.addEventListener(MouseEventUtil.MOUSE_UP,this.showCaptionPanel);
			stage.addEventListener(MouseEvent.MOUSE_OUT,this.onStageMouseOut);
			this._resetTimeLimit.addEventListener(Timeout.TIMEOUT,this.resetBuffNum);
			_progress_sld.addEventListener(SliderEventUtil.SLIDER_PREVIEW_RATE,this.progressSlidePreview);
			if(this._captionBar != null) {
				this._captionBar.addEventListener(MouseEvent.MOUSE_OVER,this.capBarMouseOver);
				this._captionBar.addEventListener(MouseEvent.MOUSE_OUT,this.capBarMouseOut);
				this._captionBar.addEventListener(MouseEvent.MOUSE_DOWN,this.capBarMouseDown);
				this._captionBar.addEventListener(MouseEvent.MOUSE_UP,this.capBarMouseUp);
			}
			_progress_sld.addEventListener("forward",this.forward);
			_progress_sld.addEventListener("backward",this.backward);
			_progress_sld.addEventListener("dot_seek",this.dotSeek);
			_progress_sld.addEventListener("wall3DOpen",function(param1:Event):void {
				showPriviewPic();
			});
			_progress_sld.addEventListener("newPreOver",function(param1:Event):void {
				_isShowPreview = true;
			});
			_progress_sld.addEventListener("newPreOut",function(param1:Event):void {
				_isShowPreview = false;
			});
			_progress_sld.addEventListener("proKeyboardTip",function(param1:Event):void {
				tipProKeyboardCookie();
			});
			_volume_sld.slider.addEventListener(SliderEventUtil.SLIDER_RATE,this.volumeBarPreview);
			this._definitionSlider.addEventListener(MouseEvent.MOUSE_OUT,this.hideDefinitionSideBar);
			this._definitionBar.addEventListener(MouseEventUtil.MOUSE_OUT,this.hideDefinitionSideBar);
			this._definitionBar.addEventListener(MouseEventUtil.MOUSE_OVER,this.showDefinitionSideBar);
			this._definitionSlider.addEventListener("settingFinish",this.dspSettingFinish);
			this._definitionSlider.addEventListener("showAcmePanel",this.showAcmePanel);
			this._lightBar.addEventListener(MouseEventUtil.MOUSE_OVER,this.showSettingPanel);
			this._lightBar.addEventListener(MouseEventUtil.MOUSE_OUT,this.hideSettingPanel);
			this._langSetBar.addEventListener(MouseEventUtil.CLICK,this.langSet);
			this._albumBtn.addEventListener(MouseEventUtil.CLICK,this.showPlayListPanel);
			this._barrageBtn.addEventListener(MouseEventUtil.MOUSE_UP,function(param1:Event):void {
				if(_danmu != null) {
					if(_danmu.getTmShow()) {
						param1.target.clicked = false;
						_danmu.showTanmu(false);
					} else {
						param1.target.clicked = true;
						_danmu.showTanmu(true);
					}
				}
			});
			this._oriSongBtn.addEventListener(MouseEventUtil.CLICK,this.changeToOA);
			this._vocSongBtn.addEventListener(MouseEventUtil.CLICK,this.changeToVA);
			this._normalScreen3_btn.addEventListener(MouseEventUtil.CLICK,this.exitFullMouseClick);
			_hitArea_spr.removeEventListener(MouseEvent.CLICK,hitAreaClick);
			_hitArea_spr.addEventListener(MouseEvent.CLICK,this.playOrPause);
			this._retryPanel.addEventListener(RetryPanel.RETRY,this.fileRetry);
			this._tipHistory.addEventListener(TipHistory.SEEK,this.historyBreakPoint);
			this._tipHistory.addEventListener(TipHistory.TOSTART_BTN_ONCLICK,this.toStartAndPlay);
			this._tipHistory.addEventListener("cancelJump",this.cancelJump);
			this._tipHistory.addEventListener("setting",this.showOtherSetting);
			this._tipHistory.addEventListener("hdToCommon",function(param1:Event):void {
				dispatchEvent(new Event(HD_BUTTON_MOUSEUP));
			});
			this._tipHistory.addEventListener("commonToHd",function(param1:Event):void {
				dispatchEvent(new Event(COMMON_BUTTON_MOUSEUP));
			});
			this._tipHistory.addEventListener("exitFullScreen",function(param1:Event):void {
				if(stage.displayState == "fullScreen") {
					_normalScreen_btn.dispatchEvent(new MouseEventUtil(MouseEventUtil.CLICK));
				}
			});
			this._tipHistory.addEventListener("imovie",function(param1:Event):void {
				var _loc2_:Object = null;
				_core.pause();
				if(stage.displayState == "fullScreen") {
					_normalScreen_btn.dispatchEvent(new MouseEventUtil(MouseEventUtil.CLICK));
				}
				if(Eif.available) {
					if(PlayerConfig.cooperator == "imovie") {
						_loc2_ = stage.loaderInfo.parameters;
						ExternalInterface.call("jQuery.authentication",_loc2_.c,_loc2_.n,"1","");
					}
				}
			});
			this._tipHistory.addEventListener("toSuper",function(param1:Event):void {
				dispatchEvent(new Event(SUPER_BUTTON_MOUSEUP));
			});
			this._tipHistory.addEventListener(Event.OPEN,this.tipPanelOpened);
			this._tipHistory.addEventListener(Event.CLOSE,this.tipPanelClosed);
			stage.addEventListener(KeyboardEvent.KEY_DOWN,this.keyboardDownHandler);
			stage.addEventListener(KeyboardEvent.KEY_UP,this.keyboardUpHandler);
			this._tvSohuLogo_btn.addEventListener(MouseEventUtil.CLICK,this.gotoTvSohu);
			_volume_sld.addEventListener("comebackVolume",function(param1:Event):void {
				setSkinState();
			});
			_volume_sld.addEventListener("muteVolume",function(param1:Event):void {
				setSkinState();
			});
			_volume_sld.addEventListener("volKeyboardTip",function(param1:Event):void {
				tipVolKeyboardCookie();
			});
			this._topPer50_btn.addEventListener(MouseEventUtil.MOUSE_UP,this.changeVideoRate);
			this._topPer75_btn.addEventListener(MouseEventUtil.MOUSE_UP,this.changeVideoRate);
			this._topPer100_btn.addEventListener(MouseEventUtil.MOUSE_UP,this.changeVideoRate);
		}
		
		private function capBarMouseOver(param1:MouseEvent) : void {
			this._captionBar.showDragBg();
		}
		
		private function capBarMouseOut(param1:MouseEvent) : void {
			this._captionBar.hideDragBg();
		}
		
		private function capBarMouseDown(param1:MouseEvent) : void {
			this._captionBar.startDrag(false,new Rectangle(0,0,0,_core.height - this._captionBar.height));
			this._captionBar.isDragState = true;
			this._isCapDrag = true;
		}
		
		private function capBarMouseUp(param1:MouseEvent) : void {
			this._captionBar.stopDrag();
			this._captionBar.py = (this._captionBar.y - _core.videoContainer.y) / _core.videoContainer.height;
			this._captionBar.isDragState = false;
		}
		
		private function onStageMouseOut(param1:MouseEvent) : void {
			this.hideSideBar(param1);
		}
		
		public function showCommonProgress() : void {
			if(_skin != null) {
				_progress_sld["onSliderWideStatus"](0);
				if(this._tipHistory != null) {
					if(this._tipHistory.isOpen) {
						TweenLite.to(this._tipHistory,0.1,{"y":_progress_sld.y - this._tipHistory.height + 1});
					} else {
						this._tipHistory.y = _progress_sld.y - this._tipHistory.height + 1;
					}
				}
			}
		}
		
		protected function showMiniProgress() : void {
			_progress_sld["sliderOutHandler"]();
			_progress_sld["onSliderNarrowStatus"](0);
			if(this._tipHistory != null) {
				if(this._tipHistory.isOpen) {
					TweenLite.to(this._tipHistory,0.1,{"y":_progress_sld.y - _progress_sld.height - 3});
				} else {
					this._tipHistory.y = _progress_sld.y - _progress_sld.height - 3;
				}
			}
		}
		
		public function pbarDiff() : Number {
			if(_progress_sld != null) {
				return _ctrlBarBg_spr.height;
			}
			return 0;
		}
		
		private function checkXXX(param1:Event = null) : void {
			if(!PlayerConfig.isFms && !this._isPreLoadPanel && !PlayerConfig.isLive) {
				this._isPreLoadPanel = true;
				this.startPreLoad();
			}
		}
		
		private function tipPanelOpened(param1:Event) : void {
			this.setSkinState();
		}
		
		private function tipPanelClosed(param1:Event) : void {
			this.setSkinState();
		}
		
		private function cancelJump(param1:Event) : void {
			this._isJumpEndCaption = false;
		}
		
		private function showOtherSetting(param1:Event) : void {
			this.showSettingPanel("CLICK");
		}
		
		public function showSettingPanel(param1:* = null) : void {
			var evt:* = param1;
			clearTimeout(this._showSetPId);
			clearTimeout(this._showSetPAutoId);
			this._showSetPId = setTimeout(function():void {
				loadSettingPanel();
			},200);
			if(evt == "CLICK") {
				this._showSetPAutoId = setTimeout(function():void {
					hideSettingPanel();
				},3000);
			}
		}
		
		private function hideSettingPanel(param1:* = null) : void {
			var evt:* = param1;
			clearTimeout(this._showSetPId);
			clearTimeout(this._showSetPAutoId);
			this._showSetPId = setTimeout(function():void {
				if(!(_settingPanel == null) && (!_settingPanel.hitTestPoint(mouseX,mouseY) || _ctrlBar_c.mouseX <= _settingPanel.x || !(evt == null) && evt.stageX <= 0 || mouseX >= stage.stageWidth - 6 || mouseY >= stage.stageHeight - 6)) {
					_settingPanel.close();
				}
			},200);
		}
		
		private function loadSettingPanel() : void {
			var ctx:LoaderContext = null;
			if(this._settingPanel == null) {
				ctx = new LoaderContext();
				ctx.applicationDomain = new ApplicationDomain(ApplicationDomain.currentDomain);
				new LoaderUtil().load(10,function(param1:Object):void {
					var obj:Object = param1;
					if(obj.info == "success") {
						_settingPanel = obj.data.content;
						_settingPanel.addEventListener(PanelEvent.LIGHT_VAL_CHANGE,lightSlide);
						_settingPanel.addEventListener(PanelEvent.CONTRAST_VAL_CHANGE,contrastSlider);
						_settingPanel.addEventListener(PanelEvent.SCALE_SELECTED,displayZoomSet);
						_settingPanel.addEventListener(PanelEvent.ROTATE_SCR,displayRotateSet);
						_settingPanel.addEventListener(PanelEvent.ACCELERATED_CHANGE,acceleratedChange);
						_settingPanel.addEventListener(PanelEvent.READY,function(param1:PanelEvent):void {
							_settingPanel.init(_owner);
							setSkinState();
							loadSettingPanel();
						});
						_settingPanel.addEventListener(MouseEvent.ROLL_OUT,hideSettingPanel);
						addChild(_settingPanel);
					}
				},null,PlayerConfig.swfHost + "panel/SettingPanel.swf",ctx);
			} else {
				this._settingPanel.open({
					"available":PlayerConfig.availableStvd,
					"isStvd":PlayerConfig.stvdInUse
				});
				this.setSkinState();
				this.setChildIndex(this._settingPanel,this.numChildren - 1);
			}
			SendRef.getInstance().sendPQDrog("http://click.hd.sohu.com.cn/s.gif?type=fun_yangli205733_PL_C_Set&s=" + PlayerConfig.stype + "&_=" + new Date().getTime());
		}
		
		private function dspSettingFinish(param1:Event) : void {
			var _loc2_:SharedObject = null;
			var _loc3_:* = "";
			switch(param1.target.autoFix) {
				case "1":
					_loc2_ = SharedObject.getLocal("vmsPlayer","/");
					PlayerConfig.autoFix = _loc2_.data.af = "1";
					_loc2_.data.ver = "";
					try {
						_loc3_ = _loc2_.flush();
						if(_loc3_ == SharedObjectFlushStatus.PENDING) {
							_loc2_.addEventListener(NetStatusEvent.NET_STATUS,this.onStatusShare);
						} else if(_loc3_ == SharedObjectFlushStatus.FLUSHED) {
						}
						
					}
					catch(e:Error) {
					}
					return;
				case "2":
					_loc2_ = SharedObject.getLocal("vmsPlayer","/");
					PlayerConfig.autoFix = _loc2_.data.af = "2";
					_loc2_.data.ver = "";
					try {
						_loc3_ = _loc2_.flush();
						if(_loc3_ == SharedObjectFlushStatus.PENDING) {
							_loc2_.addEventListener(NetStatusEvent.NET_STATUS,this.onStatusShare);
						} else if(_loc3_ == SharedObjectFlushStatus.FLUSHED) {
						}
						
					}
					catch(e:Error) {
					}
					return;
				default:
					switch(param1.target.ver) {
						case "1":
							if(!(PlayerConfig.hdVid == "") && !(PlayerConfig.hdVid == PlayerConfig.currentVid)) {
								this._isPreLoadPanel = false;
								dispatchEvent(new Event(HD_BUTTON_MOUSEUP));
								this.tipText("切换到高清...");
							}
							_loc2_ = SharedObject.getLocal("vmsPlayer","/");
							_loc2_.data.ver = "1";
							PlayerConfig.autoFix = _loc2_.data.af = "";
							try {
								_loc3_ = _loc2_.flush();
								if(_loc3_ == SharedObjectFlushStatus.PENDING) {
									_loc2_.addEventListener(NetStatusEvent.NET_STATUS,this.onStatusShare);
								} else if(_loc3_ == SharedObjectFlushStatus.FLUSHED) {
								}
								
							}
							catch(e:Error) {
							}
							break;
						case "2":
							if(!(PlayerConfig.norVid == "") && !(PlayerConfig.norVid == PlayerConfig.currentVid)) {
								this._isPreLoadPanel = false;
								dispatchEvent(new Event(COMMON_BUTTON_MOUSEUP));
								this.tipText("切换到标清...");
							}
							_loc2_ = SharedObject.getLocal("vmsPlayer","/");
							_loc2_.data.ver = "2";
							PlayerConfig.autoFix = _loc2_.data.af = "";
							try {
								_loc3_ = _loc2_.flush();
								if(_loc3_ == SharedObjectFlushStatus.PENDING) {
									_loc2_.addEventListener(NetStatusEvent.NET_STATUS,this.onStatusShare);
								} else if(_loc3_ == SharedObjectFlushStatus.FLUSHED) {
								}
								
							}
							catch(e:Error) {
							}
							break;
						case "21":
							if(!(PlayerConfig.superVid == "") && !(PlayerConfig.superVid == PlayerConfig.currentVid)) {
								this._isPreLoadPanel = false;
								dispatchEvent(new Event(SUPER_BUTTON_MOUSEUP));
								this.tipText("切换到超清...");
							}
							_loc2_ = SharedObject.getLocal("vmsPlayer","/");
							_loc2_.data.ver = "21";
							PlayerConfig.autoFix = _loc2_.data.af = "";
							try {
								_loc3_ = _loc2_.flush();
								if(_loc3_ == SharedObjectFlushStatus.PENDING) {
									_loc2_.addEventListener(NetStatusEvent.NET_STATUS,this.onStatusShare);
								} else if(_loc3_ == SharedObjectFlushStatus.FLUSHED) {
								}
								
							}
							catch(e:Error) {
							}
							break;
						case "31":
							if(!(PlayerConfig.oriVid == "") && !(PlayerConfig.oriVid == PlayerConfig.currentVid)) {
								this._isPreLoadPanel = false;
								dispatchEvent(new Event(ORI_BUTTON_MOUSEUP));
								this.tipText("切换到原画...");
							}
							_loc2_ = SharedObject.getLocal("vmsPlayer","/");
							_loc2_.data.ver = "31";
							PlayerConfig.autoFix = _loc2_.data.af = "";
							try {
								_loc3_ = _loc2_.flush();
								if(_loc3_ == SharedObjectFlushStatus.PENDING) {
									_loc2_.addEventListener(NetStatusEvent.NET_STATUS,this.onStatusShare);
								} else if(_loc3_ == SharedObjectFlushStatus.FLUSHED) {
								}
								
							}
							catch(e:Error) {
							}
							break;
						case "51":
							if(!(PlayerConfig.h2644kVid == "") && !(PlayerConfig.h2644kVid == PlayerConfig.currentVid)) {
								this._isPreLoadPanel = false;
								dispatchEvent(new Event(EXTREME_BUTTON_MOUSEUP));
								this.tipText("切换到极清...");
								if(this._tipHistory != null) {
									if(this._tipHistory.isOpen) {
										this._tipHistory.close();
									}
									this._tipHistory.isExtremeTip = false;
								}
							}
							_loc2_ = SharedObject.getLocal("vmsPlayer","/");
							_loc2_.data.ver = "51";
							PlayerConfig.autoFix = _loc2_.data.af = "";
							try {
								_loc3_ = _loc2_.flush();
								if(_loc3_ == SharedObjectFlushStatus.PENDING) {
									_loc2_.addEventListener(NetStatusEvent.NET_STATUS,this.onStatusShare);
								} else if(_loc3_ == SharedObjectFlushStatus.FLUSHED) {
								}
								
							}
							catch(e:Error) {
							}
							break;
						case "53":
							break;
					}
					return;
			}
		}
		
		private function showAcmePanel(param1:Event) : void {
			var evt:Event = param1;
			if(this._acmePanel == null) {
				new LoaderUtil().load(10,function(param1:Object):void {
					var obj:Object = param1;
					if(obj.info == "success") {
						_acmePanel = obj.data.content;
						_panelArr.push(_acmePanel);
						_acmePanel.addEventListener("needPause",function(param1:Event):void {
							_core.pause();
						});
						addChild(_acmePanel);
						_acmePanel.open();
						setSkinState();
					}
				},null,PlayerConfig.swfHost + "panel/H265ClientPanel.swf");
			} else if(this._acmePanel.isOpen) {
				this._acmePanel.close();
			} else if(this._preLoadPanel == null || (!this._preLoadPanel.isOpen) || (this._preLoadPanel.isBackgroundRun)) {
				this.closePanel();
				this._acmePanel.open();
				SendRef.getInstance().sendPQVPC("PL_R_Speed");
			}
			
			
		}
		
		override protected function onPlay(param1:Event) : void {
			var evt:Event = param1;
			_skinMap.getValue("replayBtn").v = _skinMap.getValue("replayBtn").e = false;
			this.clearBlurFilter();
			super.onPlay(evt);
			if(_skin != null) {
				if(!(this._preLoadPanel == null) && (this._preLoadPanel.isOpen)) {
					this._preLoadPanel.ttt();
				}
				if(!PlayerConfig.isSohuDomain && !(this._searchBar == null) && this._topSideBar.y == 0) {
					this._rightSideBarTimeout_to.restart();
				}
				if(_progress_sld != null) {
					_progress_sld["hideNewPreview"] = false;
				}
			}
			this._showTipTimeout = setTimeout(function():void {
				if(_isFB == "f") {
					tipText("快进 " + Utils.fomatTime(_core.filePlayedTime) + "(" + Math.round(_core.filePlayedTime / _core.fileTotTime * 100) + "%)",2);
					_isFB = "";
				} else if(_isFB == "b") {
					tipText("快退 " + Utils.fomatTime(_core.filePlayedTime) + "(" + Math.round(_core.filePlayedTime / _core.fileTotTime * 100) + "%)",2);
					_isFB = "";
				}
				
			},500);
			InforSender.getInstance().sendIRS("play");
			if(this._danmu != null) {
				this._danmu.play();
			}
		}
		
		override protected function onPause(param1:Event) : void {
			var evt:Event = param1;
			_skinMap.getValue("replayBtn").v = _skinMap.getValue("replayBtn").e = false;
			super.onPause(evt);
			if(evt["obj"].isHard) {
				this._onPuaeStatId = setTimeout(function():void {
					ErrorSenderPQ.getInstance().sendPQStat({
						"error":0,
						"code":PlayerConfig.ON_VIDEO_PAUSE_CODE
					});
				},500);
			}
			if(_skin != null) {
				clearInterval(this._showBufferRate);
				this._transition_mc.visible = false;
				if(!PlayerConfig.isSohuDomain && !(this._searchBar == null) && this._topSideBar.y < 0) {
					TweenLite.to(this._topSideBar,0.5,{
						"y":0,
						"ease":Quad.easeOut
					});
				}
			}
			if(Eif.available) {
				ExternalInterface.call("flv_playerEvent","onPause");
			}
			InforSender.getInstance().sendIRS("pause");
			if(this._danmu != null) {
				this._danmu.pause();
			}
		}
		
		private function forward(param1:Event) : void {
			var evt:Event = param1;
			var seekTo:Number = _core.filePlayedTime + 20;
			var totTime:Number = _core.fileTotTime;
			clearTimeout(this._showTipTimeout);
			if(seekTo > 0 && seekTo < totTime) {
				_core.seek(seekTo);
				_progress_sld.topRate = seekTo / totTime;
				_core.play();
				if((PlayerConfig.isKTVVideo) && !(this._ktvCore == null)) {
					setTimeout(function():void {
						_core.sleep();
						_ktvCore.seek(_core.filePlayedTime);
						_ktvCore.play();
					},500);
				}
				this._isFB = "f";
			}
		}
		
		private function backward(param1:Event) : void {
			var evt:Event = param1;
			var seekTo:Number = _core.filePlayedTime - 20;
			var totTime:Number = _core.fileTotTime;
			clearTimeout(this._showTipTimeout);
			if(seekTo > 0 && seekTo < totTime) {
				_core.seek(seekTo);
				_progress_sld.topRate = seekTo / totTime;
				_core.play();
				if((PlayerConfig.isKTVVideo) && !(this._ktvCore == null)) {
					setTimeout(function():void {
						_core.sleep();
						_ktvCore.seek(_core.filePlayedTime);
						_ktvCore.play();
					},500);
				}
				this._isFB = "b";
			}
		}
		
		private function dotSeek(param1:Event) : void {
			if(!(PlayerConfig.uvrInfo == null) && !this._isEssenceTip && !this._tipHistory.isOpen) {
				this._isEssenceTip = true;
				this._tipHistory.showEssenceTip(PlayerConfig.uvrInfo);
			}
			var _loc2_:Number = param1.target.dotSeekTime;
			var _loc3_:Number = _core.fileTotTime;
			if(_loc2_ > 0 && _loc2_ < _loc3_) {
				_core.seek(_loc2_);
				_progress_sld.topRate = _loc2_ / _loc3_;
				_core.play();
			}
		}
		
		public function seekTo(param1:Number = 0) : void {
			var _loc2_:* = NaN;
			var _loc3_:* = NaN;
			if(!(_core == null) && (_core.streamState == "play" || _core.streamState == "pause" || _core.streamState == "stop") && !(TvSohuAds.getInstance().endAd.state == "playing") && !(TvSohuAds.getInstance().startAd.state == "playing")) {
				_loc2_ = param1;
				_loc3_ = _core.fileTotTime;
				if(_loc2_ > 0 && _loc2_ < _loc3_) {
					_core.seek(_loc2_);
					_progress_sld.topRate = _loc2_ / _loc3_;
					_core.play();
				}
				if(Eif.available) {
					ExternalInterface.call("flv_playerEvent","onSeek",_loc2_);
				}
			}
		}
		
		override protected function progressSlideStart(param1:SliderEventUtil) : void {
			this.startDragTime = PlayerConfig.playedTime;
			super.progressSlideStart(param1);
		}
		
		override public function seek(param1:* = null) : void {
			var st:uint = 0;
			var et:uint = 0;
			var tot:Number = NaN;
			var ds:Number = NaN;
			var evt:* = param1;
			var tempTime:uint = PlayerConfig.playedTime;
			if(!(PlayerConfig.startTime == "") && !(PlayerConfig.endTime == "")) {
				st = uint(PlayerConfig.startTime);
				et = uint(PlayerConfig.endTime);
				tot = _core.fileTotTime;
				ds = (et - st) / tot;
				if(evt is Number) {
					evt = evt * ds + st / tot;
				} else {
					evt.obj.rate = evt.obj.rate * ds + st / tot;
				}
			}
			var offset:Number = evt is Number?evt:evt.obj.rate;
			var videoTime:Number = _core.fileTotTime;
			var sec:Number = Math.round(videoTime * offset);
			_core.dispatch(MediaEvent.PLAY_PROGRESS,{
				"nowTime":sec,
				"totTime":videoTime,
				"isSeek":true
			});
			if(!(evt is Number) && evt.obj.sign == 0) {
				if(Math.abs(sec - _seekTime) >= 6) {
					_seekTime = sec;
					_core.seek(_seekTime,evt.obj.sign);
					if((PlayerConfig.isKTVVideo) && !(this._ktvCore == null)) {
						this._ktvCore.audioCore.sleep();
					}
				}
			} else {
				SendRef.getInstance().sendPQDrog("http://click.hd.sohu.com.cn/s.gif?type=1009&uid=" + PlayerConfig.userId + "&expand1=" + sec + "&expand2=" + PlayerConfig.vid + "&expand3=" + (this.startDragTime > 0?this.startDragTime:tempTime) + "&s=" + PlayerConfig.stype + "&_=" + new Date().getTime());
				if(!(PlayerConfig.uvrInfo == null) && !this._isEssenceTip && !this._tipHistory.isOpen) {
					this._isEssenceTip = true;
					this._tipHistory.showEssenceTip(PlayerConfig.uvrInfo);
				}
				this.startDragTime = 0;
				sec = sec <= 0?1:sec;
				_seekTime = sec;
				_core.seek(_seekTime);
				if((PlayerConfig.isKTVVideo) && !(this._ktvCore == null)) {
					setTimeout(function():void {
						_core.sleep();
						_ktvCore.seek(_core.filePlayedTime);
						_ktvCore.play();
					},500);
				}
			}
			if(this._danmu != null) {
				this._danmu.seek(_seekTime);
			}
		}
		
		override protected function onFullScreenChange(param1:FullScreenEvent) : void {
			var evt:FullScreenEvent = param1;
			clearTimeout(this._onPuaeStatId);
			super.onFullScreenChange(evt);
			if(evt.fullScreen) {
				if(Eif.available) {
					try {
						fscommand("fullscreen","1");
					}
					catch(evt:Error) {
					}
				}
				_skinMap.getValue("fullScreenBtn").e = _skinMap.getValue("fullScreenBtn").v = false;
				_skinMap.getValue("normalScreenBtn").e = _skinMap.getValue("normalScreenBtn").v = true;
				if(PlayerConfig.autoFix == "2" && !(PlayerConfig.relativeId == "") && !PlayerConfig.isHd) {
					setTimeout(function():void {
						dispatchEvent(new Event(HD_BUTTON_MOUSEUP));
					},500);
				}
				ErrorSenderPQ.getInstance().sendPQStat({
					"error":0,
					"code":PlayerConfig.ON_VIDEO_FULLSCREEN_CODE
				});
				this._isEsc = true;
			} else {
				if((!(this._playListPanel == null)) && (this._playListPanel.isOpen) && PlayerConfig.domainProperty == "0") {
					this._playListPanel.close();
				}
				if(Eif.available) {
					try {
						ExternalInterface.call("setFullWindowCookie","0");
						fscommand("fullscreen","0");
					}
					catch(evt:Error) {
					}
				}
				_skinMap.getValue("fullScreenBtn").e = _skinMap.getValue("fullScreenBtn").v = true;
				_skinMap.getValue("normalScreenBtn").e = _skinMap.getValue("normalScreenBtn").v = false;
				TvSohuAds.getInstance().ctrlBarAd.dispatchSharedEvent();
				if(stage.displayState != "fullScreen") {
					this._displayRate = 1;
					_core.displayZoom(this._displayRate);
					this.setAdsState();
				}
				if(this._isEsc) {
					SendRef.getInstance().sendPQDrog("http://click.hd.sohu.com.cn/s.gif?type=fun_yangli205733_PL_S_EscFull&s=" + PlayerConfig.stype + "&_=" + new Date().getTime());
				}
			}
			if(_skin != null) {
				this.setSkinState();
			}
		}
		
		override protected function hitAreaDClick(param1:MouseEvent) : void {
			this._isEsc = false;
			super.hitAreaDClick(param1);
			if(stage.displayState == "fullScreen") {
				SendRef.getInstance().sendPQDrog("http://click.hd.sohu.com.cn/s.gif?type=fun_yangli205733_PL_S_DoubleFull&s=" + PlayerConfig.stype + "&_=" + new Date().getTime());
			} else {
				SendRef.getInstance().sendPQDrog("http://click.hd.sohu.com.cn/s.gif?type=fun_yangli205733_PL_S_DoubleCom&s=" + PlayerConfig.stype + "&_=" + new Date().getTime());
			}
		}
		
		private function gotoTvSohu(param1:MouseEventUtil) : void {
			if(PlayerConfig.isNewsLogo) {
				Utils.openWindow("http://tv.sohu.com/news/");
				SendRef.getInstance().sendPQVPC("PL_C_LogoNew");
			} else if(PlayerConfig.channel == "s") {
				Utils.openWindow("http://tv.sohu.com/sports/");
				SendRef.getInstance().sendPQVPC("fun_yangli205733_PL_C_LogoSports");
			} else if(!PlayerConfig.isPartner) {
				Utils.openWindow("http://tv.sohu.com");
				SendRef.getInstance().sendPQVPC("PL_C_Logo");
			}
			
			
		}
		
		private function keyboardDownHandler(param1:KeyboardEvent) : void {
			stage.removeEventListener(KeyboardEvent.KEY_DOWN,this.keyboardDownHandler);
			switch(param1.keyCode) {
				case 38:
					if((_volume_sld.slider.enabled) && (PlayerConfig.isUseSpacebar)) {
						_volume_sld.slider["forward"]();
						SendRef.getInstance().sendPQVPC("fun_yangli205733_PL_C_UpVolumeKeyboard");
					}
					break;
				case 40:
					if((_volume_sld.slider.enabled) && (PlayerConfig.isUseSpacebar)) {
						_volume_sld.slider["backward"]();
						SendRef.getInstance().sendPQVPC("fun_yangli205733_PL_C_DownVolumeKeyboard");
					}
					break;
				case 39:
					if((_progress_sld.enabled) && (PlayerConfig.isUseSpacebar)) {
						_progress_sld["forward"]();
						SendRef.getInstance().sendPQVPC("fun_yangli205733_PL_C_ForwardKeyboard");
					}
					break;
				case 37:
					if((_progress_sld.enabled) && (PlayerConfig.isUseSpacebar)) {
						_progress_sld["backward"]();
						SendRef.getInstance().sendPQVPC("fun_yangli205733_PL_C_BackwardKeyboard");
					}
					break;
			}
		}
		
		private function keyboardUpHandler(param1:KeyboardEvent) : void {
			stage.addEventListener(KeyboardEvent.KEY_DOWN,this.keyboardDownHandler);
			switch(param1.keyCode) {
				case 38:
					if((_volume_sld.slider.enabled) && (PlayerConfig.isUseSpacebar)) {
						_volume_sld.slider["stopForward"]();
					}
					break;
				case 40:
					if((_volume_sld.slider.enabled) && (PlayerConfig.isUseSpacebar)) {
						_volume_sld.slider["stopBackward"]();
					}
					break;
				case 39:
					if((_progress_sld.enabled) && (PlayerConfig.isUseSpacebar)) {
						_progress_sld["stopForward"]();
					}
					break;
				case 37:
					if((_progress_sld.enabled) && (PlayerConfig.isUseSpacebar)) {
						_progress_sld["stopBackward"]();
					}
					break;
				case 32:
					if(!((TvSohuAds.getInstance().endAd.hasAd) && TvSohuAds.getInstance().endAd.state == "playing" || (TvSohuAds.getInstance().startAd.hasAd) && TvSohuAds.getInstance().startAd.state == "playing")) {
						if(PlayerConfig.isUseSpacebar) {
							_core.playOrPause(param1);
						}
					}
					break;
				case 13:
					if((param1.ctrlKey) && !((TvSohuAds.getInstance().endAd.hasAd) && TvSohuAds.getInstance().endAd.state == "playing" || (TvSohuAds.getInstance().startAd.hasAd) && TvSohuAds.getInstance().startAd.state == "playing") && !(_skin == null) && !(stage.displayState == "fullScreen")) {
						_fullScreen_btn.dispatchEvent(new MouseEventUtil(MouseEventUtil.CLICK));
					}
					break;
				case 79:
					if((param1.ctrlKey) && (param1.shiftKey)) {
						this.showP2PLogPanel();
					}
			}
		}
		
		private function showP2PLogPanel() : void {
			if(this._p2pLogPanel == null) {
				new LoaderUtil().load(10,function(param1:Object):void {
					if(param1.info == "success") {
						_p2pLogPanel = param1.data.content;
						_p2pLogPanel.close(0);
						addChild(_p2pLogPanel);
						showP2PLogPanel();
					}
				},null,PlayerConfig.swfHost + "panel/P2PInfoPanel.swf");
			} else if(this._p2pLogPanel.isOpen) {
				this._p2pLogPanel.close();
			} else {
				this._p2pLogPanel.open();
			}
			
		}
		
		public function showVideoInfoPanel() : void {
			if(this._videoInfoPanel.isOpen) {
				this._videoInfoPanel.close();
			} else {
				this.closePanel();
				this._videoInfoPanel.open();
			}
		}
		
		protected function lightSlide(param1:PanelEvent) : void {
			var _loc2_:ColorMatrix = new ColorMatrix();
			var _loc3_:Number = this._lightRate = param1.lightVal;
			var _loc4_:Number = (_loc3_ - 1) * 2 + 1;
			var _loc5_:Array = [];
			_loc2_.adjustBrightness(100 * _loc4_);
			this._filterArr[0] = _loc4_ != 0?new ColorMatrixFilter(_loc2_):_loc4_;
			var _loc6_:uint = 0;
			while(_loc6_ < this._filterArr.length) {
				if(!(this._filterArr[_loc6_] == 0) && !(this._filterArr[_loc6_] == null)) {
					_loc5_.push(this._filterArr[_loc6_]);
				}
				_loc6_++;
			}
			_core.videoContainer.filters = _loc5_;
		}
		
		protected function contrastSlider(param1:PanelEvent) : void {
			var _loc2_:ColorMatrix = new ColorMatrix();
			var _loc3_:Number = this._contrastRate = param1.contrastVal;
			var _loc4_:Number = (_loc3_ - 1) * 2 + 1;
			var _loc5_:Array = [];
			_loc2_.adjustContrast(100 * _loc4_);
			this._filterArr[1] = _loc4_ != 0?new ColorMatrixFilter(_loc2_):_loc4_;
			var _loc6_:uint = 0;
			while(_loc6_ < this._filterArr.length) {
				if(!(this._filterArr[_loc6_] == 0) && !(this._filterArr[_loc6_] == null)) {
					_loc5_.push(this._filterArr[_loc6_]);
				}
				_loc6_++;
			}
			_core.videoContainer.filters = _loc5_;
		}
		
		private function displayZoomSet(param1:PanelEvent) : void {
			this._displayRate = param1.scaleRate;
			_core.displayZoom(this._displayRate);
			this.setAdsState();
		}
		
		private function displayRotateSet(param1:PanelEvent) : void {
			_core.setR(param1.rotateVal);
			this.setAdsState();
		}
		
		private function acceleratedChange(param1:PanelEvent) : void {
			if((param1.toStgVd) && !PlayerConfig.stvdInUse) {
				dispatchEvent(new Event("gotoStageVideo"));
			} else if(!param1.toStgVd && (PlayerConfig.stvdInUse)) {
				dispatchEvent(new Event("gotoVideo"));
			}
			
		}
		
		public function get displayRate() : Number {
			return this._displayRate;
		}
		
		private function toStartAndPlay(param1:Event) : void {
			var _loc2_:Number = PlayerConfig.stTime > 0?PlayerConfig.stTime:1;
			var _loc3_:Number = _core.fileTotTime;
			if(_loc2_ > 0 && _loc2_ < _loc3_) {
				_core.seek(_loc2_);
				_progress_sld.topRate = _loc2_ / _loc3_;
				_core.play();
			}
			_core.play();
		}
		
		private function historyBreakPoint(param1:Event) : void {
			var _loc2_:Number = param1.target.breakPoint;
			var _loc3_:Number = _core.fileTotTime;
			if(_loc2_ > 0 && _loc2_ < _loc3_) {
				_core.seek(_loc2_);
				_progress_sld.topRate = _loc2_ / _loc3_;
				_core.play();
			}
			_core.play();
		}
		
		private function jumpTo(param1:Event) : void {
			Utils.openWindow(param1.target.url,"_self");
		}
		
		private function fileRetryFailed(param1:MediaEvent) : void {
			this._retryPanel.open();
			ErrorSenderPQ.getInstance().sendPQStat({"code":PlayerConfig.RETRY_SHOWN_CODE});
			dispatchEvent(new Event("retryPanel_shown"));
		}
		
		private function ncRetryFailed(param1:MediaEvent) : void {
			this._ncConnectError = true;
		}
		
		public function get ncConnectError() : Boolean {
			return this._ncConnectError;
		}
		
		private function fileRetry(param1:Event) : void {
			_core.retry();
			ErrorSenderPQ.getInstance().sendPQStat({"code":PlayerConfig.AFFIRM_RETRY_CODE});
		}
		
		private function preLoadFinish(param1:Event) : void {
			if((!(this._preLoadPanel == null)) && (this._preLoadPanel.isOpen) && (this._preLoadPanel.isBackgroundRun)) {
				this._preLoadPanel.close(0);
				this.setSkinState();
			}
		}
		
		private function preLoadPanelBGRun(param1:Event) : void {
			this.setSkinState();
		}
		
		private function preLoadPanelFGRun(param1:Event) : void {
			this.setSkinState();
		}
		
		override protected function exitFullMouseClick(param1:MouseEventUtil = null) : void {
			this._isEsc = false;
			if((!(this._playListPanel == null)) && (this._playListPanel.isOpen) && PlayerConfig.domainProperty == "0") {
				this._playListPanel.close();
			}
			super.exitFullMouseClick(param1);
			SendRef.getInstance().sendPQVPC("PL_S_ExitFull");
		}
		
		private function changeVideoRate(param1:MouseEventUtil) : void {
			param1.target.enabled = false;
			switch(param1.target) {
				case this._topPer50_btn:
					this._displayRate = 0.5;
					this._topPer75_btn.enabled = this._topPer100_btn.enabled = true;
					SendRef.getInstance().sendPQVPC("PL_S_50Percent");
					break;
				case this._topPer75_btn:
					this._displayRate = 0.75;
					this._topPer50_btn.enabled = this._topPer100_btn.enabled = true;
					SendRef.getInstance().sendPQVPC("PL_S_75Percent");
					break;
				case this._topPer100_btn:
					this._displayRate = 1;
					this._topPer50_btn.enabled = this._topPer75_btn.enabled = true;
					SendRef.getInstance().sendPQVPC("PL_S_100Percent");
					break;
			}
			_core.displayZoom(this._displayRate);
			this.setAdsState();
		}
		
		public function toCommonMode() : void {
			if((PlayerConfig.isBrowserFullScreen) || stage.displayState == "fullScreen") {
				_normalScreen_btn.dispatchEvent(new MouseEventUtil(MouseEventUtil.CLICK));
			}
		}
		
		public function toCinemaMode(param1:* = null) : void {
			if(!(param1 == null) && param1 == 1) {
				if(!this._isCinema) {
					this.cinemaMouseClick();
				}
			} else if(this._isCinema) {
				this._turnOffWider_btn.dispatchEvent(new MouseEventUtil(MouseEventUtil.CLICK));
			}
			
		}
		
		public function writeBreakpoint() : void {
		}
		
		private function exitFull3MouseClick(param1:MouseEventUtil) : void {
			this._isEsc = false;
			if((!(this._playListPanel == null)) && (this._playListPanel.isOpen) && PlayerConfig.domainProperty == "0") {
				this._playListPanel.close();
			}
			super.exitFullMouseClick(param1);
		}
		
		private function normalScreenMouseOver(param1:MouseEventUtil) : void {
			if(stage.displayState != "fullScreen") {
				_fullScreen_btn.dispatchEvent(new MouseEventUtil(MouseEventUtil.MOUSE_OVER));
			}
		}
		
		override protected function fullMouseClick(param1:MouseEventUtil = null) : void {
			if((PlayerConfig.isSohuDomain) || !(PlayerConfig.apiKey == "")) {
				super.fullMouseClick(param1);
			} else if(PlayerConfig.isJump) {
				super.fullMouseClick(param1);
			}
			
			SendRef.getInstance().sendPQVPC("PL_C_FullScreen");
		}
		
		private function miniWinMouseClick(param1:MouseEventUtil) : void {
			if(stage.displayState == "fullScreen") {
				_normalScreen_btn.dispatchEvent(new MouseEventUtil(MouseEventUtil.CLICK));
			}
			ExternalInterface.call("_openSmallWin");
			this.setSkinState();
			InforSender.getInstance().sendCustomMesg("http://220.181.61.231/get.gif?type=miniwinmode");
			SendRef.getInstance().sendPQVPC("PL_C_SmallScreen");
		}
		
		private function cinemaMouseClick(param1:* = null) : void {
			if(stage.displayState == "fullScreen") {
				_normalScreen_btn.dispatchEvent(new MouseEventUtil(MouseEventUtil.CLICK));
			}
			ExternalInterface.call("fullSm",ExternalInterface.objectID);
			this._isCinema = true;
			this._turnOffWider_btn.visible = this._turnOffWider_btn.enabled = true;
			this._turnOnWider_btn.enabled = this._turnOnWider_btn.visible = false;
			ExternalInterface.call("swfWiderMode","on");
			this.setSkinState();
			if(param1 != null) {
				InforSender.getInstance().sendCustomMesg("http://220.181.61.231/get.gif?type=cinemamode");
				SendRef.getInstance().sendPQVPC("PL_C_WideScreen");
			}
		}
		
		private function windowMouseClick(param1:* = null) : void {
			if(stage.displayState == "fullScreen") {
				_normalScreen_btn.dispatchEvent(new MouseEventUtil(MouseEventUtil.CLICK));
			}
			this._isCinema = false;
			this._turnOnWider_btn.visible = this._turnOnWider_btn.enabled = true;
			this._turnOffWider_btn.visible = this._turnOffWider_btn.enabled = false;
			ExternalInterface.call("swfWiderMode","off");
			_skinMap.getValue("fullScreenBtn").e = _skinMap.getValue("fullScreenBtn").v = true;
			_skinMap.getValue("normalScreenBtn").e = _skinMap.getValue("normalScreenBtn").v = false;
			this.setSkinState();
		}
		
		protected function showDefinitionSideBar(param1:MouseEventUtil) : void {
			var evt:MouseEventUtil = param1;
			clearTimeout(this._showBsbId);
			this._showBsbId = setTimeout(function():void {
				_definitionSlider.visible = true;
				_definitionSlider.open();
				_tween = TweenLite.to(_definitionSlider,0.3,{
					"alpha":1,
					"ease":Quad.easeOut
				});
				SendRef.getInstance().sendPQDrog("http://click.hd.sohu.com.cn/s.gif?type=fun_yangli205733_PL_C_Resolution&s=" + PlayerConfig.stype + "&_=" + new Date().getTime());
			},200);
		}
		
		protected function hideDefinitionSideBar(param1:* = null) : void {
			var evt:* = param1;
			clearTimeout(this._showBsbId);
			this._showBsbId = setTimeout(function():void {
				if(!_definitionSlider.hitTestPoint(mouseX,mouseY) || _ctrlBar_c.mouseX <= _definitionBar.x || !(evt == null) && evt.stageX <= 0 || mouseX >= stage.stageWidth - 6 || mouseY >= stage.stageHeight - 6) {
					hideBsb();
				}
			},200);
		}
		
		protected function hideBsb(param1:* = null) : void {
			var evt:* = param1;
			if(this._tween != null) {
				this._definitionSlider.visible = true;
				this._tween = TweenLite.to(this._definitionSlider,0.3,{
					"alpha":0,
					"ease":Quad.easeOut,
					"onComplete":function():void {
						_definitionSlider.visible = false;
					}
				});
				this._tween = null;
			}
		}
		
		private function langSet(param1:MouseEventUtil) : void {
		}
		
		private function nextClickHandler(param1:MouseEventUtil) : void {
			if((PlayerConfig.vrsPlayListId) && (!(this._playListPanel == null)) && (this._playListPanel.hasNext())) {
				this._playListPanel.nextPlay();
			}
			SendRef.getInstance().sendPQDrog("http://click.hd.sohu.com.cn/s.gif?type=fun_yangli205733_PL_C_Next&s=" + PlayerConfig.stype + "&_=" + new Date().getTime());
		}
		
		public function showPlayListPanel(param1:MouseEventUtil = null) : void {
			var evt:MouseEventUtil = param1;
			if(this._playListPanel == null) {
				this._albumBtn.enabled = this._albumBtn.visible = false;
				this._next_btn.enabled = false;
				new LoaderUtil().load(15,function(param1:Object):void {
					var obj:Object = param1;
					if(obj.info == "success") {
						_playListPanel = obj.data.content;
						_panelArr.push(_playListPanel);
						addChild(_playListPanel);
						_playListPanel.addEventListener("playVideo",function(param1:Event):void {
							_isSwitchVideos = true;
							dispatchEvent(new Event("playListVideo"));
						});
						_playListPanel.addEventListener("playListOk",function(param1:Event):void {
							_isPlayListOk = true;
							if(_playListPanel.hasNext()) {
								_next_btn.enabled = true;
							}
							if(_playListPanel.sourceLength() > 1) {
								_skinMap.getValue("albumBtn").e = _skinMap.getValue("albumBtn").v = true;
							} else {
								_skinMap.getValue("albumBtn").e = _skinMap.getValue("albumBtn").v = false;
							}
							setSkinState();
						});
						_playListPanel.init(_core.width,_core.height - (PlayerConfig.isHide?0:pbarDiff()));
						_playListPanel.initPlayList(PlayerConfig.vrsPlayListId,InforSender.getInstance().ifltype != ""?PlayerConfig.hdVid:PlayerConfig.vid);
						try {
							VerLog.msg(_playListPanel["version"]);
						}
						catch(evt:Error) {
						}
					}
				},null,PlayerConfig.swfHost + "panel/PlayList.swf");
			} else if(this._albumBtn.btnVisNum == 0) {
				if(this._playListPanel.isOpen) {
					this._playListPanel.close();
				} else if(this._preLoadPanel == null || (!this._preLoadPanel.isOpen) || (this._preLoadPanel.isBackgroundRun)) {
					this.closePanel();
					this._playListPanel.open();
					this.setChildIndex(this._playListPanel,this.getChildIndex(_ctrlBar_c) - 1);
					SendRef.getInstance().sendPQDrog("http://click.hd.sohu.com.cn/s.gif?type=fun_yangli205733_PL_C_SelectEpisodes&s=" + PlayerConfig.stype + "&_=" + new Date().getTime());
				}
				
			} else {
				this._next_btn.dispatchEvent(new MouseEventUtil(MouseEventUtil.MOUSE_UP));
			}
			
		}
		
		private function showSogouPanel(param1:MouseEventUtil) : void {
			var evt:MouseEventUtil = param1;
			if(this._sogouPanel == null) {
				this._sogou_btn.enabled = false;
				new LoaderUtil().load(10,function(param1:Object):void {
					if(param1.info == "success") {
						_sogouPanel = param1.data.content;
						_sogouPanel.close(0);
						_panelArr.push(_sogouPanel);
						addChild(_sogouPanel);
						setSkinState();
						_sogou_btn.dispatchEvent(new MouseEventUtil(MouseEventUtil.MOUSE_UP));
					}
					_sogou_btn.enabled = true;
				},null,PlayerConfig.swfHost + "panel/SogouPanel.swf");
			} else if(this._sogouPanel.isOpen) {
				this._sogouPanel.close();
			} else if(this._preLoadPanel == null || (!this._preLoadPanel.isOpen) || (this._preLoadPanel.isBackgroundRun)) {
				this.closePanel();
				this._sogouPanel.open();
				SendRef.getInstance().sendPQVPC("PL_R_Speed");
			}
			
			
		}
		
		private function get isBrowserFullScreen() : Boolean {
			var _loc2_:String = null;
			var _loc1_:* = false;
			if(Eif.available) {
				_loc2_ = ExternalInterface.call("isFullWindow");
				if(!(_loc2_ == null) && _loc2_ == "1") {
					_loc1_ = true;
				} else {
					_loc1_ = false;
				}
			}
			return _loc1_;
		}
		
		private function showCueTip() : void {
			var loadSucc:Function = null;
			var ctx:LoaderContext = null;
			loadSucc = function():void {
				_cueTipPanel.init(PlayerConfig.cueTipEpInfo);
				if((_isShownLogoAd) && !(_cueTipPanel == null)) {
					_cueTipPanel.visible = false;
				}
				setSkinState();
			};
			if(this._cueTipPanel == null) {
				ctx = new LoaderContext();
				ctx.applicationDomain = new ApplicationDomain(ApplicationDomain.currentDomain);
				new LoaderUtil().load(10,function(param1:Object):void {
					var obj:Object = param1;
					if(obj.info == "success") {
						_cueTipPanel = obj.data.content;
						_cueTipPanel.addEventListener(PanelEvent.READY,loadSucc);
						_cueTipPanel.addEventListener("GO_URL_HAPPENS",function(param1:Event):void {
							_core.pause();
						});
						addChild(_cueTipPanel);
					}
				},null,PlayerConfig.swfHost + "panel/CueTip.swf",ctx);
			}
		}
		
		private function showWmTip() : void {
			var ctx:LoaderContext = null;
			if(this._wmTipPanel == null) {
				ctx = new LoaderContext();
				ctx.applicationDomain = new ApplicationDomain(ApplicationDomain.currentDomain);
				new LoaderUtil().load(10,function(param1:Object):void {
					var wmDataInfo:Object = null;
					var obj:Object = param1;
					if(obj.info == "success") {
						_wmTipPanel = obj.data.content;
						_wmTipPanel.addEventListener("PAUSE",function(param1:Event):void {
							_isShownPauseAd = false;
							_core.pause();
						});
						_wmTipPanel.addEventListener("RESUME",function(param1:Event):void {
							_isShownPauseAd = true;
							_core.play();
						});
						_wmTipPanel.addEventListener("DAT_LOADED",function(param1:Event):void {
							var _loc3_:uint = 0;
							var _loc4_:* = 0;
							var _loc2_:Array = param1["dat"];
							if(_loc2_ != null) {
								_loc3_ = 0;
								while(_loc3_ < _loc2_.length) {
									if(_loc2_[_loc3_].interactionInfo.beginTime / PlayerConfig.totalDuration >= 0 && _loc2_[_loc3_].interactionInfo.beginTime / PlayerConfig.totalDuration <= 1) {
										_loc4_ = _loc2_[_loc3_].type == 1?!(_loc2_[_loc3_].interactionInfo.isItem == null) && _loc2_[_loc3_].interactionInfo.isItem == 0?0:_loc2_[_loc3_].type:_loc2_[_loc3_].type;
										PlayerConfig.epInfo.push({
											"rate":_loc2_[_loc3_].interactionInfo.beginTime / PlayerConfig.totalDuration,
											"time":_loc2_[_loc3_].interactionInfo.beginTime,
											"type":_loc4_,
											"title":_loc2_[_loc3_].interactionInfo.slogan,
											"isai":"1"
										});
									}
									_loc3_++;
								}
							}
							setHighDot();
						});
						_wmTipPanel.addEventListener("LOGIN",function(param1:Event):void {
							if(Eif.available) {
								if(PlayerConfig.domainProperty == "3") {
									ExternalInterface.call("show_login()");
								} else {
									ExternalInterface.call("sohuHD.showLoginWinbox()");
								}
							}
							if(stage.displayState == "fullScreen") {
								_normalScreen_btn.dispatchEvent(new MouseEventUtil(MouseEventUtil.CLICK));
							}
						});
						wmDataInfo = new Object();
						wmDataInfo.passport = PlayerConfig.passportMail;
						wmDataInfo.uid = PlayerConfig.visitorId;
						wmDataInfo.pageName = !(PlayerConfig.wmDataInfo == null) && !(PlayerConfig.wmDataInfo.wm_username == null)?PlayerConfig.wmDataInfo.wm_username:"";
						wmDataInfo.pagePhoto = !(PlayerConfig.wmDataInfo == null) && !(PlayerConfig.wmDataInfo.wm_userphoto == null)?PlayerConfig.wmDataInfo.wm_userphoto:"";
						wmDataInfo.pageUid = PlayerConfig.myTvUserId;
						wmDataInfo.vid = PlayerConfig.vid;
						wmDataInfo.sid = PlayerConfig.sid;
						wmDataInfo.isact = !(PlayerConfig.wmDataInfo == null) && !(PlayerConfig.wmDataInfo.wm_isact == null)?PlayerConfig.wmDataInfo.wm_isact:0;
						wmDataInfo.playtype = !(PlayerConfig.wmDataInfo == null) && !(PlayerConfig.wmDataInfo.wm_playtype == null)?PlayerConfig.wmDataInfo.wm_playtype:0;
						wmDataInfo.duration = PlayerConfig.totalDuration;
						wmDataInfo.isSohuDomain = PlayerConfig.isSohuDomain;
						wmDataInfo.isai = !(PlayerConfig.isai == "") && PlayerConfig.isai == "1"?true:false;
						wmDataInfo.tvid = PlayerConfig.tvid;
						wmDataInfo.domainProperty = PlayerConfig.domainProperty;
						LogManager.msg("自媒体视频信息:passport=" + wmDataInfo.passport + " : : uid=" + wmDataInfo.uid + " : : pageName=" + wmDataInfo.pageName + " : : wmDataInfo.pagePhoto=" + wmDataInfo.pagePhoto + " : : pageUid=" + wmDataInfo.pageUid + " : : vid=" + wmDataInfo.vid + " : : sid=" + wmDataInfo.sid + " : : isact=" + wmDataInfo.isact + " : : playtype=" + wmDataInfo.playtype + " : : duration=" + wmDataInfo.duration + ": : wmDataInfo.isai=" + wmDataInfo.isai + ": : wmDataInfo.tvid=" + wmDataInfo.tvid + ": : isSohuDomain=" + wmDataInfo.isSohuDomain);
						_wmTipPanel.init(wmDataInfo);
						addChild(_wmTipPanel);
						try {
							VerLog.msg(_wmTipPanel["version"]);
						}
						catch(evt:Error) {
						}
						setSkinState();
					}
				},null,PlayerConfig.swfHost + "panel/ugcmodule.swf",ctx);
			} else if((this._isShownLogoAd) && !(this._wmTipPanel == null)) {
				this._wmTipPanel.visible = false;
			}
			
		}
		
		protected function sharePanel(param1:MouseEventUtil) : void {
			var evt:MouseEventUtil = param1;
			if(this._sharePanel == null) {
				this.streamState = _core.streamState;
				this._share_btn.enabled = false;
				new LoaderUtil().load(10,function(param1:Object):void {
					var obj:Object = param1;
					if(obj.info == "success") {
						_sharePanel = obj.data.content;
						_sharePanel.init();
						_sharePanel.close(0);
						_panelArr.push(_sharePanel);
						_sharePanel.addEventListener("CLOSE_EVT",function(param1:Event):void {
							if(!(!(_more == null) && _more.visible)) {
								if(streamState == "pause") {
									_core.pause();
								} else {
									_core.play();
								}
							}
						});
						_core.dispatch(MediaEvent.PLAY_PROGRESS,{
							"nowTime":_core.filePlayedTime,
							"totTime":_core.fileTotTime,
							"isSeek":false
						});
						addChild(_sharePanel);
						_share_btn.dispatchEvent(new MouseEventUtil(MouseEventUtil.MOUSE_UP));
					}
					_share_btn.enabled = true;
				},null,PlayerConfig.swfHost + "panel/SharePanel.swf");
			} else if(this._sharePanel.isOpen) {
				this._sharePanel.close(evt);
			} else if(this._preLoadPanel == null || (!this._preLoadPanel.isOpen) || (this._preLoadPanel.isBackgroundRun)) {
				this.streamState = _core.streamState;
				this.closePanel();
				this._sharePanel.open();
				if(!(this._more == null) && (this._more.visible)) {
					this.setSkinState();
					this.setChildIndex(this._sharePanel,this.numChildren - 1);
				} else {
					_core.pause();
					if(stage.displayState == "fullScreen") {
						_normalScreen_btn.dispatchEvent(new MouseEventUtil(MouseEventUtil.CLICK));
					}
				}
				SendRef.getInstance().sendPQVPC("PL_R_Share");
				try {
					VerLog.msg(this._sharePanel["version"]);
				}
				catch(evt:Error) {
				}
			}
			
			
		}
		
		private function showLike(param1:* = null) : void {
			var ctx:LoaderContext = null;
			var evt:* = param1;
			this.streamState = _core.streamState;
			if(this._likePanel == null) {
				ctx = new LoaderContext();
				ctx.applicationDomain = new ApplicationDomain(ApplicationDomain.currentDomain);
				new LoaderUtil().load(10,function(param1:Object):void {
					var obj:Object = param1;
					if(obj.info == "success") {
						_likePanel = obj.data.content;
						_likePanel.addEventListener(PanelEvent.READY,function(param1:PanelEvent):void {
							var _loc2_:Object = new Object();
							_loc2_.width = _width;
							_loc2_.height = _core.height - (stage.displayState == "fullScreen"?pbarDiff():0);
							_loc2_.vid = PlayerConfig.vid;
							_loc2_.coverImg = PlayerConfig.coverImg;
							_loc2_.videoTitle = PlayerConfig.videoTitle;
							_loc2_.cid = PlayerConfig.cid;
							_loc2_.caid = PlayerConfig.caid;
							_loc2_.url = PlayerConfig.currentPageUrl == ""?escape(PlayerConfig.outReferer):escape(PlayerConfig.currentPageUrl);
							_loc2_.refer = PlayerConfig.currentPageUrl == ""?escape(PlayerConfig.outReferer):escape(PlayerConfig.currentPageUrl);
							_loc2_.fuid = PlayerConfig.userId;
							_loc2_.yyid = PlayerConfig.yyid;
							_loc2_.passport = PlayerConfig.passportMail;
							_loc2_.sid = PlayerConfig.sid;
							_loc2_.tvid = PlayerConfig.isMyTvVideo?Utils.cleanUnderline(PlayerConfig.vid):PlayerConfig.tvid;
							_loc2_.pid = PlayerConfig.vrsPlayListId;
							_loc2_.guid = PlayerConfig.userId;
							_loc2_.lb = PlayerConfig.lb;
							_likePanel.init(_loc2_);
							_core.pause();
							if(!_showBar_boo) {
								showBar2();
							}
							if(_progress_sld != null) {
								_progress_sld["hideNewPreview"] = true;
							}
							_startPlay_btn.visible = _skinMap.getValue("startPlayBtn").v = false;
							setSkinState();
							SendRef.getInstance().sendPQVPC("PL_R_Like");
						});
						addChild(_likePanel);
						try {
							VerLog.msg(_likePanel["version"]);
						}
						catch(evt:Error) {
						}
						_likePanel.x = 0;
						_likePanel.y = _topSideBarBg.height;
					}
				},null,PlayerConfig.swfHost + "recommendGuess.swf",ctx);
			} else {
				if(this._likePanel.visible) {
					this._likePanel.visible = false;
					if(this.streamState == "pause") {
						_core.pause();
					} else {
						_core.play();
					}
					if(_progress_sld != null) {
						_progress_sld["hideNewPreview"] = false;
					}
					_startPlay_btn.visible = _skinMap.getValue("startPlayBtn").v = true;
				} else {
					this._likePanel.visible = true;
					_core.pause();
					if(_progress_sld != null) {
						_progress_sld["hideNewPreview"] = true;
					}
					_startPlay_btn.visible = _skinMap.getValue("startPlayBtn").v = false;
					SendRef.getInstance().sendPQVPC("PL_R_Like");
				}
				if(!_showBar_boo) {
					this.showBar2();
				}
			}
		}
		
		public function loadMore(param1:TvSohuAdsEvent = null) : void {
			var _loc2_:String = null;
			var _loc3_:LoaderContext = null;
			if(PlayerConfig.isHide) {
				this._saveIsHide = PlayerConfig.isHide;
				PlayerConfig.isHide = _isHide = false;
				this.resize(stage.stageWidth,stage.stageHeight);
			}
			if(!(this._playListPanel == null) && (this._playListPanel.isOpen)) {
				this._playListPanel.close();
			}
			if(!(this._settingPanel == null) && (this._settingPanel.visible)) {
				this._settingPanel.close();
			}
			if(this._more == null) {
				_loc2_ = PlayerConfig.isSohuDomain?PlayerConfig.RECOMMEND_PANEL_PATH:PlayerConfig.OUTRECOMMEND_PANEL_PATH;
				_loc3_ = new LoaderContext();
				_loc3_.applicationDomain = new ApplicationDomain(ApplicationDomain.currentDomain);
				new LoaderUtil().load(5,this.moreHandler,null,PlayerConfig.swfHost + _loc2_,_loc3_);
				SendRef.getInstance().sendPQVPC("PL_R_BVIEW");
			} else {
				this._more.visible = true;
				SendRef.getInstance().sendPQVPC("PL_R_BVIEW");
				if(_progress_sld != null) {
					_progress_sld["hideNewPreview"] = true;
				}
				if(!_showBar_boo) {
					this.showBar2();
				}
			}
		}
		
		private function moreHandler(param1:Object) : void {
			var moreH:Number = NaN;
			var obj:Object = param1;
			if(obj.info == "success") {
				this._more = obj.data.content;
				moreH = 0;
				this._more.addEventListener(PanelEvent.READY,function(param1:PanelEvent):void {
					var _loc2_:Object = new Object();
					_loc2_.width = _width;
					_loc2_.height = _core.height - (stage.displayState == "fullScreen"?pbarDiff():0);
					_loc2_.vid = PlayerConfig.vid;
					_loc2_.coverImg = PlayerConfig.coverImg;
					_loc2_.videoTitle = PlayerConfig.videoTitle;
					_loc2_.cid = PlayerConfig.cid;
					_loc2_.caid = PlayerConfig.caid;
					_loc2_.url = PlayerConfig.currentPageUrl == ""?escape(PlayerConfig.outReferer):escape(PlayerConfig.currentPageUrl);
					_loc2_.refer = PlayerConfig.currentPageUrl == ""?escape(PlayerConfig.outReferer):escape(PlayerConfig.currentPageUrl);
					_loc2_.fuid = PlayerConfig.userId;
					_loc2_.yyid = PlayerConfig.yyid;
					_loc2_.passport = PlayerConfig.passportMail;
					_loc2_.sid = PlayerConfig.sid;
					_loc2_.tvid = PlayerConfig.isMyTvVideo?Utils.cleanUnderline(PlayerConfig.vid):PlayerConfig.tvid;
					_loc2_.pid = PlayerConfig.vrsPlayListId;
					_loc2_.guid = PlayerConfig.userId;
					_loc2_.lb = PlayerConfig.lb;
					_more.init(_loc2_);
					if(_progress_sld != null) {
						_progress_sld["hideNewPreview"] = true;
					}
					if(!_showBar_boo) {
						showBar2();
					}
					setSkinState();
				});
				this._more.addEventListener("open_share_event",function(param1:Event):void {
					_share_btn.dispatchEvent(new MouseEventUtil(MouseEventUtil.MOUSE_UP));
				});
				this._more.addEventListener("replay_event",function(param1:Event):void {
					_replay_btn.dispatchEvent(new MouseEventUtil(MouseEventUtil.MOUSE_UP));
				});
				this._more.addEventListener("SAYSAY_CLICK",function(param1:Event):void {
					if(stage.displayState == "fullScreen") {
						_normalScreen_btn.dispatchEvent(new MouseEventUtil(MouseEventUtil.CLICK));
					}
				});
				addChild(this._more);
				try {
					VerLog.msg(this._more["version"]);
				}
				catch(evt:Error) {
				}
			}
		}
		
		private function downloadVideo(param1:MouseEvent) : void {
			if(stage.displayState == "fullScreen") {
				_normalScreen_btn.dispatchEvent(new MouseEventUtil(MouseEventUtil.CLICK));
			}
			ExternalInterface.call("spxzClick",true);
			SendRef.getInstance().sendPQVPC("PL_R_Download");
		}
		
		public function ctrlBarVisible(param1:Boolean, param2:* = null) : void {
			_ctrlBar_c.visible = this._adContainer.visible = this._rightSideBar.visible = false;
			PlayerConfig.isHide = _isHide = true;
			this.resize(stage.stageWidth,stage.stageHeight);
			if(!(param2 == null) && param2 == 1) {
				if(!param1) {
					PlayerConfig.isHide = _isHide = param1;
				}
				this.resize(stage.stageWidth,stage.stageHeight);
				_ctrlBar_c.visible = this._adContainer.visible = this._rightSideBar.visible = true;
			} else {
				if(!param1) {
					PlayerConfig.isHide = _isHide = true;
				}
				this.resize(stage.stageWidth,stage.stageHeight);
			}
		}
		
		private function showCaptionPanel(param1:MouseEvent) : void {
			var evt:MouseEvent = param1;
			if(this._captionPanel == null) {
				this._caption_btn.enabled = false;
				new LoaderUtil().load(10,function(param1:Object):void {
					var obj:Object = param1;
					if(obj.info == "success") {
						_captionPanel = obj.data.content;
						_captionPanel.init(_owner);
						_captionPanel.close(0);
						_panelArr.push(_captionPanel);
						_captionPanel.addEventListener("captionVer",function(param1:Event):void {
							_captionBar.captionVer = param1.target.captionVer;
						});
						_captionPanel.addEventListener("captionColor",function(param1:Event):void {
							_captionBar.captionColor = param1.target.captionColor;
						});
						_captionPanel.addEventListener("captionSizeRate",function(param1:Event):void {
							_captionBar.captionSizeRate = param1.target.captionSizeRate;
						});
						_captionPanel.addEventListener("captionAlpha",function(param1:Event):void {
							_captionBar.captionAlpha = param1.target.captionAlpha;
						});
						addChild(_captionPanel);
						setSkinState();
						_caption_btn.dispatchEvent(new MouseEventUtil(MouseEventUtil.MOUSE_UP));
					}
					_caption_btn.enabled = true;
				},null,PlayerConfig.swfHost + "panel/CaptionPanel.swf");
			} else if(this._captionPanel.isOpen) {
				this._captionPanel.close();
			} else if(this._preLoadPanel == null || (!this._preLoadPanel.isOpen) || (this._preLoadPanel.isBackgroundRun)) {
				this.closePanel();
				this._captionPanel.open();
			}
			
			
		}
		
		public function get captionBar() : * {
			return this._captionBar;
		}
		
		private function tipVipCookie() : void {
			var _loc4_:* = 0;
			var _loc5_:String = null;
			var _loc1_:SharedObject = SharedObject.getLocal("tipIFoxVip","/");
			var _loc2_:Date = new Date();
			var _loc3_:String = _loc2_.getFullYear() + "/" + (_loc2_.getMonth() + 1) + "/" + _loc2_.getDate();
			if(!(_loc1_.data.date == undefined) && !(_loc1_.data.date == "")) {
				if(_loc1_.data.date == _loc3_) {
					_loc4_ = _loc1_.data.times;
					if(_loc1_.data.times < 3) {
						this._tipHistory.showIfoxVipTip();
						_loc4_++;
						_loc1_.data.times = _loc4_;
					}
				} else {
					this._tipHistory.showIfoxVipTip();
					_loc1_.data.date = _loc3_;
					_loc1_.data.times = 1;
				}
			} else {
				this._tipHistory.showIfoxVipTip();
				_loc1_.data.date = _loc3_;
				_loc1_.data.times = 1;
			}
			try {
				_loc5_ = _loc1_.flush();
				if(_loc5_ == SharedObjectFlushStatus.PENDING) {
					_loc1_.addEventListener(NetStatusEvent.NET_STATUS,this.onStatusShare);
				} else if(_loc5_ == SharedObjectFlushStatus.FLUSHED) {
				}
				
			}
			catch(e:Error) {
			}
		}
		
		private function tipVolKeyboardCookie() : void {
			var _loc1_:SharedObject = SharedObject.getLocal("tipVolKeyboard","/");
			var _loc2_:Date = new Date();
			var _loc3_:String = _loc2_.getFullYear() + "-" + _loc2_.getMonth() + "-" + _loc2_.getDate();
			if(!(_loc3_ == String(_loc1_.data.td)) && !(this._tipHistory == null) && !this._tipHistory.isOpen && !this._tipHistory.isShowVolKeyboardTip) {
				this._tipHistory.showVolKeyboardTip();
			}
		}
		
		private function tipProKeyboardCookie() : void {
			var _loc1_:SharedObject = SharedObject.getLocal("tipProKeyboard","/");
			var _loc2_:Date = new Date();
			var _loc3_:String = _loc2_.getFullYear() + "-" + _loc2_.getMonth() + "-" + _loc2_.getDate();
			if(!(_loc3_ == String(_loc1_.data.dt)) && !(this._tipHistory == null) && !this._tipHistory.isOpen && !this._tipHistory.isShowProKeyboardTip) {
				this._tipHistory.showProKeyboardTip();
			}
		}
		
		private function onStatusShare(param1:NetStatusEvent) : void {
			if(param1.info.code != "SharedObject.Flush.Success") {
				if(param1.info.code == "SharedObject.Flush.Failed") {
				}
			}
			param1.target.removeEventListener(NetStatusEvent.NET_STATUS,this.onStatusShare);
		}
		
		override protected function startPlayMouseUp(param1:MouseEventUtil) : void {
			if(!PlayerConfig.autoPlay) {
				Model.getInstance().sendVV();
			}
			if(!(this._likePanel == null) && (this._likePanel.visible)) {
				this._likePanel.visible = false;
			}
			if((!PlayerConfig.autoPlay && TvSohuAds.getInstance().startAd.hasAd && !TvSohuAds.getInstance().startAd.isAutoPlayAd) && (!this._mpbAutoPlay) && TvSohuAds.getInstance().startAd.state == "no") {
				TvSohuAds.getInstance().startAd.play();
				dispatchEvent(new Event("ChangeAutoPlay"));
				this._mpbAutoPlay = true;
			} else if(!PlayerConfig.autoPlay && (TvSohuAds.getInstance().startAd.isAutoPlayAd)) {
				dispatchEvent(new Event("ChangeAutoPlay"));
				if(this._saveIsHide) {
					this.replay(param1);
				} else {
					super.startPlayMouseUp(param1);
				}
			} else if(this._saveIsHide) {
				this.replay(param1);
			} else {
				super.startPlayMouseUp(param1);
			}
			
			
			SendRef.getInstance().sendPQDrog("http://click.hd.sohu.com.cn/s.gif?type=fun_yangli205733_PL_S_PlayButton&s=" + PlayerConfig.stype + "&_=" + new Date().getTime());
		}
		
		override protected function playMouseUp(param1:MouseEventUtil) : void {
			if(!PlayerConfig.autoPlay) {
				Model.getInstance().sendVV();
			}
			if(!(this._likePanel == null) && (this._likePanel.visible)) {
				this._likePanel.visible = false;
			}
			if((!PlayerConfig.autoPlay && TvSohuAds.getInstance().startAd.hasAd) && (!TvSohuAds.getInstance().startAd.isAutoPlayAd) && !this._mpbAutoPlay) {
				TvSohuAds.getInstance().startAd.play();
				dispatchEvent(new Event("ChangeAutoPlay"));
				this._mpbAutoPlay = true;
			} else if(!PlayerConfig.autoPlay && (TvSohuAds.getInstance().startAd.isAutoPlayAd)) {
				dispatchEvent(new Event("ChangeAutoPlay"));
				if(this._saveIsHide) {
					this.replay(param1);
				} else {
					super.playMouseUp(param1);
				}
			} else if(this._saveIsHide) {
				this.replay(param1);
			} else {
				super.playMouseUp(param1);
			}
			
			
			SendRef.getInstance().sendPQDrog("http://click.hd.sohu.com.cn/s.gif?type=fun_yangli205733_PL_C_Play&s=" + PlayerConfig.stype + "&_=" + new Date().getTime());
		}
		
		override protected function pauseMouseUp(param1:MouseEventUtil) : void {
			super.pauseMouseUp(param1);
			SendRef.getInstance().sendPQDrog("http://click.hd.sohu.com.cn/s.gif?type=fun_yangli205733_PL_C_Pause&s=" + PlayerConfig.stype + "&_=" + new Date().getTime());
		}
		
		public function activity(param1:Object) : void {
			var o:Object = param1;
			if(o.status == 1 && o.pt == 0) {
				new LoaderUtil().load(10,function(param1:Object):void {
					if(param1.info == "success") {
						_activity = param1.data.content;
						_activity.setData(o);
						setSkinState();
						addChildAt(param1.data,getChildIndex(_adContainer) + 1);
					}
				},null,PlayerConfig.ACTIVITY_SWF_PATH);
			} else if(o.status == 1 && o.pt > 0) {
				PlayerConfig.activityTimer = o.pt;
			}
			
		}
		
		private function showPreLoadPanel(param1:Boolean = true) : void {
			var url:String = null;
			var backgroundRun:Boolean = param1;
			if(this._preLoadPanel == null) {
				url = PlayerConfig.swfHost + "panel/PreLoadPanel.swf";
				new LoaderUtil().load(10,function(param1:Object):void {
					if(param1.info == "success") {
						_preLoadPanel = param1.data.content;
						_preLoadPanel.close(0);
						_preLoadPanel.addEventListener("start_pre_load",startPreLoad);
						_preLoadPanel.addEventListener("backgroundRun",preLoadPanelBGRun);
						_preLoadPanel.addEventListener("frontrun",preLoadPanelFGRun);
						_preLoadPanel.addEventListener("pre_load_finish",preLoadFinish);
						_preLoadPanel.addEventListener("pre_panel_closed",_core.play);
						_owner.addChildAt(_preLoadPanel,_owner.getChildIndex(_adContainer) - 2);
						if(backgroundRun) {
							_preLoadPanel.toBackgroundRun();
						}
						if(!PlayerConfig.isCounterfeitFms) {
							_preLoadPanel.open();
						}
						setSkinState();
					}
				},null,url);
			} else {
				if(backgroundRun) {
					this._preLoadPanel.toBackgroundRun();
				}
				this._preLoadPanel.open();
			}
		}
		
		override protected function loadProgress(param1:*) : void {
			super.loadProgress(param1);
			if(_skin != null) {
				if((PlayerConfig.isCounterfeitFms) || !(PlayerConfig.startTime == "") && !(PlayerConfig.endTime == "")) {
					_progress_sld.middleRate = 0;
				}
			}
			if(this._preLoadPanel != null) {
				this._preLoadPanel.loadProgress(param1);
			}
		}
		
		override public function resize(param1:Number, param2:Number) : void {
			var param1:Number = param1 < 0?1:param1;
			var param2:Number = param2 < 0?1:param2;
			var _loc3_:Number = param1;
			var _loc4_:Number = param2;
			_width = param1;
			_height = param2;
			if(stage.displayState == "fullScreen") {
				if(_skin != null) {
					_loc4_ = param2 - (TvSohuAds.getInstance().bottomAd.isFButtomAd?0:TvSohuAds.getInstance().bottomAd.height);
				}
			} else if(!((_isHide) && !(_skin == null))) {
				if(_skin != null) {
					_loc4_ = param2 - ctrlBarBg.height - (TvSohuAds.getInstance().bottomAd.isFButtomAd?0:TvSohuAds.getInstance().bottomAd.height);
					stopTween();
				}
			}
			
			_core.resize(_loc3_,_loc4_);
			if(!(_cover_c.width == 0) && !(_cover_c.height == 0)) {
				Utils.prorata(_cover_c,_loc3_,_loc4_);
				Utils.setCenter(_cover_c,_core);
			}
			if(this._captionBar != null) {
				this._captionBar.resize(_loc3_);
			}
			this.setSkinState();
			if(stage.loaderInfo.parameters["os"] == "android") {
				this.setAdsState();
			}
			if(this._danmu != null) {
				this._danmu.updateTmLayerSize(_core.width,_core.height - (stage.displayState == "fullScreen"?_ctrlBarBg_spr.height:0));
			}
		}
		
		override protected function setSkinState() : void {
			var _loc2_:Object = null;
			var _loc3_:* = NaN;
			var _loc4_:* = NaN;
			var _loc5_:* = NaN;
			var _loc1_:Number = 0;
			if(_skin != null) {
				_loc1_ = _core.width - _ctrlBarBg_spr.width;
			}
			this.setWatermark();
			if(this._timer_c != null) {
				this._timer_c.y = TvSohuAds.getInstance().topAd.container.height + 8;
				this._timer_c.x = _core.width - this._timer_c.width - 60;
				if((this._isViewTimer) && stage.displayState == "fullScreen" && !TvSohuAds.getInstance().topLogoAd.hasAd && !(TvSohuAds.getInstance().startAd.hasAd && TvSohuAds.getInstance().startAd.state == "playing")) {
					this._timer_c.visible = true;
				} else {
					this._timer_c.visible = false;
				}
			}
			if((TvSohuAds.getInstance().endAd.hasAd) && (TvSohuAds.getInstance().endAd.state == "playing") || (TvSohuAds.getInstance().startAd.hasAd) && (TvSohuAds.getInstance().startAd.state == "playing") || (TvSohuAds.getInstance().bottomAd.hasAd) && (TvSohuAds.getInstance().bottomAd.isShow) && !(_skinMap.getValue("startPlayBtn").align == "center")) {
			}
			if(!(this._tipHistory == null) && (this._tipHistory.isOpen)) {
				_skinMap.getValue("tipDisplay").v = false;
			}
			if(stage.displayState == "fullScreen" && !(this._playListPanel == null)) {
				if(this._isPlayListOk) {
					if((this._isPlayListOk) && this._playListPanel.sourceLength() > 1) {
						_skinMap.getValue("nextBtn").e = this._playListPanel.hasNext()?true:false;
						_skinMap.getValue("nextBtn").v = true;
					}
				}
			} else {
				_skinMap.getValue("nextBtn").v = false;
			}
			super.setSkinState();
			if(_skin != null) {
				if(stage.displayState == "fullScreen" || (PlayerConfig.isHide)) {
					_ctrlBarBg_spr.alpha = 0.8;
					if(_showBar_boo) {
						_ctrlBar_c.y = _hitArea_spr.y + _hitArea_spr.height + (TvSohuAds.getInstance().bottomAd.isFButtomAd?0:TvSohuAds.getInstance().bottomAd.height) - _ctrlBarBg_spr.height;
					} else {
						_ctrlBar_c.y = _hitArea_spr.y + _hitArea_spr.height + (TvSohuAds.getInstance().bottomAd.isFButtomAd?0:TvSohuAds.getInstance().bottomAd.height) + 2;
					}
					if(this._settingPanel != null) {
						this._settingPanel.y = Math.round(_hitArea_spr.y + _hitArea_spr.height - this._settingPanel.height - _ctrlBarBg_spr.height + 1);
					}
				} else {
					_ctrlBarBg_spr.alpha = 1;
					_ctrlBar_c.y = _hitArea_spr.y + _hitArea_spr.height + (TvSohuAds.getInstance().bottomAd.isFButtomAd?0:TvSohuAds.getInstance().bottomAd.height);
					if(this._settingPanel != null) {
						this._settingPanel.y = Math.round(_hitArea_spr.y + _hitArea_spr.height - this._settingPanel.height + 1);
					}
				}
				_loc3_ = _ctrlBarBg_spr.width;
				_loc2_ = _skinMap.getValue("tipDisplay");
				_tipDisplay.x = _loc2_.x = _loc2_.x + (_loc2_.r?_loc1_:0);
				_tipDisplay.y = _loc2_.y;
				_loc2_ = _skinMap.getValue("tvSohuLogoBtn");
				if((PlayerConfig.isNewsLogo) || PlayerConfig.channel == "s") {
					this._tvSohuLogo_btn.x = _loc2_.x = _loc2_.x + (_loc2_.r?_loc1_:0);
					this._tvSohuLogo_btn.x = this._tvSohuLogo_btn.x - 40;
				} else {
					this._tvSohuLogo_btn.x = _loc2_.x = _loc2_.x + (_loc2_.r?_loc1_:0);
				}
				this._tvSohuLogo_btn.y = _loc2_.y;
				this._tvSohuLogo_btn.visible = (_loc2_.v) && _loc3_ > _loc2_.w;
				this._tvSohuLogo_btn.enabled = _loc2_.e;
				_loc2_ = _skinMap.getValue("lightBar");
				if(!_fullScreen_btn.visible && !_normalScreen_btn.visible) {
					this._lightBar.x = _fullScreen_btn.x + _fullScreen_btn.width - this._lightBar.width;
				} else {
					this._lightBar.x = _fullScreen_btn.x - this._lightBar.width;
				}
				this._lightBar.visible = (_loc2_.v) && _loc3_ > _loc2_.w;
				this._lightBar.y = _loc2_.y;
				this._lightBar.enabled = _loc2_.e;
				_loc2_ = _skinMap.getValue("definitionBar");
				this._definitionBar["hasBtnVis"] = PlayerConfig.h2644kVid == PlayerConfig.currentVid?0:PlayerConfig.oriVid == PlayerConfig.currentVid?1:PlayerConfig.superVid == PlayerConfig.currentVid?2:PlayerConfig.hdVid == PlayerConfig.currentVid?3:4;
				if(!this._lightBar.visible) {
					this._definitionBar.x = this._lightBar.x + this._lightBar.width - this._definitionBar.width;
				} else {
					this._definitionBar.x = this._lightBar.x - this._definitionBar.width;
				}
				this._definitionBar.visible = (_loc2_.v) && _loc3_ > _loc2_.w;
				this._definitionBar.y = _loc2_.y;
				this._definitionSlider.y = this._definitionBar.y - this._definitionSlider.height - 9;
				this._definitionBar.enabled = _loc2_.e;
				_loc2_ = _skinMap.getValue("langSetBar");
				if(!this._definitionBar.visible) {
					this._langSetBar.x = this._definitionBar.x + this._definitionBar.width - this._langSetBar.width;
				} else {
					this._langSetBar.x = this._definitionBar.x - this._langSetBar.width;
				}
				this._langSetBar.visible = (_loc2_.v) && _loc3_ > _loc2_.w;
				this._langSetBar.y = _loc2_.y;
				this._langSetBar.enabled = _loc2_.e;
				_loc2_ = _skinMap.getValue("volumeBar");
				if(!this._langSetBar.visible) {
					_volume_sld.x = this._langSetBar.x + this._langSetBar.width - _volume_sld.width;
				} else {
					_volume_sld.x = this._langSetBar.x - _volume_sld.width;
				}
				_loc2_ = _skinMap.getValue("barrageBtn");
				if(!_volume_sld.visible) {
					this._barrageBtn.x = _volume_sld.x + _volume_sld.width - this._barrageBtn.width;
				} else {
					this._barrageBtn.x = _volume_sld.x - this._barrageBtn.width;
				}
				this._barrageBtn.visible = (_loc2_.v) && _loc3_ > _loc2_.w;
				this._barrageBtn.y = _loc2_.y;
				this._barrageBtn.enabled = _loc2_.e;
				_loc2_ = _skinMap.getValue("oriSongBtn");
				if(!this._barrageBtn.visible) {
					this._oriSongBtn.x = this._barrageBtn.x + this._barrageBtn.width - this._oriSongBtn.width;
				} else {
					this._oriSongBtn.x = this._barrageBtn.x - this._oriSongBtn.width;
				}
				this._oriSongBtn.visible = (_loc2_.v) && _loc3_ > _loc2_.w;
				this._oriSongBtn.y = _loc2_.y;
				this._oriSongBtn.enabled = _loc2_.e;
				_loc2_ = _skinMap.getValue("vocSongBtn");
				if(!this._barrageBtn.visible) {
					this._vocSongBtn.x = this._barrageBtn.x + this._barrageBtn.width - this._vocSongBtn.width;
				} else {
					this._vocSongBtn.x = this._barrageBtn.x - this._vocSongBtn.width;
				}
				this._vocSongBtn.visible = (_loc2_.v) && _loc3_ > _loc2_.w;
				this._vocSongBtn.y = _loc2_.y;
				this._vocSongBtn.enabled = _loc2_.e;
				_loc2_ = _skinMap.getValue("replayBtn");
				this._replay_btn.x = _loc2_.x = _loc2_.x + (_loc2_.r?_loc1_:0);
				this._replay_btn.y = _loc2_.y;
				this._replay_btn.visible = (_loc2_.v) && _loc3_ > _loc2_.w;
				this._replay_btn.enabled = _loc2_.e;
				_loc2_ = _skinMap.getValue("albumBtn");
				this._albumBtn.x = _loc2_.x = _loc2_.x + (_loc2_.r?_loc1_:0);
				this._albumBtn.y = _loc2_.y;
				if(this._playListPanel != null) {
					if((this._isPlayListOk) && this._playListPanel.sourceLength() > 1 && (_loc3_)) {
						if(_core.streamState != "stop") {
							_skinMap.getValue("albumBtn").e = _skinMap.getValue("albumBtn").v = true;
						}
					} else {
						_skinMap.getValue("albumBtn").e = _skinMap.getValue("albumBtn").v = false;
					}
				} else {
					_skinMap.getValue("albumBtn").e = _skinMap.getValue("albumBtn").v = false;
				}
				this._albumBtn.visible = (_loc2_.v) && _loc3_ > _loc2_.w;
				this._albumBtn.enabled = _loc2_.e;
				this._albumBtn["hasBtnVis"] = PlayerConfig.domainProperty == "0" && !(stage.displayState == "fullScreen")?1:0;
				if(!(this._playListPanel == null) && (this._isPlayListOk) && this._playListPanel.sourceLength() > 1 && this._albumBtn.btnVisNum == 1) {
					this._albumBtn.onlyBtnEnabled(this._albumBtn.btnVisNum,this._playListPanel.hasNext()?true:false);
				}
				_loc2_ = _skinMap.getValue("nextBtn");
				this._next_btn.visible = _loc2_.v;
				this._next_btn.enabled = _loc2_.e;
				this._next_btn.x = _loc2_.x = _loc2_.x + (_loc2_.r?_loc1_:0);
				this._next_btn.y = _loc2_.y;
				_loc2_ = _skinMap.getValue("timeDisplay");
				_timeDisplay.visible = (_loc2_.v) && _loc3_ > _loc2_.w;
				_timeDisplay.x = (this._albumBtn.visible) && (this._next_btn.visible)?this._next_btn.x + this._next_btn.width:this._albumBtn.visible?_loc2_.x + (_loc2_.r?_loc1_:0):this._albumBtn.x;
				this._normalScreen3_btn.visible = _normalScreen_btn.visible;
				this._normalScreen3_btn.enabled = _normalScreen_btn.enabled;
				this._definitionSlider.x = this._definitionBar.x - (this._definitionSlider.width - this._definitionBar.width) / 2;
				this._rightSideBar.y = Math.round(_hitArea_spr.y + _hitArea_spr.height / 3 - this._rightSideBar.height / 3 + 10);
				if(!this._firstSet) {
					this._rightSideBar.x = this._rightSideBar.x + _loc1_;
				}
				this._firstSet = false;
				this.setAdsState();
				if(this._transition_mc != null) {
					Utils.setCenter(this._transition_mc,_hitArea_spr);
				}
				if(this._sharePanel != null) {
					this._sharePanel.resize(_core.width,_core.height);
					Utils.setCenter(this._sharePanel,_hitArea_spr);
				}
				if(!(this._playListPanel == null) && (this._isPlayListOk)) {
					this._playListPanel.resize(_core.width,_core.height - (PlayerConfig.isHide?0:this.pbarDiff()));
					this._playListPanel.x = Math.round((_core.width - this._playListPanel.width) / 2);
					this._playListPanel.y = Math.round(_hitArea_spr.height - this._playListPanel.height - 15 - (stage.displayState == "fullScreen" || (PlayerConfig.isHide)?_ctrlBarBg_spr.height:0));
				}
				if(this._sogouPanel != null) {
					Utils.setCenter(this._sogouPanel,_hitArea_spr);
				}
				if(this._acmePanel != null) {
					Utils.setCenter(this._acmePanel,_hitArea_spr);
				}
				if(this._flatWall3D != null) {
					this._flatWall3D.resize(_core.width,_core.height - (stage.displayState == "fullScreen"?this.pbarDiff():0));
				}
				if(this._cueTipPanel != null) {
					if((this._tipHistory.isOpen) && TvSohuAds.getInstance().bottomAd.height == 0) {
						this._cueTipPanel.y = Math.round(_hitArea_spr.height - this._cueTipPanel.height - 6 - this._tipHistory.height - (stage.displayState == "fullScreen" || (PlayerConfig.isHide)?_ctrlBarBg_spr.height:0));
					} else {
						this._cueTipPanel.y = Math.round(_hitArea_spr.height - this._cueTipPanel.height - 6 - (stage.displayState == "fullScreen" || (PlayerConfig.isHide)?_ctrlBarBg_spr.height:0));
					}
					this._cueTipPanel.x = Math.round(_hitArea_spr.width - this._cueTipPanel.width - 4);
				}
				if(this._wmTipPanel != null) {
					this._wmTipPanel.resize(_core.width,_core.height - (stage.displayState == "fullScreen"?this.pbarDiff():0));
					if(this._isShownLogoAd) {
						this._wmTipPanel.specialResize(TvSohuAds.getInstance().logoAd.height,"right");
					} else {
						this._wmTipPanel.specialResize(0,"right");
					}
					if(this._isShownBottomAd) {
						this._wmTipPanel.specialResize(TvSohuAds.getInstance().bottomAd.isFButtomAd?TvSohuAds.getInstance().bottomAd.height:0,"whole");
					} else {
						this._wmTipPanel.specialResize(0,"whole");
					}
				}
				if(this._hisRecommend != null) {
					this._hisRecommend.x = 5;
					if((this._tipHistory.isOpen) && TvSohuAds.getInstance().bottomAd.height == 0) {
						this._hisRecommend.y = -43 - this._tipHistory.height;
					} else {
						this._hisRecommend.y = -43;
					}
				}
				if(this._captionPanel != null) {
					Utils.setCenter(this._captionPanel,_hitArea_spr);
				}
				if(this._likePanel != null) {
					this._likePanel.resize(_core.width,_core.height - (stage.displayState == "fullScreen"?this.pbarDiff():0) - this._topSideBarBg.height);
					if(!_showBar_boo) {
						this.showBar2();
					}
				}
				this._topSideBarBg.width = _hitArea_spr.width;
				if(this._searchBar != null) {
					this._searchBar.resize(this._topSideBarBg.width,1);
				}
				Utils.setCenter(this._normalScreen3_btn,this._topSideBarBg);
				this._normalScreen3_btn.x = this._topSideBarBg.width - this._normalScreen3_btn.width;
				if(this._topPerSp.visible) {
					Utils.setCenter(this._topPerSp,this._topSideBarBg);
				}
				if(this._preLoadPanel != null) {
					if(this._preLoadPanel.isBackgroundRun) {
						if((this._tipHistory.isOpen) && TvSohuAds.getInstance().bottomAd.height == 0) {
							this._preLoadPanel.y = Math.round(_hitArea_spr.height - this._preLoadPanel.height - this._tipHistory.height);
						} else {
							this._preLoadPanel.y = Math.round(_hitArea_spr.height - this._preLoadPanel.height - 3);
						}
						this._preLoadPanel.x = Math.round(_hitArea_spr.width - this._preLoadPanel.width);
					} else {
						Utils.setCenter(this._preLoadPanel,_hitArea_spr);
					}
				}
				if(_skinMap.getValue("startPlayBtn").align != "center") {
					_startPlay_btn.y = -_startPlay_btn.skin.bg.height - (10 + ((this._tipHistory.isOpen) && TvSohuAds.getInstance().bottomAd.height == 0?this._tipHistory.height:0));
				} else {
					_startPlay_btn.x = Math.round(_hitArea_spr.x + (_hitArea_spr.width - _startPlay_btn.skin.bg.width) / 2);
					_startPlay_btn.y = Math.round(_hitArea_spr.y + (_hitArea_spr.height - _startPlay_btn.skin.bg.height) / 2);
				}
				Utils.setCenter(this._retryPanel,_hitArea_spr);
				if(this._playHistoryPanel != null) {
					Utils.setCenter(this._playHistoryPanel,_hitArea_spr);
				}
				Utils.setCenter(this._videoInfoPanel,_hitArea_spr);
				if(this._settingPanel != null) {
					if(this._settingPanel.isSpCenter) {
						Utils.setCenter(this._settingPanel,_hitArea_spr);
					} else {
						this._settingPanel.x = Math.round(_hitArea_spr.width - this._settingPanel.width);
					}
				}
				if(this._more != null) {
					this._more.resize(_core.width,_core.height - (stage.displayState == "fullScreen"?this.pbarDiff():0));
					if(!_showBar_boo) {
						this.showBar2();
					}
				}
				if(this._highlightPanel != null) {
					this._highlightPanel.x = this._highlightPanel.y = 0;
					this._highlightPanel.resize(_width,_height);
				}
				if(this._activity != null) {
					this._activity.x = _hitArea_spr.width - this._activity.bg_mc.width;
					this._activity.y = _hitArea_spr.height - this._activity.bg_mc.height - _progress_sld["sliderDiffHeight"] - ((PlayerConfig.isHide) || stage.displayState == "fullScreen"?_ctrlBarBg_spr.height:0);
				}
				this._tipHistory.resize(_width);
				if((PlayerConfig.topBarFull) && !PlayerConfig.topBarNor) {
					if(stage.displayState == "fullScreen") {
						this._topSideBar.visible = true;
						if(!(this._displayRate == 0.5) && !(this._displayRate == 0.75) && !(this._displayRate == 1)) {
							this._topPer50_btn.enabled = this._topPer75_btn.enabled = this._topPer100_btn.enabled = true;
						}
					} else {
						this._topSideBar.visible = false;
					}
				} else if((PlayerConfig.topBarNor) && !PlayerConfig.topBarFull) {
					if(stage.displayState == "fullScreen") {
						this._topSideBar.visible = false;
					} else {
						this._topSideBar.visible = true;
						this._topPerSp.visible = false;
					}
				} else if((PlayerConfig.topBarFull) && (PlayerConfig.topBarNor)) {
					if(stage.displayState == "fullScreen") {
						this._topPerSp.visible = true;
					} else {
						this._topPerSp.visible = false;
					}
				} else if(!PlayerConfig.topBarFull && !PlayerConfig.topBarNor) {
					this._topSideBar.visible = false;
				} else {
					this._topSideBar.visible = false;
				}
				
				
				
				if(!PlayerConfig.isSohuDomain) {
					if(stage.displayState == "fullScreen") {
						this._titleText.visible = this._topPerSp.visible = true;
						if(!(this._displayRate == 0.5) && !(this._displayRate == 0.75) && !(this._displayRate == 1)) {
							this._topPer50_btn.enabled = this._topPer75_btn.enabled = this._topPer100_btn.enabled = true;
						}
						if(this._searchBar != null) {
							this._searchBar.visible = false;
						}
					} else {
						this._titleText.visible = this._topPerSp.visible = false;
						if(this._searchBar != null) {
							this._searchBar.visible = true;
						}
					}
				}
				if(this._topPerSp != null) {
					if(!(this._displayRate == 0.5) && !(this._displayRate == 0.75) && !(this._displayRate == 1)) {
						this._topPer50_btn.enabled = this._topPer75_btn.enabled = this._topPer100_btn.enabled = true;
					} else if(this._displayRate == 0.5) {
						this._topPer50_btn.enabled = false;
						this._topPer100_btn.enabled = this._topPer75_btn.enabled = true;
					} else if(this._displayRate == 0.75) {
						this._topPer75_btn.enabled = false;
						this._topPer50_btn.enabled = this._topPer100_btn.enabled = true;
					} else if(this._displayRate == 1) {
						this._topPer100_btn.enabled = false;
						this._topPer50_btn.enabled = this._topPer75_btn.enabled = true;
					} else {
						this._topPer50_btn.enabled = this._topPer75_btn.enabled = this._topPer100_btn.enabled = true;
					}
					
					
					
				}
				this.setTitle();
				this.setChildIndex(_ctrlBar_c,this.numChildren - 1);
			}
			if(this._danmu != null) {
				this._danmu.x = this._danmu.y = 0;
			}
			if(!(_skin == null) && (TvSohuAds.getInstance().startAd.state == "playing" || TvSohuAds.getInstance().endAd.state == "playing" || TvSohuAds.getInstance().middleAd.state == "playing")) {
				_progress_sld["isAdMode"] = true;
				_progress_sld.enabled = false;
				_play_btn.enabled = false;
				_pause_btn.enabled = false;
				_tipDisplay.visible = false;
				this._lightBar.enabled = false;
				this._definitionBar.enabled = false;
				this._langSetBar.enabled = false;
				this._albumBtn.enabled = this._albumBtn.visible = false;
				this._next_btn.enabled = false;
				this._barrageBtn.enabled = false;
				_startPlay_btn.visible = false;
				this._oriSongBtn.enabled = this._vocSongBtn.enabled = false;
			}
			if(this._mofunengPanel != null) {
				this._mofunengPanel.resize(_core.width,_core.height);
			}
			if(this._licenseText != null) {
				_loc4_ = _core.videoContainer.width;
				_loc5_ = _core.videoContainer.height;
				this._licenseText.x = _core.videoContainer.x + _loc4_ - this._licenseText.width - 10;
				this._licenseText.y = _core.videoContainer.y + _loc5_ - this._licenseText.height - 10;
			}
		}
		
		public function get preLoadPanel() : * {
			return this._preLoadPanel;
		}
		
		public function get videoInfoPanel() : VideoInfoPanel {
			return this._videoInfoPanel;
		}
		
		public function get isJumpEndCaption() : Boolean {
			return this._isJumpEndCaption;
		}
		
		public function get isJumpStartCaption() : Boolean {
			return this._isJumpStartCaption;
		}
		
		public function get isShownPauseAd() : Boolean {
			return this._isShownPauseAd;
		}
		
		public function get isViewTimer() : Boolean {
			return this._isViewTimer;
		}
		
		public function set isJumpEndCaption(param1:Boolean) : void {
			this._isJumpEndCaption = param1;
		}
		
		public function set isSwitchVideos(param1:Boolean) : void {
			this._isSwitchVideos = param1;
		}
		
		public function set isViewTimer(param1:Boolean) : void {
			this._isViewTimer = param1;
			if(this._timer_c != null) {
				this._timer_c.visible = (this._isViewTimer) && stage.displayState == "fullScreen" && !TvSohuAds.getInstance().topLogoAd.hasAd && !(TvSohuAds.getInstance().startAd.hasAd && TvSohuAds.getInstance().startAd.state == "playing");
			}
		}
		
		public function set isJumpStartCaption(param1:Boolean) : void {
			this._isJumpStartCaption = param1;
		}
		
		override protected function registerUi() : void {
			super.registerUi();
			register("shareBtn",{
				"e":false,
				"v":true
			});
			register("miniWinBtn",{
				"e":false,
				"v":true
			});
			register("tvSohuLogoBtn",{
				"e":true,
				"v":true
			});
			register("ctrlBarAd",{
				"e":true,
				"v":true
			});
			register("replayBtn",{
				"e":false,
				"v":false
			});
			register("nextBtn",{
				"e":false,
				"v":(PlayerConfig.playListId == ""?false:true)
			});
			register("definitionBar",{
				"e":false,
				"v":true
			});
			register("langSetBar",{
				"e":false,
				"v":PlayerConfig.showLangSetBtn
			});
			register("albumBtn",{
				"e":false,
				"v":false
			});
			register("barrageBtn",{
				"e":false,
				"v":PlayerConfig.isShowTanmu && !PlayerConfig.isSohuDomain
			});
			register("oriSongBtn",{
				"e":false,
				"v":PlayerConfig.isKTVVideo
			});
			register("vocSongBtn",{
				"e":false,
				"v":PlayerConfig.isKTVVideo
			});
			_skinMap.getValue("volumeBar").e = true;
			_skinMap.getValue("volumeBar").v = true;
		}
		
		override protected function drawSkin() : void {
			var vSkins_obj:Object = null;
			var j:* = undefined;
			var cap:Array = null;
			var sc:String = null;
			var nc:String = null;
			var ec:String = null;
			var cec:String = null;
			var w:uint = 0;
			var arr:Array = _skinMap.keys();
			var i:uint = 0;
			while(i < arr.length) {
				for(j in _skin.status[arr[i]]) {
					_skinMap.getValue(arr[i])[j] = _skin.status[arr[i]][j];
				}
				i++;
			}
			_ctrlBarBg_spr = _skin["ctrlBg_mc"];
			_ctrlBarBg_spr.x = 0;
			_ctrlBarBg_spr.y = 0;
			_hitArea_spr = new Sprite();
			Utils.drawRect(_hitArea_spr,0,0,_width,_height,0,1);
			_hitArea_spr.alpha = 0;
			_hitArea_spr.doubleClickEnabled = true;
			_hitArea_spr.buttonMode = _hitArea_spr.useHandCursor = true;
			_play_btn = new ButtonUtil({
				"skin":_skin["play_btn"],
				"showTip":true
			});
			_startPlay_btn = new ButtonUtil({"skin":_skin["startPlay_btn"]});
			_pause_btn = new ButtonUtil({
				"skin":_skin["pause_btn"],
				"showTip":true
			});
			this._replay_btn = new ButtonUtil({
				"skin":_skin["replay_btn"],
				"showTip":true
			});
			_fullScreen_btn = new ButtonUtil({
				"skin":_skin["fullScreen_btn"],
				"showTip":true
			});
			_normalScreen_btn = new ButtonUtil({
				"skin":_skin["normalScreen_btn"],
				"showTip":true
			});
			this._normalScreen3_btn = new ButtonUtil({"skin":_skin["normalScreen3_btn"]});
			this._topPer50_btn = new ButtonUtil({"skin":_skin["topPer50"]});
			this._topPer75_btn = new ButtonUtil({"skin":_skin["topPer75"]});
			this._topPer100_btn = new ButtonUtil({"skin":_skin["topPer100"]});
			this._tvSohuLogo_btn = PlayerConfig.channel == "s"?new ButtonUtil({
				"skin":_skin["sportsLogo_btn"],
				"showTip":true
			}):PlayerConfig.isNewsLogo?new ButtonUtil({
				"skin":_skin["tvSohuNewLogo_btn"],
				"showTip":true
			}):new ButtonUtil({
				"skin":_skin["tvSohuLogo_btn"],
				"showTip":true
			});
			_timeDisplay = _skin["time_mc"];
			_tipDisplay = _skin["status_mc"];
			var dollop_btn:ButtonUtil = new ButtonUtil({"skin":_skin["pro_btn"]});
			var forward_btn:ButtonUtil = new ButtonUtil({"skin":_skin["forward_btn"]});
			var back_btn:ButtonUtil = new ButtonUtil({"skin":_skin["back_btn"]});
			var dotClass:Class = _skinLoaderInfo.applicationDomain.getDefinition("Dot") as Class;
			var sSkins_obj:Object = {
				"top":_skin["proTop_mc"],
				"middle":_skin["proMiddle_mc"],
				"bottom":_skin["proBottom_mc"],
				"previewTip":_skin["previewTip_mc"],
				"previewTip2":_skin["previewTip2_mc"],
				"forwardBtn":forward_btn,
				"backBtn":back_btn,
				"dollop":dollop_btn,
				"dotClass":dotClass,
				"commonPPBg":_skin["commonPPBg_mc"],
				"newPreviewTip":_skin["newPreview_mc"],
				"multiImgPreview":_skin["multiImgPreview_mc"],
				"line":_skin["line"]
			};
			_progress_sld = new TvSohuSliderPreview({
				"skin":sSkins_obj,
				"isDrag":_isDrag
			});
			if(PlayerConfig.isLive) {
				_progress_sld.height = 0;
			}
			var muteVol_btn:ButtonUtil = new ButtonUtil({"skin":_skin["muteVol_btn"]});
			var comebackVol_btn:ButtonUtil = new ButtonUtil({"skin":_skin["comebackVol_btn"]});
			var dollopVol_btn:ButtonUtil = new ButtonUtil({"skin":_skin["dollopVol_btn"]});
			var addVol_btn:ButtonUtil = new ButtonUtil({"skin":_skin["addVol_btn"]});
			var subVol_btn:ButtonUtil = new ButtonUtil({"skin":_skin["subVol_btn"]});
			vSkins_obj = {
				"top":_skin["volTop_mc"],
				"middle":_skin["volMiddle_mc"],
				"bottom":_skin["volBottom_mc"],
				"dollop":dollopVol_btn,
				"muteBtn":muteVol_btn,
				"comebackBtn":comebackVol_btn,
				"bgMc":_skin["volBg_mc"],
				"volContinueTipMc":_skin["volContinueTip_mc"],
				"forwardBtn":addVol_btn,
				"backBtn":subVol_btn,
				"volMc":_skin["vol_mc"]
			};
			_volume_sld = new TvSohuVolumeBar({
				"skin":vSkins_obj,
				"isDrag":true,
				"isVertical":_skinMap.getValue("volumeBar").isVertical,
				"sliderY":_skinMap.getValue("volumeBar").y
			});
			this._lightBar = new ButtonUtil({
				"skin":_skin["light_btn"],
				"showTip":true
			});
			var multiBtnSkinArr:Array = [_skin["h2644k_btn"],_skin["original_btn"],_skin["super_btn"],_skin["hd_btn"],_skin["common_btn"]];
			this._definitionBar = new TvSohuMultiButton({"arrSkin":multiBtnSkinArr});
			this._definitionSlider = new DefinitionSettingPanel({"skin":_skin["definition_slider"]});
			this._langSetBar = new TvSohuButton({"skin":_skin["langSet_btn"]});
			this._albumBtn = new TvSohuMultiButton({"arrSkin":[_skin["album_btn"],_skin["next_btn2"]]});
			this._barrageBtn = new TvSohuButton({
				"skin":_skin["barrage_btn"],
				"showTip":false
			});
			this._oriSongBtn = new TvSohuButton({
				"skin":_skin["oriSong_btn"],
				"showTip":true
			});
			this._vocSongBtn = new TvSohuButton({
				"skin":_skin["vocSong_btn"],
				"showTip":true
			});
			_ctrlBar_c = new Sprite();
			this._ctrlBtn_sp = new Sprite();
			TvSohuAds.getInstance().endAd.detailClass = TvSohuAds.getInstance().startAd.detailClass = _skinLoaderInfo.applicationDomain.getDefinition("DetailBtn") as Class;
			if(!(PlayerConfig.cap == null) && PlayerConfig.cap.length > 0) {
				cap = PlayerConfig.cap;
				sc = "";
				nc = "";
				ec = "";
				cec = "";
				w = 0;
				while(w < cap.length) {
					if(cap[w].ver == "1") {
						sc = cap[w].cpath;
					} else if(cap[w].ver == "2") {
						nc = cap[w].cpath;
					} else if(cap[w].ver == "3") {
						ec = cap[w].cpath;
					} else if(cap[w].ver == "4") {
						cec = cap[w].cpath;
					}
					
					
					
					w++;
				}
				this._captionBar = new CaptionBar(sc,nc,ec,cec);
				if(PlayerConfig.hcap == "0") {
					this._captionBar.captionVer = cap[0].ver;
				}
			}
			this.setLicense();
			addChild(_hitArea_spr);
			if(this._captionBar != null) {
				addChild(this._captionBar);
			}
			_ctrlBar_c.addChild(_ctrlBarBg_spr);
			this._tipHistory = new TipHistory(_skin["tipHistoryPanel"]);
			this._tipHistory.x = 0;
			this._tipHistory.y = _progress_sld.y - _progress_sld.height - this._tipHistory.height + 1;
			_ctrlBar_c.addChild(this._tipHistory);
			_ctrlBar_c.addChild(_progress_sld);
			_ctrlBar_c.addChild(this._ctrlBtn_sp);
			this._ctrlBtn_sp.addChild(this._tvSohuLogo_btn);
			this._ctrlBtn_sp.addChild(this._replay_btn);
			this._ctrlBtn_sp.addChild(_pause_btn);
			this._ctrlBtn_sp.addChild(_play_btn);
			this._ctrlBtn_sp.addChild(_normalScreen_btn);
			this._ctrlBtn_sp.addChild(_fullScreen_btn);
			this._ctrlBtn_sp.addChild(this._langSetBar);
			this._ctrlBtn_sp.addChild(this._definitionBar);
			this._ctrlBtn_sp.addChild(this._lightBar);
			this._ctrlBtn_sp.addChild(this._definitionSlider);
			this._ctrlBtn_sp.addChild(_volume_sld);
			this._ctrlBtn_sp.addChild(this._barrageBtn);
			this._ctrlBtn_sp.addChild(this._albumBtn);
			this._ctrlBtn_sp.addChild(this._vocSongBtn);
			this._ctrlBtn_sp.addChild(this._oriSongBtn);
			this._ctrlBtn_sp.addChild(_timeDisplay);
			if(_skinMap.getValue("startPlayBtn").align == "center") {
				addChild(_startPlay_btn);
			} else {
				_ctrlBar_c.addChild(_startPlay_btn);
			}
			addChild(_ctrlBar_c);
			this._definitionSlider.visible = false;
			_ctrlBar_c.addChild(this._ctrlAdContainer);
			_ctrlBar_c.addChild(this._bottomAdContainer);
			_ctrlBar_c.addChildAt(this._bottomAdContainer,0);
			_ctrlBar_c.addChildAt(this._sogouAdContainer,0);
			this._rightSideBar = new Sprite();
			this._share_btn = new ButtonUtil({"skin":_skin["share_btn"]});
			this._download_btn = new ButtonUtil({"skin":_skin["download_btn"]});
			this._miniWin_btn = new ButtonUtil({"skin":_skin["miniWin_btn"]});
			this._sogou_btn = new ButtonUtil({"skin":_skin["sogou_btn"]});
			this._turnOnWider_btn = new ButtonUtil({"skin":_skin["turnOnWider_btn"]});
			this._turnOffWider_btn = new ButtonUtil({"skin":_skin["turnOffWider_btn"]});
			this._next_btn = new ButtonUtil({"skin":_skin["next_btn"]});
			this._caption_btn = new ButtonUtil({"skin":_skin["caption_btn"]});
			this._rightBarBg = _skin["rightBarBg_mc"];
			this._rightBarBg.x = this._rightBarBg.y = 0;
			this._rightSideBar.addChild(this._rightBarBg);
			this._rightSideBar.addChild(this._share_btn);
			this._rightSideBar.addChild(this._download_btn);
			this._rightSideBar.addChild(this._miniWin_btn);
			this._rightSideBar.addChild(this._sogou_btn);
			this._rightSideBar.addChild(this._caption_btn);
			this._rightSideBar.addChild(this._turnOnWider_btn);
			this._rightSideBar.addChild(this._turnOffWider_btn);
			this._topSideBar = new Sprite();
			this._topSideBarBg = new Sprite();
			this._topPerSp = new Sprite();
			Utils.drawRect(this._topSideBarBg,0,0,_width,34,0,0.7);
			addChild(this._rightSideBar);
			this._ctrlBtn_sp.addChild(this._next_btn);
			this._ctrlShow = new Bitmap();
			_ctrlBar_c.addChild(this._ctrlShow);
			this._transition_mc = _skin["transition_mc"];
			this._transition_mc.visible = false;
			addChild(this._transition_mc);
			var t:ButtonUtil = null;
			this._share_btn.x = this._download_btn.x = this._miniWin_btn.x = this._sogou_btn.x = this._turnOnWider_btn.x = this._turnOffWider_btn.x = 0;
			this._share_btn.y = t != null?t.y + t.height:0;
			this._share_btn.visible = PlayerConfig.showShareBtn;
			if(PlayerConfig.showShareBtn) {
				t = this._share_btn;
			}
			this._turnOnWider_btn.y = this._turnOffWider_btn.y = t != null?t.y + t.height:0;
			this._turnOnWider_btn.visible = PlayerConfig.showWiderBtn;
			this._turnOffWider_btn.visible = false;
			if(PlayerConfig.showWiderBtn) {
				t = this._turnOnWider_btn;
			}
			this._miniWin_btn.y = t != null?t.y + t.height:0;
			this._miniWin_btn.visible = PlayerConfig.showMiniWinBtn;
			if(PlayerConfig.showMiniWinBtn) {
				t = this._miniWin_btn;
			}
			this._caption_btn.y = t != null?t.y + t.height:0;
			this._caption_btn.visible = !(PlayerConfig.cap == null) && PlayerConfig.cap.length > 0 && !(PlayerConfig.cap.length == 1 && PlayerConfig.cap[0].ver == PlayerConfig.hcap);
			if(this._caption_btn.visible) {
				t = this._caption_btn;
			}
			this._download_btn.y = t != null?t.y + t.height:0;
			this._download_btn.visible = false;
			if(!PlayerConfig.isFms && !PlayerConfig.isCounterfeitFms && (PlayerConfig.idDownload)) {
				if(PlayerConfig.showDownloadBtn) {
					this._download_btn.visible = true;
					t = this._download_btn;
				}
				if(Eif.available) {
					ExternalInterface.call("showDownload");
				}
			}
			this._sogou_btn.y = t != null?t.y + t.height:0;
			var re:RegExp = new RegExp("SE \\d+\\.X","g");
			if((Eif.available) && (PlayerConfig.showSogouBtn)) {
				this._sogou_btn.visible = true;
			} else {
				this._sogou_btn.visible = false;
			}
			this._rightBarBg.height = this._rightSideBar.height - (!this._sogou_btn.visible?this._sogou_btn.height:0);
			this._rightBarBg.visible = this._rightBarBg.height < this._sogou_btn.height?false:true;
			this._rightSideBar.x = _hitArea_spr.width - this._rightSideBar.width;
			this._titleText = new TextField();
			this._titleText.autoSize = TextFieldAutoSize.LEFT;
			this._topSideBar.addChild(this._topSideBarBg);
			this._topSideBar.addChild(this._titleText);
			this._titleText.x = 3;
			this._titleText.y = 8;
			var _lableText:TextField = new TextField();
			_lableText.autoSize = TextFieldAutoSize.LEFT;
			var fat2:TextFormat = new TextFormat();
			fat2.size = 14;
			fat2.color = 15132390;
			_lableText.text = "画面尺寸";
			_lableText.setTextFormat(fat2);
			this._topPerSp.addChild(_lableText);
			this._topPerSp.addChild(this._topPer50_btn);
			this._topPerSp.addChild(this._topPer75_btn);
			this._topPerSp.addChild(this._topPer100_btn);
			_lableText.width = 100;
			_lableText.height = 20;
			_lableText.x = 0;
			_lableText.y = 1;
			this._topPer50_btn.x = _lableText.x + _lableText.width + 10;
			this._topPer75_btn.x = this._topPer50_btn.x + this._topPer50_btn.width + 20;
			this._topPer100_btn.x = this._topPer75_btn.x + this._topPer75_btn.width + 20;
			this._topPer50_btn.y = this._topPer75_btn.y = this._topPer100_btn.y = 4;
			this._topPer100_btn.enabled = false;
			this._topSideBar.addChild(this._topPerSp);
			this.setTitle();
			if(!PlayerConfig.isSohuDomain) {
				new LoaderUtil().load(20,function(param1:Object):void {
					if(param1.info == "success") {
						_searchBar = param1.data.content;
						_searchBar.init(_topSideBarBg.width,PlayerConfig);
						_searchBar.x = _searchBar.y = 0;
						_searchBar.addEventListener(PanelEvent.OPEN_LIKE_PANEL,showLike);
						_topSideBar.addChild(_searchBar);
					} else {
						_titleText.visible = true;
					}
				},null,PlayerConfig.swfHost + "panel/SearchAndShareForTop.swf");
			}
			this._topSideBar.addChild(this._normalScreen3_btn);
			addChild(_tipDisplay);
			addChild(this._topSideBar);
			this._retryPanel = new RetryPanel(_skin["retryPanel"]);
			this._videoInfoPanel = new VideoInfoPanel(_skin["videoInfoPanel"],this);
			this._videoInfoPanel.close(0);
			this._retryPanel.close();
			addChild(this._retryPanel);
			addChild(this._videoInfoPanel);
			this._timer_c = new Sprite();
			addChild(this._timer_c);
			this._panelArr.push(this._videoInfoPanel);
			this.setChildIndex(this._adContainer,this.numChildren - 1);
			this.setChildIndex(_ctrlBar_c,this.numChildren - 1);
			this.setChildIndex(this._transition_mc,this.getChildIndex(this._adContainer) - 1);
			if(PlayerConfig.domainProperty == "2" || !PlayerConfig.isSohuDomain) {
				_skinMap.getValue("volumeBar").x = _skinMap.getValue("volumeBar").x - this._tvSohuLogo_btn.width;
				_skinMap.getValue("volumeBar").w = _skinMap.getValue("volumeBar").w + this._tvSohuLogo_btn.width;
				_skinMap.getValue("lightBar").x = _skinMap.getValue("lightBar").x - this._tvSohuLogo_btn.width;
				_skinMap.getValue("lightBar").w = _skinMap.getValue("lightBar").w + this._tvSohuLogo_btn.width;
				_skinMap.getValue("definitionBar").x = _skinMap.getValue("definitionBar").x - this._tvSohuLogo_btn.width;
				_skinMap.getValue("definitionBar").w = _skinMap.getValue("definitionBar").w + this._tvSohuLogo_btn.width;
				_skinMap.getValue("langSetBar").x = _skinMap.getValue("langSetBar").x - this._tvSohuLogo_btn.width;
				_skinMap.getValue("langSetBar").w = _skinMap.getValue("langSetBar").w + this._tvSohuLogo_btn.width;
				_skinMap.getValue("fullScreenBtn").x = _skinMap.getValue("fullScreenBtn").x - this._tvSohuLogo_btn.width;
				_skinMap.getValue("fullScreenBtn").w = _skinMap.getValue("fullScreenBtn").w + this._tvSohuLogo_btn.width;
				_skinMap.getValue("normalScreenBtn").x = _skinMap.getValue("normalScreenBtn").x - this._tvSohuLogo_btn.width;
				_skinMap.getValue("normalScreenBtn").w = _skinMap.getValue("normalScreenBtn").w + this._tvSohuLogo_btn.width;
				_skinMap.getValue("albumBtn").w = _skinMap.getValue("albumBtn").w + this._tvSohuLogo_btn.width;
				_skinMap.getValue("timeDisplay").w = _skinMap.getValue("timeDisplay").w + this._tvSohuLogo_btn.width;
				_skinMap.getValue("barrageBtn").x = _skinMap.getValue("barrageBtn").x - this._tvSohuLogo_btn.width;
				_skinMap.getValue("barrageBtn").w = _skinMap.getValue("barrageBtn").w + this._tvSohuLogo_btn.width;
				_skinMap.getValue("oriSongBtn").x = _skinMap.getValue("oriSongBtn").x - this._tvSohuLogo_btn.width;
				_skinMap.getValue("oriSongBtn").w = _skinMap.getValue("oriSongBtn").w + this._tvSohuLogo_btn.width;
				_skinMap.getValue("vocSongBtn").x = _skinMap.getValue("vocSongBtn").x - this._tvSohuLogo_btn.width;
				_skinMap.getValue("vocSongBtn").w = _skinMap.getValue("vocSongBtn").w + this._tvSohuLogo_btn.width;
			} else if((PlayerConfig.isNewsLogo) || PlayerConfig.channel == "s") {
				_skinMap.getValue("volumeBar").x = _skinMap.getValue("volumeBar").x - this._tvSohuLogo_btn.width;
				_skinMap.getValue("volumeBar").w = _skinMap.getValue("volumeBar").w + this._tvSohuLogo_btn.width;
				_skinMap.getValue("lightBar").x = _skinMap.getValue("lightBar").x - this._tvSohuLogo_btn.width;
				_skinMap.getValue("lightBar").w = _skinMap.getValue("lightBar").w + this._tvSohuLogo_btn.width;
				_skinMap.getValue("definitionBar").x = _skinMap.getValue("definitionBar").x - this._tvSohuLogo_btn.width;
				_skinMap.getValue("definitionBar").w = _skinMap.getValue("definitionBar").w + this._tvSohuLogo_btn.width;
				_skinMap.getValue("langSetBar").x = _skinMap.getValue("langSetBar").x - this._tvSohuLogo_btn.width;
				_skinMap.getValue("langSetBar").w = _skinMap.getValue("langSetBar").w + this._tvSohuLogo_btn.width;
				_skinMap.getValue("fullScreenBtn").x = _skinMap.getValue("fullScreenBtn").x - this._tvSohuLogo_btn.width;
				_skinMap.getValue("fullScreenBtn").w = _skinMap.getValue("fullScreenBtn").w + this._tvSohuLogo_btn.width;
				_skinMap.getValue("normalScreenBtn").x = _skinMap.getValue("normalScreenBtn").x - this._tvSohuLogo_btn.width;
				_skinMap.getValue("normalScreenBtn").w = _skinMap.getValue("normalScreenBtn").w + this._tvSohuLogo_btn.width;
				_skinMap.getValue("albumBtn").w = _skinMap.getValue("albumBtn").w + this._tvSohuLogo_btn.width;
				_skinMap.getValue("timeDisplay").w = _skinMap.getValue("timeDisplay").w + this._tvSohuLogo_btn.width;
				_skinMap.getValue("barrageBtn").x = _skinMap.getValue("barrageBtn").x - this._tvSohuLogo_btn.width;
				_skinMap.getValue("barrageBtn").w = _skinMap.getValue("barrageBtn").w + this._tvSohuLogo_btn.width;
				_skinMap.getValue("oriSongBtn").x = _skinMap.getValue("oriSongBtn").x - this._tvSohuLogo_btn.width;
				_skinMap.getValue("oriSongBtn").w = _skinMap.getValue("oriSongBtn").w + this._tvSohuLogo_btn.width;
				_skinMap.getValue("vocSongBtn").x = _skinMap.getValue("vocSongBtn").x - this._tvSohuLogo_btn.width;
				_skinMap.getValue("vocSongBtn").w = _skinMap.getValue("vocSongBtn").w + this._tvSohuLogo_btn.width;
			} else {
				_skinMap.getValue("tvSohuLogoBtn").v = false;
			}
			
			if(!((PlayerConfig.isShowTanmu) && !PlayerConfig.isSohuDomain)) {
				_skinMap.getValue("albumBtn").w = _skinMap.getValue("albumBtn").w - this._barrageBtn.width;
			}
			this.resize(_width,_height);
		}
		
		public function closePanel() : void {
			var _loc1_:uint = 0;
			if(!(this._panelArr == null) && this._panelArr.length > 0) {
				while(_loc1_ < this._panelArr.length) {
					this._panelArr[_loc1_].close();
					_loc1_++;
				}
			}
		}
		
		public function get sharePanel2() : * {
			return this._sharePanel;
		}
		
		public function get lightRate() : Number {
			return this._lightRate;
		}
		
		public function get contrastRate() : Number {
			return this._contrastRate;
		}
		
		public function get saturationRate() : Number {
			return this._saturationRate;
		}
		
		override protected function loadSkin(param1:String = "") : void {
			var _hitArea:Sprite = null;
			var url:String = param1;
			if(PlayerConfig.skinNum != "-1") {
				super.loadSkin(url);
			} else if(stage.loaderInfo.parameters["os"] == "android") {
				new LoaderUtil().load(10,function(param1:Object):void {
					var android:* = undefined;
					var obj:Object = param1;
					if(obj.info == "success") {
						android = obj.data.content;
						addChildAt(android,0);
						android.hardInit({
							"width":stage.stageWidth,
							"height":stage.stageHeight,
							"c":_core,
							"isHide":true,
							"hardInitHandler":function(param1:Object):void {
							},
							"skinPath":""
						});
					}
					_hardInitHandler({"info":"success"});
				},null,PlayerConfig.swfHost + "other/android.swf");
			} else {
				_hardInitHandler({"info":"success"});
				_core.addEventListener(MediaEvent.PLAY_PROGRESS,this.noSkinPlayProgress);
				_hitArea = new Sprite();
				Utils.drawRect(_hitArea,0,0,_width,_height,0,1);
				_hitArea.alpha = 0;
				addChild(_hitArea);
			}
			
		}
		
		override protected function skinHandler(param1:Object) : void {
			var _loc2_:String = null;
			PlayerConfig.skinLoadTime = PlayerConfig.skinLoadTime + param1.target.spend;
			super.skinHandler(param1);
			if(param1.info == "success") {
				if((TvSohuAds.getInstance().startAd.hasAd) && TvSohuAds.getInstance().startAd.state == "playing") {
				}
				if(TvSohuAds.getInstance().ctrlBarAd.hasAd) {
					TvSohuAds.getInstance().ctrlBarAd.play();
				} else {
					TvSohuAds.getInstance().ctrlBarAd.pingback();
				}
				this.setAdsState();
				this.startSideTween();
				dispatchEvent(new Event("skinLoadSuccess"));
			} else if(this._loadSkinRetryNum > 0) {
				this._loadSkinRetryNum--;
				_loc2_ = _skinPath;
				_skinPath = "";
				this.loadSkin(_loc2_ + "?t=" + Math.random());
			} else {
				ErrorSenderPQ.getInstance().sendPQStat({
					"error":1,
					"allno":0,
					"code":PlayerConfig.SKIN_CODE,
					"utime":0,
					"dom":_skinPath
				});
				_hardInitHandler({"info":"success"});
			}
			
		}
		
		override protected function onStart(param1:Event = null) : void {
			var _loc3_:String = null;
			if((Eif.available) && (PlayerConfig.hasApi) && !this._isFbChecked) {
				this._isFbChecked = true;
				_loc3_ = ExternalInterface.call("playStart");
				PlayerConfig.isBrowserFullScreen = _loc3_ == "1"?true:false;
			}
			var _loc2_:Boolean = PlayerConfig.isBrowserFullScreen;
			_skinMap.getValue("miniWinBtn").e = _skinMap.getValue("miniWinBtn").v = PlayerConfig.showMiniWinBtn;
			_skinMap.getValue("lightBar").e = _skinMap.getValue("lightBar").v = true;
			_skinMap.getValue("definitionBar").e = _skinMap.getValue("definitionBar").v = true;
			_skinMap.getValue("langSetBar").e = _skinMap.getValue("langSetBar").v = PlayerConfig.showLangSetBtn;
			_skinMap.getValue("albumBtn").e = _skinMap.getValue("albumBtn").v = false;
			_skinMap.getValue("barrageBtn").e = _skinMap.getValue("barrageBtn").v = PlayerConfig.isShowTanmu && !PlayerConfig.isSohuDomain;
			_skinMap.getValue("oriSongBtn").e = _skinMap.getValue("oriSongBtn").v = PlayerConfig.isKTVVideo;
			_skinMap.getValue("vocSongBtn").e = _skinMap.getValue("vocSongBtn").v = PlayerConfig.isKTVVideo;
			_skinMap.getValue("fullScreenBtn").v = _skinMap.getValue("fullScreenBtn").e = stage.displayState == "fullScreen"?false:true;
			_skinMap.getValue("normalScreenBtn").v = _skinMap.getValue("normalScreenBtn").e = stage.displayState == "fullScreen"?true:false;
			super.onStart();
			_skinMap.getValue("replayBtn").e = true;
		}
		
		override protected function bufferEmpty(param1:Event) : void {
			var _loc2_:* = NaN;
			_loc2_ = _core.filePlayedTime;
			if(this._bfTotNum.length <= 0) {
				this._bfTotNum.push(0);
			}
			if(Eif.available) {
				ExternalInterface.call("flv_playerEvent","onbuffering");
			}
			if(Math.abs(_loc2_ - this._bfTotNum[this._bfTotNum.length - 1]) >= _core.ns.bufferTime) {
				super.bufferEmpty(param1);
				this.mediaConnecting({});
				if(!PlayerConfig.isLive && !this._isPreLoadPanel && !PlayerConfig.isFms) {
					this._bfTotNum.push(_loc2_);
					if(this._bfTotNum.length == 3 && !_core.lastoutBuffer && !(_skin == null)) {
						if(!P2PExplorer.getInstance().hasP2P) {
							if(PlayerConfig.isp == "2" && PlayerConfig.area == "40" && !(Utils.getBrowserCookie("fee_channel") == "3")) {
								this._tipHistory.showNewAddSpeedTip();
							} else {
								this._tipHistory.showAddSpeedTip();
							}
							this.resetBuffNum();
						}
						ErrorSenderPQ.getInstance().sendPQStat({"code":PlayerConfig.PRELOAD_SHOWN_CODE});
					}
					if(!this._resetTimeLimit.running) {
						this._resetTimeLimit.start();
					}
				} else if(PlayerConfig.autoFix == "1") {
					if(this._bfTotNum.length >= 2 && (this._isPreLoadPanel) && (PlayerConfig.isHd) && !(PlayerConfig.relativeId == "") && !(_skin == null) && !this._tipHistory.isShowHdToCommonTip) {
						this.resetBuffNum();
					} else if(this._bfTotNum.length < 2) {
						this._bfTotNum.push(_loc2_);
					}
					
				} else {
					this.resetBuffNum();
				}
				
			}
			if(!PlayerConfig.isFms && !PlayerConfig.isCounterfeitFms && !PlayerConfig.isLive && (PlayerConfig.showIFoxBar) && (TvSohuAds.getInstance().sogouAd.hasAd) && TvSohuAds.getInstance().sogouAd.state == "no" && !TvSohuAds.getInstance().bottomAd.isShow && stage.stageHeight > 300) {
				TvSohuAds.getInstance().sogouAd.play();
			}
		}
		
		override protected function onStop(param1:* = "") : void {
			var _loc2_:Object = null;
			super.onStop(param1);
			_skinMap.getValue("playBtn").e = false;
			_skinMap.getValue("barrageBtn").e = _skinMap.getValue("langSetBar").e = false;
			_skinMap.getValue("definitionBar").e = _skinMap.getValue("lightBar").e = false;
			_skinMap.getValue("oriSongBtn").e = _skinMap.getValue("vocSongBtn").e = false;
			_skinMap.getValue("startPlayBtn").v = false;
			if(_skin != null) {
				this._tipHistory.close();
			}
			if(this._hisRecommend != null) {
				_ctrlBar_c.removeChild(this._hisRecommend);
				this._hisRecommend = null;
			}
			PlayerConfig.otherInforSender = "";
			_loc2_ = {
				"totalRAM":System.totalMemory,
				"idleRAMPer":Math.round(System.freeMemory / System.totalMemory),
				"playerRAMPer":Math.round(System.privateMemory / System.totalMemory)
			};
			InforSender.getInstance().sendMesg(InforSender.END,PlayerConfig.viewTime,"","","http://pb.hd.sohu.com.cn/hdpb.gif",0,_loc2_);
			InforSender.getInstance().sendIRS("end");
			this.stopDanmu();
		}
		
		private function stopDanmu() : void {
			if(this._danmu != null) {
				if(this._danmu.hasEventListener("__onTmDataGet")) {
					this._danmu.removeEventListener("__onTmDataGet",this.onTmDataComplete);
					this._danmu.removeEventListener("__onTmDataErr",this.onTmDataFailHandler);
					this._danmu.removeEventListener("__onTmNoData",this.onTmDataFailHandler);
					this._danmu.removeEventListener("__onTmDataFailed",this.onTmDataFailHandler);
				}
				this._danmu.stop();
				this._danmu.dispose();
				removeChild(this._danmu);
				this._danmu = null;
			}
		}
		
		public function readyReplay() : void {
			_skinMap.getValue("playBtn").v = _skinMap.getValue("playBtn").e = false;
			_skinMap.getValue("replayBtn").v = _skinMap.getValue("replayBtn").e = true;
			_skinMap.getValue("albumBtn").e = _skinMap.getValue("nextBtn").e = false;
			if(!PlayerConfig.showRecommend) {
				_skinMap.getValue("startPlayBtn").v = true;
			}
			this.setSkinState();
		}
		
		private function resetBuffNum(param1:Event = null) : void {
			this._bfTotNum.splice(0);
			this._resetTimeLimit.stop();
		}
		
		override protected function bufferFull(param1:Event) : void {
			super.bufferFull(param1);
			if(_skin != null) {
				clearInterval(this._showBufferRate);
				this._transition_mc.visible = false;
				if(this._retryPanel.isOpen) {
					this._retryPanel.close();
				}
			}
			if(Eif.available) {
				ExternalInterface.call("flv_playerEvent","onplaying");
			}
		}
		
		public function replay(param1:* = null) : void {
			var evt:* = param1;
			if(this._saveIsHide) {
				PlayerConfig.isHide = _isHide = this._saveIsHide;
			}
			this.resize(stage.stageWidth,stage.stageHeight);
			_core.play();
			LogManager.msg("重新播放");
			if(this._tipHistory != null) {
				this._tipHistory.isShowPayTip = false;
			}
			if((PlayerConfig.isKTVVideo) && !(this._ktvCore == null)) {
				setTimeout(function():void {
					_core.sleep();
					_ktvCore.seek(_core.filePlayedTime);
					_ktvCore.play();
				},500);
			}
			SendRef.getInstance().sendPQDrog("http://click.hd.sohu.com.cn/s.gif?type=fun_yangli205733_PL_C_Repeat&s=" + PlayerConfig.stype + "&_=" + new Date().getTime());
		}
		
		override protected function mediaNotfound(param1:*) : void {
			super.mediaNotfound(param1);
			if(_skin != null) {
				clearInterval(this._showBufferRate);
				this._transition_mc.visible = false;
			}
		}
		
		override protected function mediaConnecting(param1:*) : void {
			var evt:* = param1;
			if(_skin != null) {
				if(!this._isFirstConnect) {
					this._transition_mc.visible = true;
					this._showBufferRate = setInterval(function():void {
						var _loc1_:* = undefined;
						_loc1_ = 0;
						try {
							_loc1_ = _core.ns.bufferLength / _core.ns.bufferTime;
						}
						catch(err:Error) {
						}
						_loc1_ = _loc1_ > 1?1:_loc1_;
						_loc1_ = _loc1_ < 0?0:_loc1_;
						if(_loc1_ <= 0) {
							_transition_mc.loading_txt.visible = false;
						} else {
							_transition_mc.loading_txt.text = Math.round(_loc1_ * 100) + "%";
							_transition_mc.loading_txt.visible = true;
						}
						if(_loc1_ >= 1) {
							_transition_mc.visible = false;
							_transition_mc.loading_txt.text = "";
						}
					},50);
				} else {
					this._isFirstConnect = false;
				}
			}
		}
		
		protected function adPlayProgress(param1:TvSohuAdsEvent) : void {
			if(_skin != null) {
				_progress_sld["isAdMode"] = true;
				_progress_sld.enabled = false;
				_play_btn.enabled = false;
				_pause_btn.enabled = false;
				_tipDisplay.visible = false;
				_startPlay_btn.visible = false;
				this._lightBar.enabled = false;
				this._definitionBar.enabled = false;
				this._langSetBar.enabled = false;
				this._albumBtn.visible = (_skinMap.getValue("albumBtn").v) && _ctrlBarBg_spr.width > _skinMap.getValue("albumBtn").w;
				this._albumBtn.enabled = true;
				this._next_btn.enabled = false;
				this._barrageBtn.visible = _skinMap.getValue("barrageBtn").v;
				this._oriSongBtn.enabled = this._vocSongBtn.enabled = false;
				try {
					_volume_sld.rate = param1.target.volume;
				}
				catch(e:Error) {
				}
				if(TvSohuAds.getInstance().ctrlBarAd.hasAd) {
					TvSohuAds.getInstance().ctrlBarAd.container.visible = param1.target.isExcluded?false:true;
					TvSohuAds.getInstance().ctrlBarAd.container.alpha = param1.target.isExcluded?0:100;
					this.setAdsState();
				}
			}
		}
		
		override protected function ctrlBarBgUp(param1:MouseEvent) : void {
			this.hideDefinitionSideBar();
		}
		
		private function bottomAdShown(param1:TvSohuAdsEvent) : void {
			this._isShownBottomAd = true;
			this.resize(_width,_height);
		}
		
		private function bottomAdHide(param1:TvSohuAdsEvent) : void {
			this._isShownBottomAd = false;
			if(_core.streamState == "pause") {
				_skinMap.getValue("startPlayBtn").v = _skinMap.getValue("startPlayBtn").e = true;
			}
			this.resize(_width,_height);
		}
		
		private function sogouAdShown(param1:TvSohuAdsEvent) : void {
			if(TvSohuAds.getInstance().bottomAd.isShow) {
				TvSohuAds.getInstance().sogouAd.hide();
			}
			this.setAdsState();
		}
		
		private function pauseAdShown(param1:TvSohuAdsEvent) : void {
			this.setAdsState();
		}
		
		private function pauseAdClosed(param1:TvSohuAdsEvent = null) : void {
		}
		
		override protected function newFunc() : void {
			super.newFunc();
			this._rightSideBarTimeout_to = new Timeout(3);
			this._resetTimeLimit = new Timeout(10 * 60);
			this._panelArr = new Array();
			this._filterArr = new Array();
			this._filterArr = new Array(3);
			this._bfTotNum = new Array();
			this._softInitObj = new Object();
		}
		
		protected function progressSlidePreview(param1:SliderEventUtil) : void {
			var _loc2_:* = NaN;
			_loc2_ = param1.obj.rate * _skinMap.getValue("progressBar").totTime;
			var _loc3_:Number = 0;
			param1.target.previewTip = Utils.fomatTime(_loc2_);
			if(!(PlayerConfig.pvpic == null) && (PlayerConfig.isPreviewPic)) {
				this.slidePreviewTime = param1.target.currentTime = Math.floor(_loc2_);
			}
		}
		
		protected function volumeBarPreview(param1:SliderEventUtil) : void {
			this.tipText("音量：" + Math.round(param1.obj.rate * 100) + "%",2);
		}
		
		override protected function playProgress(param1:*) : void {
			/*
			 * Decompilation error
			 * Code may be obfuscated
			 * Deobfuscation is activated but decompilation still failed. If the file is NOT obfuscated, disable "Automatic deobfuscation" for better results.
			 * Error type: ExecutionException
			 */
			throw new flash.errors.IllegalOperationError("Not decompiled due to error");
		}
		
		private function noSkinPlayProgress(param1:*) : void {
			var _loc2_:* = NaN;
			var _loc3_:* = NaN;
			var _loc6_:String = null;
			var _loc7_:* = false;
			_loc2_ = PlayerConfig.playedTime = param1.obj.nowTime;
			_loc3_ = param1.obj.totTime;
			var _loc4_:Number = _loc2_;
			var _loc5_:Number = _loc3_;
			if(!(TvSohuAds.getInstance().startAd.state == "playing") && !(TvSohuAds.getInstance().endAd.state == "playing")) {
				if(Math.abs(Math.round(_loc2_) - this._playedTime1) >= 1) {
					this._playedTime1 = _loc2_;
					PlayerConfig.viewTime++;
					if((PlayerConfig.viewTime == 5 || PlayerConfig.viewTime - this._playedTime60 >= 60) && (!(PlayerConfig.passportMail == "") && (PlayerConfig.isSohuDomain) || !PlayerConfig.isSohuDomain) && !PlayerConfig.isLive) {
						this._playedTime60 = PlayerConfig.viewTime;
						_loc6_ = PlayerConfig.xuid != ""?"&xuid=" + PlayerConfig.xuid:"";
						_loc7_ = !(InforSender.getInstance().ifltype == "") && !PlayerConfig.isLive && !(PlayerConfig.currentVid == "")?true:false;
						InforSender.getInstance().sendCustomMesg("http://his.tv.sohu.com/his/ping.do?vid=" + (_loc7_?PlayerConfig.currentVid:PlayerConfig.vid) + "&tvid=" + PlayerConfig.tvid + "&sid=" + PlayerConfig.vrsPlayListId + "&uiddd=" + PlayerConfig.passportUID + "&out=" + PlayerConfig.domainProperty + _loc6_ + (!PlayerConfig.isSohuDomain?"&from=20":"") + "&t=" + Math.round(_loc2_) + "&account_time=" + PlayerConfig.viewTime + "&c=1&tt=" + Math.random() + "&ismytv=" + (PlayerConfig.isMyTvVideo?"1":"0") + "&pageurl=" + escape(PlayerConfig.outReferer));
					}
				}
			}
		}
		
		private function sendAndLoadRecomm() : void {
			var videosArr:Array = null;
			var area:String = null;
			this._isLoadRecomm = true;
			videosArr = new Array();
			area = "";
			if((Eif.available) && (ExternalInterface.available)) {
				area = ExternalInterface.call("window.__findAreaText");
			}
			new URLLoaderUtil().load(5,function(param1:Object):void {
				var json:Object = null;
				var obj:Object = param1;
				if(obj.info == "success") {
					json = new JSON().parse(obj.data.replace("var video_podcast_search_result=",""));
					videosArr = json.videos;
					if(!(videosArr == null) && videosArr.length >= 1) {
						new LoaderUtil().load(10,function(param1:Object):void {
							var removeHisRecommend:Function = null;
							var url:String = null;
							var refer:String = null;
							var obj:Object = param1;
							if(obj.info == "success") {
								removeHisRecommend = function(param1:Event):void {
									if(_hisRecommend != null) {
										_ctrlBar_c.removeChild(_hisRecommend);
									}
									_hisRecommend = null;
									_hisRecommObj = {};
									if(param1.type == "clickclose") {
										SendRef.getInstance().sendPQDrog("http://click.hd.sohu.com.cn/s.gif?type=fun_haoli202921_bfqznlb&s=" + PlayerConfig.stype + "&_=" + new Date().getTime());
									}
								};
								_hisRecommend = obj.data.content;
								_hisRecommend.setData({
									"url":videosArr[0].videoUrl,
									"title":videosArr[0].videoName
								});
								_hisRecommend.addEventListener("clickclose",removeHisRecommend);
								_ctrlBar_c.addChild(_hisRecommend);
								_hisRecommObj = videosArr[0];
								SendRef.getInstance().sendPQDrog("http://click.hd.sohu.com.cn/s.gif?type=PL_S_RecommendPlay_v20141106&s=" + PlayerConfig.stype + "&_=" + new Date().getTime());
								url = "";
								refer = "";
								if(!(PlayerConfig.lb == null) && !(PlayerConfig.lb == "") && PlayerConfig.lb == "1") {
									refer = escape(PlayerConfig.lastReferer);
									url = escape(PlayerConfig.filePrimaryReferer);
								} else {
									if((Eif.available) && (ExternalInterface.available)) {
										try {
											refer = escape(ExternalInterface.call("eval","document.referrer"));
										}
										catch(e:Error) {
										}
									}
									url = PlayerConfig.currentPageUrl == ""?escape(PlayerConfig.outReferer):escape(PlayerConfig.currentPageUrl);
								}
								SendRef.getInstance().sendPQDrog("http://ctr.hd.sohu.com/ctr.gif?fuid=" + PlayerConfig.userId + "&yyid=" + PlayerConfig.yyid + "&passport=" + PlayerConfig.passportMail + "&sid=" + PlayerConfig.sid + "&vid=" + PlayerConfig.vid + "&pid=" + PlayerConfig.vrsPlayListId + "&cid=" + PlayerConfig.caid + "&msg=impression" + "&rec=" + json.callback + "&ab=0&formwork=33&type=100" + "&uuid=" + PlayerConfig.uuid + "&url=" + url + "&refer=" + refer);
								setSkinState();
							}
						},null,PlayerConfig.swfHost + "panel/HisRecommend.swf");
					}
				}
			},"http://rc.vrs.sohu.com/drama/tab?pid=" + PlayerConfig.vrsPlayListId + "&ab=0" + "&p=" + PlayerConfig.passportMail + "&u=" + PlayerConfig.userId + "&y=" + PlayerConfig.yyid + "&source=44" + "&cids=" + PlayerConfig.caid + "&vid=" + PlayerConfig.vid + "&catecode=" + PlayerConfig.catcode + "&cate=101&po=4&s=2&ps=4&isBackRec=1" + "&area=" + escape(area) + "&r=" + new Date().getTime());
		}
		
		public function setCaptionBarState(param1:*) : void {
			var _loc2_:* = NaN;
			if(!(this._captionBar == null) && !(_core == null)) {
				this._captionBar.playProgress(param1);
				this._captionBar.x = 0;
				_loc2_ = Math.round(_core.videoContainer.y + _core.videoContainer.height * this._captionBar.py);
				if(_loc2_ + this._captionBar.height > _core.height) {
					this._captionBar.y = Math.round(_core.videoContainer.y + _core.videoContainer.height - this._captionBar.height - 5);
				} else if(!this._captionBar.isDragState) {
					this._captionBar.y = _loc2_;
				}
				
			}
		}
		
		private function hideSideBar(param1:*) : void {
			var _loc2_:* = NaN;
			var _loc3_:* = NaN;
			if(_skin != null) {
				_loc2_ = stage.mouseX;
				_loc3_ = stage.mouseY;
				if(!(param1.type == "mouseOut") && !this._rightSideBar.hitTestPoint(_loc2_,_loc3_) || param1.type == "mouseOut" && (param1.stageX <= 0 || param1.stageY <= 0) || param1.type == Event.MOUSE_LEAVE) {
					_showTween = TweenLite.to(this._rightSideBar,0.5,{
						"x":_hitArea_spr.width + 1,
						"ease":Quad.easeOut
					});
					if(!(!PlayerConfig.isSohuDomain && (_core.streamState == "pause" || (PlayerConfig.searchFocusIn) && stage.mouseX > 8 && stage.mouseX < stage.stageWidth - 8 && stage.mouseY > 8 && stage.mouseY < this._topSideBarBg.height - 8))) {
						TweenLite.to(this._topSideBar,0.5,{
							"y":-this._topSideBarBg.height,
							"ease":Quad.easeOut
						});
					}
					this.hideBar(param1);
				}
			}
		}
		
		private function showSideBar(param1:MouseEvent) : void {
			if(_skin != null) {
				if(!_ctrlBarBg_spr.hitTestPoint(mouseX,mouseY + 2)) {
					this._rightSideBarTimeout_to.restart();
				}
				if(!_ctrlBarBg_spr.hitTestPoint(mouseX,mouseY) && (this._activity != null?!this._activity.hitTestPoint(mouseX,mouseY):true)) {
					_showTween = TweenLite.to(this._rightSideBar,0.5,{
						"x":_hitArea_spr.width - this._share_btn.width,
						"ease":Quad.easeOut
					});
					this.showBar(param1);
					TweenLite.to(this._topSideBar,0.5,{
						"y":0,
						"ease":Quad.easeOut
					});
				}
				if(_ctrlBar_c.hitTestPoint(mouseX,mouseY - 110)) {
					if(!PlayerConfig.isLive) {
						this.showCommonProgress();
					}
				} else {
					this.hideBar2();
				}
			}
		}
		
		override protected function hideBar(param1:*) : void {
			var evt:* = param1;
			if(_skin != null) {
				if(!(evt.type == "mouseOut") && !_ctrlBarBg_spr.hitTestPoint(stage.mouseX,stage.mouseY + 5) && !this._isShowPreview && !((_volume_sld.slider.visible) && (_volume_sld.hitTestPoint(stage.mouseX,stage.mouseY))) && !((this._definitionSlider.visible) && (this._definitionSlider.hitTestPoint(stage.mouseX,stage.mouseY))) && !(!(this._settingPanel == null) && (this._settingPanel.visible) && (this._settingPanel.hitTestPoint(stage.mouseX,stage.mouseY))) || evt.type == "mouseOut" && (evt.stageX <= 0 || evt.stageY <= 0) || evt.type == Event.MOUSE_LEAVE) {
					if((PlayerConfig.isHide) || stage.displayState == "fullScreen") {
						if(stage.displayState == "fullScreen") {
							Mouse.hide();
						}
						_hideTween = TweenLite.to(_ctrlBar_c,0.5,{
							"y":_height + 2,
							"ease":Quad.easeOut,
							"onComplete":function():void {
								_showBar_boo = false;
							}
						});
					}
					if(!_progress_sld["hitSpr"].hitTestPoint(_progress_sld.mouseX,_progress_sld.mouseY)) {
						this.showMiniProgress();
					}
				}
			}
		}
		
		private function hideBar2(param1:* = null) : void {
			if(_skin != null) {
				if(!_ctrlBarBg_spr.hitTestPoint(stage.mouseX,stage.mouseY + 5) && !this._isShowPreview && !((_volume_sld.slider.visible) && (_volume_sld.hitTestPoint(stage.mouseX,stage.mouseY))) && !((this._definitionSlider.visible) && (this._definitionSlider.hitTestPoint(stage.mouseX,stage.mouseY))) && !(!(this._settingPanel == null) && (this._settingPanel.visible) && (this._settingPanel.hitTestPoint(stage.mouseX,stage.mouseY)))) {
					if(!_progress_sld["hitSpr"].hitTestPoint(stage.mouseX,stage.mouseY)) {
						this.showMiniProgress();
					}
				}
			}
		}
		
		override protected function showBar(param1:MouseEvent) : void {
			if(!(_skin == null) && !_showBar_boo) {
				TvSohuAds.getInstance().ctrlBarAd.dispatchSharedEvent();
			}
			if(_skin != null) {
				Mouse.show();
				_showBar_boo = true;
				_showTween = TweenLite.to(_ctrlBar_c,0.5,{
					"y":_height - _ctrlBarBg_spr.height,
					"ease":Quad.easeOut
				});
			}
		}
		
		public function videoBlurFilter() : void {
			var _loc1_:BlurFilter = null;
			var _loc2_:Array = null;
			var _loc3_:uint = 0;
			_loc1_ = new BlurFilter(12,12,BitmapFilterQuality.HIGH);
			this._filterArr[2] = _loc1_;
			_loc2_ = [];
			_loc3_ = 0;
			while(_loc3_ < this._filterArr.length) {
				if(!(this._filterArr[_loc3_] == 0) && !(this._filterArr[_loc3_] == null)) {
					_loc2_.push(this._filterArr[_loc3_]);
				}
				_loc3_++;
			}
			_core.videoContainer.filters = _loc2_;
			TweenLite.to(_hitArea_spr,0.8,{
				"alpha":0.5,
				"ease":Quad.easeOut
			});
		}
		
		public function clearBlurFilter() : void {
			var _loc1_:Array = null;
			var _loc2_:uint = 0;
			TweenLite.killTweensOf(_hitArea_spr);
			_hitArea_spr.alpha = 0;
			this._filterArr[2] = null;
			_loc1_ = [];
			_loc2_ = 0;
			while(_loc2_ < this._filterArr.length) {
				if(!(this._filterArr[_loc2_] == 0) && !(this._filterArr[_loc2_] == null)) {
					_loc1_.push(this._filterArr[_loc2_]);
				}
				_loc2_++;
			}
			_core.videoContainer.filters = _loc1_;
		}
		
		private function showBar2(param1:MouseEvent = null) : void {
			if(!(_skin == null) && !_showBar_boo) {
				TvSohuAds.getInstance().ctrlBarAd.dispatchSharedEvent();
			}
			if(_skin != null) {
				Mouse.show();
				_showBar_boo = true;
				_showTween = TweenLite.to(_ctrlBar_c,0.5,{
					"y":_height - _ctrlBarBg_spr.height,
					"ease":Quad.easeOut
				});
			}
		}
		
		private function startSideTween() : void {
			if(!stage.hasEventListener(MouseEvent.MOUSE_MOVE)) {
				stage.addEventListener(MouseEvent.MOUSE_MOVE,this.showSideBar);
				stage.addEventListener(Event.MOUSE_LEAVE,function(param1:Event):void {
					hideSideBar(param1);
				});
				this._rightSideBarTimeout_to.start();
			}
		}
		
		private function startPreLoad(param1:Event = null) : void {
			LogManager.msg("开启预加载功能！");
			_core.lastoutBuffer = true;
			ErrorSenderPQ.getInstance().sendPQStat({"code":PlayerConfig.START_PRELOAD_CODE});
		}
		
		public function get parentClass() : Class {
			return MediaPlayback;
		}
		
		public function get panel() : * {
			return this._playListPanel;
		}
		
		public function get likePanel() : * {
			return this._likePanel;
		}
		
		public function get more() : * {
			return this._more;
		}
		
		public function get flatWall3D() : * {
			return this._flatWall3D;
		}
		
		public function get skin() : * {
			return _skin;
		}
		
		public function get liveCoreVer() : String {
			return this._liveCoreVersion;
		}
		
		public function get hisRecommObj() : Object {
			return this._hisRecommObj;
		}
		
		public function setLoadCore(param1:Function) : void {
			_skin = null;
			this.loadCore();
			this._func = param1;
		}
		
		public function setTitle() : void {
			var _loc1_:TextFormat = null;
			var _loc2_:uint = 0;
			if(!(PlayerConfig.videoTitle == "") && !(this._titleText == null) && !(this._topPerSp == null)) {
				_loc1_ = new TextFormat();
				_loc1_.size = 14;
				_loc1_.color = 15066597;
				this._titleText.htmlText = unescape(PlayerConfig.videoTitle);
				this._titleText.setTextFormat(_loc1_);
				_loc2_ = 0;
				while(_loc2_ < unescape(PlayerConfig.videoTitle).length * 2) {
					if(!this._titleText.hitTestObject(this._topPerSp)) {
						break;
					}
					this._titleText.htmlText = Utils.maxCharsLimit(unescape(PlayerConfig.videoTitle),unescape(PlayerConfig.videoTitle).length * 2 - _loc2_,true);
					this._titleText.setTextFormat(_loc1_);
					_loc2_++;
				}
			}
		}
		
		public function setLicense() : void {
			var fat:TextFormat = null;
			var filter_fk:BitmapFilter = null;
			var fkFilters:Array = null;
			var getBitmapFilter:Function = function():BitmapFilter {
				var _loc1_:* = NaN;
				var _loc2_:* = NaN;
				var _loc3_:* = NaN;
				var _loc4_:* = NaN;
				var _loc5_:* = NaN;
				var _loc6_:* = false;
				var _loc7_:* = false;
				var _loc8_:* = NaN;
				_loc1_ = 3394815;
				_loc2_ = 0.8;
				_loc3_ = 35;
				_loc4_ = 35;
				_loc5_ = 2;
				_loc6_ = false;
				_loc7_ = false;
				_loc8_ = BitmapFilterQuality.HIGH;
				return new GlowFilter(_loc1_,_loc2_,_loc3_,_loc4_,_loc5_,_loc8_,_loc6_,_loc7_);
			};
			if(PlayerConfig.wm_filing != "") {
				this._licenseText = new TextField();
				this._licenseText.autoSize = TextFieldAutoSize.RIGHT;
				addChild(this._licenseText);
				fat = new TextFormat();
				fat.size = 18;
				fat.font = "微软雅黑";
				fat.color = 16777215;
				this._licenseText.htmlText = "备案号：" + PlayerConfig.wm_filing;
				this._licenseText.setTextFormat(fat);
				filter_fk = getBitmapFilter();
				fkFilters = new Array();
				fkFilters.push(filter_fk);
				this._licenseText.filters = fkFilters;
			}
		}
		
		public function setHighDot() : void {
			if(!(PlayerConfig.epInfo == null) && PlayerConfig.epInfo.length > 0) {
				_progress_sld["setDots"](PlayerConfig.epInfo);
			}
		}
		
		public function setFlatWall3D() : void {
			if(this._flatWall3D != null) {
				this._flatWall3D.End();
				removeChild(this._flatWall3D);
				this._flatWall3D = null;
			}
			if(_progress_sld != null) {
				_progress_sld["removeDotsBtn"]();
				_progress_sld["clearPreviewPic"]();
			}
			if(this._cueTipPanel != null) {
				removeChild(this._cueTipPanel);
				this._cueTipPanel = null;
			}
			if(this._wmTipPanel != null) {
				removeChild(this._wmTipPanel);
				this._wmTipPanel = null;
			}
		}
		
		public function set isTsp(param1:Boolean) : void {
			if(param1) {
				if(_progress_sld != null) {
					_progress_sld["downLoadPic"]();
				}
			}
		}
		
		public function set isSvdUserTip(param1:Boolean) : void {
			this._isSvdUserTip = param1;
		}
		
		public function set isUncaught(param1:Boolean) : void {
			this._isUncaught = param1;
		}
		
		public function set uncaughtError(param1:String) : void {
			this._uncaughtError = param1;
		}
		
		public function set isShowNextTitle(param1:Boolean) : void {
			this._isShowNextTitle = param1;
		}
		
		public function set isHide(param1:Boolean) : void {
			_isHide = param1;
		}
		
		public function showPriviewPic() : void {
			var flat3dReady:Function = null;
			var ctx:LoaderContext = null;
			flat3dReady = function(param1:PanelEvent):void {
				var obj:Object = null;
				var e:PanelEvent = param1;
				_flatWall3D.addEventListener("SEEK_PLAY_EVT",function(param1:Event):void {
					_flatWall3D.visible = false;
					seekTo(param1.target.nowR);
				});
				_flatWall3D.addEventListener("INITED",function(param1:Event):void {
					_flatWall3D.open(PlayerConfig.playedTime,slidePreviewTime);
					_core.pause();
				});
				_flatWall3D.addEventListener("CLOSE_EVT",function(param1:Event):void {
					if(streamState == "pause") {
						_core.pause();
					} else {
						_core.play();
					}
				});
				obj = _progress_sld["allPicObj"];
				obj.width = _core.width;
				obj.height = _core.height - (stage.displayState == "fullScreen"?pbarDiff():0);
				_flatWall3D.init(obj);
				setSkinState();
				_startPlay_btn.visible = _skinMap.getValue("startPlayBtn").v = false;
			};
			this.streamState = _core.streamState;
			if(_progress_sld != null) {
				if(this._flatWall3D == null) {
					ctx = new LoaderContext();
					ctx.applicationDomain = new ApplicationDomain(ApplicationDomain.currentDomain);
					new LoaderUtil().load(10,function(param1:Object):void {
						if(param1.info === "success") {
							_flatWall3D = param1.data.content;
							_flatWall3D.addEventListener(PanelEvent.READY,flat3dReady);
							_panelArr.push(_flatWall3D);
							addChild(_flatWall3D);
						}
					},null,PlayerConfig.swfHost + "panel/FlatWall3D.swf",ctx);
				} else if(this._flatWall3D.isOpen) {
					this._flatWall3D.close();
					_startPlay_btn.visible = _skinMap.getValue("startPlayBtn").v = true;
				} else if(this._preLoadPanel == null || (!this._preLoadPanel.isOpen) || (this._preLoadPanel.isBackgroundRun)) {
					this.closePanel();
					this._flatWall3D.open(PlayerConfig.playedTime,this.slidePreviewTime);
					_core.pause();
					_startPlay_btn.visible = _skinMap.getValue("startPlayBtn").v = false;
				}
				
				
				SendRef.getInstance().sendPQDrog("http://click.hd.sohu.com.cn/s.gif?type=PL_C_PreView&s=" + PlayerConfig.stype + "&r=" + new Date().getTime());
			}
		}
		
		public function changeToVA(param1:MouseEventUtil) : void {
			PlayerConfig.ktvMode = "va";
			_core.volume = this._ktvCore.audioCore.volume;
			this._ktvCore.volume = 0;
			_skinMap.getValue("vocSongBtn").v = _skinMap.getValue("vocSongBtn").e = false;
			_skinMap.getValue("oriSongBtn").v = _skinMap.getValue("oriSongBtn").e = true;
			this.setSkinState();
		}
		
		public function changeToOA(param1:MouseEventUtil) : void {
			var objEle:Object = null;
			var evt:MouseEventUtil = param1;
			PlayerConfig.ktvMode = "oa";
			if(this._ktvCore == null) {
				_core.pause("0");
				objEle = {
					"videoCore":_core,
					"synUrl":PlayerConfig.synUrl,
					"gslbIp":PlayerConfig.gslbIp,
					"data":Model.getInstance().videoInfo.data,
					"data2":Model.getInstance().videoInfo.data2
				};
				new LoaderUtil().load(10,function(param1:Object):void {
					var obj:Object = param1;
					if(obj.info == "success") {
						LogManager.msg("KTVModule加载成功:");
						_ktvCore = obj.data.content;
						_ktvCore.softInit(objEle);
						_ktvCore.seek(_core.filePlayedTime);
						_ktvCore.play();
						_ktvCore.volume = _core.volume;
						_core.addEventListener(MediaEvent.PAUSE,function(param1:MediaEvent):void {
							if((PlayerConfig.isKTVVideo) && !(_ktvCore == null)) {
								_ktvCore.pause();
							}
						});
						_core.addEventListener(MediaEvent.PLAY,function(param1:MediaEvent):void {
							if((PlayerConfig.isKTVVideo) && !(_ktvCore == null)) {
								_ktvCore.play();
							}
						});
						_core.addEventListener(MediaEvent.PLAY_PROGRESS,_ktvCore.onPlayProgress);
						_ktvCore.addEventListener("revise",function(param1:Event):void {
							_core.sleep();
						});
						_ktvCore.audioCore.addEventListener(MediaEvent.FULL,function(param1:MediaEvent):void {
							_core.play();
						});
						_core.volume = 0;
					} else {
						LogManager.msg("KTVModule加载失败");
					}
				},null,PlayerConfig.swfHost + "otherCore/KTVCore.swf");
			} else {
				this._ktvCore.volume = _core.volume;
				_core.volume = 0;
			}
			_skinMap.getValue("vocSongBtn").v = _skinMap.getValue("vocSongBtn").e = true;
			_skinMap.getValue("oriSongBtn").v = _skinMap.getValue("oriSongBtn").e = false;
			this.setSkinState();
		}
		
		public function clearTipText() : void {
			this.tipText("");
		}
		
		public function updateUserLoginInfo() : void {
			if(this._wmTipPanel != null) {
				this._wmTipPanel.updateUserLoginInfo({
					"uid":PlayerConfig.visitorId,
					"passport":PlayerConfig.passportMail
				});
			}
		}
		
		override protected function tipText(param1:String, param2:uint = 0) : void {
			if(_tipDisplay != null) {
				super.tipText(param1,param2);
			}
		}
		
		private function average(param1:Array) : Number {
			var _loc2_:* = NaN;
			var _loc3_:uint = 0;
			_loc2_ = 0;
			_loc3_ = 0;
			while(_loc3_ < param1.length) {
				_loc2_ = _loc2_ + param1[_loc3_];
				_loc3_++;
			}
			return _loc2_ / param1.length;
		}
		
		private var isCuting:Boolean = false;
		
		public function startCutImgToBoundPage() : void {
			if(this.isCuting) {
				return;
			}
			this.isCuting = true;
			this.streamState = _core.streamState;
			new LoaderUtil().load(10,function(param1:Object):void {
				var obj:Object = param1;
				if(obj.info == "success") {
					_broundPageCut = obj.data.content;
					_broundPageCut.addEventListener("close",function closeHan(param1:Event):void {
						removeChild(_broundPageCut);
						_broundPageCut.removeEventListener("close",closeHan);
						_broundPageCut = null;
						if(streamState == "pause") {
							_core.pause();
						} else {
							_core.play();
						}
						isCuting = false;
					});
					addChild(_broundPageCut);
					_broundPageCut.CutImage(_core.videoArr[_core.curIndex].video,PlayerConfig.playedTime,_core.metaWidth,_core.metaHeight);
				} else {
					if(streamState == "pause") {
						_core.pause();
					} else {
						_core.play();
					}
					isCuting = false;
					if(Eif.available) {
						ExternalInterface.call("boundPageCutResult","",0);
					}
				}
			},null,PlayerConfig.swfHost + "panel/BountPageCutImage.swf");
		}
		
		public function getJSVarObj(param1:Object) : Object {
			var vari:Object = param1;
			try {
				if((Eif.available) && (ExternalInterface.available)) {
					return ExternalInterface.call("function(){return " + vari + ";}",null);
				}
			}
			catch(err:Error) {
				return null;
			}
			return null;
		}
		
		public function showMofunEnglishPanel() : void {
			if(this._mofunengPanel == null) {
				new LoaderUtil().load(10,function(param1:Object):void {
					if(param1.info == "success") {
						_mofunengPanel = param1.data.content;
						_mofunengPanel.init(TvSohuMediaPlayback.getInstance(),PlayerConfig.videoTitle,PlayerConfig.totalDuration,PlayerConfig.vid,"sohu");
						addChild(_mofunengPanel);
						_mofunengPanel.open();
						setSkinState();
						showMofunEnglishPanel();
					}
				},null,PlayerConfig.swfHost + "panel/MofunEnglish.swf",new LoaderContext(true));
			}
		}
	}
}
