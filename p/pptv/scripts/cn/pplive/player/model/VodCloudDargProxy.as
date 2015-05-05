package cn.pplive.player.model
{
   import org.puremvc.as3.multicore.utilities.fabrication.patterns.proxy.FabricationProxy;
   import cn.pplive.player.utils.loader.DataLoader;
   import cn.pplive.player.common.VodParser;
   import cn.pplive.player.utils.PrintDebug;
   import flash.net.URLRequest;
   import flash.events.Event;
   import cn.pplive.player.common.VodNotification;
   
   public class VodCloudDargProxy extends FabricationProxy
   {
      
      public static const NAME:String = "vod_clouddarg_proxy";
      
      private var $lo:DataLoader;
      
      public function VodCloudDargProxy(param1:String = null, param2:Object = null)
      {
         super(param1,param2);
      }
      
      override public function onRegister() : void
      {
      }
      
      public function initData() : void
      {
         if(!VodParser.cid)
         {
            return;
         }
         PrintDebug.Trace("请求视频云图数据 ");
         this.$lo = new DataLoader(new URLRequest("http://clouddrag.api.pptv.com/api/v1/cloud?id=" + VodParser.cid + "&format=xml"),10);
         this.$lo.addEventListener("_complete_",this.onContentHandler);
         this.$lo.addEventListener("_ioerror_",this.onContentHandler);
         this.$lo.addEventListener("_securityerror_",this.onContentHandler);
         this.$lo.addEventListener("_timeout_",this.onContentHandler);
      }
      
      private function onContentHandler(param1:Event) : void
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
                     PrintDebug.Trace("视频云图数据请求成功 >>>>>> ",_loc2_);
                     this.parse(_loc2_);
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
      
      public function parse(param1:*) : void
      {
         var _loc2_:XML = null;
         var _loc3_:Array = null;
         var _loc4_:Object = null;
         var _loc5_:Array = null;
         var _loc6_:Array = null;
         var _loc7_:* = NaN;
         var _loc8_:* = NaN;
         var _loc9_:* = 0;
         var _loc10_:* = 0;
         var _loc11_:* = 0;
         try
         {
            _loc2_ = new XML(param1);
            _loc3_ = String(_loc2_.content).split("-");
            if(_loc3_.length == 2)
            {
               _loc4_ = {};
               _loc4_["interval"] = _loc3_[0];
               _loc5_ = String(_loc3_[1]).split(",");
               _loc4_["mapEachGroupSum"] = [];
               _loc7_ = 0;
               _loc8_ = 0;
               _loc4_["maxIndex"] = 0;
               _loc9_ = 0;
               while(_loc9_ < _loc5_.length)
               {
                  _loc6_ = _loc5_[_loc9_].split(":");
                  if(_loc6_[0] != _loc4_["mapEachGroupSum"].length * _loc4_["interval"])
                  {
                     PrintDebug.Trace("云图数据中间跳了" + (_loc6_[0] - _loc4_["mapEachGroupSum"].length * _loc4_["interval"]) + "秒 >>>" + _loc4_["mapEachGroupSum"].length * _loc4_["interval"] + "-----" + _loc6_[0]);
                     _loc10_ = (_loc6_[0] - _loc4_["mapEachGroupSum"].length * _loc4_["interval"]) / _loc4_["interval"];
                     _loc11_ = 0;
                     while(_loc11_ < _loc10_)
                     {
                        _loc4_["mapEachGroupSum"].push(0);
                        _loc11_++;
                     }
                  }
                  _loc4_["mapEachGroupSum"].push(Number(_loc6_[1]));
                  _loc7_ = _loc7_ + Number(_loc6_[1]);
                  if(_loc6_[1] > _loc8_)
                  {
                     _loc8_ = _loc6_[1];
                     _loc4_["maxIndex"] = _loc9_;
                  }
                  _loc9_++;
               }
               if(_loc7_ > 100)
               {
                  sendNotification(VodNotification.VOD_CLOUDDARG_COMPLETE,_loc4_);
                  PrintDebug.Trace("云图数据最高点索引 >>>>>> " + _loc4_["maxIndex"] + " 值为 >>>>>> " + _loc8_);
               }
            }
         }
         catch(e:Error)
         {
         }
      }
   }
}
