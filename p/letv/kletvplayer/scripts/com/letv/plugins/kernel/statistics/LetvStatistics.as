package com.letv.plugins.kernel.statistics
{
   import com.letv.plugins.kernel.model.Model;
   import com.letv.plugins.kernel.controller.Controller;
   import flash.net.SharedObject;
   import com.letv.pluginsAPI.cookieApi.CookieAPI;
   import com.alex.utils.ID;
   import flash.external.ExternalInterface;
   import com.letv.pluginsAPI.stat.Stat;
   import flash.utils.Timer;
   import flash.utils.getTimer;
   import flash.events.TimerEvent;
   import com.alex.utils.SystemUtil;
   import flash.system.Capabilities;
   import com.alex.utils.BrowserUtil;
   import com.letv.plugins.kernel.Kernel;
   import flash.net.sendToURL;
   import flash.net.URLRequest;
   import com.alex.utils.ObjectUtil;
   import flash.utils.clearTimeout;
   import flash.utils.setTimeout;
   import flash.net.URLLoader;
   import flash.events.IOErrorEvent;
   import flash.events.SecurityErrorEvent;
   import flash.events.Event;
   import flash.net.URLLoaderDataFormat;
   import com.irs.IRS;
   
   public class LetvStatistics extends Object
   {
      
      private static var _instance:LetvStatistics;
      
      private var _irs:IRS;
      
      private var _comscoreTimer:int;
      
      private var _ptTimer:Timer;
      
      private var _headTimer:Timer;
      
      private var storage_so:SharedObject;
      
      private var model:Model;
      
      private var controller:Controller;
      
      public var params:LetvParams;
      
      public function LetvStatistics()
      {
         this.params = new LetvParams();
         super();
      }
      
      public static function getInstance() : LetvStatistics
      {
         if(_instance == null)
         {
            _instance = new LetvStatistics();
         }
         return _instance;
      }
      
      public function init(param1:Model, param2:Controller) : void
      {
         this.model = param1;
         this.controller = param2;
      }
      
      public function get lc() : String
      {
         var value:String = null;
         try
         {
            if(this.storage_so == null)
            {
               this.storage_so = SharedObject.getLocal(CookieAPI.COOKIE_STORAGE,"/");
            }
            if(this.storage_so.data.hasOwnProperty("lc"))
            {
               value = this.storage_so.data["lc"];
            }
            if(value == null || value == "")
            {
               value = ID.createGUID();
               this.storage_so.data["lc"] = value;
               this.storage_so.flush();
            }
         }
         catch(e:Error)
         {
         }
         return value;
      }
      
      public function get uuid() : String
      {
         if(this.params.uuid == null)
         {
            this.params.uuid = ID.createGUID();
         }
         if(this.params.gslbcount > 0)
         {
            return this.params.uuid + "_" + this.params.gslbcount;
         }
         return this.params.uuid;
      }
      
      public function get webeventid() : String
      {
         var id:String = null;
         try
         {
            id = ExternalInterface.call("eval","Stats.WEID");
         }
         catch(e:Error)
         {
         }
         if(id == null)
         {
            return "-";
         }
         return id;
      }
      
      public function flushIDInfo(param1:Object) : void
      {
         if(param1 == null || !param1.hasOwnProperty("uuid"))
         {
            return;
         }
         this.params.uuid = param1.uuid;
      }
      
      protected function refreshVV(param1:Boolean = false) : void
      {
         this.pausePtStat();
         this.pauseHeadStat();
         this.params.pt = 0;
         this.params.gslbcount = 0;
         this.params.emptytime = 0;
         if(param1)
         {
            this.params.uuid = null;
            this.model.config.flashvars.autoplay = 1;
            this.sendIRS(Stat.IRS_CLEAR);
         }
      }
      
      protected function refreshDefinition() : void
      {
         this.params.emptytime = 0;
         this.params.gslbcount++;
      }
      
      public function resumePtStat() : void
      {
         if(this._ptTimer == null)
         {
            this._ptTimer = new Timer(200);
         }
         this.params.lastTime = getTimer();
         this._ptTimer.addEventListener(TimerEvent.TIMER,this.onPtTimer);
         this._ptTimer.start();
      }
      
      public function pausePtStat() : void
      {
         if(this._ptTimer != null)
         {
            this._ptTimer.removeEventListener(TimerEvent.TIMER,this.onPtTimer);
            this._ptTimer.stop();
         }
      }
      
      private function onPtTimer(param1:TimerEvent) : void
      {
         var _loc2_:Number = getTimer();
         this.params.pt = this.params.pt + (_loc2_ - this.params.lastTime);
         this.params.lastTime = _loc2_;
      }
      
      protected function resumeHeadStat() : void
      {
         if(this._headTimer == null)
         {
            this._headTimer = new Timer(1000);
         }
         var _loc1_:Number = 15000;
         if(this.model.setting.duration > 300)
         {
            _loc1_ = 180000;
         }
         else if(this.model.setting.duration > 120)
         {
            _loc1_ = 60000;
         }
         else if(this.model.setting.duration > 60)
         {
            _loc1_ = 30000;
         }
         
         
         this._headTimer.delay = _loc1_;
         this._headTimer.addEventListener(TimerEvent.TIMER,this.onHeadTimer);
         this._headTimer.start();
      }
      
      protected function pauseHeadStat() : void
      {
         if(this._headTimer != null)
         {
            this._headTimer.removeEventListener(TimerEvent.TIMER,this.onHeadTimer);
            this._headTimer.stop();
         }
      }
      
      private function onHeadTimer(param1:TimerEvent) : void
      {
         this.sendStat(Stat.LOG_PLAY,Stat.LOG_PLAY_HEAD);
         this.params.pt = 0;
      }
      
      private function sendEnvStat(param1:Object = null) : void
      {
         var url:String = null;
         var value:Object = param1;
         if(LetvParams.sendENVFlag)
         {
            return;
         }
         LetvParams.sendENVFlag = true;
         url = Stat.URL_STAT_ENV;
         try
         {
            url = url + ("?p1=" + this.model.config.flashvars.p1);
            url = url + ("&p2=" + this.model.config.flashvars.p2);
            url = url + ("&p3=" + this.model.config.flashvars.p3);
            url = url + ("&lc=" + this.lc);
            url = url + ("&uuid=" + this.uuid);
            url = url + "&ip=-";
            url = url + "&mac=-";
            url = url + "&nt=-";
            url = url + ("&os=" + SystemUtil.os);
            url = url + "&osv=-";
            url = url + ("&app=" + Capabilities.version);
            url = url + "&bd=-";
            url = url + "&xh=-";
            url = url + ("&ro=" + Capabilities.screenResolutionX + "_" + Capabilities.screenResolutionY);
            url = url + ("&br=" + BrowserUtil.name);
            url = url + ("&r=" + Math.random());
            Kernel.sendLog("[Stat] " + url);
            sendToURL(new URLRequest(url));
         }
         catch(e:Error)
         {
            Kernel.sendLog("[Stat] " + url,"error");
         }
      }
      
      public function sendStat(param1:String, param2:Object = null, param3:Object = null) : void
      {
         switch(param1)
         {
            case Stat.LOG_ENV:
               this.sendEnvStat(param3);
               break;
            case Stat.LOG_PLAY:
               this.sendPlayStat(param2,param3);
               break;
            case Stat.LOG_ACTION:
               this.sendActionStat(param2,param3);
               break;
            case Stat.LOG_COMSCORE:
               this.sendComScore();
               break;
            case Stat.LOG_IRS:
               this.sendIRS(param2,param3);
               break;
            case Stat.OP_REFRESH_VV:
               this.refreshVV(param2);
               break;
            case Stat.OP_REFRESH_DEFINITION:
               this.refreshDefinition();
               break;
            case Stat.OP_RESUME_PT:
               this.resumePtStat();
               break;
            case Stat.OP_PAUSE_PT:
               this.pausePtStat();
               break;
            case Stat.OP_RESUME_HEAD:
               this.resumeHeadStat();
               break;
            case Stat.OP_PAUSE_HEAD:
               this.pauseHeadStat();
               break;
            case Stat.OP_REFRESH_INFO:
               this.flushIDInfo(param3);
               break;
         }
      }
      
      public function sendPlayInitStat(param1:Object = null) : void
      {
         this.sendPlayStat(Stat.LOG_PLAY_INIT,param1);
      }
      
      private function sendPlayStat(param1:Object, param2:Object = null) : void
      {
         var url:String = null;
         var emptyutime:int = 0;
         var pyvalue:Object = null;
         var pyResult:String = null;
         var action:Object = param1;
         var value:Object = param2;
         switch(action)
         {
            case Stat.LOG_PLAY_EMPTY:
               emptyutime = this.params.emptyutime;
               if(emptyutime <= 0)
               {
                  return;
               }
               value = {"utime":emptyutime};
               break;
            case Stat.LOG_PLAY_HEAD:
               this.controller.getP2PInfo();
               break;
         }
         url = Stat.URL_STAT_PLAY;
         try
         {
            url = url + ("?ver=" + Stat.VERSION);
            url = url + ("&ac=" + action);
            if(value != null)
            {
               if(value.hasOwnProperty("error"))
               {
                  url = url + ("&err=" + value["error"]);
               }
               else
               {
                  url = url + "&err=0";
               }
               if(value.hasOwnProperty("utime"))
               {
                  url = url + ("&ut=" + value["utime"]);
               }
               else
               {
                  url = url + "&ut=-";
               }
               if(value.hasOwnProperty("retry"))
               {
                  url = url + ("&ry=" + value["retry"]);
               }
            }
            else
            {
               url = url + "&err=0";
               url = url + "&ut=-";
            }
            url = url + ("&ap=" + this.model.config.flashvars.autoplay);
            url = url + ("&p1=" + this.model.config.flashvars.p1);
            url = url + ("&p2=" + this.model.config.flashvars.p2);
            url = url + ("&p3=" + this.model.config.flashvars.p3);
            url = url + ("&lc=" + this.lc);
            url = url + ("&uid=" + (this.model.user.uid != null?this.model.user.uid:"-"));
            url = url + ("&uuid=" + this.uuid);
            url = url + ("&auid=" + (this.model.config.flashvars.auid || "-"));
            url = url + ("&cid=" + this.model.setting.cid);
            if(this.model.config.flashvars.zid != null)
            {
               url = url + ("&zid=" + this.model.config.flashvars.zid);
            }
            url = url + ("&pid=" + this.model.setting.pid);
            url = url + ("&vid=" + this.model.setting.vid);
            url = url + ("&vlen=" + int(this.model.setting.duration));
            url = url + ("&ch=" + this.model.config.typeFrom);
            url = url + "&ty=0";
            url = url + ("&url=" + encodeURIComponent(BrowserUtil.url));
            url = url + ("&ref=" + encodeURIComponent(BrowserUtil.referer));
            url = url + ("&pv=" + encodeURIComponent(this.model.versions.mainVersion));
            url = url + "&st=-";
            url = url + ("&ilu=" + (this.model.user.isLogin?0:1));
            url = url + "&pcode=-";
            if(this.params.pt > 180000)
            {
               this.params.pt = 180000;
            }
            url = url + ("&pt=" + Math.round(this.params.pt * 0.001));
            url = url + ("&weid=" + this.webeventid);
            if(this.model.currentGslb != null)
            {
               url = url + ("&vt=" + this.model.currentGslb.vtype);
            }
            else
            {
               url = url + "&vt=-";
            }
            if(!(value == null) && (value.hasOwnProperty("py")))
            {
               pyvalue = value["py"];
            }
            else
            {
               pyvalue = {};
            }
            if(action == Stat.LOG_PLAY_GSLB && !(value == null) && (value.hasOwnProperty("ra")))
            {
               pyvalue.ra = value["ra"];
               pyvalue.sra = value["sra"];
            }
            if(action == Stat.LOG_PLAY_INIT)
            {
               pyvalue.adload = this.model.config.flashvars.adload;
            }
            if(action == Stat.LOG_PLAY_DRAG)
            {
               pyvalue.dr = value["dr"];
               url = url + ("&prg=" + int(value["position"]));
            }
            else
            {
               url = url + ("&prg=" + int(this.controller.getVideoTime()));
            }
            if(this.model.trylookState >= 0)
            {
               pyvalue["pay"] = this.model.trylookState;
            }
            if(this.model.config.flashvars.up == "1")
            {
               pyvalue["play"] = "1";
            }
            pyResult = ObjectUtil.objectParseToString(pyvalue);
            url = url + (pyResult == ""?"&py=-":"&py=" + encodeURIComponent(pyResult));
            url = url + ("&r=" + Math.random());
            Kernel.sendLog("[Stat] " + url);
            sendToURL(new URLRequest(url));
         }
         catch(e:Error)
         {
            Kernel.sendLog("[Stat] " + url,"error");
         }
      }
      
      private function sendActionStat(param1:Object = "0", param2:Object = null) : void
      {
         var url:String = null;
         var pyvalue:Object = null;
         var pyResult:String = null;
         var action:Object = param1;
         var value:Object = param2;
         url = Stat.URL_STAT_ACT;
         try
         {
            url = url + ("?ver=" + Stat.VERSION);
            url = url + ("&acode=" + action);
            url = url + ("&p1=" + this.model.config.flashvars.p1);
            url = url + ("&p2=" + this.model.config.flashvars.p2);
            url = url + ("&p3=" + this.model.config.flashvars.p3);
            url = url + ("&lc=" + this.lc);
            url = url + ("&uid=" + (this.model.user.uid != null?this.model.user.uid:"-"));
            url = url + ("&uuid=" + this.uuid);
            url = url + "&auid=-";
            url = url + ("&cid=" + this.model.setting.cid);
            url = url + ("&pid=" + this.model.setting.pid);
            if(this.model.config.flashvars.zid != null)
            {
               url = url + ("&zid=" + this.model.config.flashvars.zid);
            }
            url = url + ("&vid=" + this.model.setting.vid);
            url = url + ("&ch=" + this.model.config.typeFrom);
            url = url + ("&cur_url=" + encodeURIComponent(BrowserUtil.url));
            url = url + ("&ilu=" + (this.model.user.isLogin?0:1));
            url = url + "&pcode=-";
            if(!(value == null) && (value.hasOwnProperty("py")))
            {
               pyvalue = value["py"];
            }
            else
            {
               pyvalue = {};
            }
            pyResult = ObjectUtil.objectParseToString(pyvalue);
            url = url + (pyResult == ""?"&ap=-":"&ap=" + encodeURIComponent(pyResult));
            url = url + ("&r=" + Math.random());
            Kernel.sendLog("[Stat] " + url);
            sendToURL(new URLRequest(url));
         }
         catch(e:Error)
         {
            Kernel.sendLog("[Stat] " + url,"error");
         }
      }
      
      private function sendComScore() : void
      {
         clearTimeout(this._comscoreTimer);
         this._comscoreTimer = setTimeout(this.onComScore,3000);
      }
      
      private function onComScore() : void
      {
         var loader:URLLoader = null;
         var c1:String = "1";
         var c2:String = "8640631";
         var c3:String = this.model.setting.vid;
         var c4:String = this.model.setting.mmsid;
         var c5:String = "";
         var c6:String = this.model.setting.cid;
         var cs_params:String = ["c1=",c1,"&c2=",c2,"&c3=",c3,"&c4=",c4,"&c5=",c5,"&c6=",c6].join("");
         var req:URLRequest = new URLRequest("http://b.scorecardresearch.com/b?" + cs_params);
         try
         {
            loader = new URLLoader();
            loader.addEventListener(IOErrorEvent.IO_ERROR,this.onComScoreCallBack);
            loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.onComScoreCallBack);
            loader.addEventListener(Event.COMPLETE,this.onComScoreCallBack);
            loader.dataFormat = URLLoaderDataFormat.VARIABLES;
            loader.load(req);
         }
         catch(e:Error)
         {
            onComScoreCallBack();
         }
         Kernel.sendLog("[Stat] comScore " + req.url);
      }
      
      private function onComScoreCallBack(param1:Event = null) : void
      {
         var event:Event = param1;
         try
         {
            event.target.close();
         }
         catch(e:Error)
         {
         }
         event.target.removeEventListener(IOErrorEvent.IO_ERROR,this.onComScoreCallBack);
         event.target.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,this.onComScoreCallBack);
         event.target.removeEventListener(Event.COMPLETE,this.onComScoreCallBack);
      }
      
      private function sendIRS(param1:Object, param2:Object = null) : void
      {
         var action:Object = param1;
         var value:Object = param2;
         try
         {
            if(this._irs == null)
            {
               this._irs = new IRS();
               try
               {
                  this._irs._IWT_UAID = BrowserUtil.domain.indexOf("letv") != -1?"UA-letv-100009":"UA-letv-100008";
               }
               catch(e:Error)
               {
                  _irs._IWT_UAID = "UA-letv-100008";
               }
            }
            if(this._irs == null)
            {
               switch(action)
               {
                  case Stat.IRS_START:
                     this._irs.IRS_NewPlay(this.model.setting.vid,int(this.model.setting.duration),true,this.model.config.typeFrom,BrowserUtil.url);
                     break;
                  case Stat.IRS_PLAY:
                  case Stat.IRS_PAUSE:
                  case Stat.IRS_DRAG:
                  case Stat.IRS_END:
                     this._irs.IRS_UserACT(action + "");
                     break;
                  case Stat.IRS_CLEAR:
                     this._irs.IRS_FlashClear();
                     break;
               }
            }
            else
            {
               switch(action)
               {
                  case Stat.IRS_START:
                     this._irs.IRS_NewPlay(this.model.setting.vid,int(this.model.setting.duration),true,this.model.config.typeFrom,BrowserUtil.url);
                     break;
                  case Stat.IRS_PLAY:
                  case Stat.IRS_PAUSE:
                  case Stat.IRS_DRAG:
                  case Stat.IRS_END:
                     this._irs.IRS_UserACT(action + "");
                     break;
                  case Stat.IRS_CLEAR:
                     this._irs.IRS_FlashClear();
                     break;
               }
            }
         }
         catch(e:Error)
         {
            Kernel.sendLog("[Stat] IRS Action: " + action,"error");
         }
      }
   }
}
