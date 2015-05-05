package com.p2p.utils.json
{
   public class JSONDOC extends Object
   {
      
      public function JSONDOC()
      {
         super();
      }
      
      public static function encode(param1:Object) : String
      {
         var _loc2_:JSONEncoder = new JSONEncoder(param1);
         return _loc2_.getString();
      }
      
      public static function decode(param1:String) : *
      {
         var _loc2_:JSONDecoder = new JSONDecoder(param1);
         return _loc2_.getValue();
      }
   }
}
