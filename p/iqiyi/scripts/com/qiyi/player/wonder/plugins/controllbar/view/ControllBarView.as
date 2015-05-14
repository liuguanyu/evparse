package com.qiyi.player.wonder.plugins.controllbar.view
{
	import com.iqiyi.components.panelSystem.impls.BasePanel;
	import com.qiyi.player.wonder.common.status.Status;
	import com.qiyi.player.wonder.common.vo.UserInfoVO;
	import com.qiyi.player.base.pub.EnumItem;
	import com.qiyi.player.wonder.plugins.controllbar.view.seekbar.SeekBarView;
	import com.qiyi.player.wonder.plugins.controllbar.view.volume.VolumeControlView;
	import controllbar.ControlBarUI;
	import com.iqiyi.components.tooltip.DefaultToolTip;
	import com.qiyi.player.wonder.plugins.controllbar.view.controllbar.ControllBarButton;
	import com.qiyi.player.wonder.plugins.controllbar.view.controllbar.ControllBarDispalyTime;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import com.qiyi.player.wonder.common.utils.ChineseNameOfLangAudioDef;
	import com.iqiyi.components.global.GlobalStage;
	import flash.geom.Point;
	import com.qiyi.player.wonder.body.BodyDef;
	import gs.TweenLite;
	import flash.events.MouseEvent;
	import com.iqiyi.components.tooltip.ToolTip;
	import com.qiyi.player.wonder.plugins.controllbar.ControllBarDef;
	import com.qiyi.player.wonder.plugins.setting.SettingDef;
	import flash.display.DisplayObjectContainer;
	import com.qiyi.player.wonder.common.utils.ConstUtils;
	import com.qiyi.player.base.utils.Strings;
	
	public class ControllBarView extends BasePanel
	{
		
		public static const NAME:String = "com.qiyi.player.wonder.plugins.controllbar.view.ControllBarView";
		
		private var _status:Status;
		
		private var _userInfoVO:UserInfoVO;
		
		private var _currentDefinitionInfo:EnumItem;
		
		private var _seekBarView:SeekBarView;
		
		private var _volumeControlView:VolumeControlView;
		
		private var _controlBarUI:ControlBarUI;
		
		private var _tvListBtnClicked:Boolean = false;
		
		private var _loadingBtnToolTip:DefaultToolTip;
		
		private var _filterBtn:ControllBarButton;
		
		private var _trackBtn:ControllBarButton;
		
		private var _captionBtn:ControllBarButton;
		
		private var _d3Btn:ControllBarButton;
		
		private var _definitionBtn:ControllBarButton;
		
		private var _likeListBtn:ControllBarButton;
		
		private var _timeShow:ControllBarDispalyTime;
		
		public function ControllBarView(param1:DisplayObjectContainer, param2:Status, param3:UserInfoVO)
		{
			super(NAME,param1);
			this._status = param2;
			this._userInfoVO = param3;
			this.initUI();
			this.onResize(GlobalStage.stage.stageWidth,GlobalStage.stage.stageHeight);
		}
		
		public function get currentDefinitionInfo() : EnumItem
		{
			return this._currentDefinitionInfo;
		}
		
		public function set currentDefinitionInfo(param1:EnumItem) : void
		{
			this.updateDefinitionBtn(param1);
		}
		
		public function get seekBarView() : SeekBarView
		{
			return this._seekBarView;
		}
		
		public function get volumeControlView() : VolumeControlView
		{
			return this._volumeControlView;
		}
		
		public function get playBtn() : SimpleButton
		{
			return this._controlBarUI.triggerBtn.playBtn;
		}
		
		public function get pauseBtn() : SimpleButton
		{
			return this._controlBarUI.triggerBtn.pauseBtn;
		}
		
		public function get loadingBtn() : Sprite
		{
			return this._controlBarUI.loadingBtn;
		}
		
		public function get replayBtn() : SimpleButton
		{
			return this._controlBarUI.replayBtn;
		}
		
		public function get unFoldBtn() : SimpleButton
		{
			return this._controlBarUI.unFoldBtn;
		}
		
		public function get foldBtn() : SimpleButton
		{
			return this._controlBarUI.foldBtn;
		}
		
		public function updateDefinitionBtn(param1:EnumItem) : void
		{
			this._currentDefinitionInfo = param1;
			if(this._definitionBtn)
			{
				this._definitionBtn.updateBtnText(ChineseNameOfLangAudioDef.getDefinitionName(param1));
			}
			this.onBtnsResize(GlobalStage.stage.stageWidth,GlobalStage.stage.stageHeight);
		}
		
		public function set repeatSubBtnVisible(param1:Boolean) : void
		{
			this._controlBarUI.repeatBtn.openLoopBtn.visible = !param1;
			this._controlBarUI.repeatBtn.closeLoopBtn.visible = param1;
		}
		
		public function onUserInfoChanged(param1:UserInfoVO) : void
		{
			this._userInfoVO = param1;
		}
		
		public function onAddStatus(param1:int) : void
		{
			var _loc2:* = 0;
			var _loc3:Point = null;
			var _loc4:String = null;
			var _loc5:String = null;
			this._status.addStatus(param1);
			this.seekBarView.onAddStatus(param1);
			switch(param1)
			{
				case ControllBarDef.STATUS_OPEN:
					this.open();
					break;
				case ControllBarDef.STATUS_SHOW:
					_loc2 = GlobalStage.stage.stageHeight - BodyDef.VIDEO_BOTTOM_RESERVE - 10;
					TweenLite.to(this,0.5,{
						"y":_loc2,
						"onComplete":this.onTweenComplete
					});
					break;
				case ControllBarDef.STATUS_TRIGGER_BTN_SHOW:
					this._controlBarUI.triggerBtn.visible = true;
					this._controlBarUI.triggerBtn.pauseBtn.visible = true;
					this._controlBarUI.triggerBtn.playBtn.visible = false;
					this._controlBarUI.loadingBtn.visible = false;
					this._controlBarUI.replayBtn.visible = false;
					if(this._loadingBtnToolTip.parent)
					{
						GlobalStage.stage.removeChild(this._loadingBtnToolTip);
					}
					break;
				case ControllBarDef.STATUS_TRIGGER_BTN_PAUSE:
					this._controlBarUI.triggerBtn.visible = true;
					this._controlBarUI.triggerBtn.pauseBtn.visible = false;
					this._controlBarUI.triggerBtn.playBtn.visible = true;
					this._controlBarUI.loadingBtn.visible = false;
					this._controlBarUI.replayBtn.visible = false;
					if(this._loadingBtnToolTip.parent)
					{
						GlobalStage.stage.removeChild(this._loadingBtnToolTip);
					}
					break;
				case ControllBarDef.STATUS_LOAD_TIPS_SHOW:
					_loc3 = localToGlobal(new Point(this._controlBarUI.triggerBtn.width / 3,-22));
					this._loadingBtnToolTip.x = _loc3.x;
					this._loadingBtnToolTip.y = _loc3.y;
					GlobalStage.stage.addChild(this._loadingBtnToolTip);
					break;
				case ControllBarDef.STATUS_LOAD_BTN_SHOW:
					this._controlBarUI.triggerBtn.visible = false;
					this._controlBarUI.loadingBtn.visible = true;
					this._controlBarUI.replayBtn.visible = false;
					break;
				case ControllBarDef.STATUS_REPLAY_BTN_SHOW:
					this._controlBarUI.triggerBtn.visible = false;
					this._controlBarUI.loadingBtn.visible = false;
					this._controlBarUI.replayBtn.visible = true;
					break;
				case ControllBarDef.STATUS_FULL_SCREEN_BTN_SHOW:
					this._controlBarUI.normalBtn.visible = true;
					this._controlBarUI.fullscreenBtn.visible = false;
					break;
				case ControllBarDef.STATUS_TIME_SHOW:
					if(this._timeShow)
					{
						this._timeShow.visible = true;
					}
					else
					{
						this._timeShow = new ControllBarDispalyTime();
						this._timeShow.y = (BodyDef.VIDEO_BOTTOM_RESERVE - this._timeShow.height) / 2;
						this._controlBarUI.addChild(this._timeShow);
					}
					break;
				case ControllBarDef.STATUS_LOOP_PLAY_BTN_SHOW:
					this._controlBarUI.repeatBtn.visible = true;
					this.onBtnsResize(GlobalStage.stage.stageWidth,GlobalStage.stage.stageHeight);
					break;
				case ControllBarDef.STATUS_NEXT_BTN_SHOW:
					this._controlBarUI.nextVideoBtn.visible = true;
					this.onBtnsResize(GlobalStage.stage.stageWidth,GlobalStage.stage.stageHeight);
					break;
				case ControllBarDef.STATUS_LIST_BTN_SHOW:
					_loc4 = "播放列表";
					if(this._likeListBtn)
					{
						this._likeListBtn.updateBtnText(_loc4);
						this._likeListBtn.visible = true;
					}
					else
					{
						this._likeListBtn = new ControllBarButton(_loc4);
						this._controlBarUI.addChild(this._likeListBtn);
						this._likeListBtn.addEventListener(MouseEvent.CLICK,this.onTvListBtnClick);
					}
					ToolTip.getInstance().unregisterComponent(this._likeListBtn);
					ToolTip.getInstance().registerComponent(this._likeListBtn,_loc4);
					this.onBtnsResize(GlobalStage.stage.stageWidth,GlobalStage.stage.stageHeight);
					break;
				case ControllBarDef.STATUS_TVLIST_BTN_SHOW:
					_loc5 = "剧集列表";
					if(this._likeListBtn)
					{
						this._likeListBtn.updateBtnText(_loc5);
						this._likeListBtn.visible = true;
					}
					else
					{
						this._likeListBtn = new ControllBarButton(_loc5);
						this._controlBarUI.addChild(this._likeListBtn);
						this._likeListBtn.addEventListener(MouseEvent.CLICK,this.onTvListBtnClick);
					}
					ToolTip.getInstance().unregisterComponent(this._likeListBtn);
					ToolTip.getInstance().registerComponent(this._likeListBtn,_loc5);
					this.onBtnsResize(GlobalStage.stage.stageWidth,GlobalStage.stage.stageHeight);
					break;
				case ControllBarDef.STATUS_EXPAND_BTN_SHOW:
					this._controlBarUI.unFoldBtn.visible = !this._status.hasStatus(ControllBarDef.STATUS_EXPAND_UNFOLD);
					this._controlBarUI.foldBtn.visible = this._status.hasStatus(ControllBarDef.STATUS_EXPAND_UNFOLD);
					this.onBtnsResize(GlobalStage.stage.stageWidth,GlobalStage.stage.stageHeight);
					break;
				case ControllBarDef.STATUS_EXPAND_UNFOLD:
					if(this._status.hasStatus(ControllBarDef.STATUS_EXPAND_BTN_SHOW))
					{
						this._controlBarUI.unFoldBtn.visible = !this._status.hasStatus(ControllBarDef.STATUS_EXPAND_UNFOLD);
						this._controlBarUI.foldBtn.visible = this._status.hasStatus(ControllBarDef.STATUS_EXPAND_UNFOLD);
						this.onBtnsResize(GlobalStage.stage.stageWidth,GlobalStage.stage.stageHeight);
					}
					break;
				case ControllBarDef.STATUS_3D_BTN_SHOW:
					if(this._d3Btn)
					{
						this._d3Btn.updateBtnText("2D");
						this._d3Btn.visible = true;
					}
					else
					{
						this._d3Btn = new ControllBarButton("2D");
						this._controlBarUI.addChild(this._d3Btn);
						ToolTip.getInstance().registerComponent(this._d3Btn,"切换至3D");
						this._d3Btn.addEventListener(MouseEvent.CLICK,this.onD3BtnClick);
					}
					break;
				case ControllBarDef.STATUS_CAPTION_BTN_SHOW:
					if(this._captionBtn)
					{
						this._captionBtn.visible = true;
					}
					else
					{
						this._captionBtn = new ControllBarButton("字幕");
						this._controlBarUI.addChild(this._captionBtn);
						ToolTip.getInstance().registerComponent(this._captionBtn,"设置字幕");
						this._captionBtn.addEventListener(MouseEvent.CLICK,this.onCaptionOrTrackBtnClick);
					}
					break;
				case ControllBarDef.STATUS_TRACK_BTN_SHOW:
					if(this._trackBtn)
					{
						this._trackBtn.visible = true;
					}
					else
					{
						this._trackBtn = new ControllBarButton("配音");
						this._controlBarUI.addChild(this._trackBtn);
						ToolTip.getInstance().registerComponent(this._trackBtn,"设置配音");
						this._trackBtn.addEventListener(MouseEvent.CLICK,this.onCaptionOrTrackBtnClick);
					}
					break;
				case ControllBarDef.STATUS_DEFINITION_SHOW:
					if(this._definitionBtn)
					{
						this._definitionBtn.visible = true;
					}
					else
					{
						this._definitionBtn = new ControllBarButton(ChineseNameOfLangAudioDef.getDefinitionName(this._currentDefinitionInfo));
						this._controlBarUI.addChild(this._definitionBtn);
						this._definitionBtn.addEventListener(MouseEvent.CLICK,this.onDefinitionBtnClick);
					}
					break;
				case ControllBarDef.STATUS_FILTER_BTN_SHOW:
					if(this._filterBtn)
					{
						this._filterBtn.visible = true;
					}
					else
					{
						this._filterBtn = new ControllBarButton("绿镜");
						this._controlBarUI.addChild(this._filterBtn);
						this._filterBtn.addEventListener(MouseEvent.CLICK,this.onFilterBtnClick);
					}
					ToolTip.getInstance().unregisterComponent(this._filterBtn);
					ToolTip.getInstance().registerComponent(this._filterBtn,"开启绿镜");
					this._filterBtn.isSelected = false;
					break;
				case ControllBarDef.STATUS_FILTER_OPEN:
					ToolTip.getInstance().unregisterComponent(this._filterBtn);
					ToolTip.getInstance().registerComponent(this._filterBtn,"取消绿镜");
					this._filterBtn.isSelected = true;
					break;
			}
		}
		
		public function onRemoveStatus(param1:int) : void
		{
			this._status.removeStatus(param1);
			this.seekBarView.onRemoveStatus(param1);
			switch(param1)
			{
				case ControllBarDef.STATUS_OPEN:
					this.close();
					break;
				case ControllBarDef.STATUS_SHOW:
					TweenLite.to(this,0.5,{
						"y":GlobalStage.stage.stageHeight,
						"onComplete":this.onTweenComplete
					});
					break;
				case ControllBarDef.STATUS_SEEK_BAR_SHOW:
					this.seekBarView.visible = false;
					break;
				case ControllBarDef.STATUS_FULL_SCREEN_BTN_SHOW:
					this._controlBarUI.normalBtn.visible = false;
					this._controlBarUI.fullscreenBtn.visible = true;
					break;
				case ControllBarDef.STATUS_TIME_SHOW:
					if(this._timeShow)
					{
						this._timeShow.visible = false;
					}
					break;
				case ControllBarDef.STATUS_LOOP_PLAY_BTN_SHOW:
					this._controlBarUI.repeatBtn.visible = false;
					this.onBtnsResize(GlobalStage.stage.stageWidth,GlobalStage.stage.stageHeight);
					break;
				case ControllBarDef.STATUS_NEXT_BTN_SHOW:
					this._controlBarUI.nextVideoBtn.visible = false;
					this.onBtnsResize(GlobalStage.stage.stageWidth,GlobalStage.stage.stageHeight);
					break;
				case ControllBarDef.STATUS_LIST_BTN_SHOW:
					if(this._likeListBtn)
					{
						this._likeListBtn.visible = false;
					}
					this.onBtnsResize(GlobalStage.stage.stageWidth,GlobalStage.stage.stageHeight);
					break;
				case ControllBarDef.STATUS_TVLIST_BTN_SHOW:
					if(this._likeListBtn)
					{
						this._likeListBtn.visible = false;
					}
					this.onBtnsResize(GlobalStage.stage.stageWidth,GlobalStage.stage.stageHeight);
					break;
				case ControllBarDef.STATUS_EXPAND_BTN_SHOW:
					this._controlBarUI.unFoldBtn.visible = false;
					this._controlBarUI.foldBtn.visible = false;
					this.onBtnsResize(GlobalStage.stage.stageWidth,GlobalStage.stage.stageHeight);
					break;
				case ControllBarDef.STATUS_EXPAND_UNFOLD:
					if(this._status.hasStatus(ControllBarDef.STATUS_EXPAND_BTN_SHOW))
					{
						this._controlBarUI.unFoldBtn.visible = !this._status.hasStatus(ControllBarDef.STATUS_EXPAND_UNFOLD);
						this._controlBarUI.foldBtn.visible = this._status.hasStatus(ControllBarDef.STATUS_EXPAND_UNFOLD);
						this.onBtnsResize(GlobalStage.stage.stageWidth,GlobalStage.stage.stageHeight);
					}
					break;
				case ControllBarDef.STATUS_3D_BTN_SHOW:
					if(this._d3Btn)
					{
						this._d3Btn.visible = false;
					}
					break;
				case ControllBarDef.STATUS_CAPTION_BTN_SHOW:
					if(this._captionBtn)
					{
						this._captionBtn.visible = false;
					}
					break;
				case ControllBarDef.STATUS_TRACK_BTN_SHOW:
					if(this._trackBtn)
					{
						this._trackBtn.visible = false;
					}
					break;
				case ControllBarDef.STATUS_DEFINITION_SHOW:
					if(this._definitionBtn)
					{
						this._definitionBtn.visible = false;
					}
					break;
				case ControllBarDef.STATUS_LOAD_TIPS_SHOW:
					if(this._loadingBtnToolTip.parent)
					{
						GlobalStage.stage.removeChild(this._loadingBtnToolTip);
					}
					break;
				case ControllBarDef.STATUS_FILTER_BTN_SHOW:
					if(this._filterBtn)
					{
						this._filterBtn.visible = false;
					}
					ToolTip.getInstance().unregisterComponent(this._filterBtn);
					ToolTip.getInstance().registerComponent(this._filterBtn,"开启绿镜");
					this._filterBtn.isSelected = false;
					this.onBtnsResize(GlobalStage.stage.stageWidth,GlobalStage.stage.stageHeight);
					break;
				case ControllBarDef.STATUS_FILTER_OPEN:
					ToolTip.getInstance().unregisterComponent(this._filterBtn);
					ToolTip.getInstance().registerComponent(this._filterBtn,"开启绿镜");
					this._filterBtn.isSelected = false;
					break;
			}
		}
		
		public function onResize(param1:int, param2:int) : void
		{
			var _loc3:Point = null;
			x = 0;
			if(this._status.hasStatus(ControllBarDef.STATUS_SHOW))
			{
				y = GlobalStage.stage.stageHeight - BodyDef.VIDEO_BOTTOM_RESERVE - 10;
			}
			else
			{
				y = GlobalStage.stage.stageHeight;
			}
			this._controlBarUI.backGround.width = param1;
			if(this._status.hasStatus(ControllBarDef.STATUS_SEEK_BAR_SHOW))
			{
				this._seekBarView.onResize(param1,param2);
			}
			this._volumeControlView.y = 10;
			this.onBtnsResize(param1,param2);
			if(this._loadingBtnToolTip.parent)
			{
				_loc3 = localToGlobal(new Point(this._controlBarUI.triggerBtn.width / 3,-22));
				this._loadingBtnToolTip.x = _loc3.x;
				this._loadingBtnToolTip.y = _loc3.y;
			}
		}
		
		private function onBtnsResize(param1:int, param2:int) : void
		{
			var _loc3:Number = 0;
			this._controlBarUI.repeatBtn.x = this._controlBarUI.triggerBtn.width + 1;
			this._controlBarUI.nextVideoBtn.x = this._controlBarUI.repeatBtn.x + this._controlBarUI.repeatBtn.width * int(this._controlBarUI.repeatBtn.visible);
			_loc3 = this._controlBarUI.nextVideoBtn.x + this._controlBarUI.nextVideoBtn.width * int(this._controlBarUI.nextVideoBtn.visible);
			if(this._likeListBtn)
			{
				this._likeListBtn.x = 10 + this._controlBarUI.nextVideoBtn.x + this._controlBarUI.nextVideoBtn.width * int(this._controlBarUI.nextVideoBtn.visible);
				_loc3 = this._likeListBtn.x + this._likeListBtn.width * int(this._likeListBtn.visible);
			}
			if(this._timeShow)
			{
				this._timeShow.x = _loc3;
				_loc3 = this._timeShow.x + this._timeShow.width * int(this._timeShow.visible);
			}
			_loc3 = 0;
			this._controlBarUI.fullscreenBtn.x = param1 - this._controlBarUI.fullscreenBtn.width - 2;
			this._controlBarUI.normalBtn.x = this._controlBarUI.fullscreenBtn.x;
			this._controlBarUI.unFoldBtn.x = this._controlBarUI.normalBtn.x - this._controlBarUI.unFoldBtn.width * int(this._status.hasStatus(ControllBarDef.STATUS_EXPAND_BTN_SHOW));
			this._controlBarUI.foldBtn.x = this._controlBarUI.unFoldBtn.x;
			var _loc4:Boolean = this._status.hasStatus(ControllBarDef.STATUS_VOLUME_BAR_SHOW);
			this._volumeControlView.x = this._controlBarUI.unFoldBtn.x - this._volumeControlView.width * int(_loc4) - 16;
			_loc3 = this._volumeControlView.x;
			if(this._definitionBtn)
			{
				this._definitionBtn.x = this._volumeControlView.x - this._definitionBtn.width * int(this._definitionBtn.visible);
				_loc3 = this._definitionBtn.x;
			}
			if(this._filterBtn)
			{
				this._filterBtn.x = _loc3 - this._filterBtn.width * int(this._filterBtn.visible);
				_loc3 = this._filterBtn.x;
			}
			if(this._trackBtn)
			{
				this._trackBtn.x = _loc3 - this._trackBtn.width * int(this._trackBtn.visible);
				_loc3 = this._trackBtn.x;
			}
			if(this._captionBtn)
			{
				this._captionBtn.x = _loc3 - this._captionBtn.width * int(this._captionBtn.visible);
				_loc3 = this._captionBtn.x;
			}
			if(this._d3Btn)
			{
				this._d3Btn.x = _loc3 - this._d3Btn.width * int(this._d3Btn.visible);
				_loc3 = this._d3Btn.x;
			}
			dispatchEvent(new ControllBarEvent(ControllBarEvent.Evt_DefinitionBtnLocationChange,{
				"x":(this._definitionBtn?this._definitionBtn.x + (this._definitionBtn.width - SettingDef.DEFINITION_PANEL_WIDTH) / 2:0),
				"y":this.y,
				"filterBtnX":(this._filterBtn?this._filterBtn.x:0)
			}));
		}
		
		public function onPlayerRunning(param1:int, param2:int, param3:int, param4:Boolean) : void
		{
			this._seekBarView.onPlayerRunning(param1,param2,param4);
			this.updateDisplayTime(param3,param1);
		}
		
		public function adjustDisplayTimeOnStoped() : void
		{
			var _loc1:int = this._seekBarView.totalTime - this._seekBarView.currentTime;
			if(_loc1 <= 2000 && !(_loc1 == 0))
			{
				this.updateDisplayTime(this._seekBarView.totalTime,this._seekBarView.totalTime);
			}
		}
		
		public function updateD3BtnVisible(param1:Boolean) : void
		{
			this._d3Btn.updateBtnText(param1?"3D":"2D");
			ToolTip.getInstance().unregisterComponent(this._d3Btn);
			ToolTip.getInstance().registerComponent(this._d3Btn,param1?"切换至2D":"切换至3D");
		}
		
		public function updateFilterBtnType(param1:Boolean) : void
		{
			ToolTip.getInstance().unregisterComponent(this._filterBtn);
			ToolTip.getInstance().registerComponent(this._filterBtn,param1?"取消绿镜":"开启绿镜");
			this._filterBtn.isSelected = param1;
		}
		
		override public function open(param1:DisplayObjectContainer = null) : void
		{
			if(!isOnStage)
			{
				super.open(param1);
				dispatchEvent(new ControllBarEvent(ControllBarEvent.Evt_Open));
			}
		}
		
		override public function close() : void
		{
			if(isOnStage)
			{
				super.close();
				dispatchEvent(new ControllBarEvent(ControllBarEvent.Evt_Close));
			}
		}
		
		override protected function onAddToStage() : void
		{
			super.onAddToStage();
		}
		
		override protected function onRemoveFromStage() : void
		{
			super.onRemoveFromStage();
		}
		
		private function updateDisplayTime(param1:int, param2:int) : void
		{
			var _loc3:* = "";
			var _loc4:* = "";
			if(param1 > ConstUtils.H_2_MS)
			{
				_loc3 = Strings.formatAsTimeCode(param2 / 1000,true);
				_loc4 = Strings.formatAsTimeCode(param1 / 1000,true);
			}
			else
			{
				_loc3 = Strings.formatAsTimeCode(param2 / 1000,false);
				_loc4 = Strings.formatAsTimeCode(param1 / 1000,false);
			}
			if(this._timeShow)
			{
				this._timeShow.updateTime(_loc3,_loc4);
			}
		}
		
		private function onNormalScreenBtnClick(param1:MouseEvent) : void
		{
			GlobalStage.setNormalScreen();
			this._controlBarUI.normalBtn.visible = false;
			this._controlBarUI.fullscreenBtn.visible = true;
		}
		
		private function onFullScreenBtnClick(param1:MouseEvent) : void
		{
			GlobalStage.setFullScreen();
			this._controlBarUI.normalBtn.visible = true;
			this._controlBarUI.fullscreenBtn.visible = false;
		}
		
		private function onRepeatBtnClick(param1:MouseEvent) : void
		{
			dispatchEvent(new ControllBarEvent(ControllBarEvent.Evt_RepeatBtnClicked,this._controlBarUI.repeatBtn.openLoopBtn.visible));
		}
		
		private function onNextVideoBtnClick(param1:MouseEvent) : void
		{
			dispatchEvent(new ControllBarEvent(ControllBarEvent.Evt_NextVideoBtnClicked));
		}
		
		private function onTvListBtnClick(param1:MouseEvent) : void
		{
			this._tvListBtnClicked = !this._tvListBtnClicked;
			dispatchEvent(new ControllBarEvent(ControllBarEvent.Evt_TvListBtnClicked,this._tvListBtnClicked));
		}
		
		private function onFilterBtnClick(param1:MouseEvent) : void
		{
			if(this._filterBtn.isSelected)
			{
				dispatchEvent(new ControllBarEvent(ControllBarEvent.Evt_FilterCloseClick));
			}
			else
			{
				dispatchEvent(new ControllBarEvent(ControllBarEvent.Evt_FilterOpenClick));
			}
		}
		
		private function onD3BtnClick(param1:MouseEvent) : void
		{
			var _loc2:* = false;
			if(this._d3Btn.text == "3D")
			{
				_loc2 = true;
			}
			dispatchEvent(new ControllBarEvent(ControllBarEvent.Evt_D3BtnClick,_loc2));
		}
		
		private function onDefinitionBtnClick(param1:MouseEvent) : void
		{
			dispatchEvent(new ControllBarEvent(ControllBarEvent.Evt_DefinitionBtnClicked));
		}
		
		private function onCaptionOrTrackBtnClick(param1:MouseEvent) : void
		{
			dispatchEvent(new ControllBarEvent(ControllBarEvent.Evt_CaptionOrTrackBtnClick));
		}
		
		private function onTweenComplete() : void
		{
			if(this._status.hasStatus(ControllBarDef.STATUS_SHOW))
			{
				y = GlobalStage.stage.stageHeight - BodyDef.VIDEO_BOTTOM_RESERVE - 10;
			}
			else
			{
				y = GlobalStage.stage.stageHeight;
			}
			dispatchEvent(new ControllBarEvent(ControllBarEvent.Evt_DefinitionBtnLocationChange,{
				"x":(this._definitionBtn?this._definitionBtn.x + (this._definitionBtn.width - SettingDef.DEFINITION_PANEL_WIDTH) / 2:0),
				"y":this.y,
				"filterBtnX":(this._filterBtn?this._filterBtn.x:0)
			}));
		}
		
		private function initUI() : void
		{
			this._seekBarView = new SeekBarView(this._status);
			this._seekBarView.visible = false;
			this._loadingBtnToolTip = new DefaultToolTip();
			this._loadingBtnToolTip.text = "正在缓冲...";
			this._volumeControlView = new VolumeControlView(this._status);
			this._controlBarUI = new ControlBarUI();
			this._controlBarUI.x = 0;
			this._controlBarUI.y = 10;
			this._controlBarUI.triggerBtn.playBtn.visible = false;
			this._controlBarUI.loadingBtn.visible = false;
			this._controlBarUI.loadingBtn.mouseChildren = false;
			this._controlBarUI.loadingBtn.buttonMode = true;
			this._controlBarUI.loadingBtn.useHandCursor = true;
			this._controlBarUI.loadingBtn.graphics.beginFill(0,0);
			this._controlBarUI.loadingBtn.graphics.drawRect(-this._controlBarUI.loadingBtn.width / 2,-this._controlBarUI.loadingBtn.height / 2,this._controlBarUI.loadingBtn.width,this._controlBarUI.loadingBtn.height);
			this._controlBarUI.loadingBtn.graphics.endFill();
			this._controlBarUI.replayBtn.visible = false;
			this._controlBarUI.normalBtn.visible = !this._status.hasStatus(ControllBarDef.STATUS_FULL_SCREEN_BTN_SHOW);
			this._controlBarUI.normalBtn.addEventListener(MouseEvent.CLICK,this.onNormalScreenBtnClick);
			this._controlBarUI.fullscreenBtn.visible = this._status.hasStatus(ControllBarDef.STATUS_FULL_SCREEN_BTN_SHOW);
			this._controlBarUI.fullscreenBtn.addEventListener(MouseEvent.CLICK,this.onFullScreenBtnClick);
			this._controlBarUI.repeatBtn.addEventListener(MouseEvent.CLICK,this.onRepeatBtnClick);
			this._controlBarUI.nextVideoBtn.addEventListener(MouseEvent.CLICK,this.onNextVideoBtnClick);
			this._controlBarUI.repeatBtn.visible = false;
			this._controlBarUI.repeatBtn.openLoopBtn.visible = true;
			this._controlBarUI.repeatBtn.closeLoopBtn.visible = false;
			this._controlBarUI.nextVideoBtn.visible = false;
			this._controlBarUI.unFoldBtn.visible = false;
			this._controlBarUI.foldBtn.visible = false;
			addChild(this._seekBarView);
			addChild(this._controlBarUI);
			addChild(this._volumeControlView);
			this.registerToolTip();
		}
		
		private function registerToolTip() : void
		{
			ToolTip.getInstance().registerComponent(this._seekBarView.forWardBtn,"快进");
			ToolTip.getInstance().registerComponent(this._seekBarView.backWardBtn,"快退");
			ToolTip.getInstance().registerComponent(this._controlBarUI.triggerBtn.playBtn,"点击播放");
			ToolTip.getInstance().registerComponent(this._controlBarUI.triggerBtn.pauseBtn,"点击暂停");
			ToolTip.getInstance().registerComponent(this._controlBarUI.replayBtn,"重新播放");
			ToolTip.getInstance().registerComponent(this._controlBarUI.nextVideoBtn,"下一集");
			ToolTip.getInstance().registerComponent(this._controlBarUI.repeatBtn.openLoopBtn,"开启循环");
			ToolTip.getInstance().registerComponent(this._controlBarUI.repeatBtn.closeLoopBtn,"关闭循环");
			ToolTip.getInstance().registerComponent(this._controlBarUI.unFoldBtn,"展开");
			ToolTip.getInstance().registerComponent(this._controlBarUI.foldBtn,"收起");
			ToolTip.getInstance().registerComponent(this._volumeControlView.speaker,"静音设置");
			ToolTip.getInstance().registerComponent(this._controlBarUI.normalBtn,"退出全屏");
			ToolTip.getInstance().registerComponent(this._controlBarUI.fullscreenBtn,"全屏");
		}
	}
}
