package com.letv.plugins.kernel.model.special
{
   public class FlashVars extends Object
   {
      
      public var pid:String;
      
      public var zid:String;
      
      public var vid:String;
      
      public var pccsData:String;
      
      public var autoplay:int = 1;
      
      public var autoMute:int = 0;
      
      public var typeFrom:String;
      
      public var callbackJs:String = "callbackJs";
      
      public var picStartUrl:String;
      
      public var picEndUrl:String;
      
      public var pccsUrl:String;
      
      public var start:int;
      
      public var adLoaded:int = 0;
      
      public var adload:String = "0";
      
      public var up:String = "0";
      
      public var auid:String;
      
      public var p1:String = "1";
      
      public var p2:String = "10";
      
      public var p3:String = "-";
      
      public var flashvars:Object;
      
      public var debugJs:Boolean = false;
      
      public function FlashVars(param1:Object)
      {
         var _loc2_:String = null;
         var _loc3_:* = NaN;
         super();
         if(param1 != null)
         {
            for(_loc2_ in param1)
            {
               if(this.hasOwnProperty(_loc2_))
               {
                  this[_loc2_] = param1[_loc2_];
               }
            }
            if(this.flashvars != null)
            {
               if((this.flashvars.hasOwnProperty("tg")) && !(this.flashvars["tg"] == null) && !(this.flashvars["tg"] == "") && !(this.flashvars["tg"] == "null"))
               {
                  this.typeFrom = "letv_" + this.flashvars["tg"];
               }
               else if((this.flashvars.hasOwnProperty("typeFrom")) && !(this.flashvars["typeFrom"] == null) && !(this.flashvars["typeFrom"] == "") && !(this.flashvars["typeFrom"] == "null"))
               {
                  this.typeFrom = this.flashvars["typeFrom"];
               }
               else if((this.flashvars.hasOwnProperty("from")) && !(this.flashvars["from"] == null) && !(this.flashvars["from"] == "") && !(this.flashvars["from"] == "null"))
               {
                  this.typeFrom = this.flashvars["from"];
               }
               else
               {
                  this.typeFrom = "letv";
               }
               
               
               if(this.typeFrom.indexOf("#") != -1)
               {
                  this.typeFrom = this.typeFrom.split("#")[0];
               }
               if(this.flashvars.hasOwnProperty("htime"))
               {
                  _loc3_ = Number(this.flashvars["htime"]);
                  if(!isNaN(_loc3_) && _loc3_ > 0)
                  {
                     this.start = _loc3_;
                  }
               }
            }
         }
      }
      
      public function clearNextData() : void
      {
         if(this.flashvars != null)
         {
            if(this.flashvars.hasOwnProperty("nextvid"))
            {
               delete this.flashvars["nextvid"];
               true;
            }
            if(this.flashvars.hasOwnProperty("total"))
            {
               delete this.flashvars["total"];
               true;
            }
         }
      }
   }
}
