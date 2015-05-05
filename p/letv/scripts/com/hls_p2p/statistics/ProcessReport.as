package com.hls_p2p.statistics
{
   import com.p2p.utils.console;
   import com.hls_p2p.data.vo.LiveVodConfig;
   import flash.net.sendToURL;
   import flash.net.URLRequest;
   
   class ProcessReport extends Object
   {
      
      public var isDebug:Boolean = true;
      
      private var var_178:String = "http://s.webp2p.letv.com/ClientStageInfo?";
      
      private var var_113:String = "";
      
      public var var_179:Number = 0;
      
      public var var_180:Object;
      
      private var var_144:String;
      
      function ProcessReport(param1:String, param2:String)
      {
         this.var_180 = {
            "P2P.P2PNetStream.Success":true,
            "P2P.LoadXML.Success":true,
            "P2P.SelectorConnect.Success":true,
            "P2P.RtmfpConnect.Success":true,
            "P2P.GatherConnect.Success":true,
            "P2P.P2PGetChunk.Success":true
         };
         super();
         this.var_113 = param1;
         this.var_144 = param2;
      }
      
      public function clear() : void
      {
         console.log(this,"clear:" + this.var_113,this.var_180);
         this.var_113 = "";
         this.var_180 = {
            "P2P.P2PNetStream.Success":true,
            "P2P.LoadXML.Success":true,
            "P2P.SelectorConnect.Success":true,
            "P2P.RtmfpConnect.Success":true,
            "P2P.GatherConnect.Success":true,
            "P2P.P2PGetChunk.Success":true
         };
      }
      
      public function progress(param1:Object) : void
      {
         var _loc6_:String = null;
         var _loc7_:String = null;
         var _loc8_:String = null;
         var _loc9_:* = NaN;
         var _loc10_:String = null;
         var _loc11_:* = NaN;
         if((param1.code) && (this.var_180[param1.code]))
         {
            this.var_180[param1.code] = false;
            var _loc2_:* = -1;
            var _loc3_:* = 0;
            var _loc4_:* = "0";
            var _loc5_:* = 0;
            switch(param1.code)
            {
               case "P2P.P2PNetStream.Success":
                  _loc2_ = 0;
                  break;
               case "P2P.LoadXML.Success":
                  _loc2_ = 1;
                  break;
               case "P2P.LoadXML.Failed":
                  _loc2_ = 1;
                  _loc3_ = 1;
                  break;
               case "P2P.SelectorConnect.Success":
                  _loc2_ = 2;
                  break;
               case "P2P.RtmfpConnect.Success":
                  _loc2_ = 3;
                  _loc4_ = param1.ip;
                  _loc5_ = param1.port;
                  break;
               case "P2P.GatherConnect.Success":
                  _loc2_ = 4;
                  _loc4_ = param1.ip;
                  _loc5_ = param1.port;
                  break;
               case "P2P.P2PGetChunk.Success":
                  _loc2_ = 5;
                  break;
            }
            if(_loc2_ != -1)
            {
               if(!param1.utime)
               {
                  _loc11_ = Math.floor(new Date().time);
                  param1.utime = _loc11_ - this.var_179;
                  this.var_179 = _loc11_;
               }
               _loc6_ = LiveVodConfig.TERMID == ""?"1":LiveVodConfig.TERMID;
               _loc7_ = LiveVodConfig.PLATID == ""?"0":LiveVodConfig.PLATID;
               _loc8_ = LiveVodConfig.SPLATID == ""?"0":LiveVodConfig.SPLATID;
               _loc9_ = LiveVodConfig.TYPE != LiveVodConfig.LIVE?LiveVodConfig.TOTAL_DURATION:0;
               _loc10_ = String(this.var_178 + "act=" + _loc2_ + "&streamid=" + LiveVodConfig.STREAMID + "&err=" + _loc3_ + "&utime=" + param1.utime + "&ip=" + _loc4_ + "&port=" + _loc5_ + "&gID=" + this.var_113 + "&ver=" + LiveVodConfig.method_263() + "&appid=500" + "&type=" + LiveVodConfig.TYPE.toLowerCase() + "&termid=" + _loc6_ + "&platid=" + _loc7_ + "&splatid=" + _loc8_ + "&vtype=" + LiveVodConfig.VTYPE + "&gdur=" + _loc9_ + "&r=" + Math.floor(Math.random() * 100000));
               _loc10_ = _loc10_ + String("&ch=" + LiveVodConfig.CH + "&p1=" + LiveVodConfig.P1 + "&p2=" + LiveVodConfig.P2 + "&p3=" + LiveVodConfig.P3);
               _loc10_ = _loc10_ + String("&uuid=" + this.var_144);
               _loc10_ = _loc10_ + String("&geo=" + LiveVodConfig.GEO + "&cdeid=" + LiveVodConfig.CDE_ID);
               console.log(this,"process:" + _loc10_);
               sendToURL(new URLRequest(_loc10_));
            }
            var param1:Object = null;
            return;
         }
      }
   }
}
