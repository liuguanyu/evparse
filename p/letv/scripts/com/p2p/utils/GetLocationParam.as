package com.p2p.utils
{
   import flash.external.ExternalInterface;
   import flash.system.Capabilities;
   
   public class GetLocationParam extends Object
   {
      
      protected static var playerType:String = Capabilities.playerType;
      
      protected static var fileTitle:String = "";
      
      protected static var fileLocation:String = "";
      
      {
         playerType = Capabilities.playerType;
         fileTitle = "";
         fileLocation = "";
      }
      
      public function GetLocationParam()
      {
         super();
      }
      
      public static function GetBrowseLocationParams() : Object
      {
         var _loc1_:String = null;
         var _loc2_:String = null;
         var _loc3_:* = 0;
         if(playerType == "ActiveX" || playerType == "PlugIn")
         {
            if(ExternalInterface.available)
            {
               try
               {
                  _loc1_ = ExternalInterface.call("window.location.href.toString");
                  _loc2_ = ExternalInterface.call("window.document.title.toString");
                  if(_loc1_ != null)
                  {
                     fileLocation = _loc1_;
                  }
                  if(_loc2_ != null)
                  {
                     fileTitle = _loc2_;
                  }
                  if(fileTitle == "" && !(fileLocation == ""))
                  {
                     _loc3_ = Math.max(fileLocation.lastIndexOf("\\"),fileLocation.lastIndexOf("/"));
                     if(_loc3_ != -1)
                     {
                        fileTitle = fileLocation.substring(_loc3_ + 1,fileLocation.lastIndexOf("."));
                     }
                     else
                     {
                        fileTitle = fileLocation;
                     }
                  }
                  return {
                     "type":playerType,
                     "title":fileTitle,
                     "location":fileLocation
                  };
               }
               catch(e2:Error)
               {
               }
            }
            if(ExternalInterface.available)
            {
            }
         }
         return null;
      }
   }
}
