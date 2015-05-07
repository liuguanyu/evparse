package com.alex.encrypt.abc
{
   import flash.system.Capabilities;
   import flash.utils.ByteArray;
   
   public class DeCompress extends Object
   {
      
      private static var _bigCode:int;
      
      private static var _smallCode:int;
      
      public function DeCompress()
      {
         super();
      }
      
      private static function initialize() : void
      {
         var _loc1_:String = null;
         var _loc2_:Array = null;
         if(_bigCode == 0)
         {
            _loc1_ = Capabilities.version;
            _loc1_ = _loc1_.split(" ")[1];
            _loc2_ = _loc1_.split(",");
            _bigCode = int(_loc2_[0]);
            _smallCode = int(_loc2_[1]);
         }
      }
      
      private static function get supportLZMA() : Boolean
      {
         initialize();
         if(_bigCode >= 11)
         {
            if(_smallCode <= 3)
            {
               return false;
            }
            return true;
         }
         return false;
      }
      
      public static function decode(param1:ByteArray) : ByteArray
      {
         if(param1 == null || param1.length < 16)
         {
            return null;
         }
         if(supportLZMA)
         {
            param1["uncompress"]("lzma");
            return param1;
         }
         var _loc2_:ByteArray = new ByteArray();
         _loc2_.length = param1[5] | param1[6] << 8 | param1[7] << 16 | param1[8] << 24;
         return new Decoder().decode(param1[0],param1,13,_loc2_,0,_loc2_.length)?_loc2_:null;
      }
      
      public static function decodeSWF(param1:ByteArray) : ByteArray
      {
         if(param1 == null || param1.length < 32)
         {
            return null;
         }
         if(int(Capabilities.version.split(new RegExp("[ ,]+"))[1]) > 10)
         {
            return param1;
         }
         var _loc2_:ByteArray = new ByteArray();
         _loc2_.length = param1[4] | param1[5] << 8 | param1[6] << 16 | param1[7] << 24;
         if(!new Decoder().decode(param1[12],param1,17,_loc2_,8,_loc2_.length - 8))
         {
            return null;
         }
         var _loc3_:* = 0;
         while(_loc3_ < 8)
         {
            _loc2_[_loc3_] = param1[_loc3_];
            _loc3_++;
         }
         _loc2_[0] = 70;
         _loc2_[3] = param1[13] > 0?param1[13]:10;
         return _loc2_;
      }
   }
}
