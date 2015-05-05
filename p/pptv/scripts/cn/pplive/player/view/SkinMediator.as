package cn.pplive.player.view
{
   import org.puremvc.as3.multicore.utilities.fabrication.patterns.mediator.FlashMediator;
   import flash.display.Sprite;
   import flash.display.MovieClip;
   import cn.pplive.player.utils.loader.DisplayLoader;
   import flash.display.Stage;
   import pptv.skin.view.components.VodSkin;
   import flash.events.FullScreenEvent;
   import cn.pplive.player.manager.InteractiveManager;
   import cn.pplive.player.events.PPLiveEvent;
   import flash.ui.Mouse;
   import cn.pplive.player.dac.DACNotification;
   import cn.pplive.player.dac.DACCommon;
   import pptv.skin.view.events.SkinEvent;
   import cn.pplive.player.utils.hash.Global;
   import org.puremvc.as3.multicore.interfaces.INotification;
   import flash.text.TextField;
   import flash.text.TextFieldType;
   import flash.ui.Keyboard;
   import cn.pplive.player.common.VodParser;
   import cn.pplive.player.manager.ViewManager;
   import cn.pplive.player.common.VodPlay;
   import cn.pplive.player.common.VodCommon;
   import cn.pplive.player.utils.CommonUtils;
   import flash.utils.clearInterval;
   import cn.pplive.player.common.VodNotification;
   import cn.pplive.player.utils.PrintDebug;
   import flash.utils.clearTimeout;
   import cn.pplive.player.utils.Utils;
   import flash.events.Event;
   import cn.pplive.player.view.source.CTXQuery;
   import cn.pplive.player.common.VIPPrivilege;
   import cn.pplive.player.dac.DACQueue;
   import cn.pplive.player.dac.DACReport;
   import flash.utils.setTimeout;
   import cn.pplive.player.view.ui.CountdownBlock;
   import cn.pplive.player.utils.ColorMatrix;
   import flash.filters.ColorMatrixFilter;
   import pptv.skin.view.ui.AccelerateUI;
   import cn.pplive.player.view.components.VodP2PPlayer;
   import cn.pplive.player.view.components.LiveP2PPlayer;
   import flash.events.MouseEvent;
   import cn.pplive.player.view.events.StreamEvent;
   import flash.utils.setInterval;
   import flash.utils.getTimer;
   import cn.pplive.player.view.ui.RecommendBox;
   import cn.pplive.player.common.RecommendItem;
   import flash.display.DisplayObject;
   import flash.geom.Rectangle;
   import flash.ui.ContextMenu;
   import flash.ui.ContextMenuItem;
   
   public class SkinMediator extends FlashMediator
   {
      
      public static const NAME:String = "skin_mediator";
      
      private var $currPlayer;
      
      private var $markContainer:Sprite;
      
      private var _isDoubleClick:Boolean = false;
      
      private var _doubleInter:uint;
      
      private var _fixImg:MovieClip = null;
      
      private var _fixloader:DisplayLoader = null;
      
      private var _online_inter:uint;
      
      private var _onlinetime:Number = 300.0;
      
      private var _buffer_inter:uint;
      
      private var _afterads_inter:uint;
      
      public var videoAutoPlayNext:Boolean = true;
      
      private var _bufferCountArr:Array;
      
      private var $skin:VodSkin;
      
      private var $tempT:Number;
      
      private var $step:Number;
      
      private var minT:Number;
      
      private var maxT:Number;
      
      private var $pObj:Object;
      
      private var $kernel;
      
      private var $kernelObj:Object;
      
      private var $kernelVersion:String;
      
      private var $countDown:CountdownBlock;
      
      private var $playIndex:Number;
      
      private var $isStart:Boolean = false;
      
      private var $recommend:RecommendBox;
      
      private var $mark:DisplayObject;
      
      private var $markAdv:DisplayObject;
      
      private var $initW:Number = NaN;
      
      public function SkinMediator(param1:String, param2:Object)
      {
         this._bufferCountArr = [];
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
      
      public function get skin() : VodSkin
      {
         return this.$skin;
      }
      
      private function onFullscreenHandler(param1:FullScreenEvent) : void
      {
         InteractiveManager.sendEvent(PPLiveEvent.VOD_ONMODE_CHANGED,param1.fullScreen?"3":"4");
         Mouse.show();
         if(this.$skin)
         {
            this.$skin.setDisplayState(param1.fullScreen);
         }
         if(param1.fullScreen)
         {
            sendNotification(DACNotification.ADDOBJECTVALUE,{
               "at":DACCommon.B_CLK,
               "time":Math.floor(new Date().getTime() / 1000),
               "pos1":DACCommon.B_FULL
            },DACCommon.BEHA);
         }
         else
         {
            sendNotification(DACNotification.ADDOBJECTVALUE,{
               "at":DACCommon.B_CLK,
               "time":Math.floor(new Date().getTime() / 1000),
               "pos1":DACCommon.B_UNFULL
            },DACCommon.BEHA);
         }
      }
      
      override public function onRegister() : void
      {
         this.$skin = new VodSkin();
         this.view.addChild(this.$skin);
         this.$skin.visible = false;
         this.$skin.addEventListener(SkinEvent.LAYOUT_SUCCESS,this.onSkinHandler);
         this.$skin.addEventListener(SkinEvent.MEDIA_PLAY,this.onSkinHandler);
         this.$skin.addEventListener(SkinEvent.MEDIA_PAUSE,this.onSkinHandler);
         this.$skin.addEventListener(SkinEvent.MEDIA_SOUND,this.onSkinHandler);
         this.$skin.addEventListener(SkinEvent.MEDIA_CODE,this.onSkinHandler);
         this.$skin.addEventListener(SkinEvent.MEDIA_SHOW_SUBSETTING,this.onSkinHandler);
         this.$skin.addEventListener(SkinEvent.MEDIA_OPTION,this.onSkinHandler);
         this.$skin.addEventListener(SkinEvent.MEDIA_SHARE,this.onSkinHandler);
         this.$skin.addEventListener(SkinEvent.MEDIA_THEATRE,this.onSkinHandler);
         this.$skin.addEventListener(SkinEvent.MEDIA_STREAM,this.onSkinHandler);
         this.$skin.addEventListener(SkinEvent.MEDIA_HUE,this.onSkinHandler);
         this.$skin.addEventListener(SkinEvent.MEDIA_BARRAGE,this.onSkinHandler);
         this.$skin.addEventListener(SkinEvent.MEDIA_SETUP_BARRAGE,this.onSkinHandler);
         this.$skin.addEventListener(SkinEvent.MEDIA_SETTING,this.onSkinHandler);
         this.$skin.addEventListener(SkinEvent.MEDIA_ADJUST,this.onSkinHandler);
         this.$skin.addEventListener(SkinEvent.MEDIA_ICON,this.onSkinHandler);
         this.$skin.addEventListener(SkinEvent.MEDIA_NEXT,this.onSkinHandler);
         this.$skin.addEventListener(SkinEvent.MEDIA_HREF,this.onSkinHandler);
         this.$skin.addEventListener(SkinEvent.MEDIA_ACCELERATE,this.onSkinHandler);
         this.$skin.addEventListener(SkinEvent.MEDIA_VOD_POSITION,this.onSkinHandler);
         this.$skin.addEventListener(SkinEvent.MEDIA_PREVIEW_SNAPSHOT,this.onSkinHandler);
         this.$skin.addEventListener(SkinEvent.MEDIA_SMARTCLICK,this.onSkinHandler);
         this.$skin.addEventListener(SkinEvent.MEDIA_SUBTITLE_SETTING,this.onSkinHandler);
         this.$skin.addEventListener(SkinEvent.MEDIA_SUBTITLE_CHANGE,this.onSkinHandler);
         this.$skin.stage.addEventListener(FullScreenEvent.FULL_SCREEN,this.onFullscreenHandler);
         fabFacade.registerMediator(new BarrageMediator(BarrageMediator.NAME,this.$skin));
         fabFacade.registerMediator(new AdverMediator(AdverMediator.NAME,this.$skin));
         Global.getInstance()["ratio"] = 1;
         Global.getInstance()["playVideo"] = this.playVideo;
         Global.getInstance()["pauseVideo"] = this.pauseVideo;
         Global.getInstance()["stopVideo"] = this.stopVideo;
         Global.getInstance()["seekVideo"] = this.seekVideo;
         Global.getInstance()["setVolume"] = this.setVolume;
         Global.getInstance()["updataAccelerateState"] = this.updataAccelerateState;
         Global.getInstance()["smartClickData"] = this.smartClickData;
         Global.getInstance()["setBfrRecord"] = this.setBfrRecord;
         Global.getInstance()["setTips"] = this.setTips;
      }
      
      public function respondToVodKeyboard(param1:INotification) : void
      {
         var _loc2_:* = NaN;
         var _loc3_:* = NaN;
         var _loc4_:* = 0;
         var _loc5_:* = NaN;
         if((this.$skin && this.$skin.stage.focus) && (this.$skin.stage.focus is TextField) && TextField(this.$skin.stage.focus).type == TextFieldType.INPUT)
         {
            return;
         }
         if(param1.getBody() == Keyboard.UP || param1.getBody() == Keyboard.DOWN)
         {
            _loc2_ = VodParser.sv;
            if(!this.$skin.controlEnable)
            {
               try
               {
                  _loc2_ = ViewManager.getInstance().getMediator("adver").content.adVolume;
               }
               catch(evt:Error)
               {
               }
            }
            _loc3_ = _loc2_ % 5;
            if(param1.getBody() == Keyboard.UP)
            {
               _loc2_ = _loc2_ + (_loc3_ != 0?5 - _loc3_:5);
               _loc4_ = 1000;
               if(!this.$skin.controlEnable)
               {
                  _loc4_ = 100;
               }
               if(_loc2_ > _loc4_)
               {
                  _loc2_ = _loc4_;
               }
            }
            else if(param1.getBody() == Keyboard.DOWN)
            {
               _loc2_ = _loc2_ - (_loc3_ != 0?_loc3_:5);
               if(_loc2_ < 0)
               {
                  _loc2_ = 0;
               }
            }
            
            this.setVolume(_loc2_);
            sendNotification(DACNotification.ADDOBJECTVALUE,{
               "at":DACCommon.B_CLK,
               "time":Math.floor(new Date().getTime() / 1000),
               "pos1":DACCommon.B_VOLUME
            },DACCommon.BEHA);
         }
         if((param1.getBody() == Keyboard.LEFT || param1.getBody() == Keyboard.RIGHT) && (this.$skin.isCheckControlVisible))
         {
            if(isNaN(this.$tempT))
            {
               this.$tempT = VodPlay.posi;
            }
            if(Global.getInstance()["playmodel"] == "live")
            {
               this.minT = VodParser.stime;
               this.maxT = VodParser.etime;
               this.$step = VodPlay.interval;
               _loc5_ = this.$tempT % this.$step;
            }
            else if(Global.getInstance()["playmodel"] == "vod")
            {
               this.minT = 0;
               this.maxT = VodPlay.duration;
               this.$step = 10;
               _loc5_ = 0;
            }
            
            try
            {
               if(param1.getBody() == Keyboard.LEFT)
               {
                  this.$tempT = this.$tempT - (_loc5_ != 0?_loc5_:this.$step);
                  if(this.$tempT < this.minT)
                  {
                     this.$tempT = this.minT;
                  }
               }
               else if(param1.getBody() == Keyboard.RIGHT)
               {
                  this.$tempT = this.$tempT + (_loc5_ != 0?this.$step - _loc5_:this.$step);
                  if(this.$tempT > this.maxT)
                  {
                     this.$tempT = this.maxT;
                  }
               }
               
               this.$skin.setPosition(this.$tempT);
            }
            catch(evt:Error)
            {
            }
         }
         if((param1.getBody() == Keyboard.LEFT || param1.getBody() == Keyboard.RIGHT) && (this.$skin.isCheckControlVisible))
         {
            return;
         }
      }
      
      public function setVolume(param1:Number, param2:Boolean = true) : void
      {
         var _loc3_:Object = null;
         if(!this.$skin.controlEnable)
         {
            try
            {
               ViewManager.getInstance().getMediator("adver").content.adVolume = param1;
               this.$skin.setSound(param1);
            }
            catch(evt:Error)
            {
            }
            return;
         }
         VodParser.sv = param1;
         if(this.$currPlayer)
         {
            Global.getInstance()["volume"] = VodParser.sv;
            _loc3_ = {};
            if(param1 != 0)
            {
               VodCommon.cookie.setData("vol",param1);
               _loc3_["event"] = "volume";
            }
            else
            {
               _loc3_["event"] = "mute";
            }
            _loc3_["value"] = param1;
            InteractiveManager.sendEvent(PPLiveEvent.VOD_ONVOLUME_CHANGED,_loc3_);
            this.$currPlayer.setVolume(VodParser.sv);
            this.$skin.setSound(VodParser.sv);
         }
      }
      
      public function stopVideo() : void
      {
         if((this.$skin.startFreshMc) && !VodParser.hl)
         {
            this.$skin.startFreshMc.visible = true;
         }
         ViewManager.getInstance().getMediator("barrage").destroy();
         ViewManager.getInstance().getProxy("presnapshot").disposed(true);
         if((this.$markContainer) && (this.$markContainer.parent))
         {
            this.$currPlayer.removeChild(this.$markContainer);
            this.$markContainer = null;
         }
         this.close();
      }
      
      private function close() : void
      {
         if(this.$currPlayer)
         {
            this.$currPlayer.stop();
            this.$skin.removeChild(this.$currPlayer);
            this.$currPlayer = null;
            delete Global.getInstance()["player"];
            true;
            delete Global.getInstance()["rect"];
            true;
            CommonUtils.gc();
         }
         VodCommon.isPatch = false;
         VodCommon.isEmpty = true;
         this.$skin.playstate = VodCommon.playstate;
         VodPlay.cdnIndex = 0;
         this.$skin.showLoading(false);
         this.$skin.hideError();
         this.$skin.reset();
         if(this._online_inter)
         {
            clearInterval(this._online_inter);
         }
      }
      
      public function setSize(param1:Number = NaN, param2:Number = NaN) : void
      {
         var _loc3_:Array = null;
         var _loc4_:* = 0;
         var _loc5_:* = 0;
         var param1:Number = isNaN(param1)?this.stage.stageWidth:param1;
         var param2:Number = isNaN(param2)?this.stage.stageHeight:param2;
         if(this.stage.displayState == "fullScreen")
         {
            param1 = this.stage.stageWidth;
            param2 = this.stage.stageHeight;
         }
         try
         {
            this.$skin.resize(param1,param2);
            VodCommon.playerWidth = param1;
            VodCommon.playerHeight = this.stage.displayState == "fullScreen" || !this.$skin.isCheckControlVisible?param2:param2 - this.$skin.disH;
            if(this.$countDown)
            {
               this.$countDown.setSize(VodCommon.playerWidth,VodCommon.playerHeight);
            }
            if(this.$skin.handyMc)
            {
               this.setSkinUIVisible(this.$skin.handyMc,VodCommon.playerWidth > this.$skin.adjW);
            }
            if(this.$skin.controlMc)
            {
               this.setSkinUIVisible(this.$skin.controlMc,this.$skin.isCheckControlVisible);
            }
            if(this.$skin.topMc)
            {
               this.setSkinUIVisible(this.$skin.topMc,this.$skin.isCheckControlVisible);
            }
            this.playerResize(VodCommon.playerWidth,VodCommon.playerHeight,Global.getInstance()["ratio"]);
            this.fixImgResize(VodCommon.playerWidth,VodCommon.playerHeight);
            this.markResize();
            this.updataSmartClickUI();
            if(this.$recommend)
            {
               this.$recommend.setSize(VodCommon.playerWidth,VodCommon.playerHeight);
            }
         }
         catch(evt:Error)
         {
         }
         ViewManager.getInstance().getMediator("adver").setSize(VodCommon.playerWidth,VodCommon.playerHeight);
         ViewManager.getInstance().getMediator("barrage").setSize(VodCommon.playerWidth,VodCommon.playerHeight);
         ViewManager.getInstance().getMediator("smart").setSize(VodCommon.playerWidth,VodCommon.playerHeight);
         try
         {
            if(VodCommon.barrageDisplay)
            {
               ViewManager.getInstance().getMediator("barrage").visible = this.$skin.isCheckControlVisible;
            }
         }
         catch(evt:Error)
         {
         }
         try
         {
            ViewManager.getInstance().getMediator("vod").changeMouseMoveEffect(false);
         }
         catch(evt:Error)
         {
         }
         try
         {
            _loc3_ = Global.getInstance()["effect"];
            delete Global.getInstance()["effect"];
            true;
            if(_loc3_.length > 0)
            {
               _loc4_ = 0;
               _loc5_ = _loc3_.length;
               while(_loc4_ < _loc5_)
               {
                  if(_loc3_[_loc4_]["target"] == this.$skin.controlMc)
                  {
                     _loc3_[_loc4_]["status"] = this.stage.displayState == "fullScreen";
                     if(this.stage.displayState != "fullScreen")
                     {
                        _loc3_[_loc4_]["target"].visible = true;
                        _loc3_[_loc4_]["target"].alpha = 1;
                     }
                     break;
                  }
                  _loc4_++;
               }
            }
            Global.getInstance()["effect"] = _loc3_;
         }
         catch(evt:Error)
         {
         }
         try
         {
            ViewManager.getInstance().getMediator("vod").changeMouseMoveEffect(true);
         }
         catch(evt:Error)
         {
         }
      }
      
      public function setSkinUIVisible(param1:*, param2:Boolean) : void
      {
         var _loc3_:* = 0;
         var _loc4_:* = 0;
         if(Global.getInstance()["effect"].length > 0)
         {
            _loc3_ = 0;
            _loc4_ = Global.getInstance()["effect"].length;
            while(_loc3_ < _loc4_)
            {
               if(Global.getInstance()["effect"][_loc3_]["target"] == param1)
               {
                  Global.getInstance()["effect"].splice(_loc3_,1);
                  break;
               }
               _loc3_++;
            }
         }
         if(!param2)
         {
            param1.visible = false;
         }
         else
         {
            try
            {
               param1.alpha = 0;
               Global.getInstance()["effect"].push({
                  "target":param1,
                  "status":true
               });
            }
            catch(evt:Error)
            {
            }
         }
      }
      
      private function playerResize(param1:Number, param2:Number, param3:Number = NaN) : void
      {
         try
         {
            this.$currPlayer.resize(param1,param2,param3);
         }
         catch(evt:Error)
         {
         }
      }
      
      private function fixImgResize(param1:Number, param2:Number) : void
      {
         if(this._fixImg != null)
         {
            this._fixImg.graphics.clear();
            this._fixImg.graphics.beginFill(0);
            this._fixImg.graphics.drawRect(0,0,param1,param2);
            this._fixImg.graphics.endFill();
            if(this._fixloader != null)
            {
               this._fixloader.resize(param1,param2);
            }
         }
      }
      
      public function seekVideo(param1:Number) : void
      {
         if(this.$recommend)
         {
            this.$skin.removeChild(this.$recommend);
            this.$recommend = null;
         }
         this.$tempT = NaN;
         VodPlay.posi = param1;
         if(this.$currPlayer)
         {
            this.$currPlayer.seek();
            this.$currPlayer.setVolume(VodParser.sv);
         }
         this.$skin.hideError();
         this.$skin.clearCurrentSub();
         this.$skin.playstate = VodCommon.playstate;
         sendNotification(VodNotification.VOD_PAUSE_PATCH,false);
         ViewManager.getInstance().getMediator("barrage").clearBarrage();
         ViewManager.getInstance().getMediator("barrage").playBarrage();
         this._bufferCountArr.splice(0);
      }
      
      public function switchVideo(param1:Number) : void
      {
         if(this.$currPlayer)
         {
            if(Global.getInstance()["playmodel"] == "live")
            {
               VodCommon.currRid = VodPlay.streamVec[param1].rid;
               sendNotification(DACNotification.SET_VALUE,VodCommon.currRid,DACCommon.VID);
               sendNotification(DACNotification.SET_VALUE,VodPlay.streamIndex,DACCommon.CFT);
               sendNotification(DACNotification.SET_VALUE,null,DACCommon.CS);
               this.$currPlayer.currRid = VodCommon.currRid;
               this.$currPlayer.isKernelStart = true;
               this.seekVideo(VodPlay.posi);
            }
            else if(Global.getInstance()["playmodel"] == "vod")
            {
               this.$currPlayer.switchFT(param1);
               PrintDebug.Trace("切换码流 ===>>>  ",param1);
            }
            
            this.$currPlayer.setVolume(VodParser.sv);
            this.$skin.playstate = VodCommon.playstate;
            sendNotification(VodNotification.VOD_PAUSE_PATCH,false);
         }
      }
      
      public function toggleVideo() : void
      {
         if(VodCommon.playstate == "playing")
         {
            this.pauseVideo();
         }
         else if(!VodParser.ap)
         {
            if(this._fixImg)
            {
               this._fixImg.visible = false;
            }
            this.checkPlayModel();
            VodParser.ap = true;
         }
         else
         {
            this.playVideo();
         }
         
      }
      
      public function playVideo(param1:Object = null) : void
      {
         var obj:Object = param1;
         if(this.$recommend)
         {
            this.$skin.removeChild(this.$recommend);
            this.$recommend = null;
         }
         if((this.$skin) && (this.$skin.startFreshMc))
         {
            this.$skin.startFreshMc.visible = false;
         }
         if(this._afterads_inter)
         {
            clearTimeout(this._afterads_inter);
         }
         if(obj != null)
         {
            this.$pObj = obj;
            if(obj["cid"])
            {
               VodParser.cid = obj["cid"];
            }
            try
            {
               if(obj["pl"])
               {
                  VodCommon.pl = obj["pl"];
                  Utils.decodePlayLink(obj["pl"]);
                  VodParser.cid = Utils.ChListId;
               }
            }
            catch(evt:Error)
            {
            }
            if(CommonUtils.match(obj,"title"))
            {
               VodCommon.title = obj["title"];
            }
            if(CommonUtils.match(obj,"link"))
            {
               VodCommon.link = obj["link"];
            }
            if(CommonUtils.match(obj,"swf"))
            {
               VodCommon.swf = obj["swf"];
            }
            if(CommonUtils.match(obj,"playStr"))
            {
               VodCommon.playStr = obj["playStr"];
            }
            this.stopVideo();
            sendNotification(VodNotification.VOD_CLEAR_ADVER);
            sendNotification(DACNotification.UPDATE_SESSION);
            try
            {
               Global.getInstance()["setBarrageInfo"]();
            }
            catch(evt:Error)
            {
            }
            if(VodParser.ap)
            {
               this.checkPlayModel();
            }
            else
            {
               var addFiximg:Function = function():void
               {
                  var onFixLoaderHandler:Function = null;
                  onFixLoaderHandler = function(param1:Event):void
                  {
                     switch(param1.type)
                     {
                        case "_ioerror_":
                        case "_securityerror_":
                        case "_timeout_":
                           _fixloader.clear();
                           _fixloader = null;
                           break;
                        case "_complete_":
                           _fixImg = new MovieClip();
                           $skin.addChild(_fixImg);
                           if($skin.bigPlayMc)
                           {
                              $skin.swapChildren(_fixImg,$skin.bigPlayMc);
                           }
                           _fixImg.addChild(_fixloader.content);
                           fixImgResize(VodCommon.playerWidth,VodCommon.playerHeight);
                           break;
                     }
                  };
                  _fixloader = new DisplayLoader(VodParser.fimg);
                  _fixloader.addEventListener("_complete_",onFixLoaderHandler);
                  _fixloader.addEventListener("_ioerror_",onFixLoaderHandler);
                  _fixloader.addEventListener("_securityerror_",onFixLoaderHandler);
                  _fixloader.addEventListener("_timeout_",onFixLoaderHandler);
               };
               this.$skin.controlEnable = true;
               VodParser.fimg = CommonUtils.addHttp(VodParser.fimg?VodParser.fimg:"http://s1.pplive.cn/v/cap/" + VodParser.cid + "/h480.jpg");
               addFiximg();
            }
         }
         else if(this.$currPlayer)
         {
            this.$currPlayer.play();
            sendNotification(VodNotification.VOD_PAUSE_PATCH,false);
            this.$skin.playstate = VodCommon.playstate;
            ViewManager.getInstance().getMediator("barrage").playBarrage();
         }
         else
         {
            this.stopVideo();
            sendNotification(VodNotification.VOD_CLEAR_ADVER);
            sendNotification(DACNotification.UPDATE_SESSION);
            this.checkPlayModel();
         }
         
         if(obj != null)
         {
            InteractiveManager.sendEvent(PPLiveEvent.VOD_ONPLAYSTATE_CHANGED,"5");
            return;
         }
         InteractiveManager.sendEvent(PPLiveEvent.VOD_ONPLAYSTATE_CHANGED,"5");
      }
      
      private function checkPlayModel() : void
      {
         PrintDebug.Trace("beha、bfr、pv日志发送  >>>>> ");
         sendNotification(DACNotification.ACTION,null,DACCommon.BFR);
         sendNotification(DACNotification.ACTION,null,DACCommon.INIT);
         sendNotification(DACNotification.SET_VALUE,VodCommon.version,DACCommon.VERSION);
         sendNotification(DACNotification.SET_VALUE,this.$kernelVersion,DACCommon.CORE_VERSION);
         sendNotification(DACNotification.SET_VALUE,VodCommon.pid,DACCommon.PID);
         sendNotification(DACNotification.SET_VALUE,VodParser.ctx,DACCommon.CTX);
         sendNotification(DACNotification.SET_VALUE,CTXQuery.dctx,DACCommon.DCTX);
         sendNotification(DACNotification.SET_VALUE,VodParser.os,DACCommon.RCCID);
         sendNotification(DACNotification.SET_VALUE,VodParser.clid,DACCommon.CLD);
         sendNotification(DACNotification.SET_VALUE,VodParser.cid,DACCommon.CID);
         try
         {
            sendNotification(DACNotification.SET_VALUE,Utils.playLink(VodCommon.pl),DACCommon.PL);
         }
         catch(evt:Error)
         {
         }
         sendNotification(DACNotification.ACTION,null,DACCommon.PV);
         sendNotification(DACNotification.SET_VALUE,Number(VIPPrivilege.isVip),DACCommon.ISVIP);
         sendNotification(DACNotification.SET_VALUE,VodParser.un,DACCommon.UID);
         DACQueue.sendURL("http://hit.data.pplive.com/test/1.html?plt=ik&biz=ads_ik_test&ver=+" + VodCommon.version + "&o=" + VodParser.os + "&chid=" + VodParser.cid + "&clid=" + VodParser.clid + "&sid=" + Utils.ChListId + "&vvid=" + DACReport.vvid + "&position=2");
         this.$skin.controlEnable = false;
         this.$skin.soundEnable = true;
         this.$skin["$config"] = {
            "puid":(VodCommon.mkey?VodCommon.mkey:VodCommon.puid),
            "username":VodParser.un
         };
         if(!ViewManager.getInstance().getMediator("adver").content)
         {
            ViewManager.getInstance().getProxy("adver").initData();
         }
         else if(!VIPPrivilege.isNoad)
         {
            sendNotification(VodNotification.VOD_BEFORE_PATCH);
         }
         
         sendNotification(DACNotification.SET_VALUE,"1",DACCommon.NP);
         ViewManager.getInstance().getMediator("barrage").destroy(true);
         ViewManager.getInstance().getProxy("ppap").initData();
         if((this.$skin) && (this.$skin.subTitleMc))
         {
            ViewManager.getInstance().getProxy("subtitlelist").initData();
         }
         this.restartData();
      }
      
      private function restartData() : void
      {
         sendNotification(DACNotification.START_RECORD,null,DACCommon.TDS);
         sendNotification(DACNotification.DAC_MARK,{
            "t":new Date().getTime(),
            "p":"ftps"
         },DACCommon.TDS);
         ViewManager.getInstance().getProxy("play").reset();
         ViewManager.getInstance().getProxy("play").initData();
         ViewManager.getInstance().getProxy("clouddarg").initData();
      }
      
      public function pauseVideo() : void
      {
         if(this.$currPlayer)
         {
            this.$currPlayer.pause();
         }
         if((this.$skin.adjustMc) && !this.$skin.adjustMc.visible)
         {
            sendNotification(VodNotification.VOD_PAUSE_PATCH,true);
         }
         this.$skin.playstate = VodCommon.playstate;
         ViewManager.getInstance().getMediator("barrage").pauseBarrage();
         this.$skin.showLoading(false);
         InteractiveManager.sendEvent(PPLiveEvent.VOD_ONPLAYSTATE_CHANGED,"6");
      }
      
      public function respondToVodPPAP(param1:INotification) : void
      {
         VodCommon.isPPAP = true;
         this.updataAccelerateState();
         sendNotification(DACNotification.SET_VALUE,"0",DACCommon.NP);
         if(param1.getBody())
         {
            VodCommon.mkey = param1.getBody()["k"];
            this.$skin["$config"] = {
               "puid":(VodCommon.mkey?VodCommon.mkey:VodCommon.puid),
               "username":VodParser.un
            };
         }
      }
      
      public function respondToVodKernelFailed(param1:INotification) : void
      {
         PrintDebug.Trace("内核获取失败......");
         var _loc2_:Object = {"code":VodCommon.callCode["video"][1]};
         var _loc3_:String = VodCommon.playErrorText;
         this.$skin.showError({
            "title":_loc3_.replace(new RegExp("%code%","g"),_loc2_["code"]),
            "type":"error"
         });
      }
      
      public function get kernel() : *
      {
         return this.$kernel;
      }
      
      public function respondToVodKernelSuccess(param1:INotification) : void
      {
         var note:INotification = param1;
         if((this.$kernelObj) && (this.$kernel))
         {
            this.view.removeChild(this.$kernel);
         }
         this.$kernelObj = note.getBody() as Object;
         this.$kernelVersion = this.$kernelObj["version"].toString();
         this.$kernel = this.$kernelObj["kernel"];
         this.view.addChild(this.$kernel);
         PrintDebug.Trace("内核 " + this.$kernelObj["playmodel"] + " 获取成功 ====>>>>");
         if(this.$kernelObj["playmodel"] == "vod")
         {
            try
            {
               this.$kernel.start();
            }
            catch(evt:Error)
            {
            }
            if(VodCommon.isHttpRequest)
            {
               this.playVideo(VodParser.paramObj);
            }
            else
            {
               setTimeout(function():void
               {
                  InteractiveManager.sendEvent(PPLiveEvent.VOD_ONREADY);
               },0);
            }
         }
         else if(this.$kernelObj["playmodel"] == "live")
         {
            VodPlay.streamIndex = Global.getInstance()["getStreamIndex"](VodPlay.streamVec);
            PrintDebug.Trace("准备播放执行码流 ===>>>  ",VodPlay.streamIndex);
            VodCommon.currRid = VodPlay.streamVec[VodPlay.streamIndex].rid;
            sendNotification(DACNotification.SET_VALUE,VodCommon.currRid,DACCommon.VID);
            sendNotification(DACNotification.SET_VALUE,VodPlay.streamIndex,DACCommon.CFT);
            sendNotification(DACNotification.SET_VALUE,VodPlay.streamVec[VodPlay.streamIndex].bitrate,DACCommon.BIT);
            sendNotification(VodNotification.VOD_DATA_REQUEST);
            VodCommon.cookie.setData("ft",VodPlay.streamIndex);
         }
         
         this.updataAccelerateState();
      }
      
      public function respondToVodCountdown(param1:INotification) : void
      {
         PrintDebug.Trace("节目尚未到播放时间点，开始倒计时 ===>>>");
         this.$countDown = new CountdownBlock();
         this.$skin.addChild(this.$countDown);
         this.$countDown.AddTime(param1.getBody()["time"]);
         this.$countDown.addEventListener("countdown_over",this.onCountdownHandler);
         this.$countDown.setSize(VodCommon.playerWidth,VodCommon.playerHeight);
         ViewManager.getInstance().getMediator("adver").DelAFP();
      }
      
      private function onCountdownHandler(param1:Event) : void
      {
         this.$skin.removeChild(this.$countDown);
         this.playVideo(this.$pObj);
      }
      
      public function respondToVodPlayFailed(param1:INotification) : void
      {
         var _loc2_:Object = null;
         sendNotification(DACNotification.ERROR,null,DACCommon.ERROR_DATETIME);
         PrintDebug.Trace("play服务请求失败  ===>>>  ",param1.getBody());
         if(param1.getBody())
         {
            _loc2_ = param1.getBody() as Object;
            this.$skin.showError({
               "title":_loc2_["error"],
               "type":"error"
            });
         }
      }
      
      public function respondToVodSkinSuccess(param1:INotification) : void
      {
         this.$skin.setData(param1.getBody() as Array);
         PrintDebug.Trace("播放器皮肤配置文件载入成功");
      }
      
      private function onSkinHandler(param1:SkinEvent) : void
      {
         var _loc2_:* = NaN;
         var _loc3_:* = NaN;
         var _loc4_:ColorMatrix = null;
         var _loc5_:String = null;
         var _loc6_:String = null;
         var _loc7_:String = null;
         var _loc8_:* = 0;
         var _loc9_:Object = null;
         switch(param1.type)
         {
            case SkinEvent.LAYOUT_SUCCESS:
               try
               {
                  Global.getInstance()["effect"].push({
                     "target":this.$skin.topMc,
                     "status":true
                  });
               }
               catch(evt:Error)
               {
               }
               try
               {
                  Global.getInstance()["effect"].push({
                     "target":this.$skin.handyMc,
                     "status":true
                  });
               }
               catch(evt:Error)
               {
               }
               try
               {
                  Global.getInstance()["effect"].push({
                     "target":this.$skin.controlMc,
                     "status":false
                  });
               }
               catch(evt:Error)
               {
               }
               _loc2_ = isNaN(VodParser.vw)?this.stage.stageWidth:VodParser.vw;
               _loc3_ = isNaN(VodParser.vw)?this.stage.stageHeight:VodParser.vh;
               this.setSize(_loc2_,_loc3_);
               this.$skin.setDisplayState(false);
               this.$skin.setTheatre(VodCommon.isTheatre);
               this.$skin.controlEnable = false;
               this.$skin.visible = true;
               sendNotification(VodNotification.PLAYER_LOADING_DELETE);
               InteractiveManager.sendEvent(PPLiveEvent.VOD_ONPLAYSTATE_CHANGED,"2");
               ViewManager.getInstance().getProxy("kernel").initData();
               break;
            case SkinEvent.MEDIA_PLAY:
               if(!VodParser.ap)
               {
                  InteractiveManager.sendEvent(PPLiveEvent.VOD_ONPLAYSTATE_CHANGED,"5");
                  this.checkPlayModel();
                  VodParser.ap = true;
               }
               else
               {
                  this.playVideo();
               }
               if(this._fixImg)
               {
                  this._fixImg.visible = false;
               }
               break;
            case SkinEvent.MEDIA_PAUSE:
               this.pauseVideo();
               sendNotification(DACNotification.ADDOBJECTVALUE,{
                  "at":DACCommon.B_CLK,
                  "time":Math.floor(new Date().getTime() / 1000),
                  "pos1":DACCommon.B_PAUSE
               },DACCommon.BEHA);
               break;
            case SkinEvent.MEDIA_SOUND:
               this.setVolume(param1.currObj["value"]);
               if(param1.currObj["click"])
               {
                  sendNotification(DACNotification.ADDOBJECTVALUE,{
                     "at":DACCommon.B_CLK,
                     "time":Math.floor(new Date().getTime() / 1000),
                     "pos1":DACCommon.B_VOLUME
                  },DACCommon.BEHA);
               }
               break;
            case SkinEvent.MEDIA_THEATRE:
               sendNotification(DACNotification.ADDOBJECTVALUE,{
                  "at":DACCommon.B_CLK,
                  "time":Math.floor(new Date().getTime() / 1000),
                  "pos1":DACCommon.B_THEATRE
               },DACCommon.BEHA);
               if(this.stage.displayState == "fullScreen")
               {
                  this.stage.displayState = "normal";
               }
               InteractiveManager.sendEvent(PPLiveEvent.VOD_ONNOTIFICATION,{
                  "header":{"type":"theatre"},
                  "body":{"data":param1.currObj}
               });
               break;
            case SkinEvent.MEDIA_STREAM:
               if(param1.currObj["stream"] != VodPlay.streamIndex)
               {
                  _loc8_ = VodPlay.streamIndex;
                  VodPlay.streamIndex = param1.currObj["stream"];
                  if(!Global.getInstance()["checklimit"](VodPlay.streamIndex))
                  {
                     _loc9_ = {
                        "code":VodCommon.callCode["video"][5],
                        "message":"该码流需安装插件播放"
                     };
                     sendNotification(VodNotification.VOD_TIPS,_loc9_);
                     VodPlay.streamIndex = _loc8_;
                     try
                     {
                        sendNotification(DACNotification.ADDOBJECTVALUE,{
                           "at":DACCommon.B_SHOW,
                           "time":Math.floor(new Date().getTime() / 1000),
                           "ft":VodPlay.streamIndex,
                           "mn":this.$currPlayer.playIndex,
                           "pos1":DACCommon.B_SMOOTH_NO_PPAP
                        },DACCommon.BEHA);
                     }
                     catch(evt:Error)
                     {
                     }
                     this.resetStreamRadio();
                  }
                  else
                  {
                     if(Global.getInstance()["playmodel"] == "vod")
                     {
                        if(!VIPPrivilege.isVip && !(VodPlay.streamVec[VodPlay.streamIndex].vip == "0"))
                        {
                           PrintDebug.Trace("非VIP用户切换VIP所需码流，弹出开通会员浮层  ===>>>");
                           if(this.stage.displayState == "fullScreen")
                           {
                              this.stage.displayState = "normal";
                           }
                           InteractiveManager.sendEvent(PPLiveEvent.VOD_ONVIP_VALIDATE,"3");
                           VodPlay.streamIndex = _loc8_;
                           this.resetStreamRadio();
                           return;
                        }
                        PrintDebug.Trace("当前播放段数  ====>>>>  ",this.$currPlayer.playIndex,",","可播放最大段数  ===>>> ",Global.getInstance()["checkMaxPlayIndex"](VodPlay.streamIndex));
                        if(this.$currPlayer.playIndex + 1 > Global.getInstance()["checkMaxPlayIndex"](VodPlay.streamIndex) && !VodCommon.isPPAP)
                        {
                           _loc9_ = {
                              "code":VodCommon.callCode["video"][5],
                              "message":"该码流需安装插件播放"
                           };
                           sendNotification(VodNotification.VOD_TIPS,_loc9_);
                           VodPlay.streamIndex = _loc8_;
                           try
                           {
                              sendNotification(DACNotification.ADDOBJECTVALUE,{
                                 "at":DACCommon.B_SHOW,
                                 "time":Math.floor(new Date().getTime() / 1000),
                                 "ft":VodPlay.streamIndex,
                                 "mn":this.$currPlayer.playIndex,
                                 "pos1":DACCommon.B_SMOOTH_NO_PPAP
                              },DACCommon.BEHA);
                           }
                           catch(evt:Error)
                           {
                           }
                           this.resetStreamRadio();
                           return;
                        }
                        this.$playIndex = NaN;
                     }
                     this.switchVideo(VodPlay.streamIndex);
                     VodCommon.cookie.setData("ft",VodPlay.streamIndex);
                     this.$skin.setHdTitle(VodPlay.streamIndex);
                     sendNotification(DACNotification.ADDOBJECTVALUE,{
                        "at":DACCommon.B_CLK,
                        "time":Math.floor(new Date().getTime() / 1000),
                        "pos1":DACCommon.B_SMOOTH
                     },DACCommon.BEHA);
                     InteractiveManager.sendEvent(PPLiveEvent.VOD_ONSTREAM_CHANGED,{
                        "ft":VodPlay.streamVec[VodPlay.streamIndex].ft,
                        "rid":VodPlay.streamVec[VodPlay.streamIndex].rid,
                        "bitrate":VodPlay.streamVec[VodPlay.streamIndex].bitrate
                     });
                  }
               }
               break;
            case SkinEvent.MEDIA_HUE:
               if(!this.$currPlayer)
               {
                  return;
               }
               _loc4_ = new ColorMatrix();
               _loc4_.adjustBrightness(param1.currObj["bt"]);
               _loc4_.adjustContrast(param1.currObj["ct"]);
               this.$currPlayer.filters = [new ColorMatrixFilter(_loc4_)];
               PrintDebug.Trace("播放器亮度、对比度调整为  ===>>>  ",param1.currObj);
               break;
            case SkinEvent.MEDIA_CODE:
               _loc5_ = VodCommon.link + "?rcc_src=vodplayer_qrcode";
               this.$skin.setCode(_loc5_);
               sendNotification(DACNotification.ADDOBJECTVALUE,{
                  "at":DACCommon.B_SHOW,
                  "time":Math.floor(new Date().getTime() / 1000),
                  "pos1":DACCommon.B_QRCODE
               },DACCommon.BEHA);
               break;
            case SkinEvent.MEDIA_SHOW_SUBSETTING:
               break;
            case SkinEvent.MEDIA_OPTION:
               sendNotification(DACNotification.ADDOBJECTVALUE,{
                  "at":DACCommon.B_CLK,
                  "time":Math.floor(new Date().getTime() / 1000),
                  "pos1":DACCommon.B_SETUP
               },DACCommon.BEHA);
               break;
            case SkinEvent.MEDIA_SHARE:
               sendNotification(DACNotification.ADDOBJECTVALUE,{
                  "at":DACCommon.B_CLK,
                  "time":Math.floor(new Date().getTime() / 1000),
                  "pos1":DACCommon.B_SHARE
               },DACCommon.BEHA);
               break;
            case SkinEvent.MEDIA_BARRAGE:
               VodCommon.barrageDisplay = param1.currObj["display"];
               ViewManager.getInstance().getMediator("barrage").visible = VodCommon.barrageDisplay;
               VodCommon.cookie.setData("default_display",VodCommon.barrageDisplay);
               if(param1.currObj["click"])
               {
                  sendNotification(DACNotification.ADDOBJECTVALUE,{
                     "at":DACCommon.B_CLK,
                     "time":Math.floor(new Date().getTime() / 1000),
                     "state":(VodCommon.barrageDisplay?"1":"0"),
                     "pos1":DACCommon.B_BARRAGE
                  },DACCommon.BEHA);
               }
               break;
            case SkinEvent.MEDIA_SETUP_BARRAGE:
               InteractiveManager.sendEvent(PPLiveEvent.VOD_ONNOTIFICATION,{
                  "header":{"type":"setupbarrage"},
                  "body":{"data":param1.currObj}
               });
               break;
            case SkinEvent.MEDIA_SETTING:
               _loc4_ = new ColorMatrix();
               _loc4_.adjustBrightness(param1.currObj["bt"]);
               _loc4_.adjustContrast(param1.currObj["ct"]);
               this.$currPlayer.filters = [new ColorMatrixFilter(_loc4_)];
               sendNotification(DACNotification.ADDOBJECTVALUE,{
                  "at":DACCommon.B_CLK,
                  "time":Math.floor(new Date().getTime() / 1000),
                  "pos1":DACCommon.B_BRIGHT
               },DACCommon.BEHA);
               PrintDebug.Trace("播放器亮度、对比度调整为  ===>>>  ",param1.currObj);
               if(param1.currObj["skip"] != undefined)
               {
                  VodCommon.isSkipPrelude = !Boolean(param1.currObj["skip"]);
                  VodCommon.cookie.setData("skip_prelude",VodCommon.isSkipPrelude);
                  this.setSkipPrelude();
               }
               break;
            case SkinEvent.MEDIA_ADJUST:
               sendNotification(VodNotification.VOD_ADVER_VISIBLE,param1.currObj);
               break;
            case SkinEvent.MEDIA_ICON:
               _loc6_ = param1.currObj["value"];
               _loc7_ = VodCommon.link + "?rcc_src=vodplayer_share";
               _loc7_ = _loc7_ + ("&suid=" + ViewManager.getInstance().getMediator("dac").dac_report.puid);
               _loc7_ = _loc7_ + ("&susername=" + encodeURIComponent(VodParser.un));
               _loc7_ = _loc7_ + "&splt=ik";
               _loc7_ = _loc7_ + ("&sapp=" + encodeURIComponent(param1.currObj["sapp"]));
               _loc6_ = _loc6_.replace(new RegExp("\\[LINK\\]","g"),encodeURIComponent(_loc7_));
               _loc6_ = _loc6_.replace(new RegExp("\\[TITLE\\]","g"),encodeURIComponent("我正在#PPTV 网络电视#观看" + VodCommon.title + "（分享自@PPTV聚力）"));
               try
               {
                  CommonUtils.getURL(_loc6_);
               }
               catch(evt:Error)
               {
               }
               break;
            case SkinEvent.MEDIA_NEXT:
               this.videoAutoPlayNext = false;
               sendNotification(DACNotification.ADDOBJECTVALUE,{
                  "at":DACCommon.B_CLK,
                  "time":Math.floor(new Date().getTime() / 1000),
                  "pos1":DACCommon.B_NEXT
               },DACCommon.BEHA);
               PrintDebug.Trace("主动结束播放，进入下一段节目 ===>>>" + VodCommon.playstate);
               this.nextExecute();
               break;
            case SkinEvent.MEDIA_HREF:
               if(param1.currObj["value"] == "vip")
               {
                  PrintDebug.Trace("弹出开通会员浮层  ===>>>");
                  if(this.stage.displayState == "fullScreen")
                  {
                     this.stage.displayState = "normal";
                  }
                  InteractiveManager.sendEvent(PPLiveEvent.VOD_ONVIP_VALIDATE,"3");
               }
               if(param1.currObj["value"] == "click")
               {
                  PrintDebug.Trace("安装插件 >>>>> " + param1.currObj["link"]);
                  try
                  {
                     CommonUtils.getURL(param1.currObj["link"]);
                     sendNotification(DACNotification.ADDOBJECTVALUE,{
                        "at":DACCommon.B_CLK,
                        "time":Math.floor(new Date().getTime() / 1000),
                        "pos1":DACCommon.B_INSTALL_PLUGIN
                     },DACCommon.BEHA);
                  }
                  catch(evt:Error)
                  {
                  }
               }
               else if(param1.currObj["value"] == AccelerateUI.NO_MEMBER)
               {
                  PrintDebug.Trace("弹出登录会员浮层  ===>>>");
                  if(this.stage.displayState == "fullScreen")
                  {
                     this.stage.displayState = "normal";
                  }
                  InteractiveManager.sendEvent(PPLiveEvent.VOD_ONVIP_VALIDATE,"2");
               }
               
               break;
            case SkinEvent.MEDIA_ACCELERATE:
               sendNotification(DACNotification.ADDOBJECTVALUE,{
                  "at":DACCommon.B_CLK,
                  "time":Math.floor(new Date().getTime() / 1000),
                  "pos1":DACCommon.B_ACC
               },DACCommon.BEHA);
               break;
            case SkinEvent.MEDIA_VOD_POSITION:
               sendNotification(DACNotification.ADD_VALUE,null,DACCommon.DG);
               sendNotification(DACNotification.START_RECORD,null,DACCommon.TDD);
               sendNotification(DACNotification.ADDOBJECTVALUE,{
                  "at":DACCommon.B_CLK,
                  "time":Math.floor(new Date().getTime() / 1000),
                  "pos1":DACCommon.B_P_DRAG
               },DACCommon.BEHA);
               this.seekVideo(param1.currObj["value"]);
               break;
            case SkinEvent.MEDIA_PREVIEW_SNAPSHOT:
               if(param1.currObj)
               {
                  ViewManager.getInstance().getProxy("presnapshot").disposed(false,Global.getInstance()["playmodel"] == "live"?VodParser.stime:NaN);
                  ViewManager.getInstance().getProxy("presnapshot").initData(param1.currObj["value"]);
               }
               else
               {
                  this.$skin.setPreSnapshot(null);
               }
               break;
            case SkinEvent.MEDIA_SMARTCLICK:
               sendNotification(VodNotification.VOD_ADVER_SMARTCLICK,param1.currObj);
               break;
            case SkinEvent.MEDIA_SUBTITLE_SETTING:
               if(this.skin)
               {
                  this.skin.setSubTitleShowInfo(param1.currObj);
               }
               break;
            case SkinEvent.MEDIA_SUBTITLE_CHANGE:
               try
               {
                  VodParser.subTitle = param1.currObj.toString();
                  if((VodParser.subTitle) && VodParser.subTitle.length > 0)
                  {
                     ViewManager.getInstance().getProxy("subtitleinfo").initData();
                  }
                  if(this.skin)
                  {
                     this.skin.changeSubTitle();
                  }
               }
               catch(evt:Error)
               {
               }
               break;
         }
      }
      
      public function respondToVodPreviewSnapshot(param1:INotification) : void
      {
         this.$skin.setPreSnapshot(param1.getBody());
      }
      
      private function startUpPlayer() : void
      {
         PrintDebug.Trace("最终执行启动点播play类型  >>>>>  " + Global.getInstance()["playmodel"]);
         this.$currPlayer = new (Global.getInstance()["playmodel"] == "vod"?VodP2PPlayer:LiveP2PPlayer)();
         this.$markContainer = new Sprite();
         this.$skin.addChild(this.$currPlayer);
         this.$currPlayer.currRid = VodCommon.currRid;
         if(this.$kernel)
         {
            this.$currPlayer.kernel = this.$kernel;
            this.$currPlayer.advertisementTime = isNaN(ViewManager.getInstance().getMediator("adver").adTotalTime)?30:ViewManager.getInstance().getMediator("adver").adTotalTime;
            this.$currPlayer["setConnect"]();
         }
         Global.getInstance()["player"] = this.$currPlayer;
         this.$skin.setChildIndex(this.$currPlayer,0);
         if(this.$skin.startFreshMc)
         {
            this.$skin.swapChildren(this.$currPlayer,this.$skin.startFreshMc);
         }
         this.$currPlayer.addEventListener(MouseEvent.CLICK,this.onPlayerHandler);
         this.$currPlayer.addEventListener(StreamEvent.STREAM_REPLAY,this.onPlayerHandler);
         this.$currPlayer.addEventListener(StreamEvent.STREAM_UPDATE,this.onPlayerHandler);
         this.$currPlayer.addEventListener(StreamEvent.STREAM_START,this.onPlayerHandler);
         this.$currPlayer.addEventListener(StreamEvent.STREAM_SEEK,this.onPlayerHandler);
         this.$currPlayer.addEventListener(StreamEvent.STREAM_EMPTY,this.onPlayerHandler);
         this.$currPlayer.addEventListener(StreamEvent.STREAM_FULL,this.onPlayerHandler);
         this.$currPlayer.addEventListener(StreamEvent.STREAM_FAILED,this.onPlayerHandler);
         this.$currPlayer.addEventListener(StreamEvent.STREAM_SPEED,this.onPlayerHandler);
         this.$currPlayer.addEventListener(StreamEvent.STREAM_STOP,this.onPlayerHandler);
         this.$currPlayer.addEventListener(StreamEvent.STREAM_RESULT,this.onPlayerHandler);
         this.$currPlayer.addEventListener(StreamEvent.STREAM_P2PLOG,this.onPlayerHandler);
         this.$currPlayer.addEventListener("_video_change_",this.onPlayerHandler);
         this.$currPlayer.addEventListener("_video_status_",this.onPlayerHandler);
         this.$currPlayer.addEventListener("_play_error_",this.onPlayerHandler);
         this.$currPlayer.addEventListener("_onair_show_",this.onPlayerHandler);
         this.$currPlayer.addEventListener("_onair_hide_",this.onPlayerHandler);
         this.$currPlayer.addEventListener("_flashp2p_dac_",this.onPlayerHandler);
         this.$currPlayer.addEventListener("_stream_started_",this.onPlayerHandler);
         this.$currPlayer.addEventListener("_stream_seeked_",this.onPlayerHandler);
      }
      
      private function online() : void
      {
         sendNotification(DACNotification.ACTION,null,DACCommon.ONLINE);
      }
      
      private function checkDoubleClick(param1:Boolean) : void
      {
         this._isDoubleClick = false;
         if(this._doubleInter)
         {
            clearTimeout(this._doubleInter);
         }
         if((param1) && (VodCommon.allowScreenClick == "all" || VodCommon.allowScreenClick == "click"))
         {
            this.toggleVideo();
         }
      }
      
      private function nextExecute() : void
      {
         this.stopVideo();
         VodCommon.cookie.remove("posiInfo");
         if(VodParser.rp)
         {
            PrintDebug.Trace("播放自动结束，轮播开始 ===>>>");
            this.playVideo(this.$pObj);
         }
         else
         {
            PrintDebug.Trace("播放自动结束，进入下一段节目 ===>>>" + VodCommon.playstate);
            InteractiveManager.sendEvent(PPLiveEvent.VOD_ONPLAYSTATE_CHANGED,"8");
            sendNotification(VodNotification.VOD_NEXT);
         }
         this.videoAutoPlayNext = true;
      }
      
      private function onPlayerHandler(param1:Event) : void
      {
         var $timeObj:Object = null;
         var $obj:Object = null;
         var temp:String = null;
         var _codeObj:Object = null;
         var start:Number = NaN;
         var i:int = 0;
         var tempIndex:int = 0;
         var changeNext:Function = null;
         var e:Event = param1;
         switch(e.type)
         {
            case MouseEvent.CLICK:
               if(VodCommon.allowScreenClick == "none")
               {
                  return;
               }
               if(this.$currPlayer.visible)
               {
                  if(this._isDoubleClick)
                  {
                     try
                     {
                        if(VodCommon.allowScreenClick == "all" || VodCommon.allowScreenClick == "doubleclick")
                        {
                           this.stage.displayState = this.stage.displayState == "fullScreen"?"normal":"fullScreen";
                        }
                     }
                     catch(evt:Error)
                     {
                     }
                     this.checkDoubleClick(false);
                  }
                  else
                  {
                     this._isDoubleClick = true;
                     this._doubleInter = setTimeout(this.checkDoubleClick,500,true);
                  }
                  if(this._isDoubleClick)
                  {
                  }
               }
               break;
            case StreamEvent.STREAM_REPLAY:
               this.playVideo(this.$pObj);
               break;
            case StreamEvent.STREAM_START:
               if(!Global.getInstance()["checklimit"](VodPlay.streamIndex) && !VodCommon.isPPAP && !VodCommon.smart)
               {
                  PrintDebug.Trace("强插策略下，未检测到 9000|9000 端口......");
                  try
                  {
                     sendNotification(DACNotification.ADDOBJECTVALUE,{
                        "at":DACCommon.B_SHOW,
                        "time":Math.floor(new Date().getTime() / 1000),
                        "ft":VodPlay.streamIndex,
                        "mn":this.$currPlayer.playIndex,
                        "pos1":DACCommon.B_FORCE_PPAP
                     },DACCommon.BEHA);
                  }
                  catch(evt:Error)
                  {
                  }
                  this.stopVideo();
                  VodCommon.cookie.remove("posiInfo");
                  _codeObj = {
                     "code":VodCommon.callCode["video"][4],
                     "message":"无插最低码流不存在"
                  };
                  sendNotification(VodNotification.VOD_TIPS,_codeObj);
                  return;
               }
               this.$isStart = true;
               PrintDebug.Trace("点播获取到数据 ===>>>");
               this.$currPlayer.pause();
               this.$skin.playstate = VodCommon.playstate;
               VodParser.sv = 0;
               this.$currPlayer.setVolume(VodParser.sv);
               this.$currPlayer.visible = false;
               this.$currPlayer.originalResize(VodPlay.streamVec[VodPlay.streamIndex].width,VodPlay.streamVec[VodPlay.streamIndex].height);
               if(!VodCommon.isPatch || (VIPPrivilege.isNoad))
               {
                  sendNotification(VodNotification.VOD_PLAY);
               }
               sendNotification(DACNotification.SET_VALUE,VodPlay.start * 1000,DACCommon.NOW);
               if(Global.getInstance()["playmodel"] == "live")
               {
                  sendNotification(DACNotification.DAC_MARK,{
                     "t":new Date().getTime(),
                     "p":"vde"
                  },DACCommon.TDS);
                  sendNotification(DACNotification.STOP_RECORD,null,DACCommon.TDS);
               }
               else if(Global.getInstance()["playmodel"] == "vod")
               {
                  sendNotification(DACNotification.SET_VALUE,VodPlay.streamVec[VodPlay.streamIndex].dt.addr[0].replace(new RegExp(":\\d{1,5}","g"),""),DACCommon.VH);
               }
               
               this.online();
               this._online_inter = setInterval(this.online,this._onlinetime * 1000);
               sendNotification(VodNotification.VOD_ADS_GET_VIDEO,{
                  "video":this.$currPlayer.video,
                  "xml":VodPlay.xml
               });
               if(VodPlay.isFd)
               {
                  ViewManager.getInstance().getMediator("adver").DelAFP();
                  VodCommon.isPatch = false;
                  sendNotification(VodNotification.VOD_PLAY);
               }
               try
               {
                  InteractiveManager.sendEvent(PPLiveEvent.VOD_ONVIDEO_READY,{
                     "duration":VodPlay.duration,
                     "totalbytes":VodPlay.streamVec[VodPlay.streamIndex].drag.fs,
                     "width":VodPlay.streamVec[VodPlay.streamIndex].width,
                     "height":VodPlay.streamVec[VodPlay.streamIndex].height
                  });
               }
               catch(evt:Error)
               {
               }
               break;
            case StreamEvent.STREAM_RESULT:
               sendNotification(DACNotification.DAC_MARK,{
                  "t":new Date().getTime(),
                  "p":"vde"
               },DACCommon.TDS);
               sendNotification(DACNotification.STOP_RECORD,this.$currPlayer.failStr,DACCommon.TDS);
               break;
            case StreamEvent.STREAM_P2PLOG:
               sendNotification(DACNotification.P2PLOG,this.$currPlayer.logObject);
               break;
            case StreamEvent.STREAM_STOP:
               this.nextExecute();
               break;
            case StreamEvent.STREAM_UPDATE:
               $timeObj = {"dur":VodPlay.duration};
               if(Global.getInstance()["playmodel"] == "live")
               {
                  start = Math.floor(new Date().valueOf() / 1000);
                  VodPlay.start = VodPlay.serverTime + (start - VodPlay.localTime);
                  $timeObj["start"] = VodParser.stime;
                  $timeObj["end"] = VodParser.etime;
                  $timeObj["live"] = VodPlay.start;
                  VodPlay.posi = Math.round(this.$currPlayer.timeHack + this.$currPlayer.headTime);
               }
               else if(Global.getInstance()["playmodel"] == "vod")
               {
                  $timeObj["buffer"] = VodPlay.posi + this.$currPlayer.buffer;
                  VodPlay.posi = this.$currPlayer.headTime;
                  if(VodPlay.duration > 5 * 60 && VodPlay.posi < VodPlay.duration - 5 * 60)
                  {
                     VodCommon.cookie.setData("posiInfo",{
                        "cid":VodParser.cid,
                        "posi":VodPlay.posi
                     });
                  }
                  else
                  {
                     VodCommon.cookie.remove("posiInfo");
                  }
               }
               
               $timeObj["posi"] = VodPlay.posi;
               $timeObj["playmodel"] = Global.getInstance()["playmodel"];
               this.$skin.setTimeArea($timeObj);
               this.$skin.setSmartClickTime(VodPlay.posi);
               this.$skin.setSubTitlePosition($timeObj);
               sendNotification(DACNotification.ADD_VALUE,null,DACCommon.VT);
               try
               {
                  InteractiveManager.sendEvent(PPLiveEvent.VOD_ONPROGRESS_CHANGED,{
                     "bytesloaded":$timeObj["buffer"],
                     "timeloaded":$timeObj["posi"]
                  });
               }
               catch(evt:Error)
               {
               }
               ViewManager.getInstance().getMediator("adver").InsertAFP({
                  "vt":int(ViewManager.getInstance().getMediator("dac").dac_report.getValue(DACCommon.VT)),
                  "tp":VodPlay.posi
               });
               ViewManager.getInstance().getMediator("barrage").seekBarrage(VodPlay.posi);
               ViewManager.getInstance().getMediator("smart").headTime = VodPlay.posi;
               if(Global.getInstance()["playmodel"] == "vod")
               {
                  this.$skin.setAccSpeed({
                     "speed":this.$currPlayer.speed,
                     "accSpeed":this.$currPlayer.accSpeed,
                     "bit":VodPlay.streamVec[VodPlay.streamIndex].bitrate
                  });
                  if(VodCommon.isSkipPrelude)
                  {
                     try
                     {
                        i = 0;
                        while(i < VodPlay.contentPoint.length)
                        {
                           if(VodPlay.contentPoint[i]["type"] == "2" && VodPlay.contentPoint[i]["time"] > 0)
                           {
                              if(Math.abs(VodPlay.posi - VodPlay.contentPoint[i]["time"]) == 15)
                              {
                                 this.setTips({
                                    "html":VodCommon.playSkipEndText,
                                    "times":"1",
                                    "display":15 * 1000
                                 });
                              }
                              if(this.$currPlayer.headTime >= VodPlay.contentPoint[i]["time"])
                              {
                                 this.nextExecute();
                              }
                              break;
                           }
                           i++;
                        }
                     }
                     catch(evt:Error)
                     {
                     }
                  }
                  if(!isNaN(VodPlay.fd) && VodPlay.fd > 0)
                  {
                     if(VodPlay.posi > VodPlay.fd)
                     {
                        this.stopVideo();
                        VodCommon.cookie.remove("posiInfo");
                        InteractiveManager.sendEvent(PPLiveEvent.VOD_ONERROR,{"code":VodCommon.callCode["video"][6]});
                        ViewManager.getInstance().getMediator("skin").setTips({
                           "html":CommonUtils.getHtml(VodCommon.playPayFreeEndText.replace(new RegExp("\\[CID\\]","g"),VodParser.cid),"#ffffff"),
                           "times":"0",
                           "display":VodPlay.fd * 1000
                        });
                     }
                  }
                  if(this.$playIndex != this.$currPlayer.playIndex)
                  {
                     this.$playIndex = this.$currPlayer.playIndex;
                     PrintDebug.Trace("当前播放段数 ====>>>> ",this.$playIndex,",","最大播放段数  ===>>> ",Global.getInstance()["checkMaxPlayIndex"](VodPlay.streamIndex));
                     if(this.$playIndex + 1 > Global.getInstance()["checkMaxPlayIndex"](VodPlay.streamIndex) && !VodCommon.isPPAP)
                     {
                        if(VodPlay.streamIndex > 0)
                        {
                           tempIndex = VodPlay.streamIndex;
                           tempIndex--;
                           changeNext = function():void
                           {
                              if(VodPlay.streamVec[tempIndex])
                              {
                                 VodPlay.streamIndex = tempIndex;
                                 switchVideo(VodPlay.streamIndex);
                                 VodCommon.cookie.setData("ft",VodPlay.streamIndex);
                                 $skin.setHdTitle(VodPlay.streamIndex);
                                 _codeObj = {
                                    "code":VodCommon.callCode["video"][5],
                                    "message":"该码流需安装插件播放"
                                 };
                                 sendNotification(VodNotification.VOD_TIPS,_codeObj);
                                 try
                                 {
                                    sendNotification(DACNotification.ADDOBJECTVALUE,{
                                       "at":DACCommon.B_SHOW,
                                       "time":Math.floor(new Date().getTime() / 1000),
                                       "ft":VodPlay.streamIndex,
                                       "mn":$currPlayer.playIndex,
                                       "pos1":DACCommon.B_SMOOTH_NO_PPAP
                                    },DACCommon.BEHA);
                                 }
                                 catch(evt:Error)
                                 {
                                 }
                              }
                              else if(tempIndex > 0)
                              {
                                 tempIndex--;
                                 changeNext();
                              }
                              else
                              {
                                 try
                                 {
                                    sendNotification(DACNotification.ADDOBJECTVALUE,{
                                       "at":DACCommon.B_SHOW,
                                       "time":Math.floor(new Date().getTime() / 1000),
                                       "ft":VodPlay.streamIndex,
                                       "mn":$currPlayer.playIndex,
                                       "pos1":DACCommon.B_FORCE_PPAP
                                    },DACCommon.BEHA);
                                 }
                                 catch(evt:Error)
                                 {
                                 }
                                 stopVideo();
                                 VodCommon.cookie.remove("posiInfo");
                                 _codeObj = {
                                    "code":VodCommon.callCode["video"][4],
                                    "message":"无插最低码流不存在"
                                 };
                                 sendNotification(VodNotification.VOD_TIPS,_codeObj);
                                 return;
                              }
                              
                           };
                           changeNext();
                        }
                        else
                        {
                           try
                           {
                              sendNotification(DACNotification.ADDOBJECTVALUE,{
                                 "at":DACCommon.B_SHOW,
                                 "time":Math.floor(new Date().getTime() / 1000),
                                 "ft":VodPlay.streamIndex,
                                 "mn":this.$currPlayer.playIndex,
                                 "pos1":DACCommon.B_FORCE_PPAP
                              },DACCommon.BEHA);
                           }
                           catch(evt:Error)
                           {
                           }
                           this.stopVideo();
                           VodCommon.cookie.remove("posiInfo");
                           _codeObj = {
                              "code":VodCommon.callCode["video"][4],
                              "message":"无插最低码流不存在"
                           };
                           sendNotification(VodNotification.VOD_TIPS,_codeObj);
                           return;
                        }
                     }
                  }
               }
               if(Global.getInstance()["playmodel"] == "live")
               {
                  if(VodPlay.posi >= VodParser.etime)
                  {
                     this.nextExecute();
                  }
               }
               if(this.$skin.loadingMc.visible)
               {
                  this.$skin.showLoading(true,this.getBufferProgress());
               }
               break;
            case StreamEvent.STREAM_SEEK:
               sendNotification(DACNotification.STOP_RECORD,null,DACCommon.TDD);
               break;
            case StreamEvent.STREAM_EMPTY:
               if(this._buffer_inter)
               {
                  clearTimeout(this._buffer_inter);
               }
               if(this.$isStart)
               {
                  this._buffer_inter = setTimeout(function():void
                  {
                     if(_bufferCountArr.length < 5)
                     {
                        _bufferCountArr.push(getTimer());
                        if(_bufferCountArr.length == 5)
                        {
                           if(_bufferCountArr[4] - _bufferCountArr[0] <= 60 * 1000)
                           {
                              if(!VodCommon.playStr && !VodCommon.smart && !VodCommon.priplay)
                              {
                                 setTips({
                                    "html":CommonUtils.getHtml(VodCommon.playSmoothText,"#ffffff"),
                                    "times":"1",
                                    "display":15 * 1000
                                 });
                              }
                              sendNotification(DACNotification.ADDOBJECTVALUE,{
                                 "at":DACCommon.B_CLK,
                                 "time":Math.floor(new Date().getTime() / 1000),
                                 "pos1":DACCommon.B_SMOOTH_DELAY
                              },DACCommon.BEHA);
                           }
                           _bufferCountArr.shift();
                        }
                     }
                     $skin.showLoading(true,getBufferProgress());
                     InteractiveManager.sendEvent(PPLiveEvent.VOD_ONPLAYSTATE_CHANGED,"4");
                     if(!VodCommon.isPatch && !$currPlayer.isInitStart && !$currPlayer.isInitSeek)
                     {
                        if(VodCommon.isEmpty)
                        {
                           sendNotification(DACNotification.START_RECORD,null,DACCommon.BS);
                           sendNotification(DACNotification.ADD_VALUE,null,DACCommon.BF);
                        }
                     }
                  },50);
               }
               else
               {
                  this.$skin.showLoading();
               }
               break;
            case StreamEvent.STREAM_FULL:
               this.$skin.showLoading(false);
               if(this._buffer_inter)
               {
                  clearTimeout(this._buffer_inter);
               }
               if(!this.$currPlayer.isInitStart && !this.$currPlayer.isInitSeek)
               {
                  sendNotification(DACNotification.STOP_RECORD,null,DACCommon.BS);
               }
               break;
            case StreamEvent.STREAM_FAILED:
               sendNotification(DACNotification.DAC_MARK,{
                  "t":new Date().getTime(),
                  "p":"vde"
               },DACCommon.TDS);
               sendNotification(DACNotification.ERROR,Global.getInstance()["playmodel"] == "vod"?this.$currPlayer.failStr:null,DACCommon.ERROR_BOOSTFAILED);
               $obj = {"code":VodCommon.callCode["video"][1]};
               this.$skin.showError({
                  "title":temp.replace(new RegExp("%code%","g"),$obj["code"]),
                  "type":"error"
               });
               break;
            case "_video_change_":
               this.markResize();
               sendNotification(VodNotification.VOD_STAGEVIDEO);
               break;
            case "_stream_started_":
               sendNotification(DACNotification.SET_VALUE,this.$currPlayer.host == "127.0.0.1:9000"?this.$currPlayer.host:this.$currPlayer.host.replace(new RegExp(":\\d{1,5}","g"),""),DACCommon.VH);
               break;
            case "_play_error_":
               sendNotification(DACNotification.ERROR,Global.getInstance()["playmodel"] == "vod"?this.$currPlayer.failStr:null,DACCommon.ERROR_PLAYFAILED);
               $obj = {"code":VodCommon.callCode["video"][1]};
               temp = VodCommon.playErrorText;
               this.$skin.showError({
                  "title":temp.replace(new RegExp("%code%","g"),$obj["code"]),
                  "type":"error"
               });
               break;
         }
      }
      
      public function respondToVodTips(param1:INotification) : void
      {
         var _loc2_:Object = param1.getBody();
         if((_loc2_) && (!(_loc2_["code"] == undefined)) && !(_loc2_["code"].indexOf("3004") == -1))
         {
            this.$skin.showError({"type":"ppap"});
            InteractiveManager.sendEvent(PPLiveEvent.VOD_ONERROR,_loc2_);
         }
         else
         {
            this.setTips({
               "html":CommonUtils.getHtml(VodCommon.installPPAPText,"#ffffff"),
               "times":"1",
               "display":15 * 1000
            });
         }
      }
      
      public function respondToVodRecommend(param1:INotification) : void
      {
         var note:INotification = param1;
         if(!this.$recommend)
         {
            var onRecomHandler:Function = function(param1:Event):void
            {
               var _loc2_:Object = null;
               switch(param1.type)
               {
                  case "_replay_":
                     playVideo($pObj);
                     break;
                  case SkinEvent.MEDIA_RECOMMEND_CLICK:
                     try
                     {
                        _loc2_ = param1["currObj"];
                        sendNotification(DACNotification.ADDOBJECTVALUE,{
                           "at":DACCommon.B_CLK,
                           "time":Math.floor(new Date().getTime() / 1000),
                           "uuid":_loc2_.Uuid,
                           "src":"22",
                           "channelid":_loc2_.channeled,
                           "pos1":DACCommon.B_RECOMMEND
                        },DACCommon.BEHA);
                        CommonUtils.getURL(_loc2_.link);
                        InteractiveManager.sendEvent(PPLiveEvent.VOD_ONNOTIFICATION,{
                           "header":{"type":"recomclick"},
                           "body":{"data":{
                              "uuid ":_loc2_.Uuid,
                              "src":"22",
                              "channelid":_loc2_.channeled,
                              "sadr":_loc2_.link,
                              "n":_loc2_.title,
                              "puid":VodCommon.puid
                           }}
                        });
                     }
                     catch(evt:Error)
                     {
                     }
                     break;
                  case "_share_":
                     if($skin)
                     {
                        $skin.openAdjustUI("share_mc");
                     }
                     break;
               }
            };
            this.$recommend = new RecommendBox();
            this.$skin.addChild(this.$recommend);
            try
            {
               this.$skin.setChildIndex(this.$skin.adjustMc,this.$skin.numChildren - 1);
               this.$skin.setChildIndex(this.$recommend,this.$skin.getChildIndex(this.$skin.controlMc));
            }
            catch(evt:Error)
            {
            }
            this.$recommend.addEventListener("_share_",onRecomHandler);
            this.$recommend.addEventListener("_replay_",onRecomHandler);
            this.$recommend.addEventListener(SkinEvent.MEDIA_RECOMMEND_CLICK,onRecomHandler);
         }
         this.$recommend.recom = note.getBody()["items"] as Vector.<RecommendItem>;
         this.$recommend.requestUUID = note.getBody()["uuid"];
         this.$recommend.setSize(VodCommon.playerWidth,VodCommon.playerHeight);
         this.$recommend.shareDisable(VodPlay.shareDisable);
      }
      
      public function respondToVodNext(param1:INotification) : void
      {
         var note:INotification = param1;
         this._afterads_inter = setTimeout(function():void
         {
            sendNotification(VodNotification.VOD_AFTER_PATCH);
         },2 * 1000);
         InteractiveManager.sendEvent(PPLiveEvent.VOD_ONNOTIFICATION,{
            "header":{"type":"nextvideo"},
            "body":{"data":{"autoPlayNext":(this.videoAutoPlayNext?1:0)}}
         });
      }
      
      public function respondToVodVipPlay(param1:INotification) : void
      {
         this.setTips({
            "html":VodCommon.playVipTipTexT,
            "times":"0",
            "display":30 * 1000
         });
      }
      
      public function respondToVodSharedisable(param1:INotification) : void
      {
         if(this.$recommend)
         {
            this.$recommend.shareDisable(param1.getBody());
         }
         if(this.$skin)
         {
            this.$skin.uiShareDisable(param1.getBody());
         }
      }
      
      public function respondToVodMark(param1:INotification) : void
      {
         try
         {
            if(this.$mark)
            {
               if((this.$markContainer) && (this.$mark.parent))
               {
                  this.$markContainer.removeChild(this.$mark);
               }
               this.$mark = null;
            }
            this.$mark = param1.getBody()["content"] as DisplayObject;
            this.markResize();
            this.updataSmartClickUI();
         }
         catch(evt:Error)
         {
         }
      }
      
      public function respondToVodMarkAdv(param1:INotification) : void
      {
         try
         {
            if(this.$markAdv)
            {
               if((this.$markContainer) && (this.$markAdv.parent))
               {
                  this.$markContainer.removeChild(this.$markAdv);
               }
               this.$markAdv = null;
            }
            this.$markAdv = param1.getBody()["content"] as DisplayObject;
            this.markResize();
         }
         catch(evt:Error)
         {
         }
      }
      
      public function respondToVodSetProgress(param1:INotification) : void
      {
         if(this.skin)
         {
            this.skin.progressEnable = param1.getBody();
         }
      }
      
      public function respondToVodShowSubTitle(param1:INotification) : void
      {
         if(this.skin)
         {
            this.skin.changeSubTitle(param1.getBody());
         }
      }
      
      public function respondToVodSubTitleInfo(param1:INotification) : void
      {
         if(this.skin)
         {
            this.skin.setTitleListInfo(param1.getBody());
         }
      }
      
      private function markResize() : void
      {
         var _loc1_:Rectangle = null;
         var _loc2_:* = NaN;
         var _loc3_:* = NaN;
         var _loc4_:String = null;
         var _loc5_:* = NaN;
         try
         {
            if(!this.$currPlayer)
            {
               return;
            }
            this.$currPlayer.addChild(this.$markContainer);
            if(this.$mark)
            {
               this.$markContainer.addChild(this.$mark);
               this.$mark.x = -this.$mark.width;
               this.$mark.y = -this.$mark.height;
               _loc1_ = Global.getInstance()["rect"] as Rectangle;
               if(isNaN(this.$initW))
               {
                  this.$initW = _loc1_.width;
               }
               if(!VodPlay.markObj || !VodPlay.markObj["url"] || VodPlay.markObj["aw"] == 0)
               {
                  this.$mark.scaleX = this.$mark.scaleY = _loc1_.width / this.$initW;
               }
               else
               {
                  _loc5_ = this.$mark.width / this.$mark.height;
                  this.$mark.width = _loc1_.width * VodPlay.markObj["aw"];
                  this.$mark.height = this.$mark.width / _loc5_;
               }
               _loc2_ = (VodPlay.markObj["ax"]) || (1 / 24);
               _loc3_ = (VodPlay.markObj["ay"]) || (1 / 12);
               _loc4_ = VodPlay.markObj["align"];
               switch(_loc4_)
               {
                  case "lefttop":
                     this.$mark.x = _loc1_.x + _loc1_.width * _loc2_;
                     this.$mark.y = _loc1_.y + _loc1_.height * _loc3_;
                     break;
                  case "leftbottom":
                     this.$mark.x = _loc1_.x + _loc1_.width * _loc2_;
                     this.$mark.y = _loc1_.y + (_loc1_.height * (1 - _loc3_) - this.$mark.height);
                     break;
                  case "rightbottom":
                     this.$mark.x = _loc1_.x + (_loc1_.width * (1 - _loc2_) - this.$mark.width);
                     this.$mark.y = _loc1_.y + (_loc1_.height * (1 - _loc3_) - this.$mark.height);
                     break;
                  case "righttop":
                  default:
                     this.$mark.x = _loc1_.x + (_loc1_.width * (1 - _loc2_) - this.$mark.width);
                     this.$mark.y = _loc1_.y + _loc1_.height * _loc3_;
               }
            }
            if(this.$markAdv)
            {
               this.$markContainer.addChild(this.$markAdv);
               this.$markAdv.x = this.$mark?this.$mark.x:-this.$markAdv.width;
               this.$markAdv.y = this.$mark?this.$mark.height + this.$mark.y + 10:-this.$markAdv.height;
               this.$markAdv.scaleX = this.$mark.scaleX;
               this.$markAdv.scaleY = this.$mark.scaleY;
            }
            if(VodPlay.markObj["diaphaneity"])
            {
               this.$markContainer.alpha = VodPlay.markObj["diaphaneity"] / 100;
            }
         }
         catch(evt:Error)
         {
         }
      }
      
      public function respondToVodPlay(param1:INotification) : void
      {
         var _loc2_:* = 0;
         if(!this.$currPlayer)
         {
            return;
         }
         this.$skin.controlEnable = true;
         if(!VodPlay.barrage)
         {
            this.$skin.setBarrage();
         }
         else if(!ViewManager.getInstance().getMediator("barrage").content)
         {
            ViewManager.getInstance().getProxy("barrage").reset();
            ViewManager.getInstance().getProxy("barrage").initData();
         }
         else
         {
            this.$skin.setBarrage(VodPlay.barrage);
         }
         
         this.$currPlayer.visible = true;
         if(!isNaN(VodParser.sv) && !(VodParser.sv == 0))
         {
            VodCommon.cookie.setData("vol",VodParser.sv);
         }
         else if(VodCommon.cookie.contains("vol"))
         {
            VodParser.sv = VodCommon.cookie.getData("vol");
         }
         else
         {
            VodParser.sv = VodCommon.volume;
            VodCommon.cookie.setData("vol",VodParser.sv);
         }
         
         this.setVolume(VodParser.sv);
         if((Global.getInstance()["playmodel"] == "vod" && VodCommon.isSkipPrelude) && (VodPlay.contentPoint) && !(VodCommon.playstate == "playing"))
         {
            _loc2_ = 0;
            while(_loc2_ < VodPlay.contentPoint.length)
            {
               if(VodPlay.contentPoint[_loc2_]["type"] == "1" && VodPlay.contentPoint[_loc2_]["time"] > 0)
               {
                  this.setTips({
                     "html":VodCommon.playSkipStartText,
                     "times":"1",
                     "display":5 * 1000
                  });
                  break;
               }
               _loc2_++;
            }
         }
         this.playVideo();
         try
         {
            if(VodCommon.isSV)
            {
               this.$skin.startFreshMc.visible = false;
            }
         }
         catch(evt:Error)
         {
         }
         this.$skin.setTitle(VodCommon.title,VodCommon.isHttpRequest,VodPlay.nm);
         try
         {
            ViewManager.getInstance().getMediator("adver").tempContent.visible = false;
         }
         catch(evt:Error)
         {
         }
         ViewManager.getInstance().getProxy("mark").initData();
         InteractiveManager.sendEvent(PPLiveEvent.VOD_ONPLAYSTATE_CHANGED,"3",{"cs":(VodPlay.shareDisable?0:1)});
         if(!ViewManager.getInstance().getMediator("smart").content)
         {
            ViewManager.getInstance().getProxy("smart").initData();
         }
         else
         {
            ViewManager.getInstance().getMediator("smart").setSize(VodCommon.playerWidth,VodCommon.playerHeight);
         }
      }
      
      public function respondToVodDataRequest(param1:INotification) : void
      {
         var _loc2_:ContextMenu = null;
         var _loc3_:Object = null;
         sendNotification(DACNotification.DAC_MARK,{
            "t":new Date().getTime(),
            "p":"vds"
         },DACCommon.TDS);
         sendNotification(DACNotification.SET_VALUE,VodPlay.duration,DACCommon.DU);
         if(Global.getInstance()["root"])
         {
            _loc2_ = Global.getInstance()["root"].contextMenu;
            _loc2_.customItems.push(new ContextMenuItem("Build " + Global.getInstance()["playmodel"] + "kernel " + this.$kernelVersion));
            Global.getInstance()["root"].contextMenu = _loc2_;
         }
         this.$skin.hideError();
         try
         {
            _loc3_ = {"videoTimeTotal":VodPlay.duration};
            if(VodPlay.adverPoint.length > 0)
            {
               _loc3_["triggerPoints"] = VodPlay.adverPoint;
            }
            ViewManager.getInstance().getMediator("adver").content["videoTimeInfo"] = _loc3_;
         }
         catch(evt:Error)
         {
         }
         this.$skin.setTitle("",VodCommon.isHttpRequest,VodPlay.nm);
         this.smartClickData();
         this.resetStreamRadio();
         this.setSkipPrelude();
         this.startUpPlayer();
         try
         {
            VodCommon.title = VodCommon.title || VodPlay.nm;
            VodCommon.link = VodCommon.link || VodPlay.lk;
            this.$skin.setShare(Global.getInstance()["share"],{
               "link":VodCommon.link,
               "swf":VodCommon.swf
            });
         }
         catch(evt:Error)
         {
         }
      }
      
      private function setSkipPrelude() : void
      {
         if(VodCommon.cookie.contains("skip_prelude"))
         {
            VodCommon.isSkipPrelude = VodCommon.cookie.getData("skip_prelude");
         }
         PrintDebug.Trace("设置是否跳过片头  ===>>>  ",VodCommon.isSkipPrelude);
         this.$skin.setSkipPrelude({
            "skip":VodCommon.isSkipPrelude,
            "point":VodPlay.contentPoint
         });
      }
      
      private function resetStreamRadio() : void
      {
         var _loc1_:* = 0;
         var _loc2_:Array = null;
         var _loc3_:Object = null;
         try
         {
            _loc1_ = 0;
            _loc2_ = [];
            while(_loc1_ < VodPlay.streamVec.length)
            {
               _loc3_ = {
                  "ft":(VodPlay.streamVec[_loc1_]?VodPlay.streamVec[_loc1_].ft:_loc1_),
                  "vip":(VodPlay.streamVec[_loc1_]?VodPlay.streamVec[_loc1_].vip:null),
                  "enabled":false
               };
               if(VodPlay.streamVec[_loc1_])
               {
                  _loc3_["enabled"] = true;
                  if(!(VodPlay.streamVec[_loc1_].vip == "0") && !VodParser.bray)
                  {
                     _loc3_["enabled"] = false;
                  }
               }
               _loc2_.push(_loc3_);
               _loc1_++;
            }
            PrintDebug.Trace("设置码流选项 ===>>> ",_loc2_);
            this.$skin.setStream(_loc2_,VodPlay.streamIndex);
         }
         catch(evt:Error)
         {
         }
      }
      
      public function setTips(param1:Object) : void
      {
         if(this.$skin)
         {
            this.$skin.setPlayerTip(param1);
         }
      }
      
      public function respondToVodCloudDargComplete(param1:INotification) : void
      {
         if(this.$skin)
         {
            this.$skin.setColumnData(param1.getBody());
         }
      }
      
      public function updataAccelerateState() : void
      {
         PrintDebug.Trace("playmodel====>" + this.$kernelObj["playmodel"]);
         if(!this.$skin || !this.$kernelObj["playmodel"])
         {
            return;
         }
         PrintDebug.Trace("更新加速状态");
         if(this.$kernelObj["playmodel"] == "vod")
         {
            if((VodCommon.isPPAP) && ((VIPPrivilege.isVip) || (VIPPrivilege.isSpdup)))
            {
               this.$skin.setAccelerateState(AccelerateUI.VIP_PPVA);
            }
            else if(!VodCommon.isPPAP && ((VIPPrivilege.isVip) || (VIPPrivilege.isSpdup)))
            {
               this.$skin.setAccelerateState(AccelerateUI.VIP_NO_PPVA);
            }
            else
            {
               this.$skin.setAccelerateState(AccelerateUI.NO_MEMBER);
            }
            
         }
         else if(this.$kernelObj["playmodel"] == "live")
         {
            this.$skin.setAccelerateState();
         }
         
      }
      
      public function smartClickData() : void
      {
         PrintDebug.Trace("设置视频点击广告数据 >>> ",VodPlay.smartItem);
         if(this.$skin)
         {
            this.$skin.smartClickData((VIPPrivilege.isVip) || (VIPPrivilege.isNoad)?null:VodPlay.smartItem);
         }
      }
      
      public function updataSmartClickUI() : void
      {
         if((this.$skin) && (this.$skin.smartClickPanel))
         {
            this.$skin.smartClickPanel.resize(Global.getInstance()["rect"]);
         }
      }
      
      public function getBufferProgress() : Number
      {
         var _loc1_:Number = 0;
         try
         {
            if(this.$currPlayer)
            {
               _loc1_ = Math.abs(Math.round(this.$currPlayer.buffer / this.$currPlayer.bufferTime * 100));
            }
         }
         catch(evt:Error)
         {
         }
         _loc1_ = _loc1_ >= 100?100:_loc1_;
         return _loc1_;
      }
      
      public function setBfrRecord(param1:String = "") : void
      {
         if((param1) && param1.length > 0)
         {
            PrintDebug.Trace("setBfrRecord value >>>>>> ",param1);
            sendNotification(DACNotification.SET_VALUE,param1,DACCommon.SBR);
         }
      }
   }
}
