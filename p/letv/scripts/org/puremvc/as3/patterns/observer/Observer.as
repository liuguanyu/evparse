package org.puremvc.as3.patterns.observer
{
   import org.puremvc.as3.interfaces.IObserver;
   import org.puremvc.as3.interfaces.INotification;
   
   public class Observer extends Object implements IObserver
   {
      
      private var notify:Function;
      
      private var context:Object;
      
      public function Observer(param1:Function, param2:Object)
      {
         super();
         this.setNotifyMethod(param1);
         this.setNotifyContext(param2);
      }
      
      public function setNotifyMethod(param1:Function) : void
      {
         this.notify = param1;
      }
      
      public function setNotifyContext(param1:Object) : void
      {
         this.context = param1;
      }
      
      private function getNotifyMethod() : Function
      {
         return this.notify;
      }
      
      private function getNotifyContext() : Object
      {
         return this.context;
      }
      
      public function notifyObserver(param1:INotification) : void
      {
         this.getNotifyMethod().apply(this.getNotifyContext(),[param1]);
      }
      
      public function compareNotifyContext(param1:Object) : Boolean
      {
         return param1 === this.context;
      }
   }
}
