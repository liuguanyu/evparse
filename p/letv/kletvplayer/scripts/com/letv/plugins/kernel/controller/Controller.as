package com.letv.plugins.kernel.controller
{
   import com.letv.pluginsAPI.stat.Stat;
   import com.letv.plugins.kernel.Kernel;
   import com.letv.pluginsAPI.kernel.PlayerStateEvent;
   import com.letv.pluginsAPI.api.JsAPI;
   import com.alex.utils.TimeUtil;
   import com.letv.pluginsAPI.kernel.DefinitionType;
   import com.letv.pluginsAPI.kernel.PlayerErrorEvent;
   import com.letv.pluginsAPI.kernel.PlayerError;
   import com.letv.plugins.kernel.controller.auth.AuthController;
   import com.letv.plugins.kernel.controller.auth.pay.LetvPayUseTicket;
   import flash.events.Event;
   import com.letv.plugins.kernel.controller.auth.AuthEvent;
   import com.letv.plugins.kernel.controller.gslb.Gslb;
   import com.letv.plugins.kernel.controller.gslb.GslbEvent;
   import com.letv.plugins.kernel.media.MediaFactory;
   import com.alex.utils.BrowserUtil;
   import com.letv.plugins.kernel.model.Model;
   import com.letv.plugins.kernel.controller.cookie.CookieControl;
   import com.letv.plugins.kernel.interfaces.IMedia;
   
   public class Controller extends Object
   {
      
      public static const SECTION_INIT_ING:uint = 0;
      
      public static const SECTION_INIT_OVER:uint = 1;
      
      public static const SECTION_GSLB:uint = 2;
      
      public static const SECTION_GSLB_ERROR:uint = 3;
      
      public static const SECTION_PLAY:uint = 4;
      
      private var model:Model;
      
      private var auth:AuthController;
      
      private var setCookie:CookieControl;
      
      private var gslb:Gslb;
      
      private var media:IMedia;
      
      private var currentSection:uint = 0;
      
      private var isSmoothMode:Boolean = false;
      
      public function Controller(param1:Model)
      {
         this.setCookie = CookieControl.getInstance();
         super();
         this.model = param1;
         this.setCookie.init(this.model,this);
      }
      
      public function playStart() : void
      {
         this.model.play.swapDefinition = false;
         this.setCookie.setRecordLoop(true,false,true);
         this.setCookie.setRecordVcsLoop(true,false,true);
      }
      
      public function playStop() : void
      {
         this.setCookie.setRecordLoop(false,true);
         this.setCookie.setRecordVcsLoop(false,true);
      }
      
      public function setConfig(param1:XML = null, param2:Object = null, param3:Object = null) : void
      {
         var pccs:XML = param1;
         var flashvars:Object = param2;
         var idinfo:Object = param3;
         this.model.statistics.sendStat(Stat.OP_REFRESH_VV);
         if(idinfo != null)
         {
            this.model.statistics.sendStat(Stat.OP_REFRESH_INFO,null,idinfo);
         }
         try
         {
            this.model.setConfig(pccs,flashvars);
            this.model.statistics.sendStat(Stat.LOG_ENV);
            Kernel.sendLog("Kernel.setConfig");
         }
         catch(e:Error)
         {
            Kernel.sendLog("Kernel.setConfig Invalid","fault");
         }
      }
      
      public function setAuth() : void
      {
         Kernel.sendLog("Kernel.setAuth");
         this.startAuth({"vid":this.model.setting.vid},true);
      }
      
      public function playNext(param1:Boolean = false, param2:Boolean = false) : Boolean
      {
         var callback:Object = null;
         var fromEnd:Boolean = param1;
         var active:Boolean = param2;
         try
         {
            if(fromEnd)
            {
               Kernel.sendLog("Kernel PlayerContinue Auto PlayNext");
               if(!this.tryToPlayPreload())
               {
                  this.closeVideo();
                  this.startAuth({"vid":this.model.setting.nextvid},true);
                  this.model.playerState = PlayerStateEvent.PLAYER_NEXT;
               }
               return true;
            }
            callback = this.model.sendInterface(JsAPI.PLAYER_PLAY_NEXT,active);
            if(callback["status"] == "recommend")
            {
               this.closeVideo();
               this.model.playerState = PlayerStateEvent.PLAYER_STOP;
               return true;
            }
            if((this.model.hadNextData) && !(callback["status"] == "pageContinue") && !this.tryToPlayPreload())
            {
               Kernel.sendLog("Kernel PlayerContinue Force PlayNext");
               this.closeVideo();
               this.model.playerState = PlayerStateEvent.PLAYER_NEXT;
               this.startAuth({"vid":this.model.setting.nextvid},true);
               return true;
            }
         }
         catch(e:Error)
         {
            Kernel.sendLog("Kernel PlayerContinue Invalid","fault");
         }
         return false;
      }
      
      public function loadAndPlay(param1:Boolean = true, param2:String = null) : void
      {
         this.model.play.swapDefinition = false;
         if(param2 == null)
         {
            this.model.setting.autoPlay = param1;
            Kernel.sendLog("Kernel.loadAndPlay AutoPlay " + param1);
            if(this.model.preloadData.playPreload)
            {
               if(param1)
               {
                  this.gslb.setPreloadData();
                  this.onGslbSuccess();
               }
               else
               {
                  return;
               }
            }
            else
            {
               this.closeVideo();
               this.initGslb();
            }
         }
         else
         {
            this.model.setting.vid = param2;
            this.model.setting.autoPlay = true;
            if(param2 == this.model.setting.nextvid && (this.tryToPlayPreload()))
            {
               Kernel.sendLog("Kernel.loadAndPlay NewID " + param2 + "--preload","info");
               this.model.playerState = [PlayerStateEvent.PLAYER_NEXT,true];
            }
            else
            {
               this.closeVideo();
               Kernel.sendLog("Kernel.loadAndPlay NewID " + param2,"info");
               this.startAuth({"vid":this.model.setting.vid},true);
               this.model.playerState = PlayerStateEvent.PLAYER_NEXT;
            }
         }
      }
      
      public function seekTo(param1:Number) : void
      {
         var dr:String = null;
         var position:Number = param1;
         try
         {
            dr = TimeUtil.swap(this.getVideoTime()) + "_" + TimeUtil.swap(position);
            this.setCookie.setRecordLoop(true,false,false,position);
            this.setCookie.setRecordVcsLoop(true,false,false,position);
            this.model.statistics.sendStat(Stat.LOG_IRS,Stat.IRS_DRAG);
            this.model.statistics.sendStat(Stat.LOG_PLAY,Stat.LOG_PLAY_DRAG,{
               "ac":Stat.LOG_PLAY_DRAG,
               "dr":dr,
               "position":position
            });
            this.model.sendInterface(JsAPI.PLAYER_SEEK,{
               "id":this.model.setting.vid,
               "time":position
            });
            this.media.seekTo(position);
         }
         catch(e:Error)
         {
            Kernel.sendLog("Kernel.seekTo Invalid","warn");
         }
      }
      
      public function setDefinition(param1:String = null, param2:String = null, param3:Boolean = false, param4:Boolean = false, param5:Boolean = false) : Boolean
      {
         var transferType:String = null;
         var type:String = param1;
         var nodeID:String = param2;
         var smooth:Boolean = param3;
         var second:Boolean = param4;
         var changeNode:Boolean = param5;
         try
         {
            Kernel.sendLog("Kernel.SetDefinition Type: " + type + " nodeID: " + nodeID);
            this.model.play.swapDefinition = true;
            this.model.setting.upDefinition = this.model.setting.definition;
            if(type != null)
            {
               this.model.gslb.nodeID = null;
               transferType = type == DefinitionType.AUTO?this.setCookie.getAutoDefinition():type;
               if(this.model.gslb.gslblist.hasOwnProperty(transferType))
               {
                  this.model.setting.defaultDefinition = type;
                  this.setCookie.recordDefinition();
                  if(!(transferType == this.model.setting.definition) || (second))
                  {
                     this.model.setting.definition = transferType;
                     this.setCookie.setRecordLoop(false);
                     this.setCookie.setRecordVcsLoop(false);
                  }
                  else
                  {
                     return false;
                  }
               }
               else
               {
                  return false;
               }
            }
            else if(nodeID != null)
            {
               this.model.gslb.nodeID = nodeID;
            }
            else
            {
               this.model.gslb.nodeID = null;
            }
            
            this.isSmoothMode = smooth;
            if(!this.isSmoothMode)
            {
               this.closeVideo(false);
            }
            this.model.setting.setDefinitionRecordTime = this.model.setting.beforeCloseTime;
            this.setCookie.readData(type?false:true);
            if(!changeNode)
            {
               this.model.playerState = PlayerStateEvent.PLAYER_DEFINITION;
            }
            this.model.statistics.sendStat(Stat.OP_REFRESH_DEFINITION);
            if(this.model.preloadData.preload)
            {
               this.media.clearPreloadData();
            }
            this.initGslb();
            return true;
         }
         catch(e:Error)
         {
            Kernel.sendLog("Kernel.SetDefinition Invalid","warn");
         }
         return false;
      }
      
      public function jumpVideo(param1:int = 0) : void
      {
         Kernel.sendLog("Kernel.jumpVideo " + param1);
         if(this.model.config.jump)
         {
            this.media.jumpVideo(param1);
         }
         else
         {
            this.seekTo(param1 == 0?this.model.vrs.headTime:this.model.vrs.tailTime);
         }
      }
      
      public function closeVideo(param1:Boolean = true) : void
      {
         var time:Number = NaN;
         var clearEffect:Boolean = param1;
         try
         {
            if(this.auth != null)
            {
               this.auth.destroy();
            }
            this.gslbGc();
            this.setCookie.setRecordLoop(false);
            this.setCookie.setRecordVcsLoop(false);
            time = this.media.getVideoTime();
            if(time > 0)
            {
               this.model.setting.beforeCloseTime = time;
            }
            this.media.closeVideo(clearEffect);
            Kernel.sendLog("Kernel.closeVideo " + clearEffect + " BeforeCloseTime: " + this.model.setting.beforeCloseTime);
         }
         catch(e:Error)
         {
            Kernel.sendLog("Kernel.closeVideo Invalid","warn");
         }
      }
      
      public function replayVideo() : void
      {
         try
         {
            this.media.replayVideo();
            Kernel.sendLog("Kernel.replayVideo");
         }
         catch(e:Error)
         {
            Kernel.sendLog("Kernel.replayVideo Invalid","warn");
         }
      }
      
      public function toggleVideo() : void
      {
         try
         {
            this.media.toggleVideo();
            Kernel.sendLog("Kernel.toggleVideo");
         }
         catch(e:Error)
         {
            Kernel.sendLog("Kernel.toggleVideo Invalid","warn");
         }
      }
      
      public function pauseVideo() : void
      {
         try
         {
            this.media.pauseVideo();
            Kernel.sendLog("Kernel.pauseVideo");
            this.setCookie.setRecordLoop(false);
            this.setCookie.setRecordVcsLoop(false);
         }
         catch(e:Error)
         {
            Kernel.sendLog("Kernel.pauseVideo Invalid","warn");
         }
      }
      
      public function resumeVideo() : void
      {
         var ev:PlayerErrorEvent = null;
         var evt:PlayerErrorEvent = null;
         try
         {
            Kernel.sendLog("Kernel.resumeVideo Section:" + this.currentSection);
            if(this.model.preloadData.playPreload)
            {
               this.model.setting.autoPlay = true;
               this.currentSection = SECTION_PLAY;
               this.gslb.setPreloadData();
               this.onGslbSuccess();
               return;
            }
            if(this.currentSection == SECTION_INIT_ING)
            {
               this.model.setting.autoPlay = true;
            }
            else if(this.currentSection == SECTION_INIT_OVER)
            {
               this.model.setting.autoPlay = true;
               this.initGslb();
            }
            else if(this.currentSection == SECTION_GSLB)
            {
               this.model.setting.autoPlay = true;
            }
            else if(this.currentSection == SECTION_GSLB_ERROR)
            {
               this.model.setting.autoPlay = true;
               ev = new PlayerErrorEvent(PlayerErrorEvent.PLAYER_ERROR);
               ev.errorCode = this.model.setting.playerErrorCode;
               this.model.dispatchEvent(ev);
            }
            else if(!(this.media == null) && this.currentSection == SECTION_PLAY)
            {
               this.media.resumeVideo();
               this.setCookie.setRecordLoop(true);
               this.setCookie.setRecordVcsLoop(true);
            }
            else
            {
               evt = new PlayerErrorEvent(PlayerErrorEvent.PLAYER_ERROR);
               evt.errorCode = this.model.setting.playerErrorCode != null?this.model.setting.playerErrorCode:PlayerError.GSLB_OTHER_ERROR;
               this.model.dispatchEvent(evt);
            }
            
            
            
            
         }
         catch(e:Error)
         {
            Kernel.sendLog("Kernel.resumeVideo Invalid " + e.message,"warn");
         }
      }
      
      public function mute(param1:Boolean = true) : void
      {
         var flag:Boolean = param1;
         try
         {
            if(flag)
            {
               this.model.setting.muteBeforeVolume = this.model.volume;
               this.model.setting.volume = 0;
               this.media.setVolume(0);
            }
            else
            {
               this.model.setting.volume = this.model.setting.muteBeforeVolume;
               this.media.setVolume(this.model.setting.muteBeforeVolume);
            }
         }
         catch(e:Error)
         {
            Kernel.sendLog("Kernel.mute Invalid","warn");
         }
      }
      
      public function setVolume(param1:Number) : void
      {
         var value:Number = param1;
         try
         {
            this.model.volume = value;
            this.setCookie.recordVolume(value);
            this.media.setVolume(value);
         }
         catch(e:Error)
         {
            Kernel.sendLog("Kernel.setVolume Invalid","warn");
         }
      }
      
      public function setJump(param1:Boolean = true) : void
      {
         var flag:Boolean = param1;
         try
         {
            this.model.setting.jump = flag;
            this.setCookie.recordJump();
            if(flag)
            {
               this.media.jumpVideo();
            }
         }
         catch(e:Error)
         {
            Kernel.sendLog("Kernel.setJump Invalid","warn");
         }
      }
      
      public function getVideoTime() : Number
      {
         if(this.media)
         {
            return this.media.getVideoTime();
         }
         return 0;
      }
      
      public function getPlayState() : Object
      {
         if(this.media)
         {
            return this.media.getPlayState();
         }
         return {};
      }
      
      public function getFPS() : int
      {
         if(this.media)
         {
            return this.media.getFPS();
         }
         return 0;
      }
      
      public function getLoadPercent() : Number
      {
         if(this.media)
         {
            return this.media.getLoadPercent();
         }
         return 0;
      }
      
      public function getBufferPercent() : Number
      {
         if(this.media != null)
         {
            return this.media.getBufferPercent();
         }
         return 0;
      }
      
      public function getP2PInfo() : Object
      {
         if(this.media)
         {
            return this.media.p2pInfo;
         }
         return null;
      }
      
      public function getSectionInfo() : String
      {
         if(this.media)
         {
            return this.media.sectionInfo;
         }
         return "";
      }
      
      public function get bufferDataSize() : Number
      {
         if(this.media)
         {
            return this.media.bufferDataSize;
         }
         return 0;
      }
      
      public function get bufferTime() : Number
      {
         if(this.media)
         {
            return this.media.bufferTime;
         }
         return 0;
      }
      
      public function get currentUrl() : String
      {
         try
         {
            return this.media.currentUrl;
         }
         catch(e:Error)
         {
         }
         return null;
      }
      
      public function get currentNode() : String
      {
         try
         {
            return this.media.currentNode;
         }
         catch(e:Error)
         {
         }
         return null;
      }
      
      public function setVIP() : void
      {
         if(this.auth == null)
         {
            this.auth = new AuthController(this.model);
         }
         this.auth.checkVip();
      }
      
      public function setUsePayTicket(param1:Function, param2:Function) : void
      {
         var _loc3_:LetvPayUseTicket = LetvPayUseTicket.getInstance();
         _loc3_.addEventListener(Event.COMPLETE,this.onUsePayTicketSuccess);
         _loc3_.useTicket(this.model.user.payURL,param1,param2);
      }
      
      public function startAuth(param1:Object, param2:Boolean = false) : void
      {
         if(!this.model.preloadData.preload)
         {
            this.model.statistics.sendStat(Stat.OP_REFRESH_VV,param2);
            this.closeVideo();
            this.currentSection = SECTION_INIT_ING;
         }
         if(this.auth == null)
         {
            this.auth = new AuthController(this.model);
         }
         this.auth.addEventListener(AuthEvent.AUTH_VALID,this.onAuthValid);
         this.auth.addEventListener(AuthEvent.AUTH_INVALID,this.onAuthInvalid);
         this.auth.start(param1);
      }
      
      private function onAuthValid(param1:AuthEvent = null) : void
      {
         Kernel.sendLog("Kernel.onAuthValid");
         if((this.model.preloadData.preload) && !(param1 == null))
         {
            this.initGslb();
         }
         else
         {
            this.currentSection = SECTION_INIT_OVER;
            this.model.cookieControl.readData();
            this.model.sendInterface(JsAPI.PLAYER_INIT,{"id":this.model.setting.vid});
            this.model.statistics.sendPlayInitStat();
            this.model.dispatchEvent(new PlayerStateEvent(PlayerStateEvent.USER_AUTH_VALID));
         }
      }
      
      private function onAuthInvalid(param1:AuthEvent = null) : void
      {
         Kernel.sendLog("Kernel.onAuthInvalid","warn");
         if(this.model.preloadData.preload)
         {
            this.model.preloadData.gc(true);
            return;
         }
         this.closeVideo(false);
         var _loc2_:PlayerErrorEvent = new PlayerErrorEvent(PlayerErrorEvent.PLAYER_ERROR);
         _loc2_.errorCode = param1.errorCode;
         this.model.statistics.sendPlayInitStat({"error":param1.errorCode});
         this.model.dispatchEvent(_loc2_);
      }
      
      private function initGslb() : void
      {
         var _loc1_:String = null;
         this.gslbGc();
         if(this.gslb == null)
         {
            this.gslb = new Gslb(this.model);
         }
         this.gslb.addEventListener(GslbEvent.LOAD_FAILED,this.onGslbFailed);
         this.gslb.addEventListener(GslbEvent.LOAD_SUCCESS,this.onGslbSuccess);
         if(this.model.preloadData.preload)
         {
            _loc1_ = this.model.cookieControl.preloadDefinition();
            if(_loc1_ != this.model.preloadData.currentDefinition)
            {
               if(this.model.preloadData.currentDefinition == "")
               {
                  this.model.preloadData.clearGslb();
                  this.model.preloadData.preload = true;
               }
               this.model.preloadData.currentDefinition = _loc1_;
               this.gslb.load(_loc1_,this.model.preloadData.preloadData.playData.list,false);
            }
         }
         else
         {
            this.model.setting.playerErrorCode = null;
            this.model.setting.playerErrorTime = -1;
            this.currentSection = SECTION_GSLB;
            this.gslb.load(this.model.setting.definition,this.model.gslb.gslblist);
         }
      }
      
      private function onGslbFailed(param1:GslbEvent) : void
      {
         var _loc2_:PlayerErrorEvent = null;
         if(this.model.preloadData.preload)
         {
            this.model.preloadData.gc(true);
            return;
         }
         this.currentSection = SECTION_GSLB_ERROR;
         this.closeVideo(false);
         this.model.setting.playerErrorCode = param1.errorCode;
         Kernel.sendLog("Kernel.onGslbFailed ErrorCode: " + param1.errorCode + " AutoPlay: " + this.model.setting.autoPlay);
         if(this.model.setting.autoPlay)
         {
            _loc2_ = new PlayerErrorEvent(PlayerErrorEvent.PLAYER_ERROR);
            _loc2_.errorCode = param1.errorCode;
            this.model.dispatchEvent(_loc2_);
         }
      }
      
      private function onGslbSuccess(param1:GslbEvent = null) : void
      {
         var _loc2_:PlayerStateEvent = null;
         this.gslbGc();
         if((this.model.preloadData.preload) && !this.model.preloadData.playPreload)
         {
            this.media.startPreload();
            _loc2_ = new PlayerStateEvent(PlayerStateEvent.START_PRELOAD_AD,this.model.preloadData.stopTime);
            this.model.dispatchEvent(_loc2_);
         }
         else
         {
            this.model.playerState = PlayerStateEvent.GSLB_SUCCESS;
            this.currentSection = SECTION_PLAY;
            if(this.media == null || !this.media.streamValid)
            {
               this.media = MediaFactory.create(this.model);
            }
            this.media.init(this.model,this.isSmoothMode);
            this.isSmoothMode = false;
         }
      }
      
      private function gslbGc() : void
      {
         if(this.gslb != null)
         {
            this.gslb.destroy();
            this.gslb.removeEventListener(GslbEvent.LOAD_FAILED,this.onGslbFailed);
            this.gslb.removeEventListener(GslbEvent.LOAD_SUCCESS,this.onGslbSuccess);
         }
      }
      
      private function onUsePayTicketSuccess(param1:Event) : void
      {
         this.model.playNormalFromTry();
         this.model.playerState = PlayerStateEvent.PLAYER_NEXT;
         this.model.sendInterface(JsAPI.HIDE_PAY_PANEL);
         this.setDefinition(null,null);
      }
      
      public function changeMode(param1:Boolean) : void
      {
         this.media = MediaFactory.create(this.model,param1);
         this.media.init(this.model);
      }
      
      public function getDownloadSpeed() : int
      {
         if(this.media != null)
         {
            return this.media.getDownloadSpeed;
         }
         return 0;
      }
      
      public function onPreload() : void
      {
         this.model.preloadData.preload = true;
         this.model.preloadData.playPreload = false;
         this.model.preloadData.preloadData = null;
         if(this.model.setting.nextvid == null || this.model.setting.nextvid == "0")
         {
            Kernel.sendLog(this + "PreloadFail:nextvid=null");
            this.onAuthInvalid();
         }
         else
         {
            this.startAuth({"vid":this.model.setting.nextvid},true);
         }
      }
      
      public function onPlayPreload() : void
      {
         this.model.preloadData.playPreload = true;
         this.model.statistics.sendStat(Stat.OP_REFRESH_VV,true);
         this.model.setSetting(this.model.preloadData.preloadData);
         this.model.gslb.gslblist = this.model.preloadData.preloadData.playData.list;
         this.onAuthValid();
      }
      
      public function adPreloadComplete() : void
      {
         this.model.preloadData.adPreloadComplete = true;
      }
      
      public function getAdPreloadData() : Object
      {
         var obj:Object = {};
         try
         {
            obj["vid"] = this.model.preloadData.preloadData.playData.vid;
            obj["mmsid"] = this.model.preloadData.preloadData.playData.mmsid;
            obj["pid"] = this.model.preloadData.preloadData.playData.pid;
            obj["cid"] = this.model.preloadData.preloadData.playData.cid;
            obj["uuid"] = this.model.statistics.uuid;
            obj["uid"] = this.model.user.uid;
            obj["isvip"] = this.model.user.isVip;
            obj["isplatvip"] = this.model.user.yuanxianinfo.isplatvip || null;
            obj["trylook"] = this.model.preloadData.preloadData.trylook;
            obj["ru"] = BrowserUtil.url;
            obj["ref"] = BrowserUtil.referer;
            obj["url"] = this.model.setting.url;
            obj["video_duration"] = this.model.preloadData.preloadData.playData.duration;
         }
         catch(e:Error)
         {
         }
         return obj;
      }
      
      private function tryToPlayPreload() : Boolean
      {
         if(this.model.preloadData.preloadComplete)
         {
            this.onPlayPreload();
            return true;
         }
         return false;
      }
   }
}
