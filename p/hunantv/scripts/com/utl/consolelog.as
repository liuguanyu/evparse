package com.utl
{
   import com.parmParse;
   import flash.utils.getQualifiedClassName;
   import flash.external.ExternalInterface;
   
   public class consolelog extends Object
   {
      
      public function consolelog()
      {
         super();
      }
      
      public static function log(param1:String, param2:Object = null) : void
      {
         if(!parmParse.DEBUG)
         {
            return;
         }
         var _loc3_:* = "";
         if(param2)
         {
            _loc3_ = getQualifiedClassName(param2);
            _loc3_ = _loc3_ + ":: ";
         }
         _loc3_ = _loc3_ + param1;
         if(ExternalInterface.available)
         {
            try
            {
               ExternalInterface.call("console.log",_loc3_);
            }
            catch(ex:*)
            {
            }
         }
      }
   }
}
