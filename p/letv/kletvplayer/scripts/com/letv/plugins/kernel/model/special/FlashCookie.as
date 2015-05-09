package com.letv.plugins.kernel.model.special
{
   public class FlashCookie extends Object
   {
      
      public var recordTime:Number = 0;
      
      public var defaultDefinition:String = "auto";
      
      public var volume:Number = 1;
      
      public var jump:Boolean;
      
      public var continuePlay:Boolean;
      
      public var fullscreenInput:Boolean;
      
      public var barrage:Boolean;
      
      public function FlashCookie(param1:Object)
      {
         var _loc2_:String = null;
         super();
         for(_loc2_ in param1)
         {
            if(this.hasOwnProperty(_loc2_))
            {
               this[_loc2_] = param1[_loc2_];
            }
         }
      }
   }
}
