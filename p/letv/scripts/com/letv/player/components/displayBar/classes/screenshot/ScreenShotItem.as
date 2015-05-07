package com.letv.player.components.displayBar.classes.screenshot
{
   import com.alex.controls.Image;
   import com.greensock.TweenLite;
   import flash.utils.ByteArray;
   import flash.net.FileReference;
   import com.adobe.images.PNGEncoder;
   import com.alex.rpc.events.AutoLoaderEvent;
   
   public class ScreenShotItem extends Image
   {
      
      private var _picurl:String;
      
      public function ScreenShotItem(param1:String)
      {
         this._picurl = param1;
         super();
      }
      
      override public function destroy() : void
      {
         try
         {
            TweenLite.killTweensOf(this);
         }
         catch(e:Error)
         {
         }
         super.destroy();
      }
      
      override public function get source() : String
      {
         return this._picurl;
      }
      
      public function display() : void
      {
         if(this.source != this._picurl)
         {
            source = this._picurl;
         }
      }
      
      public function saveScreenShot() : void
      {
         var _loc1_:ByteArray = null;
         var _loc2_:FileReference = null;
         if(bitmapData != null)
         {
            _loc1_ = PNGEncoder.encode(bitmapData);
            _loc2_ = new FileReference();
            _loc2_.save(_loc1_,"screenshot.png");
         }
      }
      
      override protected function onLoadComplete(param1:AutoLoaderEvent) : void
      {
         super.onLoadComplete(param1);
         alpha = 0;
         TweenLite.to(this,0.3,{"alpha":1});
      }
      
      override protected function initialize() : void
      {
         super.initialize();
         backgroundColor = 0;
         mouseEnabled = false;
         mouseChildren = false;
      }
   }
}
