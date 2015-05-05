package org.puremvc.as3.multicore.utilities.fabrication.patterns.command.routing
{
   import org.puremvc.as3.multicore.utilities.fabrication.patterns.command.SimpleFabricationCommand;
   import org.puremvc.as3.multicore.interfaces.INotification;
   import org.puremvc.as3.multicore.utilities.fabrication.patterns.observer.RouterNotification;
   import org.puremvc.as3.multicore.utilities.fabrication.interfaces.IRouterMessage;
   import org.puremvc.as3.multicore.utilities.fabrication.patterns.observer.TransportNotification;
   import org.puremvc.as3.multicore.utilities.fabrication.interfaces.IRouterMessageStore;
   
   public class RouteMessageCommand extends SimpleFabricationCommand
   {
      
      public function RouteMessageCommand()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         var _loc6_:INotification = null;
         var _loc2_:RouterNotification = param1 as RouterNotification;
         var _loc3_:IRouterMessage = _loc2_.getMessage();
         var _loc4_:TransportNotification = _loc3_.getNotification();
         var _loc5_:INotification = _loc4_.getCustomNotification();
         if(_loc5_ == null)
         {
            _loc6_ = new RouterNotification(_loc4_.getName(),_loc4_.getBody(),_loc4_.getType(),_loc3_);
         }
         else
         {
            _loc6_ = _loc5_;
            if(_loc6_ is IRouterMessageStore)
            {
               (_loc6_ as IRouterMessageStore).setMessage(_loc3_);
            }
         }
         fabFacade.notifyObservers(_loc6_);
      }
   }
}
