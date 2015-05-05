package
{
   import flash.display.Sprite;
   import cn.pplive.player.utils.loader.DataLoader;
   import flash.events.Event;
   import cn.pplive.player.utils.PrintDebug;
   import flash.system.Capabilities;
   import cn.pplive.player.common.VodCommon;
   import flash.display.StageScaleMode;
   import flash.display.StageAlign;
   import flash.text.TextField;
   import cn.pplive.player.utils.CommonUtils;
   import cn.pplive.player.utils.PageURLQuery;
   import cn.pplive.player.utils.hash.Global;
   import cn.pplive.player.common.VodParser;
   import cn.pplive.player.view.source.CTXQuery;
   import cn.pplive.player.manager.InteractiveManager;
   import flash.utils.setTimeout;
   import cn.pplive.player.events.PPLiveEvent;
   import cn.pplive.player.manager.ViewManager;
   import flash.utils.getQualifiedClassName;
   import flash.net.URLRequest;
   import com.adobe.serialization.json.JSON;
   import flash.external.ExternalInterface;
   import flash.utils.describeType;
   import flash.utils.getDefinitionByName;
   import cn.pplive.player.common.VodPlay;
   import flash.display.BitmapData;
   import flash.system.Security;
   
   public class VodFacade extends Sprite
   {
      
      private var $config:Object = null;
      
      private var $aplusUrl:String = null;
      
      private var $lo:DataLoader;
      
      private var $et:TextField;
      
      private var aplusNum:int = 0;
      
      public function VodFacade()
      {
         super();
         Security.allowDomain("*");
         Security.allowInsecureDomain("*");
         if(stage)
         {
            this.initStage();
         }
         else
         {
            addEventListener(Event.ADDED_TO_STAGE,this.initStage);
         }
      }
      
      private function initStage(param1:Event = null) : void
      {
         removeEventListener(Event.ADDED_TO_STAGE,this.initStage);
         PrintDebug.Trace("播放器正在初始化，当前flash player版本 >>>>> " + Capabilities.version," ，播放器版本 ===>>> " + VodCommon.version);
         stage.scaleMode = StageScaleMode.NO_SCALE;
         stage.align = StageAlign.TOP_LEFT;
         stage.stageFocusRect = false;
         if(stage.stageWidth == 0 || stage.stageHeight == 0)
         {
            stage.addEventListener(Event.RESIZE,this.onInitResizeHandler);
         }
         else
         {
            this.init();
         }
      }
      
      private function onInitResizeHandler(param1:Event) : void
      {
         if(stage.stageWidth > 0 && stage.stageHeight > 0)
         {
            stage.removeEventListener(Event.RESIZE,this.onInitResizeHandler);
            this.init();
         }
      }
      
      private function addErrorTips(param1:String) : void
      {
         this.$et = CommonUtils.addDynamicTxt();
         this.$et.htmlText = CommonUtils.getHtml(param1,"#0099FF");
         addChild(this.$et);
      }
      
      private function errorTipResize() : void
      {
         if(this.$et)
         {
            this.$et.x = stage.stageWidth - this.$et.width >> 1;
            this.$et.y = stage.stageHeight - this.$et.height >> 1;
         }
      }
      
      private function init() : void
      {
         if(CommonUtils.getVersion() <= 10.1)
         {
            this.addErrorTips(VodCommon.VersionText);
            this.$et.width = 390;
            this.$et.mouseEnabled = true;
            this.errorTipResize();
            return;
         }
         PageURLQuery.setURLQuery();
         Global.getInstance()["facade"] = this;
         VodParser.paramObj = loaderInfo.parameters;
         VodCommon.pid = this.getParam("pid",VodParser.paramObj);
         if(this.getParam("api",VodParser.paramObj) != null)
         {
            Global.getInstance()["api"] = this.getParam("api",VodParser.paramObj);
         }
         if(this.getParam("asc",VodParser.paramObj) != null)
         {
            VodCommon.allowScreenClick = this.getParam("asc",VodParser.paramObj);
         }
         if(this.getParam("act",VodParser.paramObj) != null)
         {
            VodCommon.allowInteractive = this.getParam("act",VodParser.paramObj);
         }
         if(this.getParam("title",VodParser.paramObj) != null)
         {
            VodCommon.title = this.getParam("title",VodParser.paramObj);
         }
         if(this.getParam("link",VodParser.paramObj) != null)
         {
            VodCommon.link = this.getParam("link",VodParser.paramObj);
         }
         if(this.getParam("swf",VodParser.paramObj) != null)
         {
            VodCommon.swf = this.getParam("swf",VodParser.paramObj);
         }
         if(this.getParam("clid",VodParser.paramObj) != null)
         {
            VodCommon.clid = this.getParam("clid",VodParser.paramObj);
         }
         if(this.getParam("type",VodParser.paramObj) != null)
         {
            VodCommon.playType = this.getParam("type",VodParser.paramObj);
         }
         if(this.getParam("smart",VodParser.paramObj) != null)
         {
            VodCommon.smart = this.getParam("smart",VodParser.paramObj);
         }
         if(this.getParam("priplay",VodParser.paramObj) != null)
         {
            VodCommon.priplay = this.getParam("priplay",VodParser.paramObj);
         }
         if(this.getParam("playStr",VodParser.paramObj) != null)
         {
            VodCommon.playStr = this.getParam("playStr",VodParser.paramObj);
         }
         if(this.getParam("vw",VodParser.paramObj) != null)
         {
            VodParser.vw = Number(this.getParam("vw",VodParser.paramObj));
         }
         if(this.getParam("vh",VodParser.paramObj) != null)
         {
            VodParser.vh = Number(this.getParam("vh",VodParser.paramObj));
         }
         if(this.getParam("o",VodParser.paramObj) != null)
         {
            VodParser.os = this.getParam("o",VodParser.paramObj);
         }
         if(this.getParam("ctx",VodParser.paramObj) != null)
         {
            CTXQuery.setCTX(this.getParam("ctx",VodParser.paramObj));
         }
         if(this.getParam("advars",VodParser.paramObj) != null)
         {
            VodParser.advars = this.getParam("advars",VodParser.paramObj);
         }
         if(this.getParam("stime",VodParser.paramObj) != null)
         {
            VodParser.stime = this.getParam("stime",VodParser.paramObj);
         }
         if(this.getParam("etime",VodParser.paramObj) != null)
         {
            VodParser.etime = this.getParam("etime",VodParser.paramObj);
         }
         InteractiveManager.callEvent("setCallback",this.setCallback);
         InteractiveManager.callEvent("playVideo",this.playVideo);
         InteractiveManager.callEvent("pauseVideo",this.pauseVideo);
         InteractiveManager.callEvent("stopVideo",this.stopVideo);
         InteractiveManager.callEvent("seekVideo",this.seekVideo);
         InteractiveManager.callEvent("setVolume",this.setVolume);
         InteractiveManager.callEvent("setAdvMute",this.setAdvMute);
         InteractiveManager.callEvent("getVolume",this.getVolume);
         InteractiveManager.callEvent("getSnapshot",this.getSnapshot);
         InteractiveManager.callEvent("getVersion",this.getVersion);
         InteractiveManager.callEvent("setSize",this.setSize);
         InteractiveManager.callEvent("setMute",this.setMute);
         InteractiveManager.callEvent("setTips",this.setTips);
         InteractiveManager.callEvent("playTime",this.playTime);
         InteractiveManager.callEvent("duration",this.duration);
         InteractiveManager.callEvent("setBfrRecord",this.setBfrRecord);
         setTimeout(function():void
         {
            InteractiveManager.callEvent("setCtx",setCtx);
            InteractiveManager.callEvent("setConfig",setConfig);
            InteractiveManager.callEvent("hasPPAP",hasPPAP);
            InteractiveManager.sendEvent(PPLiveEvent.VOD_ONINIT);
            InteractiveManager.sendEvent(PPLiveEvent.VOD_ONPLAYSTATE_CHANGED,"1");
            $aplusUrl = VodParser.aplus + "/pid/" + VodCommon.pid;
            $aplusUrl = $aplusUrl + ("?version=" + VodCommon.version);
            $aplusUrl = $aplusUrl + ("&o=" + (CTXQuery.contain("o")?CTXQuery.getAttr("o"):VodParser.os));
            aplusRequest();
         },0);
      }
      
      public function setCallback(param1:String, param2:Object = null) : void
      {
         PrintDebug.Trace("setCallback 接口被调用，获取 数据 ==>> ",param1,",",param2);
         if(param1 == "userinfo")
         {
            this.setUserInfo(param2);
         }
         else if(param1 == "theatre")
         {
            VodCommon.isTheatre = Boolean(param2["body"]["data"]["mode"]);
            try
            {
               ViewManager.getInstance().getMediator("skin").skin.setTheatre(VodCommon.isTheatre);
            }
            catch(e:Error)
            {
            }
         }
         else if(param1 == "barragesetting")
         {
            try
            {
               Global.getInstance()["setBarrageInfo"](param2["body"]["data"]);
            }
            catch(e:Error)
            {
            }
         }
         else if(param1 == "sendbarrage")
         {
            try
            {
               Global.getInstance()["sendBarrage"](param2["body"]["data"]);
            }
            catch(e:Error)
            {
            }
         }
         
         
         
      }
      
      public function getEventClass() : String
      {
         return getQualifiedClassName(PPLiveEvent);
      }
      
      private function setUserInfo(param1:Object = null) : void
      {
         VodCommon.isHttpRequest = false;
         PrintDebug.Trace("setUserInfo 接口被调用，获取 userinfo 数据 ==>> ",param1);
         try
         {
            Global.getInstance()["setUserInfo"](param1);
         }
         catch(e:Error)
         {
         }
      }
      
      public function setCtx(param1:String = null) : void
      {
         VodCommon.isHttpRequest = false;
         PrintDebug.Trace("setCtx 接口被调用，获取 ctx 数据 ==>> ",param1);
         if(param1)
         {
            CTXQuery.setCTX(param1);
         }
      }
      
      public function setConfig(param1:Object) : void
      {
         VodCommon.isHttpRequest = false;
         this.$config = param1;
         PrintDebug.Trace("setConfig 接口被调用，获取 config 数据 ==>> ",this.$config);
      }
      
      public function hasPPAP() : void
      {
         VodCommon.isPPAP = true;
         Global.getInstance()["updataAccelerateState"]();
         PrintDebug.Trace("外部 javascript 已经检测到PPAP......");
      }
      
      private function aplusRequest() : void
      {
         PrintDebug.Trace("aplus 请求地址  ===>>>  ",this.$aplusUrl);
         this.$lo = new DataLoader(new URLRequest(this.$aplusUrl),10);
         this.$lo.addEventListener("_complete_",this.onContentHandler);
         this.$lo.addEventListener("_ioerror_",this.onContentHandler);
         this.$lo.addEventListener("_securityerror_",this.onContentHandler);
         this.$lo.addEventListener("_timeout_",this.onContentHandler);
      }
      
      private function onContentHandler(param1:Event) : void
      {
         var _loc2_:Object = null;
         var _loc3_:Object = null;
         switch(param1.type)
         {
            case "_ioerror_":
            case "_securityerror_":
            case "_timeout_":
               this.$lo.clear();
               if(this.aplusNum < 1)
               {
                  this.aplusNum++;
                  this.aplusRequest();
               }
               else
               {
                  this.addErrorTips(VodCommon.initErrorText);
                  this.$et.wordWrap = this.$et.multiline = false;
                  this.errorTipResize();
                  _loc2_ = {};
                  if(param1.type == "_ioerror_")
                  {
                     _loc2_["code"] = VodCommon.callCode["config"][1];
                  }
                  else if(param1.type == "_securityerror_")
                  {
                     _loc2_["code"] = VodCommon.callCode["config"][2];
                  }
                  else if(param1.type == "_timeout_")
                  {
                     _loc2_["code"] = VodCommon.callCode["config"][3];
                  }
                  
                  
                  _loc2_["message"] = param1.target.errorMsg;
                  InteractiveManager.sendEvent(PPLiveEvent.VOD_ONERROR,_loc2_);
               }
               break;
            case "_complete_":
               try
               {
                  _loc3_ = com.adobe.serialization.json.JSON.decode(param1.target.content as String);
                  if(_loc3_["err"] != 0)
                  {
                     this.addErrorTips(VodCommon.initErrorText);
                     this.$et.wordWrap = this.$et.multiline = false;
                     this.errorTipResize();
                     return;
                  }
                  PrintDebug.Trace("远端请求数据  ",_loc3_);
                  this.$config = this.$config?CommonUtils.mix(_loc3_,this.$config):_loc3_;
                  PrintDebug.Trace("最终合并数据  ",this.$config);
                  this.ergodic();
               }
               catch(evt:Error)
               {
               }
               break;
         }
      }
      
      private function ergodic() : void
      {
         var i:String = null;
         var setting:Object = null;
         for(i in this.$config)
         {
            if(this.$config[i] != undefined)
            {
               Global.getInstance()[i] = this.$config[i];
            }
         }
         setting = Global.getInstance()["setting"];
         if(setting)
         {
            VodParser.acb = this.getParam("acb",setting);
            VodParser.afp = this.getParam("afp",setting);
            VodParser.fimg = this.getParam("fimg",setting);
            VodParser.lu = this.getParam("lu",setting);
            VodParser.barrage = this.getParam("barrage",setting);
            VodParser.rp = CommonUtils.bool(this.getParam("rp",VodParser.paramObj)?this.getParam("rp",VodParser.paramObj):this.getParam("rp",setting));
            VodParser.ap = CommonUtils.bool(this.getParam("ap",VodParser.paramObj)?this.getParam("ap",VodParser.paramObj):this.getParam("ap",setting));
            VodParser.hl = CommonUtils.bool(this.getParam("hl",VodParser.paramObj)?this.getParam("hl",VodParser.paramObj):this.getParam("hl",setting));
            VodParser.ph = this.getParam("ph",setting) || VodParser.ph;
            if(this.getParam("advars",setting) != null)
            {
               VodParser.advars = this.getParam("advars",setting);
            }
            if(this.getParam("am",setting) != null)
            {
               VodParser.am = CommonUtils.bool(this.getParam("am",setting));
            }
            if(this.getParam("bray",setting) != null)
            {
               VodParser.bray = CommonUtils.bool(this.getParam("bray",setting));
            }
            if(this.getParam("sv",setting) != null)
            {
               VodParser.sv = Number(this.getParam("sv",setting));
            }
            if(this.getParam("sa",setting) != null)
            {
               VodParser.sa = this.getParam("sa",setting);
            }
            if(this.getParam("ads",setting) != null)
            {
               VodParser.ads = this.getParam("ads",setting);
            }
            if(this.getParam("stat",setting) != null)
            {
               VodParser.stat = this.getParam("stat",setting);
            }
            if(!(this.getParam("o",setting) == null) || !(VodParser.os == "-1"))
            {
               VodParser.os = VodParser.os || this.getParam("o",setting);
            }
            if(this.getParam("vodcore",setting) != null)
            {
               VodParser.vodcore = this.getParam("vodcore",setting);
            }
            if(this.getParam("ru",setting) != null)
            {
               VodParser.ru = this.getParam("ru",setting);
            }
         }
         if(CTXQuery.contain("lm"))
         {
            VodParser.lm = CommonUtils.bool(CTXQuery.getAttr("lm"));
         }
         if(CTXQuery.contain("type"))
         {
            VodCommon.playType = CTXQuery.getAttr("type");
         }
         if(CTXQuery.contain("o"))
         {
            VodParser.os = CTXQuery.getAttr("o");
         }
         if(CTXQuery.contain("stime"))
         {
            VodParser.stime = Number(CTXQuery.getAttr("stime"));
         }
         if(CTXQuery.contain("etime"))
         {
            VodParser.etime = Number(CTXQuery.getAttr("etime"));
         }
         CTXQuery.setAttr("o",VodParser.os);
         CTXQuery.setAttr("type",VodCommon.playType);
         try
         {
            CTXQuery.setAttr("pageUrl",String(ExternalInterface.call("eval","window.location.href")));
            CTXQuery.setAttr("referrer",String(ExternalInterface.call("eval","document.referrer")));
         }
         catch(e:Error)
         {
         }
         VodParser.ctx = CTXQuery.cctx;
         var $param:String = "获取的setting相关参数  ===>>>  ";
         var $list:XMLList = describeType(VodParser).child("accessor") as XMLList;
         var mix:Function = function(param1:Object):String
         {
            var i:String = null;
            var obj:Object = param1;
            var str:String = "";
            var sign:Array = "{,}".split(",");
            for(i in obj)
            {
               try
               {
                  str = str + ("\"" + i + "\":" + obj[i] + ",");
               }
               catch(e:Error)
               {
                  continue;
               }
            }
            return str;
         };
         var j:int = 0;
         while(j < $list.length())
         {
            if($list[j]["@access"] == "readwrite")
            {
               $param = $param + (";  " + $list[j]["@name"] + "=");
               if($list[j]["@type"] == "Object")
               {
                  $param = $param + mix(getDefinitionByName($list[j]["@declaredBy"].toString())[$list[j]["@name"]]);
               }
               else
               {
                  $param = $param + getDefinitionByName($list[j]["@declaredBy"].toString())[$list[j]["@name"]];
               }
            }
            j++;
         }
         PrintDebug.Trace($param);
         addChild(new PPNewVodApp());
      }
      
      public function setSize(param1:Number = NaN, param2:Number = NaN) : void
      {
         PrintDebug.Trace("setSize 接口被调用，获取 w,h 数据 ：",param1,param2);
         try
         {
            Global.getInstance()["setSize"](param1,param2);
         }
         catch(evt:Error)
         {
         }
      }
      
      public function setTips(param1:Object) : void
      {
         PrintDebug.Trace("setTips 接口被调用，获取 obj 数据 ：",param1);
         try
         {
            Global.getInstance()["setTips"](param1);
         }
         catch(evt:Error)
         {
         }
      }
      
      public function setMute(param1:Boolean) : void
      {
         PrintDebug.Trace("setMute 接口被调用，获取 mute 数据 ：",param1);
         try
         {
            Global.getInstance()["setMute"](param1);
         }
         catch(evt:Error)
         {
         }
      }
      
      public function playVideo(param1:Object = null) : void
      {
         PrintDebug.Trace("playVideo 接口被调用，获取 obj 数据 ：",param1);
         try
         {
            Global.getInstance()["playVideo"](param1);
         }
         catch(evt:Error)
         {
         }
      }
      
      public function pauseVideo() : void
      {
         PrintDebug.Trace("pauseVideo 接口被调用......");
         try
         {
            Global.getInstance()["pauseVideo"]();
         }
         catch(evt:Error)
         {
         }
      }
      
      public function stopVideo() : void
      {
         PrintDebug.Trace("stopVideo 接口被调用......");
         try
         {
            Global.getInstance()["stopVideo"]();
         }
         catch(evt:Error)
         {
         }
      }
      
      public function seekVideo(param1:Number) : void
      {
         PrintDebug.Trace("seekVideo 接口被调用，获取 seek点 数据 ：",param1);
         try
         {
            Global.getInstance()["seekVideo"](param1);
         }
         catch(evt:Error)
         {
         }
      }
      
      public function setVolume(param1:Number) : void
      {
         PrintDebug.Trace("setVolume 接口被调用，获取 音量 数据 ：",param1);
         try
         {
            Global.getInstance()["setVolume"](param1);
         }
         catch(evt:Error)
         {
         }
      }
      
      public function getVolume() : Number
      {
         PrintDebug.Trace("getVolume 接口被调用，返回当前音量......");
         return Global.getInstance()["volume"];
      }
      
      public function playTime() : Number
      {
         PrintDebug.Trace("playTime 接口被调用，返回当前播放点......");
         return VodPlay.posi;
      }
      
      public function setBfrRecord(param1:String = "") : void
      {
         PrintDebug.Trace("setBfrRecord 接口被调用",param1);
         try
         {
            Global.getInstance()["setBfrRecord"](param1);
         }
         catch(evt:Error)
         {
         }
      }
      
      public function duration() : Number
      {
         PrintDebug.Trace("headTime 接口被调用，返回当前直播点......");
         return VodPlay.duration;
      }
      
      public function getSnapshot() : BitmapData
      {
         try
         {
            return Global.getInstance()["getSnapshot"]();
         }
         catch(evt:Error)
         {
         }
         return null;
      }
      
      public function getVersion() : String
      {
         PrintDebug.Trace("getVersion 接口被调用，返回当前播放器版本......");
         return VodCommon.version;
      }
      
      public function setAdvMute(param1:Boolean) : void
      {
         PrintDebug.Trace("setAdvMute 接口被调用，获取 开关 数据 ：",param1);
         try
         {
         }
         catch(evt:Error)
         {
         }
      }
      
      private function getParam(param1:String, param2:Object) : *
      {
         if(param2[param1] != undefined)
         {
            switch(param2[param1].constructor)
            {
               case String:
                  if(param2[param1]["length"] > 0)
                  {
                     return param2[param1];
                  }
                  break;
               case Number:
               case Boolean:
                  return param2[param1];
               case Object:
                  if(CommonUtils.match(param2[param1]))
                  {
                     return param2[param1];
                  }
                  break;
               case Array:
                  if(param2[param1]["length"] > 0)
                  {
                     return param2[param1];
                  }
                  break;
            }
         }
         return null;
      }
   }
}
