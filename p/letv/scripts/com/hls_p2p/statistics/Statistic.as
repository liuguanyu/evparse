package com.hls_p2p.statistics
{
   import com.hls_p2p.data.vo.class_2;
   import com.hls_p2p.stream.HTTPNetStream;
   import com.p2p.utils.console;
   import flash.events.EventDispatcher;
   import com.hls_p2p.events.EventExtensions;
   import com.hls_p2p.events.protocol.NETSTREAM_PROTOCOL;
   import com.hls_p2p.data.vo.LiveVodConfig;
   import com.hls_p2p.events.EventWithData;
   
   public class Statistic extends Object
   {
      
      private static var var_267:Statistic = null;
      
      {
         var_267 = null;
      }
      
      public var isDebug:Boolean = true;
      
      private var var_72:String = "";
      
      protected var _initData:class_2;
      
      protected var var_73:HTTPNetStream;
      
      public var var_74:Object;
      
      public var outMsg:Function;
      
      private var var_75:Object;
      
      private var var_76:StatisticsElement;
      
      private var var_77:Number = 0;
      
      private var var_78:Number = 0;
      
      private var var_79:Number = 0;
      
      public var var_80:Boolean = false;
      
      private var var_81:Number = 0;
      
      private var var_82:Number = 0;
      
      public var var_83:Number = 0;
      
      private var var_84:String;
      
      private var var_85:Object;
      
      private var var_86:Number = 0;
      
      private var var_87:Number = 0;
      
      private var var_88:Number = 0;
      
      private var var_89:Number = 0;
      
      private var var_90:Number = 0;
      
      public function Statistic(param1:Singleton)
      {
         this.var_74 = new Object();
         this.var_75 = new Object();
         this.var_85 = new Object();
         super();
      }
      
      public static function method_261() : Statistic
      {
         if(var_267 == null)
         {
            var_267 = new Statistic(new Singleton());
         }
         return var_267;
      }
      
      public function set method_78(param1:String) : void
      {
         this.var_72 = param1;
      }
      
      public function get method_78() : String
      {
         return this.var_72;
      }
      
      public function get method_79() : Number
      {
         return this.var_77;
      }
      
      public function get method_80() : Number
      {
         return this.var_78;
      }
      
      public function get method_81() : Number
      {
         return this.var_79;
      }
      
      public function clear() : void
      {
         var _loc1_:String = null;
         var _loc2_:* = undefined;
         console.log(this,"clear ");
         this.reset();
         this.var_72 = "";
         for(_loc1_ in this.var_75)
         {
            this.var_75[_loc1_].clear();
            delete this.var_75[_loc1_];
            true;
         }
         this.var_75 = new Object();
         for(_loc2_ in this.var_74)
         {
            _loc2_ = null;
            delete this.var_74[_loc2_];
            true;
         }
         this.var_74 = new Object();
         if(this.var_73)
         {
            this.var_73 = null;
         }
         this.var_83 = 0;
         this.var_80 = false;
         this.var_77 = 0;
         this.var_78 = 0;
         this.var_79 = 0;
         this.var_81 = 0;
         this.var_82 = 0;
      }
      
      public function method_82() : void
      {
         if(this.var_83 == 0)
         {
            this.var_83 = this.getTime();
         }
      }
      
      private function reset() : void
      {
      }
      
      public function method_83(param1:Number) : void
      {
         if(this.outMsg != null)
         {
            this.outMsg(param1,"totalDuration");
         }
      }
      
      public function method_84(param1:String, param2:String) : void
      {
         if(null == this.var_73)
         {
            return;
         }
         var _loc3_:Object = new Object();
         _loc3_.pieceID = param1;
         _loc3_.from = param2;
         _loc3_.code = "P2P.Repeat.Success";
         (this.var_73 as EventDispatcher).dispatchEvent(new EventExtensions(NETSTREAM_PROTOCOL.const_4,_loc3_));
      }
      
      public function method_85(param1:String, param2:String) : void
      {
         if(null == this.var_73)
         {
            return;
         }
         var _loc3_:Object = new Object();
         _loc3_.pieceID = param1;
         _loc3_.from = param2;
         _loc3_.code = "P2P.TimeOut.Success";
         (this.var_73 as EventDispatcher).dispatchEvent(new EventExtensions(NETSTREAM_PROTOCOL.const_4,_loc3_));
      }
      
      public function method_86(param1:String, param2:String) : void
      {
         if(!this.var_75[param1])
         {
            this.var_75[param1] = new StatisticsElement(this,param1,param2);
            this.var_75[param1].start();
            this.method_96(param1);
         }
         if(this.var_72 == "")
         {
            this.var_72 = param1;
         }
      }
      
      public function method_87(param1:String) : void
      {
         var _loc2_:Object = null;
         console.log(this,"delStatisticByGroupID " + param1);
         if(this.var_75[param1])
         {
            this.var_75[param1].clear();
            delete this.var_75[param1];
            true;
            _loc2_ = new Object();
            _loc2_.name = "delPeerInfoPanel";
            _loc2_.info = param1;
            this.method_88(_loc2_);
         }
      }
      
      private function method_88(param1:Object) : void
      {
         var _loc2_:* = undefined;
         for each(_loc2_ in this.var_74)
         {
            _loc2_.fun(param1);
         }
      }
      
      private function streamPlayHandler(param1:EventExtensions) : void
      {
         console.log(this,"统计响应play事件" + LiveVodConfig.method_263() + LiveVodConfig.method_265());
         this._initData = param1.data["initData"] as class_2;
         if(this.outMsg != null)
         {
            this.outMsg(LiveVodConfig.method_263() + LiveVodConfig.method_265(),"version");
         }
      }
      
      public function method_89(param1:String) : void
      {
         if(this.outMsg != null)
         {
            this.outMsg(param1,"groupName");
         }
         var _loc2_:Object = new Object();
         _loc2_.name = "groupName";
         _loc2_.info = param1;
         this.method_88(_loc2_);
      }
      
      public function method_90(param1:Object) : void
      {
         if(null == this.var_73)
         {
            return;
         }
         if(this.outMsg != null)
         {
            if(LiveVodConfig.TYPE != LiveVodConfig.LIVE)
            {
               this.outMsg.call(null,Math.round(this._initData.totalSize / (1024 * 1024)) + ", W*H=" + this._initData["videoWidth"] + "*" + this._initData["videoHeight"],"totalSize");
            }
            else
            {
               this.outMsg.call(null,"  , W*H=" + this._initData["videoWidth"] + "*" + this._initData["videoHeight"],"totalSize");
            }
         }
      }
      
      public function dispatchPreLoadComplete() : void
      {
         if(this.var_73)
         {
            this.var_73.dispatchPreLoadComplete();
         }
      }
      
      public function method_91(param1:Number) : void
      {
         var _loc2_:Object = new Object();
         _loc2_.name = "time";
         _loc2_.info = Math.round(param1);
         this.method_88(_loc2_);
      }
      
      public function method_92(param1:String) : void
      {
         var _loc2_:Object = new Object();
         _loc2_.name = "chunkIndex";
         _loc2_.info = param1;
         this.method_88(_loc2_);
      }
      
      public function method_93() : void
      {
         var _loc1_:Object = new Object();
         _loc1_.name = "MaxTime";
         _loc1_.info = LiveVodConfig.method_267;
         this.method_88(_loc1_);
      }
      
      public function method_94() : void
      {
         var _loc1_:Object = new Object();
         _loc1_.name = "NearWantID";
         _loc1_.info = LiveVodConfig.method_94;
         this.method_88(_loc1_);
      }
      
      public function method_95(param1:String, param2:String = null) : void
      {
      }
      
      private function method_96(param1:String) : void
      {
         this.var_76 = this.var_75[param1];
         if(this.var_76)
         {
            this.var_76.method_96();
         }
      }
      
      public function method_97(param1:String) : void
      {
         this.var_76 = this.var_75[param1];
         if(this.var_76)
         {
            this.var_76.method_97();
         }
      }
      
      public function method_98() : void
      {
         if(this.outMsg != null)
         {
            this.outMsg("","loadNextData");
         }
      }
      
      public function method_99(param1:String, param2:String) : void
      {
         var _loc3_:Object = new Object();
         _loc3_.name = "myPeerID_ws";
         _loc3_.info = param1;
         this.method_88(_loc3_);
         _loc3_.name = "rtmfpOk";
         this.method_88(_loc3_);
         _loc3_.name = "checkSum";
         _loc3_.info = LiveVodConfig.method_263() + LiveVodConfig.method_265();
         this.method_88(_loc3_);
      }
      
      public function method_100(param1:String) : void
      {
         var _loc2_:Object = new Object();
         _loc2_.info = param1;
         _loc2_.code = "P2P.WebSocket.States";
         (this.var_73 as EventDispatcher).dispatchEvent(new EventExtensions(NETSTREAM_PROTOCOL.const_4,_loc2_));
      }
      
      public function method_101(param1:String, param2:uint, param3:String) : void
      {
         this.var_76 = this.var_75[param3];
         if(this.var_76)
         {
            this.var_76.method_101(param1,param2);
         }
         if(this.var_72 != param3)
         {
            return;
         }
         if(this.outMsg != null)
         {
            this.outMsg(String(param1 + ":" + param2),"rtmfpName");
         }
         var _loc4_:Object = new Object();
         _loc4_.name = "rtmfp";
         _loc4_.info = String(param1 + ":" + param2);
         this.method_88(_loc4_);
      }
      
      public function method_102(param1:String, param2:uint, param3:String, param4:String) : void
      {
         this.var_76 = this.var_75[param4];
         if(this.var_76)
         {
            this.var_76.method_102(param1,param2,param3);
         }
         var _loc5_:Object = new Object();
         _loc5_.name = "creatPeerInfoPanel";
         _loc5_.info = param4;
         this.method_88(_loc5_);
         var _loc6_:Object = new Object();
         _loc6_.name = "myPeerID";
         _loc6_.gid = param4;
         _loc6_.info = param3;
         this.method_88(_loc6_);
         if(this.var_72 != param4)
         {
            return;
         }
         if(this.outMsg != null)
         {
            this.outMsg(String(param1 + ":" + param2 + " OK"),"rtmfpName");
            this.var_84 = String(param3).substr(0,10);
            this.outMsg(this.var_84,"myName");
         }
         var _loc7_:Object = new Object();
         _loc7_.name = "rtmfp";
         _loc7_.info = String(param1 + ":" + param2);
         this.method_88(_loc7_);
         _loc6_.name = "rtmfpOk";
         this.method_88(_loc6_);
         _loc6_.name = "checkSum";
         _loc6_.info = LiveVodConfig.method_263() + LiveVodConfig.method_265();
         this.method_88(_loc6_);
      }
      
      public function rtmfpFailed(param1:String, param2:uint, param3:String) : void
      {
         this.var_76 = this.var_75[param3];
         if(this.var_76)
         {
            this.var_76.rtmfpFailed();
         }
         if(this.var_72 != param3)
         {
            return;
         }
         if(this.outMsg != null)
         {
            this.outMsg(String(param1 + ":" + param2 + " Failed"),"rtmfpName");
         }
         var _loc4_:Object = new Object();
         _loc4_.name = "rtmfpFailed";
         this.method_88(_loc4_);
      }
      
      public function method_103(param1:String, param2:uint, param3:String) : void
      {
         this.var_76 = this.var_75[param3];
         if(this.var_76)
         {
            this.var_76.method_103(param1,param2);
         }
         if(this.var_72 != param3)
         {
            return;
         }
         if(this.outMsg != null)
         {
            this.outMsg(String(param1 + ":" + param2),"gatherName");
         }
         var _loc4_:Object = new Object();
         _loc4_.name = "gather";
         _loc4_.info = String(param1 + ":" + param2);
         this.method_88(_loc4_);
      }
      
      public function method_104(param1:String, param2:uint, param3:String) : void
      {
         this.var_76 = this.var_75[param3];
         if(this.var_76)
         {
            this.var_76.method_104(param1,param2);
         }
         if(this.var_72 != param3)
         {
            return;
         }
         if(this.outMsg != null)
         {
            this.outMsg(String(param1 + ":" + param2 + "  OK"),"gatherName");
         }
         var _loc4_:Object = new Object();
         _loc4_.name = "gatherOk";
         this.method_88(_loc4_);
      }
      
      public function gatherFailed(param1:String, param2:uint, param3:String) : void
      {
         this.var_76 = this.var_75[param3];
         if(this.var_76)
         {
            this.var_76.gatherFailed();
         }
         if(this.var_72 != param3)
         {
            return;
         }
         if(this.outMsg != null)
         {
            this.outMsg(String(param1 + ":" + param2 + " Failed"),"gatherName");
         }
         var _loc4_:Object = new Object();
         _loc4_.name = "gatherFailed";
         this.method_88(_loc4_);
      }
      
      public function method_105(param1:String, param2:String) : void
      {
         if(null == this.var_73)
         {
            return;
         }
         var _loc3_:Object = new Object();
         _loc3_.pieceID = param1;
         _loc3_.remoteID = param2;
         _loc3_.code = "P2P.WantChunk.Success";
         (this.var_73 as EventDispatcher).dispatchEvent(new EventExtensions(NETSTREAM_PROTOCOL.const_4,_loc3_));
      }
      
      public function getDownloadSpeed() : void
      {
         var _loc1_:String = null;
         var _loc2_:Object = null;
         var _loc3_:Object = null;
         if(this.var_90 != 0)
         {
            this.var_90 = this.getTime();
            if(this.var_90 - this.var_89 < 1 * 1000)
            {
               return;
            }
         }
         this.var_89 = this.var_90;
         this.var_87 = 0;
         this.var_88 = 0;
         this.var_86 = 0;
         if(this.var_85.httpSpeed)
         {
            this.var_85.httpSpeed = 0;
         }
         if(this.var_85.p2pSpeed)
         {
            this.var_85.p2pSpeed = 0;
         }
         for(_loc1_ in this.var_75)
         {
            this.var_85 = (this.var_75[_loc1_] as StatisticsElement).method_178();
            this.var_87 = this.var_87 + (!this.var_85.httpSpeed?0:this.var_85.httpSpeed);
            this.var_88 = this.var_88 + (!this.var_85.p2pSpeed?0:this.var_85.p2pSpeed);
         }
         this.var_86 = this.var_87 + this.var_88;
         _loc2_ = new Object();
         _loc2_.info = this.var_88;
         _loc2_.name = "P2PSpeed";
         this.method_88(_loc2_);
         _loc3_ = new Object();
         _loc3_.info = this.var_87;
         _loc3_.name = "avgSpeed";
         this.method_88(_loc3_);
         if(this.outMsg != null)
         {
            this.outMsg(this.var_84 + " ,HS:" + this.var_87 + " ,PS:" + this.var_88,"myName");
         }
      }
      
      public function method_106() : void
      {
         var _loc3_:String = null;
         var _loc4_:Object = null;
         var _loc5_:Object = null;
         if(this.var_90 != 0)
         {
            this.var_90 = this.getTime();
            if(this.var_90 - this.var_89 < 1 * 1000)
            {
               return;
            }
         }
         this.var_89 = this.var_90;
         var _loc1_:Number = 0;
         var _loc2_:Number = 0;
         this.var_86 = 0;
         if(this.var_85.httpSpeed)
         {
            this.var_85.httpSpeed = 0;
         }
         if(this.var_85.p2pSpeed)
         {
            this.var_85.p2pSpeed = 0;
         }
         for(_loc3_ in this.var_75)
         {
            this.var_85 = (this.var_75[_loc3_] as StatisticsElement).method_178();
            _loc1_ = _loc1_ + (!this.var_85.httpSpeed?0:this.var_85.httpSpeed);
            _loc2_ = _loc2_ + (!this.var_85.p2pSpeed?0:this.var_85.p2pSpeed);
         }
         this.var_86 = _loc1_ + _loc2_;
         _loc4_ = new Object();
         _loc4_.info = _loc2_;
         _loc4_.name = "P2PSpeed";
         this.method_88(_loc4_);
         _loc5_ = new Object();
         _loc5_.info = _loc1_;
         _loc5_.name = "avgSpeed";
         this.method_88(_loc5_);
         if(this.outMsg != null)
         {
            this.outMsg(this.var_84 + " ,HS:" + _loc1_ + " ,PS:" + _loc2_,"myName");
         }
      }
      
      public function get method_107() : Number
      {
         return this.var_86;
      }
      
      public function get method_108() : Number
      {
         return this.var_87;
      }
      
      public function get method_109() : Number
      {
         return this.var_88;
      }
      
      public function method_110(param1:String, param2:Number, param3:Number, param4:Number, param5:String, param6:String, param7:String = "PC", param8:String = "rtmfp") : void
      {
         var _loc9_:Date = null;
         this.var_81 = this.var_81 + param4;
         this.var_76 = this.var_75[param6];
         if(this.var_76)
         {
            this.var_76.method_110(param1,param2,param3,param4,param5,param7,param8);
         }
         if(null == this.var_73)
         {
            return;
         }
         if(this.var_90 == 0)
         {
            this.var_90 = this.getTime();
         }
         var _loc10_:Object = new Object();
         _loc10_.id = param1 + ", " + param5.substr(0,8) + ", " + param7;
         if(param1.indexOf("TN") > -1)
         {
            _loc9_ = new Date(int(param1.split("_")[1]) * 1000);
            _loc10_.id = _loc10_.id + ", " + _loc9_.hours + ":" + _loc9_.minutes + ":" + _loc9_.seconds;
         }
         _loc10_.code = "P2P.P2PGetChunk.Success";
         (this.var_73 as EventDispatcher).dispatchEvent(new EventExtensions(NETSTREAM_PROTOCOL.const_4,_loc10_));
         if(this.outMsg != null)
         {
            if(param8 == "utp")
            {
               this.outMsg(String("utp " + _loc10_.id + ", " + param7));
            }
            else
            {
               this.outMsg(String("p2p " + _loc10_.id + ", " + param7));
            }
         }
         this.var_77++;
         this.method_111();
      }
      
      public function method_42(param1:String, param2:Number, param3:Number, param4:Number, param5:String) : void
      {
         var _loc6_:Date = null;
         this.var_82 = this.var_82 + param4;
         this.var_76 = this.var_75[param5];
         if(this.var_76)
         {
            this.var_76.method_42(param1,param2,param3,param4);
         }
         if(null == this.var_73)
         {
            return;
         }
         if(this.var_90 == 0)
         {
            this.var_90 = this.getTime();
         }
         var _loc7_:Object = new Object();
         _loc7_.id = param1 + " " + String(param5).substr(0,3);
         if(param1.indexOf("TN") > -1)
         {
            _loc6_ = new Date(int(param1.split("_")[1]) * 1000);
            _loc7_.id = _loc7_.id + " " + _loc6_.hours + ":" + _loc6_.minutes + ":" + _loc6_.seconds;
         }
         _loc7_.code = "Http.LoadClip.Success";
         (this.var_73 as EventDispatcher).dispatchEvent(new EventExtensions(NETSTREAM_PROTOCOL.const_4,_loc7_));
         if(this.outMsg != null)
         {
            this.outMsg(String("http " + _loc7_.id));
         }
         this.var_78++;
         this.method_111();
      }
      
      private function method_111() : void
      {
         var _loc1_:Object = new Object();
         _loc1_.info = Math.round(Number(1000 * this.var_81 / (this.var_82 + this.var_81))) / 10;
         _loc1_.name = "P2PRate";
         this.method_88(_loc1_);
         if(this.outMsg != null)
         {
            this.outMsg(String(_loc1_.info + "%, CLoad: " + this.var_78 + "PLoad: " + this.var_77 + "Share: " + this.var_79),"p2p下载率");
         }
      }
      
      public function method_112(param1:String) : void
      {
         if(null == this.var_73)
         {
            return;
         }
         var _loc2_:Object = new Object();
         _loc2_.id = param1;
         _loc2_.code = "Http.LoadClip.Failed";
         (this.var_73 as EventDispatcher).dispatchEvent(new EventExtensions(NETSTREAM_PROTOCOL.const_4,_loc2_));
      }
      
      public function getDnode() : uint
      {
         var _loc2_:String = null;
         var _loc1_:uint = 0;
         for(_loc2_ in this.var_75)
         {
            _loc1_ = _loc1_ + this.var_75[_loc2_].getDnode();
         }
         return _loc1_;
      }
      
      public function getLnode() : uint
      {
         var _loc2_:String = null;
         var _loc1_:uint = 0;
         for(_loc2_ in this.var_75)
         {
            _loc1_ = _loc1_ + this.var_75[_loc2_].getLnode();
         }
         return _loc1_;
      }
      
      public function method_113(param1:Object, param2:uint, param3:uint, param4:String, param5:String = "") : void
      {
         this.var_76 = this.var_75[param4];
         if(this.var_76)
         {
            this.var_76.method_113(param2,param3);
         }
         var _loc6_:Object = new Object();
         _loc6_.name = "peerID";
         _loc6_.gid = param4;
         _loc6_.data = param1;
         this.method_88(_loc6_);
         if(this.var_72 != param4)
         {
            return;
         }
         if(this.outMsg != null)
         {
            this.outMsg(param2,"dnode");
            if(LiveVodConfig.TYPE != LiveVodConfig.LIVE)
            {
               this.outMsg(param3,"lnode");
            }
            else
            {
               this.outMsg(param3 + " cr : " + LiveVodConfig.DAT_LOAD_RATE,"lnode");
            }
         }
         _loc6_ = new Object();
         _loc6_.name = "peerID";
         if(param5 == "ws")
         {
            _loc6_.name = "peerID_ws";
         }
         _loc6_.data = param1;
         this.method_88(_loc6_);
      }
      
      public function method_114(param1:String, param2:String) : void
      {
         var _loc3_:Object = new Object();
         _loc3_.name = "peerState";
         _loc3_.gid = param1;
         var _loc4_:Object = new Object();
         _loc4_.farID = param2;
         _loc4_.state = "signalling";
         _loc3_.data = _loc4_;
         this.method_88(_loc3_);
      }
      
      public function method_115(param1:String, param2:String) : void
      {
         if(null == this.var_73)
         {
            return;
         }
         var _loc3_:Object = new Object();
         _loc3_.code = "P2P.P2PShareChunk.Success";
         _loc3_.pieceID = param1;
         _loc3_.remoteID = param2;
         (this.var_73 as EventDispatcher).dispatchEvent(new EventExtensions(NETSTREAM_PROTOCOL.const_4,_loc3_));
         this.var_79++;
      }
      
      public function method_116(param1:String) : void
      {
         if(null == this.var_73)
         {
            return;
         }
         var _loc2_:Object = new Object();
         _loc2_.code = "P2P.RemoveData.Success";
         _loc2_.id = param1;
         (this.var_73 as EventDispatcher).dispatchEvent(new EventExtensions(NETSTREAM_PROTOCOL.const_4,_loc2_));
      }
      
      public function DatSkip(param1:String) : void
      {
         if(null == this.var_73)
         {
            return;
         }
         var _loc2_:Object = new Object();
         _loc2_.code = "P2P.DatSkip.Success";
         _loc2_.id = param1;
         (this.var_73 as EventDispatcher).dispatchEvent(new EventExtensions(NETSTREAM_PROTOCOL.const_4,_loc2_));
      }
      
      public function DESCSkip(param1:String) : void
      {
         if(null == this.var_73)
         {
            return;
         }
         var _loc2_:Object = new Object();
         _loc2_.code = "P2P.DESCSkip.Success";
         _loc2_.id = param1;
         (this.var_73 as EventDispatcher).dispatchEvent(new EventExtensions(NETSTREAM_PROTOCOL.const_4,_loc2_));
      }
      
      public function method_117(param1:String) : void
      {
         if(null == this.var_73)
         {
            return;
         }
         var _loc2_:Object = new Object();
         _loc2_.code = "P2P.CheckSum.Failed";
         _loc2_.id = param1;
         (this.var_73 as EventDispatcher).dispatchEvent(new EventExtensions(NETSTREAM_PROTOCOL.const_4,_loc2_));
         if(this.outMsg != null)
         {
            this.outMsg(param1);
         }
      }
      
      public function method_118(param1:String) : void
      {
         if(null == this.var_73)
         {
            return;
         }
         var _loc2_:Object = new Object();
         _loc2_.code = "Http.LoadXML.Failed";
         _loc2_.id = param1;
         (this.var_73 as EventDispatcher).dispatchEvent(new EventExtensions(NETSTREAM_PROTOCOL.const_4,_loc2_));
      }
      
      public function method_119(param1:String) : void
      {
         var _loc2_:Object = new Object();
         _loc2_.code = "Stream.ForceSeek.Start";
         _loc2_.id = param1;
         (this.var_73 as EventDispatcher).dispatchEvent(new EventExtensions(NETSTREAM_PROTOCOL.const_4,_loc2_));
      }
      
      public function method_120(param1:String) : void
      {
      }
      
      public function allCDNFailed() : void
      {
      }
      
      public function bufferTime(param1:Number, param2:Number, param3:int, param4:int) : void
      {
         if(this.outMsg != null)
         {
            if(param4 < 0)
            {
               var param4:* = 0;
            }
            this.outMsg(String(param1 + ", BufLength= " + param2 + ", ad= " + param3 + ", nowAd= " + param4),"bufferTime");
         }
         var _loc5_:Object = new Object();
         _loc5_.info = param2;
         _loc5_.name = "bufferLength";
         this.method_88(_loc5_);
         _loc5_.info = param1;
         _loc5_.name = "bufferTime";
         this.method_88(_loc5_);
      }
      
      public function peerRemoveHaveData(param1:String, param2:Number, param3:Number) : void
      {
         if(null == this.var_73)
         {
            return;
         }
         var _loc4_:Object = new Object();
         _loc4_.code = "P2P.peerRemoveHaveData.Success";
         _loc4_.bID = param2;
         _loc4_.pID = param3;
         _loc4_.peerID = param1.substr(0,5);
         (this.var_73 as EventDispatcher).dispatchEvent(new EventExtensions(NETSTREAM_PROTOCOL.const_4,_loc4_));
      }
      
      public function method_121(param1:String) : void
      {
         var _loc2_:Object = new Object();
         _loc2_.info = param1;
         _loc2_.name = "avgSpeed";
         this.method_88(_loc2_);
      }
      
      public function method_122(param1:String) : void
      {
         var _loc2_:Object = new Object();
         _loc2_.info = param1;
         _loc2_.name = "P2PSpeed";
         this.method_88(_loc2_);
      }
      
      public function method_123(param1:*) : void
      {
         if(!this.var_73)
         {
            this.var_73 = param1;
         }
         if(this.var_74 == null)
         {
            this.var_74 = new Object();
         }
      }
      
      public function method_124() : Number
      {
         if(this.var_73)
         {
            return this.var_73.time + 8;
         }
         return 0;
      }
      
      public function addEventListener() : void
      {
         if(false == EventWithData.method_261().hasEventListener(NETSTREAM_PROTOCOL.PLAY))
         {
            EventWithData.method_261().addEventListener(NETSTREAM_PROTOCOL.PLAY,this.streamPlayHandler);
         }
      }
      
      public function removeEventListener() : void
      {
         if(EventWithData.method_261().hasEventListener(NETSTREAM_PROTOCOL.PLAY))
         {
            EventWithData.method_261().removeEventListener(NETSTREAM_PROTOCOL.PLAY,this.streamPlayHandler);
         }
         this.clear();
         var_267 = null;
      }
      
      public function method_125(param1:String) : void
      {
         if(null == this.var_73)
         {
            return;
         }
         var _loc2_:Object = new Object();
         _loc2_.id = param1;
         _loc2_.code = "SetPieceStreamFailed";
         (this.var_73 as EventDispatcher).dispatchEvent(new EventExtensions(NETSTREAM_PROTOCOL.const_4,_loc2_));
         if(this.outMsg != null)
         {
            this.outMsg(String("error: " + param1));
         }
      }
      
      private function getTime() : Number
      {
         return Math.floor(new Date().time);
      }
   }
}

class Singleton extends Object
{
   
   function Singleton()
   {
      super();
   }
}
