package com.gridsum.VideoTracker.Store
{
   import flash.external.ExternalInterface;
   
   public class BrowserStore extends Object implements IVideoTrackerStore
   {
      
      public function BrowserStore()
      {
         var _loc2_:Error = null;
         super();
         var _loc1_:* = "";
         _loc1_ = _loc1_ + ("if(GVCookieFunction == undefined)" + "{");
         _loc1_ = _loc1_ + ("function gsSetCookie(name, value, expires, security) {" + "        var str = name + \"=\" + escape(value);" + "        if (expires != null) str += \";expires=\" + new Date(expires).toGMTString() + \"\";" + "        if (security == true) str += \";secure\";" + "        document.cookie = str;" + "}");
         _loc1_ = _loc1_ + ("function gsGetCookie(name) {" + "        var arr = document.cookie.match(new RegExp(\"(;|^) *\" +name + \"=([^;]*)\", \"m\"));" + "        if(arr != null) return unescape(arr[2]); " + "        return null;" + "}");
         _loc1_ = _loc1_ + ("function gsDeleteCookie(name) {" + "        var d = new Date();" + "        d.setTime(d.getTime() - 1);" + "        var value = gsGetCookie(name);" + "        if(value != null) {" + "                document.cookie = name + \"=\" + escape(value) + \";expires=\" + d.toGMTString();" + "        }" + "}");
         _loc1_ = _loc1_ + ("var GVCookieFunction = 1;" + "}");
         if(ExternalInterface.available)
         {
            ExternalInterface.call("eval",_loc1_);
            return;
         }
         _loc2_ = new Error("The container of this player doesn\'t support ExternalInterface.");
         throw _loc2_;
      }
      
      public function addOrSetValue(param1:String, param2:Object) : void
      {
         var _loc3_:Error = null;
         if(ExternalInterface.available)
         {
            if(param2 == null)
            {
               ExternalInterface.call("gsDeleteCookie",param1);
            }
            else
            {
               ExternalInterface.call("gsSetCookie",param1,param2,null,false);
            }
            return;
         }
         _loc3_ = new Error("The container of this player doesn\'t support ExternalInterface.");
         throw _loc3_;
      }
      
      public function getValue(param1:String) : Object
      {
         var _loc2_:Error = null;
         if(ExternalInterface.available)
         {
            return ExternalInterface.call("gsGetCookie",param1);
         }
         _loc2_ = new Error("The container of this player doesn\'t support ExternalInterface.");
         throw _loc2_;
      }
   }
}
