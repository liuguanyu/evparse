package com.alex.controls
{
   import com.alex.core.UIComponent;
   import com.alex.surface.ISurface;
   import com.alex.error.SkinError;
   import com.alex.surface.pc.ImageSurface;
   import com.alex.states.BitmapFillMode;
   import flash.display.BitmapData;
   import flash.geom.ColorTransform;
   import com.alex.rpc.AutoLoader;
   import com.alex.rpc.events.AutoLoaderEvent;
   import com.alex.rpc.type.ResourceType;
   import flash.events.IOErrorEvent;
   import flash.geom.Rectangle;
   import flash.display.Loader;
   import flash.events.Event;
   import flash.display.MovieClip;
   
   public class Image extends UIComponent
   {
      
      protected var _width:uint = 100;
      
      protected var _height:uint = 100;
      
      protected var _image:Loader;
      
      protected var _rect:Rectangle;
      
      protected var _url:String;
      
      protected var _smoothing:Boolean = true;
      
      protected var _fillMode:String = "scale";
      
      protected var _loader:AutoLoader;
      
      protected var s:ImageSurface;
      
      public function Image(param1:MovieClip = null)
      {
         if(param1 == null)
         {
            var param1:MovieClip = new Framework_Default_Skin_Image();
         }
         super(new ImageSurface(param1));
      }
      
      override public function destroy() : void
      {
         this.imageGc();
         this.loadGc();
         this.s = null;
         super.destroy();
      }
      
      override public function set surface(param1:ISurface) : void
      {
         if(this.s != null)
         {
            throw new SkinError("该组件不支持动态修改皮肤",SkinError.SKIN_SET_ERROR);
         }
         else
         {
            super.surface = param1;
            this.s = surface as ImageSurface;
            return;
         }
      }
      
      override public function set width(param1:Number) : void
      {
         this._width = int(param1);
         this.update();
      }
      
      override public function get width() : Number
      {
         if(!(this._rect == null) && this.fillMode == BitmapFillMode.ORIGINAL)
         {
            return this._rect.width;
         }
         return this._width;
      }
      
      override public function set height(param1:Number) : void
      {
         this._height = int(param1);
         this.update();
      }
      
      override public function get height() : Number
      {
         if(!(this._rect == null) && this.fillMode == BitmapFillMode.ORIGINAL)
         {
            return this._rect.height;
         }
         return this._height;
      }
      
      public function get sourceWidth() : uint
      {
         if(this._rect != null)
         {
            return this._rect.width;
         }
         return this._width;
      }
      
      public function get sourceHeight() : uint
      {
         if(this._rect != null)
         {
            return this._rect.height;
         }
         return this._height;
      }
      
      public function get bitmapData() : BitmapData
      {
         try
         {
            return this._image.content["bitmapData"];
         }
         catch(e:Error)
         {
         }
         return null;
      }
      
      public function set backgroundColor(param1:uint) : void
      {
         var _loc2_:ColorTransform = new ColorTransform();
         _loc2_.color = param1;
         this.s.background.transform.colorTransform = _loc2_;
      }
      
      public function set backgroundAlpha(param1:Number) : void
      {
         this.s.background.alpha = param1;
      }
      
      public function set smoothing(param1:Boolean) : void
      {
         var value:Boolean = param1;
         this._smoothing = value;
         try
         {
            this._image.content["smoothing"] = this._smoothing;
         }
         catch(e:Error)
         {
         }
      }
      
      public function get smoothing() : Boolean
      {
         return this._smoothing;
      }
      
      public function set fillMode(param1:String) : void
      {
         this._fillMode = param1;
         this.update();
      }
      
      public function get fillMode() : String
      {
         return this._fillMode;
      }
      
      public function set source(param1:String) : void
      {
         this._url = param1;
         this.loadImage();
      }
      
      public function get source() : String
      {
         return this._url;
      }
      
      override protected function initialize() : void
      {
         super.initialize();
         this.s.container.mask = this.s.masker;
         this.loadImage();
      }
      
      protected function loadImage() : void
      {
         if(this.source != null)
         {
            this.imageGc();
            this.loadGc();
            this._loader = new AutoLoader();
            this._loader.addEventListener(AutoLoaderEvent.LOAD_ERROR,this.onLoadError);
            this._loader.addEventListener(AutoLoaderEvent.LOAD_COMPLETE,this.onLoadComplete);
            this._loader.setup([{
               "url":this.source,
               "type":ResourceType.FLASH
            }]);
         }
      }
      
      protected function onLoadError(param1:AutoLoaderEvent = null) : void
      {
         this.loadGc();
         this.s.container.visible = false;
         this.update();
         dispatchEvent(new IOErrorEvent(IOErrorEvent.IO_ERROR));
      }
      
      protected function onLoadComplete(param1:AutoLoaderEvent) : void
      {
         var event:AutoLoaderEvent = param1;
         try
         {
            this._rect = event.dataProvider.rect as Rectangle;
            this._image = event.dataProvider.content as Loader;
            this.s.container.visible = true;
            this.update();
            dispatchEvent(new Event(Event.COMPLETE));
         }
         catch(e:Error)
         {
            onLoadError();
         }
      }
      
      protected function update() : void
      {
         var _wid:uint = 0;
         var _hei:uint = 0;
         var bitScale:Number = NaN;
         var imageScale:Number = NaN;
         this.s.masker.width = this.width;
         this.s.masker.height = this.height;
         this.s.background.width = this.width;
         this.s.background.height = this.height;
         if(!this.s.container.visible)
         {
            this.s.masker.visible = false;
            return;
         }
         this.s.masker.visible = true;
         if(this._rect == null || this._image == null)
         {
            return;
         }
         _wid = 100;
         _hei = 100;
         if(this._rect != null)
         {
            _wid = this._rect.width;
            _hei = this._rect.height;
         }
         try
         {
            this.s.container.addChild(this._image);
            this._image.content["smoothing"] = this.smoothing;
         }
         catch(e:Error)
         {
         }
         var changeScale:Number = 1;
         switch(this._fillMode)
         {
            case BitmapFillMode.ORIGINAL:
               this._image.x = 0;
               this._image.y = 0;
               this._image.scaleX = changeScale;
               this._image.scaleY = changeScale;
               break;
            case BitmapFillMode.SCALE:
               bitScale = _wid / _hei;
               imageScale = this._width / this._height;
               if(bitScale > imageScale)
               {
                  changeScale = this._width / _wid;
               }
               else
               {
                  changeScale = this._height / _hei;
               }
               this._image.scaleX = changeScale;
               this._image.scaleY = changeScale;
               this._image.x = (this._width - _wid * changeScale) * 0.5;
               this._image.y = (this._height - _hei * changeScale) * 0.5;
               break;
            case BitmapFillMode.CLIP:
               this._image.x = 0;
               this._image.y = 0;
               changeScale = this._width / _wid;
               this._image.scaleX = changeScale;
               changeScale = this._height / _hei;
               this._image.scaleY = changeScale;
               break;
         }
      }
      
      protected function loadGc() : void
      {
         if(this._loader != null)
         {
            this._loader.removeEventListener(AutoLoaderEvent.LOAD_ERROR,this.onLoadError);
            this._loader.removeEventListener(AutoLoaderEvent.LOAD_COMPLETE,this.onLoadComplete);
            this._loader.destroy();
            this._loader = null;
         }
      }
      
      public function imageGc() : void
      {
         try
         {
            this._image.content["bitmapData"].dispose();
         }
         catch(e:Error)
         {
         }
         try
         {
            skin.removeChild(this._image);
         }
         catch(e:Error)
         {
         }
         this._image = null;
         this._rect = null;
      }
   }
}
