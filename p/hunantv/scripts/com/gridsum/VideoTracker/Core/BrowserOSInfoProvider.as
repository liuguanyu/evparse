package com.gridsum.VideoTracker.Core
{
   import flash.system.Capabilities;
   
   public class BrowserOSInfoProvider extends Object
   {
      
      private static var _isInitialized:Boolean = false;
      
      private static var _staticOSName:String = null;
      
      private static var _staticBrowserName:String = null;
      
      public function BrowserOSInfoProvider()
      {
         super();
      }
      
      public static function setBrowserName(param1:String) : void
      {
         _staticBrowserName = param1;
      }
      
      public static function setOSName(param1:String) : void
      {
         _staticOSName = param1;
      }
      
      public static function getBrowserName() : String
      {
         if(_staticBrowserName != null)
         {
            return _staticBrowserName;
         }
         if(!_isInitialized)
         {
            CoreJSHandler.Initialize();
            _isInitialized = true;
         }
         return CoreJSHandler.getBrowser();
      }
      
      public static function getOSName() : String
      {
         if(_staticOSName != null)
         {
            return _staticOSName;
         }
         return Capabilities.os;
      }
   }
}
