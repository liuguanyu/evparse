package com.letv.pluginsAPI.kernel
{
   public class PlayerError extends Error
   {
      
      public static const API_CALL_ERROR:String = "apiCallError";
      
      public static const VIDEO_NONE_ERROR:String = "10";
      
      public static const AUTH_OVERSEA_ERROR:String = "11";
      
      public static const BLACK_LIST_ERROR:String = "12";
      
      public static const VIDEO_EDIT_ERROR:String = "13";
      
      public static const VIDEO_RIGHT_ERROR:String = "14";
      
      public static const AUTH_CN_ERROR:String = "15";
      
      public static const AUTH_HK_ERROR:String = "16";
      
      public static const PLUGINS_IO_ERROR:String = "420";
      
      public static const PLUGINS_TIMEOUT_ERROR:String = "421";
      
      public static const PLUGINS_SECURITY_ERROR:String = "422";
      
      public static const PLUGINS_ANALY_ERROR:String = "423";
      
      public static const PLUGINS_OTHER_ERROR:String = "429";
      
      public static const AD_TIMEOUT:String = "31";
      
      public static const AD_PLUGIN_IO_ERROR:String = "40";
      
      public static const AD_PLUGIN_TIMEOUT_ERROR:String = "41";
      
      public static const AD_PLUGIN_SECURITY_ERROR:String = "42";
      
      public static const AD_PLUGIN_ANALY_ERROR:String = "43";
      
      public static const AD_PLUGIN_OTHER_ERROR:String = "49";
      
      public static const AD_IO_ERROR:String = "450";
      
      public static const AD_TIMEOUT_ERROR:String = "451";
      
      public static const AD_SECURITY_ERROR:String = "452";
      
      public static const AD_ANALY_ERROR:String = "453";
      
      public static const AD_OTHER_ERROR:String = "459";
      
      public static const GSLB_IO_ERROR:String = "470";
      
      public static const GSLB_TIMEOUT_ERROR:String = "471";
      
      public static const GSLB_SECURITY_ERROR:String = "472";
      
      public static const GSLB_ANALY_ERROR:String = "473";
      
      public static const GSLB_EXPIRED_ERROR:String = "474";
      
      public static const GSLB_OTHER_ERROR:String = "479";
      
      public static const PLAY_HTTP_TS_IO_ERROR:String = "480";
      
      public static const PLAY_HTTP_TS_TIMEOUT_ERROR:String = "481";
      
      public static const PLAY_HTTP_TS_SECURITY_ERROR:String = "482";
      
      public static const PLAY_HTTP_TS_ANALY_ERROR:String = "483";
      
      public static const PLAY_HTTP_TS_OTHER_ERROR:String = "484";
      
      public static const PLAY_HTTP_TIMEOUT_ERROR:String = "485";
      
      public static const P2P_M3U8_ERROR:String = "486";
      
      public static const P2P_PLAY_ERROR:String = "487";
      
      public static const P2P_TIMEOUT_ERROR:String = "488";
      
      public static const P2P_PLAY_OTHER_ERROR:String = "489";
      
      public static const PLAY_HTTP_M3U8_IO_ERROR:String = "490";
      
      public static const PLAY_HTTP_M3U8_TIMEOUT_ERROR:String = "491";
      
      public static const PLAY_HTTP_M3U8_SECURITY_ERROR:String = "492";
      
      public static const PLAY_HTTP_M3U8_ANALY_ERROR:String = "493";
      
      public static const PLAY_HTTP_M3U8_OTHER_ERROR:String = "494";
      
      public static const PLUGIN_LOAD_IO_ERROR:String = "540";
      
      public static const PLUGIN_LOAD_TIMEOUT_ERROR:String = "541";
      
      public static const PLUGIN_LOAD_SECURITY_ERROR:String = "542";
      
      public static const PLUGIN_LOAD_ANALY_ERROR:String = "543";
      
      public static const PLUGIN_LOAD_OTHER_ERROR:String = "549";
      
      public static const NEW_MMSID_IO_ERROR:String = "550";
      
      public static const NEW_MMSID_TIMEOUT_ERROR:String = "551";
      
      public static const NEW_MMSID_SECURITY_ERROR:String = "552";
      
      public static const NEW_MMSID_ANALY_ERROR:String = "553";
      
      public static const NEW_MMSID_AUTHTYPE_ERROR:String = "554";
      
      public static const INPUT_ERROR:String = "555";
      
      public static const NEW_MMSID_SERVER_ERROR:String = "558";
      
      public static const NEW_MMSID_OTHER_ERROR:String = "559";
      
      public static const AD_BLOCK_PLUGIN:String = "560";
      
      public static const AD_BLOCK_SYSTEM:String = "561";
      
      public static const AD_BLOCK_ENV:String = "562";
      
      public static const FLASH_PLAYER_WARNING:String = "998";
      
      public static const OTHER_ERROR:String = "999";
      
      public static const NORMAL:String = "0";
      
      public function PlayerError(param1:* = "", param2:int = 0)
      {
         super(param1,param2);
      }
   }
}
