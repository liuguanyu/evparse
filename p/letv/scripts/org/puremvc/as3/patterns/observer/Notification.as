package org.puremvc.as3.patterns.observer
{
   import org.puremvc.as3.interfaces.*;
   
   public class Notification extends Object implements INotification
   {
      
      private var name:String;
      
      private var type:String;
      
      private var body:Object;
      
      public function Notification(param1:String, param2:Object = null, param3:String = null)
      {
         super();
         this.name = param1;
         this.body = param2;
         this.type = param3;
      }
      
      public function getName() : String
      {
         return this.name;
      }
      
      public function setBody(param1:Object) : void
      {
         this.body = param1;
      }
      
      public function getBody() : Object
      {
         return this.body;
      }
      
      public function setType(param1:String) : void
      {
         this.type = param1;
      }
      
      public function getType() : String
      {
         return this.type;
      }
      
      public function toString() : String
      {
         var _loc1_:String = "Notification Name: " + this.getName();
         _loc1_ = _loc1_ + ("\nBody:" + (this.body == null?"null":this.body.toString()));
         _loc1_ = _loc1_ + ("\nType:" + (this.type == null?"null":this.type));
         return _loc1_;
      }
   }
}
