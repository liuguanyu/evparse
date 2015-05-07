package com.letv.player.model.config
{
   import com.alex.utils.RichStringUtil;
   import com.alex.utils.BrowserUtil;
   import flash.utils.describeType;
   import com.letv.player.model.EmbedConfig;
   
   public class InfoFlashvarsConfig extends Object
   {
      
      public var cid:String;
      
      public var pid:String;
      
      public var zid:String;
      
      public var vid:String;
      
      public var mmsid:String;
      
      public var pccsData:String;
      
      public var autoplay:Boolean = true;
      
      public var autoMute:Boolean = false;
      
      public var callbackJs:String;
      
      public var playClkUrl:String;
      
      public var picStartTo:String;
      
      public var picStartUrl:String;
      
      public var picEndTo:String;
      
      public var picEndUrl:String;
      
      public var pccsUrl:String;
      
      public var simple:String;
      
      public var skinnable:Boolean = true;
      
      public var start:int = 0;
      
      public var up:String = "0";
      
      public var duration:Number = 0;
      
      public var p1:String = "1";
      
      public var p2:String = "10";
      
      public var p3:String = "-";
      
      public var filter:Boolean;
      
      public var debugJs:Boolean = false;
      
      public var loadingUrl:String;
      
      public var flashvars:Object;
      
      public function InfoFlashvarsConfig()
      {
         super();
         var _loc1_:XML = EmbedConfig.CONFIG;
         this.callbackJs = _loc1_.callbackjs;
         this.pccsUrl = _loc1_.pccsurl;
      }
      
      public function init(param1:Object) : void
      {
         var item:String = null;
         var params:Object = null;
         var value:Object = param1;
         if(value == null)
         {
            return;
         }
         this.flashvars = value;
         for(item in value)
         {
            if(this.hasOwnProperty(item))
            {
               this[item] = value[item];
            }
         }
         try
         {
            if(this.flashvars.hasOwnProperty("filter"))
            {
               this.filter = String(this.flashvars["filter"]) == "1"?true:false;
            }
            if((this.flashvars.hasOwnProperty("loading")) && !(this.flashvars["loading"] == ""))
            {
               this.loadingUrl = this.flashvars.loading;
            }
            else if((this.flashvars.hasOwnProperty("loadingUrl")) && !(this.flashvars["loadingUrl"] == ""))
            {
               this.loadingUrl = this.flashvars.loadingUrl;
            }
            
            if(this.flashvars.hasOwnProperty("debug"))
            {
               this.debugJs = String(this.flashvars["debug"]) == "1"?true:false;
            }
            if(this.flashvars.hasOwnProperty("skinnable"))
            {
               this.skinnable = String(this.flashvars["skinnable"]) == "0"?false:true;
            }
            if(this.flashvars.hasOwnProperty("pic"))
            {
               this.picStartUrl = this.flashvars.pic;
               this.picEndUrl = this.flashvars.pic;
            }
            if(!(this.picStartUrl == null) && this.picStartUrl.indexOf("http://") == -1)
            {
               this.picStartUrl = null;
            }
            if(!(this.picEndUrl == null) && this.picEndUrl.indexOf("http://") == -1)
            {
               this.picEndUrl = null;
            }
            if((this.flashvars.hasOwnProperty("id")) && !(this.flashvars["id"] == ""))
            {
               this.vid = this.flashvars["id"];
            }
            if(this.vid != null)
            {
               this.vid = RichStringUtil.remove(this.vid," ");
            }
            if(this.mmsid != null)
            {
               this.mmsid = RichStringUtil.remove(this.mmsid," ");
            }
            if(this.flashvars.hasOwnProperty("autoMute"))
            {
               this.autoMute = String(this.flashvars["autoMute"]) == "1"?true:false;
            }
            if(this.flashvars.hasOwnProperty("autoPlay"))
            {
               this.autoplay = String(this.flashvars["autoPlay"]) == "0"?false:true;
            }
            else
            {
               this.autoplay = true;
            }
            try
            {
               params = BrowserUtil.urlparams;
               if(params.hasOwnProperty("up"))
               {
                  this.up = String(params["up"]);
               }
               if(params.hasOwnProperty("htime"))
               {
                  this.start = int(params["htime"]);
               }
            }
            catch(e:Error)
            {
            }
         }
         catch(e:Error)
         {
         }
      }
      
      public function clone() : Object
      {
         var _loc3_:XML = null;
         var _loc4_:String = null;
         var _loc1_:XMLList = describeType(InfoFlashvarsConfig).factory[0].variable;
         var _loc2_:Object = {};
         for each(_loc3_ in _loc1_)
         {
            _loc4_ = _loc3_.@name;
            if(_loc4_ != "classStructure")
            {
               _loc2_[_loc4_] = this[_loc4_];
            }
         }
         return _loc2_;
      }
   }
}
