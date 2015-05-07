package org.puremvc.as3.interfaces
{
   public interface INotification
   {
      
      function getName() : String;
      
      function setBody(param1:Object) : void;
      
      function getBody() : Object;
      
      function setType(param1:String) : void;
      
      function getType() : String;
      
      function toString() : String;
   }
}
