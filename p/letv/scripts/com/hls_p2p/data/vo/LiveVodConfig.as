package com.hls_p2p.data.vo
{
   import com.hls_p2p.statistics.Statistic;
   
   public class LiveVodConfig extends Object
   {
      
      public static var uuid:String = "";
      
      private static var var_268:uint = 300 * 1024 * 1024;
      
      public static var var_269:Boolean = false;
      
      public static var canChangeM3U8:Boolean = false;
      
      public static var changeBlockId:Number = -1;
      
      public static var changeBlockPreId:Number = -1;
      
      public static var var_270:Number = -1;
      
      public static var var_271:uint = 188 * 1024;
      
      public static var var_272:uint = 188 * 1024;
      
      public static var var_273:Number = 60 * 1;
      
      public static var resourceID:String = "";
      
      public static var P2P_KERNEL:String = "r";
      
      public static var STREAMID:String = " ";
      
      public static var var_274:Boolean = true;
      
      public static var IS_DRM:Boolean = false;
      
      public static var var_275:String = "s";
      
      public static var vars:Object;
      
      public static var var_276:Boolean = true;
      
      public static var KBPS:int = 0;
      
      public static var IS_CHANGE_KBPS:Boolean = false;
      
      public static var PLAYING_BLOCK_GID:String = "";
      
      public static var CH:String = "";
      
      public static var REPORT_VAR:Object = null;
      
      public static var P1:String = "";
      
      public static var P2:String = "";
      
      public static var P3:String = "";
      
      public static var USING_TS_URL:String = "";
      
      public static var USING_ERROR_TS_URL:String = "";
      
      public static var var_277:Number = 0;
      
      public static var END_TIME:Number = -1;
      
      public static var var_278:Object = new Object();
      
      public static var ADD_DATA_TIME:Number = -1;
      
      public static var PLAY_TIME:Number = -1;
      
      public static var BlockID:Number = -1;
      
      public static var var_279:Number = -1;
      
      public static var TOTAL_DURATION:Number = 0;
      
      public static var TOTAL_MEDIA_DURATION:Number = 0;
      
      public static var VTYPE:String = "";
      
      public static var TOTAL_TS:Number = 0;
      
      public static var TOTAL_PIECE:Number = 0;
      
      public static var LAST_TS_ID:Number = 0;
      
      private static var _NEAREST_WANT_ID:Number = -1;
      
      public static var var_280:Number = 6 * 60;
      
      public static var var_281:Number = 0;
      
      public static var var_282:Number = 0;
      
      public static var currentVid:String = "noContinuity";
      
      public static var nextVid:String = "";
      
      public static var currentChangeVid:String = "";
      
      public static var DATARATE:Number = 800;
      
      public static var RATE_MULTIPLE:Number = 1.5;
      
      private static var var_283:Number = 15;
      
      public static var BufferTimeLimit:Number = 15;
      
      public static var var_284:Number = 15;
      
      public static var var_285:Number = 40 * 60;
      
      public static var DESC_RPEAT_LOAD_COUNT:int = 3;
      
      private static var _M3U8_MAXTIME:Number = -1;
      
      public static var DAT_RPEAT_LOAD_COUNT:int = 3;
      
      public static var DAT_CHECK_INTERVAL:Number = 2000;
      
      public static var DAT_LOAD_RATE:Number = 0.1;
      
      public static var Buffer_Count_Time:Number = 60;
      
      public static var BirthTime:Number = 0;
      
      public static var MY_NAME:String;
      
      public static var badPeerTime:Number = 0.5 * 60 * 1000;
      
      public static var var_286:Number = 9;
      
      public static var ifCanP2PDownload:Boolean = true;
      
      public static var ifCanP2PUpload:Boolean = true;
      
      public static var IS_SHARE_PEERS:Boolean = false;
      
      public static var var_287:int = 0;
      
      public static var var_288:int = 5;
      
      public static var IS_SEEKING:Boolean = false;
      
      public static const const_6:int = 3;
      
      public static var cdnDisable:int = 0;
      
      public static var EXT_LETV_M3U8_ERRCODE:String = "noError";
      
      public static const const_7:String = "PC";
      
      public static var TERMID:String = "1";
      
      public static var PLATID:String = "";
      
      public static var SPLATID:String = "";
      
      public static var GEO:String = "";
      
      public static var CDE_ID:String = "";
      
      private static const VOD_VERSION:String = "vod.4.2.04271800";
      
      private static const LIVE_VERSION:String = "liv.4.1.03301800";
      
      private static const VOD_TEMP_VERSION:String = "";
      
      private static const LIVE_TEMP_VERSION:String = "";
      
      public static const LIVE:String = "LIVE";
      
      public static const VOD:String = "VOD";
      
      public static var TYPE:String = LIVE;
      
      private static const P2P_AGREEMENT_VOD_VERSION:String = "1.3m3u8_12272000";
      
      private static const P2P_AGREEMENT_LIVE_VERSION:String = "1.3m3u8_12272000";
      
      {
         uuid = "";
         var_268 = 300 * 1024 * 1024;
         var_269 = false;
         canChangeM3U8 = false;
         changeBlockId = -1;
         changeBlockPreId = -1;
         var_270 = -1;
         var_271 = 188 * 1024;
         var_272 = 188 * 1024;
         var_273 = 60 * 1;
         resourceID = "";
         P2P_KERNEL = "r";
         STREAMID = " ";
         var_274 = true;
         IS_DRM = false;
         var_275 = "s";
         var_276 = true;
         KBPS = 0;
         IS_CHANGE_KBPS = false;
         PLAYING_BLOCK_GID = "";
         CH = "";
         REPORT_VAR = null;
         P1 = "";
         P2 = "";
         P3 = "";
         USING_TS_URL = "";
         USING_ERROR_TS_URL = "";
         var_277 = 0;
         END_TIME = -1;
         var_278 = new Object();
         ADD_DATA_TIME = -1;
         PLAY_TIME = -1;
         BlockID = -1;
         var_279 = -1;
         TOTAL_DURATION = 0;
         TOTAL_MEDIA_DURATION = 0;
         VTYPE = "";
         TOTAL_TS = 0;
         TOTAL_PIECE = 0;
         LAST_TS_ID = 0;
         _NEAREST_WANT_ID = -1;
         var_280 = 6 * 60;
         var_281 = 0;
         var_282 = 0;
         currentVid = "noContinuity";
         nextVid = "";
         currentChangeVid = "";
         DATARATE = 800;
         RATE_MULTIPLE = 1.5;
         var_283 = 15;
         BufferTimeLimit = 15;
         var_284 = 15;
         var_285 = 40 * 60;
         DESC_RPEAT_LOAD_COUNT = 3;
         _M3U8_MAXTIME = -1;
         DAT_RPEAT_LOAD_COUNT = 3;
         DAT_CHECK_INTERVAL = 2000;
         DAT_LOAD_RATE = 0.1;
         Buffer_Count_Time = 60;
         BirthTime = 0;
         badPeerTime = 0.5 * 60 * 1000;
         var_286 = 9;
         ifCanP2PDownload = true;
         ifCanP2PUpload = true;
         IS_SHARE_PEERS = false;
         var_287 = 0;
         var_288 = 5;
         IS_SEEKING = false;
         cdnDisable = 0;
         EXT_LETV_M3U8_ERRCODE = "noError";
         TERMID = "1";
         PLATID = "";
         SPLATID = "";
         GEO = "";
         CDE_ID = "";
         TYPE = LIVE;
      }
      
      public function LiveVodConfig()
      {
         super();
      }
      
      public static function set method_262(param1:uint) : void
      {
         var_268 = param1 * 1024 * 1024;
      }
      
      public static function get method_262() : uint
      {
         return var_268;
      }
      
      public static function method_263() : String
      {
         if(LiveVodConfig.TYPE != LiveVodConfig.LIVE)
         {
            return LiveVodConfig.VOD_VERSION;
         }
         return LiveVodConfig.LIVE_VERSION;
      }
      
      public static function method_264() : String
      {
         if(LiveVodConfig.TYPE != LiveVodConfig.LIVE)
         {
            return LiveVodConfig.P2P_AGREEMENT_VOD_VERSION;
         }
         return LiveVodConfig.P2P_AGREEMENT_LIVE_VERSION;
      }
      
      public static function method_265() : String
      {
         if(LiveVodConfig.TYPE != LiveVodConfig.LIVE)
         {
            return LiveVodConfig.VOD_TEMP_VERSION;
         }
         return LiveVodConfig.LIVE_TEMP_VERSION;
      }
      
      public static function set method_94(param1:Number) : void
      {
         _NEAREST_WANT_ID = param1;
         Statistic.method_261().method_94();
      }
      
      public static function get method_94() : Number
      {
         return _NEAREST_WANT_ID;
      }
      
      public static function set method_266(param1:Number) : void
      {
         var_283 = param1;
      }
      
      public static function get method_266() : Number
      {
         return var_283;
      }
      
      public static function set method_267(param1:Number) : void
      {
         _M3U8_MAXTIME = param1;
         Statistic.method_261().method_93();
      }
      
      public static function get method_267() : Number
      {
         return _M3U8_MAXTIME;
      }
      
      public static function CLEAR() : void
      {
         LiveVodConfig.uuid = "";
         var_270 = 0;
         LiveVodConfig.canChangeM3U8 = false;
         LiveVodConfig.changeBlockId = -1;
         LiveVodConfig.changeBlockPreId = -1;
         LiveVodConfig.currentVid = "noContinuity";
         LiveVodConfig.nextVid = "";
         LiveVodConfig.currentChangeVid = "";
         LiveVodConfig.ADD_DATA_TIME = -1;
         LiveVodConfig.PLAY_TIME = -1;
         LiveVodConfig._NEAREST_WANT_ID = -1;
         LiveVodConfig.BlockID = -1;
         LiveVodConfig.Buffer_Count_Time = 60;
         LiveVodConfig.BufferTimeLimit = 15;
         LiveVodConfig.BirthTime = 0;
         LiveVodConfig.DATARATE = 800;
         LiveVodConfig.RATE_MULTIPLE = 1.5;
         LiveVodConfig.DESC_RPEAT_LOAD_COUNT = 3;
         LiveVodConfig._M3U8_MAXTIME = -1;
         LiveVodConfig.DAT_RPEAT_LOAD_COUNT = 3;
         LiveVodConfig.DAT_CHECK_INTERVAL = 2000;
         LiveVodConfig.MY_NAME = "";
         LiveVodConfig.badPeerTime = 30 * 1000;
         LiveVodConfig.DAT_LOAD_RATE = 0.1;
         LiveVodConfig.TOTAL_TS = 0;
         LiveVodConfig.TOTAL_PIECE = 0;
         LiveVodConfig.LAST_TS_ID = 0;
         LiveVodConfig.ifCanP2PDownload = true;
         LiveVodConfig.ifCanP2PUpload = true;
         LiveVodConfig.P2P_KERNEL = "r";
         LiveVodConfig.TERMID = "1";
         LiveVodConfig.PLATID = "";
         LiveVodConfig.SPLATID = "";
         LiveVodConfig.resourceID = "";
         LiveVodConfig.IS_SHARE_PEERS = false;
         LiveVodConfig.cdnDisable = 0;
         LiveVodConfig.IS_SEEKING = false;
         LiveVodConfig.TOTAL_DURATION = 0;
         LiveVodConfig.TOTAL_MEDIA_DURATION = 0;
         LiveVodConfig.VTYPE = "";
         LiveVodConfig.STREAMID = "";
         LiveVodConfig.KBPS = 0;
         LiveVodConfig.IS_CHANGE_KBPS = false;
         LiveVodConfig.IS_DRM = false;
         LiveVodConfig.PLAYING_BLOCK_GID = "";
         LiveVodConfig.USING_TS_URL = "";
         LiveVodConfig.USING_ERROR_TS_URL = "";
         LiveVodConfig.REPORT_VAR = null;
         LiveVodConfig.GEO = "";
         LiveVodConfig.CDE_ID = "";
         LiveVodConfig.END_TIME = -1;
         LiveVodConfig.EXT_LETV_M3U8_ERRCODE = "noError";
      }
   }
}
