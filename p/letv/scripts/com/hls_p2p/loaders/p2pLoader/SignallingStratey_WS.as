package com.hls_p2p.loaders.p2pLoader
{
   import com.hls_p2p.dataManager.DataManager;
   import flash.utils.Timer;
   import flash.utils.ByteArray;
   import com.hls_p2p.data.Piece;
   import com.p2p.utils.console;
   import flash.utils.Endian;
   import com.hls_p2p.data.vo.LiveVodConfig;
   import com.hls_p2p.statistics.Statistic;
   import flash.events.TimerEvent;
   
   public class SignallingStratey_WS extends Object
   {
      
      public var isDebug:Boolean = true;
      
      protected var var_225:String = "";
      
      protected var var_220:String = "WS";
      
      protected var remotePNList:Array;
      
      protected var remoteTNList:Array;
      
      protected var var_226:Array;
      
      protected var var_227:Array = null;
      
      protected var var_252:WS_Pipe;
      
      protected var var_219:WebSocket_Loader;
      
      protected var var_156:DataManager;
      
      public var var_221:Array;
      
      protected var name_4:Number = 0;
      
      public var var_228:Boolean = false;
      
      private var var_229:Boolean = false;
      
      private var var_230:Boolean = false;
      
      private var var_253:Boolean = false;
      
      private var var_186:Timer;
      
      private var var_254:Number = 0;
      
      private var var_255:Number = 0;
      
      private var var_231:Number = 0;
      
      public function SignallingStratey_WS(param1:WS_Pipe, param2:WebSocket_Loader, param3:DataManager)
      {
         this.var_221 = new Array();
         super();
         switch(param1.var_256)
         {
            case "0":
               this.var_220 = "";
               break;
            case "1":
               this.var_220 = "PC";
               break;
            case "2":
               this.var_220 = "MP";
               break;
            case "3":
               this.var_220 = "BOX";
               break;
            case "4":
               this.var_220 = "TV";
               break;
         }
         this.var_252 = param1;
         this.var_219 = param2;
         this.var_156 = param3;
         this.var_254 = 0;
         this.var_255 = 0;
         param1.name_5 = this.name_5;
         param1.name_7 = this.sendHandshake;
         this.name_4 = this.getTime();
         this.var_186 = new Timer(1000);
         this.var_186.addEventListener(TimerEvent.TIMER,this.peerHartBeatTimer);
         this.var_186.start();
      }
      
      protected function getTime() : Number
      {
         return Math.floor(new Date().time);
      }
      
      public function sendHandshake(param1:String) : void
      {
         var _loc3_:String = null;
         var _loc4_:Object = null;
         var _loc5_:String = null;
         var _loc6_:String = null;
         if(param1 == null)
         {
            return;
         }
         this.var_253 = true;
         var _loc2_:Array = param1.split(new RegExp("\\r?\\n"));
         while(_loc2_.length > 0)
         {
            _loc3_ = _loc2_.shift();
            _loc4_ = this.parseHTTPHeader(_loc3_);
            if(_loc4_ == null)
            {
               continue;
            }
            _loc5_ = _loc4_.name.toLocaleLowerCase();
            _loc6_ = _loc4_.value.toLocaleLowerCase();
            switch(_loc5_)
            {
               case "x-mtep-client-id":
                  continue;
               case "x-mtep-client-module":
                  continue;
               case "x-mtep-client-version":
                  continue;
               case "x-mtep-protocol-version":
                  continue;
               case "x-mtep-business-tags":
                  continue;
               case "x-mtep-os-platform":
                  continue;
               case "x-mtep-hardware-platform":
                  continue;
               default:
                  continue;
            }
         }
      }
      
      private function method_248() : void
      {
         var _loc1_:ByteArray = null;
         var _loc2_:Array = null;
         var _loc3_:Array = null;
         var _loc4_:Array = null;
         var _loc5_:Array = null;
         var _loc6_:* = 0;
         var _loc7_:Array = null;
         var _loc8_:* = 0;
         var _loc9_:* = NaN;
         var _loc10_:* = NaN;
         var _loc11_:* = 0;
         var _loc12_:Piece = null;
         var _loc13_:Array = null;
         var _loc14_:* = 0;
         if((this.var_252) && (this.var_252.canSend))
         {
            console.log("handle Send WebSocketData ");
            this.var_254++;
            _loc1_ = new ByteArray();
            _loc1_.endian = Endian.BIG_ENDIAN;
            _loc2_ = [{"sequence_4":0},{"rangeCount_4":0},{"rangeItems":[[{"type_2":123},{"start_8":234},{"end_4":345}]]},{"requestCount_4":0},{"requestItems":[[{"type_2":0},{"start_8":1411033199},{"cks_4":57473}]]},{"responseCount_4":0},{"responseItems":[[{"type_2":0},{"start_8":1411033199},{"streamLength_4":57473},{"stream_d":new ByteArray()}]]},{"peerCount_4":1},{"peerItems":[[{"head_4":0},{"URL_utf":"ws://202.103.4.52:34567/*****"}]]}];
            _loc3_ = [];
            if(true == LiveVodConfig.ifCanP2PUpload)
            {
               _loc4_ = this.var_156.getTNRange(this.groupID);
               if(_loc4_ != null)
               {
                  _loc11_ = 0;
                  while(_loc11_ < _loc4_.length)
                  {
                     _loc9_ = _loc4_[_loc11_]["start"];
                     _loc10_ = _loc4_[_loc11_]["end"];
                     _loc3_.push([{"type_2":0},{"start_8":_loc9_},{"end_4":_loc10_ - _loc9_ + 1}]);
                     _loc11_++;
                  }
               }
               _loc4_ = this.var_156.getPNRange(this.groupID);
               if(_loc4_ != null)
               {
                  _loc11_ = 0;
                  while(_loc11_ < _loc4_.length)
                  {
                     _loc9_ = _loc4_[_loc11_]["start"];
                     _loc10_ = _loc4_[_loc11_]["end"];
                     _loc3_.push([{"type_2":1},{"start_8":_loc9_},{"end_4":_loc10_ - _loc9_ + 1}]);
                     _loc11_++;
                  }
               }
            }
            _loc2_[2]["rangeItems"] = _loc3_;
            _loc5_ = [];
            _loc6_ = 0;
            if(this.var_221 == null)
            {
               this.var_221 = [];
            }
            if(true == LiveVodConfig.ifCanP2PDownload && this.var_221.length == 0 && (this.method_236()))
            {
               _loc12_ = this.getTask(this.remoteTNList,this.remotePNList) as Piece;
               if(null != _loc12_)
               {
                  this.var_221.push(_loc12_);
                  if(_loc12_.type == "PN")
                  {
                     _loc6_ = 1;
                  }
                  _loc5_.push([{"type_2":_loc6_},{"start_8":_loc12_.pieceKey},{"cks_4":_loc12_.checkSum}]);
               }
            }
            _loc2_[4]["requestItems"] = _loc5_;
            _loc7_ = [];
            _loc6_ = 0;
            if((this.var_227) && this.var_227.length > 0)
            {
               _loc11_ = 0;
               while(_loc11_ < this.var_227.length)
               {
                  if(this.var_227[_loc11_]["type"] == "PN")
                  {
                     _loc6_ = 1;
                  }
                  _loc7_.push([{"type_2":_loc6_},{"start_8":this.var_227[_loc11_]["key"]},{"streamLength_4":this.var_227[_loc11_]["data"].length},{"stream_d":this.var_227[_loc11_]["data"]}]);
                  _loc11_++;
               }
               this.var_227 = null;
            }
            _loc2_[6]["responseItems"] = _loc7_;
            _loc2_[1].rangeCount_4 = _loc2_[2].rangeItems.length;
            _loc2_[3].requestCount_4 = _loc2_[4].requestItems.length;
            _loc2_[5].responseCount_4 = _loc2_[6].responseItems.length;
            _loc8_ = 0;
            while(_loc8_ < _loc2_[6].responseItems.length)
            {
               _loc2_[6].responseItems[_loc8_][2].streamLength_4 = _loc2_[6].responseItems[_loc8_][3].stream_d.length;
               _loc8_++;
            }
            if(LiveVodConfig.IS_SHARE_PEERS)
            {
               _loc13_ = [];
               _loc4_ = this.var_219.method_214(this.remoteID);
               _loc11_ = 0;
               while(_loc11_ < _loc4_.length)
               {
                  _loc13_.push([{"head_4":_loc11_},{"URL_utf":_loc4_[_loc11_]}]);
                  _loc11_++;
               }
               _loc2_[8]["peerItems"] = _loc13_;
               _loc2_[7].peerCount_4 = _loc2_[8].peerItems.length;
               _loc14_ = 0;
               while(_loc14_ < _loc2_[8].peerItems.length)
               {
                  _loc2_[8].peerItems[_loc14_][0].head_4 = _loc2_[8].peerItems[_loc14_][1].URL_utf.length;
                  _loc14_++;
               }
            }
            this.method_237(_loc2_);
            this.method_206(_loc2_,_loc1_);
            this.var_252.sendData("sendBytes",_loc1_);
            return;
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
      
      private function method_249(param1:String, param2:*, param3:ByteArray) : void
      {
         switch(param1)
         {
            case "2":
               param3.writeShort(param2);
               break;
            case "4":
               param3.writeUnsignedInt(param2);
               break;
            case "8":
               param3.writeUnsignedInt(Math.floor(param2 / 4.294967296E9));
               param3.writeUnsignedInt(Math.floor(param2 % 4.294967296E9));
               break;
            case "utf":
               param3.writeUTFBytes(param2);
               break;
            case "d":
               param3.writeBytes(param2);
               break;
         }
      }
      
      private function method_250(param1:String, param2:ByteArray, param3:uint = 0, param4:uint = 0) : *
      {
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         var _loc7_:uint = 0;
         var _loc8_:uint = 0;
         var _loc9_:* = NaN;
         var _loc10_:String = null;
         var _loc11_:ByteArray = null;
         switch(param1)
         {
            case "2":
               param2.position = param3;
               _loc5_ = param2.readShort();
               return _loc5_;
            case "4":
               param2.position = param3;
               _loc6_ = param2.readUnsignedInt();
               return _loc6_;
            case "8":
               param2.position = param3;
               _loc7_ = param2.readUnsignedInt();
               _loc8_ = param2.readUnsignedInt();
               _loc9_ = _loc7_ * 4.294967296E9 + _loc8_;
               return _loc9_;
            case "utf":
               param2.position = param3;
               _loc10_ = param2.readUTFBytes(param4);
               return _loc10_;
            case "d":
               param2.position = param3;
               _loc11_ = new ByteArray();
               param2.readBytes(_loc11_,0,param4);
               return _loc11_;
            default:
               return 0;
         }
      }
      
      private function method_206(param1:*, param2:ByteArray) : void
      {
         var _loc3_:* = 0;
         var _loc4_:String = null;
         var _loc5_:String = null;
         if(param1 is Array)
         {
            _loc3_ = 0;
            while(_loc3_ < param1.length)
            {
               if(param1[_loc3_] is Array)
               {
                  this.method_206(param1[_loc3_],param2);
               }
               else if(param1[_loc3_] is Object)
               {
                  this.method_206(param1[_loc3_],param2);
               }
               
               _loc3_++;
            }
         }
         else if(param1 is Object)
         {
            for(_loc4_ in param1)
            {
               _loc5_ = _loc4_.split("_")[1];
               if(_loc5_)
               {
                  this.method_249(_loc5_,param1[_loc4_],param2);
               }
               if(!_loc5_ && (param1[_loc4_]))
               {
                  this.method_206(param1[_loc4_],param2);
               }
            }
         }
         
      }
      
      private function method_251(param1:ByteArray) : void
      {
         var _loc13_:uint = 0;
         var _loc14_:uint = 0;
         var _loc15_:* = NaN;
         var _loc16_:* = NaN;
         var _loc17_:uint = 0;
         var _loc18_:* = NaN;
         var _loc19_:* = NaN;
         var _loc20_:uint = 0;
         var _loc21_:* = NaN;
         var _loc22_:uint = 0;
         var _loc23_:ByteArray = null;
         var _loc24_:uint = 0;
         var _loc25_:String = null;
         console.log(this,"parseRecieveData " + this.remoteID);
         var _loc2_:uint = 0;
         var _loc3_:uint = this.method_250("4",param1,_loc2_);
         _loc2_ = _loc2_ + 4;
         var _loc4_:uint = this.method_250("4",param1,_loc2_);
         _loc2_ = _loc2_ + 4;
         if(_loc4_ != 0)
         {
            this.remoteTNList = [];
            this.remotePNList = [];
            _loc13_ = 0;
            while(_loc13_ < _loc4_)
            {
               _loc14_ = this.method_250("2",param1,_loc2_);
               _loc2_ = _loc2_ + 2;
               _loc15_ = this.method_250("8",param1,_loc2_);
               _loc2_ = _loc2_ + 8;
               _loc16_ = this.method_250("4",param1,_loc2_);
               _loc2_ = _loc2_ + 4;
               if(0 == _loc14_)
               {
                  this.remoteTNList.push({
                     "start":_loc15_,
                     "end":_loc15_ + _loc16_ - 1
                  });
               }
               else
               {
                  this.remotePNList.push({
                     "start":_loc15_,
                     "end":_loc15_ + _loc16_ - 1
                  });
               }
               _loc13_++;
            }
            console.log(this,"recieve tn range:" + this.remoteTNList.length,"recieve pn range:" + this.remotePNList.length);
         }
         var _loc5_:uint = this.method_250("4",param1,_loc2_);
         _loc2_ = _loc2_ + 4;
         var _loc6_:Array = [];
         var _loc7_:uint = 0;
         while(_loc7_ < _loc5_)
         {
            _loc17_ = this.method_250("2",param1,_loc2_);
            _loc2_ = _loc2_ + 2;
            _loc18_ = this.method_250("8",param1,_loc2_);
            _loc2_ = _loc2_ + 8;
            _loc19_ = this.method_250("4",param1,_loc2_);
            _loc2_ = _loc2_ + 4;
            if(_loc17_ == 0)
            {
               _loc6_.push({
                  "type":"TN",
                  "groupId":this.groupID,
                  "key":_loc18_,
                  "checksum":_loc19_
               });
            }
            else
            {
               _loc6_.push({
                  "type":"PN",
                  "groupId":this.groupID,
                  "key":_loc18_,
                  "checksum":_loc19_
               });
            }
            _loc7_++;
         }
         if(_loc6_.length > 0)
         {
            this.var_227 = this.method_239(_loc6_);
         }
         var _loc8_:uint = this.method_250("4",param1,_loc2_);
         _loc2_ = _loc2_ + 4;
         var _loc9_:uint = this.var_221?this.var_221.length:1;
         var _loc10_:uint = 0;
         while(_loc10_ < _loc8_ && _loc10_ < _loc9_)
         {
            _loc20_ = this.method_250("2",param1,_loc2_);
            _loc2_ = _loc2_ + 2;
            _loc21_ = this.method_250("8",param1,_loc2_);
            _loc2_ = _loc2_ + 8;
            _loc22_ = this.method_250("4",param1,_loc2_);
            _loc2_ = _loc2_ + 4;
            try
            {
               _loc23_ = this.method_250("d",param1,_loc2_,_loc22_);
               _loc2_ = _loc2_ + _loc22_;
               console.log(this,"recieve stream pid:" + _loc21_,this.remoteID);
               this.method_240({
                  "pieceID":_loc21_,
                  "data":_loc23_
               });
            }
            catch(err:Error)
            {
            }
            _loc10_++;
         }
         var _loc11_:uint = this.method_250("4",param1,_loc2_);
         _loc2_ = _loc2_ + 4;
         var _loc12_:uint = 0;
         while(_loc12_ < _loc11_)
         {
            _loc24_ = this.method_250("4",param1,_loc2_);
            _loc2_ = _loc2_ + 4;
            _loc25_ = this.method_250("utf",param1,_loc2_,_loc24_);
            _loc2_ = _loc2_ + _loc24_;
            _loc12_++;
         }
         if(_loc4_ > 0)
         {
            this.var_255++;
            this.method_235(false);
         }
      }
      
      protected function method_237(param1:Array) : void
      {
         var var_232:Piece = null;
         var type:String = null;
         var data:Array = param1;
         var var_221:Array = data[4]["requestItems"] as Array;
         var var_322:Array = data[6]["responseItems"] as Array;
         var i:int = 0;
         while(i < var_221.length)
         {
            Statistic.method_261().method_105(var_221[i][0]["type_2"] + "_" + var_221[i][1]["start_8"],this.var_252.remoteID);
            i++;
         }
         var j:int = 0;
         while(j < var_322.length)
         {
            try
            {
               type = "TN";
               if(var_322[j][0]["type_2"] == 1)
               {
                  type = "PN";
               }
               var_232 = this.var_156.method_5({
                  "groupID":this.groupID,
                  "pieceKey":var_322[j][1]["start_8"],
                  "type":type
               });
               var_232.method_46++;
               Statistic.method_261().method_115(type + "_" + var_322[j][1]["start_8"],this.var_252.remoteID);
            }
            catch(err:Error)
            {
               console.log(this,"err:" + err + err.getStackTrace());
            }
            j++;
         }
      }
      
      private function parseHTTPHeader(param1:String) : Object
      {
         var _loc2_:Array = param1.split(new RegExp("\\: +"));
         return _loc2_.length === 2?{
            "name":_loc2_[0],
            "value":_loc2_[1]
         }:null;
      }
      
      public function name_5(param1:ByteArray) : void
      {
         this.method_251(param1);
      }
      
      protected function method_240(param1:Object) : void
      {
         var _loc2_:Piece = null;
         var _loc3_:* = 0;
         if(this.var_221.length == 0)
         {
            return;
         }
         if((param1.pieceID) && (this.var_221[0] as Piece).pieceKey == param1.pieceID)
         {
            _loc2_ = this.var_156.method_5({
               "groupID":this.groupID,
               "type":(this.var_221[0] as Piece).type,
               "pieceKey":(this.var_221[0] as Piece).pieceKey
            });
            if(_loc2_)
            {
               if(false == _loc2_.name_1)
               {
                  this.var_228 = true;
                  _loc2_.protocol = "ws";
                  _loc2_.method_48(param1.data as ByteArray,this.var_252.remoteID,this.var_220);
               }
               else
               {
                  Statistic.method_261().method_84(_loc2_.pieceKey,_loc2_.from);
               }
               _loc3_ = this.var_221.indexOf(_loc2_);
               if(-1 != _loc3_)
               {
                  this.var_221.splice(_loc3_,1);
               }
            }
         }
         _loc2_ = null;
      }
      
      public function method_233() : Boolean
      {
         if(this.getTime() - this.name_4 > 9 * 1000)
         {
            return false;
         }
         return true;
      }
      
      private function peerHartBeatTimer(param1:* = null) : void
      {
         this.method_235(true);
      }
      
      private function method_235(param1:Boolean = false) : void
      {
         if(this.var_252.canSend)
         {
            this.method_252();
         }
      }
      
      public function method_232() : Boolean
      {
         return Math.floor(new Date().time) - this.name_4 > 3 * 60 * 1000;
      }
      
      private function method_252() : void
      {
         if(!this.var_253)
         {
            return;
         }
         this.method_248();
      }
      
      protected function getTask(param1:Array, param2:Array) : Object
      {
         if(null == param1 && null == param2)
         {
            return null;
         }
         var _loc3_:Object = new Object();
         _loc3_.groupID = this.groupID;
         _loc3_.TNrange = param1;
         _loc3_.PNrange = param2;
         _loc3_.remoteID = this.var_252.remoteID;
         var _loc4_:Object = this.var_156.method_7(_loc3_);
         _loc3_ = null;
         return _loc4_;
      }
      
      private function method_253(param1:Piece) : void
      {
      }
      
      public function method_231(param1:int) : void
      {
      }
      
      private function method_254(param1:ByteArray) : String
      {
         var _loc2_:* = "";
         var _loc3_:* = "";
         var _loc4_:* = 0;
         param1.position = 0;
         while(param1.bytesAvailable > 0)
         {
            _loc3_ = param1[param1.position].toString(16);
            _loc2_ = _loc2_ + (_loc3_.length == 1?" 0" + _loc3_:" " + _loc3_);
            _loc4_++;
            if(_loc4_ == 16)
            {
               _loc2_ = _loc2_ + "\n";
               _loc4_ = 0;
            }
            param1.position++;
         }
         param1.position = 0;
         return _loc2_;
      }
      
      public function clear() : void
      {
         console.log(this,"clear");
         this.remotePNList = null;
         this.remoteTNList = null;
         this.var_221 = null;
         this.var_226 = null;
         if(this.var_186)
         {
            this.var_186.stop();
            this.var_186.addEventListener(TimerEvent.TIMER,this.peerHartBeatTimer);
            this.var_186 = null;
         }
         if(this.var_219)
         {
            this.var_219 = null;
         }
         if(this.var_252)
         {
            this.var_252.name_5 = null;
            this.var_252.name_7 = null;
            this.var_252.clear();
            this.var_252 = null;
         }
         this.var_156 = null;
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
      
      public function get remoteID() : String
      {
         return this.var_252.remoteID;
      }
      
      public function get groupID() : String
      {
         return this.var_252.groupID;
      }
      
      public function get name_6() : Boolean
      {
         return this.var_252.name_6;
      }
      
      public function get method_255() : String
      {
         return this.var_252.var_257;
      }
      
      public function set name_6(param1:Boolean) : void
      {
         this.var_252.name_6 = param1;
      }
      
      public function get canSend() : Boolean
      {
         return this.var_252.canSend;
      }
      
      public function set canSend(param1:Boolean) : void
      {
         this.var_252.canSend = param1;
      }
   }
}
