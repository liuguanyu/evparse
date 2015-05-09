package com.letv.plugins.kernel.model.special
{
   public class P2PData extends Object
   {
      
      public var p2pFLV:Object;
      
      public var p2pM3U8:Object;
      
      public function P2PData()
      {
         super();
      }
      
      public function flush(param1:Object = null, param2:Object = null) : void
      {
         if(param1 != null)
         {
            this.p2pFLV = param1;
         }
         if(param2 != null)
         {
            this.p2pM3U8 = param2;
         }
      }
   }
}
