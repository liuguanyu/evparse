package cn.pplive.player.model
{
   import org.puremvc.as3.multicore.utilities.fabrication.patterns.proxy.FabricationProxy;
   import cn.pplive.player.utils.loader.DataLoader;
   import cn.pplive.player.common.VodParser;
   import flash.net.URLRequest;
   import cn.pplive.player.utils.PrintDebug;
   import flash.events.Event;
   import cn.pplive.player.common.VodNotification;
   import com.adobe.serialization.json.JSON;
   
   public class VodSubTitleListProxy extends FabricationProxy
   {
      
      public static const NAME:String = "vod_subtitlelist_proxy";
      
      private var url:String = "http://sub.cp.pptv.com/sub/v1/subtitleinfo/info?channelid=";
      
      private var _lang:Object;
      
      private var $lo:DataLoader = null;
      
      public function VodSubTitleListProxy(param1:String = null, param2:Object = null)
      {
         this._lang = {
            "jpn":"日语",
            "eng":"英语",
            "chn":"中文",
            "chi":"中文",
            "jp":"日语",
            "en":"英语",
            "chs":"中文"
         };
         super(param1,param2);
      }
      
      public function initData() : void
      {
         var _loc1_:String = this.url + VodParser.cid;
         this.$lo = new DataLoader(new URLRequest(_loc1_),10);
         this.$lo.addEventListener("_complete_",this.onTargetHandler);
         this.$lo.addEventListener("_ioerror_",this.onTargetHandler);
         this.$lo.addEventListener("_securityerror_",this.onTargetHandler);
         this.$lo.addEventListener("_timeout_",this.onTargetHandler);
         PrintDebug.Trace("字幕元信息标请求地址  ===>>>  " + _loc1_);
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
               PrintDebug.Trace("字幕元信息请求失败 ");
               sendNotification(VodNotification.VOD_SUBTITLEINFO,null);
               break;
            case "_complete_":
               try
               {
                  _loc2_ = param1.target.content;
                  if(_loc2_ != null)
                  {
                     PrintDebug.Trace("字幕元信息请求成功 >>>>>> ",_loc2_);
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
         var _loc2_:Object = null;
         var _loc3_:Array = null;
         var _loc4_:Array = null;
         var _loc5_:* = 0;
         var _loc6_:Object = null;
         var _loc7_:Object = null;
         try
         {
            _loc2_ = com.adobe.serialization.json.JSON.decode(param1);
            if((_loc2_.hasOwnProperty("err")) && _loc2_["err"] == 0)
            {
               _loc3_ = _loc2_["data"]["subtitleInfoMetadataBeanList"];
               _loc4_ = null;
               if((_loc3_) && _loc3_.length > 0)
               {
                  _loc4_ = [{
                     "lang":"不使用字幕",
                     "format":"",
                     "downloadUrl":""
                  }];
                  _loc5_ = 0;
                  while(_loc5_ < _loc3_.length)
                  {
                     if(_loc3_[_loc5_]["format"] == "xml")
                     {
                        _loc6_ = {
                           "lang":(this._lang[_loc3_[_loc5_]["lang"]]?this._lang[_loc3_[_loc5_]["lang"]]:_loc3_[_loc5_]["lang"]),
                           "format":_loc3_[_loc5_]["format"],
                           "downloadUrl":_loc3_[_loc5_]["downloadUrl"],
                           "subtitleFileSize":_loc3_[_loc5_]["subtitleFileSize"],
                           "score":_loc3_[_loc5_]["score"],
                           "index":0
                        };
                        for each(_loc7_ in _loc4_)
                        {
                           if(_loc6_["lang"] == _loc7_["lang"])
                           {
                              if(_loc7_["index"] <= 0)
                              {
                                 _loc7_["index"] = 1;
                              }
                              _loc6_["index"] = _loc7_["index"] + 1;
                           }
                        }
                        _loc4_.push(_loc6_);
                     }
                     _loc5_++;
                  }
               }
               sendNotification(VodNotification.VOD_SUBTITLEINFO,_loc4_);
            }
         }
         catch(e:Error)
         {
         }
      }
   }
}
