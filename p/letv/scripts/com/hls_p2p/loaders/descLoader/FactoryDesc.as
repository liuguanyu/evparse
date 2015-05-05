package com.hls_p2p.loaders.descLoader
{
   import com.hls_p2p.dataManager.DataManager;
   
   public class FactoryDesc extends Object
   {
      
      public function FactoryDesc()
      {
         super();
      }
      
      public function method_153(param1:String, param2:DataManager) : IDescLoader
      {
         return new GeneralLiveM3U8Loader(param2);
      }
   }
}
