package com.alex.core
{
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.display.StageAlign;
   import flash.display.StageScaleMode;
   import flash.geom.Point;
   import flash.geom.Vector3D;
   import flash.display.DisplayObject;
   import flash.display.StageDisplayState;
   import flash.display.MovieClip;
   import com.alex.surface.pc.AlertSurface;
   import com.alex.surface.pc.ToolTipSurface;
   import com.alex.managers.ISystemManager;
   import com.alex.managers.IFocusManager;
   import com.alex.managers.ICursorManager;
   import com.alex.managers.IToolTipManager;
   import com.alex.managers.IAlertManager;
   import com.alex.managers.IBrowserManager;
   import com.alex.error.FrameworkError;
   import com.alex.managers.SystemManager;
   import com.alex.managers.FocusManager;
   import com.alex.managers.CursorManager;
   import com.alex.managers.ToolTipManager;
   import com.alex.managers.AlertManager;
   import com.alex.managers.BrowserManager;
   import com.alex.managers.LayerManager;
   
   public class Application extends Sprite implements IContainer
   {
      
      private static var _app:Application;
      
      public var systemManager:ISystemManager;
      
      public var focusManager:IFocusManager;
      
      public var cursorManager:ICursorManager;
      
      public var tooltipManager:IToolTipManager;
      
      public var alertManager:IAlertManager;
      
      public var browserManager:IBrowserManager;
      
      public var layerManager:IContainer;
      
      public function Application()
      {
         super();
         if(_app != null)
         {
            throw new FrameworkError("应用程序必须唯一",FrameworkError.APP_UNIQUE_ERROR);
         }
         else
         {
            _app = this;
            this.systemManager = new SystemManager();
            this.focusManager = new FocusManager();
            this.cursorManager = new CursorManager();
            this.tooltipManager = new ToolTipManager();
            this.alertManager = new AlertManager();
            this.browserManager = new BrowserManager();
            this.layerManager = new LayerManager();
            addChild((this.layerManager as IUIComponent).skin);
            addChild((this.tooltipManager as IUIComponent).skin);
            addChild((this.alertManager as IUIComponent).skin);
            if(stage != null)
            {
               this.onInit();
            }
            else
            {
               addEventListener(Event.ADDED_TO_STAGE,this.onInit);
            }
            return;
         }
      }
      
      public static function get application() : Application
      {
         return _app;
      }
      
      private function onInit(param1:Event = null) : void
      {
         removeEventListener(Event.ADDED_TO_STAGE,this.onInit);
         stage.stageFocusRect = false;
         stage.align = StageAlign.TOP_LEFT;
         stage.scaleMode = StageScaleMode.NO_SCALE;
         this.systemManager.setStage(stage);
         this.focusManager.setStage(stage);
      }
      
      override public function set doubleClickEnabled(param1:Boolean) : void
      {
         super.doubleClickEnabled = param1;
         (this.layerManager as UIComponent).doubleClickEnabled = param1;
      }
      
      override public function set width(param1:Number) : void
      {
         this.systemManager.applicationWidth = param1;
      }
      
      override public function get width() : Number
      {
         return this.systemManager.applicationWidth;
      }
      
      override public function set height(param1:Number) : void
      {
         this.systemManager.applicationHeight = param1;
      }
      
      override public function get height() : Number
      {
         return this.systemManager.applicationHeight;
      }
      
      override public function globalToLocal(param1:Point) : Point
      {
         return this.layerManager.globalToLocal(param1);
      }
      
      override public function globalToLocal3D(param1:Point) : Vector3D
      {
         return this.layerManager.globalToLocal3D(param1);
      }
      
      public function addElement(param1:IUIComponent) : DisplayObject
      {
         return this.layerManager.addElement(param1);
      }
      
      public function removeElement(param1:IUIComponent) : DisplayObject
      {
         return this.layerManager.removeElement(param1);
      }
      
      public function containsElement(param1:IUIComponent) : Boolean
      {
         return this.layerManager.containsElement(param1);
      }
      
      public function getElementIndex(param1:IUIComponent) : int
      {
         return this.layerManager.getElementIndex(param1);
      }
      
      public function removeElementAt(param1:int) : DisplayObject
      {
         return this.layerManager.removeElementAt(param1);
      }
      
      public function setElementIndex(param1:IUIComponent, param2:int) : void
      {
         this.layerManager.setElementIndex(param1,param2);
      }
      
      public function swapElement(param1:IUIComponent, param2:IUIComponent) : void
      {
         this.layerManager.swapElement(param1,param2);
      }
      
      public function get numElement() : int
      {
         return this.layerManager.numElement;
      }
      
      public function get fullscreen() : Boolean
      {
         if(stage != null)
         {
            return !(stage.displayState == StageDisplayState.NORMAL);
         }
         return false;
      }
      
      public function setMsg(param1:String, param2:Object) : Boolean
      {
         return this.systemManager.setMsg(param1,param2);
      }
      
      public function getMsg(param1:String) : Object
      {
         return this.systemManager.getMsg(param1);
      }
      
      public function delMsg(param1:String) : void
      {
         return this.systemManager.delMsg(param1);
      }
      
      public function setAlertSkin(param1:MovieClip) : void
      {
         (this.alertManager as IUIComponent).surface = new AlertSurface(param1);
         addChild((this.layerManager as IUIComponent).skin);
         addChild((this.tooltipManager as IUIComponent).skin);
         addChild((this.alertManager as IUIComponent).skin);
      }
      
      public function setToolTipSkin(param1:MovieClip) : void
      {
         (this.tooltipManager as IUIComponent).surface = new ToolTipSurface(param1);
         addChild((this.layerManager as IUIComponent).skin);
         addChild((this.tooltipManager as IUIComponent).skin);
         addChild((this.alertManager as IUIComponent).skin);
      }
   }
}
