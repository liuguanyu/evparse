package com.alex.managers
{
   import flash.display.Stage;
   import flash.geom.Rectangle;
   
   public interface ISystemManager
   {
      
      function setMsg(param1:String, param2:Object) : Boolean;
      
      function getMsg(param1:String) : Object;
      
      function delMsg(param1:String) : void;
      
      function addResize(param1:Function) : void;
      
      function removeResize(param1:Function) : void;
      
      function setStage(param1:Stage) : void;
      
      function setFullScreen(param1:Boolean, param2:Boolean = false) : void;
      
      function set screen(param1:Rectangle) : void;
      
      function set applicationWidth(param1:Number) : void;
      
      function get applicationWidth() : Number;
      
      function set applicationHeight(param1:Number) : void;
      
      function get applicationHeight() : Number;
   }
}
