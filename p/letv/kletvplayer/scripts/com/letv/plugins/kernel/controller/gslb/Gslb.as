package com.letv.plugins.kernel.controller.gslb
{
   import com.letv.pluginsAPI.kernel.PlayerError;
   import com.letv.plugins.kernel.controller.auth.pay.LetvPayToken;
   import com.letv.plugins.kernel.controller.LoadEvent;
   import com.letv.plugins.kernel.model.special.gslb.GslbItemData;
   import com.letv.plugins.kernel.statistics.LetvStatistics;
   import com.alex.rpc.events.AutoLoaderEvent;
   import com.letv.plugins.kernel.Kernel;
   import com.letv.pluginsAPI.stat.PageDebugLog;
   import com.letv.pluginsAPI.stat.Stat;
   import com.letv.plugins.kernel.controller.auth.transfer.IDTransfer;
   import com.letv.plugins.kernel.controller.auth.transfer.TransferEvent;
   import com.letv.plugins.kernel.controller.auth.transfer.TransferResult;
   import com.letv.plugins.kernel.media.MediaFactory;
   import flash.events.Event;
   import com.letv.plugins.kernel.media.PlayMode;
   import com.letv.plugins.kernel.model.Model;
   
   public class Gslb extends GslbControl
   {
      
      private var model:Model;
      
      private var data:Object;
      
      private var payToken:LetvPayToken;
      
      private var p2plib:GslbP2PLibLoader;
      
      private var transfer:IDTransfer;
      
      private var transferFlag:Boolean;
      
      private var isRetry:Boolean;
      
      private var _gslbList:Object;
      
      private var _gslbLogData:String;
      
      public function Gslb(param1:Model)
      {
         super();
         this.model = param1;
      }
      
      override public function destroy() : void
      {
         super.destroy();
         this.GC_P2PLib();
         this.GC_PayToken();
         this.GC_Transfer();
         this.data = null;
         this._gslbLogData = "";
      }
      
      public function load(param1:String, param2:Object, param3:Boolean = false) : void
      {
         this.isRetry = param3;
         this._gslbList = param2;
         this.destroy();
         this.transferFlag = true;
         this.preprogress(param1,this._gslbList);
      }
      
      protected function preprogress(param1:String, param2:Object) : void
      {
         this.data = this.getRightData(param1,param2);
         if(this.data == null || this.data.urls == null || this.data.urls.length == 0 || this.data.storepath == null)
         {
            this.onLoadError(PlayerError.NEW_MMSID_ANALY_ERROR);
            return;
         }
         var _loc3_:Boolean = this.model.preloadData.preload?this.model.preloadData.preloadData.trylook == 1:this.model.setting.trylook;
         var _loc4_:Boolean = (_loc3_) && !this.model.user.payLook;
         if((_loc3_) && (this.model.user.isLogin) && !_loc4_)
         {
            this.startPayToken();
         }
         else
         {
            this.startGSLB();
         }
      }
      
      protected function startPayToken() : void
      {
         this.GC_PayToken();
         this.payToken = new LetvPayToken();
         this.payToken.addEventListener(LoadEvent.LOAD_ERROR,this.onPayTokenFailed);
         this.payToken.addEventListener(LoadEvent.LOAD_COMPLETE,this.onPayTokenComplete);
         this.payToken.start(this.data);
      }
      
      protected function onPayTokenComplete(param1:LoadEvent) : void
      {
         this.GC_PayToken();
         var _loc2_:* = 0;
         while(_loc2_ < this.data.urls.length)
         {
            this.data.urls[_loc2_] = this.data.urls[_loc2_] + ("&token=" + param1.dataProvider + "&uid=" + this.model.user.uid);
            _loc2_++;
         }
         this.startGSLB();
      }
      
      protected function onPayTokenFailed(param1:LoadEvent) : void
      {
         this.GC_PayToken();
         this.startGSLB();
      }
      
      private function GC_PayToken() : void
      {
         if(this.payToken != null)
         {
            this.payToken.removeEventListener(LoadEvent.LOAD_ERROR,this.onPayTokenFailed);
            this.payToken.removeEventListener(LoadEvent.LOAD_COMPLETE,this.onPayTokenComplete);
            this.payToken.destroy();
            this.payToken = null;
         }
      }
      
      protected function startGSLB() : void
      {
         super.start(this.data.urls,this.data.definition);
      }
      
      protected function getRightData(param1:String, param2:Object) : Object
      {
         if(param1 == null || param2 == null)
         {
            return null;
         }
         var _loc3_:Object = {
            "definition":param1,
            "pid":this.model.setting.pid,
            "uid":this.model.user.uid
         };
         if(param2.hasOwnProperty(param1))
         {
            _loc3_["urls"] = this.createUrl(param2[param1]);
            _loc3_["storepath"] = param2[param1].storepath;
         }
         return _loc3_;
      }
      
      protected function createUrl(param1:GslbItemData) : Array
      {
         var _loc2_:Array = null;
         var _loc3_:* = 0;
         if(!(param1 == null) && !(param1.storepath == null) && !(param1.urls == null))
         {
            _loc2_ = [];
            _loc3_ = 0;
            while(_loc3_ < param1.urls.length)
            {
               _loc2_[_loc3_] = param1.urls[_loc3_];
               if((this.model.config.forvip) || (this.model.user.isVip))
               {
                  _loc2_[_loc3_] = _loc2_[_loc3_] + "&pay=1";
               }
               else
               {
                  _loc2_[_loc3_] = _loc2_[_loc3_] + "&pay=0";
               }
               if(this.model.user.uinfo)
               {
                  _loc2_[_loc3_] = _loc2_[_loc3_] + ("&uinfo=" + this.model.user.uinfo);
               }
               if(this.model.user.isLogin)
               {
                  _loc2_[_loc3_] = _loc2_[_loc3_] + "&iscpn=f9051";
               }
               if(this.model.gslb.nodeID != null)
               {
                  _loc2_[_loc3_] = _loc2_[_loc3_] + ("&must=" + this.model.gslb.nodeID);
               }
               else if(this.model.gslb.everNodeID != null)
               {
                  _loc2_[_loc3_] = _loc2_[_loc3_] + ("&ever=" + this.model.gslb.everNodeID + "&tspeed=" + this.model.gslb.everNodeSpeed);
               }
               
               _loc2_[_loc3_] = _loc2_[_loc3_] + ("&uuid=" + LetvStatistics.getInstance().uuid);
               _loc3_++;
            }
         }
         return _loc2_;
      }
      
      override protected function onLoadComplete(param1:AutoLoaderEvent) : Object
      {
         var _loc2_:Object = super.onLoadComplete(param1);
         this._gslbLogData = param1.dataProvider.content;
         if(this.isRetry)
         {
            return this.retryComplete(_loc2_);
         }
         this.model.gslb.playlevel = _loc2_.playlevel;
         if(!GslbControl.hadControl && !this.model.isLowestRate && _loc2_.playlevel >= 3)
         {
            Kernel.sendLog(this + " PowerControl PlayLevel: " + _loc2_.playlevel + " " + this.model.setting.definition + "->" + this.model.lowestDefinition);
            this.model.setting.definition = this.model.lowestDefinition;
            this.load(this.model.setting.definition,this._gslbList,false);
         }
         else
         {
            this.onGslbComplete(_loc2_,param1);
         }
         return null;
      }
      
      private function onGslbComplete(param1:Object, param2:AutoLoaderEvent) : void
      {
         var obj:Object = null;
         var status:int = 0;
         var e:GslbEvent = null;
         var value:Object = param1;
         var event:AutoLoaderEvent = param2;
         GslbControl.hadControl = true;
         try
         {
            obj = value.data;
            if((obj.hasOwnProperty("status")) && int(obj.status) >= 400)
            {
               status = int(obj.status);
               Kernel.sendLog(this + " Complete analy error status=" + status);
               if((this.transferFlag) && (status == 424 || status == 425))
               {
                  this.startTransfer();
               }
               else
               {
                  this.analyError();
               }
               return;
            }
            if(!this.model.preloadData.preload)
            {
               this.analyGSLBData(value);
            }
         }
         catch(e:Error)
         {
            analyError();
            return;
         }
         this.model.sendDebug(PageDebugLog.GSBL_COMPLETE,{
            "remote":"IP:" + this.model.gslb.remote,
            "geo":"用户调度所在区域：" + this.model.gslb.geo,
            "desc":"用户所在运营商信息:" + this.model.gslb.desc,
            "speed":"用户网速：" + this.model.cookieControl.averageSpeed
         });
         Kernel.sendLog(this + " Complete usep2p: " + this.model.gslb.usep2p + " forcegslb: " + this.model.gslb.gslbp2pRate);
         var statValue:Object = {
            "utime":event.dataProvider.utime,
            "retry":event.retry
         };
         if(this.model.preloadData.preload)
         {
            this.model.preloadData.gslbPreloadData = value;
            this.model.preloadData.statValue = statValue;
            this.model.preloadData.currentGslbUrl = event.dataProvider.url;
            e = new GslbEvent(GslbEvent.LOAD_SUCCESS);
            dispatchEvent(e);
         }
         else
         {
            this.model.gslb.currentGslbUrl = event.dataProvider.url;
            this.model.gslb.urlist = value.list as Array;
            this.model.config.rate = null;
            this.sendStat(statValue);
            this.startP2PLib();
         }
      }
      
      private function retryComplete(param1:Object) : Object
      {
         var obj:Object = null;
         var status:int = 0;
         var result:Object = param1;
         try
         {
            obj = result.data;
            if((obj.hasOwnProperty("status")) && int(obj.status) >= 400)
            {
               status = int(obj.status);
               Kernel.sendLog(this + " onLoadComplete analy error status=" + status);
               if((this.transferFlag) && (status == 424 || status == 425))
               {
                  this.startTransfer();
               }
               else
               {
                  this.analyError();
               }
               return null;
            }
            if(obj.hasOwnProperty("updatecdn"))
            {
               this.model.gslb.gslbp2pRate = int(obj["updatecdn"]);
            }
            else if(obj.hasOwnProperty("forcegslb"))
            {
               this.model.gslb.gslbp2pRate = int(obj["forcegslb"]);
            }
            else
            {
               this.model.gslb.gslbp2pRate = -1;
            }
            
         }
         catch(e:Error)
         {
         }
         Kernel.sendLog(this + " Complete forcegslb: " + this.model.gslb.gslbp2pRate);
         dispatchEvent(new GslbEvent(GslbEvent.LOAD_SUCCESS,result));
         return null;
      }
      
      override protected function onLoadError(param1:*) : void
      {
         if(this.isRetry)
         {
            this.retryError(param1);
            return;
         }
         super.onLoadError(param1);
         var _loc2_:* = param1 + "";
         if(!(param1 == null) && param1 is AutoLoaderEvent)
         {
            _loc2_ = "47" + param1.errorCode;
            this.model.statistics.sendStat(Stat.LOG_PLAY,Stat.LOG_PLAY_GSLB,{
               "error":_loc2_,
               "utime":param1.dataProvider.utime,
               "retry":param1.retry
            });
         }
         else if(param1 != null)
         {
            this.model.statistics.sendStat(Stat.LOG_PLAY,Stat.LOG_PLAY_GSLB,{"error":_loc2_});
         }
         
         this.sendFailed(_loc2_);
         this.model.sendDebug(PageDebugLog.GSBL_ERROR);
         Kernel.sendLog(this + " onLoadError " + _loc2_,"error");
      }
      
      private function retryError(param1:*) : void
      {
         var _loc2_:* = param1 + "";
         if(!(param1 == null) && param1 is AutoLoaderEvent)
         {
            _loc2_ = "47" + String(param1.errorCode);
            Kernel.sendLog(this + "  onLoadError " + _loc2_,"error");
            this.sendFailed(_loc2_);
         }
         else
         {
            Kernel.sendLog(this + " onLoadError " + _loc2_,"error");
            this.sendFailed(PlayerError.GSLB_ANALY_ERROR);
         }
      }
      
      private function startTransfer() : void
      {
         this.GC_Transfer();
         this.transferFlag = false;
         var _loc1_:String = this.model.preloadData.preload?this.model.setting.nextvid:this.model.setting.vid;
         this.transfer = IDTransfer.create({"vid":_loc1_},this.model);
         Kernel.sendLog(this + " startTransfer");
         if(this.transfer != null)
         {
            this.transfer.addEventListener(TransferEvent.LOAD_SUCCESS,this.onTransferSuccess);
            this.transfer.addEventListener(TransferEvent.LOAD_FAILED,this.onTransferFailed);
            this.transfer.transform();
         }
         else
         {
            this.onTransferFailed();
         }
      }
      
      private function onTransferSuccess(param1:TransferEvent) : void
      {
         Kernel.sendLog(this + " onTransferSuccess");
         var _loc2_:TransferResult = param1.dataProvider as TransferResult;
         if(!this.model.preloadData.preload)
         {
            this.model.gslb.gslblist = _loc2_.playData.list;
         }
         else
         {
            this.model.preloadData.preloadData.playData.list = _loc2_.playData.list;
         }
         this._gslbList = _loc2_.playData.list;
         this.GC_Transfer();
         this.preprogress(this.model.setting.definition,this._gslbList);
      }
      
      private function onTransferFailed(param1:TransferEvent = null) : void
      {
         Kernel.sendLog(this + " onTransferFailed" + param1,"error");
         this.sendFailed(param1 != null?param1.errorCode:PlayerError.INPUT_ERROR);
      }
      
      private function GC_Transfer() : void
      {
         if(this.transfer != null)
         {
            this.transfer.destroy();
            this.transfer.removeEventListener(TransferEvent.LOAD_SUCCESS,this.onTransferSuccess);
            this.transfer.removeEventListener(TransferEvent.LOAD_FAILED,this.onTransferFailed);
            this.transfer = null;
         }
      }
      
      protected function startP2PLib() : void
      {
         var _loc1_:String = MediaFactory.getMediaType(this.model);
         Kernel.sendLog(this + " startP2PLib " + _loc1_);
         if(this.p2plib == null)
         {
            this.p2plib = new GslbP2PLibLoader();
         }
         this.p2plib.addEventListener(Event.COMPLETE,this.onP2PLibComplete);
         switch(_loc1_)
         {
            case PlayMode.P2P_VOD:
            case PlayMode.P2P_TRY:
               this.p2plib.load(this.model.config.p2pflvurl,null);
               break;
            case PlayMode.P2P_M3U8_VOD:
            case PlayMode.P2P_M3U8_TRY:
               this.p2plib.load(null,this.model.config.p2pm3u8url);
               break;
            default:
               this.onP2PLibComplete();
         }
      }
      
      protected function onP2PLibComplete(param1:Event = null) : void
      {
         this.GC_P2PLib();
         this.model.p2p.flush(this.p2plib.p2pFlvClass,this.p2plib.p2pM3u8vClass);
         var _loc2_:GslbEvent = new GslbEvent(GslbEvent.LOAD_SUCCESS);
         dispatchEvent(_loc2_);
      }
      
      private function GC_P2PLib() : void
      {
         if(this.p2plib != null)
         {
            this.p2plib.removeEventListener(Event.COMPLETE,this.onP2PLibComplete);
            this.p2plib.destroy();
         }
      }
      
      protected function sendFailed(param1:String) : void
      {
         this.destroy();
         var _loc2_:GslbEvent = new GslbEvent(GslbEvent.LOAD_FAILED);
         _loc2_.errorCode = param1;
         dispatchEvent(_loc2_);
      }
      
      private function analyGSLBData(param1:Object) : void
      {
         var _loc2_:Object = param1.data;
         if(_loc2_.hasOwnProperty("needtest"))
         {
            this.model.gslb.cantest = String(_loc2_["needtest"]) == "1";
         }
         if(_loc2_.hasOwnProperty("geo"))
         {
            this.model.gslb.geo = _loc2_["geo"];
         }
         if(_loc2_.hasOwnProperty("desc"))
         {
            this.model.gslb.desc = _loc2_["desc"];
         }
         if(_loc2_.hasOwnProperty("remote"))
         {
            this.model.gslb.remote = _loc2_["remote"];
         }
         if(_loc2_.hasOwnProperty("usep2p"))
         {
            this.model.gslb.usep2p = String(_loc2_["usep2p"]) == "1";
         }
         else
         {
            this.model.gslb.usep2p = true;
         }
         if(_loc2_.hasOwnProperty("updatecdn"))
         {
            this.model.gslb.gslbp2pRate = int(_loc2_["updatecdn"]);
         }
         else if(_loc2_.hasOwnProperty("forcegslb"))
         {
            this.model.gslb.gslbp2pRate = int(_loc2_["forcegslb"]);
         }
         else
         {
            this.model.gslb.gslbp2pRate = -1;
         }
         
      }
      
      private function sendStat(param1:Object) : void
      {
         var _loc2_:String = null;
         if(!(this.model.setting.upDefinition == this.model.setting.definition) && !(this.model.setting.upDefinition == null))
         {
            _loc2_ = "1_" + this.model.setting.upDefinition + "_" + this.model.setting.definition;
         }
         else
         {
            _loc2_ = "0";
         }
         this.model.statistics.sendStat(Stat.LOG_PLAY,Stat.LOG_PLAY_GSLB,{
            "utime":param1.utime,
            "retry":param1.retry,
            "sra":_loc2_,
            "ra":this.model.gslb.ra
         });
      }
      
      public function setPreloadData() : void
      {
         try
         {
            this.analyGSLBData(this.model.preloadData.gslbPreloadData);
         }
         catch(e:Error)
         {
         }
         this.model.gslb.gslblist = this.model.preloadData.preloadData.playData.list;
         this.model.gslb.urlist = this.model.preloadData.gslbPreloadData.list as Array;
         this.model.gslb.currentGslbUrl = this.model.preloadData.currentGslbUrl;
         this.model.config.rate = null;
         this.sendStat(this.model.preloadData.statValue);
      }
      
      private function analyError() : void
      {
         Kernel.sendLog(this + "gslbData:" + this._gslbLogData);
         this.onLoadError(PlayerError.GSLB_ANALY_ERROR);
      }
   }
}
