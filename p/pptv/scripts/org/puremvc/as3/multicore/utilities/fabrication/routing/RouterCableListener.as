package org.puremvc.as3.multicore.utilities.fabrication.routing
{
   import org.puremvc.as3.multicore.utilities.pipes.plumbing.PipeListener;
   import org.puremvc.as3.multicore.utilities.fabrication.interfaces.IDisposable;
   import org.puremvc.as3.multicore.interfaces.IFacade;
   import org.puremvc.as3.multicore.utilities.fabrication.interfaces.IRouterMessage;
   import org.puremvc.as3.multicore.utilities.fabrication.patterns.observer.RouterNotification;
   
   public class RouterCableListener extends PipeListener implements IDisposable
   {
      
      protected var facade:IFacade;
      
      public function RouterCableListener(param1:IFacade)
      {
         super(this,this.handleMessage);
         this.facade = param1;
      }
      
      public function dispose() : void
      {
         disconnect();
         this.facade = null;
      }
      
      protected function handleMessage(param1:IRouterMessage) : void
      {
         this.facade.notifyObservers(new RouterNotification(RouterNotification.RECEIVED_MESSAGE_VIA_ROUTER,null,null,param1));
      }
   }
}
