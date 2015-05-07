package com.letv.player.components
{
   import flash.events.EventDispatcher;
   import flash.system.ApplicationDomain;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.filters.BlurFilter;
   
   public class UIComponent extends EventDispatcher
   {
      
      public static var domain:ApplicationDomain;
      
      protected var _config:Object;
      
      protected var _skin:MovieClip;
      
      public function UIComponent(param1:Object = null, param2:Object = null)
      {
         super();
         this._skin = param1 as MovieClip;
         this._config = param2;
         this.initConfig();
         this.init();
      }
      
      public function destroy() : void
      {
         if(this.skin)
         {
            this.skin.removeEventListener(Event.ADDED_TO_STAGE,this.addedToStage);
            this.skin.removeEventListener(Event.REMOVED_FROM_STAGE,this.removedFromStage);
            if(this.skin.stage)
            {
               this.skin.stage.removeEventListener(Event.RESIZE,this.stageResize);
            }
         }
      }
      
      public function set enabled(param1:Boolean) : void
      {
         if(this._skin != null)
         {
            if(param1)
            {
               this._skin.mouseEnabled = true;
               this._skin.mouseChildren = true;
               this._skin.filters = null;
               this._skin.alpha = 1;
            }
            else
            {
               this._skin.mouseEnabled = false;
               this._skin.mouseChildren = false;
               this._skin.filters = [new BlurFilter(2,2)];
               this._skin.alpha = 0.8;
            }
         }
      }
      
      public function set buttonMode(param1:Boolean) : void
      {
         var value:Boolean = param1;
         try
         {
            this._skin.buttonMode = value;
         }
         catch(e:Error)
         {
         }
      }
      
      public function set visible(param1:Boolean) : void
      {
         var flag:Boolean = param1;
         try
         {
            this._skin.visible = flag;
         }
         catch(e:Error)
         {
         }
      }
      
      public function get visible() : Boolean
      {
         try
         {
            return this._skin.visible;
         }
         catch(e:Error)
         {
         }
         return false;
      }
      
      public function get enabled() : Boolean
      {
         try
         {
            return this._skin.mouseEnabled;
         }
         catch(e:Error)
         {
         }
         return false;
      }
      
      public function set alpha(param1:Number) : void
      {
         if(this.skin)
         {
            this.skin.alpha = param1;
         }
      }
      
      public function get alpha() : Number
      {
         if(this.skin)
         {
            return this.skin.alpha;
         }
         return 0;
      }
      
      public function get surface() : MovieClip
      {
         return this._skin;
      }
      
      public function get skin() : MovieClip
      {
         return this._skin;
      }
      
      public function get conf() : Object
      {
         return this._config;
      }
      
      public function get width() : Number
      {
         try
         {
            return this._skin.width;
         }
         catch(e:Error)
         {
         }
         return 0;
      }
      
      public function get height() : Number
      {
         try
         {
            return this._skin.height;
         }
         catch(e:Error)
         {
         }
         return 0;
      }
      
      public function set cacheAsBitmap(param1:Boolean) : void
      {
         if(this._skin)
         {
            this._skin.cacheAsBitmap = param1;
         }
      }
      
      public function get cacheAsBitmap() : Boolean
      {
         if(this._skin)
         {
            return this._skin.cacheAsBitmap;
         }
         return false;
      }
      
      public function set mouseEnabled(param1:Boolean) : void
      {
         if(this._skin != null)
         {
            this._skin.mouseEnabled = param1;
         }
      }
      
      public function get mouseEnabled() : Boolean
      {
         if(this._skin != null)
         {
            return this._skin.mouseEnabled;
         }
         return false;
      }
      
      public function set mouseChildren(param1:Boolean) : void
      {
         if(this._skin != null)
         {
            this._skin.mouseChildren = param1;
         }
      }
      
      public function get mouseChildren() : Boolean
      {
         if(this._skin != null)
         {
            return this._skin.mouseChildren;
         }
         return false;
      }
      
      public function set x(param1:Number) : void
      {
         var value:Number = param1;
         try
         {
            this._skin.x = value;
         }
         catch(e:Error)
         {
         }
      }
      
      public function get x() : Number
      {
         try
         {
            return this._skin.x;
         }
         catch(e:Error)
         {
         }
         return 0;
      }
      
      public function set y(param1:Number) : void
      {
         var value:Number = param1;
         try
         {
            this._skin.y = value;
         }
         catch(e:Error)
         {
         }
      }
      
      public function get y() : Number
      {
         try
         {
            return this._skin.y;
         }
         catch(e:Error)
         {
         }
         return 0;
      }
      
      public function clearparent() : void
      {
         try
         {
            this.skin.parent.removeChild(this.skin);
         }
         catch(e:Error)
         {
         }
      }
      
      protected function init() : void
      {
         if(this.skin != null)
         {
            this.skin.addEventListener(Event.ADDED_TO_STAGE,this.addedToStage);
            this.skin.addEventListener(Event.REMOVED_FROM_STAGE,this.removedFromStage);
         }
      }
      
      protected function initConfig() : void
      {
      }
      
      private function addedToStage(param1:Event) : void
      {
         this.onAddedToStage(param1);
         this.skin.stage.addEventListener(Event.RESIZE,this.stageResize);
      }
      
      private function removedFromStage(param1:Event) : void
      {
         this.onRemovedFromStage(param1);
         this.skin.stage.removeEventListener(Event.RESIZE,this.stageResize);
      }
      
      private function stageResize(param1:Event) : void
      {
         this.onStageResize(param1);
      }
      
      protected function onAddedToStage(param1:Event = null) : void
      {
      }
      
      protected function onRemovedFromStage(param1:Event = null) : void
      {
      }
      
      protected function onStageResize(param1:Event = null) : void
      {
      }
   }
}
