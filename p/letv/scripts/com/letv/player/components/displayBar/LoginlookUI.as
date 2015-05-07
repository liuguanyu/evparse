package com.letv.player.components.displayBar
{
   import com.letv.player.components.BaseCenterDisplayPopup;
   import flash.events.MouseEvent;
   import com.alex.utils.BrowserUtil;
   import com.letv.player.model.stat.LetvStatistics;
   import com.letv.pluginsAPI.api.JsAPI;
   
   public class LoginlookUI extends BaseCenterDisplayPopup
   {
      
      private var _stopTime:Number;
      
      public function LoginlookUI(param1:Object)
      {
         super(param1);
      }
      
      override protected function initialize() : void
      {
         super.initialize();
         try
         {
            skin.loginBtn.addEventListener(MouseEvent.CLICK,this.onLogin);
            skin.signBtn.addEventListener(MouseEvent.CLICK,this.onSign);
         }
         catch(e:Error)
         {
         }
      }
      
      private function onLogin(param1:MouseEvent) : void
      {
         var url:String = null;
         var arr:Array = null;
         var url1:String = null;
         var i:int = 0;
         var reg:RegExp = null;
         var reg1:RegExp = null;
         var event:MouseEvent = param1;
         try
         {
            systemManager.setFullScreen(false);
            url = BrowserUtil.url || "";
            arr = url.split("#");
            url1 = arr[0];
            if(url1.indexOf("htime=") != -1)
            {
               reg = new RegExp("htime=\\d+");
               url1 = url1.replace(reg,"htime=" + this._stopTime);
            }
            else
            {
               url1 = url1 + (url1.indexOf("?") != -1?"&htime=":"?htime=") + this._stopTime;
            }
            if(url1.indexOf("ref=") != -1)
            {
               reg1 = new RegExp("ref=\\w+");
               url1 = url1.replace(reg1,"ref=" + "loginLimit");
            }
            else
            {
               url1 = url1 + (url1.indexOf("?") != -1?"&ref=":"?ref=") + "loginLimit";
            }
            url = url1;
            i = 1;
            while(i < arr.length)
            {
               url = url + "#" + arr[i];
               i++;
            }
            R.stat.sendDocDebug(LetvStatistics.LOGINLIMIT_LOGIN_PANEL);
            browserManager.callScript(JsAPI.DISPLAY_LOGIN,url);
         }
         catch(e:Error)
         {
         }
         hide();
      }
      
      private function onSign(param1:MouseEvent) : void
      {
         R.stat.sendDocDebug(LetvStatistics.LOGINLIMIT_REGIST_PANEL);
         BrowserUtil.openBlankWindow("http://sso.letv.com/user/emailreg",stage);
      }
      
      public function set stopTime(param1:Number) : void
      {
         var _loc2_:Number = Math.floor(param1);
         this._stopTime = _loc2_ < 0?0:_loc2_;
      }
   }
}
