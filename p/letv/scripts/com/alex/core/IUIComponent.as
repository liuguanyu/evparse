package com.alex.core
{
   import flash.events.IEventDispatcher;
   import flash.display.Stage;
   import com.alex.surface.ISurface;
   import flash.display.Graphics;
   import flash.display.MovieClip;
   import flash.display.DisplayObjectContainer;
   import flash.display.DisplayObject;
   
   public interface IUIComponent extends IEventDispatcher
   {
      
      function get stage() : Stage;
      
      function get applicationStage() : Stage;
      
      function set surface(param1:ISurface) : void;
      
      function get surface() : ISurface;
      
      function set viewData(param1:Object) : void;
      
      function get viewData() : Object;
      
      function set enabled(param1:Boolean) : void;
      
      function get enabled() : Boolean;
      
      function set mouseEnabled(param1:Boolean) : void;
      
      function get mouseEnabled() : Boolean;
      
      function set mouseChildren(param1:Boolean) : void;
      
      function get mouseChildren() : Boolean;
      
      function set doubleClickEnabled(param1:Boolean) : void;
      
      function get doubleClickEnabled() : Boolean;
      
      function set buttonMode(param1:Boolean) : void;
      
      function get buttonMode() : Boolean;
      
      function set name(param1:String) : void;
      
      function get name() : String;
      
      function set scaleX(param1:Number) : void;
      
      function get scaleX() : Number;
      
      function set scaleY(param1:Number) : void;
      
      function get scaleY() : Number;
      
      function set x(param1:Number) : void;
      
      function get x() : Number;
      
      function set y(param1:Number) : void;
      
      function get y() : Number;
      
      function get mouseX() : Number;
      
      function get mouseY() : Number;
      
      function set width(param1:Number) : void;
      
      function get width() : Number;
      
      function set height(param1:Number) : void;
      
      function get height() : Number;
      
      function set alpha(param1:Number) : void;
      
      function get alpha() : Number;
      
      function set visible(param1:Boolean) : void;
      
      function get visible() : Boolean;
      
      function set cacheAsBitmap(param1:Boolean) : void;
      
      function get cacheAsBitmap() : Boolean;
      
      function get graphics() : Graphics;
      
      function set tabChildren(param1:Boolean) : void;
      
      function get tabChildren() : Boolean;
      
      function set tabEnabled(param1:Boolean) : void;
      
      function get tabEnabled() : Boolean;
      
      function set filters(param1:Array) : void;
      
      function get filters() : Array;
      
      function set tooltip(param1:String) : void;
      
      function get tooltip() : String;
      
      function set fullscreen(param1:Boolean) : void;
      
      function get fullscreen() : Boolean;
      
      function get skin() : MovieClip;
      
      function get parent() : DisplayObjectContainer;
      
      function get applicationWidth() : Number;
      
      function get applicationHeight() : Number;
      
      function addChild(param1:DisplayObject) : DisplayObject;
      
      function removeChild(param1:DisplayObject) : DisplayObject;
      
      function addChildAt(param1:DisplayObject, param2:int) : DisplayObject;
      
      function removeChildAt(param1:int) : DisplayObject;
      
      function setMsg(param1:String, param2:Object) : Boolean;
      
      function getMsg(param1:String) : Object;
      
      function getFocus() : void;
      
      function destroy() : void;
   }
}
