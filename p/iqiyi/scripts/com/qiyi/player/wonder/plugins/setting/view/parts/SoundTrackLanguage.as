package com.qiyi.player.wonder.plugins.setting.view.parts
{
	import flash.display.Sprite;
	import flash.text.TextField;
	import com.qiyi.player.wonder.common.ui.SelectTextField;
	import com.qiyi.player.core.model.IAudioTrackInfo;
	import com.qiyi.player.base.pub.EnumItem;
	import flash.events.MouseEvent;
	import com.qiyi.player.wonder.common.utils.ChineseNameOfLangAudioDef;
	import com.qiyi.player.core.model.impls.pub.Settings;
	import com.qiyi.player.wonder.plugins.setting.view.SettingEvent;
	import com.qiyi.player.wonder.plugins.setting.SettingDef;
	import com.qiyi.player.wonder.common.ui.FastCreator;
	
	public class SoundTrackLanguage extends Sprite
	{
		
		private var _label:TextField;
		
		private var _subtitlesTypeVector:Vector.<SelectTextField>;
		
		private var _soundTrackLangVector:Vector.<IAudioTrackInfo>;
		
		private var _currSoundTrackLang:EnumItem;
		
		public function SoundTrackLanguage()
		{
			super();
			this.mouseEnabled = false;
			this._soundTrackLangVector = new Vector.<IAudioTrackInfo>();
			this._subtitlesTypeVector = new Vector.<SelectTextField>();
			this._label = FastCreator.createLabel("音轨语言 : ",13421772,14);
			addChild(this._label);
		}
		
		public function get soundTrackLangVector() : Vector.<IAudioTrackInfo>
		{
			return this._soundTrackLangVector;
		}
		
		public function set soundTrackLangVector(param1:Vector.<IAudioTrackInfo>) : void
		{
			var _loc3:SelectTextField = null;
			var _loc5:uint = 0;
			var _loc6:SelectTextField = null;
			this._soundTrackLangVector = param1;
			if(!this._soundTrackLangVector)
			{
				return;
			}
			while(this._subtitlesTypeVector.length > 0)
			{
				_loc6 = this._subtitlesTypeVector.shift();
				removeChild(_loc6);
				_loc6.removeEventListener(MouseEvent.CLICK,this.onItemClick);
				_loc6.destroy();
				_loc6 = null;
			}
			var _loc2:Number = this._label.width + this._label.x + 10;
			var _loc4:* = false;
			_loc5 = 0;
			while(_loc5 < this._soundTrackLangVector.length)
			{
				_loc3 = new SelectTextField(ChineseNameOfLangAudioDef.getAudioName(this._soundTrackLangVector[_loc5].type),14);
				_loc3.x = _loc2;
				_loc3.y = this._label.y - _loc3.height + 24;
				_loc2 = _loc2 + _loc3.width + 10;
				_loc3.data = this._soundTrackLangVector[_loc5].type;
				this._subtitlesTypeVector.push(_loc3);
				addChild(_loc3);
				if(Settings.instance.audioTrack == this._soundTrackLangVector[_loc5].type)
				{
					_loc4 = _loc3.isSelected = true;
					this._currSoundTrackLang = this._soundTrackLangVector[_loc5].type;
				}
				_loc3.addEventListener(MouseEvent.CLICK,this.onItemClick);
				_loc5++;
			}
			if(!_loc4 && this._subtitlesTypeVector.length > 0)
			{
				this._subtitlesTypeVector[0].isSelected = true;
				this._currSoundTrackLang = this._subtitlesTypeVector[0].data as EnumItem;
			}
		}
		
		private function onItemClick(param1:MouseEvent) : void
		{
			var _loc3:SelectTextField = null;
			var _loc2:SelectTextField = param1.currentTarget as SelectTextField;
			for each(_loc3 in this._subtitlesTypeVector)
			{
				_loc3.isSelected = false;
				if(_loc3 == _loc2)
				{
					_loc3.isSelected = true;
				}
			}
			dispatchEvent(new SettingEvent(SettingEvent.Evt_AudioTrackChanged,_loc2.data));
		}
		
		public function close() : void
		{
			dispatchEvent(new SettingEvent(SettingEvent.Evt_AudioTrackChanged,this._currSoundTrackLang));
		}
		
		public function resetClick() : void
		{
			var _loc1:uint = 0;
			while(_loc1 < this._subtitlesTypeVector.length)
			{
				this._subtitlesTypeVector[_loc1].isSelected = false;
				if(_loc1 == SettingDef.DEFAULT_SOUND_TRACK_INDEX)
				{
					this._subtitlesTypeVector[_loc1].isSelected = true;
					dispatchEvent(new SettingEvent(SettingEvent.Evt_AudioTrackChanged,this._subtitlesTypeVector[_loc1].data));
				}
				_loc1++;
			}
		}
	}
}
