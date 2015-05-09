package com.letv.plugins.kernel.model
{
   import flash.events.EventDispatcher;
   import com.letv.plugins.kernel.controller.auth.transfer.TransferResult;
   import com.letv.plugins.kernel.Kernel;
   import com.letv.plugins.kernel.statistics.*;
   import com.letv.plugins.kernel.model.special.*;
   import com.alex.utils.BrowserUtil;
   import com.letv.pluginsAPI.cookieApi.CookieAPI;
   import flash.geom.Rectangle;
   import com.letv.plugins.kernel.media.MediaEvent;
   import flash.events.Event;
   import com.letv.pluginsAPI.api.JsAPI;
   import flash.external.ExternalInterface;
   import com.letv.pluginsAPI.kernel.PlayerStateEvent;
   import com.letv.pluginsAPI.kernel.DefinitionType;
   import com.alex.utils.ObjectUtil;
   import com.letv.plugins.kernel.model.special.gslb.GslbItemData;
   import flash.net.SharedObject;
   import flash.net.FileReference;
   import com.letv.pluginsAPI.stat.Stat;
   import com.letv.pluginsAPI.stat.PageDebugLog;
   import com.letv.plugins.kernel.controller.cookie.CookieControl;
   
   public class Model extends EventDispatcher
   {
      
      private var debug:PageDebugLog;
      
      public var statistics:LetvStatistics;
      
      public var cookieControl:CookieControl;
      
      public var config:ConfigData;
      
      public var user:UserSetting;
      
      public var play:PlaySetting;
      
      public var transfer:TransferData;
      
      public var setting:VideoSetting;
      
      public var flashCookie:FlashCookie;
      
      public var vrs:VrsData;
      
      public var ad:AdData;
      
      public var p2p:P2PData;
      
      public var coopAuth:CoopAuthData;
      
      public var metadata:MetaData;
      
      public var gslb:GslbData;
      
      public var versions:VersionData;
      
      public var playMode:String;
      
      public var videoRect:Rectangle;
      
      public var waterMarkData:WaterMarkData;
      
      public var preloadData:PreloadData;
      
      public function Model()
      {
         this.debug = PageDebugLog.getInstance();
         this.statistics = LetvStatistics.getInstance();
         this.cookieControl = CookieControl.getInstance();
         this.config = ConfigData.getInstance();
         this.user = UserSetting.getInstance();
         this.play = PlaySetting.getInstance();
         this.transfer = TransferData.getInstance();
         this.setting = VideoSetting.getInstance();
         this.vrs = VrsData.getInstance();
         this.ad = AdData.getInstance();
         this.p2p = new P2PData();
         this.gslb = new GslbData();
         this.versions = new VersionData();
         this.waterMarkData = new WaterMarkData();
         this.preloadData = new PreloadData();
         super();
         this.versions.version = EmbedConfig.CONFIG.version;
         try
         {
            ExternalInterface.call(JsAPI.SEND_LC_TO_PAGE,this.statistics.lc);
         }
         catch(e:Error)
         {
         }
      }
      
      public function setConfig(param1:XML = null, param2:Object = null) : void
      {
         this.config.flush(param1,param2);
         this.versions.mainVersion = this.config.version;
         this.setting.flushFromFlashVars(param2);
         if(this.config.forvip)
         {
            this.user.forvip();
         }
         else
         {
            this.user.reset();
         }
      }
      
      public function setSetting(param1:TransferResult) : void
      {
         var result:TransferResult = param1;
         try
         {
            result.playData.mmsid = this.currentGslb.mmsid;
         }
         catch(e:Error)
         {
         }
         this.transfer.flush(result);
         this.vrs.flush(result.point);
         this.setting.trylook = this.transfer.trylook;
         this.user.payType = this.transfer.trylookType;
         if((this.coopAuth) && this.coopAuth.playtime <= 0)
         {
            this.setting.trylook = false;
         }
         this.play.setLimitData(result.limitData);
         this.waterMarkData.setData(result.mark);
         this.setting.flushFromTransfer(result);
      }
      
      public function setFlashCookie(param1:Object) : void
      {
         this.flashCookie = new FlashCookie(param1);
         Kernel.sendLog("Cookie.RecordTime " + this.flashCookie.recordTime);
         this.setting.defaultDefinition = this.flashCookie.defaultDefinition;
         this.setting.definition = param1.currentDefinition;
         this.setting.jump = this.flashCookie.jump;
         this.setting.fullscreenInput = this.flashCookie.fullscreenInput;
         if(!(BrowserUtil.url == null) && BrowserUtil.url.indexOf("barrage=1") > 0)
         {
            this.setting.barrage = true;
         }
         else
         {
            this.setting.barrage = this.flashCookie.barrage;
         }
         if(this.config.flashvars.autoMute == 1)
         {
            this.setting.volume = 0;
         }
         else
         {
            this.setting.volume = this.flashCookie.volume;
         }
         if(this.cookieControl.so.data[CookieAPI.UP_VOLUME] > 0)
         {
            this.setting.upVolume = this.cookieControl.so.data[CookieAPI.UP_VOLUME];
         }
      }
      
      public function setCoopAuthData(param1:Object) : void
      {
         if(param1)
         {
            this.coopAuth = new CoopAuthData(param1,this.user);
            this.play.playDuration = this.coopAuth.playtime;
         }
         else
         {
            this.coopAuth = null;
            this.user.reset();
            this.play.playDuration = -1;
         }
      }
      
      public function playNormalFromTry() : void
      {
         this.user.payLook = true;
      }
      
      public function setMetaData(param1:Object) : void
      {
         this.metadata = new MetaData(param1);
         if(this.setting.currentScale == this.setting.originalScale)
         {
            this.setting.fullScale = false;
            this.setting.currentScale = this.metadata.scale;
         }
         this.setting.originalScale = this.metadata.scale;
         this.setting.originalRect = new Rectangle(0,0,this.metadata.width,this.metadata.height);
         if(this.config.scale > 0)
         {
            this.setting.currentScale = this.config.scale;
         }
         dispatchEvent(new MediaEvent(MediaEvent.META_DATA));
         dispatchEvent(new Event(Event.RESIZE));
      }
      
      public function sendInterface(param1:String, param2:Object = null) : Object
      {
         var callback:Object = null;
         var type:String = param1;
         var info:Object = param2;
         if(this.config.flashvars.callbackJs == null)
         {
            return {"status":"error"};
         }
         switch(type)
         {
            case JsAPI.PLAYER_VIDEO_COMPLETE:
            case JsAPI.PLAYER_GET_NEXT_VID:
               info = {
                  "id":this.setting.vid,
                  "recommendvideo":this.config.flashvars.up,
                  "fullscreen":this.setting.fullscreen,
                  "continuePlay":this.setting.continuePlay,
                  "nextvid":this.setting.nextvid
               };
               break;
            case JsAPI.PLAYER_PLAY_NEXT:
               info = {
                  "id":this.setting.vid,
                  "fullscreen":this.setting.fullscreen,
                  "nextvid":this.setting.nextvid,
                  "active":info
               };
               break;
         }
         try
         {
            callback = ExternalInterface.call(this.config.flashvars.callbackJs,type,info);
         }
         catch(e:Error)
         {
            callback = null;
         }
         if((callback) && !callback.hasOwnProperty("status"))
         {
            callback["status"] = "error";
         }
         if(callback == null)
         {
            callback = {"status":"error"};
         }
         return callback;
      }
      
      public function set playerState(param1:Object) : void
      {
         var _loc2_:PlayerStateEvent = null;
         if(param1 != null)
         {
            if(param1 is Array && param1.length > 1)
            {
               _loc2_ = new PlayerStateEvent(param1[0]);
               _loc2_.dataProvider = param1[1];
               dispatchEvent(_loc2_);
            }
            else
            {
               dispatchEvent(new PlayerStateEvent(param1 as String));
            }
         }
      }
      
      public function set volume(param1:Number) : void
      {
         this.setting.volume = param1;
         this.config.flashvars.autoMute = 0;
      }
      
      public function get volume() : Number
      {
         return this.setting.volume;
      }
      
      public function get isTrylook() : Boolean
      {
         return (this.setting.trylook) && !this.user.payLook;
      }
      
      public function get trylookState() : int
      {
         if(!this.setting.trylook)
         {
            return -1;
         }
         if(this.user.payLook)
         {
            return 1;
         }
         return 0;
      }
      
      public function get hadNextData() : Boolean
      {
         if(this.setting.nextvid)
         {
            return true;
         }
         return false;
      }
      
      public function get isLowestRate() : Boolean
      {
         try
         {
            return this.setting.definition == this.lowestDefinition;
         }
         catch(e:Error)
         {
         }
         return false;
      }
      
      public function get lowestDefinition() : String
      {
         var _loc1_:* = 0;
         if(this.gslb.gslblist != null)
         {
            _loc1_ = 0;
            while(_loc1_ < DefinitionType.STACK.length)
            {
               if(this.gslb.gslblist.hasOwnProperty(DefinitionType.STACK[_loc1_]))
               {
                  return DefinitionType.STACK[_loc1_];
               }
               _loc1_++;
            }
         }
         return null;
      }
      
      public function get lowestGslb() : String
      {
         try
         {
            return this.gslb.gslblist[this.lowestDefinition].url;
         }
         catch(e:Error)
         {
         }
         return null;
      }
      
      public function get adEnabled() : Boolean
      {
         if(this.setting.trylook)
         {
            return false;
         }
         if(!this.setting.adEnabled)
         {
            return false;
         }
         return true;
      }
      
      public function get adState() : int
      {
         if(this.config.flashvars.adLoaded == 0)
         {
            return 0;
         }
         if(!this.setting.adEnabled)
         {
            return this.config.flashvars.adLoaded == 1?10:-10;
         }
         if((this.setting.trylook) && !this.user.payLook)
         {
            return 4;
         }
         if(this.user.isVip)
         {
            return 3;
         }
         return this.config.flashvars.adLoaded;
      }
      
      public function get up() : String
      {
         var _loc1_:String = null;
         var _loc2_:Object = {};
         if(this.trylookState >= 0)
         {
            _loc2_["pay"] = this.trylookState;
         }
         if(this.config.flashvars.up == "1")
         {
            _loc2_["play"] = "1";
         }
         var _loc3_:String = ObjectUtil.objectParseToString(_loc2_);
         if(_loc3_ == "")
         {
            return "-";
         }
         return encodeURIComponent(_loc3_);
      }
      
      public function get isPay() : Boolean
      {
         var _loc1_:* = 0;
         if(this.transfer.listVip != null)
         {
            while(_loc1_ < this.transfer.listVip.length)
            {
               if(this.setting.definition == this.transfer.listVip[_loc1_])
               {
                  return true;
               }
               _loc1_++;
            }
         }
         return false;
      }
      
      public function get is720P() : Boolean
      {
         return this.setting.definition == DefinitionType.P720;
      }
      
      public function get is1080P() : Boolean
      {
         return this.setting.definition == DefinitionType.P1080;
      }
      
      public function get is4K() : Boolean
      {
         return this.setting.definition == DefinitionType.K4;
      }
      
      public function get isM3U8() : Boolean
      {
         try
         {
            return this.currentGslb.newver;
         }
         catch(e:Error)
         {
         }
         return false;
      }
      
      public function get currentGslb() : GslbItemData
      {
         try
         {
            return this.gslb.gslblist[this.setting.definition];
         }
         catch(e:Error)
         {
         }
         return null;
      }
      
      public function get cdnlist() : Array
      {
         var i:int = 0;
         var arr:Array = [];
         try
         {
            i = 0;
            while(i < this.gslb.urlist.length)
            {
               if(this.gslb.urlist[i] != null)
               {
                  if(this.gslb.urlist[i].hasOwnProperty(this.setting.definition))
                  {
                     arr.push(this.gslb.urlist[i][this.setting.definition].location);
                  }
               }
               i++;
            }
         }
         catch(e:Error)
         {
         }
         return arr;
      }
      
      public function get cdnlistInfo() : Array
      {
         var i:int = 0;
         var urlitem:Object = null;
         var arr:Array = [];
         try
         {
            i = 0;
            while(i < this.gslb.urlist.length)
            {
               if(this.gslb.urlist[i] != null)
               {
                  if(this.gslb.urlist[i].hasOwnProperty(this.setting.definition))
                  {
                     urlitem = this.gslb.urlist[i][this.setting.definition];
                     arr.push({
                        "location":urlitem.location,
                        "playlevel":urlitem.playlevel,
                        "kbps":this.setting.definition
                     });
                  }
               }
               i++;
            }
         }
         catch(e:Error)
         {
         }
         return arr;
      }
      
      public function setAssistData(param1:Object) : void
      {
         this.ad.flush(param1);
      }
      
      public function setCookie(param1:String, param2:Object) : Boolean
      {
         var so:SharedObject = null;
         var type:String = param1;
         var value:Object = param2;
         try
         {
            so = SharedObject.getLocal(CookieAPI.COOKIE_NAME,"/");
            so.data[type] = value;
            so.flush();
            return true;
         }
         catch(e:Error)
         {
         }
         return false;
      }
      
      public function setContinuePlay(param1:Boolean = false) : void
      {
         var flag:Boolean = param1;
         try
         {
            this.setting.continuePlay = flag;
         }
         catch(e:Error)
         {
            Kernel.sendLog("Kernel.setContinuePlay Invalid","warn");
         }
      }
      
      public function setFullscreenInput(param1:Boolean = false) : void
      {
         var flag:Boolean = param1;
         try
         {
            this.setting.fullscreenInput = flag;
            this.cookieControl.recordFullscreenInput();
         }
         catch(e:Error)
         {
            Kernel.sendLog("Kernel.setFullscreenInput Invalid","warn");
         }
      }
      
      public function setBarrage(param1:Boolean = false) : void
      {
         var flag:Boolean = param1;
         try
         {
            this.setting.barrage = flag;
            this.cookieControl.recordBarrage();
         }
         catch(e:Error)
         {
            Kernel.sendLog("Kernel.setBarrage Invalid","warn");
         }
      }
      
      public function setAutoReplay(param1:Boolean) : void
      {
         this.play.autoReplay = param1;
      }
      
      public function getPlayRecord() : Object
      {
         var so:SharedObject = null;
         try
         {
            so = SharedObject.getLocal(CookieAPI.COOKIE_NAME,"/");
            return so.data[CookieAPI.DATA_PLAYRECORD];
         }
         catch(e:Error)
         {
         }
         return null;
      }
      
      public function getCookie(param1:String) : Object
      {
         var so:SharedObject = null;
         var value:String = param1;
         try
         {
            so = SharedObject.getLocal(CookieAPI.COOKIE_NAME,"/");
            return so.data[value];
         }
         catch(e:Error)
         {
         }
         return null;
      }
      
      public function getVideoVolume() : Number
      {
         try
         {
            return this.setting.volume;
         }
         catch(e:Error)
         {
         }
         return 0;
      }
      
      public function getVideoRect(param1:String = "xml") : Object
      {
         switch(param1)
         {
            case "amf":
               return this.setting.originalRect;
            case "xml":
               return "<root><width>" + this.setting.originalRect.width + "</width><height>" + this.setting.originalRect.height + "</height></root>";
            default:
               return null;
         }
      }
      
      public function getVideoRotation() : int
      {
         return this.setting.rotation;
      }
      
      public function getVideoScale() : Number
      {
         return this.setting.currentScale;
      }
      
      public function getVideoPercent() : Number
      {
         return this.setting.percent;
      }
      
      public function getVideoColor() : Array
      {
         return this.setting.color;
      }
      
      public function getDefinition() : String
      {
         return this.setting.definition;
      }
      
      public function getDefaultDefinition() : String
      {
         var _loc1_:String = this.setting.defaultDefinition;
         if(_loc1_ == DefinitionType.AUTO)
         {
            return _loc1_;
         }
         if(!this.user.isVip && (this.transfer.isPayD(_loc1_)))
         {
            return this.setting.definition;
         }
         if(!(_loc1_ == DefinitionType.AUTO) && !this.gslb.gslblist.hasOwnProperty(_loc1_))
         {
            return this.setting.definition;
         }
         if(_loc1_ != this.setting.definition)
         {
            return this.setting.definition;
         }
         return _loc1_;
      }
      
      public function getDefinitionList(param1:String = "amf") : Object
      {
         var list:Object = null;
         var testurl:String = null;
         var item:String = null;
         var format:String = param1;
         try
         {
            switch(format)
            {
               case "coop":
               case "amf":
                  list = {};
                  for(item in this.gslb.gslblist)
                  {
                     list[item] = true;
                  }
                  testurl = this.currentGslb.testurl;
                  if((this.config.forvip) || (this.user.isVip))
                  {
                     testurl = testurl + "&pay=1";
                  }
                  else
                  {
                     testurl = testurl + "&pay=0";
                  }
                  if(this.user.isLogin)
                  {
                     testurl = testurl + "&iscpn=f9051";
                  }
                  list.testurl = testurl;
                  break;
               case "xml":
                  list = XML("<root></root>");
                  for(item in this.gslb.gslblist)
                  {
                     list.appendChild(XML("<df>" + item + "</df>"));
                  }
                  list = list.toString();
                  break;
            }
         }
         catch(e:Error)
         {
         }
         return list;
      }
      
      public function getDefinitionMatchList() : Object
      {
         return {
            "vip":this.transfer.listVip,
            "free":this.transfer.listFree
         };
      }
      
      public function getPlayset() : Object
      {
         var _loc1_:Object = {};
         _loc1_["jump"] = this.setting.jump;
         _loc1_["continuePlay"] = this.setting.continuePlay;
         _loc1_["fullScale"] = this.setting.fullScale;
         _loc1_["resetScale"] = this.setting.currentScale == this.setting.originalScale;
         _loc1_["preload"] = this.preloadData.preloadComplete;
         return _loc1_;
      }
      
      public function getVideoSetting() : Object
      {
         var _loc1_:Object = this.setting.clone();
         _loc1_["isTrylook"] = this.isTrylook;
         _loc1_["is4K"] = this.is4K;
         _loc1_["isPay"] = this.isPay;
         _loc1_["isM3U8"] = this.isM3U8;
         _loc1_["isLowestRate"] = this.isLowestRate;
         if(this.vrs != null)
         {
            _loc1_["headTime"] = this.vrs.headTime;
            _loc1_["tailTime"] = this.vrs.tailTime;
         }
         if(this.metadata != null)
         {
            _loc1_["width"] = this.metadata.width;
            _loc1_["height"] = this.metadata.height;
         }
         if(this.currentGslb != null)
         {
            _loc1_["br"] = this.currentGslb.br;
         }
         _loc1_["videoRect"] = this.videoRect;
         _loc1_["firstlook"] = this.play.limitData.firstlook;
         _loc1_["login"] = this.play.limitData.login;
         return _loc1_;
      }
      
      public function getSettingAsText() : void
      {
         var _loc2_:String = null;
         var _loc3_:* = 0;
         var _loc4_:String = null;
         var _loc5_:FileReference = null;
         var _loc1_:Object = this.getVideoSetting();
         if(_loc1_)
         {
            _loc2_ = "【Version】:\n" + this.versions.version + "\n" + "【Update】:\n";
            _loc3_ = 0;
            while(_loc3_ < EmbedConfig.CONFIG.update.length())
            {
               _loc2_ = _loc2_ + (EmbedConfig.CONFIG.update[_loc3_] + "\n");
               _loc3_++;
            }
            _loc2_ = _loc2_ + "【Setting】:\n";
            for(_loc4_ in _loc1_)
            {
               _loc2_ = _loc2_ + (_loc4_ + "  :  " + _loc1_[_loc4_] + "\n");
            }
            _loc5_ = new FileReference();
            _loc5_.save(_loc2_,"KernelSetting.txt");
         }
      }
      
      public function getVersion() : Object
      {
         return {
            "main":this.versions.mainVersion,
            "kernel":this.versions.version,
            "p2p":this.versions.p2pVersion
         };
      }
      
      public function getIdInfo() : Object
      {
         return {
            "p1":this.config.flashvars.p1,
            "p2":this.config.flashvars.p2,
            "p3":this.config.flashvars.p3,
            "ty":"0",
            "pv":this.versions.mainVersion,
            "uid":this.user.uid,
            "cid":this.setting.cid,
            "pid":this.setting.pid,
            "vid":this.setting.vid,
            "mmsid":this.setting.mmsid,
            "url":this.setting.url,
            "uuid":this.statistics.uuid,
            "lc":this.statistics.lc,
            "uname":this.user.uname,
            "gone":this.gslb.gone,
            "ru":BrowserUtil.url,
            "vlen":int(this.setting.duration),
            "ver":this.versions.mainVersion,
            "up":this.up,
            "trylook":this.isTrylook,
            "ref":BrowserUtil.referer,
            "ch":this.config.typeFrom,
            "ilu":(this.user.isLogin?0:1),
            "yuanxian":this.user.yuanxianinfo
         };
      }
      
      public function getUserInfo() : Object
      {
         var _loc1_:Object = this.user.clone();
         _loc1_["title"] = this.setting.title;
         _loc1_["tryLook"] = this.isTrylook;
         _loc1_["vodUrl"] = this.user.VOD_URL + this.setting.pid;
         return _loc1_;
      }
      
      public function sendStatistics(param1:Object) : void
      {
         if(param1 != null)
         {
            if(param1.hasOwnProperty("mode"))
            {
               this.statistics.sendStat(param1["mode"],param1.type,param1.info);
            }
            else
            {
               this.statistics.sendStat(Stat.LOG_PLAY,param1.type,param1.info);
            }
         }
      }
      
      public function sendDebug(param1:String, param2:Object = null) : void
      {
         if(this.config.flashvars.debugJs)
         {
            this.debug.callJsLog(param1,param2);
         }
      }
   }
}
