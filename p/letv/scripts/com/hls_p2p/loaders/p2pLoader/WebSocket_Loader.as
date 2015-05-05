package com.hls_p2p.loaders.p2pLoader
{
   import flash.net.URLLoader;
   import com.hls_p2p.data.vo.class_2;
   import com.hls_p2p.dataManager.DataManager;
   import flash.utils.Timer;
   import flash.events.TimerEvent;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.events.SecurityErrorEvent;
   import com.hls_p2p.data.vo.LiveVodConfig;
   import com.p2p.utils.console;
   import flash.net.URLRequest;
   import com.hls_p2p.statistics.Statistic;
   import com.p2p.utils.json.JSONDOC;
   import com.p2p.utils.GetLocationParam;
   import com.p2p.utils.ParseUrl;
   
   public class WebSocket_Loader extends Object
   {
      
      public var isDebug:Boolean = true;
      
      public var var_214:Boolean = false;
      
      private var var_193:Boolean = true;
      
      private var var_192:URLLoader;
      
      private var _initData:class_2;
      
      private var _dataManager:DataManager;
      
      protected var var_109:P2P_Cluster;
      
      private var _pipeListArr:Array;
      
      private var var_194:Object;
      
      private var _sparePipeArr:Array;
      
      private var var_186:Timer;
      
      private var var_185:Timer;
      
      private var groupID:String;
      
      private var resourceID:String;
      
      private var _maxQPeers:uint = 0;
      
      private var var_198:uint = 30;
      
      private var var_199:Number = 0;
      
      private var var_200:Number = 45000.0;
      
      private var var_201:Boolean = false;
      
      private var var_188:int = 0;
      
      private var var_189:Selector;
      
      private var var_175:String;
      
      private var var_176:uint;
      
      public function WebSocket_Loader(param1:DataManager, param2:P2P_Cluster, param3:Selector)
      {
         super();
         this._dataManager = param1;
         this.var_109 = param2;
         this.var_189 = param3;
         this.var_189.addEventListener(Event.COMPLETE,this.method_209);
         Statistic.method_261().method_99(LiveVodConfig.uuid,this.groupID);
         if(console._csl)
         {
            this.var_214 = true;
         }
      }
      
      public function startLoadP2P(param1:class_2, param2:String, param3:String) : void
      {
         this.groupID = param2;
         this.resourceID = param3;
         this._initData = param1;
         this._pipeListArr = new Array();
         this.var_194 = new Object();
         this._sparePipeArr = new Array();
         this.var_186 = new Timer(1 * 1000);
         this.var_186.addEventListener(TimerEvent.TIMER,this.peerHartBeatTimer);
         this.var_186.start();
         this.var_185 = new Timer(300);
         this.var_185.addEventListener(TimerEvent.TIMER,this.gatherRegisterTimer);
         this.var_185.start();
      }
      
      private function method_209(param1:Event) : void
      {
         this.var_175 = this.var_189.gatherName;
         this.var_176 = this.var_189.var_206;
         this.var_198 = this.var_189.hbInterval;
      }
      
      public function gatherRegisterTimer(param1:* = null) : void
      {
         var _loc2_:String = null;
         var _loc3_:Array = null;
         var _loc4_:Array = null;
         this.var_185.delay = this.var_198 * 1000;
         if(this.var_193)
         {
            if(this.var_192 == null)
            {
               this.var_192 = new URLLoader();
               this.var_192.addEventListener(Event.COMPLETE,this.method_213);
               this.var_192.addEventListener(IOErrorEvent.IO_ERROR,this.loader_ERROR);
               this.var_192.addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.loader_ERROR);
            }
            if(this.var_188 > this._maxQPeers && LiveVodConfig.IS_SHARE_PEERS == true)
            {
               return;
            }
            if((this.var_175) && (this._initData))
            {
               _loc2_ = "";
               _loc2_ = _loc2_ + ("http://" + this.var_175 + ":" + this.var_176 + "/query?tid=1");
               if(LiveVodConfig.TYPE == LiveVodConfig.LIVE)
               {
                  _loc2_ = _loc2_ + "&playtype=2";
               }
               else
               {
                  _loc2_ = _loc2_ + "&playtype=1";
               }
               _loc2_ = _loc2_ + "&protocol=4";
               _loc2_ = _loc2_ + ("&streamid=" + this.groupID);
               _loc2_ = _loc2_ + ("&peerid=" + LiveVodConfig.uuid);
               _loc2_ = _loc2_ + "&peerinfo=0-0-0-0";
               _loc2_ = _loc2_ + ("&ver=" + LiveVodConfig.method_263());
               _loc3_ = this._initData.geo.split(".");
               _loc2_ = _loc2_ + ("&ispid=" + _loc3_[3]);
               _loc2_ = _loc2_ + ("&country=" + _loc3_[0]);
               _loc2_ = _loc2_ + ("&province=" + _loc3_[1]);
               _loc2_ = _loc2_ + ("&city=" + _loc3_[2]);
               _loc2_ = _loc2_ + ("&neighbors=" + this.var_188);
               _loc2_ = _loc2_ + "&expect=21";
               _loc2_ = _loc2_ + "&op=2";
               _loc2_ = _loc2_ + "&format=1";
               _loc2_ = _loc2_ + ("&rdm=" + this.getTime());
               console.log(this,"get peer list:",_loc2_);
               this.var_192.load(new URLRequest(_loc2_));
               this.var_193 = false;
               _loc4_ = _loc2_.split("&");
            }
         }
      }
      
      private function pipeDeadHandler(param1:String, param2:int) : void
      {
         this.var_194[param1] = this.getTime();
         console.log(this,"deadPipe id:" + param1);
         (this._pipeListArr[param2] as SignallingStratey_WS).clear();
         this._pipeListArr[param2] = null;
         this._pipeListArr.splice(param2,1);
      }
      
      protected function method_213(param1:Event) : void
      {
         var var_315:WS_Pipe = null;
         var obj:Object = null;
         var _browserParams:Object = null;
         var port:String = null;
         var ip:String = null;
         var i:int = 0;
         var var_298:Event = param1;
         this.var_193 = true;
         Statistic.method_261().method_104(this.var_175,this.var_176,this.groupID);
         this.method_212();
         try
         {
            if(String(this.var_192.data).length == 0)
            {
               return;
            }
            obj = JSONDOC.decode(String(this.var_192.data));
            if(this.var_214)
            {
               _browserParams = GetLocationParam.GetBrowseLocationParams();
               if((_browserParams) && (_browserParams.hasOwnProperty("location")))
               {
                  port = ParseUrl.getParam(_browserParams.location,"port");
                  ip = ParseUrl.getParam(_browserParams.location,"ip");
                  if((port) && (ip))
                  {
                     obj["peerlist"] = [{
                        "pip":ip,
                        "pport":port,
                        "tid":"2",
                        "peerid":"1234567"
                     }];
                  }
               }
            }
            if(!obj["peerlist"] || !(obj["peerlist"] is Array) || obj["peerlist"].length == 0)
            {
               return;
            }
         }
         catch(e:Error)
         {
            loader_ERROR("dataError");
            return;
         }
         if(!LiveVodConfig.MY_NAME)
         {
            LiveVodConfig.MY_NAME = LiveVodConfig.uuid;
         }
         var remoteID:String = "";
         var var_314:Array = obj["peerlist"];
         try
         {
            i = 0;
            while(i < var_314.length)
            {
               remoteID = var_314[i]["peerid"];
               if((!(remoteID == "") && !this.var_194[remoteID] && !(remoteID == LiveVodConfig.MY_NAME) && -1 == this.ifHasPipeInArray(this._pipeListArr,remoteID)) && (var_314[i]["pip"]) && (var_314[i]["pport"]) && !(var_314[i]["tid"] == "1"))
               {
                  if(this._pipeListArr.length < LiveVodConfig.var_286)
                  {
                     console.log(this,"create UTP pipe:" + var_314[i]["pip"] + ":" + var_314[i]["pport"] + " " + remoteID);
                     var_315 = new WS_Pipe(this.groupID,remoteID,var_314[i]["pip"],int(var_314[i]["pport"]),var_314[i]["tid"]);
                     this._pipeListArr.push(new SignallingStratey_WS(var_315,this,this._dataManager));
                     var_315.init();
                  }
                  else if(-1 == this.ifHasPipeInArray(this._sparePipeArr,remoteID,false))
                  {
                     this.method_216(remoteID,var_314[i]["pip"],var_314[i]["pport"],var_314[i]["tid"]);
                  }
                  
               }
               i++;
            }
         }
         catch(e:Error)
         {
            return;
         }
      }
      
      protected function loader_ERROR(param1:* = null) : void
      {
         console.log(this,"load UTP Peerlist error:" + param1);
         this.var_193 = true;
      }
      
      public function method_214(param1:String) : Array
      {
         var _loc2_:Array = new Array();
         if(!this._pipeListArr)
         {
            return _loc2_;
         }
         var _loc3_:* = 0;
         while(_loc3_ < this._pipeListArr.length)
         {
            if(!((this._pipeListArr[_loc3_] as SignallingStratey_WS).remoteID == "") && !((this._pipeListArr[_loc3_] as SignallingStratey_WS).remoteID == param1) && ((this._pipeListArr[_loc3_] as SignallingStratey_WS).method_233()) && true == (this._pipeListArr[_loc3_] as SignallingStratey_WS).var_228)
            {
               _loc2_.push((this._pipeListArr[_loc3_] as SignallingStratey_WS).method_255);
            }
            _loc3_++;
         }
         return _loc2_;
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
      
      public function peerHartBeatTimer(param1:* = null) : void
      {
         var _loc4_:SignallingStratey_WS = null;
         var _loc2_:Object = new Object();
         this.var_188 = 0;
         var _loc3_:int = this._pipeListArr.length - 1;
         while(_loc3_ >= 0)
         {
            _loc4_ = this._pipeListArr[_loc3_];
            if(_loc4_.method_232())
            {
               this.pipeDeadHandler(_loc4_.remoteID,_loc3_);
            }
            else
            {
               if((_loc4_.name_6) && (_loc4_.canSend))
               {
                  this.var_188++;
                  _loc4_.method_231(_loc3_ * 50);
               }
               _loc2_[_loc4_["remoteID"]] = {
                  "name":_loc4_.remoteID,
                  "farID":_loc4_.remoteID,
                  "state":((_loc4_.name_6) && (_loc4_.canSend)?"connect":(_loc4_.name_6) || (_loc4_.canSend)?"halfConnect":"notConnect")
               };
            }
            _loc3_--;
         }
         this.pushSparePeerIntoPipeList(_loc2_);
         Statistic.method_261().method_113(_loc2_,this.var_188,this._pipeListArr.length + this._sparePipeArr.length,this.groupID,"ws");
      }
      
      private function pushSparePeerIntoPipeList(param1:Object) : void
      {
         var _loc3_:WS_Pipe = null;
         var _loc2_:int = this._sparePipeArr.length - 1;
         while(_loc2_ >= 0)
         {
            if(this._pipeListArr.length < LiveVodConfig.var_286)
            {
               _loc3_ = new WS_Pipe(this.groupID,this._sparePipeArr[_loc2_]["remoteID"],this._sparePipeArr[_loc2_]["pip"],int(this._sparePipeArr[_loc2_]["pport"]),this._sparePipeArr[_loc2_]["tid"]);
               this._pipeListArr.push(new SignallingStratey_WS(_loc3_,this,this._dataManager));
               _loc2_--;
               continue;
            }
            break;
         }
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
      
      private function method_216(param1:String, param2:String, param3:String, param4:String) : void
      {
         if(true == this.var_201)
         {
            this._sparePipeArr = new Array();
            this.var_201 = false;
         }
         this._sparePipeArr.push({
            "remoteID":param1,
            "ip":param2,
            "port":param3,
            "tid":param4
         });
         if(this._sparePipeArr.length > 50)
         {
            this._sparePipeArr.shift();
         }
         this.var_199 = this.getTime();
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
                  (this._pipeListArr[i] as SignallingStratey_WS).clear();
               }
               catch(err:Error)
               {
                  console.log(this,err + err.getStackTrace());
               }
               this._pipeListArr[i] = null;
               this._pipeListArr.splice(i,1);
               i--;
            }
            this._pipeListArr = null;
         }
      }
      
      protected function getTime() : Number
      {
         return Math.floor(new Date().time);
      }
      
      public function clear() : void
      {
         console.log(this,"clear");
         if(this.var_189)
         {
            this.var_189.removeEventListener(Event.COMPLETE,this.method_209);
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
         if(this.var_185)
         {
            this.var_185.stop();
            this.var_185.removeEventListener(TimerEvent.TIMER,this.gatherRegisterTimer);
            this.var_185 = null;
            console.log(this,"_gatherRegisterTimer clear");
         }
         if(this.var_192)
         {
            if(false == this.var_193)
            {
               try
               {
                  this.var_192.close();
               }
               catch(err:Error)
               {
                  console.log(this,"_URLLoader close() error");
               }
            }
            this.var_192.removeEventListener(Event.COMPLETE,this.method_213);
            this.var_192.removeEventListener(IOErrorEvent.IO_ERROR,this.loader_ERROR);
            this.var_192.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,this.loader_ERROR);
            this.var_192 = null;
            console.log(this,"_URLLoader clear");
         }
         this.method_210();
         this.var_194 = null;
         this._sparePipeArr = null;
         this._initData = null;
         this._dataManager = null;
         this.var_109 = null;
         this.var_188 = 0;
         this.var_198 = 11;
         this.var_199 = 0;
         this.var_200 = 45 * 1000;
         this.var_201 = false;
      }
   }
}
