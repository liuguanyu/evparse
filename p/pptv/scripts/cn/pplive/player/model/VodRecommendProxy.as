package cn.pplive.player.model
{
   import org.puremvc.as3.multicore.utilities.fabrication.patterns.proxy.FabricationProxy;
   import cn.pplive.player.utils.loader.DataLoader;
   import cn.pplive.player.common.VodParser;
   import cn.pplive.player.utils.PrintDebug;
   import flash.net.URLRequest;
   import flash.events.Event;
   import cn.pplive.player.common.RecommendItem;
   import com.adobe.serialization.json.JSON;
   import cn.pplive.player.common.VodNotification;
   
   public class VodRecommendProxy extends FabricationProxy
   {
      
      public static const NAME:String = "vod_recommend_proxy";
      
      private var $lo:DataLoader;
      
      public function VodRecommendProxy(param1:String = null, param2:Object = null)
      {
         super(param1,param2);
      }
      
      override public function onRegister() : void
      {
      }
      
      public function initData() : void
      {
         if(!VodParser.ru)
         {
            return;
         }
         var _loc1_:String = VodParser.ru.replace(new RegExp("\\[ID\\]","g"),VodParser.cid);
         _loc1_ = _loc1_ + "&src=22";
         PrintDebug.Trace("发起结束后推荐请求  ===>>>  ",_loc1_);
         this.$lo = new DataLoader(new URLRequest(_loc1_));
         this.$lo.addEventListener("_complete_",this.onContentHandler);
         this.$lo.addEventListener("_ioerror_",this.onContentHandler);
         this.$lo.addEventListener("_securityerror_",this.onContentHandler);
         this.$lo.addEventListener("_timeout_",this.onContentHandler);
      }
      
      private function onContentHandler(param1:Event) : void
      {
         var _loc2_:String = null;
         var _loc3_:Object = null;
         var _loc4_:Array = null;
         var _loc5_:Vector.<RecommendItem> = null;
         var _loc6_:* = 0;
         var _loc7_:String = null;
         switch(param1.type)
         {
            case "_ioerror_":
            case "_securityerror_":
            case "_timeout_":
               this.$lo.clear();
               break;
            case "_complete_":
               _loc2_ = param1.target.content;
               try
               {
                  _loc3_ = com.adobe.serialization.json.JSON.decode(_loc2_);
                  if(_loc3_["err"] == 0 && _loc3_["data"]["videos"].length > 0)
                  {
                     _loc4_ = _loc3_["data"]["videos"] as Array;
                     _loc5_ = new Vector.<RecommendItem>();
                     _loc6_ = 0;
                     while(_loc6_ < _loc4_.length)
                     {
                        _loc5_.push(new RecommendItem(String(_loc4_[_loc6_]["id"]),String(_loc4_[_loc6_]["title"]),_loc4_[_loc6_]["capture"] != undefined?String(_loc4_[_loc6_]["capture"]):String(_loc4_[_loc6_]["catpure"]),String(_loc4_[_loc6_]["link"])));
                        _loc6_++;
                     }
                     PrintDebug.Trace("结束后推荐请求成功  ===>>>  ",_loc3_);
                     _loc7_ = "";
                     if(_loc3_["data"]["requestUUID"])
                     {
                        _loc7_ = _loc3_["data"]["requestUUID"];
                     }
                     sendNotification(VodNotification.VOD_RECOMMEND,{
                        "items":_loc5_,
                        "uuid":_loc7_
                     });
                  }
               }
               catch(evt:Error)
               {
               }
               break;
         }
      }
      
      public function clear() : void
      {
         if(this.$lo)
         {
            this.$lo.clear();
         }
      }
   }
}
