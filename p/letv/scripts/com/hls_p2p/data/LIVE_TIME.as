package com.hls_p2p.data
{
   import com.hls_p2p.data.vo.LiveVodConfig;
   
   public class LIVE_TIME extends Object
   {
      
      private static var _liveTime:Number = 0;
      
      private static var var_261:Number = 0;
      
      private static var var_262:Number = 0;
      
      private static var var_263:Number = 0;
      
      private static var var_264:Number = 0;
      
      private static var var_265:Number = 0;
      
      private static var var_266:Boolean = false;
      
      {
         _liveTime = 0;
         var_261 = 0;
         var_262 = 0;
         var_263 = 0;
         var_264 = 0;
         var_265 = 0;
         var_266 = false;
      }
      
      public function LIVE_TIME()
      {
         super();
      }
      
      public static function get isPause() : Boolean
      {
         return var_266;
      }
      
      public static function set isPause(param1:Boolean) : void
      {
         if(param1)
         {
            var_265 = method_260();
            method_259(var_265);
         }
         var_266 = param1;
         if(!var_266)
         {
            var_264 = getTime();
         }
      }
      
      public static function method_256(param1:Number) : void
      {
         LIVE_TIME._liveTime = param1;
         var_261 = getTime();
      }
      
      public static function method_257() : Number
      {
         return Math.floor(LIVE_TIME._liveTime + (getTime() - var_261) / 1000);
      }
      
      public static function method_258() : Number
      {
         return Math.floor(LIVE_TIME._liveTime + (getTime() - var_261) / 1000 - LiveVodConfig.var_273 + var_262);
      }
      
      public static function method_259(param1:Number) : void
      {
         var_263 = param1;
         var_264 = getTime();
      }
      
      public static function method_260() : Number
      {
         if(var_266)
         {
            var_264 = getTime();
            return var_263;
         }
         return Math.floor(var_263 + (getTime() - var_264) / 1000);
      }
      
      public static function CLEAR() : void
      {
         _liveTime = 0;
         var_261 = 0;
         var_262 = 0;
         var_263 = 0;
         var_264 = 0;
         var_266 = false;
         var_265 = 0;
      }
      
      private static function getTime() : Number
      {
         return Math.floor(new Date().time);
      }
   }
}
