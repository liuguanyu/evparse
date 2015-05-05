package com.gridsum.VideoTracker.Core
{
   import flash.external.ExternalInterface;
   
   public class HostingPageInfoProvider extends Object
   {
      
      private static var _staticPageUrl:String = null;
      
      private static var _staticPageTitle:String = null;
      
      public function HostingPageInfoProvider()
      {
         super();
      }
      
      public static function setStaticPageURL(param1:String) : void
      {
         _staticPageUrl = param1;
      }
      
      public static function setStaticPageTitle(param1:String) : void
      {
         _staticPageTitle = param1;
      }
      
      public static function getHostingPageURL() : String
      {
         if(_staticPageUrl != null)
         {
            return _staticPageUrl;
         }
         var url:String = "";
         try
         {
            url = ExternalInterface.call("eval","document.URL");
         }
         catch(err:Error)
         {
            url = null;
         }
         if(url == null)
         {
            return "-";
         }
         return url;
      }
      
      public static function getCurrentHostingPageTitle() : String
      {
         if(_staticPageUrl != null)
         {
            return _staticPageTitle;
         }
         try
         {
            return ExternalInterface.call("eval","document.title");
         }
         catch(err:Error)
         {
         }
         return "-";
      }
   }
}
