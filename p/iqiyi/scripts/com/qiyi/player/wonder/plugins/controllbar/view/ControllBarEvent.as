package com.qiyi.player.wonder.plugins.controllbar.view
{
	import com.qiyi.player.wonder.common.event.CommonEvent;
	
	public class ControllBarEvent extends CommonEvent
	{
		
		public static const Evt_Open:String = "evtControllBarOpen";
		
		public static const Evt_Close:String = "evtControllBarClose";
		
		public static const Evt_Seek:String = "evtControllBarSeek";
		
		public static const Evt_VolumeChanged:String = "evtVolumeBarChanged";
		
		public static const Evt_VolumeMuteChanged:String = "evtVolumeBarMuteChanged";
		
		public static const Evt_RepeatBtnClicked:String = "evtRepeatBtnClicked";
		
		public static const Evt_NextVideoBtnClicked:String = "evtNextVideoBtnClicked";
		
		public static const Evt_TvListBtnClicked:String = "evtTvListBtnClicked";
		
		public static const Evt_DefinitionBtnClicked:String = "evtDefinitionBtnClicked";
		
		public static const Evt_DefinitionBtnLocationChange:String = "evtDefinitionBtnLocationChange";
		
		public static const Evt_SettingBtnClicked:String = "evtSettingBtnClicked";
		
		public static const Evt_ImagePreviewMouseStateChange:String = "evtImagePreviewMouseStateChange";
		
		public static const Evt_ImagePreViewGoodsClick:String = "evtImagePreviewGoodsClick";
		
		public static const Evt_ImagePreItemClick:String = "evtImagePreItemClick";
		
		public static const Evt_ImagePreviewVedioShow:String = "evtImagePreviewVideoShow";
		
		public static const Evt_FilterOpenClick:String = "evtFilterOpenClick";
		
		public static const Evt_FilterCloseClick:String = "evtFilterCloseClick";
		
		public static const Evt_D3BtnClick:String = "evtD3BtnClick";
		
		public static const Evt_CaptionOrTrackBtnClick:String = "evtCaptionOrTrackBtnClick";
		
		public function ControllBarEvent(param1:String, param2:Object = null)
		{
			super(param1,param2);
		}
	}
}
