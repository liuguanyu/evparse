package com.hls_p2p.loaders.p2pLoader
{
   import flash.net.NetStream;
   import flash.utils.Timer;
   import com.hls_p2p.dataManager.DataManager;
   import flash.events.NetStatusEvent;
   import flash.events.AsyncErrorEvent;
   import com.p2p.utils.console;
   import com.hls_p2p.statistics.Statistic;
   import com.hls_p2p.data.Piece;
   import com.hls_p2p.data.vo.LiveVodConfig;
   import flash.utils.ByteArray;
   import flash.events.TimerEvent;
   
   public class SignallingStrategy_V1 extends Object
   {
      
      public var isDebug:Boolean = false;
      
      public var var_215:P2P_Pipe;
      
      private var var_216:NetStream = null;
      
      protected var var_217:Number = -1;
      
      protected var var_218:Timer;
      
      protected var var_219:P2P_Loader = null;
      
      protected var var_156:DataManager = null;
      
      protected var var_220:String = "";
      
      public var var_221:Array;
      
      private var var_222:Number = 0;
      
      protected var var_223:Boolean = false;
      
      protected var var_224:Number = -1;
      
      protected var var_225:String = "";
      
      protected var remotePNList:Array;
      
      protected var remoteTNList:Array;
      
      protected var var_226:Array;
      
      protected var var_227:Array = null;
      
      private var var_186:Timer;
      
      public var var_228:Boolean = false;
      
      private var var_229:Boolean = false;
      
      private var var_230:Boolean = false;
      
      private var var_38:Number = 0;
      
      private var var_231:Number = 0;
      
      private var var_232:Piece;
      
      public function SignallingStrategy_V1(param1:P2P_Pipe, param2:P2P_Loader, param3:DataManager)
      {
         this.var_221 = new Array();
         super();
         this.var_215 = param1;
         this.var_219 = param2;
         this.var_156 = param3;
         this.var_215.name_7 = this.name_7;
         this.var_215.name_5 = this.name_5;
         this.var_222 = this.getTime();
         this.var_186 = new Timer(3 * 1000,1);
         this.var_186.addEventListener(TimerEvent.TIMER,this.peerHartBeatTimer);
      }
      
      public function get name_4() : Number
      {
         return this.var_222;
      }
      
      public function set XNetStream(param1:NetStream) : void
      {
         if(!this.var_216)
         {
            this.var_216 = param1;
            this.var_216.client = this;
            if(!this.var_216.hasEventListener(NetStatusEvent.NET_STATUS))
            {
               this.var_216.addEventListener(NetStatusEvent.NET_STATUS,this.method_230);
            }
            if(!this.var_216.hasEventListener(AsyncErrorEvent.ASYNC_ERROR))
            {
               this.var_216.addEventListener(AsyncErrorEvent.ASYNC_ERROR,this.method_222);
            }
         }
      }
      
      public function get XNetStream() : NetStream
      {
         return this.var_216;
      }
      
      public function pipeprocess(... rest) : void
      {
         console.log(this,"SignallingStrategy_V1 pipeprocess");
      }
      
      public function method_228(param1:*, param2:*) : void
      {
         console.log(this,"SignallingStrategy_V1 stopTransmit called");
      }
      
      public function method_229() : void
      {
         console.log(this,"SignallingStrategy_V1 startTransmit called");
      }
      
      private function method_222(param1:AsyncErrorEvent) : void
      {
      }
      
      private function method_230(param1:NetStatusEvent = null) : void
      {
         console.log(this,"SignallingStrategy_V1 startTransmit called");
      }
      
      public function method_231(param1:int) : void
      {
         if(this.var_186)
         {
            this.var_186.delay = param1;
            this.var_186.repeatCount = 1;
            this.var_186.reset();
            this.var_186.start();
         }
      }
      
      public function name_5(param1:String, param2:Object = null, param3:String = null) : void
      {
         this.var_222 = this.getTime();
         if(param2)
         {
            Statistic.method_261().method_114(this.groupID,this.remoteID);
            if(param2.TNList)
            {
               this.remoteTNList = param2.TNList;
            }
            if(param2.PNList)
            {
               this.remotePNList = param2.PNList;
            }
            if((true == this.var_230) && (param2.peerListArr) && param2.peerListArr.length > 0)
            {
               this.var_219.method_215(param2.peerListArr);
               this.var_230 = false;
            }
            if(param2.playType)
            {
               this.var_225 = param2.playType;
            }
            if(param2.nearestWantID)
            {
               this.var_217 = param2.nearestWantID;
            }
            if(param2.requetData)
            {
               this.var_227 = this.method_239(param2.requetData);
            }
            if(param2.sendData)
            {
               this.method_240(param2.sendData);
            }
            if(param2.clientType)
            {
               this.var_220 = param2.clientType;
               console.log(this,"remoteClientType = " + this.var_220);
            }
            if(param2.version)
            {
            }
            if(param2.isWantPeerList == true)
            {
               this.var_229 = param2.isGetPeerList;
            }
         }
         this.method_235(false);
      }
      
      public function get startTime() : Number
      {
         if(this.var_38 > 0)
         {
            return this.var_38;
         }
         return this.var_38;
      }
      
      public function method_232() : Boolean
      {
         return Math.floor(new Date().time) - this.var_222 > 3 * 60 * 1000;
      }
      
      public function method_233() : Boolean
      {
         if(this.getTime() - this.var_222 > 9 * 1000)
         {
            return false;
         }
         return true;
      }
      
      public function method_234() : Boolean
      {
         if(this.getTime() - this.var_222 > 9 * 1000)
         {
            return false;
         }
         return true;
      }
      
      public function pipeConnected() : Boolean
      {
         return (this.canSend) && (this.name_6);
      }
      
      private function peerHartBeatTimer(param1:* = null) : void
      {
         this.method_235(true);
      }
      
      private function method_235(param1:Boolean = false) : void
      {
         var _loc2_:Object = null;
         var _loc3_:Piece = null;
         if((param1) && this.getTime() - this.var_231 < 1000)
         {
            return;
         }
         this.method_241();
         if(this.var_215.canSend)
         {
            _loc2_ = new Object();
            _loc2_.clientType = LiveVodConfig.const_7;
            _loc2_.version = LiveVodConfig.method_263();
            _loc2_.playType = LiveVodConfig.TYPE;
            _loc2_.nearestWantID = LiveVodConfig.method_94;
            if(true == LiveVodConfig.ifCanP2PUpload)
            {
               _loc2_.TNList = this.var_156.getTNRange(this.groupID);
               _loc2_.PNList = this.var_156.getPNRange(this.groupID);
            }
            else
            {
               _loc2_.TNList = null;
               _loc2_.PNList = null;
            }
            if(true == LiveVodConfig.ifCanP2PDownload && this.var_221.length == 0 && (this.method_236()))
            {
               _loc3_ = this.getTask(this.remoteTNList,this.remotePNList) as Piece;
               if(null == _loc3_)
               {
                  _loc2_.requetData = null;
               }
               else
               {
                  this.var_221.push(_loc3_);
                  if(_loc3_.type == "TN")
                  {
                     _loc2_.requetData = [{
                        "type":_loc3_.type,
                        "key":_loc3_.pieceKey,
                        "checksum":_loc3_.checkSum
                     }];
                  }
                  else if(_loc3_.type == "PN")
                  {
                     _loc2_.requetData = [{
                        "type":_loc3_.type,
                        "key":_loc3_.pieceKey
                     }];
                  }
                  
               }
            }
            else
            {
               _loc2_.requetData = null;
            }
            if((this.var_227) && this.var_227.length > 0)
            {
               _loc2_.sendData = this.var_227;
               this.var_227 = null;
            }
            else
            {
               _loc2_.sendData = null;
            }
            if(this.method_233() == true && (this.var_219.isWantPeerList()))
            {
               _loc2_.isWantPeerList = true;
               this.var_230 = true;
            }
            else
            {
               _loc2_.isWantPeerList = false;
            }
            if((param1) || !(_loc2_.sendData == null) || !(_loc2_.requetData == null))
            {
               if((param1) && (LiveVodConfig.IS_SHARE_PEERS) && true == this.var_229)
               {
                  _loc2_.peerListArr = this.var_219.method_214(this.remoteID);
                  this.var_229 = false;
               }
               this.method_237(_loc2_);
               if(this.var_215)
               {
                  this.var_215.sendData(LiveVodConfig.method_264(),_loc2_);
               }
               this.var_231 = this.getTime();
            }
         }
      }
      
      private function method_236() : Boolean
      {
         if(LiveVodConfig.TYPE == LiveVodConfig.VOD)
         {
            if(true == LiveVodConfig.IS_CHANGE_KBPS && !("" == LiveVodConfig.currentChangeVid) && this.groupID == LiveVodConfig.currentChangeVid)
            {
               return true;
            }
            if(this.groupID == LiveVodConfig.currentVid)
            {
               return true;
            }
            if(!("" == LiveVodConfig.nextVid) && this.groupID == LiveVodConfig.nextVid)
            {
               return true;
            }
            return false;
         }
         return true;
      }
      
      protected function method_237(param1:Object) : void
      {
         var i:int = 0;
         var j:int = 0;
         var data:Object = param1;
         if(data.requetData)
         {
            i = 0;
            while(i < (data.requetData as Array).length)
            {
               Statistic.method_261().method_105(data.requetData[i]["type"] + "_" + data.requetData[i]["key"],this.var_215.remoteID);
               i++;
            }
         }
         if(data.sendData)
         {
            j = 0;
            while(j < (data.sendData as Array).length)
            {
               try
               {
                  this.var_232 = this.var_156.method_5({
                     "groupID":this.groupID,
                     "pieceKey":data.sendData[j]["key"],
                     "type":data.sendData[j]["type"]
                  });
                  this.var_232.method_46++;
                  Statistic.method_261().method_115(data.sendData[j]["type"] + "_" + data.sendData[j]["key"],this.var_215.remoteID);
               }
               catch(err:Error)
               {
                  console.log(this,"err:" + err + err.getStackTrace());
               }
               j++;
            }
         }
      }
      
      public function method_238(param1:Object) : Boolean
      {
         var _loc3_:uint = 0;
         var _loc4_:* = 0;
         var _loc5_:* = 0;
         if(false == this.pipeConnected())
         {
            var param1:Object = null;
            return false;
         }
         var _loc2_:Number = new Date().time;
         if(!(null == this.var_226) && this.var_224 < LiveVodConfig.BirthTime)
         {
            _loc3_ = 0;
            while(_loc3_ < this.var_226.length)
            {
               if(this.var_226[_loc3_]["groupID"] == param1.groupID && this.var_226[_loc3_]["pieceKey"] == param1.pieceKey && this.var_226[_loc3_]["type"] == param1.type)
               {
                  param1 = null;
                  return true;
               }
               _loc3_++;
            }
         }
         if(null != this.remotePNList)
         {
            _loc4_ = 0;
            while(_loc4_ < this.remotePNList.length)
            {
               if(param1.type == "PN" && param1.pieceKey >= this.remotePNList[_loc4_]["start"] && param1.pieceKey <= this.remotePNList[_loc4_]["end"])
               {
                  param1 = null;
                  return true;
               }
               _loc4_++;
            }
         }
         if(null != this.remoteTNList)
         {
            _loc5_ = 0;
            while(_loc5_ < this.remoteTNList.length)
            {
               if(param1.type == "TN" && param1.pieceKey >= this.remoteTNList[_loc5_]["start"] && param1.pieceKey <= this.remoteTNList[_loc5_]["end"])
               {
                  param1 = null;
                  return true;
               }
               _loc5_++;
            }
         }
         param1 = null;
         return false;
      }
      
      protected function getTask(param1:Array, param2:Array) : Object
      {
         if(this.groupID == "t_88ec2152415da0c64ce5e58b222b6fb7ver_00_221.3m3u8_12272000")
         {
            trace("getTask");
         }
         if(null == param1 && null == param2)
         {
            return null;
         }
         var _loc3_:Object = new Object();
         _loc3_.groupID = this.groupID;
         _loc3_.TNrange = param1;
         _loc3_.PNrange = param2;
         _loc3_.remoteID = this.var_215.remoteID;
         var _loc4_:Object = this.var_156.method_7(_loc3_);
         _loc3_ = null;
         return _loc4_;
      }
      
      protected function method_239(param1:Array) : Array
      {
         var _loc3_:Piece = null;
         var _loc4_:Object = null;
         var _loc6_:String = null;
         var _loc7_:String = null;
         var _loc2_:Array = new Array();
         if(null == param1)
         {
            return _loc2_;
         }
         var _loc5_:* = 0;
         while(_loc5_ < param1.length)
         {
            if(param1[_loc5_])
            {
               _loc6_ = param1[_loc5_]["type"];
               _loc7_ = param1[_loc5_]["key"];
               if((_loc6_) && (_loc7_))
               {
                  _loc3_ = this.var_156.method_5({
                     "groupID":this.groupID,
                     "type":param1[_loc5_].type,
                     "pieceKey":param1[_loc5_].key
                  });
                  if(!(!_loc3_ || false == _loc3_.name_1))
                  {
                     if(!(_loc6_ == "TN" && !(_loc3_.checkSum == param1[_loc5_]["checksum"])))
                     {
                        _loc4_ = {
                           "type":_loc3_.type,
                           "key":_loc3_.pieceKey,
                           "data":_loc3_.method_50()
                        };
                        _loc2_.push(_loc4_);
                        if(_loc2_.length > 0)
                        {
                           break;
                        }
                     }
                  }
               }
            }
            _loc5_++;
         }
         _loc3_ = null;
         return _loc2_;
      }
      
      protected function method_240(param1:Array) : void
      {
         var _loc3_:Piece = null;
         var _loc4_:* = 0;
         if(null == param1)
         {
            return;
         }
         var _loc2_:* = 0;
         _loc2_ = 0;
         while(_loc2_ < param1.length)
         {
            if(param1[_loc2_])
            {
               if((param1[_loc2_].hasOwnProperty("type")) && (param1[_loc2_].hasOwnProperty("key")) && (param1[_loc2_].hasOwnProperty("data")) && (param1[_loc2_].data as ByteArray).length > 0)
               {
                  _loc3_ = this.var_156.method_5({
                     "groupID":this.groupID,
                     "type":param1[_loc2_].type,
                     "pieceKey":param1[_loc2_].key
                  });
                  if(_loc3_)
                  {
                     if(false == _loc3_.name_1)
                     {
                        this.var_228 = true;
                        _loc3_.method_48(param1[_loc2_].data as ByteArray,this.var_215.remoteID,this.var_220);
                     }
                     else
                     {
                        Statistic.method_261().method_84(_loc3_.pieceKey,_loc3_.from);
                     }
                     _loc4_ = this.var_221.indexOf(_loc3_);
                     if(-1 != _loc4_)
                     {
                        this.var_221.splice(_loc4_,1);
                     }
                  }
               }
            }
            _loc2_++;
         }
         _loc3_ = null;
      }
      
      protected function method_241() : void
      {
         var _loc1_:* = 0;
         var _loc2_:Piece = null;
         var _loc3_:* = 0;
         if(this.var_221)
         {
            _loc1_ = this.var_221.length;
            while(_loc1_ > 0)
            {
               _loc1_--;
               _loc2_ = this.var_156.method_5({
                  "groupID":this.groupID,
                  "type":this.var_221[_loc1_].type,
                  "pieceKey":this.var_221[_loc1_].pieceKey
               });
               if(_loc2_)
               {
                  if((_loc2_.name_1) && _loc2_.method_50().length > 0 || this.getTime() - _loc2_.var_23 > 30 * 1000)
                  {
                     _loc3_ = this.var_221.indexOf(_loc2_);
                     if(-1 != _loc3_)
                     {
                        this.var_221.splice(_loc3_,1);
                     }
                     if(this.getTime() - _loc2_.var_23 > 30 * 1000)
                     {
                        Statistic.method_261().method_85(_loc2_.pieceKey,_loc2_.peerID);
                     }
                  }
               }
            }
         }
      }
      
      protected function getTime() : Number
      {
         return Math.floor(new Date().time);
      }
      
      public function clear() : void
      {
         var _loc1_:* = undefined;
         var _loc2_:Piece = null;
         console.log(this,"clear");
         if(this.var_186)
         {
            this.var_186.stop();
            this.var_186.removeEventListener(TimerEvent.TIMER,this.peerHartBeatTimer);
            this.var_186 = null;
         }
         if((this.var_221) && this.var_221.length > 0)
         {
            for each(_loc1_ in this.var_221)
            {
               _loc2_ = this.var_156.method_5({
                  "groupID":this.groupID,
                  "type":_loc1_.type,
                  "pieceKey":_loc1_.pieceKey
               });
               if(_loc2_)
               {
                  _loc2_ = null;
               }
            }
         }
         this.var_221 = null;
         this.remotePNList = null;
         this.remoteTNList = null;
         this.var_226 = null;
         this.var_227 = null;
         if(this.var_216)
         {
            this.var_216.close();
            if(this.var_216.hasEventListener(NetStatusEvent.NET_STATUS))
            {
               this.var_216.removeEventListener(NetStatusEvent.NET_STATUS,this.method_230);
            }
            if(this.var_216.hasEventListener(AsyncErrorEvent.ASYNC_ERROR))
            {
               this.var_216.removeEventListener(AsyncErrorEvent.ASYNC_ERROR,this.method_222);
            }
            this.var_216 = null;
         }
         this.var_215.clear();
         this.var_215.name_7 = null;
         this.var_215.name_5 = null;
         this.var_215 = null;
         this.var_216 = null;
         this.var_219 = null;
         this.var_156 = null;
         this.var_220 = "PC";
         this.var_222 = 0;
         this.var_223 = false;
         this.var_224 = -1;
         this.var_217 = -1;
         this.var_232 = null;
         this.var_228 = false;
         this.var_229 = false;
         this.var_230 = false;
      }
      
      public function set method_242(param1:NetStream) : void
      {
         this.var_215.XNetStream = param1;
      }
      
      public function get name_6() : Boolean
      {
         return this.var_215.name_6;
      }
      
      public function set name_6(param1:Boolean) : void
      {
         this.var_215.name_6 = param1;
      }
      
      public function get canSend() : Boolean
      {
         return this.var_215.canSend;
      }
      
      public function set canSend(param1:Boolean) : void
      {
         this.var_215.canSend = param1;
      }
      
      public function get remoteID() : String
      {
         return this.var_215.remoteID;
      }
      
      public function get method_243() : String
      {
         return this.var_215.method_243;
      }
      
      public function get groupID() : String
      {
         return this.var_215.groupID;
      }
      
      public function name_7(param1:Object) : void
      {
         this.var_223 = param1 as Boolean;
      }
   }
}
