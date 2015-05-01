package com.qiyi.player.wonder.plugins.setting.view {
	import com.iqiyi.components.panelSystem.impls.BasePanel;
	import com.qiyi.player.wonder.common.status.Status;
	import com.qiyi.player.wonder.common.vo.UserInfoVO;
	import common.CommonCloseBtn;
	import common.CommonBg;
	import flash.text.TextField;
	import offinewatch.OffineDownloadlBtn;
	import com.qiyi.player.wonder.plugins.setting.view.parts.filter.FilterSexRadioPart;
	import com.qiyi.player.wonder.plugins.setting.view.parts.filter.FilterTimeRadioPart;
	import flash.display.Shape;
	import flash.display.Loader;
	import flash.display.DisplayObjectContainer;
	import com.qiyi.player.base.pub.EnumItem;
	import com.qiyi.player.wonder.common.ui.FastCreator;
	import flash.events.MouseEvent;
	import gs.TweenLite;
	import com.qiyi.player.wonder.plugins.setting.SettingDef;
	import com.iqiyi.components.global.GlobalStage;
	import com.qiyi.player.wonder.body.BodyDef;
	import com.qiyi.player.core.model.def.SkipPointEnum;
	import com.qiyi.player.user.UserDef;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLRequest;
	import com.qiyi.player.wonder.common.config.SystemConfig;
	import flash.system.LoaderContext;
	
	public class FilterView extends BasePanel {
		
		public function FilterView(param1:DisplayObjectContainer, param2:Status, param3:UserInfoVO) {
			super(NAME,param1);
			this._container = param1;
			this._status = param2;
			this._userInfoVO = param3;
			type = BodyDef.VIEW_TYPE_POPUP;
			this.initUI();
		}
		
		public static const NAME:String = "com.qiyi.player.wonder.plugins.setting.view.FilterView";
		
		private static const STR_CONFIRM:String = "确定";
		
		private static const STR_TIME:String = "播放时间缩短为";
		
		private static const STR_SEX:Array = ["帅哥","美女"];
		
		private static const STR_SEX_FILTER:Array = ["绿镜","大众版绿镜","男生版绿镜","女生版绿镜"];
		
		private static const STR_EXPLAIN_TITLE_PART1:String = "为您开启";
		
		private static const STR_EXPLAIN_TITLE_PART2:String = "模式，只播放<font color=\'#f05b26\'>橙色</font>部分";
		
		private static const STR_EXPLAIN_SELECT:String = "更多选择";
		
		private var _status:Status;
		
		private var _userInfoVO:UserInfoVO;
		
		private var _closeBtn:CommonCloseBtn;
		
		private var _bg:CommonBg;
		
		private var _title:TextField;
		
		private var _explainTime:TextField;
		
		private var _time:TextField;
		
		private var _tfExplainSelect:TextField;
		
		private var _confirmBtn:OffineDownloadlBtn;
		
		private var _contirmTF:TextField;
		
		private var _filterSexRadio:FilterSexRadioPart;
		
		private var _filterTimeRadio:FilterTimeRadioPart;
		
		private var _bgShape:Shape;
		
		private var _filterMovieClip:Loader;
		
		private var _container:DisplayObjectContainer;
		
		private var _guessSex:uint = 0;
		
		private var _curSex:EnumItem;
		
		private var _curTimeIndex:uint = 0;
		
		private var _sexList:Vector.<EnumItem> = null;
		
		private var _timeList:Array = null;
		
		public function set guessSex(param1:uint) : void {
			this._guessSex = param1;
		}
		
		public function get curTimeIndex() : uint {
			return this._curTimeIndex;
		}
		
		public function set curTimeIndex(param1:uint) : void {
			this._curTimeIndex = param1;
		}
		
		public function get curSex() : EnumItem {
			return this._curSex;
		}
		
		public function set curSex(param1:EnumItem) : void {
			this._curSex = param1;
		}
		
		private function initUI() : void {
			this._bg = new CommonBg();
			this._bg.width = 430;
			addChild(this._bg);
			this._title = FastCreator.createLabel(STR_EXPLAIN_TITLE_PART1,16777215,14);
			this._title.x = (this._bg.width - this._title.textWidth) / 2;
			this._title.y = 24;
			addChild(this._title);
			this._explainTime = FastCreator.createLabel(STR_TIME,16777215,14);
			this._explainTime.x = (this._bg.width - 68 - this._explainTime.textWidth) / 2;
			this._explainTime.y = 58;
			addChild(this._explainTime);
			this._time = FastCreator.createLabel("20分钟",16777215,20);
			this._time.x = 238;
			this._time.y = 54;
			addChild(this._time);
			this._tfExplainSelect = FastCreator.createLabel(STR_EXPLAIN_SELECT,16777215,14);
			this._tfExplainSelect.x = 68;
			this._tfExplainSelect.y = 92;
			addChild(this._tfExplainSelect);
			this._confirmBtn = new OffineDownloadlBtn();
			this._confirmBtn.x = (this._bg.width - this._confirmBtn.width) / 2;
			addChild(this._confirmBtn);
			this._contirmTF = FastCreator.createLabel(STR_CONFIRM,16777215,14);
			this._contirmTF.x = this._confirmBtn.x + (this._confirmBtn.width - this._contirmTF.width) / 2;
			this._contirmTF.mouseEnabled = false;
			addChild(this._contirmTF);
			this._closeBtn = new CommonCloseBtn();
			this._closeBtn.x = this._bg.width - this._closeBtn.width - 5;
			this._closeBtn.y = 1;
			addChild(this._closeBtn);
			this._bgShape = new Shape();
			this._closeBtn.addEventListener(MouseEvent.CLICK,this.onCloseBtnClick);
			this._confirmBtn.addEventListener(MouseEvent.CLICK,this.onConfirmBtnClick);
		}
		
		public function onAddStatus(param1:int) : void {
			this._status.addStatus(param1);
			switch(param1) {
				case SettingDef.STATUS_FILTER_OPEN:
					TweenLite.to(this._bg,10,{"onComplete":this.onCloseBtnClick});
					this.loaderMovieClip();
					this.open();
					break;
			}
		}
		
		public function onRemoveStatus(param1:int) : void {
			this._status.removeStatus(param1);
			switch(param1) {
				case SettingDef.STATUS_FILTER_OPEN:
					TweenLite.killTweensOf(this._bg);
					this.close();
					break;
			}
		}
		
		public function onUserInfoChanged(param1:UserInfoVO) : void {
			this._userInfoVO = param1;
		}
		
		override public function open(param1:DisplayObjectContainer = null) : void {
			if(!isOnStage) {
				super.open(param1);
				dispatchEvent(new SettingEvent(SettingEvent.Evt_FilterOpen));
			}
		}
		
		override public function close() : void {
			if(isOnStage) {
				super.close();
				this.deletedSexRadioPart();
				this.deletedTimeRadioPart();
				dispatchEvent(new SettingEvent(SettingEvent.Evt_FilterClose));
			}
		}
		
		override protected function onAddToStage() : void {
			super.onAddToStage();
			this.onResize(GlobalStage.stage.stageWidth,GlobalStage.stage.stageHeight);
			alpha = 0;
			TweenLite.to(this,BodyDef.POPUP_TWEEN_TIME / 1000,{"alpha":1});
		}
		
		override protected function onRemoveFromStage() : void {
			super.onRemoveFromStage();
			TweenLite.killTweensOf(this);
		}
		
		public function onResize(param1:int, param2:int) : void {
			if(isOnStage) {
				if((this._filterTimeRadio) || (this._filterSexRadio)) {
					this._tfExplainSelect.visible = true;
				} else {
					this._tfExplainSelect.visible = false;
				}
				this._confirmBtn.y = this._confirmBtn.height + this._explainTime.y + int(this._tfExplainSelect.visible) * 34 + (this._filterSexRadio?34:0) + (this._filterTimeRadio?34:0);
				this._contirmTF.y = this._confirmBtn.y + (this._confirmBtn.height - this._contirmTF.height) / 2;
				this._bg.height = this._confirmBtn.y + this._confirmBtn.height + 20;
				x = (param1 - this._bg.width) / 2;
				y = (param2 - this._bg.height) / 2;
			}
		}
		
		public function setPanelSexAttribute(param1:EnumItem, param2:Vector.<EnumItem>) : void {
			this._sexList = param2;
			this._curSex = param1;
			this.deletedSexRadioPart();
			if(this._sexList.length >= 2) {
				this._filterSexRadio = new FilterSexRadioPart();
				this._filterSexRadio.setSexAttribute(this._curSex,this._sexList);
				this._filterSexRadio.x = 68;
				this._filterSexRadio.y = this._tfExplainSelect.y + 34;
				addChild(this._filterSexRadio);
				this._filterSexRadio.addEventListener(SettingEvent.Evt_FilterSexRadioClick,this.onFilterSexRadioClick);
			}
			this._title.htmlText = this.getTitleStrBySex(this._curSex);
			this.onResize(GlobalStage.stage.stageWidth,GlobalStage.stage.stageHeight);
		}
		
		public function setPanelTimeAttribute(param1:Array, param2:uint = 0) : void {
			this._timeList = param1;
			if(!this._timeList) {
				return;
			}
			this._curTimeIndex = param2 == 0?this._curTimeIndex:param2;
			this._curTimeIndex = this._curTimeIndex > this._timeList.length - 1?0:this._curTimeIndex;
			this.deletedTimeRadioPart();
			if(param1.length >= 2) {
				this._filterTimeRadio = new FilterTimeRadioPart();
				this._filterTimeRadio.setTimeAttribute(this._curTimeIndex,param1);
				this._filterTimeRadio.x = 68;
				this._filterTimeRadio.y = this._tfExplainSelect.y + 34 + (this._filterSexRadio?34:0);
				addChild(this._filterTimeRadio);
				this._filterTimeRadio.addEventListener(SettingEvent.Evt_FilterTimeRadioClick,this.onFilterTimeRadioClick);
			}
			this._time.text = uint(this._timeList[this._curTimeIndex] / 60 / 1000) + "分钟";
			this.onResize(GlobalStage.stage.stageWidth,GlobalStage.stage.stageHeight);
		}
		
		private function deletedSexRadioPart() : void {
			if(this._filterSexRadio) {
				this._filterSexRadio.removeEventListener(SettingEvent.Evt_FilterSexRadioClick,this.onFilterSexRadioClick);
				this._filterSexRadio.destroy();
				if(this._filterSexRadio.parent) {
					this._filterSexRadio.parent.removeChild(this._filterSexRadio);
				}
				this._filterSexRadio = null;
			}
		}
		
		private function deletedTimeRadioPart() : void {
			if(this._filterTimeRadio) {
				this._filterTimeRadio.removeEventListener(SettingEvent.Evt_FilterTimeRadioClick,this.onFilterTimeRadioClick);
				this._filterTimeRadio.destroy();
				if(this._filterTimeRadio.parent) {
					this._filterTimeRadio.parent.removeChild(this._filterTimeRadio);
				}
				this._filterTimeRadio = null;
			}
		}
		
		private function onFilterSexRadioClick(param1:SettingEvent) : void {
			this._curSex = param1.data as EnumItem;
			this._title.htmlText = this.getTitleStrBySex(this._curSex);
			dispatchEvent(new SettingEvent(SettingEvent.Evt_FilterSexRadioClick,this._curSex));
		}
		
		private function onFilterTimeRadioClick(param1:SettingEvent) : void {
			this._curTimeIndex = int(param1.data);
			if(!this._timeList) {
				return;
			}
			this._curTimeIndex = this._curTimeIndex > this._timeList.length - 1?0:this._curTimeIndex;
			this._time.text = uint(this._timeList[this._curTimeIndex] / 60 / 1000) + "分钟";
		}
		
		private function getTitleStrBySex(param1:EnumItem) : String {
			var _loc2_:* = "";
			switch(param1) {
				case SkipPointEnum.ENJOYABLE_SUB_COMMON:
					_loc2_ = this.getNicknameByGuessSex(this._guessSex) + STR_EXPLAIN_TITLE_PART1 + "<font color=\'#699f00\'>" + (this._sexList.length > 1?STR_SEX_FILTER[1]:STR_SEX_FILTER[0]) + "</font>" + STR_EXPLAIN_TITLE_PART2;
					break;
				case SkipPointEnum.ENJOYABLE_SUB_MALE:
					_loc2_ = this.getNicknameByGuessSex(this._guessSex) + STR_EXPLAIN_TITLE_PART1 + "<font color=\'#699f00\'>" + STR_SEX_FILTER[2] + "</font>" + STR_EXPLAIN_TITLE_PART2;
					break;
				case SkipPointEnum.ENJOYABLE_SUB_FEMALE:
					_loc2_ = this.getNicknameByGuessSex(this._guessSex) + STR_EXPLAIN_TITLE_PART1 + "<font color=\'#699f00\'>" + STR_SEX_FILTER[3] + "</font>" + STR_EXPLAIN_TITLE_PART2;
					break;
			}
			return _loc2_;
		}
		
		private function getNicknameByGuessSex(param1:uint) : String {
			var _loc2_:* = "";
			switch(param1) {
				case UserDef.USER_SEX_MALE:
					_loc2_ = STR_SEX[0] + "，";
					break;
				case UserDef.USER_SEX_FEMALE:
					_loc2_ = STR_SEX[1] + "，";
					break;
			}
			return _loc2_;
		}
		
		public function playSkipMovieClip() : void {
			var _loc1_:MovieClip = null;
			if(this._filterMovieClip == null && this._filterMovieClip.content == null) {
				return;
			}
			this._filterMovieClip.scaleX = GlobalStage.stage.stageWidth / 980;
			this._filterMovieClip.scaleY = GlobalStage.stage.stageHeight / 480;
			if(!this._filterMovieClip.parent) {
				this._container.addChild(this._bgShape);
				this._container.addChild(this._filterMovieClip);
				_loc1_ = this._filterMovieClip.contentLoaderInfo.content as MovieClip;
				if(_loc1_) {
					_loc1_.filterMovieClip.gotoAndPlay(1);
				}
				this._bgShape.alpha = 1;
				this._bgShape.graphics.clear();
				this._bgShape.graphics.beginFill(0);
				this._bgShape.graphics.drawRect(0,0,GlobalStage.stage.stageWidth,GlobalStage.stage.stageHeight);
				this._bgShape.graphics.endFill();
				TweenLite.to(this._bgShape,2,{
					"alpha":0,
					"onComplete":this.onMCPlayComplete
				});
			}
		}
		
		private function onMCPlayComplete() : void {
			TweenLite.killTweensOf(this._bgShape);
			if(this._filterMovieClip.parent) {
				this._container.removeChild(this._filterMovieClip);
			}
			if(this._bgShape.parent) {
				this._container.removeChild(this._bgShape);
			}
		}
		
		private function loaderMovieClip() : void {
			if((this._filterMovieClip) && (this._filterMovieClip.content)) {
				return;
			}
			this._filterMovieClip = new Loader();
			this._filterMovieClip.contentLoaderInfo.addEventListener(Event.COMPLETE,this.onComplete);
			this._filterMovieClip.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,this.onError);
			this._filterMovieClip.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.onError);
			this._filterMovieClip.load(new URLRequest(SystemConfig.FILTER_MOVIE_CLIP),new LoaderContext(true));
		}
		
		private function onComplete(param1:Event) : void {
		}
		
		private function onError(param1:Event = null) : void {
			if(this._filterMovieClip == null) {
				return;
			}
			this._filterMovieClip.contentLoaderInfo.removeEventListener(Event.COMPLETE,this.onComplete);
			this._filterMovieClip.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,this.onError);
			this._filterMovieClip.contentLoaderInfo.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,this.onError);
			this._filterMovieClip = null;
		}
		
		private function onConfirmBtnClick(param1:MouseEvent) : void {
			dispatchEvent(new SettingEvent(SettingEvent.Evt_FilterConfirmBtnClick,{
				"curSex":this._curSex,
				"timeIndex":this._curTimeIndex
			}));
			this.close();
		}
		
		private function onCloseBtnClick(param1:MouseEvent = null) : void {
			this.close();
		}
	}
}
