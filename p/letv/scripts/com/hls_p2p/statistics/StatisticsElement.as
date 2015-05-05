package com.hls_p2p.statistics
{
   import flash.utils.Timer;
   import com.p2p.utils.console;
   import flash.events.TimerEvent;
   import com.hls_p2p.data.vo.LiveVodConfig;
   import flash.net.sendToURL;
   import flash.net.URLRequest;
   
   class StatisticsElement extends Object
   {
      
      public var isDebug:Boolean = true;
      
      private var var_112:String = "rtmfp";
      
      private var var_113:String = "";
      
      private var var_114:Number = 0;
      
      private var var_115:Number = 0;
      
      private var var_116:Number = 0;
      
      private var var_117:Number = 0;
      
      private var var_118:Number = 0;
      
      private var var_119:Number = 0;
      
      private var var_120:Number = 0;
      
      private var var_121:Number = 0;
      
      public var var_81:Number = 0;
      
      public var var_82:Number = 0;
      
      private var var_122:Number = 0;
      
      private var var_123:Boolean = false;
      
      private var var_124:Array;
      
      private var var_125:Array;
      
      private var var_126:int = 0;
      
      private var var_127:int = 0;
      
      private var var_128:int = 0;
      
      private var var_129:int = 0;
      
      private var var_130:Boolean = false;
      
      private var var_131:Boolean = false;
      
      private var var_132:String = "0";
      
      private var var_133:String = "0";
      
      private var var_134:uint = 0;
      
      private var var_135:uint = 0;
      
      private var var_136:Number = 0;
      
      private var var_137:Number = 0;
      
      private var var_138:String = "http://s.webp2p.letv.com/ClientTrafficInfo";
      
      private var var_139:Timer;
      
      private var var_140:int = 60000.0;
      
      private var var_141:int = 15;
      
      private var var_142:ProcessReport;
      
      private var var_143:Statistic;
      
      private var var_144:String;
      
      private var var_145:uint = 0;
      
      private var var_146:uint = 0;
      
      private var var_147:Array;
      
      private var var_89:Number = 0;
      
      private var var_90:Number = 0;
      
      private var var_148:Object;
      
      function StatisticsElement(param1:Statistic, param2:String, param3:String)
      {
         this.var_124 = [];
         this.var_125 = [];
         this.var_148 = new Object();
         super();
         this.var_143 = param1;
         this.var_113 = param2;
         this.var_144 = param3;
         if(!this.var_139)
         {
            this.var_139 = new Timer(this.var_140);
            this.var_139.addEventListener(TimerEvent.TIMER,this.getStatisticData);
            this.var_139.start();
         }
         this.var_142 = new ProcessReport(param2,this.var_144);
         this.var_142.var_179 = this.getTime();
      }
      
      public function get method_167() : Number
      {
         return this.var_114;
      }
      
      public function get method_168() : Number
      {
         return this.var_115;
      }
      
      public function get method_169() : Number
      {
         return this.var_116;
      }
      
      public function get method_170() : Number
      {
         return this.var_117;
      }
      
      public function get method_171() : Number
      {
         return this.var_118;
      }
      
      public function get method_172() : Number
      {
         return this.var_119;
      }
      
      public function get method_173() : Number
      {
         return this.var_120;
      }
      
      public function get method_174() : Number
      {
         return this.var_121;
      }
      
      public function get groupID() : String
      {
         return this.var_113;
      }
      
      public function start() : void
      {
         if(false == this.var_139.running)
         {
            this.var_139.start();
         }
      }
      
      public function stop() : void
      {
         this.var_139.reset();
      }
      
      public function clear() : void
      {
         console.log(this,"clear:" + this.groupID);
         this.getStatisticData();
         this.reset();
         this.var_145 = 0;
         this.var_146 = 0;
         this.var_81 = 0;
         this.var_82 = 0;
         this.var_122 = 0;
         while((this.var_147) && this.var_147.length > 0)
         {
            this.var_147.shift();
         }
         this.var_147 = null;
         this.var_142.clear();
         if(this.var_139)
         {
            this.var_139.stop();
            this.var_139.removeEventListener(TimerEvent.TIMER,this.getStatisticData);
         }
         this.var_143 = null;
      }
      
      private function reset() : void
      {
         this.var_124 = [];
         this.var_125 = [];
         this.var_115 = 0;
         this.var_114 = 0;
         this.var_116 = 0;
         this.var_117 = 0;
         this.var_118 = 0;
         this.var_119 = 0;
         this.var_120 = 0;
         this.var_121 = 0;
         this.var_126 = 0;
         this.var_127 = 0;
         this.var_128 = 0;
         this.var_129 = 0;
         this.var_123 = false;
      }
      
      public function getStatisticData(param1:TimerEvent = null) : void
      {
         var _loc2_:Number = -1;
         var _loc3_:Number = -1;
         if(this.var_130)
         {
            this.var_129 = this.var_129?this.var_129:1;
            this.var_128 = this.var_128?this.var_128:1;
            _loc2_ = Math.round(this.var_127 / this.var_129 * 10) / 10;
            _loc3_ = Math.round(this.var_126 / this.var_128 * 10) / 10;
         }
         if(this.var_143.var_80 == false && _loc3_ == 0)
         {
            _loc3_ = -2;
         }
         var _loc4_:String = LiveVodConfig.TERMID == ""?"1":LiveVodConfig.TERMID;
         var _loc5_:String = LiveVodConfig.PLATID == ""?"0":LiveVodConfig.PLATID;
         var _loc6_:String = LiveVodConfig.SPLATID == ""?"0":LiveVodConfig.SPLATID;
         var _loc7_:Number = LiveVodConfig.TYPE != LiveVodConfig.LIVE?LiveVodConfig.TOTAL_DURATION:0;
         var _loc8_:* = this.var_138 + "?";
         _loc8_ = _loc8_ + String("csize=" + this.var_114 + "&dsize=" + this.var_115 + "&streamid=" + LiveVodConfig.STREAMID + "&tsize=" + this.var_116 + "&msize=" + this.var_117 + "&bsize=" + this.var_118 + "&lpsize=" + (this.var_119 + this.var_120 + this.var_121) + "&p=" + LiveVodConfig.P2P_KERNEL + "&dnode=" + _loc3_ + "&lnode=" + _loc2_ + "&gip=" + this.var_133 + "&gport=" + this.var_135 + "&rip=" + this.var_132 + "&rport=" + this.var_134 + "&gID=" + this.groupID + "&appid=500" + "&ver=" + LiveVodConfig.method_263() + "&type=" + LiveVodConfig.TYPE.toLowerCase() + "&termid=" + _loc4_ + "&platid=" + _loc5_ + "&splatid=" + _loc6_ + "&vtype=" + LiveVodConfig.VTYPE + "&gdur=" + _loc7_ + "&r=" + Math.floor(Math.random() * 100000));
         _loc8_ = _loc8_ + String("&ch=" + LiveVodConfig.CH + "&p1=" + LiveVodConfig.P1 + "&p2=" + LiveVodConfig.P2 + "&p3=" + LiveVodConfig.P3);
         _loc8_ = _loc8_ + String("&uuid=" + this.var_144);
         _loc8_ = _loc8_ + String("&geo=" + LiveVodConfig.GEO + "&cdeid=" + LiveVodConfig.CDE_ID);
         console.log(this,"heart:" + _loc8_);
         sendToURL(new URLRequest(_loc8_));
         this.reset();
      }
      
      public function method_96() : void
      {
         var _loc1_:Object = new Object();
         if(this.var_142.var_180["P2P.P2PNetStream.Success"])
         {
            _loc1_.code = "P2P.P2PNetStream.Success";
            this.var_142.progress(_loc1_);
         }
         if(this.var_142.var_180["P2P.LoadXML.Success"])
         {
            _loc1_.code = "P2P.LoadXML.Success";
            this.var_142.progress(_loc1_);
         }
      }
      
      public function method_113(param1:uint, param2:uint) : void
      {
         this.var_126 = this.var_126 + param1;
         this.var_128++;
         this.var_127 = this.var_127 + param2;
         this.var_129++;
         this.var_145 = param1;
         this.var_146 = param2;
      }
      
      public function getDnode() : uint
      {
         return this.var_145;
      }
      
      public function getLnode() : uint
      {
         return this.var_146;
      }
      
      private function method_175(param1:Number) : void
      {
         var _loc2_:* = 0;
         var _loc3_:Object = null;
         var _loc4_:* = 0;
         if(!this.var_147)
         {
            this.var_147 = new Array();
            _loc2_ = this.var_141 - 1;
            while(_loc2_ >= 0)
            {
               _loc3_ = new Object();
               _loc3_.time = Math.floor(param1 / 1000) - (this.var_141 - 1 - _loc2_);
               _loc3_.httpSize = 0;
               _loc3_.p2pSize = 0;
               this.var_147[_loc2_] = _loc3_;
               _loc2_--;
            }
         }
         else
         {
            _loc4_ = this.var_147.length - 1;
            while(_loc4_ >= 0)
            {
               this.var_147[_loc4_].time = Math.floor(param1 / 1000) - _loc4_;
               this.var_147[_loc4_].httpSize = 0;
               this.var_147[_loc4_].p2pSize = 0;
               _loc4_--;
            }
         }
      }
      
      private function method_176(param1:Number) : void
      {
         var _loc2_:* = NaN;
         var _loc3_:* = 0;
         if(!this.var_147)
         {
            this.method_175(param1);
            return;
         }
         _loc2_ = Math.floor(param1 / 1000) - this.var_147[this.var_141 - 1].time;
         if(_loc2_ > 0)
         {
            if(_loc2_ < this.var_141)
            {
               _loc3_ = 0;
               while(_loc3_ < this.var_147.length)
               {
                  if(_loc3_ + _loc2_ < this.var_147.length)
                  {
                     this.var_147[_loc3_].time = this.var_147[_loc3_ + _loc2_].time;
                     this.var_147[_loc3_].httpSize = this.var_147[_loc3_ + _loc2_].httpSize;
                     this.var_147[_loc3_].p2pSize = this.var_147[_loc3_ + _loc2_].p2pSize;
                  }
                  else
                  {
                     this.var_147[_loc3_].time = this.var_147[_loc3_].time + _loc2_;
                     this.var_147[_loc3_].httpSize = 0;
                     this.var_147[_loc3_].p2pSize = 0;
                  }
                  _loc3_++;
               }
            }
            else
            {
               this.method_175(param1);
            }
         }
      }
      
      private function method_177(param1:Number, param2:String) : void
      {
         var _loc3_:Number = this.getTime();
         if(!this.var_147)
         {
            this.method_175(_loc3_);
         }
         else
         {
            this.method_176(_loc3_);
         }
         var _loc4_:int = this.var_147.length - 1;
         while(_loc4_ >= 0)
         {
            if(this.var_147[_loc4_].time == Math.floor(_loc3_ / 1000))
            {
               if(param2 == "http")
               {
                  this.var_147[_loc4_].httpSize = this.var_147[_loc4_].httpSize + param1;
               }
               else
               {
                  this.var_147[_loc4_].p2pSize = this.var_147[_loc4_].p2pSize + param1;
               }
               return;
            }
            _loc4_--;
         }
      }
      
      public function method_42(param1:String, param2:Number, param3:Number, param4:Number) : void
      {
         if(!isNaN(param2) || !isNaN(param3))
         {
            this.var_122 = this.var_122 + (param3 - param2);
         }
         else
         {
            console.log(this,"p2p时间报NaN啦~~~~~~");
         }
         this.var_114 = this.var_114 + param4;
         this.var_82 = this.var_82 + param4;
         if(this.var_90 == 0)
         {
            this.var_90 = this.getTime();
         }
         this.method_177(param4,"http");
         this.var_123 = true;
      }
      
      public function method_110(param1:String, param2:Number, param3:Number, param4:Number, param5:String, param6:String = "PC", param7:String = "rtmfp") : void
      {
         var _loc9_:Object = null;
         var _loc8_:* = "P2P.P2PGetChunk.Success";
         if(this.var_142.var_180[_loc8_])
         {
            _loc9_ = new Object();
            _loc9_.code = _loc8_;
            this.var_142.progress(_loc9_);
         }
         if(param7 == "rtmfp")
         {
            switch(param6)
            {
               case "PC":
                  this.var_115 = this.var_115 + param4;
                  break;
               case "TV":
                  this.var_116 = this.var_116 + param4;
                  break;
               case "MP":
                  this.var_117 = this.var_117 + param4;
                  break;
               case "BOX":
                  this.var_118 = this.var_118 + param4;
                  break;
            }
         }
         else if(param7 == "utp")
         {
            this.var_112 = "utp";
            switch(param6)
            {
               case "TV":
                  this.var_119 = this.var_119 + param4;
                  break;
               case "MP":
                  this.var_120 = this.var_120 + param4;
                  break;
               case "BOX":
                  this.var_121 = this.var_121 + param4;
                  break;
               default:
                  this.var_119 = this.var_119 + param4;
            }
         }
         else if(param7 == "ws")
         {
            this.var_112 = "ws";
            switch(param6)
            {
               case "TV":
                  this.var_119 = this.var_119 + param4;
                  break;
               case "MP":
                  this.var_120 = this.var_120 + param4;
                  break;
               case "BOX":
                  this.var_121 = this.var_121 + param4;
                  break;
               default:
                  this.var_119 = this.var_119 + param4;
            }
         }
         
         
         this.var_81 = this.var_81 + param4;
         if(this.var_90 == 0)
         {
            this.var_90 = this.getTime();
         }
         this.method_177(param4,"p2p");
         this.var_123 = true;
      }
      
      public function method_178() : Object
      {
         this.var_148.httpSpeed = 0;
         this.var_148.p2pSpeed = 0;
         if(!this.var_147)
         {
            return this.var_148;
         }
         var _loc1_:Number = 0;
         var _loc2_:Number = 0;
         var _loc3_:Number = 0;
         var _loc4_:Number = this.getTime();
         this.var_89 = this.var_90;
         _loc4_ = this.var_90 = this.getTime();
         this.method_176(_loc4_);
         var _loc5_:* = 0;
         while(_loc5_ < this.var_147.length)
         {
            _loc2_ = _loc2_ + this.var_147[_loc5_].httpSize;
            _loc3_ = _loc3_ + this.var_147[_loc5_].p2pSize;
            if(_loc1_ == 0 && Math.floor(this.var_143.var_83 / 1000) <= this.var_147[_loc5_].time)
            {
               _loc1_ = this.var_147.length - _loc5_;
            }
            _loc5_++;
         }
         this.var_148.httpSpeed = Math.round(10 * _loc2_ / 1024 / _loc1_) / 10;
         this.var_148.p2pSpeed = Math.round(10 * _loc3_ / 1024 / _loc1_) / 10;
         this.var_122 = 0;
         return this.var_148;
      }
      
      public function method_97() : void
      {
         var _loc1_:Object = null;
         if(this.var_142.var_180["P2P.SelectorConnect.Success"])
         {
            _loc1_ = new Object();
            _loc1_.code = "P2P.SelectorConnect.Success";
            this.var_142.progress(_loc1_);
         }
      }
      
      public function method_101(param1:String, param2:uint) : void
      {
         this.var_132 = param1;
         this.var_134 = param2;
      }
      
      public function method_102(param1:String, param2:uint, param3:String) : void
      {
         var _loc4_:Object = null;
         this.var_132 = param1;
         this.var_134 = param2;
         this.var_130 = true;
         if(this.var_142.var_180["P2P.RtmfpConnect.Success"])
         {
            _loc4_ = new Object();
            _loc4_.code = "P2P.RtmfpConnect.Success";
            _loc4_.ip = param1;
            _loc4_.port = param2;
            this.var_142.progress(_loc4_);
         }
      }
      
      public function rtmfpFailed() : void
      {
         this.var_130 = false;
      }
      
      public function method_103(param1:String, param2:uint) : void
      {
         this.var_133 = param1;
         this.var_135 = param2;
      }
      
      public function method_104(param1:String, param2:uint) : void
      {
         var _loc3_:Object = null;
         this.var_133 = param1;
         this.var_135 = param2;
         this.var_131 = true;
         if(this.var_142.var_180["P2P.GatherConnect.Success"])
         {
            _loc3_ = new Object();
            _loc3_.code = "P2P.GatherConnect.Success";
            _loc3_.ip = param1;
            _loc3_.port = param2;
            this.var_142.progress(_loc3_);
         }
      }
      
      public function gatherFailed() : void
      {
         this.var_131 = false;
      }
      
      private function method_179(param1:int, param2:Array) : Number
      {
         var _loc3_:Number = 0;
         var _loc4_:* = 0;
         while(_loc4_ < param1)
         {
            _loc3_ = _loc3_ + (param2[_loc4_][1] - param2[_loc4_][0]);
            _loc4_++;
         }
         return _loc3_;
      }
      
      private function getTime() : Number
      {
         return Math.floor(new Date().time);
      }
   }
}
