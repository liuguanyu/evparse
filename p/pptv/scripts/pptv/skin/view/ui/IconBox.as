package pptv.skin.view.ui
{
   import flash.display.MovieClip;
   import flash.display.Loader;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.net.URLRequest;
   
   public dynamic class IconBox extends MovieClip
   {
      
      private var _loader:Loader;
      
      private var _width:Number = 16;
      
      private var _height:Number = 16;
      
      public function IconBox(param1:String, param2:Number = 16, param3:Number = 16)
      {
         super();
         this._width = param2;
         this._height = param3;
         this.drawIcon();
         this._loader = new Loader();
         this._loader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.onCompleteHandler);
         this._loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,this.onIOErrorHandler);
         this._loader.load(new URLRequest(param1));
      }
      
      private function onCompleteHandler(param1:Event) : void
      {
         this.addChild(this._loader);
         this.drawIcon();
      }
      
      private function onIOErrorHandler(param1:IOErrorEvent) : void
      {
         this.drawIcon(0.5);
      }
      
      private function drawIcon(param1:Number = 0) : void
      {
         this.graphics.clear();
         this.graphics.beginFill(0,param1);
         this.graphics.drawRect(0,0,this._width,this._height);
         this.graphics.endFill();
      }
   }
}
