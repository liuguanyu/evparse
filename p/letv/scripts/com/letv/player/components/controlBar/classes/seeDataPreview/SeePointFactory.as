package com.letv.player.components.controlBar.classes.seeDataPreview
{
   import flash.events.EventDispatcher;
   
   public class SeePointFactory extends Object
   {
      
      public function SeePointFactory()
      {
         super();
      }
      
      public static function create(param1:Class, param2:EventDispatcher, param3:Object, param4:Number) : SeePoint
      {
         var _loc5_:SeePoint = null;
         if(param3 == null)
         {
            return null;
         }
         if(param4 <= 0)
         {
            return null;
         }
         if(!param3.hasOwnProperty("step"))
         {
            return null;
         }
         if(!param3.hasOwnProperty("type"))
         {
            return null;
         }
         _loc5_ = new SeePoint(param1,param2,param3,param4);
         return _loc5_;
      }
   }
}
