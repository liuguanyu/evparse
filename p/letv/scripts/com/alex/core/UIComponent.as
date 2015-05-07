package com.alex.core
{
   import flash.events.EventDispatcher;
   import flash.display.Stage;
   import flash.display.MovieClip;
   import flash.display.DisplayObjectContainer;
   import com.alex.surface.ISurface;
   import flash.filters.BlurFilter;
   import flash.display.Graphics;
   import flash.display.StageDisplayState;
   import flash.display.DisplayObject;
   import flash.events.Event;
   import com.alex.managers.ISystemManager;
   import com.alex.managers.IFocusManager;
   import com.alex.managers.ICursorManager;
   import com.alex.managers.IToolTipManager;
   import com.alex.managers.IAlertManager;
   import com.alex.managers.IBrowserManager;
   
   public class UIComponent extends EventDispatcher implements IUIComponent
   {
      
      protected var _enabled:Boolean = true;
      
      protected var _viewData:Object = null;
      
      protected var _surface:ISurface = null;
      
      protected var application:Object;
      
      public function UIComponent(param1:ISurface = null, param2:Object = null)
      {
         this.application = Application.application;
         super();
         this.surface = param1;
         this._viewData = param2;
         this.initialize();
      }
      
      public function destroy() : void
      {
         this._viewData = null;
         this._surface = null;
         this.application = null;
      }
      
      public function get stage() : Stage
      {
         if(this.skin != null)
         {
            return this.skin.stage;
         }
         return null;
      }
      
      public function get applicationStage() : Stage
      {
         return this.application.stage;
      }
      
      public function get skin() : MovieClip
      {
         if(this._surface != null)
         {
            return this._surface.skin;
         }
         return null;
      }
      
      public function get parent() : DisplayObjectContainer
      {
         if(this.skin != null)
         {
            return this.skin.parent;
         }
         return null;
      }
      
      public function set surface(param1:ISurface) : void
      {
         this._surface = param1;
      }
      
      public function get surface() : ISurface
      {
         return this._surface;
      }
      
      public function set viewData(param1:Object) : void
      {
         this._viewData = param1;
      }
      
      public function get viewData() : Object
      {
         return this._viewData;
      }
      
      public function set enabled(param1:Boolean) : void
      {
         this._enabled = param1;
         this.mouseEnabled = param1;
         this.mouseChildren = param1;
         this.filters = param1?null:[new BlurFilter(2,2)];
      }
      
      public function get enabled() : Boolean
      {
         return this._enabled;
      }
      
      public function set mouseEnabled(param1:Boolean) : void
      {
         if(this.skin != null)
         {
            this.skin.mouseEnabled = param1;
         }
      }
      
      public function get mouseEnabled() : Boolean
      {
         if(this.skin != null)
         {
            return this.skin.mouseEnabled;
         }
         return false;
      }
      
      public function set mouseChildren(param1:Boolean) : void
      {
         if(this.skin != null)
         {
            this.skin.mouseChildren = param1;
         }
      }
      
      public function get mouseChildren() : Boolean
      {
         if(this.skin != null)
         {
            return this.skin.mouseChildren;
         }
         return false;
      }
      
      public function set doubleClickEnabled(param1:Boolean) : void
      {
         if(this.skin != null)
         {
            this.skin.doubleClickEnabled = param1;
         }
      }
      
      public function get doubleClickEnabled() : Boolean
      {
         if(this.skin != null)
         {
            return this.skin.doubleClickEnabled;
         }
         return false;
      }
      
      public function set buttonMode(param1:Boolean) : void
      {
         if(this.skin != null)
         {
            this.skin.buttonMode = param1;
         }
      }
      
      public function get buttonMode() : Boolean
      {
         if(this.skin != null)
         {
            return this.skin.buttonMode;
         }
         return false;
      }
      
      public function set name(param1:String) : void
      {
         if(this.skin != null)
         {
            this.skin.name = param1;
         }
      }
      
      public function get name() : String
      {
         if(this.skin != null)
         {
            return this.skin.name;
         }
         return null;
      }
      
      public function set scaleX(param1:Number) : void
      {
         if(this.skin != null)
         {
            this.skin.scaleX = param1;
         }
      }
      
      public function get scaleX() : Number
      {
         if(this.skin != null)
         {
            return this.skin.scaleX;
         }
         return 1;
      }
      
      public function set scaleY(param1:Number) : void
      {
         if(this.skin != null)
         {
            this.skin.scaleY = param1;
         }
      }
      
      public function get scaleY() : Number
      {
         if(this.skin != null)
         {
            return this.skin.scaleY;
         }
         return 1;
      }
      
      public function set x(param1:Number) : void
      {
         if(this.skin != null)
         {
            this.skin.x = param1;
         }
      }
      
      public function get x() : Number
      {
         if(this.skin != null)
         {
            return this.skin.x;
         }
         return 0;
      }
      
      public function set y(param1:Number) : void
      {
         if(this.skin != null)
         {
            this.skin.y = param1;
         }
      }
      
      public function get y() : Number
      {
         if(this.skin != null)
         {
            return this.skin.y;
         }
         return 0;
      }
      
      public function get mouseX() : Number
      {
         if(this.skin != null)
         {
            return this.skin.mouseX;
         }
         return 0;
      }
      
      public function get mouseY() : Number
      {
         if(this.skin != null)
         {
            return this.skin.mouseY;
         }
         return 0;
      }
      
      public function set width(param1:Number) : void
      {
         if(this.skin != null)
         {
            this.skin.width = param1;
         }
      }
      
      public function get width() : Number
      {
         if(this.skin != null)
         {
            return this.skin.width;
         }
         return 0;
      }
      
      public function set height(param1:Number) : void
      {
         if(this.skin != null)
         {
            this.skin.height = param1;
         }
      }
      
      public function get height() : Number
      {
         if(this.skin != null)
         {
            return this.skin.height;
         }
         return 0;
      }
      
      public function set alpha(param1:Number) : void
      {
         if(this.skin != null)
         {
            this.skin.alpha = param1;
         }
      }
      
      public function get alpha() : Number
      {
         if(this.skin != null)
         {
            return this.skin.alpha;
         }
         return 0;
      }
      
      public function set visible(param1:Boolean) : void
      {
         if(this.skin != null)
         {
            this.skin.visible = param1;
         }
      }
      
      public function get visible() : Boolean
      {
         if(this.skin != null)
         {
            return this.skin.visible;
         }
         return false;
      }
      
      public function set cacheAsBitmap(param1:Boolean) : void
      {
         if(this.skin != null)
         {
            this.skin.cacheAsBitmap = param1;
         }
      }
      
      public function get cacheAsBitmap() : Boolean
      {
         if(this.skin != null)
         {
            return this.skin.cacheAsBitmap;
         }
         return false;
      }
      
      public function set tabChildren(param1:Boolean) : void
      {
         if(this.skin != null)
         {
            this.skin.tabChildren = param1;
         }
      }
      
      public function get graphics() : Graphics
      {
         if(this.skin != null)
         {
            return this.skin.graphics;
         }
         return null;
      }
      
      public function get tabChildren() : Boolean
      {
         if(this.skin != null)
         {
            return this.skin.tabChildren;
         }
         return false;
      }
      
      public function set tabEnabled(param1:Boolean) : void
      {
         if(this.skin != null)
         {
            this.skin.tabEnabled = param1;
         }
      }
      
      public function get tabEnabled() : Boolean
      {
         if(this.skin != null)
         {
            return this.skin.tabEnabled;
         }
         return false;
      }
      
      public function set filters(param1:Array) : void
      {
         if(this.skin != null)
         {
            this.skin.filters = param1;
         }
      }
      
      public function get filters() : Array
      {
         if(this.skin != null)
         {
            return this.skin.filters;
         }
         return null;
      }
      
      public function set tooltip(param1:String) : void
      {
         if(param1 != null)
         {
            this.tooltipManager.regist(this.skin,param1);
         }
         else
         {
            this.tooltipManager.remove(this.skin);
         }
      }
      
      public function get tooltip() : String
      {
         return this.tooltipManager.getContent(this.skin);
      }
      
      public function set fullscreen(param1:Boolean) : void
      {
         this.systemManager.setFullScreen(param1);
      }
      
      public function get fullscreen() : Boolean
      {
         if(this.applicationStage != null)
         {
            return !(this.applicationStage.displayState == StageDisplayState.NORMAL);
         }
         return false;
      }
      
      public function get applicationWidth() : Number
      {
         return this.application.width;
      }
      
      public function get applicationHeight() : Number
      {
         return this.application.height;
      }
      
      public function setMsg(param1:String, param2:Object) : Boolean
      {
         return this.systemManager.setMsg(param1,param2);
      }
      
      public function delMsg(param1:String) : void
      {
         return this.systemManager.delMsg(param1);
      }
      
      public function addChild(param1:DisplayObject) : DisplayObject
      {
         if(this.skin != null)
         {
            return this.skin.addChild(param1);
         }
         return null;
      }
      
      public function removeChild(param1:DisplayObject) : DisplayObject
      {
         if(!(this.skin == null) && (this.skin.contains(param1)))
         {
            return this.skin.removeChild(param1);
         }
         return null;
      }
      
      public function addChildAt(param1:DisplayObject, param2:int) : DisplayObject
      {
         if(this.skin != null)
         {
            return this.skin.addChildAt(param1,param2);
         }
         return null;
      }
      
      public function removeChildAt(param1:int) : DisplayObject
      {
         if(!(this.skin == null) && !(this.skin.getChildAt(param1) == null))
         {
            return this.skin.removeChildAt(param1);
         }
         return null;
      }
      
      public function getMsg(param1:String) : Object
      {
         return this.systemManager.getMsg(param1);
      }
      
      public function getFocus() : void
      {
         if(this.stage != null)
         {
            this.stage.focus = this.skin;
         }
      }
      
      override public function addEventListener(param1:String, param2:Function, param3:Boolean = false, param4:int = 0, param5:Boolean = false) : void
      {
         if(this.skin != null)
         {
            this.skin.addEventListener(param1,param2,param3,param4,param5);
         }
         else
         {
            super.addEventListener(param1,param2,param3,param4,param5);
         }
      }
      
      override public function removeEventListener(param1:String, param2:Function, param3:Boolean = false) : void
      {
         if(this.skin != null)
         {
            this.skin.removeEventListener(param1,param2,param3);
         }
         else
         {
            super.removeEventListener(param1,param2,param3);
         }
      }
      
      override public function dispatchEvent(param1:Event) : Boolean
      {
         if(this.skin != null)
         {
            return this.skin.dispatchEvent(param1);
         }
         return super.dispatchEvent(param1);
      }
      
      protected function get parentApplication() : Object
      {
         return this.application;
      }
      
      protected function get systemManager() : ISystemManager
      {
         return (this.application as Application).systemManager;
      }
      
      protected function get focusManager() : IFocusManager
      {
         return (this.application as Application).focusManager;
      }
      
      protected function get cursorManager() : ICursorManager
      {
         return (this.application as Application).cursorManager;
      }
      
      protected function get tooltipManager() : IToolTipManager
      {
         return (this.application as Application).tooltipManager;
      }
      
      protected function get alertManager() : IAlertManager
      {
         return (this.application as Application).alertManager;
      }
      
      protected function get browserManager() : IBrowserManager
      {
         return (this.application as Application).browserManager;
      }
      
      protected function addAppResize(param1:Function) : void
      {
         this.systemManager.addResize(param1);
      }
      
      protected function removeAppResize(param1:Function) : void
      {
         this.systemManager.removeResize(param1);
      }
      
      protected function clearparent() : DisplayObjectContainer
      {
         if(this.surface == null)
         {
            return null;
         }
         if(this.skin == null)
         {
            return null;
         }
         if(this.skin.parent == null)
         {
            return null;
         }
         var _loc1_:DisplayObjectContainer = this.skin.parent;
         _loc1_.removeChild(this.skin);
         return _loc1_;
      }
      
      protected function initialize() : void
      {
         if(this.stageChanged)
         {
            this.addEventListener(Event.ADDED_TO_STAGE,this.onAddedToStage);
            this.addEventListener(Event.REMOVED_FROM_STAGE,this.onRemovedFromStage);
         }
      }
      
      protected function renderer() : void
      {
      }
      
      protected function get stageChanged() : Boolean
      {
         return false;
      }
      
      protected function onAddedToStage(param1:Event = null) : void
      {
      }
      
      protected function onRemovedFromStage(param1:Event = null) : void
      {
      }
   }
}
