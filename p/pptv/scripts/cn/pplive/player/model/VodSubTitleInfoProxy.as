package cn.pplive.player.model
{
   import org.puremvc.as3.multicore.utilities.fabrication.patterns.proxy.FabricationProxy;
   import cn.pplive.player.utils.loader.DataLoader;
   import cn.pplive.player.common.VodParser;
   import com.hurlant.util.Base64;
   import com.adobe.crypto.MD5;
   import flash.net.URLRequest;
   import cn.pplive.player.utils.PrintDebug;
   import flash.events.Event;
   import cn.pplive.player.common.VodNotification;
   
   public class VodSubTitleInfoProxy extends FabricationProxy
   {
      
      public static const NAME:String = "vod_subtitleinfo_proxy";
      
      private var url:String = "http://subcdn.cp.pptv.com/sub";
      
      private var $lo:DataLoader = null;
      
      public function VodSubTitleInfoProxy(param1:String = null, param2:Object = null)
      {
         super(param1,param2);
      }
      
      public function initData() : void
      {
         var _loc1_:Array = null;
         var _loc2_:String = null;
         var _loc3_:String = null;
         var _loc4_:String = null;
         var _loc5_:String = null;
         try
         {
            if((VodParser.subTitle) && VodParser.subTitle.length > 0)
            {
               _loc1_ = VodParser.subTitle.split("/");
               _loc2_ = "pplive_client" + _loc1_[3].toString();
               _loc3_ = Base64.encode(_loc2_);
               _loc4_ = MD5.hash(_loc3_);
               _loc5_ = this.url + VodParser.subTitle + "?token=" + _loc4_;
               this.$lo = new DataLoader(new URLRequest(_loc5_),10);
               this.$lo.addEventListener("_complete_",this.onTargetHandler);
               this.$lo.addEventListener("_ioerror_",this.onTargetHandler);
               this.$lo.addEventListener("_securityerror_",this.onTargetHandler);
               this.$lo.addEventListener("_timeout_",this.onTargetHandler);
               PrintDebug.Trace("字幕信息标请求地址  ===>>>  " + _loc5_ + ",urlParams=" + _loc2_);
            }
         }
         catch(e:Error)
         {
         }
      }
      
      private function onTargetHandler(param1:Event) : void
      {
         var _loc2_:String = null;
         switch(param1.type)
         {
            case "_ioerror_":
            case "_securityerror_":
            case "_timeout_":
               this.$lo.clear();
               break;
            case "_complete_":
               try
               {
                  _loc2_ = param1.target.content;
                  if(_loc2_ != null)
                  {
                     PrintDebug.Trace("字幕信息请求成功 >>>>>> ");
                     this.parse(_loc2_);
                  }
               }
               catch(evt:Error)
               {
               }
               break;
         }
      }
      
      public function parse(param1:*) : void
      {
         var _loc2_:XML = null;
         var _loc3_:Object = null;
         var _loc4_:XMLList = null;
         var _loc5_:Array = null;
         var _loc6_:* = 0;
         try
         {
            _loc2_ = new XML(param1);
            if(_loc2_ == null)
            {
               return;
            }
            _loc3_ = {"title":_loc2_["sub"]["@title"]};
            _loc4_ = _loc2_["item"] as XMLList;
            _loc5_ = [];
            _loc6_ = 0;
            while(_loc6_ < _loc4_.length())
            {
               _loc5_.push({
                  "st":Math.floor(Number(_loc4_[_loc6_]["st"]) / 1000),
                  "et":Math.floor(Number(_loc4_[_loc6_]["et"]) / 1000),
                  "sub":_loc4_[_loc6_]["sub"].toString()
               });
               _loc6_++;
            }
            _loc3_["item"] = _loc5_;
            sendNotification(VodNotification.VOD_SHOWSUBTITLE,_loc3_);
         }
         catch(e:Error)
         {
         }
      }
   }
}
