package cn.pplive.player.utils
{
   import flash.utils.Dictionary;
   import flash.external.ExternalInterface;
   
   public class PageURLQuery extends Object
   {
      
      protected static var $map:Dictionary;
      
      protected static var $query:String = null;
      
      public function PageURLQuery()
      {
         super();
      }
      
      public static function setURLQuery() : void
      {
         var _loc1_:Array = null;
         var _loc2_:* = 0;
         var _loc3_:Array = null;
         $map = new Dictionary();
         try
         {
            $query = ExternalInterface.call("eval","window.location.search");
            if(!($query == "") && !($query == null))
            {
               $query = $query.substr(1);
               _loc1_ = $query.split("&");
               _loc2_ = -1;
               while(++_loc2_ < _loc1_.length)
               {
                  _loc3_ = _loc1_[_loc2_].split("=");
                  $map[_loc3_[0]] = _loc3_[1];
               }
            }
         }
         catch(e:Error)
         {
         }
      }
      
      public static function getValue(param1:String) : String
      {
         if($query == null)
         {
            return null;
         }
         return $map[param1];
      }
      
      public static function contains(param1:String) : Boolean
      {
         return getValue(param1)?true:false;
      }
      
      public static function getParam(param1:String) : String
      {
         var _loc2_:RegExp = new RegExp("(^|&|\\?)" + param1 + "=([^&]*)(&|$)","i");
         var _loc3_:String = ExternalInterface.call("eval","window.location.href");
         var _loc4_:Array = _loc3_.substr(1).match(_loc2_);
         if(_loc4_ != null)
         {
            return unescape(_loc4_[2]);
         }
         return null;
      }
   }
}
