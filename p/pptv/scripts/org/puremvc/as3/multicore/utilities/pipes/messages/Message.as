package org.puremvc.as3.multicore.utilities.pipes.messages
{
   import org.puremvc.as3.multicore.utilities.pipes.interfaces.IPipeMessage;
   
   public class Message extends Object implements IPipeMessage
   {
      
      public static const PRIORITY_MED:int = 5;
      
      public static const NORMAL:String = BASE + "normal/";
      
      protected static const BASE:String = "http://puremvc.org/namespaces/pipes/messages/";
      
      public static const PRIORITY_LOW:int = 10;
      
      public static const PRIORITY_HIGH:int = 1;
      
      protected var body:Object;
      
      protected var priority:int;
      
      protected var header:Object;
      
      protected var type:String;
      
      public function Message(param1:String, param2:Object = null, param3:Object = null, param4:int = 5)
      {
         super();
         setType(param1);
         setHeader(param2);
         setBody(param3);
         setPriority(param4);
      }
      
      public function setPriority(param1:int) : void
      {
         this.priority = param1;
      }
      
      public function getPriority() : int
      {
         return priority;
      }
      
      public function getHeader() : Object
      {
         return header;
      }
      
      public function setHeader(param1:Object) : void
      {
         this.header = param1;
      }
      
      public function getType() : String
      {
         return this.type;
      }
      
      public function setBody(param1:Object) : void
      {
         this.body = param1;
      }
      
      public function getBody() : Object
      {
         return body;
      }
      
      public function setType(param1:String) : void
      {
         this.type = param1;
      }
   }
}
