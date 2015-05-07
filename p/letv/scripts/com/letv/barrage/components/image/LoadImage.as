package com.letv.barrage.components.image
{
   import flash.display.MovieClip;
   import com.alex.rpc.AutoLoader;
   import flash.system.ApplicationDomain;
   import flash.display.Sprite;
   import com.alex.rpc.events.AutoLoaderEvent;
   import com.alex.rpc.type.ResourceType;
   
   public class LoadImage extends MovieClip
   {
      
      public static const WIDTH:int = 50;
      
      public static const HEIGHT:int = 50;
      
      public static const SCALERATE:Number = 1.25;
      
      private static var _instance:LoadImage;
      
      private var loader:AutoLoader;
      
      private var _url:String;
      
      private var _isComplete:Boolean;
      
      private var domain:ApplicationDomain;
      
      private var _haxe:Object;
      
      private var _imageContainer:Sprite;
      
      public function LoadImage()
      {
         super();
      }
      
      public static function getinstance() : LoadImage
      {
         if(!_instance)
         {
            _instance = new LoadImage();
         }
         return _instance;
      }
      
      public function get imageContainer() : Sprite
      {
         return this._imageContainer;
      }
      
      public function init(param1:String) : void
      {
         this._url = param1;
         this.loadImage();
      }
      
      public function get isComplete() : Boolean
      {
         return this._isComplete;
      }
      
      private function loadHandler(param1:AutoLoaderEvent) : void
      {
         var faceCase:Object = null;
         var list:Array = null;
         var i:int = 0;
         var j:int = 0;
         var c:Class = null;
         var item:MovieClip = null;
         var row:int = 0;
         var line:int = 0;
         var event:AutoLoaderEvent = param1;
         this.loader.removeEventListener(AutoLoaderEvent.LOAD_COMPLETE,this.loadHandler);
         this.loader.removeEventListener(AutoLoaderEvent.LOAD_ERROR,this.loadHandler);
         switch(event.type)
         {
            case AutoLoaderEvent.LOAD_COMPLETE:
               this._isComplete = true;
               faceCase = event.dataProvider.content.content;
               this.domain = faceCase.loaderInfo.applicationDomain;
               this._imageContainer = new Sprite();
               try
               {
                  list = faceCase.list as Array;
               }
               catch(e:Error)
               {
               }
               if(!(this.domain == null) && !(list == null))
               {
                  this._haxe = new Object();
                  i = 0;
                  j = 0;
                  while(i < list.length)
                  {
                     try
                     {
                        c = this.domain.getDefinition(list[i].className) as Class;
                        if(c == null)
                        {
                        }
                        i++;
                        continue;
                     }
                     catch(e:Error)
                     {
                        i++;
                        continue;
                     }
                     item = new c() as MovieClip;
                     if(item != null)
                     {
                        row = j % 3;
                        line = int(j / 3);
                        item.gotoAndStop(1);
                        item.graphics.lineStyle(1,3355443,1);
                        item.graphics.drawRect(-item.back.width * 0.5,-item.back.height * 0.5,item.back.width,item.back.height);
                        item.scaleX = WIDTH / item.back.width;
                        item.scaleY = HEIGHT / item.back.height;
                        item.x = row * WIDTH + WIDTH * 0.5;
                        item.y = line * HEIGHT + HEIGHT * 0.5;
                        item.mouseChildren = false;
                        item.name = list[i].id;
                        this._imageContainer.addChild(item);
                        this._haxe[String(list[i].id)] = list[i];
                        j++;
                     }
                     i++;
                  }
                  addChild(this._imageContainer);
               }
               break;
            case AutoLoaderEvent.LOAD_ERROR:
               this._isComplete = false;
               break;
         }
      }
      
      public function mcPlay(param1:Boolean) : void
      {
         var i:int = 0;
         var item:MovieClip = null;
         var value:Boolean = param1;
         try
         {
            i = 0;
            while(i < this._imageContainer.numChildren)
            {
               item = this._imageContainer.getChildAt(i) as MovieClip;
               if(value)
               {
                  item.gotoAndPlay(1);
               }
               else
               {
                  item.gotoAndStop(1);
               }
               i++;
            }
         }
         catch(e:Error)
         {
         }
      }
      
      public function getContent(param1:*) : MovieClip
      {
         var c:Class = null;
         var item:MovieClip = null;
         var id:* = param1;
         if((id) && (this._haxe) && (this._haxe[String(id)]))
         {
            try
            {
               c = this.domain.getDefinition(this._haxe[String(id)].className) as Class;
               item = new c() as MovieClip;
               item.gotoAndPlay(2);
               return item;
            }
            catch(e:*)
            {
               return null;
            }
            return null;
         }
         return null;
      }
      
      private function loadImage() : void
      {
         var _loc1_:Array = [{
            "type":ResourceType.FLASH,
            "url":this._url
         }];
         trace("_url==========0+0" + this._url);
         this.loader = new AutoLoader();
         this.loader.addEventListener(AutoLoaderEvent.LOAD_COMPLETE,this.loadHandler);
         this.loader.addEventListener(AutoLoaderEvent.LOAD_ERROR,this.loadHandler);
         this.loader.setup(_loc1_);
      }
   }
}
