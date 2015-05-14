package com.qiyi.player.wonder.common.utils
{
	import com.qiyi.player.base.pub.EnumItem;
	import com.qiyi.player.core.model.def.LanguageEnum;
	import com.qiyi.player.core.model.def.AudioTrackEnum;
	import com.qiyi.player.core.model.def.DefinitionEnum;
	
	public class ChineseNameOfLangAudioDef extends Object
	{
		
		public function ChineseNameOfLangAudioDef()
		{
			super();
		}
		
		public static function getLanguageName(param1:EnumItem) : String
		{
			switch(param1)
			{
				case LanguageEnum.CHINESE:
					return "中文";
				case LanguageEnum.TRADITIONAL:
					return "繁体";
				case LanguageEnum.ENGLISH:
					return "英文";
				case LanguageEnum.KOREAN:
					return "韩文";
				case LanguageEnum.JAPANESE:
					return "日文";
				case LanguageEnum.FRENCH:
					return "法文";
				case LanguageEnum.RUSSIAN:
					return "俄文";
				case LanguageEnum.NOTHING:
					return "无字幕";
				case LanguageEnum.CHINESE_AND_ENGLISH:
					return "中英文";
				case LanguageEnum.CHINESE_AND_JAPANESE:
					return "中日文";
				case LanguageEnum.CHINESE_AND_FRENCH:
					return "中法文";
				case LanguageEnum.CHINESE_AND_RUSSIAN:
					return "中俄文";
				default:
					return "";
			}
		}
		
		public static function getAudioName(param1:EnumItem) : String
		{
			switch(param1)
			{
				case AudioTrackEnum.CHINESE:
					return "国语";
				case AudioTrackEnum.CANTONESE:
					return "粤语";
				case AudioTrackEnum.ENGLISH:
					return "英语";
				case AudioTrackEnum.FRENCH:
					return "法语";
				case AudioTrackEnum.JAPANESE:
					return "日语";
				case AudioTrackEnum.KOREAN:
					return "韩语";
				case AudioTrackEnum.RUSSIAN:
					return "俄语";
				case AudioTrackEnum.NONE:
					return "无";
				default:
					return "";
			}
		}
		
		public static function getDefinitionName(param1:EnumItem) : String
		{
			switch(param1)
			{
				case DefinitionEnum.NONE:
					break;
				case DefinitionEnum.LIMIT:
					return "极速";
				case DefinitionEnum.STANDARD:
					return "流畅";
				case DefinitionEnum.HIGH:
					return "高清";
				case DefinitionEnum.SUPER:
				case DefinitionEnum.SUPER_HIGH:
					return "超清720P";
				case DefinitionEnum.FULL_HD:
					return "1080P";
				case DefinitionEnum.FOUR_K:
					return "4K";
			}
			return "";
		}
	}
}
