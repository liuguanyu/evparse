package cn.pplive.player.view
{
   import org.puremvc.as3.multicore.utilities.fabrication.patterns.mediator.FlashMediator;
   import flash.display.Stage;
   import flash.display.MovieClip;
   import cn.pplive.player.view.ui.AdvBlock;
   import flash.events.Event;
   import cn.pplive.player.common.*;
   import cn.pplive.player.utils.*;
   import cn.pplive.player.dac.*;
   import cn.pplive.player.manager.*;
   import cn.pplive.player.utils.hash.Global;
   import org.puremvc.as3.multicore.interfaces.INotification;
   import flash.ui.ContextMenu;
   import cn.pplive.player.view.source.CTXQuery;
   import flash.ui.ContextMenuItem;
   import cn.pplive.player.events.PPLiveEvent;
   
   public class AdverMediator extends FlashMediator
   {
      
      public static const NAME:String = "adver_mediator";
      
      private var $content = null;
      
      private var _isCorner:Boolean = true;
      
      private var _isInsertAfping:Boolean = false;
      
      private var $tempContent:AdvBlock = null;
      
      private var $adTotalTime:Number = NaN;
      
      public function AdverMediator(param1:String = null, param2:Object = null)
      {
         super(param1,param2);
      }
      
      public function get stage() : Stage
      {
         return this.view.stage;
      }
      
      public function get view() : MovieClip
      {
         return viewComponent as MovieClip;
      }
      
      override public function onRegister() : void
      {
         this.$tempContent = new AdvBlock();
         this.view.addChild(this.$tempContent);
         this.$tempContent.visible = false;
         this.$tempContent.addEventListener("remove_barriers",function(param1:Event):void
         {
            VodCommon.isPatch = false;
            $tempContent.visible = false;
            sendNotification(VodNotification.VOD_PLAY);
         });
      }
      
      public function skipAdver() : void
      {
         if(VIPPrivilege.isNoad)
         {
            PrintDebug.Trace("vip用户免除广告请求或删除所有广告 ===>>>");
            if(this.$tempContent)
            {
               this.$tempContent.DelAFP();
            }
            if(this.$content)
            {
               this._isCorner = false;
               this.$content.DelAFP();
            }
            if(Global.getInstance()["clickSource"] == "4")
            {
               ViewManager.getInstance().getMediator("skin")["changeRtmp"]();
            }
         }
      }
      
      public function respondToVodAdverFailed(param1:INotification) : void
      {
         PrintDebug.Trace("广告插件 plugin 载入失败 ===>>>");
         if(param1.getBody() == "_ioerror_" || param1.getBody() == "_securityerror_")
         {
            if(!VIPPrivilege.isNoad)
            {
               VodCommon.isPatch = true;
               this.view.setChildIndex(this.$tempContent,this.view.numChildren - 1);
               try
               {
                  this.view.addChild(this.view["controlMc"]);
               }
               catch(evt:Error)
               {
               }
               this.$tempContent.visible = true;
               this.$tempContent.AddAFP();
            }
         }
         else
         {
            sendNotification(VodNotification.VOD_PLAY);
         }
      }
      
      public function respondToVodAdverSuccess(param1:INotification) : void
      {
         var _loc3_:ContextMenu = null;
         if(this.$tempContent)
         {
            this.view.removeChild(this.$tempContent);
            this.$tempContent = null;
         }
         this.$content = param1.getBody();
         this.view.addChild(this.$content);
         try
         {
            this.view.addChild(this.view["controlMc"]);
         }
         catch(evt:Error)
         {
         }
         try
         {
            this.$content["setTips"] = ViewManager.getInstance().getMediator("skin").setTips;
         }
         catch(evt:Error)
         {
         }
         this.$content.addEventListener("ikan_play",this.onPluginHandler);
         this.$content.addEventListener("ikan_error",this.onPluginHandler);
         this.$content.addEventListener("ikan_stop",this.onPluginHandler);
         this.$content.addEventListener("ikan_resume",this.onPluginHandler);
         this.$content.addEventListener("ikan_pause",this.onPluginHandler);
         this.$content.addEventListener("ikan_vip",this.onPluginHandler);
         this.$content.addEventListener("ikan_resize",this.onPluginHandler);
         this.$content.addEventListener("prog_lock",this.onPluginHandler);
         this.$content.addEventListener("prog_unlock",this.onPluginHandler);
         this.$content.addEventListener("ikan_onNotification",this.onPluginHandler);
         this.$content.addEventListener("ikan_ad_status",this.onPluginHandler);
         this.$content.addEventListener("ikan_third",this.onPluginHandler);
         this.$content.addEventListener("ikan_vip",this.onPluginHandler);
         this.$content.addEventListener("ikan_beforepacth_start",this.onPluginHandler);
         PrintDebug.Trace("广告插件 plugin 载入成功 ===>>>");
         if(!isNaN(VodPlay.duration))
         {
            this.$content["videoTimeInfo"] = {
               "videoTimeTotal":VodPlay.duration,
               "triggerPoints":[]
            };
         }
         if(VodParser.am)
         {
            this.$content.adVolume = 0;
         }
         var _loc2_:String = VodParser.ctx + "&sa=" + VodParser.sa + "&isVip=" + Number(VIPPrivilege.isVip) + (CTXQuery.actx != ""?"&":"") + CTXQuery.actx + (VodCommon.cookie.contains("rlen")?"&rlen=" + VodCommon.cookie.getData("rlen"):"");
         PrintDebug.Trace("传递给广告插件的 CTX ===>>> " + _loc2_);
         this.$content.ctx = encodeURIComponent(_loc2_);
         this.$content.advars = VodParser.advars;
         this.$content.InitAFP(VodParser.cid,VodParser.clid,1,1,VodParser.ads,VodCommon.playerWidth,VodCommon.playerHeight);
         this.$content.sid = VodParser.cid;
         sendNotification(VodNotification.VOD_BEFORE_PATCH);
         if(Global.getInstance()["root"])
         {
            _loc3_ = Global.getInstance()["root"].contextMenu;
            _loc3_.customItems.push(new ContextMenuItem("Build plugin " + this.$content["getVersion"]()));
            Global.getInstance()["root"].contextMenu = _loc3_;
         }
      }
      
      private function onPluginHandler(param1:Event) : void
      {
         var _loc2_:Object = null;
         PrintDebug.Trace("监听广告抛出事件  ===>>>  ",param1.type);
         switch(param1.type)
         {
            case "ikan_play":
            case "ikan_error":
               VodCommon.isPatch = false;
               sendNotification(VodNotification.VOD_PLAY);
               if(!VIPPrivilege.isNoad && (this._isCorner))
               {
                  this.$content.AddAFP("4");
               }
               PrintDebug.Trace("开始请求角标广告");
               InteractiveManager.sendEvent(PPLiveEvent.VOD_ONADEVENT,{"event":"finish"});
               break;
            case "ikan_stop":
               ViewManager.getInstance().getProxy("recom").initData();
               break;
            case "ikan_ad_status":
               sendNotification(DACNotification.ACTION,this.$content.Status,DACCommon.ADERR);
               break;
            case "ikan_third":
               InteractiveManager.sendEvent(PPLiveEvent.VOD_ONADEVENT,this.$content.thirdObj);
               break;
            case "ikan_vip":
               InteractiveManager.sendEvent(PPLiveEvent.VOD_ONVIP_VALIDATE,"1");
               break;
            case "ikan_beforepacth_start":
               try
               {
                  this.$adTotalTime = this.$content.adTotalTime;
                  PrintDebug.Trace("获取到前帖广告总时间 ===>>>  ",this.$adTotalTime);
                  Global.getInstance()["player"].advertisementTime = this.$adTotalTime;
               }
               catch(evt:Error)
               {
               }
               break;
            case "ikan_pause":
               this._isInsertAfping = true;
               try
               {
                  Global.getInstance()["pauseVideo"]();
               }
               catch(evt:Error)
               {
               }
               break;
            case "ikan_resume":
               this._isInsertAfping = false;
               try
               {
                  Global.getInstance()["playVideo"]();
               }
               catch(evt:Error)
               {
               }
               break;
            case "ikan_onNotification":
               try
               {
                  _loc2_ = this.$content.onNotification;
                  if((_loc2_) && (_loc2_.hasOwnProperty("type")))
                  {
                     switch(_loc2_.type)
                     {
                        case "waterMark":
                           PrintDebug.Trace("监听广告抛出水印事件事件  ===>>>  ",_loc2_);
                           VodParser.markAdv = _loc2_["data"]["url"];
                           ViewManager.getInstance().getProxy("markadv").initData();
                           break;
                        default:
                           InteractiveManager.sendEvent(PPLiveEvent.VOD_ONNOTIFICATION,{
                              "header":{"type":_loc2_.type},
                              "body":{"data":_loc2_.data}
                           });
                     }
                  }
               }
               catch(err:Error)
               {
               }
               break;
            case "prog_lock":
               sendNotification(VodNotification.VOD_SETPROGRESS,false);
               break;
            case "prog_unlock":
               sendNotification(VodNotification.VOD_SETPROGRESS,true);
               break;
         }
      }
      
      public function get adTotalTime() : *
      {
         return this.$adTotalTime;
      }
      
      public function respondToVodAfterPatch(param1:INotification) : void
      {
         if((this.$content) && (!VIPPrivilege.isNoad) && !VodPlay.isFd)
         {
            PrintDebug.Trace("开始请求后帖广告");
            this.$content.AddAFP("2");
         }
         else
         {
            ViewManager.getInstance().getProxy("recom").initData();
         }
      }
      
      public function respondToVodBeforePatch(param1:INotification) : void
      {
         this._isCorner = true;
         if((this.$content) && !VIPPrivilege.isNoad)
         {
            this.$content.vvid = DACReport.vvid;
            VodCommon.isPatch = true;
            PrintDebug.Trace("开始请求前帖广告");
            this.$content.AddAFP("1_6_7");
            InteractiveManager.sendEvent(PPLiveEvent.VOD_ONADEVENT,{
               "event":"hasad",
               "aid":"300001"
            });
            try
            {
               if(!isNaN(this.$content.adVolume))
               {
                  ViewManager.getInstance().getMediator("skin").skin.setSound(this.$content.adVolume);
               }
            }
            catch(evt:Error)
            {
            }
         }
         if((this.$content) && !VIPPrivilege.isNoad)
         {
            return;
         }
      }
      
      public function respondToVodAdverVisible(param1:INotification) : void
      {
         var _loc2_:Object = null;
         try
         {
            _loc2_ = param1.getBody();
            this.$content.adHandle(_loc2_["pos"])["visible"] = _loc2_["visible"];
         }
         catch(evt:Error)
         {
         }
      }
      
      public function respondToVodPausePatch(param1:INotification) : void
      {
         if((this.$content) && !VIPPrivilege.isNoad)
         {
            this.$content.playState = !param1.getBody();
            _loc2_[param1.getBody()?"AddAFP":"DelAFP"]("3");
            PrintDebug.Trace("开始 " + (param1.getBody()?"请求":"删除") + " 暂停广告 ===>>>");
         }
      }
      
      public function respondToVodClearAdver(param1:INotification) : void
      {
         this._isCorner = false;
         try
         {
            this.$content.DelAFP();
            PrintDebug.Trace("清除所有广告响应 ===>>>");
            this.$content.InitAFP(VodParser.cid,VodParser.clid,1,1,VodParser.ads,VodCommon.playerWidth,VodCommon.playerHeight);
         }
         catch(evt:Error)
         {
         }
      }
      
      public function respondToVodAdverSmartClick(param1:INotification) : void
      {
         if(this.$content)
         {
            this.$content.smartClick(param1.getBody());
         }
      }
      
      public function respondToVodAdsGetVideo(param1:INotification) : void
      {
         try
         {
            if(this.$content)
            {
               this.$content.videoItself = param1.getBody()["video"];
               this.$content.playInfo = param1.getBody()["xml"];
            }
         }
         catch(evt:Error)
         {
         }
      }
      
      public function setSize(param1:Number, param2:Number) : void
      {
         if(this.$content)
         {
            this.$content.setSize(param1,param2);
         }
         if(this.$tempContent)
         {
            this.$tempContent.setSize(param1,param2);
         }
      }
      
      public function DelAFP() : void
      {
         if(this.$content)
         {
            this.$content.DelAFP();
         }
         if(this.$tempContent)
         {
            this.$tempContent.DelAFP();
         }
         PrintDebug.Trace("清除所有广告 ===>>>");
      }
      
      public function InsertAFP(param1:Object) : void
      {
         try
         {
            if((this.$content) && !VIPPrivilege.isNoad)
            {
               this.$content["InsertAFP"](param1);
            }
         }
         catch(evt:Error)
         {
         }
      }
      
      public function get content() : *
      {
         return this.$content;
      }
      
      public function get tempContent() : *
      {
         return this.$tempContent;
      }
   }
}
