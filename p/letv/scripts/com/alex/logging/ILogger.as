package com.alex.logging
{
   public interface ILogger
   {
      
      function info(param1:String) : void;
      
      function warn(param1:String) : void;
      
      function error(param1:String) : void;
      
      function fault(param1:String) : void;
   }
}
