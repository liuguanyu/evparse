package pptv.skin.view.events
{
   import flash.events.Event;
   
   public class SkinEvent extends Event
   {
      
      public static const MEDIA_PAUSE:String = "media_pause";
      
      public static const MEDIA_PLAY:String = "media_play";
      
      public static const MEDIA_STOP:String = "media_stop";
      
      public static const MEDIA_THEATRE:String = "media_theatre";
      
      public static const MEDIA_BARRAGE:String = "media_barrage";
      
      public static const MEDIA_SETUP_BARRAGE:String = "media_setup_barrage";
      
      public static const MEDIA_SOUND:String = "media_sound";
      
      public static const MEDIA_SETTING:String = "media_setting";
      
      public static const MEDIA_ICON:String = "media_icon";
      
      public static const MEDIA_CHANGE_STREAM:String = "media_change_stream";
      
      public static const MEDIA_HUE:String = "media_hue";
      
      public static const MEDIA_CODE:String = "media_code";
      
      public static const MEDIA_SHARE:String = "media_share";
      
      public static const MEDIA_OPTION:String = "meida_option";
      
      public static const MEDIA_VOD_POSITION:String = "media_vod_position";
      
      public static const MEDIA_PREVIEW_SNAPSHOT:String = "media_preview_snapshot";
      
      public static const MEDIA_SHARE_EDITOR:String = "media_share_editor";
      
      public static const LAYOUT_SUCCESS:String = "layout_success";
      
      public static const MEDIA_LOGO:String = "media_logo";
      
      public static const MEDIA_HREF:String = "media_href";
      
      public static const MEDIA_ADJUST:String = "media_adjust";
      
      public static const MEDIA_SEARCH:String = "media_search";
      
      public static const MEDIA_STREAM:String = "media_stream";
      
      public static const MEDIA_NEXT:String = "media_next";
      
      public static const MEDIA_ACCELERATE:String = "media_accelerate";
      
      public static const MEDIA_SMARTCLICK:String = "media_smartclick";
      
      public static const MEDIA_RECOMMEND_CLICK:String = "media_recommend_click";
      
      public static const MEDIA_SHOW_SUBSETTING:String = "media_show_subsetting";
      
      public static const MEDIA_SUBTITLE_SETTING:String = "media_subtitle_setting";
      
      public static const MEDIA_SUBTITLE_CHANGE:String = "media_subtitle_change";
      
      private var _currObj:Object = null;
      
      public function SkinEvent(param1:String, param2:Object = null, param3:Boolean = false, param4:Boolean = false)
      {
         super(param1,param3,param4);
         this._currObj = param2;
      }
      
      public function get currObj() : Object
      {
         return this._currObj;
      }
      
      public function set currObj(param1:Object) : void
      {
         this._currObj = param1;
      }
   }
}
