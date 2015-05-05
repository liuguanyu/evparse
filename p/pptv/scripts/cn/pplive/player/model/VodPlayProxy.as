package cn.pplive.player.model
{
   import org.puremvc.as3.multicore.utilities.fabrication.patterns.proxy.FabricationProxy;
   import cn.pplive.player.utils.loader.DataLoader;
   import cn.pplive.player.common.VodCommon;
   import cn.pplive.player.common.VodParser;
   import cn.pplive.player.utils.CommonUtils;
   import cn.pplive.player.utils.hash.Global;
   import cn.pplive.player.dac.DACReport;
   import cn.pplive.player.common.VIPPrivilege;
   import cn.pplive.player.view.source.CTXQuery;
   import cn.pplive.player.dac.DACNotification;
   import cn.pplive.player.dac.DACCommon;
   import cn.pplive.player.utils.PrintDebug;
   import flash.net.URLRequest;
   import flash.events.Event;
   import cn.pplive.player.common.VodNotification;
   import cn.pplive.player.manager.InteractiveManager;
   import cn.pplive.player.events.PPLiveEvent;
   
   public class VodPlayProxy extends FabricationProxy
   {
      
      public static const NAME:String = "vod_play_proxy";
      
      private var $lo:DataLoader;
      
      private var count:int = 0;
      
      public function VodPlayProxy(param1:String = null, param2:Object = null)
      {
         super(param1,param2);
      }
      
      override public function onRegister() : void
      {
      }
      
      public function get playUrl() : String
      {
         if(VodCommon.priplay)
         {
            return VodCommon.priplay;
         }
         var _loc1_:String = VodParser.ph[this.count];
         var _loc2_:String = CommonUtils.addHttp(_loc1_);
         if(_loc2_.lastIndexOf("/") != _loc2_.length - 1)
         {
            _loc2_ = _loc2_ + "/";
         }
         if(VodCommon.playStr)
         {
            _loc2_ = _loc2_ + ("?playStr=" + VodCommon.playStr);
            if(Global.getInstance()["userInfo"])
            {
               _loc2_ = _loc2_ + ("&token=" + Global.getInstance()["userInfo"]["ppToken"]);
            }
         }
         else
         {
            _loc2_ = _loc2_ + (VodParser.lm?"webplay3":"webplay4");
            _loc2_ = _loc2_ + ("-0-" + VodParser.cid + ".xml");
            _loc2_ = _loc2_ + ("?zone=" + -(new Date().getTimezoneOffset() / 60));
            _loc2_ = _loc2_ + ("&pid=" + VodCommon.pid);
            _loc2_ = _loc2_ + ("&vvid=" + DACReport.vvid);
            _loc2_ = _loc2_ + "&version=4";
            if(VodCommon.smart)
            {
               _loc2_ = _loc2_ + "&open=1";
            }
         }
         _loc2_ = _loc2_ + ("&username=" + encodeURIComponent(VodParser.un));
         _loc2_ = _loc2_ + ("&param=" + encodeURIComponent("type=" + VodCommon.playType + "&userType=" + Number(VIPPrivilege.isVip) + "&o=" + VodParser.os));
         _loc2_ = _loc2_ + ((CTXQuery.pctx != ""?"&":"") + CTXQuery.pctx);
         _loc2_ = _loc2_ + ("&" + VodParser.ctx);
         _loc2_ = _loc2_ + ("&r=" + new Date().valueOf());
         return _loc2_;
      }
      
      public function initData() : void
      {
         if(!VodCommon.priplay && !VodCommon.playStr && !VodParser.cid)
         {
            this.check();
            return;
         }
         this.startPlay(this.playUrl);
      }
      
      private function startPlay(param1:String) : void
      {
         if(this.count == 0)
         {
            sendNotification(DACNotification.START_RECORD,null,DACCommon.DTT);
         }
         PrintDebug.Trace("第 " + this.count + " 次play请求：",param1);
         this.$lo = new DataLoader(new URLRequest(param1));
         this.$lo.addEventListener("_complete_",this.onContentHandler);
         this.$lo.addEventListener("_ioerror_",this.onContentHandler);
         this.$lo.addEventListener("_securityerror_",this.onContentHandler);
         this.$lo.addEventListener("_timeout_",this.onContentHandler);
      }
      
      private function onContentHandler(param1:Event) : void
      {
         var _loc3_:XML = null;
         var _loc2_:String = ["stps","ttps","ttpe"][this.count];
         sendNotification(DACNotification.DAC_MARK,{
            "t":new Date().getTime(),
            "p":_loc2_
         },DACCommon.TDS);
         switch(param1.type)
         {
            case "_ioerror_":
            case "_securityerror_":
            case "_timeout_":
               this.$lo.clear();
               this.check(param1.type,param1);
               break;
            case "_complete_":
               _loc3_ = XML(param1.target.content);
               try
               {
               }
               catch(evt:Error)
               {
               }
               PrintDebug.Trace("play接口返回数据：",_loc3_.toXMLString());
               sendNotification(VodNotification.VOD_PLAY_SUCCESS,_loc3_);
               sendNotification(DACNotification.STOP_RECORD,null,DACCommon.DTT);
               break;
         }
      }
      
      public function check(param1:String = "", param2:* = null) : void
      {
         var _loc3_:String = null;
         var _loc4_:Object = null;
         var _loc5_:String = null;
         if(this.count < VodParser.ph.length - 1)
         {
            this.count++;
            this.initData();
         }
         else
         {
            _loc3_ = "";
            _loc4_ = {};
            if(param1 == "_ioerror_")
            {
               _loc4_["code"] = VodCommon.callCode["play"][1];
               PrintDebug.Trace("play服务请求数据错误   >>>>>>>>   " + param2);
            }
            else if(param1 == "_securityerror_")
            {
               _loc4_["code"] = VodCommon.callCode["play"][2];
               PrintDebug.Trace("play服务请求安全沙箱错误   >>>>>>>>   " + param2);
            }
            else if(param1 == "_timeout_")
            {
               _loc4_["code"] = VodCommon.callCode["play"][3];
               PrintDebug.Trace("play服务请求超时   >>>>>>>>   " + param2);
            }
            else if(param1 == "_dterror_")
            {
               _loc4_["code"] = VodCommon.callCode["play"][4];
               _loc3_ = "_dterror_:无dt数据返回";
               PrintDebug.Trace("play服务请求数据返回结构错误，可能无dt数据   >>>>>>>>   ");
            }
            else
            {
               _loc4_["code"] = VodCommon.callCode["play"][6];
               _loc3_ = "播放串错误，无chid 或 其他未知类型错误";
               PrintDebug.Trace("播放串错误，未获取到频道id  或 其他未知类型错误 >>>>>>>>   ");
            }
            
            
            
            _loc5_ = VodCommon.playErrorText;
            _loc4_["error"] = _loc5_.replace(new RegExp("%code%","g"),_loc4_["code"]);
            if(param2 != null)
            {
               _loc4_["message"] = param2.target.errorMsg;
            }
            else
            {
               _loc4_["message"] = "play服务请求错误 " + _loc3_;
            }
            _loc4_["url"] = this.playUrl;
            InteractiveManager.sendEvent(PPLiveEvent.VOD_ONERROR,_loc4_);
            sendNotification(VodNotification.VOD_PLAY_FAILED,_loc4_);
         }
      }
      
      public function reset() : void
      {
         if(this.$lo)
         {
            this.$lo.clear();
         }
         this.count = 0;
      }
   }
}
