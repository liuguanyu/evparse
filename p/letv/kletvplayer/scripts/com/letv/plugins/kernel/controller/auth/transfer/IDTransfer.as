package com.letv.plugins.kernel.controller.auth.transfer
{
   import flash.events.EventDispatcher;
   import com.letv.plugins.kernel.model.Model;
   import com.letv.plugins.kernel.tools.TimeStamp;
   import flash.events.Event;
   import com.alex.utils.BrowserUtil;
   import com.alex.rpc.AutoLoader;
   import com.alex.rpc.events.AutoLoaderEvent;
   import com.alex.rpc.type.ResourceType;
   import com.letv.pluginsAPI.stat.PageDebugLog;
   import com.alex.utils.JSONUtil;
   import com.letv.plugins.kernel.Kernel;
   import com.alex.utils.RichStringUtil;
   import com.letv.plugins.kernel.model.special.gslb.GslbItemData;
   import com.letv.pluginsAPI.kernel.PlayerError;
   import com.alex.rpc.type.StateType;
   
   public class IDTransfer extends EventDispatcher
   {
      
      private var loader:AutoLoader;
      
      private const URL3:String = "http://api.letv.com/mms/out/video/playJson?id=";
      
      private const URL4:String = "http://117.121.54.104/mms/out/video/playJson?id=";
      
      private var model:Model;
      
      private var metadata:Object;
      
      private var timestamp:TimeStamp;
      
      private var doubleTimeError:Boolean = false;
      
      public function IDTransfer(param1:Model, param2:Object)
      {
         this.timestamp = TimeStamp.getInstance();
         super();
         this.model = param1;
         this.metadata = param2;
      }
      
      public static function create(param1:Object, param2:Model) : IDTransfer
      {
         if(!param1 || !param1["vid"])
         {
            return null;
         }
         if(!param1.hasOwnProperty("pid"))
         {
            param1["pid"] = param2.setting.pid;
         }
         return new IDTransfer(param2,param1);
      }
      
      public function destroy() : void
      {
         this.model = null;
         this.metadata = null;
         this.gc();
      }
      
      public function transform() : void
      {
         this.gc();
         this.timestamp = TimeStamp.getInstance();
         this.timestamp.addEventListener(TimeStamp.SETUP_INIT,this.onTimestampInit);
         this.timestamp.addEventListener(TimeStamp.SETUP_ERROR,this.onTimestampError);
         this.timestamp.init();
      }
      
      private function onTimestampError(param1:Event) : void
      {
         this.sendFailed(this + " onTimestampError ",9);
         this.gc();
      }
      
      private function onTimestampInit(param1:Event) : void
      {
         this.loadData();
      }
      
      private function getURL(param1:String) : String
      {
         var _loc2_:String = param1 + String(this.metadata.vid);
         if(this.model.config.flashvars.flashvars.hasOwnProperty("platid"))
         {
            _loc2_ = _loc2_ + ("&platid=" + this.model.config.flashvars.flashvars.platid);
         }
         else
         {
            _loc2_ = _loc2_ + "&platid=1";
         }
         if(this.model.config.flashvars.flashvars.hasOwnProperty("splatid"))
         {
            _loc2_ = _loc2_ + ("&splatid=" + this.model.config.flashvars.flashvars.splatid);
         }
         else
         {
            _loc2_ = _loc2_ + "&splatid=101";
         }
         _loc2_ = _loc2_ + "&format=1";
         _loc2_ = _loc2_ + ("&tkey=" + this.timestamp.calcTimeKey());
         _loc2_ = _loc2_ + ("&domain=" + encodeURIComponent(BrowserUtil.domain));
         return _loc2_;
      }
      
      private function loadData() : void
      {
         this.loaderGc();
         this.timestamp = TimeStamp.getInstance();
         try
         {
            this.loader = new AutoLoader();
            this.loader.addEventListener(AutoLoaderEvent.LOAD_ERROR,this.onLoadError);
            this.loader.addEventListener(AutoLoaderEvent.LOAD_COMPLETE,this.onLoadComplete);
            this.loader.addEventListener(AutoLoaderEvent.LOAD_STATE_CHANGE,this.onLoadState);
            this.loader.setup([{
               "url":this.getURL(this.URL3),
               "type":ResourceType.TEXT
            },{
               "url":this.getURL(this.URL4),
               "type":ResourceType.TEXT
            }]);
            this.model.sendDebug(PageDebugLog.STARTUP_CMS);
         }
         catch(e:Error)
         {
            onLoadError();
         }
      }
      
      private function analyData(param1:Object, param2:Number = 0, param3:int = 1) : void
      {
         var strlog:String = null;
         var data:Object = null;
         var playData:TransferPlayData = null;
         var limitData:Object = null;
         var stime:int = 0;
         var status:int = 0;
         var key:* = undefined;
         var h:Object = null;
         var value:Object = param1;
         var utime:Number = param2;
         var retry:int = param3;
         strlog = "CDATA:" + value;
         try
         {
            data = JSONUtil.decode(String(value));
         }
         catch(e:Error)
         {
            sendFailed("[Analy Error Json 0] " + strlog,3);
            return;
         }
         if((data.hasOwnProperty("statuscode")) && !(String(data.statuscode) == "1001"))
         {
            if(String(data.statuscode) == "1003")
            {
               stime = int(data.playstatus && data.playstatus["stime"]);
               if((stime) && (!this.timestamp.stime) || !this.doubleTimeError)
               {
                  Kernel.sendLog(this + " [Failed] " + strlog);
                  this.timestamp.stime = stime;
                  this.doubleTimeError = true;
                  this.loadData();
                  return;
               }
            }
            this.sendFailed("[Analy Error Json 1] " + strlog,8);
            return;
         }
         if(data.hasOwnProperty("playstatus"))
         {
            status = int(this.playstatus(data.playstatus));
            if(status != 200)
            {
               this.sendFailed("[Analy Error Json 2] " + strlog,status);
               return;
            }
         }
         try
         {
            if(data.hasOwnProperty("playurl"))
            {
               playData = this.analyPlayData(data.playurl);
            }
            else
            {
               this.sendFailed("[Analy Error Json 3] " + strlog,3);
               return;
            }
         }
         catch(e:Error)
         {
            sendFailed("[Analy Error Json 4] " + strlog,3);
            return;
         }
         if(!playData)
         {
            this.sendFailed("[Analy Error Json 5] " + strlog,3);
            return;
         }
         var pointtmp:Object = data.point;
         var point:Object = {};
         if(pointtmp)
         {
            if(pointtmp["hot"])
            {
               point["hot"] = [];
               for(key in pointtmp["hot"])
               {
                  h = {};
                  h["step"] = parseInt(key) || 0;
                  h["mess"] = pointtmp["hot"][key] || "";
                  point["hot"].push(h);
               }
            }
            point["skip"] = pointtmp["skip"] || ["skip"];
         }
         var result:TransferResult = new TransferResult();
         result.playData = playData;
         result.barrageSupport = data["danmu"] == "1";
         result.obj = {
            "utime":utime,
            "retry":retry
         };
         result.point = point;
         result.paylist = data["paylist"] as Array || [];
         var dIndex:int = result.paylist.indexOf("720p");
         if(dIndex >= 0)
         {
            result.paylist.splice(dIndex,1);
         }
         result.trylook = (parseInt(data["trylook"])) || 0;
         limitData = {};
         limitData.firstlook = data["firstlook"] == "1";
         limitData.login = data["cutoff"] == "1" && this.model.config.cut;
         try
         {
            limitData.cutPC = !(data["cutoff_p"].indexOf("101") == -1);
         }
         catch(e:Error)
         {
            limitData.cutPC = false;
         }
         if(data["cutoff_t"] != null)
         {
            limitData.cutoffPCTime = data["cutoff_t"] * 60;
         }
         else
         {
            limitData.cutoffPCTime = 900;
         }
         result.limitData = limitData;
         if(data.hasOwnProperty("watermark"))
         {
            result.mark = data.watermark;
         }
         else
         {
            result.mark = {};
         }
         this.doubleTimeError = false;
         this.model.sendDebug(PageDebugLog.CMS_COMPLETE);
         this.sendSuccess(result);
      }
      
      private function analyPlayData(param1:* = null) : TransferPlayData
      {
         var _loc3_:String = null;
         var _loc4_:Object = null;
         var _loc8_:String = null;
         var _loc9_:* = 0;
         var _loc10_:Array = null;
         var _loc11_:Object = null;
         var _loc12_:Object = null;
         var _loc13_:Vector.<String> = null;
         var param1:* = param1 || {};
         var _loc2_:Array = param1.domain || [];
         for(_loc3_ in param1.dispatch || {})
         {
            _loc8_ = param1.dispatch[_loc3_][0];
            _loc9_ = 0;
            _loc10_ = [];
            while(_loc9_ < _loc2_.length)
            {
               _loc10_.push(_loc2_[_loc9_] + _loc8_);
               _loc9_++;
            }
            _loc10_.push(_loc10_[0] + "&retry=1");
            _loc11_ = RichStringUtil.getUrlParams(_loc8_);
            _loc12_ = {};
            _loc12_["url"] = _loc10_[0];
            _loc12_["urls"] = _loc10_;
            _loc12_["df"] = param1.dispatch[_loc3_][1];
            _loc12_["mmsid"] = this.getParam(_loc11_,"mmsid");
            _loc12_["vtype"] = this.getParam(_loc11_,"vtype");
            _loc12_["br"] = this.getParam(_loc11_,"b") || "0";
            if(!_loc4_)
            {
               _loc4_ = {};
            }
            _loc13_ = new <String>[this.model.config.flashvars.p1,this.model.config.flashvars.p2,this.model.config.flashvars.p3];
            _loc4_[_loc3_] = new GslbItemData(_loc12_,_loc13_);
         }
         if(!_loc4_)
         {
            return null;
         }
         var _loc5_:Object = {};
         var _loc6_:Array = param1["download"] as Array || [];
         _loc9_ = 0;
         while(_loc9_ < _loc6_.length)
         {
            _loc5_[_loc6_[_loc9_]] = true;
            _loc9_++;
         }
         var _loc7_:TransferPlayData = new TransferPlayData();
         _loc7_.list = _loc4_;
         _loc7_.download = _loc5_;
         _loc7_.cid = param1["cid"];
         _loc7_.pid = param1["pid"] || null;
         _loc7_.vid = param1["vid"] || null;
         _loc7_.title = param1["title"] || "";
         _loc7_.duration = (parseInt(param1["duration"])) || 0;
         _loc7_.url = RichStringUtil.trim(decodeURIComponent(param1["url"]),true);
         _loc7_.pic = RichStringUtil.trim(decodeURIComponent(param1["pic"]),true);
         _loc7_.total = (parseInt(param1["total"])) || 0;
         _loc7_.mmsid = _loc12_["mmsid"];
         _loc7_.nextvid = (param1["nextvid"] == "0"?null:param1["nextvid"]) || null;
         return _loc7_;
      }
      
      private function playstatus(param1:*) : String
      {
         var obj:Object = null;
         var value:* = param1;
         try
         {
            if(value is String)
            {
               obj = JSONUtil.decode(value);
            }
            else
            {
               obj = value;
            }
            if(obj.status == "0")
            {
               switch(String(obj.flag))
               {
                  case "0":
                     return PlayerError.VIDEO_NONE_ERROR;
                  case "2":
                     return PlayerError.VIDEO_RIGHT_ERROR;
                  case "3":
                     return PlayerError.BLACK_LIST_ERROR;
                  case "4":
                     return PlayerError.VIDEO_EDIT_ERROR;
                  case "5":
                     return PlayerError.NEW_MMSID_AUTHTYPE_ERROR;
                  case "1":
                     if(String(obj.country + "").toLowerCase() == "cn")
                     {
                        return PlayerError.AUTH_CN_ERROR;
                     }
                     if(String(obj.country + "").toLowerCase() == "hk")
                     {
                        return PlayerError.AUTH_HK_ERROR;
                     }
                     return PlayerError.AUTH_OVERSEA_ERROR;
               }
            }
            else
            {
               return "200";
            }
         }
         catch(e:Error)
         {
         }
         return PlayerError.NEW_MMSID_ANALY_ERROR;
      }
      
      private function getParam(param1:Object, param2:String) : *
      {
         if(param2 != null)
         {
            if(param1.hasOwnProperty(param2))
            {
               return param1[param2];
            }
         }
         return null;
      }
      
      private function sendSuccess(param1:TransferResult) : void
      {
         this.destroy();
         var _loc2_:TransferEvent = new TransferEvent(TransferEvent.LOAD_SUCCESS);
         _loc2_.dataProvider = param1;
         dispatchEvent(_loc2_);
      }
      
      private function sendFailed(param1:Object = null, param2:int = -1) : void
      {
         Kernel.sendLog(this + " [Failed] " + param1,"error");
         var _loc3_:TransferEvent = new TransferEvent(TransferEvent.LOAD_FAILED);
         _loc3_.dataProvider = param1;
         switch(param2)
         {
            case 0:
               _loc3_.errorCode = PlayerError.NEW_MMSID_IO_ERROR;
               break;
            case 1:
               _loc3_.errorCode = PlayerError.NEW_MMSID_TIMEOUT_ERROR;
               break;
            case 2:
               _loc3_.errorCode = PlayerError.NEW_MMSID_SECURITY_ERROR;
               break;
            case 3:
               _loc3_.errorCode = PlayerError.NEW_MMSID_ANALY_ERROR;
               break;
            case 8:
               _loc3_.errorCode = PlayerError.NEW_MMSID_SERVER_ERROR;
               break;
            case 9:
               _loc3_.errorCode = PlayerError.NEW_MMSID_OTHER_ERROR;
               break;
            default:
               _loc3_.errorCode = "" + param2;
         }
         this.model.sendDebug(PageDebugLog.CMS_ERROR,{"errorCode":"解析ＣＭＳ数据发生错误，错误码:" + param2});
         this.destroy();
         dispatchEvent(_loc3_);
      }
      
      private function onLoadState(param1:AutoLoaderEvent) : void
      {
         if(param1.infoCode == StateType.INFO_OPEN)
         {
            Kernel.sendLog(this + " transform index:" + param1.index + " " + param1.dataProvider.url);
         }
      }
      
      private function onLoadError(param1:AutoLoaderEvent = null) : void
      {
         if(param1 == null || param1.index == param1.total - 1)
         {
            if(!(param1 == null) && param1 is AutoLoaderEvent)
            {
               this.sendFailed(this + " LoadError " + param1.errorCode,param1.errorCode);
            }
            else
            {
               this.sendFailed(this + " LoadError " + param1,9);
            }
         }
         else
         {
            Kernel.sendLog(this + " error index:" + param1.index + " errorcode:" + param1.errorCode,"error");
         }
      }
      
      private function onLoadComplete(param1:AutoLoaderEvent) : void
      {
         Kernel.sendLog(this + " LoadComplete");
         var _loc2_:Object = param1.dataProvider.content;
         this.loaderGc();
         this.analyData(_loc2_,param1.dataProvider.utime,param1.dataProvider.retry);
      }
      
      private function gc() : void
      {
         this.loaderGc();
         this.timestampGc();
      }
      
      private function loaderGc() : void
      {
         if(this.loader != null)
         {
            this.loader.removeEventListener(AutoLoaderEvent.LOAD_ERROR,this.onLoadError);
            this.loader.removeEventListener(AutoLoaderEvent.LOAD_COMPLETE,this.onLoadComplete);
            this.loader.removeEventListener(AutoLoaderEvent.LOAD_STATE_CHANGE,this.onLoadState);
            this.loader.destroy();
            this.loader = null;
         }
      }
      
      private function timestampGc() : void
      {
         if(this.timestamp != null)
         {
            this.timestamp.removeEventListener(TimeStamp.SETUP_INIT,this.onTimestampInit);
            this.timestamp.removeEventListener(TimeStamp.SETUP_ERROR,this.onTimestampError);
            this.timestamp = null;
         }
      }
   }
}
