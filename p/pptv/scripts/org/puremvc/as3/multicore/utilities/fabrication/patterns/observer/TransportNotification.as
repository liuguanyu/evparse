package org.puremvc.as3.multicore.utilities.fabrication.patterns.observer
{
   import org.puremvc.as3.multicore.patterns.observer.Notification;
   import org.puremvc.as3.multicore.utilities.fabrication.interfaces.IDisposable;
   import org.puremvc.as3.multicore.interfaces.INotification;
   import org.puremvc.as3.multicore.utilities.fabrication.interfaces.IModuleAddress;
   
   public class TransportNotification extends Notification implements IDisposable
   {
      
      protected var to:Object;
      
      protected var customNotification:INotification;
      
      public function TransportNotification(param1:Object, param2:Object = null, param3:String = null, param4:Object = null)
      {
         super(this.calcNoteName(param1),param2,param3);
         if(this.customNotification == null)
         {
            this.to = param4;
         }
         else if(!(this.customNotification == null) && !(param4 == null))
         {
            this.to = param4;
         }
         else if(param4 == null && (param2 is IModuleAddress || param2 is String))
         {
            this.to = param2;
            setBody(null);
         }
         
         
      }
      
      protected function calcNoteName(param1:Object) : String
      {
         if(param1 is String)
         {
            return param1 as String;
         }
         this.customNotification = param1 as INotification;
         return this.customNotification.getName();
      }
      
      public function dispose() : void
      {
         this.customNotification = null;
         setBody(null);
         setType(null);
         this.setTo(null);
      }
      
      public function getTo() : Object
      {
         return this.to;
      }
      
      public function setTo(param1:Object) : void
      {
         this.to = param1;
      }
      
      public function getCustomNotification() : INotification
      {
         return this.customNotification;
      }
   }
}
