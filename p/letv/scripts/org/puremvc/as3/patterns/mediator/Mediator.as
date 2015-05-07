package org.puremvc.as3.patterns.mediator
{
   import org.puremvc.as3.patterns.observer.Notifier;
   import org.puremvc.as3.interfaces.IMediator;
   import org.puremvc.as3.interfaces.INotifier;
   import org.puremvc.as3.interfaces.INotification;
   
   public class Mediator extends Notifier implements IMediator, INotifier
   {
      
      public static const NAME:String = "Mediator";
      
      protected var mediatorName:String;
      
      protected var viewComponent:Object;
      
      public function Mediator(param1:String = null, param2:Object = null)
      {
         super();
         this.mediatorName = param1 != null?param1:NAME;
         this.viewComponent = param2;
      }
      
      public function getMediatorName() : String
      {
         return this.mediatorName;
      }
      
      public function setViewComponent(param1:Object) : void
      {
         this.viewComponent = param1;
      }
      
      public function getViewComponent() : Object
      {
         return this.viewComponent;
      }
      
      public function listNotificationInterests() : Array
      {
         return [];
      }
      
      public function handleNotification(param1:INotification) : void
      {
      }
      
      public function onRegister() : void
      {
      }
      
      public function onRemove() : void
      {
      }
   }
}
