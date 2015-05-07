package com.alex.managers
{
   import flash.external.ExternalInterface;
   
   public final class BrowserManager extends Object implements IBrowserManager
   {
      
      public function BrowserManager()
      {
         super();
      }
      
      public function callScript(param1:String, ... rest) : Object
      {
         var functionName:String = param1;
         var args:Array = rest;
         try
         {
            args.unshift(functionName);
            return ExternalInterface.call.apply(null,args);
         }
         catch(e:Error)
         {
         }
         return null;
      }
      
      public function addCallBack(param1:String, param2:Function) : Boolean
      {
         var functionName:String = param1;
         var callbackFunction:Function = param2;
         try
         {
            ExternalInterface.addCallback(functionName,callbackFunction);
            return true;
         }
         catch(e:Error)
         {
         }
         return false;
      }
   }
}
