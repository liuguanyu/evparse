package com.alex.utils
{
   import flash.external.ExternalInterface;
   import flash.display.Stage;
   import flash.display.StageDisplayState;
   import flash.net.URLRequest;
   import flash.net.navigateToURL;
   import flash.net.URLVariables;
   
   public class BrowserUtil extends Object
   {
      
      private static var _name:String;
      
      public function BrowserUtil()
      {
         super();
      }
      
      private static function getEval(param1:String) : String
      {
         var type:String = param1;
         try
         {
            return ExternalInterface.call("eval",type);
         }
         catch(e:Error)
         {
         }
         return null;
      }
      
      private static function getBrowserName() : String
      {
         var _loc1_:String = getEval("navigator.userAgent");
         if(_loc1_ == null)
         {
            return "-";
         }
         _loc1_ = _loc1_.toLowerCase();
         if(_loc1_.indexOf("msie") >= 0)
         {
            _loc1_ = _loc1_.split(";")[1];
            _loc1_ = RichStringUtil.trim(_loc1_);
            _loc1_ = _loc1_.split(" ")[1];
            return "ie" + int(_loc1_);
         }
         if(_loc1_.indexOf("360se") >= 0)
         {
            return "360";
         }
         if(_loc1_.indexOf("tencent") >= 0)
         {
            return "qq";
         }
         if(_loc1_.indexOf("se 2.x") >= 0)
         {
            return "sogou";
         }
         if(_loc1_.indexOf("tencent") >= 0)
         {
            return "qq";
         }
         if(_loc1_.indexOf("firefox") >= 0)
         {
            return "ff";
         }
         if(_loc1_.indexOf("chrome") >= 0)
         {
            return "chrome";
         }
         if(_loc1_.indexOf("safari") >= 0)
         {
            return "safa";
         }
         if(_loc1_.indexOf("opera") >= 0)
         {
            _loc1_ = "opera";
         }
         return "other";
      }
      
      public static function get name() : String
      {
         if(_name == null)
         {
            _name = getBrowserName();
         }
         return _name;
      }
      
      public static function console(param1:String) : void
      {
         var value:String = param1;
         try
         {
            ExternalInterface.call("console.log",value);
         }
         catch(e:Error)
         {
         }
      }
      
      public static function alert(param1:String) : void
      {
         var value:String = param1;
         try
         {
            ExternalInterface.call("alert",value);
         }
         catch(e:Error)
         {
         }
      }
      
      public static function openBlankWindow(param1:String, param2:Stage = null) : void
      {
         var url:String = param1;
         var stage:Stage = param2;
         if(url == null || url == "")
         {
            return;
         }
         if(stage != null)
         {
            try
            {
               stage.displayState = StageDisplayState.NORMAL;
            }
            catch(e:Error)
            {
            }
         }
         openWindow(url,"_blank");
      }
      
      public static function openSelfWindow(param1:String, param2:Stage = null) : void
      {
         var url:String = param1;
         var stage:Stage = param2;
         if(url == null || url == "")
         {
            return;
         }
         if(stage != null)
         {
            try
            {
               stage.displayState = StageDisplayState.NORMAL;
            }
            catch(e:Error)
            {
            }
         }
         openWindow(url,"_self");
      }
      
      private static function openWindow(param1:String, param2:String = "_blank") : void
      {
         var jscmd:String = null;
         var req:URLRequest = null;
         var pageurl:String = param1;
         var window:String = param2;
         try
         {
            if(pageurl == null || pageurl.indexOf("http://") == -1)
            {
               return;
            }
         }
         catch(e:Error)
         {
            return;
         }
         var browsername:String = name;
         jscmd = "window.open";
         req = new URLRequest(pageurl);
         try
         {
            if(!(browsername.indexOf("ie") == -1) && !(window == "_self"))
            {
               ExternalInterface.call(jscmd,pageurl,window);
            }
            else if(browsername == "ff")
            {
               navigateToURL(req,window);
            }
            else if(browsername == "safa")
            {
               navigateToURL(req,window);
            }
            else if(browsername == "opera")
            {
               navigateToURL(req,window);
            }
            else
            {
               navigateToURL(req,window);
            }
            
            
            
         }
         catch(e:Error)
         {
            navigateToURL(req,window);
         }
      }
      
      public static function get url() : String
      {
         return getEval("window.location.href");
      }
      
      public static function get referer() : String
      {
         var url:String = null;
         try
         {
            url = ExternalInterface.call("flashGetDocumentReferrer");
            if(url.indexOf("http://") > -1)
            {
               return url;
            }
         }
         catch(e:Error)
         {
         }
         try
         {
            url = getEval("document.referrer");
            if(url.indexOf("http://") > -1)
            {
               return url;
            }
         }
         catch(e:Error)
         {
         }
         return "-";
      }
      
      public static function get domain() : String
      {
         return host;
      }
      
      public static function get host() : String
      {
         return getEval("window.location.host");
      }
      
      public static function get hash() : String
      {
         try
         {
            return getEval("window.location.hash").split("#")[1];
         }
         catch(e:Error)
         {
         }
         return null;
      }
      
      public static function get search() : String
      {
         try
         {
            return getEval("window.location.search").split("?")[1];
         }
         catch(e:Error)
         {
         }
         return null;
      }
      
      public static function get pathname() : String
      {
         return getEval("window.location.pathname");
      }
      
      public static function get port() : String
      {
         return getEval("window.location.port");
      }
      
      public static function get protocol() : String
      {
         return getEval("window.location.protocol");
      }
      
      public static function get title() : String
      {
         return getEval("window.location.title");
      }
      
      public static function get urlparams() : URLVariables
      {
         try
         {
            return new URLVariables(search);
         }
         catch(e:Error)
         {
         }
         return null;
      }
      
      public static function get userinfo() : Object
      {
         var uname:String = null;
         var uid:String = null;
         var unick:String = null;
         var baiduid:String = null;
         try
         {
            uname = ExternalInterface.call("flashGetUserInfo");
            if(uname == "")
            {
               uname = "-";
            }
         }
         catch(e:Error)
         {
         }
         try
         {
            uid = ExternalInterface.call("flashGetUserSSOUID");
            if(uid == "")
            {
               uid = "-";
            }
         }
         catch(e:Error)
         {
         }
         try
         {
            unick = ExternalInterface.call("flashGetNikename");
            if(unick == "")
            {
               unick = "-";
            }
         }
         catch(e:Error)
         {
         }
         try
         {
            baiduid = ExternalInterface.call("flashGetBaiduUID");
            if(baiduid == "")
            {
               baiduid = "-";
            }
         }
         catch(e:Error)
         {
         }
         return {
            "uname":uname,
            "uid":uid,
            "unick":unick,
            "baiduid":baiduid
         };
      }
   }
}
