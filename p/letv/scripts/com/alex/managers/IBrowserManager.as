package com.alex.managers
{
   public interface IBrowserManager
   {
      
      function callScript(param1:String, ... rest) : Object;
      
      function addCallBack(param1:String, param2:Function) : Boolean;
   }
}
