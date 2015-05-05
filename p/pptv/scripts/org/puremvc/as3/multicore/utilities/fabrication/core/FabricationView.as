package org.puremvc.as3.multicore.utilities.fabrication.core
{
   import org.puremvc.as3.multicore.core.View;
   import org.puremvc.as3.multicore.utilities.fabrication.interfaces.IDisposable;
   import org.puremvc.as3.multicore.utilities.fabrication.logging.FabricationLogger;
   import org.puremvc.as3.multicore.interfaces.INotification;
   import org.puremvc.as3.multicore.utilities.fabrication.patterns.proxy.FabricationProxy;
   import org.puremvc.as3.multicore.interfaces.IMediator;
   import org.puremvc.as3.multicore.utilities.fabrication.patterns.observer.FabricationNotification;
   
   public class FabricationView extends View implements IDisposable
   {
      
      public var logger:FabricationLogger;
      
      protected var allowedNote:INotification;
      
      protected var _controller:FabricationController;
      
      public function FabricationView(param1:String)
      {
         super(param1);
      }
      
      public static function getInstance(param1:String) : FabricationView
      {
         if(instanceMap[param1] == null)
         {
            instanceMap[param1] = new FabricationView(param1);
         }
         return instanceMap[param1] as FabricationView;
      }
      
      override public function notifyObservers(param1:INotification) : void
      {
         var _loc2_:* = false;
         var _loc3_:String = null;
         if(!(this.allowedNote == null) && param1 == this.allowedNote || this.controller == null)
         {
            super.notifyObservers(param1);
            this.allowedNote = null;
         }
         else
         {
            _loc2_ = this.controller.intercept(param1);
            if(!_loc2_)
            {
               _loc3_ = param1.getName();
               if(_loc3_ == FabricationProxy.NOTIFICATION_FROM_PROXY)
               {
                  _loc3_ = (param1.getBody() as INotification).getName();
               }
               if(!this.isFrameworkNotification(_loc3_) && observerMap[_loc3_] == null)
               {
                  this.logger.warn("No observers registered for notification [ " + _loc3_ + " ]");
               }
               super.notifyObservers(param1);
               this.allowedNote = null;
            }
         }
      }
      
      public function notifyObserversAfterInterception(param1:INotification) : void
      {
         this.allowedNote = param1;
         this.notifyObservers(param1);
      }
      
      public function dispose() : void
      {
         var _loc1_:IMediator = null;
         for each(_loc1_ in mediatorMap)
         {
            if(_loc1_ is IDisposable)
            {
               (_loc1_ as IDisposable).dispose();
            }
         }
         mediatorMap = null;
         removeView(multitonKey);
         this.allowedNote = null;
         this._controller = null;
      }
      
      public function get controller() : FabricationController
      {
         return this._controller;
      }
      
      public function set controller(param1:FabricationController) : void
      {
         this._controller = param1;
      }
      
      private function isFrameworkNotification(param1:String) : Boolean
      {
         return param1 == FabricationNotification.BOOTSTRAP;
      }
   }
}
