package com.letv.pluginsAPI.stat
{
   import flash.external.ExternalInterface;
   
   public class PageDebugLog extends Object
   {
      
      private static var _instance:PageDebugLog;
      
      public static const STARTUP_PLAYER:String = "播放器开始启动";
      
      public static const PLUGINS_LOADER_COMPLETE:String = "插件加载完成";
      
      public static const PLUGINS_LOADER_ERROR:String = "插件加载失败";
      
      public static const STARTUP_CMS:String = "开始媒资请求";
      
      public static const CMS_COMPLETE:String = "媒资请求完成";
      
      public static const CMS_ERROR:String = "媒资请求失败";
      
      public static const STARTUP_AD:String = "开始广告请求";
      
      public static const AD_START_PLAYER:String = "广告开始播放";
      
      public static const AD_LOADER_COMPLETE:String = "广告加载完毕";
      
      public static const AD_HEAD_PLAY_NONE:String = "广告系统没有出广告";
      
      public static const AD_PLAYER_COMPLETE:String = " 广告播放完毕";
      
      public static const STARTUP_GSLB:String = "开始请求调度";
      
      public static const GSBL_COMPLETE:String = "调度请求成功";
      
      public static const GSBL_ERROR:String = "调度请求错误";
      
      public static const VIDEO_START:String = "视频开始播放";
      
      public static const VIDEO_ERROR:String = "视频播放错误";
      
      public function PageDebugLog()
      {
         super();
      }
      
      public static function getInstance() : PageDebugLog
      {
         if(_instance == null)
         {
            _instance = new PageDebugLog();
         }
         return _instance;
      }
      
      public function callJsLog(param1:String, param2:Object = null) : void
      {
         var _loc4_:String = null;
         var _loc3_:* = "";
         _loc3_ = _loc3_ + param1;
         if(param2 != null)
         {
            _loc3_ = _loc3_ + "  --其他信息：";
            for(_loc4_ in param2)
            {
               _loc3_ = _loc3_ + (param2[_loc4_] + ",\t");
            }
         }
         this.log(_loc3_);
      }
      
      private function log(param1:String) : void
      {
         var info:String = param1;
         try
         {
            ExternalInterface.call("logger.log",info);
         }
         catch(e:Error)
         {
         }
      }
   }
}
