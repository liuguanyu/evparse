package com.hls_p2p.loaders.p2pLoader
{
   import flash.net.NetConnection;
   import com.hls_p2p.data.vo.class_2;
   import com.hls_p2p.dataManager.DataManager;
   import flash.utils.Timer;
   import flash.net.URLLoader;
   import flash.net.NetStream;
   import com.p2p.utils.console;
   import flash.events.TimerEvent;
   import flash.events.Event;
   import com.hls_p2p.data.vo.LiveVodConfig;
   import flash.events.IOErrorEvent;
   import flash.events.SecurityErrorEvent;
   import flash.net.URLRequest;
   import com.hls_p2p.statistics.Statistic;
   import com.p2p.utils.json.JSONDOC;
   import com.hls_p2p.loaders.cdnLoader.CDNRateStrategy;
   import flash.events.NetStatusEvent;
   import flash.events.AsyncErrorEvent;
   
   public class P2P_Loader extends Object
   {
      
      public var isDebug:Boolean = false;
      
      private var _p2pConnection:NetConnection;
      
      private var _initData:class_2;
      
      private var _dataManager:DataManager;
      
      private var var_183:String;
      
      private var groupID:String;
      
      private var var_184:Timer;
      
      private var var_185:Timer;
      
      private var var_186:Timer;
      
      protected var var_187:Timer;
      
      private var _pipeListArr:Array;
      
      private var var_188:int = 0;
      
      private var var_189:Selector;
      
      private var var_190:String;
      
      private var var_191:uint;
      
      private var var_175:String;
      
      private var var_176:uint;
      
      private var var_192:URLLoader;
      
      private var var_193:Boolean = true;
      
      private var var_194:Object;
      
      private var _sparePipeArr:Array;
      
      private var var_195:Boolean = false;
      
      protected var var_109:P2P_Cluster;
      
      protected var var_196:NetStream = null;
      
      protected var var_197:Boolean = false;
      
      protected var _p2pLoaderSelf:P2P_Loader = null;
      
      private var _maxQPeers:uint = 0;
      
      private var var_198:uint = 11;
      
      private var var_199:Number = 0;
      
      private var var_200:Number = 45000.0;
      
      private var var_201:Boolean = false;
      
      private var var_202:Number = 0;
      
      private var var_203:Boolean = true;
      
      private var var_204:Boolean = true;
      
      private var var_205:Timer;
      
      public function P2P_Loader(param1:DataManager, param2:P2P_Cluster, param3:Selector)
      {
         super();
         console.log(this,"P2P_Loader");
         this._dataManager = param1;
         this.var_109 = param2;
         this.var_189 = param3;
         this.var_189.addEventListener(Event.COMPLETE,this.method_209);
      }
      
      public function ifPeerConnection() : Boolean
      {
         var _loc1_:* = 0;
         if(this._pipeListArr)
         {
            _loc1_ = 0;
            while(_loc1_ < this._pipeListArr.length)
            {
               if(this._pipeListArr[_loc1_].pipeConnected())
               {
                  return true;
               }
               _loc1_++;
            }
         }
         return false;
      }
      
      public function startLoadP2P(param1:class_2, param2:String) : void
      {
         var _initData:class_2 = param1;
         var groupID:String = param2;
         try
         {
            this.var_183 = _initData.geo;
         }
         catch(err:Error)
         {
            console.log(this,"geo错误");
         }
         this.groupID = groupID;
         this._pipeListArr = new Array();
         this.var_194 = new Object();
         this._sparePipeArr = new Array();
         this.var_186 = new Timer(1 * 1000);
         this.var_186.addEventListener(TimerEvent.TIMER,this.peerHartBeatTimer);
         this.var_186.start();
         this.var_184 = new Timer(100,1);
         this.var_184.addEventListener(TimerEvent.TIMER,this.method_221);
         this.var_185 = new Timer(300);
         this.var_185.addEventListener(TimerEvent.TIMER,this.gatherRegisterTimer);
      }
      
      private function method_209(param1:Event) : void
      {
         this.var_175 = this.var_189.gatherName;
         this.var_176 = this.var_189.var_206;
         this.var_198 = this.var_189.hbInterval;
         this._maxQPeers = this.var_189.maxQPeers;
         this.var_190 = this.var_189.rtmfpName;
         this.var_191 = this.var_189.var_207;
         this.var_184.reset();
         this.var_184.start();
         console.log(this,"overHandler _hbInterval:",this.var_198,"_maxQPeers",this._maxQPeers);
      }
      
      private function method_210() : void
      {
         var i:int = 0;
         if(this._pipeListArr)
         {
            i = this._pipeListArr.length - 1;
            while(i >= 0)
            {
               try
               {
                  (this._pipeListArr[i] as SignallingStrategy_V1).clear();
               }
               catch(err:Error)
               {
                  console.log(this,err + err.getStackTrace());
               }
               this._pipeListArr[i] = null;
               this._pipeListArr.splice(i,1);
               i--;
            }
         }
      }
      
      public function setPeerList(param1:Object) : void
      {
         this.var_193 = true;
         if(param1["status"] == "0")
         {
            this.method_212();
            if(!LiveVodConfig.MY_NAME)
            {
               LiveVodConfig.MY_NAME = String(this._p2pConnection.nearID);
            }
            this.method_211(param1["peerlist"]);
         }
      }
      
      private function method_211(param1:Array) : void
      {
         var _loc4_:P2P_Pipe = null;
         var _loc2_:* = "";
         var _loc3_:Array = param1;
         var _loc5_:* = 0;
         while(_loc5_ < _loc3_.length)
         {
            if((_loc3_[_loc5_]) && (_loc3_[_loc5_]["peerid"]))
            {
               _loc2_ = _loc3_[_loc5_]["peerid"];
               if(!(_loc2_ == "") && !this.var_194[_loc2_] && !(_loc2_ == this._p2pConnection.nearID) && -1 == this.ifHasPipeInArray(this._pipeListArr,_loc2_))
               {
                  if((this._p2pConnection) && (this._p2pConnection.connected) && this._pipeListArr.length < LiveVodConfig.var_286)
                  {
                     console.log(this,"new P2P_Pipe",_loc2_);
                     _loc4_ = new P2P_Pipe(this._p2pConnection,this.groupID);
                     _loc4_.method_244(_loc2_);
                     this._pipeListArr.push(new SignallingStrategy_V1(_loc4_,this,this._dataManager));
                  }
                  else if(-1 == this.ifHasPipeInArray(this._sparePipeArr,_loc2_,false))
                  {
                     this.method_216(_loc2_);
                  }
                  
               }
            }
            _loc5_++;
         }
         console.log(this,"setPeerList",param1);
      }
      
      private function gatherRegisterTimer(param1:* = null) : void
      {
         var query:int = 0;
         var var_309:Array = null;
         var var_310:String = null;
         var var_311:String = null;
         var var_312:String = null;
         var var_313:String = null;
         var var_46:String = null;
         var var_308:* = param1;
         try
         {
            this.var_185.delay = this.var_198 * 1000;
            if((this._p2pConnection) && (this._p2pConnection.connected) && (this.var_193))
            {
               if(this.var_188 >= LiveVodConfig.var_286 && !this.var_195)
               {
                  this.var_195 = true;
               }
               else
               {
                  if(this.var_188 >= LiveVodConfig.var_286 && (this.var_195))
                  {
                     return;
                  }
                  if(this.var_188 < LiveVodConfig.var_286)
                  {
                     this.var_195 = false;
                  }
               }
               if(this.var_192 == null)
               {
                  this.var_192 = new URLLoader();
                  this.var_192.addEventListener(Event.COMPLETE,this.method_213);
                  this.var_192.addEventListener(IOErrorEvent.IO_ERROR,this.loader_ERROR);
                  this.var_192.addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.loader_ERROR);
               }
               query = 1;
               if(this.var_183)
               {
                  var_309 = this.var_183.split(".");
                  if(var_309.length >= 4)
                  {
                     var_310 = var_309[3];
                     var_311 = var_309[0];
                     var_312 = var_309[1];
                     var_313 = var_309[2];
                     if(this._pipeListArr.length + this._sparePipeArr.length >= LiveVodConfig.var_286)
                     {
                        if(2 * this.var_198 * 1000 > 45 * 1000)
                        {
                           this.var_185.delay = 45 * 1000;
                        }
                        else
                        {
                           this.var_185.delay = 2 * this.var_198 * 1000;
                        }
                        query = 0;
                     }
                     if("gather" == this.var_189.var_212)
                     {
                        this.var_193 = false;
                        if(this.var_192 == null)
                        {
                           this.var_192 = new URLLoader();
                           this.var_192.addEventListener(Event.COMPLETE,this.method_213);
                           this.var_192.addEventListener(IOErrorEvent.IO_ERROR,this.loader_ERROR);
                           this.var_192.addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.loader_ERROR);
                        }
                        var_46 = "http://" + this.var_175 + ":" + this.var_176 + "/heartBeat?ver=" + LiveVodConfig.method_263() + "&groupId=" + this.groupID + "&query=" + query + "&peerId=" + this._p2pConnection.nearID + "&rtmfpId=" + this.var_190 + ":" + this.var_191 + "&ispId=" + var_310 + "&pos=" + (LiveVodConfig.ADD_DATA_TIME >= 0?LiveVodConfig.ADD_DATA_TIME:0) + "&neighbors=" + this.var_188 + "&arealevel1=" + var_311 + "&arealevel2=" + var_312 + "&arealevel3=" + var_313 + "&random=" + Math.floor(Math.random() * 10000);
                        this.var_192.load(new URLRequest(var_46));
                        console.log(this,"gather:" + var_46);
                     }
                     else
                     {
                        if(this.var_188 > this._maxQPeers && LiveVodConfig.IS_SHARE_PEERS == true)
                        {
                           return;
                        }
                        this.var_193 = false;
                        this._p2pConnection.call("getPeerList",null,this.method_224);
                     }
                  }
               }
            }
         }
         catch(err:Error)
         {
            console.log(this,"gatherRegisterTimer",err,err.getStackTrace());
         }
      }
      
      private function pipeDeadHandler(param1:String, param2:int) : void
      {
         this.var_194[param1] = this.getTime();
         (this._pipeListArr[param2] as SignallingStrategy_V1).clear();
         console.log(this,"pipeDeadHandler",param1," id = " + param2);
         this._pipeListArr[param2] = null;
         this._pipeListArr.splice(param2,1);
      }
      
      private function method_212() : void
      {
         var _loc2_:String = null;
         var _loc1_:Number = this.getTime();
         for(_loc2_ in this.var_194)
         {
            if(_loc1_ - this.var_194[_loc2_] >= LiveVodConfig.badPeerTime)
            {
               delete this.var_194[_loc2_];
               true;
            }
         }
      }
      
      protected function method_213(param1:Event) : void
      {
         var remoteID:String = null;
         var obj:Object = null;
         var var_314:Array = null;
         var var_315:P2P_Pipe = null;
         var i:int = 0;
         var var_298:Event = param1;
         this.var_193 = true;
         Statistic.method_261().method_104(this.var_175,this.var_176,this.groupID);
         if((this._p2pConnection) && (this._p2pConnection.connected))
         {
            this.method_212();
            try
            {
               if(String(this.var_192.data).length == 0)
               {
                  return;
               }
               obj = JSONDOC.decode(String(this.var_192.data));
            }
            catch(e:Error)
            {
               loader_ERROR("dataError");
               return;
            }
            if(!LiveVodConfig.MY_NAME)
            {
               LiveVodConfig.MY_NAME = String(this._p2pConnection.nearID);
            }
            remoteID = "";
            try
            {
               if(obj["result"] == "success")
               {
                  if(obj.hasOwnProperty("fetchRate"))
                  {
                     CDNRateStrategy.method_261().var_21 = Number(obj["fetchRate"]);
                  }
                  if(obj["value"] is Array)
                  {
                     var_314 = obj["value"];
                     i = 0;
                     while(i < var_314.length)
                     {
                        if(var_314[i])
                        {
                           remoteID = var_314[i];
                           if(!(remoteID == "") && !this.var_194[remoteID] && !(remoteID == this._p2pConnection.nearID) && -1 == this.ifHasPipeInArray(this._pipeListArr,remoteID))
                           {
                              if((this._p2pConnection) && (this._p2pConnection.connected) && this._pipeListArr.length < LiveVodConfig.var_286)
                              {
                                 var_315 = new P2P_Pipe(this._p2pConnection,this.groupID);
                                 var_315.method_244(remoteID);
                                 this._pipeListArr.push(new SignallingStrategy_V1(var_315,this,this._dataManager));
                              }
                              else if(-1 == this.ifHasPipeInArray(this._sparePipeArr,remoteID,false))
                              {
                                 this.method_216(remoteID);
                              }
                              
                           }
                        }
                        i++;
                     }
                  }
                  else
                  {
                     return;
                  }
               }
               else
               {
                  return;
               }
            }
            catch(e:Error)
            {
               return;
            }
         }
         if((this._p2pConnection) && (this._p2pConnection.connected))
         {
            return;
         }
      }
      
      private function ifHasPipeInArray(param1:Array, param2:String, param3:Boolean = true) : int
      {
         var _loc4_:* = 0;
         while(_loc4_ < param1.length)
         {
            if(true == param3)
            {
               if(param1[_loc4_]["remoteID"] == param2)
               {
                  return _loc4_;
               }
            }
            else if(param1[_loc4_] == param2)
            {
               return _loc4_;
            }
            
            _loc4_++;
         }
         return -1;
      }
      
      protected function loader_ERROR(param1:* = null) : void
      {
         console.log(this,"loader_ERROR",param1);
         this.var_193 = true;
         Statistic.method_261().gatherFailed(this.var_175,this.var_176,this.groupID);
      }
      
      public function method_214(param1:String) : Array
      {
         var _loc2_:Array = new Array();
         var _loc3_:* = 0;
         while(_loc3_ < this._pipeListArr.length)
         {
            if(!((this._pipeListArr[_loc3_] as SignallingStrategy_V1).remoteID == "") && !((this._pipeListArr[_loc3_] as SignallingStrategy_V1).remoteID == param1) && ((this._pipeListArr[_loc3_] as SignallingStrategy_V1).method_233()) && true == (this._pipeListArr[_loc3_] as SignallingStrategy_V1).var_228)
            {
               _loc2_.push((this._pipeListArr[_loc3_] as SignallingStrategy_V1).remoteID);
            }
            _loc3_++;
         }
         return _loc2_;
      }
      
      public function method_215(param1:Array) : void
      {
         this.method_212();
         var _loc2_:* = 0;
         while(_loc2_ < param1.length)
         {
            if(-1 == this.ifHasPipeInArray(this._pipeListArr,param1[_loc2_]) && -1 == this.ifHasPipeInArray(this._sparePipeArr,param1[_loc2_],false) && !this.var_194[param1[_loc2_]])
            {
               this.method_216(param1[_loc2_]);
            }
            _loc2_++;
         }
      }
      
      public function isWantPeerList() : Boolean
      {
         if(this._sparePipeArr.length < this.var_198 || this.getTime() - this.var_199 >= this.var_200)
         {
            if(this.getTime() - this.var_199 >= this.var_200)
            {
               this.var_201 = true;
            }
            return true;
         }
         return false;
      }
      
      private function method_216(param1:String) : void
      {
         if(true == this.var_201)
         {
            this._sparePipeArr = new Array();
            this.var_201 = false;
         }
         this._sparePipeArr.push(param1);
         if(this._sparePipeArr.length > 50)
         {
            this._sparePipeArr.shift();
         }
         this.var_199 = this.getTime();
      }
      
      public function peerHartBeatTimer(param1:* = null) : void
      {
         var _loc5_:SignallingStrategy_V1 = null;
         if((this._p2pConnection && this._p2pConnection.connected) && (this.var_196) && this.var_197 == false)
         {
            this.var_196.publish(this.groupID);
         }
         var _loc2_:Object = new Object();
         this.var_188 = 0;
         if(!(this.var_202 == 0) && this.getTime() - this.var_202 > 3 * 60 * 1000 - 15 * 1000 && (this.var_204))
         {
            this.method_217();
            return;
         }
         var _loc3_:* = 0;
         var _loc4_:int = this._pipeListArr.length - 1;
         while(_loc4_ >= 0)
         {
            _loc5_ = this._pipeListArr[_loc4_];
            if(_loc5_.method_232())
            {
               this.pipeDeadHandler(_loc5_.remoteID,_loc4_);
            }
            else
            {
               if(_loc5_.pipeConnected())
               {
                  this.var_188++;
                  _loc5_.method_231(_loc4_ * 50);
               }
               else if(true == this.var_204 && this.var_188 == 0 && false == _loc5_.pipeConnected() && _loc5_.name_4 > 0 && this.getTime() - _loc5_.name_4 >= 1 * 60 * 1000)
               {
                  _loc3_++;
                  if(_loc3_ >= 5)
                  {
                     this.method_217();
                     return;
                  }
               }
               
               _loc2_[_loc5_["remoteID"]] = {
                  "name":_loc5_.method_243,
                  "farID":_loc5_.remoteID,
                  "state":((_loc5_.name_6) && (_loc5_.canSend)?"connect":(_loc5_.name_6) || (_loc5_.canSend)?"halfConnect":"notConnect")
               };
            }
            _loc4_--;
         }
         this.pushSparePeerIntoPipeList(_loc2_);
         Statistic.method_261().method_113(_loc2_,this.var_188,this._pipeListArr.length + this._sparePipeArr.length,this.groupID);
         if((this._p2pConnection) && (this._p2pConnection.connected))
         {
            Statistic.method_261().method_102(this.var_190,this.var_191,this._p2pConnection.nearID,this.groupID);
         }
         else if(LiveVodConfig.P2P_KERNEL == "r")
         {
            Statistic.method_261().method_101(this.var_190,this.var_191,this.groupID);
         }
         
      }
      
      private function method_217() : void
      {
         this.var_185.stop();
         LiveVodConfig.P2P_KERNEL = "l";
         this.var_109.method_199();
      }
      
      private function pushSparePeerIntoPipeList(param1:Object) : void
      {
         var _loc3_:P2P_Pipe = null;
         var _loc2_:int = this._sparePipeArr.length - 1;
         while(_loc2_ >= 0)
         {
            if(this._pipeListArr.length < LiveVodConfig.var_286)
            {
               _loc3_ = new P2P_Pipe(this._p2pConnection,this.groupID);
               _loc3_.method_244(this._sparePipeArr[_loc2_]);
               this._pipeListArr.push(new SignallingStrategy_V1(_loc3_,this,this._dataManager));
               this._sparePipeArr.splice(_loc2_,1);
               param1[_loc3_.remoteID] = {
                  "name":_loc3_.method_243,
                  "farID":_loc3_.remoteID,
                  "state":((_loc3_.name_6) && (_loc3_.canSend)?"connect":(_loc3_.name_6) || (_loc3_.canSend)?"halfConnect":"notConnect")
               };
               _loc2_--;
               continue;
            }
            break;
         }
         console.log(this,"pushSparePeerIntoPipeList",this._pipeListArr.length);
      }
      
      private function method_218() : void
      {
         if(!this.var_205)
         {
            this.var_205 = new Timer(0.5 * 60 * 1000,1);
            this.var_205.addEventListener(TimerEvent.TIMER,this.method_219);
            this.var_205.start();
            console.log(this,"______________________testRestartP2PHandler");
         }
         else
         {
            this.var_205.reset();
            this.var_205.start();
         }
      }
      
      private function method_219(param1:TimerEvent) : void
      {
         if(this.var_189)
         {
            console.log(this,"______________________selectorTimerRestart");
            this.var_189.method_226();
         }
      }
      
      private function method_220(param1:NetStatusEvent) : void
      {
         var _loc2_:* = 0;
         console.log(this,"e.info.code:" + param1.info.code);
         switch(param1.info.code)
         {
            case "NetConnection.Connect.Success":
               Statistic.method_261().method_102(this.var_190,this.var_191,this._p2pConnection.nearID,this.groupID);
               if("rtmfp" == this.var_189.var_212)
               {
                  this._p2pConnection.call("setMorePeerInfo",null,this.method_224);
               }
               if(this.var_187 == null)
               {
                  this.var_187 = new Timer(200,1);
                  this.var_187.addEventListener(TimerEvent.TIMER,this.method_223);
               }
               this.var_187.start();
               this.var_185.start();
               break;
            case "NetConnection.Connect.Closed":
            case "NetConnection.Connect.Failed":
            case "NetConnection.Connect.Rejected":
            case "NetConnection.Connect.AppShutdown":
            case "NetConnection.Connect.InvalidApp":
            case "NetConnection.Call.Prohibited":
            case "NetConnection.Call.BadVersion":
            case "NetConnection.Call.Failed":
            case "NetConnection.Call.Prohibited":
            case "NetConnection.Connect.IdleTimeout":
               if(this.var_203 == true)
               {
                  console.log(this,"______________________ " + param1.info.code + " ,_p2pConnection.connected" + this._p2pConnection.connected);
                  this.onError();
                  this.var_203 = true;
                  if(this.var_185)
                  {
                     this.var_185.stop();
                  }
                  this.method_218();
               }
               break;
            case "NetStream.Connect.Success":
               break;
            case "NetStream.Connect.Closed":
               _loc2_ = this.ifHasPipeInArray(this._pipeListArr,param1.info.stream.farID);
               if(-1 != _loc2_)
               {
                  console.log(this,"______________________ " + param1.info.code);
                  this.pipeDeadHandler((this._pipeListArr[_loc2_] as SignallingStrategy_V1).remoteID,_loc2_);
               }
               break;
            case "NetStream.Publish.Start":
               this.var_197 = true;
               this.var_204 = false;
               Statistic.method_261().var_80 = true;
               break;
            case "NetStream.Publish.Idle":
               this.var_197 = true;
               break;
            case "NetStream.Publish.BadName":
               this.var_197 = false;
               if(this.var_196)
               {
                  this.var_196.publish(this.groupID);
               }
               break;
         }
      }
      
      private function method_221(param1:TimerEvent = null) : void
      {
         var url:String = null;
         var var_316:Object = null;
         var e:TimerEvent = param1;
         if(this._p2pConnection == null || this._p2pConnection.connected == false)
         {
            this.var_197 = false;
            if(this._p2pConnection)
            {
               try
               {
                  this.var_203 = false;
                  this._p2pConnection.close();
                  console.log(this,"rtmfpTimer _p2pConnection.close() _p2pConnection.connected=" + this._p2pConnection.connected);
               }
               catch(err:Error)
               {
                  console.log(this,"rtmfpTimer error = " + err + " , " + err.getStackTrace());
               }
               console.log(this,"rtmfpTimer _p2pConnection clear _p2pConnection.connected=" + this._p2pConnection.connected);
            }
            if(!this._p2pConnection)
            {
               this._p2pConnection = new NetConnection();
               console.log(this," new NetConnection()");
            }
            if(!this._p2pConnection.hasEventListener(NetStatusEvent.NET_STATUS))
            {
               this._p2pConnection.addEventListener(NetStatusEvent.NET_STATUS,this.method_220);
               console.log(this,"_p2pConnection.addEventListener(NetStatusEvent.NET_STATUS,p2pStatusHandler)");
            }
            if(!this._p2pConnection.hasEventListener(IOErrorEvent.IO_ERROR))
            {
               this._p2pConnection.addEventListener(IOErrorEvent.IO_ERROR,this.onError);
               console.log(this,"_p2pConnection.addEventListener(IOErrorEvent.IO_ERROR,onError)");
            }
            this._p2pConnection.maxPeerConnections = LiveVodConfig.var_286;
            if(!this._p2pConnection.connected && !(this.var_190 == ""))
            {
               var_316 = new Object();
               if(this.var_189.var_212 == "rtmfp")
               {
                  var_316.setPeerList = this.setPeerList;
                  this._p2pConnection.client = var_316;
                  Statistic.method_261().method_103("0",0,this.groupID);
               }
               else
               {
                  Statistic.method_261().method_103(this.var_175,this.var_176,this.groupID);
               }
               url = "rtmfp://" + this.var_190 + ":" + this.var_191 + "/";
               Statistic.method_261().method_101(this.var_190,this.var_191,this.groupID);
               this.var_203 = true;
               this._p2pConnection.connect(url);
            }
            console.log(this,"_rtmfpName = " + this.var_190 + " , _rtmfpPort = " + this.var_191);
         }
      }
      
      private function onError(param1:IOErrorEvent = null) : void
      {
         var var_308:IOErrorEvent = param1;
         Statistic.method_261().rtmfpFailed(this.var_190,this.var_191,this.groupID);
         if(this._p2pConnection)
         {
            try
            {
               this.var_203 = false;
               this._p2pConnection.close();
               console.log(this,"onError close() _p2pConnection.connected=" + this._p2pConnection.connected);
            }
            catch(err:Error)
            {
               console.log(this,"onError = " + err + " , " + err.getStackTrace());
            }
            this.var_203 = true;
            console.log(this,"_p2pConnection.connected = " + this._p2pConnection.connected);
         }
      }
      
      private function method_222(param1:AsyncErrorEvent) : void
      {
      }
      
      private function method_223(param1:TimerEvent) : void
      {
         var var_317:Object = null;
         var var_308:TimerEvent = param1;
         if((this._p2pConnection) && (this._p2pConnection.connected))
         {
            if(this.var_197 == false)
            {
               this._p2pLoaderSelf = this;
               if(this.var_196)
               {
                  this.var_196.close();
                  this.var_196.removeEventListener(NetStatusEvent.NET_STATUS,this.method_220);
                  this.var_196.removeEventListener(AsyncErrorEvent.ASYNC_ERROR,this.method_222);
                  this.var_196 = null;
               }
               if(this.var_196 == null)
               {
                  this.var_196 = new NetStream(this._p2pConnection,NetStream.DIRECT_CONNECTIONS);
                  this.var_196["dataReliable"] = true;
                  this.var_196.addEventListener(NetStatusEvent.NET_STATUS,this.method_220);
                  this.var_196.addEventListener(AsyncErrorEvent.ASYNC_ERROR,this.method_222);
                  var_317 = new Object();
                  var_317.onPeerConnect = function(param1:NetStream):Boolean
                  {
                     var _loc2_:int = ifHasPipeInArray(_pipeListArr,param1.farID);
                     if(-1 != _loc2_)
                     {
                        if(_pipeListArr[_loc2_].canSend == true)
                        {
                           if(_pipeListArr[_loc2_].XNetStream)
                           {
                              return false;
                           }
                           _pipeListArr[_loc2_].XNetStream = param1;
                           return true;
                        }
                        (_pipeListArr[_loc2_] as SignallingStrategy_V1).clear();
                        _pipeListArr[_loc2_] = null;
                        _pipeListArr.splice(_loc2_,1);
                     }
                     if(_pipeListArr.length >= LiveVodConfig.var_286)
                     {
                        if(_sparePipeArr.length < LiveVodConfig.var_286)
                        {
                           if(-1 == ifHasPipeInArray(_sparePipeArr,param1.farID,false))
                           {
                              _sparePipeArr.push(param1.farID);
                           }
                        }
                        param1.close();
                        return false;
                     }
                     var _loc3_:P2P_Pipe = new P2P_Pipe(_p2pConnection,groupID);
                     _loc3_.XNetStream = param1;
                     _loc3_.method_244(param1.farID);
                     _pipeListArr.push(new SignallingStrategy_V1(_loc3_,_p2pLoaderSelf,_dataManager));
                     (_pipeListArr[_pipeListArr.length - 1] as SignallingStrategy_V1).method_231(300);
                     return true;
                  };
                  this.var_196.client = var_317;
               }
               this.var_196.publish(this.groupID);
               this.var_202 = this.getTime();
               return;
            }
         }
      }
      
      private function get method_224() : Object
      {
         var _loc1_:Array = null;
         var _loc2_:* = 0;
         var _loc3_:* = "";
         var _loc4_:* = -1;
         var _loc5_:* = -1;
         if(this.var_183)
         {
            _loc1_ = this.var_183.split(".");
            if(_loc1_.length >= 4)
            {
               _loc3_ = String(_loc1_[0]);
               _loc4_ = int(_loc1_[1]);
               _loc5_ = int(_loc1_[2]);
               _loc2_ = int(_loc1_[3]);
            }
         }
         var _loc6_:Object = {
            "peerId":this._p2pConnection.nearID,
            "streamId":this.groupID,
            "ver":LiveVodConfig.method_263(),
            "isp":_loc2_,
            "country":_loc3_,
            "province":_loc4_,
            "city":_loc5_,
            "expect":19,
            "neighbors":this.var_188,
            "tid":Number(LiveVodConfig.TERMID),
            "pos":0
         };
         console.log(this,"sendPeerList",_loc6_);
         return _loc6_;
      }
      
      protected function getTime() : Number
      {
         return Math.floor(new Date().time);
      }
      
      public function method_225() : void
      {
      }
      
      public function clear() : void
      {
         if(this.var_189)
         {
            this.var_189.clear();
            this.var_189 = null;
         }
         if(this.var_186)
         {
            this.var_186.stop();
            this.var_186.removeEventListener(TimerEvent.TIMER,this.peerHartBeatTimer);
            this.var_186 = null;
            console.log(this,"_peerHartBeatTimer clear");
         }
         if(this.var_184)
         {
            this.var_184.stop();
            this.var_184.removeEventListener(TimerEvent.TIMER,this.method_221);
            this.var_184 = null;
            console.log(this,"_rtmfpTimer clear");
         }
         if(this.var_185)
         {
            this.var_185.stop();
            this.var_185.removeEventListener(TimerEvent.TIMER,this.gatherRegisterTimer);
            this.var_185 = null;
            console.log(this,"_gatherRegisterTimer clear");
         }
         if(this.var_205)
         {
            this.var_205.stop();
            this.var_205.removeEventListener(TimerEvent.TIMER,this.method_219);
            this.var_205 = null;
         }
         if(this._p2pConnection)
         {
            try
            {
               this.var_203 = false;
               this._p2pConnection.close();
               console.log(this,"_p2pConnection clear _p2pConnection.close() _p2pConnection.connected=" + this._p2pConnection.connected);
            }
            catch(err:Error)
            {
               console.log(this,"_p2pConnection clear error=" + err + " , " + err.getStackTrace());
            }
            if((this._p2pConnection) && (this._p2pConnection.hasEventListener(NetStatusEvent.NET_STATUS)))
            {
               this._p2pConnection.removeEventListener(NetStatusEvent.NET_STATUS,this.method_220);
            }
            if((this._p2pConnection) && (this._p2pConnection.hasEventListener(IOErrorEvent.IO_ERROR)))
            {
               this._p2pConnection.removeEventListener(IOErrorEvent.IO_ERROR,this.onError);
            }
            console.log(this,"_p2pConnection clear _p2pConnection.hasEventListener(NetStatusEvent.NET_STATUS)=" + this._p2pConnection.hasEventListener(NetStatusEvent.NET_STATUS));
            console.log(this,"_p2pConnection clear _p2pConnection.hasEventListener(IOErrorEvent.IO_ERROR)=" + this._p2pConnection.hasEventListener(IOErrorEvent.IO_ERROR));
            this._p2pConnection = null;
            console.log(this,"_p2pConnection clear _p2pConnection=" + this._p2pConnection);
            this.var_203 = true;
         }
         if(this.var_192)
         {
            if(this.var_193 == false)
            {
               try
               {
                  this.var_192.close();
               }
               catch(err:Error)
               {
                  console.log(this,"_URLLoader clear");
               }
            }
            this.var_192.removeEventListener(Event.COMPLETE,this.method_213);
            this.var_192.removeEventListener(IOErrorEvent.IO_ERROR,this.loader_ERROR);
            this.var_192.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,this.loader_ERROR);
            this.var_192 = null;
            console.log(this,"_URLLoader clear");
         }
         this.method_210();
         this._pipeListArr = null;
         this.var_194 = null;
         this._sparePipeArr = null;
         if(this.var_189)
         {
            this.var_189.clear();
            this.var_189 = null;
         }
         if(this.var_187)
         {
            this.var_187.stop();
            this.var_187.removeEventListener(TimerEvent.TIMER,this.method_223);
            this.var_187 = null;
            console.log(this,"_publisherTimer clear");
         }
         if(this.var_196)
         {
            try
            {
               this.var_196.close();
               this.var_196.removeEventListener(NetStatusEvent.NET_STATUS,this.method_220);
               this.var_196.removeEventListener(AsyncErrorEvent.ASYNC_ERROR,this.method_222);
            }
            catch(err:Error)
            {
               console.log(this,"_sendNetStream clear error");
            }
            this.var_196 = null;
            console.log(this,"_sendNetStream clear");
         }
         this._initData = null;
         this._dataManager = null;
         this.var_109 = null;
         this.var_188 = 0;
         this.var_195 = false;
         this.var_190 = "";
         this.var_191 = 0;
         this.var_175 = "";
         this.var_176 = 0;
         this.var_197 = false;
         this._p2pLoaderSelf = null;
         this._maxQPeers = 0;
         this.var_198 = 11;
         this.var_199 = 0;
         this.var_200 = 45 * 1000;
         this.var_201 = false;
         this.var_202 = 0;
      }
   }
}
