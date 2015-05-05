package cn.pplive.player.controller
{
   import org.puremvc.as3.multicore.utilities.fabrication.patterns.command.SimpleFabricationCommand;
   import flash.display.MovieClip;
   import cn.pplive.player.view.ui.Loading;
   import org.puremvc.as3.multicore.interfaces.INotification;
   import cn.pplive.player.utils.hash.Global;
   import cn.pplive.player.common.*;
   import cn.pplive.player.dac.*;
   import cn.pplive.player.manager.*;
   import cn.pplive.player.model.*;
   import cn.pplive.player.utils.AS3Cookie;
   import cn.pplive.player.view.VodMediator;
   import cn.pplive.player.view.SmartMediator;
   import cn.pplive.player.utils.PrintDebug;
   import flash.ui.ContextMenuItem;
   import flash.ui.ContextMenu;
   import flash.events.ContextMenuEvent;
   import flash.utils.describeType;
   import flash.utils.getDefinitionByName;
   import cn.pplive.player.view.source.CTXQuery;
   
   public class VodStartUpCommand extends SimpleFabricationCommand
   {
      
      private var $vod:MovieClip;
      
      private var _ld:Loading;
      
      private var $userInfo:Object = null;
      
      public function VodStartUpCommand()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         this.$vod = param1.getBody() as MovieClip;
         Global.getInstance()["root"] = this.$vod;
         this._ld = new Loading();
         this.$vod.addChild(this._ld);
         this._ld.init(null,40,4);
         Global.getInstance()["loading"] = this._ld;
         this._ld.resize();
         this.register();
      }
      
      private function register() : void
      {
         this.addMenu();
         VodCommon.cookie = new AS3Cookie("pptv_vod_so");
         VodCommon.cookie.isOften = false;
         Global.getInstance()["playmodel"] = "vod";
         Global.getInstance()["fab"] = fabFacade;
         fabFacade.registerCommand(VodNotification.VOD_PUID_COMPLETE,VodPuidCommand);
         fabFacade.registerCommand(VodNotification.VOD_PLAY_SUCCESS,VodPlayCommand);
         fabFacade.registerProxy(new VodRecommendProxy(VodRecommendProxy.NAME,this.$vod));
         fabFacade.registerProxy(new VodPPAPProxy(VodPPAPProxy.NAME,this.$vod));
         fabFacade.registerProxy(new VodPuidProxy(VodPuidProxy.NAME,this.$vod));
         fabFacade.registerProxy(new VodPlayProxy(VodPlayProxy.NAME,this.$vod));
         fabFacade.registerProxy(new VodMarkProxy(VodMarkProxy.NAME,this.$vod));
         fabFacade.registerProxy(new VodWaterMarkAdvProxy(VodWaterMarkAdvProxy.NAME,this.$vod));
         fabFacade.registerProxy(new VodPreSnapshotProxy(VodPreSnapshotProxy.NAME,this.$vod));
         fabFacade.registerProxy(new VodCloudDargProxy(VodCloudDargProxy.NAME,this.$vod));
         fabFacade.registerMediator(new DACMediator(DACMediator.NAME,this.$vod));
         fabFacade.registerMediator(new VodMediator(VodMediator.NAME,this.$vod));
         fabFacade.registerMediator(new SmartMediator(SmartMediator.NAME,this.$vod));
         fabFacade.registerProxy(new VodAdvProxy(VodAdvProxy.NAME,this.$vod));
         fabFacade.registerProxy(new VodKernelProxy(VodKernelProxy.NAME,this.$vod));
         fabFacade.registerProxy(new VodBarrageProxy(VodBarrageProxy.NAME,this.$vod));
         fabFacade.registerProxy(new VodSmartProxy(VodSmartProxy.NAME,this.$vod));
         fabFacade.registerProxy(new VodSubTitleListProxy(VodSubTitleListProxy.NAME,this.$vod));
         fabFacade.registerProxy(new VodSubTitleInfoProxy(VodSubTitleInfoProxy.NAME,this.$vod));
         PrintDebug.Trace("Command, Proxy, Mediator注册成功");
         Global.getInstance()["setUserInfo"] = this.setUserInfo;
      }
      
      private function addMenu() : void
      {
         var _loc4_:ContextMenuItem = null;
         var _loc1_:ContextMenu = new ContextMenu();
         _loc1_.hideBuiltInItems();
         _loc1_.addEventListener(ContextMenuEvent.MENU_SELECT,this.onMenuSelectHandler);
         var _loc2_:Array = ["Build VodPlayer " + VodCommon.version + " Powered by PPTV"];
         var _loc3_:* = 0;
         while(_loc3_ < _loc2_.length)
         {
            _loc4_ = new ContextMenuItem(_loc2_[_loc3_]);
            _loc4_.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT,this.onMenuSelectHandler);
            _loc1_.customItems.push(_loc4_);
            _loc3_++;
         }
         this.$vod.contextMenu = _loc1_;
      }
      
      private function onMenuSelectHandler(param1:ContextMenuEvent) : void
      {
         sendNotification(VodNotification.RIGHT_CLICK);
         PrintDebug.Trace("已经触发鼠标右键");
      }
      
      public function setUserInfo(param1:Object = null) : void
      {
         var _loc2_:String = null;
         var _loc3_:XMLList = null;
         var _loc4_:* = 0;
         var _loc5_:Array = null;
         try
         {
            if((this.hasKey(this.$userInfo)) || (this.hasKey(param1["body"]["data"])))
            {
               if(this.mix(this.$userInfo,param1["body"]["data"]))
               {
                  return;
               }
            }
            this.$userInfo = param1["body"]["data"];
            Global.getInstance()["clickSource"] = this.$userInfo["source"];
            Global.getInstance()["userInfo"] = this.$userInfo;
            if((this.$userInfo["PPName"]) && (this.$userInfo["UDI"]))
            {
               _loc5_ = decodeURIComponent(this.$userInfo["UDI"]).split("$") as Array;
               VodParser.un = decodeURIComponent(this.$userInfo["PPName"]).split("$")[0] || _loc5_[16];
               VIPPrivilege.isVip = !(_loc5_[17] == "0");
               VIPPrivilege.isNoad = (VIPPrivilege.isVip) || _loc5_[19] == "true";
               VIPPrivilege.isRtmp = (VIPPrivilege.isVip) || _loc5_[23] == "true";
               VIPPrivilege.isSpdup = (VIPPrivilege.isSpdup) || _loc5_[21] == "true";
               PrintDebug.Trace("UDI 特权相关信息  ===>>>  isVip : ",_loc5_[17],"  isNoad : ",_loc5_[19],"  isRtmp : ",_loc5_[23],"  isSpdup : ",_loc5_[21]," VodCommon.isPPAP:" + VodCommon.isPPAP);
            }
            else
            {
               VodParser.un = "";
               VIPPrivilege.isVip = false;
               VIPPrivilege.isNoad = false;
               VIPPrivilege.isRtmp = false;
               VIPPrivilege.isSpdup = false;
               delete Global.getInstance()["userInfo"];
               true;
            }
            _loc2_ = "";
            _loc3_ = describeType(VIPPrivilege).child("accessor") as XMLList;
            _loc4_ = 0;
            while(_loc4_ < _loc3_.length())
            {
               if(_loc3_[_loc4_]["@access"] == "readwrite")
               {
                  _loc2_ = _loc2_ + ((_loc2_ == ""?"":",  ") + _loc3_[_loc4_]["@name"] + "=" + getDefinitionByName(_loc3_[_loc4_]["@declaredBy"].toString())[_loc3_[_loc4_]["@name"]]);
               }
               _loc4_++;
            }
            PrintDebug.Trace("VIPPrivilege 相关属性  ===>>>  ",_loc2_);
            if((VIPPrivilege.isVip) && VodCommon.playType.indexOf("vip") == -1)
            {
               VodCommon.playType = VodCommon.playType + ".vip";
            }
            CTXQuery.setAttr("type",VodCommon.playType);
            VodParser.ctx = CTXQuery.cctx;
            try
            {
               Global.getInstance()["setBarrageInfo"]();
               Global.getInstance()["smartClickData"]();
               Global.getInstance()["updataAccelerateState"]();
            }
            catch(evt:Error)
            {
            }
            try
            {
               ViewManager.getInstance().getMediator("adver").skipAdver();
            }
            catch(evt:Error)
            {
            }
         }
         catch(evt:Error)
         {
         }
      }
      
      private function hasKey(param1:Object) : Boolean
      {
         var _loc3_:* = undefined;
         var _loc2_:* = false;
         if(!param1)
         {
            return _loc2_;
         }
         for(_loc3_ in param1)
         {
            _loc2_ = true;
         }
         return _loc2_;
      }
      
      private function mix(param1:Object, param2:Object) : Boolean
      {
         var _loc3_:* = undefined;
         if(this.hasKey(param1) != this.hasKey(param2))
         {
            return false;
         }
         for(_loc3_ in param2)
         {
            if(param2[_loc3_].constructor != Object)
            {
               if(param1[_loc3_] != param2[_loc3_])
               {
                  return false;
               }
            }
            else
            {
               param1[_loc3_] = this.mix(param1[_loc3_],param2[_loc3_]);
            }
         }
         return true;
      }
   }
}
