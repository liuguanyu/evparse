package org.puremvc.as3.multicore.utilities.fabrication.utils
{
   public class NameUtils extends Object
   {
      
      public static var namesMap:Object = new Object();
      
      public function NameUtils()
      {
         super();
      }
      
      public static function nextName(param1:String) : String
      {
         var _loc2_:String = namesMap[param1];
         if(_loc2_ == null)
         {
            _loc2_ = namesMap[param1] = 0;
         }
         else
         {
            namesMap[param1]++;
         }
         return param1 + namesMap[param1];
      }
   }
}
