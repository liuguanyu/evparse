package com.qiyi.player.wonder.plugins.setting.view.parts {
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
	
	public class SoundTrackLanguage extends Sprite {
		
		public function SoundTrackLanguage() {
			super();
			this.mouseEnabled = false;
			this._soundTrackLangVector = new Vector.<IAudioTrackInfo>();
			this._subtitlesTypeVector = new Vector.<SelectTextField>();
			this._label = FastCreator.createLabel("音轨语言 : ",13421772,14);
			addChild(this._label);
		}
		
		private var _label:TextField;
		
		private var _subtitlesTypeVector:Vector.<SelectTextField>;
		
		private var _soundTrackLangVector:Vector.<IAudioTrackInfo>;
		
		private var _currSoundTrackLang:EnumItem;
		
		public function get soundTrackLangVector() : Vector.<IAudioTrackInfo> {
			return this._soundTrackLangVector;
		}
		
		public function set soundTrackLangVector(param1:Vector.<IAudioTrackInfo>) : void {
			/*
			 * Decompilation error
			 * Code may be obfuscated
			 * Deobfuscation is activated but decompilation still failed. If the file is NOT obfuscated, disable "Automatic deobfuscation" for better results.
			 * Error type: TranslateException
			 */
			throw new flash.errors.IllegalOperationError("Not decompiled due to error");
		}
		
		private function onItemClick(param1:MouseEvent) : void {
			var _loc3_:SelectTextField = null;
			var _loc2_:SelectTextField = param1.currentTarget as SelectTextField;
			for each(_loc3_ in this._subtitlesTypeVector) {
				_loc3_.isSelected = false;
				if(_loc3_ == _loc2_) {
					_loc3_.isSelected = true;
				}
			}
			dispatchEvent(new SettingEvent(SettingEvent.Evt_AudioTrackChanged,_loc2_.data));
		}
		
		public function close() : void {
			dispatchEvent(new SettingEvent(SettingEvent.Evt_AudioTrackChanged,this._currSoundTrackLang));
		}
		
		public function resetClick() : void {
			var _loc1_:uint = 0;
			while(_loc1_ < this._subtitlesTypeVector.length) {
				this._subtitlesTypeVector[_loc1_].isSelected = false;
				if(_loc1_ == SettingDef.DEFAULT_SOUND_TRACK_INDEX) {
					this._subtitlesTypeVector[_loc1_].isSelected = true;
					dispatchEvent(new SettingEvent(SettingEvent.Evt_AudioTrackChanged,this._subtitlesTypeVector[_loc1_].data));
				}
				_loc1_++;
			}
		}
	}
}