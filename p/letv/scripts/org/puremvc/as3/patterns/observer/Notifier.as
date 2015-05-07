package org.puremvc.as3.patterns.observer
{
   import org.puremvc.as3.interfaces.INotifier;
   import org.puremvc.as3.interfaces.IFacade;
   import org.puremvc.as3.patterns.facade.Facade;
   
   public class Notifier extends Object implements INotifier
   {
      
      protected var facade:IFacade;
      
      public function Notifier()
      {
         this.facade = Facade.getInstance();
         super();
      }
      
      public function sendNotification(param1:String, param2:Object = null, param3:String = null) : void
      {
         this.facade.sendNotification(param1,param2,param3);
      }
   }
}
