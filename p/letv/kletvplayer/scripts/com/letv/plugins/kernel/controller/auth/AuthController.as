package com.letv.plugins.kernel.controller.auth
{
   import flash.events.EventDispatcher;
   import com.letv.plugins.kernel.interfaces.IAuth;
   import com.alex.utils.BrowserUtil;
   import com.letv.plugins.kernel.controller.auth.transfer.IDTransfer;
   import com.letv.plugins.kernel.controller.auth.transfer.TransferEvent;
   import com.letv.plugins.kernel.Kernel;
   import com.letv.plugins.kernel.controller.auth.transfer.TransferResult;
   import com.letv.pluginsAPI.api.JsAPI;
   import com.letv.pluginsAPI.kernel.PlayerError;
   import com.letv.plugins.kernel.controller.auth.pay.LetvPayAuth;
   import com.letv.plugins.kernel.controller.LoadEvent;
   import com.letv.plugins.kernel.model.Model;
   
   public class AuthController extends EventDispatcher implements IAuth
   {
      
      private var payAuth:LetvPayAuth;
      
      private var payAuthSilent:Boolean;
      
      private var transfer:IDTransfer;
      
      private var authing:Boolean;
      
      private var model:Model;
      
      private var db:Object;
      
      public function AuthController(param1:Model)
      {
         this.model = param1;
         super();
      }
      
      public function destroy() : void
      {
         this.transferGc();
         this.payAuthGc();
      }
      
      public function checkVip() : void
      {
         if(!this.authing && this.payAuth == null && !this.model.config.forvip)
         {
            this.model.user.flushUserData(BrowserUtil.userinfo);
            this.startPayAuth(true);
         }
      }
      
      public function start(param1:Object = null) : void
      {
         this.destroy();
         this.db = param1;
         if(this.model.preloadData.preload)
         {
            this.authing = true;
         }
         this.startTransfer(this.db);
      }
      
      private function startTransfer(param1:Object) : void
      {
         this.transferGc();
         this.transfer = IDTransfer.create(param1,this.model);
         this.model.user.flushUserData(BrowserUtil.userinfo);
         if(this.transfer == null)
         {
            this.onTransferFailed();
            return;
         }
         this.transfer.addEventListener(TransferEvent.LOAD_SUCCESS,this.onTransferSuccess);
         this.transfer.addEventListener(TransferEvent.LOAD_FAILED,this.onTransferFailed);
         this.transfer.transform();
      }
      
      private function onTransferSuccess(param1:TransferEvent) : void
      {
         Kernel.sendLog(this + " onTransferSuccess");
         var _loc2_:TransferResult = param1.dataProvider as TransferResult;
         this.transferGc();
         if(this.model.preloadData.preload)
         {
            this.model.preloadData.preloadData = _loc2_;
            this.model.preloadData.setPoint();
         }
         else
         {
            this.model.setSetting(_loc2_);
            this.model.gslb.gslblist = _loc2_.playData.list;
         }
         this.startPayAuth();
      }
      
      private function onTransferFailed(param1:TransferEvent = null) : void
      {
         var event:TransferEvent = param1;
         Kernel.sendLog(this + " onTransferFailed" + event,"error");
         if(!this.model.preloadData.preload)
         {
            try
            {
               this.model.sendInterface(JsAPI.PLAYER_INIT,event.dataProvider);
            }
            catch(e:Error)
            {
            }
         }
         this.sendAuthError(event is TransferEvent?event.errorCode:PlayerError.INPUT_ERROR);
         this.destroy();
      }
      
      private function startPayAuth(param1:Boolean = false) : void
      {
         var _loc2_:Object = null;
         this.payAuthGc();
         this.payAuthSilent = (param1) && !this.model.preloadData.preload;
         if((this.model.user.isLogin) || !(this.model.user.baiduid == null))
         {
            this.payAuth = new LetvPayAuth();
            this.payAuth.addEventListener(LoadEvent.LOAD_ERROR,this.onPayAuthFailed);
            this.payAuth.addEventListener(LoadEvent.LOAD_COMPLETE,this.onPayAuthSuccess);
            if(this.model.preloadData.preload)
            {
               _loc2_ = {
                  "pid":this.model.preloadData.preloadData.playData.pid,
                  "uid":this.model.user.uid,
                  "ispay":(this.model.preloadData.preloadData.trylook?1:0)
               };
            }
            else
            {
               _loc2_ = {
                  "pid":this.model.setting.pid,
                  "uid":this.model.user.uid,
                  "ispay":(this.model.setting.trylook?1:0)
               };
            }
            if(this.model.user.baiduid != null)
            {
               _loc2_["platfrom"] = "baidu";
               _loc2_["platuid"] = this.model.user.baiduid;
            }
            this.payAuth.start(_loc2_);
         }
         else
         {
            this.onPayAuthFailed();
         }
      }
      
      private function onPayAuthSuccess(param1:LoadEvent) : void
      {
         this.model.user.flushPayData(param1.dataProvider);
         this.onAuthOver();
      }
      
      private function onPayAuthFailed(param1:LoadEvent = null) : void
      {
         this.model.user.flushPayData(null);
         this.onAuthOver();
      }
      
      private function onAuthOver() : void
      {
         Kernel.sendLog(this + " onAuthOver Slient " + this.payAuthSilent + "---pre:" + this.model.preloadData.preload);
         this.destroy();
         if(!this.payAuthSilent)
         {
            this.sendAuthSuccess();
         }
         this.authing = false;
         this.payAuthSilent = false;
      }
      
      private function sendAuthSuccess(param1:Object = null) : void
      {
         this.destroy();
         var _loc2_:AuthEvent = new AuthEvent(AuthEvent.AUTH_VALID);
         _loc2_.dataProvider = param1;
         dispatchEvent(_loc2_);
      }
      
      private function sendAuthError(param1:String) : void
      {
         this.destroy();
         this.authing = false;
         var _loc2_:AuthEvent = new AuthEvent(AuthEvent.AUTH_INVALID);
         _loc2_.errorCode = param1;
         dispatchEvent(_loc2_);
      }
      
      private function payAuthGc() : void
      {
         if(this.payAuth != null)
         {
            this.payAuth.removeEventListener(LoadEvent.LOAD_ERROR,this.onPayAuthFailed);
            this.payAuth.removeEventListener(LoadEvent.LOAD_COMPLETE,this.onPayAuthSuccess);
            this.payAuth.destroy();
            this.payAuth = null;
         }
      }
      
      private function transferGc() : void
      {
         if(this.transfer != null)
         {
            this.transfer.removeEventListener(TransferEvent.LOAD_SUCCESS,this.onTransferSuccess);
            this.transfer.removeEventListener(TransferEvent.LOAD_FAILED,this.onTransferFailed);
            this.transfer.destroy();
            this.transfer = null;
         }
      }
   }
}
