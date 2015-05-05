package com
{
   import flash.events.Event;
   
   public class playerEvents extends Event
   {
      
      public static var SKIN_LOADED:String = "SKIN_LOADED";
      
      public static var SKIN_ERROR:String = "SKIN_ERROR";
      
      public static var SKIN_PROGRESS:String = "SKIN_PROGRESS";
      
      public static var PARMS_READY:String = "PARMS_READY";
      
      public static var PARMS_ERROR:String = "PARMS_ERROR";
      
      public static var META_READY:String = "META_READY";
      
      public static var STREAM_TIME:String = "STREAM_TIME";
      
      public static var MUTIBIT_READY:String = "MUTIBIT_READY";
      
      public static var MUTIBIT_ERROR:String = "MUTIBIT_ERROR";
      
      public static var PLAYURL_READY:String = "PLAYURL_READY";
      
      public static var PLAYURL_READY_RE:String = "PLAYURL_READY_RE";
      
      public static var PLAYURL_ERROR:String = "PLAYURL_ERROR";
      
      public static var BITSET_CHANGE:String = "BITSET_CHANGE";
      
      public static var BITSET_CHANGE_OK:String = "BITSET_CHANGE_OK";
      
      public static var CONTORL_PAUSE:String = "CONTORL_PAUSE";
      
      public static var CONTORL_START:String = "CONTORL_START";
      
      public static var CONTORL_RESTART:String = "CONTORL_RESTART";
      
      public static var PLAYCORE_COMPLETE:String = "PLAYCORE_COMPLETE";
      
      public static var AD_BACK_COMPLETE:String = "AD_BACK_COMPLETE";
      
      public static var CONTORL_SEEKSTART:String = "CONTORL_SEEKSTART";
      
      public static var PLAYCORE_SEEKEND:String = "PLAYCORE_SEEKEND";
      
      public static var BUFF_START:String = "BUFF_START";
      
      public static var BUFF_END:String = "BUFF_END";
      
      public static var AUTH_START:String = "AUTH_START";
      
      public static var AUTH_END:String = "AUTH_END";
      
      public static var CONTORL_SETVOLUME:String = "CONTORL_SETVOLUME";
      
      public static var SET_VOLUME_VALUE:String = "SET_VOLUME_VALUE";
      
      public static var CONTORL_LIGHTSET:String = "CONTORL_LIGHTSET";
      
      public static var CONTORL_SIZE:String = "CONTORL_SIZE";
      
      public static var CONTORL_SKIP_HEADEND:String = "CONTORL_SKIP_HEADEND";
      
      public static var CONTORL_ZOOM:String = "CONTORL_ZOOM";
      
      public static var CONTORL_SET_ZOOM_BY_FULL_AND_WINDOWS_BTN:String = "CONTORL_SET_ZOOM_BY_FULL_AND_WINDOWS_BTN";
      
      public static var CONTORL_HEADTIME:String = "CONTORL_HEADTIME";
      
      public static var CONTORL_TAILTIME:String = "CONTORL_TAILTIME";
      
      public static var CONTORL_PHOTOPAN:String = "CONTORL_PHOTOPAN";
      
      public static var CONTORL_TOOLPAN_SHOW:String = "CONTORL_TOOLPAN_SHOW";
      
      public static var CONTORL_TOOLPAN_HIDE:String = "CONTORL_TOOLPAN_HIDE";
      
      public static var VALUE_CHANGE:String = "VALUE_CHANGE";
      
      public static var VALUE_OK:String = "VALUE_OK";
      
      public static var VALUE_CANCEL:String = " VALUE_CANCEL";
      
      public static var GET_REFURL:String = "GET_REFURL";
      
      public static var GET_REFURL_OVER:String = "GET_REFURL_OVER";
      
      public static var KEY_LEFT:String = "KEY_LEFT";
      
      public static var KEY_RIGHT:String = "KEY_RIGHT";
      
      public static var KEY_UP:String = "KEY_UP";
      
      public static var KEY_DOWN:String = "KEY_DOWN";
      
      public static var KEY_SHOWTIP:String = "KEY_SHOWTIP";
      
      public static var P2P_ERROR:String = "P2P_ERROR";
      
      public static var P2P_READY:String = "P2P_READY";
      
      public static var AD_START:String = "AD_START";
      
      public static var AD_OVER:String = "AD_OVER";
      
      public static var AD_LOADING:String = "AD_LOADING";
      
      public static var AD_LOADED:String = "AD_LOADED";
      
      public static var AD_LOADFAIL:String = "AD_LOADFAIL";
      
      public static var AD_PLAYBEGIN:String = "AD_PLAYBEGIN";
      
      public static var AD_PLAYEND:String = "AD_PLAYEND";
      
      public static var MSG_SHOW:String = "MSG_SHOW";
      
      public static var POINTPAN_SHOW:String = "POINT_SHOW";
      
      public static var POINTPAN_DEL:String = "POINTPAN_DEL";
      
      public static var BTNLIST_SETVALUE:String = "BTNLIST_SETVALUE";
      
      public static var SHOW_LIST:String = "SHOW_LIST";
      
      public static var MOVIE_INFO:String = "MOVIE_INFO";
      
      public static var LOADING_START:String = "LOADING_START";
      
      public static var LOADING_END:String = "LOADING_END";
      
      public static var AUTO_HIDE_CONTROL_PANEL:String = "AUTO_HIDE_CONTROL_PANEL";
      
      public static var MAIN_OPT_TIP:String = "MAIN_OPT_TIP";
      
      public static var PAUSE_ANIM_SHOW:String = "PAUSE_ANIM_SHOW";
      
      public static var FULL_SCREEN_MASK:String = "FULL_SCREEN_MASK";
      
      public static var PLAY_INFO:String = "PLAY_INFO";
      
      public static var SEARCH_EVENT:String = "SEARCH_EVENT";
      
      public static var VIDEO_REPLAY:String = "VIDEO_REPLAY";
      
      public static var IP_LEGAL:String = "IP_LEGAL";
      
      public static var IP_LEAGL_ERROR:String = "IP_LEAGL_ERROR";
      
      public static var PAID_MOVIE_BG:String = "PAID_MOVIE_BG";
      
      public static var TV_ERROR:String = "TV_ERROR";
      
      public static var STATION_OUTSIDE_VIP:String = "STATION_OUTSIDE_VIP";
      
      public static var SKIN_SKIP:String = "SKIN_SKIP";
      
      public static var STATISTICS_COMSCORE_START:String = "STATISTICS_COMSCORE_START";
      
      public static var STATISTICS_BIGDATA_PLAY:String = "STATISTICS_BIGDATA_PLAY";
      
      public static var STATISTICS_BIGDATA_OVER:String = "STATISTICS_BIGDATA_OVER";
      
      public static var STATISTICS_BIGDATA_RESUME:String = "STATISTICS_BIGDATA_RESUME";
      
      public static var STATISTICS_BIGDATA_FORWARD:String = "STATISTICS_BIGDATA_FORWARD";
      
      public static var STATISTICS_BIGDATA_BACKWARD:String = "STATISTICS_BIGDATA_BACKWARD";
      
      public static var STATISTICS_BIGDATA_DRAG:String = "STATISTICS_BIGDATA_DRAG";
      
      public static var STATISTICS_BIGDATA_BLOCK:String = "STATISTICS_BIGDATA_BLOCK";
      
      public static var STATISTICS_BIGDATA_BUFFER:String = "STATISTICS_BIGDATA_BUFFER";
      
      public static var STATISTICS_BIGDATA_ADBEGIN:String = "STATISTICS_BIGDATA_ADBEGIN";
      
      public static var STATISTICS_BIGDATA_ADEND:String = "STATISTICS_BIGDATA_ADEND";
      
      public static var STATISTICS_BIGDATA_HEARTBEAT:String = "STATISTICS_BIGDATA_HEARTBEAT";
      
      public static var STATISTICS_BIGDATA_ERROR:String = "STATISTICS_BIGDATA_ERROR";
      
      private var _data:Object;
      
      public function playerEvents(param1:String, param2:Object = undefined, param3:Boolean = true, param4:Boolean = false)
      {
         super(param1,param3,param4);
         this._data = param2;
      }
      
      public function get data() : Object
      {
         return this._data;
      }
   }
}
