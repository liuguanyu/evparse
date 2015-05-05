package org.qrcode.utils
{
   import org.qrcode.rs.QRRsItem;
   
   public class QRUtil extends Object
   {
      
      public static var items:Array = [];
      
      public function QRUtil()
      {
         super();
      }
      
      public static function memset(param1:Array, param2:int, param3:int, param4:int, param5:int) : Array
      {
         var _loc6_:* = 0;
         while(_loc6_ < param5)
         {
            param1[param2][_loc6_ + param3] = param4;
            _loc6_++;
         }
         return param1;
      }
      
      public static function str_repeat(param1:String, param2:int) : String
      {
         var _loc3_:* = "";
         var _loc4_:* = 0;
         while(_loc4_ < param2)
         {
            _loc3_ = _loc3_ + param1;
            _loc4_++;
         }
         return _loc3_;
      }
      
      public static function array_fill(param1:int, param2:int, param3:Object) : Array
      {
         var _loc4_:Array = new Array();
         var _loc5_:* = 0;
         while(_loc5_ < param2)
         {
            if(param3 is Array)
            {
               _loc4_[param1 + _loc5_] = copyArray(param3 as Array);
            }
            else
            {
               _loc4_[param1 + _loc5_] = param3;
            }
            _loc5_++;
         }
         return _loc4_;
      }
      
      public static function array_merge(param1:Array, param2:Array) : Array
      {
         var _loc3_:* = 0;
         while(_loc3_ < param2.length)
         {
            param1.push(param2[_loc3_]);
            _loc3_++;
         }
         return param1;
      }
      
      public static function copyFrame(param1:Array) : Array
      {
         var _loc3_:String = null;
         var _loc2_:Array = new Array();
         for(_loc3_ in param1)
         {
            _loc2_[_loc3_] = QRUtil.copyArray(param1[_loc3_]);
         }
         return _loc2_;
      }
      
      public static function copyArray(param1:Array) : Array
      {
         var _loc3_:* = undefined;
         var _loc2_:Array = new Array();
         for each(_loc3_ in param1)
         {
            _loc2_.push(_loc3_);
         }
         return _loc2_;
      }
      
      public static function initRs(param1:int, param2:int, param3:int, param4:int, param5:int, param6:int) : QRRsItem
      {
         var _loc7_:QRRsItem = null;
         var _loc8_:QRRsItem = null;
         for each(_loc7_ in items)
         {
            if(_loc7_.pad != param6)
            {
               continue;
            }
            if(_loc7_.nroots != param5)
            {
               continue;
            }
            if(_loc7_.mm != param1)
            {
               continue;
            }
            if(_loc7_.gfpoly != param2)
            {
               continue;
            }
            if(_loc7_.fcr != param3)
            {
               continue;
            }
            if(_loc7_.prim != param4)
            {
               continue;
            }
            return _loc7_;
         }
         _loc8_ = QRRsItem.init_rs_char(param1,param2,param3,param4,param5,param6);
         items.unshift(_loc8_);
         return _loc8_;
      }
   }
}
