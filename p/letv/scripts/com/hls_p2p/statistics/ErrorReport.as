package com.hls_p2p.statistics
{
   import com.hls_p2p.data.vo.class_2;
   import com.hls_p2p.dataManager.DataManager;
   import flash.net.URLVariables;
   import flash.net.URLRequest;
   import com.hls_p2p.data.vo.LiveVodConfig;
   import flash.net.URLRequestMethod;
   import flash.net.sendToURL;
   
   public class ErrorReport extends Object
   {
      
      private var _initData:class_2;
      
      private var _dataManager:DataManager;
      
      public function ErrorReport(param1:class_2, param2:DataManager)
      {
         super();
         this._initData = param1;
         this._dataManager = param2;
      }
      
      public function clear() : void
      {
         this._initData = null;
         this._dataManager = null;
      }
      
      public function sendError(param1:Object) : void
      {
         var _loc2_:* = 0;
         var _loc3_:String = null;
         var _loc4_:String = null;
         var _loc5_:String = null;
         var _loc6_:String = null;
         var _loc7_:String = null;
         var _loc8_:URLVariables = null;
         var _loc9_:URLRequest = null;
         if((this._initData) && (this._dataManager))
         {
            _loc2_ = 486;
            if(param1.err == "ts")
            {
               _loc2_ = 487;
            }
            _loc3_ = LiveVodConfig.TERMID == ""?"1":LiveVodConfig.TERMID;
            _loc4_ = LiveVodConfig.PLATID == ""?"0":LiveVodConfig.PLATID;
            _loc5_ = LiveVodConfig.SPLATID == ""?"0":LiveVodConfig.SPLATID;
            _loc6_ = "http://s.webp2p.letv.com/err?" + "code=" + _loc2_ + "&gID=" + LiveVodConfig.currentVid + "&ver=" + LiveVodConfig.method_263() + "&type=" + LiveVodConfig.TYPE + "&termid=" + _loc3_ + "&platid=" + _loc4_ + "&splatid=" + _loc5_ + "&p2p=" + (LiveVodConfig.P2P_KERNEL != "r"?0:1) + "&vtype=" + LiveVodConfig.VTYPE + "&gdur=" + this._initData.totalDuration + "&appid=500" + "&streamid=" + LiveVodConfig.STREAMID + "&ch=" + LiveVodConfig.CH + "&p1=" + LiveVodConfig.P1 + "&p2=" + LiveVodConfig.P2 + "&p3=" + LiveVodConfig.P3 + "&cdeid=" + LiveVodConfig.CDE_ID + "&uuid=" + this._dataManager.method_8(LiveVodConfig.currentVid) + "&geo=" + LiveVodConfig.GEO + "&r=" + Math.floor(Math.random() * 100000);
            _loc7_ = "";
            if(this._initData.var_58.length > 0)
            {
               _loc7_ = this._initData.var_58.join();
            }
            _loc8_ = new URLVariables();
            _loc8_.adTime = this._initData.adRemainingTime;
            _loc8_.afterAdTime = _loc8_.adTime - this._initData.method_59();
            _loc8_.startPlayTime = param1.startPlayTime;
            _loc8_.afterEmptyTime = param1.afterEmptyTime;
            _loc8_.m3u8Ready = this._initData.var_53;
            _loc8_.tsURL = LiveVodConfig.USING_ERROR_TS_URL;
            _loc8_.m3u8URL = _loc7_;
            _loc8_.gslbURL = this._initData.gslbURL;
            _loc8_.playHead = param1.playHead;
            _loc8_.p2pLoad = Statistic.method_261().method_79;
            _loc8_.httpLoad = Statistic.method_261().method_80;
            _loc8_.p2pShare = Statistic.method_261().method_81;
            _loc8_.lnode = Statistic.method_261().getLnode();
            _loc8_.dnode = Statistic.method_261().getDnode();
            _loc8_.bufferTime = param1.bufferTime;
            _loc8_.bufferLength = param1.bufferLength;
            _loc9_ = new URLRequest();
            _loc9_.url = _loc6_;
            _loc9_.method = URLRequestMethod.POST;
            _loc9_.data = _loc8_;
            try
            {
               sendToURL(_loc9_);
            }
            catch(e:Error)
            {
            }
         }
      }
   }
}
