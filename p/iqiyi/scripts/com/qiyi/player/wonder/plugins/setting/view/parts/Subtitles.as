package com.qiyi.player.wonder.plugins.setting.view.parts
{
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
	
	public class Subtitles extends Sprite
	{
		
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
		
		public function Subtitles()
		{
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
		
		public function initSubtitles(param1:Vector.<Language>) : void
		{
			this._subtitlesLanguageData = param1;
			if(!this._subtitlesLanguageData)
			{
				return;
			}
			var _loc2:Language = new Language();
			_loc2.isDefault = false;
			_loc2.lang = LanguageEnum.NOTHING;
			_loc2.url = "";
			this._subtitlesLanguageData.push(_loc2);
			this.initSubtitlesLanguage();
			this.initSubtitlesColor();
			this.initSubtitlesFontSize();
		}
		
		private function initSubtitlesColor() : void
		{
			var _loc2:SelectTextField = null;
			var _loc5:SelectTextField = null;
			while(this._subtitlesColorItem.length > 0)
			{
				_loc5 = this._subtitlesColorItem.shift();
				removeChild(_loc5);
				_loc5.removeEventListener(MouseEvent.CLICK,this.onLanguageItemClick);
				_loc5.destroy();
				_loc5 = null;
			}
			var _loc1:Number = this._subtitlesColor.width + this._subtitlesColor.x + 10;
			var _loc3:* = false;
			var _loc4:uint = 0;
			while(_loc4 < SettingDef.FONT_COLOR_LIST.length)
			{
				_loc2 = new SelectTextField(SettingDef.FONT_COLOR_SHOW_LIST[_loc4],14);
				_loc2.x = _loc1;
				_loc2.y = this._subtitlesColor.y - _loc2.height + 24;
				_loc1 = _loc1 + _loc2.width + 10;
				_loc2.data = SettingDef.FONT_COLOR_LIST[_loc4];
				this._subtitlesColorItem.push(_loc2);
				addChild(_loc2);
				if(Settings.instance.subtitleColor == SettingDef.FONT_COLOR_LIST[_loc4])
				{
					_loc3 = _loc2.isSelected = true;
					this._currColor = SettingDef.FONT_COLOR_LIST[_loc4];
				}
				_loc2.addEventListener(MouseEvent.CLICK,this.onSubtitlesColorClick);
				_loc4++;
			}
			if(!_loc3 && this._subtitlesColorItem.length > 0)
			{
				this._subtitlesColorItem[0].isSelected = true;
				this._currColor = uint(this._subtitlesColorItem[0].data);
			}
		}
		
		private function initSubtitlesFontSize() : void
		{
			var _loc2:SelectTextField = null;
			var _loc5:SelectTextField = null;
			while(this._subtitlesFontSizeItem.length > 0)
			{
				_loc5 = this._subtitlesFontSizeItem.shift();
				removeChild(_loc5);
				_loc5.removeEventListener(MouseEvent.CLICK,this.onLanguageItemClick);
				_loc5.destroy();
				_loc5 = null;
			}
			var _loc1:Number = this._subtitlesFontSize.width + this._subtitlesFontSize.x + 10;
			var _loc3:* = false;
			var _loc4:* = 0;
			while(_loc4 < SettingDef.FONT_SIZE_LIST.length)
			{
				_loc2 = new SelectTextField("Aa",SettingDef.FONT_SIZE_LIST[_loc4]);
				_loc2.x = _loc1;
				_loc2.y = this._subtitlesFontSize.y - (_loc2.height - 24) + _loc4 * 2;
				_loc1 = _loc1 + _loc2.width + 10;
				_loc2.data = SettingDef.FONT_SIZE_LIST[_loc4];
				this._subtitlesFontSizeItem.push(_loc2);
				addChild(_loc2);
				if(Settings.instance.subtitleSize == SettingDef.FONT_SIZE_LIST[_loc4])
				{
					_loc3 = _loc2.isSelected = true;
					this._currFontSize = SettingDef.FONT_SIZE_LIST[_loc4];
				}
				_loc2.addEventListener(MouseEvent.CLICK,this.onFontSizeItemClick);
				_loc4++;
			}
			if(!_loc3 && this._subtitlesFontSizeItem.length > 0)
			{
				this._subtitlesFontSizeItem[SettingDef.DEFAULT_SUBTITLE_SIZE_INDEX].isSelected = true;
				this._currFontSize = uint(this._subtitlesFontSizeItem[SettingDef.DEFAULT_SUBTITLE_SIZE_INDEX].data);
			}
		}
		
		private function initSubtitlesLanguage() : void
		{
			var _loc2:SelectTextField = null;
			var _loc5:SelectTextField = null;
			while(this._subtitlesLanguageItem.length > 0)
			{
				_loc5 = this._subtitlesLanguageItem.shift();
				removeChild(_loc5);
				_loc5.removeEventListener(MouseEvent.CLICK,this.onLanguageItemClick);
				_loc5.destroy();
				_loc5 = null;
			}
			var _loc1:Number = this._subtitlesLanguage.width + this._subtitlesLanguage.x + 10;
			var _loc3:* = false;
			var _loc4:uint = 0;
			while(_loc4 < this._subtitlesLanguageData.length)
			{
				_loc2 = new SelectTextField(ChineseNameOfLangAudioDef.getLanguageName(this._subtitlesLanguageData[_loc4].lang),14);
				_loc2.x = _loc1;
				_loc2.y = this._subtitlesLanguage.y - _loc2.height + 24;
				_loc1 = _loc1 + _loc2.width + 10;
				_loc2.data = this._subtitlesLanguageData[_loc4].lang;
				this._subtitlesLanguageItem.push(_loc2);
				addChild(_loc2);
				if(!_loc3 && this._subtitlesLanguageData[_loc4].lang == Settings.instance.subtitleLang)
				{
					_loc3 = _loc2.isSelected = true;
					this._currLanguage = this._subtitlesLanguageData[_loc4].lang;
				}
				_loc2.addEventListener(MouseEvent.CLICK,this.onLanguageItemClick);
				_loc4++;
			}
			if(!_loc3 && this._subtitlesLanguageItem.length > 0)
			{
				this._subtitlesLanguageItem[0].isSelected = true;
				this._currLanguage = this._subtitlesLanguageItem[0].data as EnumItem;
			}
		}
		
		private function onLanguageItemClick(param1:MouseEvent) : void
		{
			var _loc3:SelectTextField = null;
			var _loc2:SelectTextField = param1.currentTarget as SelectTextField;
			for each(_loc3 in this._subtitlesLanguageItem)
			{
				_loc3.isSelected = false;
				if(_loc3 == _loc2)
				{
					_loc3.isSelected = true;
				}
			}
			dispatchEvent(new SettingEvent(SettingEvent.Evt_TitleLanguageChanged,_loc2.data));
		}
		
		private function onSubtitlesColorClick(param1:MouseEvent) : void
		{
			var _loc3:SelectTextField = null;
			var _loc2:SelectTextField = param1.currentTarget as SelectTextField;
			for each(_loc3 in this._subtitlesColorItem)
			{
				_loc3.isSelected = false;
				if(_loc3 == _loc2)
				{
					_loc3.isSelected = true;
				}
			}
			dispatchEvent(new SettingEvent(SettingEvent.Evt_TitleFontColorChanged,_loc2.data));
		}
		
		private function onFontSizeItemClick(param1:MouseEvent) : void
		{
			var _loc3:SelectTextField = null;
			var _loc2:SelectTextField = param1.currentTarget as SelectTextField;
			for each(_loc3 in this._subtitlesFontSizeItem)
			{
				_loc3.isSelected = false;
				if(_loc3 == _loc2)
				{
					_loc3.isSelected = true;
				}
			}
			dispatchEvent(new SettingEvent(SettingEvent.Evt_TitleFontSizeChanged,_loc2.data));
		}
		
		public function close() : void
		{
			dispatchEvent(new SettingEvent(SettingEvent.Evt_TitleFontSizeChanged,this._currFontSize));
			dispatchEvent(new SettingEvent(SettingEvent.Evt_TitleFontColorChanged,this._currColor));
			dispatchEvent(new SettingEvent(SettingEvent.Evt_TitleLanguageChanged,this._currLanguage));
		}
		
		public function resetClick() : void
		{
			var _loc1:uint = 0;
			_loc1 = 0;
			while(_loc1 < this._subtitlesFontSizeItem.length)
			{
				this._subtitlesFontSizeItem[_loc1].isSelected = false;
				if(_loc1 == SettingDef.DEFAULT_SUBTITLE_SIZE_INDEX)
				{
					this._subtitlesFontSizeItem[_loc1].isSelected = true;
					dispatchEvent(new SettingEvent(SettingEvent.Evt_TitleFontSizeChanged,SettingDef.FONT_SIZE_LIST[_loc1]));
				}
				_loc1++;
			}
			_loc1 = 0;
			while(_loc1 < this._subtitlesColorItem.length)
			{
				this._subtitlesColorItem[_loc1].isSelected = false;
				if(_loc1 == SettingDef.DEFAULT_SUBTITLE_COLOR_INDEX)
				{
					this._subtitlesColorItem[_loc1].isSelected = true;
					dispatchEvent(new SettingEvent(SettingEvent.Evt_TitleFontColorChanged,this._subtitlesColorItem[_loc1].data));
				}
				_loc1++;
			}
			_loc1 = 0;
			while(_loc1 < this._subtitlesLanguageItem.length)
			{
				this._subtitlesLanguageItem[_loc1].isSelected = false;
				if(_loc1 == SettingDef.DEFAULT_SUBTITLE_LANG_INDEX)
				{
					this._subtitlesLanguageItem[_loc1].isSelected = true;
					dispatchEvent(new SettingEvent(SettingEvent.Evt_TitleLanguageChanged,this._subtitlesLanguageItem[_loc1].data));
				}
				_loc1++;
			}
		}
	}
}
