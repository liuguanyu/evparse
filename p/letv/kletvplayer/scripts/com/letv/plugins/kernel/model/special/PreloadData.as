package com.letv.plugins.kernel.model.special
{
   import com.letv.plugins.kernel.controller.auth.transfer.TransferResult;
   
   public class PreloadData extends Object
   {
      
      public var _preload:Boolean = false;
      
      public var preloadData:TransferResult;
      
      public var playPreload:Boolean = false;
      
      public var gslbPreloadData:Object;
      
      public var statValue:Object;
      
      public var p2pPreloadComplete:Boolean = false;
      
      public var adPreloadComplete:Boolean = false;
      
      public var preloadFail:Boolean = false;
      
      public var stopTime:Number = 0;
      
      public var currentGslbUrl:String;
      
      public var currentDefinition:String = "";
      
      public var nextHeadTime:Number = 0;
      
      public var nextTailTime:Number = 0;
      
      public function PreloadData()
      {
         super();
      }
      
      public function get cdnlistInfo() : Array
      {
         var i:int = 0;
         var urlitem:Object = null;
         var arr:Array = [];
         try
         {
            i = 0;
            while(i < this.gslbPreloadData.list.length)
            {
               if(this.gslbPreloadData.list[i] != null)
               {
                  if(this.gslbPreloadData.list[i].hasOwnProperty(this.currentDefinition))
                  {
                     urlitem = this.gslbPreloadData.list[i][this.currentDefinition];
                     arr.push({
                        "location":urlitem.location,
                        "playlevel":urlitem.playlevel,
                        "kbps":this.currentDefinition
                     });
                  }
               }
               i++;
            }
         }
         catch(e:Error)
         {
         }
         return arr;
      }
      
      public function get preloadComplete() : Boolean
      {
         return (this.p2pPreloadComplete) && (this.adPreloadComplete);
      }
      
      public function get preload() : Boolean
      {
         return this._preload;
      }
      
      public function set preload(param1:Boolean) : void
      {
         this._preload = param1;
      }
      
      public function clearGslb() : void
      {
         this.playPreload = false;
         this.preloadFail = false;
         this.p2pPreloadComplete = false;
         this.adPreloadComplete = false;
         this.gslbPreloadData = null;
         this.statValue = null;
         this.currentGslbUrl = "";
      }
      
      public function gc(param1:Boolean = false) : void
      {
         this.clearGslb();
         this.preload = false;
         this.preloadData = null;
         this.stopTime = 0;
         this.currentDefinition = "";
         this.preloadFail = param1;
      }
      
      public function setPoint() : void
      {
         this.nextHeadTime = this.nextTailTime = 0;
         if(!this.preloadData.point)
         {
            return;
         }
         var _loc1_:Array = this.preloadData.point["skip"] as Array || [];
         if(_loc1_[0])
         {
            this.nextHeadTime = (parseInt(_loc1_[0])) || (0);
         }
         if(_loc1_[1])
         {
            this.nextTailTime = (parseInt(_loc1_[1])) || (0);
         }
      }
   }
}
