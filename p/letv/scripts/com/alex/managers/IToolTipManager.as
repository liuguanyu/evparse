package com.alex.managers
{
   import flash.display.DisplayObject;
   
   public interface IToolTipManager
   {
      
      function regist(param1:DisplayObject, param2:String, param3:Boolean = false) : void;
      
      function remove(param1:DisplayObject) : void;
      
      function getContent(param1:DisplayObject) : String;
   }
}
