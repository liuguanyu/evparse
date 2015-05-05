package com.p2p.utils
{
   public class ParseUrl extends Object
   {
      
      public function ParseUrl()
      {
         super();
      }
      
      public static function parseUrl(param1:String) : Object
      {
         var _loc4_:Object = null;
         var _loc2_:RegExp = new RegExp("^([a-z+\\w\\+\\.\\-]+:\\/?\\/?)?([^\\/?#]*)?(\\/[^?#]*)?(\\?[^#]*)?(\\#.*)?","i");
         var _loc3_:Array = param1.match(_loc2_);
         if(_loc3_ != null)
         {
            _loc4_ = new Object();
            _loc4_.protocol = _loc3_[1];
            _loc4_.hostName = _loc3_[2];
            _loc4_.path = _loc3_[3];
            _loc4_.query = _loc3_[4];
            _loc4_.fragment = _loc3_[5];
            return _loc4_;
         }
         return null;
      }
      
      public static function getParam(param1:String, param2:String) : String
      {
         var _loc3_:RegExp = new RegExp("[?&]?" + param2 + "=([^&]*)","");
         var _loc4_:* = "";
         if(_loc3_.test(param1))
         {
            _loc4_ = param1.match(_loc3_)[1];
         }
         return _loc4_;
      }
      
      public static function replaceParam(param1:String, param2:String, param3:String) : String
      {
         var _loc4_:RegExp = new RegExp("[?&]" + param2 + "=(\\w{0,})?","");
         var _loc5_:* = "";
         if(_loc4_.test(param1))
         {
            _loc5_ = param1.match(_loc4_)[0];
         }
         if(param1.indexOf("?") == -1)
         {
            var param1:String = param1 + ("?" + param2 + "=" + param3);
         }
         else if(_loc5_.length > 0)
         {
            param1 = param1.replace(_loc5_,_loc5_.charAt(0) + param2 + "=" + param3);
         }
         else if(_loc5_.length == 0)
         {
            param1 = param1 + "&" + param2 + "=" + param3;
         }
         
         
         return param1;
      }
      
      public static function replaceParamAndKey(param1:String, param2:String, param3:String, param4:String) : String
      {
         var _loc5_:RegExp = new RegExp("[?&]" + param2 + "=(\\w{0,})?","");
         var _loc6_:* = "";
         if(_loc5_.test(param1))
         {
            _loc6_ = param1.match(_loc5_)[0];
         }
         if(_loc6_.length > 0)
         {
            if(_loc6_.indexOf("?") >= 0)
            {
               var param1:String = param1.replace(_loc6_,"");
               if(param1.indexOf("&") >= 0)
               {
                  param1 = param1.replace(param1.charAt(param1.indexOf("&")),"?");
               }
            }
            else
            {
               param1 = param1.replace(_loc6_,"");
            }
         }
         param1 = replaceParam(param1,param3,param4);
         return param1;
      }
   }
}
