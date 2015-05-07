package com.letv.barrage
{
   import flash.display.Sprite;
   import com.letv.barrage.components.image.LoadImage;
   import flash.geom.Rectangle;
   import com.letv.barrage.view.View;
   
   public class Barrage extends Sprite
   {
      
      public static const TYPE_EM:String = "em";
      
      public static const TYPE_TXT:String = "txt";
      
      public static var conf:Object;
      
      private var loadImage:LoadImage;
      
      private var view:View;
      
      public function Barrage(param1:String = null)
      {
         this.loadImage = LoadImage.getinstance();
         super();
         if(param1)
         {
            this.loadImage.init(param1);
         }
         this.view = new View(this);
      }
      
      public function destroy() : void
      {
         this.view.destroy();
      }
      
      public function clearInput() : void
      {
         this.view.clearInput();
      }
      
      public function showInput() : void
      {
         this.view.showInput();
      }
      
      public function hideInput() : void
      {
         this.view.hideInput();
      }
      
      public function set inputTip(param1:String) : void
      {
         this.view.inputTip = param1;
      }
      
      public function pause() : void
      {
         try
         {
            this.view.pause();
         }
         catch(e:Error)
         {
         }
      }
      
      public function resume() : void
      {
         try
         {
            this.view.resume();
         }
         catch(e:Error)
         {
         }
      }
      
      public function set viewPort(param1:Rectangle) : void
      {
         this.view.viewPort = param1;
      }
      
      public function append(param1:Object) : void
      {
         this.view.append(param1);
      }
   }
}
