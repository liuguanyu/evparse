package com.qiyi.player.core.view {
	import flash.display.Sprite;
	import com.qiyi.player.core.player.IPlayer;
	import com.qiyi.player.core.model.IMovie;
	import flash.text.TextField;
	import com.qiyi.player.core.model.impls.subtitle.SubtitleDummy;
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.Stage;
	import com.qiyi.player.core.video.engine.IEngine;
	import com.qiyi.player.core.player.coreplayer.ICorePlayer;
	import com.qiyi.player.core.player.def.PlayerUseTypeEnum;
	import flash.geom.Rectangle;
	import flash.events.Event;
	import com.qiyi.player.core.model.impls.pub.Settings;
	import com.qiyi.player.core.player.events.PlayerEvent;
	import flash.events.KeyboardEvent;
	import com.qiyi.player.core.model.impls.subtitle.Language;
	import com.qiyi.player.core.model.def.LanguageEnum;
	import com.qiyi.player.core.Config;
	import flash.net.URLRequest;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import com.qiyi.player.core.player.def.StatusEnum;
	import com.qiyi.player.core.model.impls.subtitle.Sentence;
	import flash.net.FileReference;
	import flash.ui.Keyboard;
	import com.qiyi.player.core.model.utils.LogManager;
	import flash.display.MovieClip;
	import flash.filters.DropShadowFilter;
	import com.qiyi.player.base.utils.FontUtils;
	import com.qiyi.player.components.YHTF;
	import com.qiyi.player.components.HTTF;
	
	public class FloatLayer extends Sprite implements ILayer {
		
		public function FloatLayer(param1:IPlayer) {
			super();
			this._player = param1;
			this._player.addEventListener(PlayerEvent.Evt_MovieInfoReady,this.onMovieInfoReady);
			this._player.addEventListener(PlayerEvent.Evt_StatusChanged,this.onStatusChanged);
			this._player.addEventListener(PlayerEvent.Evt_RenderAreaChanged,this.onRenderAreaChanged);
			this._player.addEventListener(PlayerEvent.Evt_RenderADAreaChanged,this.onRenderADAreaChanged);
			this._subtitleDummy = new SubtitleDummy();
			if(FontUtils.hasFont("微软雅黑")) {
				this._subtitleSprite = new YHTF();
				this._subtitleTF = this._subtitleSprite.getChildAt(0) as TextField;
			} else {
				this._subtitleSprite = new HTTF();
				this._subtitleTF = this._subtitleSprite.getChildAt(0) as TextField;
			}
			this._subtitleTF.wordWrap = true;
			this._subtitleTF.multiline = false;
			this._subtitleTF.selectable = false;
			var _loc2_:TextFormat = new TextFormat();
			_loc2_.size = Settings.instance.subtitleSize;
			_loc2_.color = Settings.instance.subtitleColor;
			_loc2_.align = TextFormatAlign.CENTER;
			_loc2_.leading = 0;
			this._subtitleTF.defaultTextFormat = _loc2_;
			this._subtitleTF.filters = this.SUBTITLE_FILTER;
			addChild(this._subtitleSprite);
			this._subtitleSprite.visible = this._showSubtitle;
			this._videoInfo = new VideoInfo(this._player,this);
			Settings.instance.addEventListener(Settings.Evt_SubtitleColor,this.onSubtitleColorChanged);
			Settings.instance.addEventListener(Settings.Evt_SubtitleSize,this.onSubtitleSizeChanged);
			Settings.instance.addEventListener(Settings.Evt_SubtitleLang,this.onSubtitleLangChanged);
			Settings.instance.addEventListener(Settings.Evt_SubtitlePos,this.onSubtitlePosChanged);
			if(stage == null) {
				addEventListener(Event.ADDED_TO_STAGE,this.onAddToStage);
			} else {
				this.onAddToStage(null);
			}
			this.drawBackground();
			addEventListener(Event.ENTER_FRAME,this.onEnterFrame);
		}
		
		private const BOSS_KEY:String = "QIYICOM";
		
		private const LOG_KEY:String = "QIYILOG";
		
		private const EVT_LOGOCHANGED:String = "qiyi_logo_changed";
		
		private const SUBTITLE_FILTER:Array = [new DropShadowFilter(2)];
		
		private var _player:IPlayer;
		
		private var _movie:IMovie;
		
		private var _showSubtitle:Boolean = true;
		
		private var _showLogo:Boolean = true;
		
		private var _showBrand:Boolean = true;
		
		private var _showBackground:Boolean = true;
		
		private var _needMask:Boolean = true;
		
		private var _key:String = "";
		
		private var _logKey:String = "";
		
		private var _subtitleSprite:Sprite;
		
		private var _subtitleTF:TextField;
		
		private var _subtitleDummy:SubtitleDummy;
		
		private var _logoLoader:LogoLoader;
		
		private var _logo:DisplayObject;
		
		private var _brand:Loader;
		
		private var _videoInfo:VideoInfo;
		
		private var _stage:Stage;
		
		private var _frameCount:int = 0;
		
		public function get movie() : IMovie {
			return this._movie;
		}
		
		public function get subtitleDummy() : SubtitleDummy {
			return this._subtitleDummy;
		}
		
		public function set showSubtitle(param1:Boolean) : void {
			this._showSubtitle = param1;
			this._subtitleSprite.visible = this._showSubtitle;
		}
		
		public function get showSubtitle() : Boolean {
			return this._showSubtitle;
		}
		
		public function set showSubtitleFilter(param1:Boolean) : void {
			this._subtitleTF.filters = param1?this.SUBTITLE_FILTER:null;
		}
		
		public function get showSubtitleFilter() : Boolean {
			return !(this._subtitleTF.filters == null);
		}
		
		public function set showLogo(param1:Boolean) : void {
			this._showLogo = param1;
			if(this._logo) {
				this._logo.visible = this._showLogo;
			}
		}
		
		public function get showLogo() : Boolean {
			return this._showLogo;
		}
		
		public function set showBrand(param1:Boolean) : void {
			this._showBrand = param1;
			if(this._brand) {
				this._brand.visible = this._showBrand;
			}
		}
		
		public function get showBrand() : Boolean {
			return this._showBrand;
		}
		
		public function set showBackground(param1:Boolean) : void {
			this._showBackground = param1;
			this.drawBackground();
		}
		
		public function get showBackground() : Boolean {
			return this._showBackground;
		}
		
		public function bind(param1:IMovie, param2:IEngine) : void {
			this._movie = param1;
			this._videoInfo.bind(param2);
			this.setMaskBackground(true);
			if((this._brand) && (this._brand.parent)) {
				this._brand.parent.removeChild(this._brand);
			}
			if((this._player.movieInfo) && (this._player.movieInfo.subtitles)) {
				this.tryLoadSubtitle();
				this.adjustSubtitle();
			}
		}
		
		public function tryLoadBrandAndLogo() : void {
			if((this._player.movieModel) && ICorePlayer(this._player).runtimeData.playerUseType == PlayerUseTypeEnum.MAIN) {
				this.loadBrand();
				this.loadLogo(this._player.movieModel.logoId);
			}
		}
		
		public function toggleVideoInfo() : void {
			if(this._videoInfo.parent) {
				this._videoInfo.hide();
			} else {
				this._videoInfo.show();
			}
		}
		
		public function loadLogo(param1:String) : void {
			this.destroyLogo();
			if(this._logoLoader) {
				this._logoLoader.removeEventListener(LogoLoader.Evt_Complete,this.onLogoComplete);
				this._logoLoader = null;
			}
			if(!(param1 == "") && !(param1 == "0")) {
				this._logoLoader = new LogoLoader();
				this._logoLoader.addEventListener(LogoLoader.Evt_Complete,this.onLogoComplete);
				this._logoLoader.load(param1);
			}
		}
		
		public function setLogo(param1:DisplayObject) : void {
			var _loc2_:Rectangle = null;
			this.destroyLogo();
			this._logo = param1;
			if(this._logo) {
				this._logo.addEventListener(this.EVT_LOGOCHANGED,this.onLogoChanged);
				this._logo.visible = this._showLogo;
				_loc2_ = this._player.realArea;
				if(_loc2_ == null) {
					this._logo.visible = false;
				} else {
					this.adjustLogo();
				}
				addChild(this._logo);
			}
		}
		
		public function clearSubtitle() : void {
			this._subtitleDummy.clear();
			this._subtitleTF.text = "";
		}
		
		public function destroy() : void {
			graphics.clear();
			if(parent) {
				parent.removeChild(this);
			}
			removeEventListener(Event.ENTER_FRAME,this.onEnterFrame);
			Settings.instance.removeEventListener(Settings.Evt_SubtitleColor,this.onSubtitleColorChanged);
			Settings.instance.removeEventListener(Settings.Evt_SubtitleSize,this.onSubtitleSizeChanged);
			Settings.instance.removeEventListener(Settings.Evt_SubtitleLang,this.onSubtitleLangChanged);
			Settings.instance.removeEventListener(Settings.Evt_SubtitlePos,this.onSubtitlePosChanged);
			this._player.removeEventListener(PlayerEvent.Evt_MovieInfoReady,this.onMovieInfoReady);
			this._player.removeEventListener(PlayerEvent.Evt_StatusChanged,this.onStatusChanged);
			this._player.removeEventListener(PlayerEvent.Evt_RenderAreaChanged,this.onRenderAreaChanged);
			this._movie = null;
			this.clearSubtitle();
			if(this._subtitleSprite.parent) {
				this._subtitleSprite.parent.removeChild(this._subtitleSprite);
			}
			if(this._logoLoader) {
				this._logoLoader.removeEventListener(LogoLoader.Evt_Complete,this.onLogoComplete);
				this._logoLoader = null;
			}
			this.destroyLogo();
			if((this._brand) && (this._brand.parent)) {
				this._brand.parent.removeChild(this._brand);
			}
			this._brand = null;
			this._videoInfo.destroy();
			removeEventListener(Event.ADDED_TO_STAGE,this.onAddToStage);
			if(this._stage) {
				this._stage.removeEventListener(KeyboardEvent.KEY_DOWN,this.onStageKey);
				this._stage = null;
			}
		}
		
		private function destroyLogo() : void {
			if(this._logo) {
				this._logo.removeEventListener(this.EVT_LOGOCHANGED,this.onLogoChanged);
				if(this._logo.parent) {
					this._logo.parent.removeChild(this._logo);
				}
			}
			this._logo = null;
		}
		
		private function setMaskBackground(param1:Boolean) : void {
			if(this._needMask != param1) {
				this._needMask = param1;
				this.drawBackground();
			}
		}
		
		private function drawBackground() : void {
			var _loc1_:Rectangle = null;
			var _loc2_:Rectangle = null;
			graphics.clear();
			if(this._showBackground) {
				_loc1_ = this._player.settingArea;
				_loc2_ = this._player.realArea;
				if((_loc2_) && (_loc1_)) {
					graphics.beginFill(0);
					graphics.drawRect(0,0,_loc1_.width,_loc2_.y);
					graphics.drawRect(0,_loc2_.y,_loc2_.x,_loc2_.height);
					graphics.drawRect(0,_loc2_.bottom,_loc1_.width,_loc1_.height - _loc2_.bottom);
					graphics.drawRect(_loc2_.right,_loc2_.y,_loc1_.width - _loc2_.right,_loc2_.height);
					if(this._needMask) {
						graphics.drawRect(_loc2_.x,_loc2_.y,_loc2_.width,_loc2_.height);
					}
					graphics.endFill();
				}
			}
		}
		
		private function tryLoadSubtitle() : void {
			var _loc1_:Vector.<Language> = null;
			var _loc2_:* = 0;
			var _loc3_:Language = null;
			var _loc4_:* = 0;
			if((this._player.movieInfo) && (this._player.movieInfo.subtitles)) {
				_loc1_ = this._player.movieInfo.subtitles;
				_loc2_ = _loc1_.length;
				_loc3_ = null;
				_loc4_ = 0;
				while(_loc4_ < _loc2_) {
					_loc3_ = _loc1_[_loc4_];
					if(_loc3_ != null) {
						if(Settings.instance.subtitleLang == LanguageEnum.NONE) {
							if((this._player.movieInfo.defaultSubtitle) && _loc3_.lang == this._player.movieInfo.defaultSubtitle.lang) {
								this._subtitleDummy.loadLanguage(_loc3_);
								break;
							}
						} else {
							if(Settings.instance.subtitleLang == LanguageEnum.NOTHING) {
								this.clearSubtitle();
								break;
							}
							if(_loc3_.lang == Settings.instance.subtitleLang) {
								this._subtitleDummy.loadLanguage(_loc3_);
								break;
							}
							if(_loc4_ == _loc2_ - 1) {
								if(this._player.movieInfo.defaultSubtitle) {
									this._subtitleDummy.loadLanguage(this._player.movieInfo.defaultSubtitle);
									break;
								}
								this._subtitleDummy.loadLanguage(_loc1_[0]);
								break;
							}
						}
					}
					_loc4_++;
				}
			}
		}
		
		private function adjustSubtitle() : void {
			var _loc1_:Rectangle = this._player.realArea;
			if(!(_loc1_ == null) && !(_loc1_.width == 0) && !(_loc1_.height == 0)) {
				this._subtitleTF.width = _loc1_.width - 20;
				this._subtitleTF.height = this._subtitleTF.textHeight + 10;
				this._subtitleSprite.x = _loc1_.x + 10;
				this._subtitleSprite.y = _loc1_.bottom - Settings.instance.subtitlePos - this._subtitleTF.textHeight;
			} else {
				this._subtitleTF.text = "";
			}
		}
		
		private function loadBrand() : void {
			var _loc1_:String = null;
			if((this._player.movieModel) && (this._player.movieInfo)) {
				if((this._brand) && (this._brand.parent)) {
					this._brand.parent.removeChild(this._brand);
				}
				_loc1_ = Config.BRAND_URL;
				if(this._player.movieInfo.qiyiProduced) {
					_loc1_ = Config.BRAND_QIYIPRODUCED_URL;
				} else if(this._player.movieModel.exclusive) {
					_loc1_ = Config.BRAND_EXCLUSIVE_URL;
				} else {
					_loc1_ = Config.BRAND_URL;
				}
				
				this._brand = new Loader();
				this._brand.visible = this._showBrand;
				this._brand.load(new URLRequest(_loc1_));
				this.adjustBrand();
			}
		}
		
		private function adjustLogo() : void {
			var _loc1_:Rectangle = null;
			var _loc2_:* = NaN;
			if(this._logo) {
				_loc1_ = this._player.realArea;
				_loc2_ = _loc1_.height / 520;
				_loc2_ = _loc2_ > 1.8?1.8:_loc2_;
				this._logo.scaleX = this._logo.scaleY = _loc2_ * 1;
				this._logo.x = _loc1_.x + _loc1_.width - this._logo.width - 10;
				this._logo.y = _loc1_.y + 8;
			}
		}
		
		private function adjustBrand() : void {
			var _loc1_:Rectangle = null;
			var _loc2_:* = NaN;
			if(this._brand) {
				_loc1_ = this._player.realArea;
				_loc2_ = _loc1_.height / 520;
				_loc2_ = _loc2_ > 1.1?1.1:_loc2_;
				this._brand.scaleX = this._brand.scaleY = _loc1_.width / 970;
				this._brand.x = _loc1_.x + _loc1_.width - 158 * this._brand.scaleX - 15;
				this._brand.y = _loc1_.y + _loc1_.height - 75 * this._brand.scaleY - 15;
			}
		}
		
		private function onSubtitleColorChanged(param1:Event) : void {
			var _loc2_:TextFormat = new TextFormat();
			_loc2_.size = Settings.instance.subtitleSize;
			_loc2_.color = Settings.instance.subtitleColor;
			_loc2_.align = TextFormatAlign.CENTER;
			_loc2_.leading = 0;
			this._subtitleTF.defaultTextFormat = _loc2_;
			this._subtitleTF.setTextFormat(_loc2_);
		}
		
		private function onSubtitleSizeChanged(param1:Event) : void {
			var _loc2_:TextFormat = new TextFormat();
			_loc2_.size = Settings.instance.subtitleSize;
			_loc2_.color = Settings.instance.subtitleColor;
			_loc2_.align = TextFormatAlign.CENTER;
			_loc2_.leading = 0;
			this._subtitleTF.defaultTextFormat = _loc2_;
			this._subtitleTF.setTextFormat(_loc2_);
			this.adjustSubtitle();
		}
		
		private function onSubtitleLangChanged(param1:Event) : void {
			if(Settings.instance.subtitleLang == LanguageEnum.NONE) {
				if((this._player.movieInfo) && (this._player.movieInfo.defaultSubtitle)) {
					this.tryLoadSubtitle();
				} else {
					this.clearSubtitle();
				}
			} else if(Settings.instance.subtitleLang == LanguageEnum.NOTHING) {
				this.clearSubtitle();
			} else {
				this.tryLoadSubtitle();
			}
			
		}
		
		private function onSubtitlePosChanged(param1:Event) : void {
			this.adjustSubtitle();
		}
		
		private function onMovieInfoReady(param1:Event) : void {
			if(!this._player.hasStatus(StatusEnum.STOPPING) && !this._player.hasStatus(StatusEnum.STOPED)) {
				this.tryLoadSubtitle();
			}
		}
		
		private function onStatusChanged(param1:PlayerEvent) : void {
			if(param1.data.isAdd as Boolean) {
				switch(param1.data.status) {
					case StatusEnum.ALREADY_READY:
						this.tryLoadSubtitle();
						this.adjustSubtitle();
						break;
					case StatusEnum.ALREADY_PLAY:
						this._needMask = false;
						this.drawBackground();
						break;
					case StatusEnum.PLAYING:
						this.setMaskBackground(false);
						break;
					case StatusEnum.STOPPING:
					case StatusEnum.STOPED:
						this._subtitleTF.text = "";
						this.setMaskBackground(false);
						break;
				}
			}
		}
		
		private function onRenderAreaChanged(param1:PlayerEvent) : void {
			this.adjustSubtitle();
			this.adjustLogo();
			this.adjustBrand();
			this.drawBackground();
		}
		
		private function onRenderADAreaChanged(param1:PlayerEvent) : void {
			this.drawBackground();
		}
		
		private function onEnterFrame(param1:Event) : void {
			var _loc2_:Sentence = null;
			this._frameCount++;
			if(this._frameCount % 5 == 0) {
				this._frameCount = 0;
				if((this._player.hasStatus(StatusEnum.PLAYING)) || (this._player.hasStatus(StatusEnum.ALREADY_PLAY)) && (this._player.hasStatus(StatusEnum.PAUSED))) {
					if(this._subtitleDummy.hasSentence()) {
						_loc2_ = this._subtitleDummy.findSentence(this._player.currentTime);
						if(!(_loc2_ == null) && !(_loc2_.content == null)) {
							if(_loc2_.content != this._subtitleTF.text) {
								this._subtitleTF.text = _loc2_.content;
								this.adjustSubtitle();
							}
						} else {
							this._subtitleTF.text = "";
						}
					}
				}
			}
		}
		
		private function onAddToStage(param1:Event) : void {
			removeEventListener(Event.ADDED_TO_STAGE,this.onAddToStage);
			this._stage = stage;
			this._stage.addEventListener(KeyboardEvent.KEY_DOWN,this.onStageKey);
		}
		
		private function onStageKey(param1:KeyboardEvent) : void {
			var file:FileReference = null;
			var logs:String = null;
			var event:KeyboardEvent = param1;
			try {
				file = null;
				logs = "";
				if((event.altKey) && (event.ctrlKey) && event.keyCode == Keyboard.F8) {
					file = new FileReference();
					logs = LogManager.getLifeLogs().join("\n");
					file.save(logs,"Log.txt");
				} else {
					this._key = this._key + String.fromCharCode(event.charCode);
					if(this.BOSS_KEY.indexOf(this._key) == -1) {
						this._key = "";
					} else if(this._key == this.BOSS_KEY) {
						Settings.instance.boss = true;
					}
					
					this._logKey = this._logKey + String.fromCharCode(event.charCode);
					if(this.LOG_KEY.indexOf(this._logKey) == -1) {
						this._logKey = "";
					} else if(this._logKey == this.LOG_KEY) {
						file = new FileReference();
						logs = LogManager.getLifeLogs().join("\n");
						file.save(logs,"Log.txt");
					}
					
				}
			}
			catch(e:Error) {
			}
		}
		
		private function onLogoComplete(param1:Event) : void {
			this._logoLoader.removeEventListener(LogoLoader.Evt_Complete,this.onLogoComplete);
			this.setLogo(this._logoLoader.getLogo());
			this._logoLoader = null;
		}
		
		private function onLogoChanged(param1:Event) : void {
			var index:int = 0;
			var event:Event = param1;
			if((this._brand) && (this._logo) && this._logo is MovieClip) {
				if(this._brand.parent) {
					this._brand.parent.removeChild(this._brand);
				}
				index = MovieClip(this._logo).initLogo;
				if(index == 2) {
					try {
						MovieClip(this._brand.content).gotoAndPlay(1);
					}
					catch(e:Error) {
					}
					addChild(this._brand);
				}
			}
		}
	}
}
