package com.qiyi.player.wonder.plugins.setting.view.parts {
	import flash.display.Sprite;
	import flash.text.TextField;
	import com.qiyi.player.wonder.common.ui.SelectTextField;
	import com.qiyi.player.base.pub.EnumItem;
	import com.qiyi.player.core.model.impls.subtitle.Language;
	import com.qiyi.player.core.model.def.LanguageEnum;
	import flash.events.MouseEvent;
	import com.qiyi.player.wonder.plugins.setting.SettingDef;
	import com.qiyi.player.core.model.impls.pub.Settings;
	import com.qiyi.player.wonder.common.utils.ChineseNameOfLangAudioDef;
	import com.qiyi.player.wonder.plugins.setting.view.SettingEvent;
	import com.qiyi.player.wonder.common.ui.FastCreator;
	
	public class Subtitles extends Sprite {
		
		public function Subtitles() {
			super();
			this.mouseEnabled = false;
			this._subtitlesLanguageItem = new Vector.<SelectTextField>();
			this._subtitlesLanguage = FastCreator.createLabel("字幕语言 : ",13421772,14);
			addChild(this._subtitlesLanguage);
			this._subtitlesColorItem = new Vector.<SelectTextField>();
			this._subtitlesColor = FastCreator.createLabel("字幕颜色 : ",13421772,14);
			this._subtitlesColor.y = this._subtitlesLanguage.y + 36;
			addChild(this._subtitlesColor);
			this._subtitlesFontSizeItem = new Vector.<SelectTextField>();
			this._subtitlesFontSize = FastCreator.createLabel("字幕大小 : ",13421772,14);
			this._subtitlesFontSize.y = this._subtitlesColor.y + 36;
			addChild(this._subtitlesFontSize);
		}
		
		private var _subtitlesColor:TextField;
		
		private var _subtitlesColorItem:Vector.<SelectTextField>;
		
		private var _subtitlesFontSize:TextField;
		
		private var _subtitlesFontSizeItem:Vector.<SelectTextField>;
		
		private var _subtitlesLanguage:TextField;
		
		private var _subtitlesLanguageItem:Vector.<SelectTextField>;
		
		private var _currColor:uint;
		
		private var _currFontSize:uint;
		
		private var _currLanguage:EnumItem;
		
		private var _subtitlesLanguageData:Vector.<Language>;
		
		public function initSubtitles(param1:Vector.<Language>) : void {
			this._subtitlesLanguageData = param1;
			if(!this._subtitlesLanguageData) {
				return;
			}
			var _loc2_:Language = new Language();
			_loc2_.isDefault = false;
			_loc2_.lang = LanguageEnum.NOTHING;
			_loc2_.url = "";
			this._subtitlesLanguageData.push(_loc2_);
			this.initSubtitlesLanguage();
			this.initSubtitlesColor();
			this.initSubtitlesFontSize();
		}
		
		private function initSubtitlesColor() : void {
			/*
			 * Decompilation error
			 * Code may be obfuscated
			 * Deobfuscation is activated but decompilation still failed. If the file is NOT obfuscated, disable "Automatic deobfuscation" for better results.
			 * Error type: TranslateException
			 */
			throw new flash.errors.IllegalOperationError("Not decompiled due to error");
		}
		
		private function initSubtitlesFontSize() : void {
			/*
			 * Decompilation error
			 * Code may be obfuscated
			 * Deobfuscation is activated but decompilation still failed. If the file is NOT obfuscated, disable "Automatic deobfuscation" for better results.
			 * Error type: TranslateException
			 */
			throw new flash.errors.IllegalOperationError("Not decompiled due to error");
		}
		
		private function initSubtitlesLanguage() : void {
			/*
			 * Decompilation error
			 * Code may be obfuscated
			 * Deobfuscation is activated but decompilation still failed. If the file is NOT obfuscated, disable "Automatic deobfuscation" for better results.
			 * Error type: TranslateException
			 */
			throw new flash.errors.IllegalOperationError("Not decompiled due to error");
		}
		
		private function onLanguageItemClick(param1:MouseEvent) : void {
			var _loc3_:SelectTextField = null;
			var _loc2_:SelectTextField = param1.currentTarget as SelectTextField;
			for each(_loc3_ in this._subtitlesLanguageItem) {
				_loc3_.isSelected = false;
				if(_loc3_ == _loc2_) {
					_loc3_.isSelected = true;
				}
			}
			dispatchEvent(new SettingEvent(SettingEvent.Evt_TitleLanguageChanged,_loc2_.data));
		}
		
		private function onSubtitlesColorClick(param1:MouseEvent) : void {
			var _loc3_:SelectTextField = null;
			var _loc2_:SelectTextField = param1.currentTarget as SelectTextField;
			for each(_loc3_ in this._subtitlesColorItem) {
				_loc3_.isSelected = false;
				if(_loc3_ == _loc2_) {
					_loc3_.isSelected = true;
				}
			}
			dispatchEvent(new SettingEvent(SettingEvent.Evt_TitleFontColorChanged,_loc2_.data));
		}
		
		private function onFontSizeItemClick(param1:MouseEvent) : void {
			var _loc3_:SelectTextField = null;
			var _loc2_:SelectTextField = param1.currentTarget as SelectTextField;
			for each(_loc3_ in this._subtitlesFontSizeItem) {
				_loc3_.isSelected = false;
				if(_loc3_ == _loc2_) {
					_loc3_.isSelected = true;
				}
			}
			dispatchEvent(new SettingEvent(SettingEvent.Evt_TitleFontSizeChanged,_loc2_.data));
		}
		
		public function close() : void {
			dispatchEvent(new SettingEvent(SettingEvent.Evt_TitleFontSizeChanged,this._currFontSize));
			dispatchEvent(new SettingEvent(SettingEvent.Evt_TitleFontColorChanged,this._currColor));
			dispatchEvent(new SettingEvent(SettingEvent.Evt_TitleLanguageChanged,this._currLanguage));
		}
		
		public function resetClick() : void {
			var _loc1_:uint = 0;
			_loc1_ = 0;
			while(_loc1_ < this._subtitlesFontSizeItem.length) {
				this._subtitlesFontSizeItem[_loc1_].isSelected = false;
				if(_loc1_ == SettingDef.DEFAULT_SUBTITLE_SIZE_INDEX) {
					this._subtitlesFontSizeItem[_loc1_].isSelected = true;
					dispatchEvent(new SettingEvent(SettingEvent.Evt_TitleFontSizeChanged,SettingDef.FONT_SIZE_LIST[_loc1_]));
				}
				_loc1_++;
			}
			_loc1_ = 0;
			while(_loc1_ < this._subtitlesColorItem.length) {
				this._subtitlesColorItem[_loc1_].isSelected = false;
				if(_loc1_ == SettingDef.DEFAULT_SUBTITLE_COLOR_INDEX) {
					this._subtitlesColorItem[_loc1_].isSelected = true;
					dispatchEvent(new SettingEvent(SettingEvent.Evt_TitleFontColorChanged,this._subtitlesColorItem[_loc1_].data));
				}
				_loc1_++;
			}
			_loc1_ = 0;
			while(_loc1_ < this._subtitlesLanguageItem.length) {
				this._subtitlesLanguageItem[_loc1_].isSelected = false;
				if(_loc1_ == SettingDef.DEFAULT_SUBTITLE_LANG_INDEX) {
					this._subtitlesLanguageItem[_loc1_].isSelected = true;
					dispatchEvent(new SettingEvent(SettingEvent.Evt_TitleLanguageChanged,this._subtitlesLanguageItem[_loc1_].data));
				}
				_loc1_++;
			}
		}
	}
}
