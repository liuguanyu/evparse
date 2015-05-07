package com.letv.player.model.proxy.loadingAd
{
   import com.alex.utils.JSONUtil;
   
   public class LoadingAd extends Object
   {
      
      public function LoadingAd()
      {
         super();
      }
      
      public static function get URL() : String
      {
         return "http://www.letv.com/cmsdata/block/235.json";
      }
      
      public static function parser(param1:Object) : Object
      {
         var result:Object = null;
         var value:Object = param1;
         var obj:Object = {};
         try
         {
            result = JSONUtil.decode(value + "");
            obj["source"] = result.blockContent[0].pic1;
            obj["clkurl"] = result.blockContent[0].url;
            return obj;
         }
         catch(e:Error)
         {
         }
         return null;
      }
   }
}
