package org.puremvc.as3.multicore.utilities.pipes.interfaces
{
   public interface IPipeMessage
   {
      
      function getType() : String;
      
      function getHeader() : Object;
      
      function setBody(param1:Object) : void;
      
      function setPriority(param1:int) : void;
      
      function getBody() : Object;
      
      function getPriority() : int;
      
      function setType(param1:String) : void;
      
      function setHeader(param1:Object) : void;
   }
}
