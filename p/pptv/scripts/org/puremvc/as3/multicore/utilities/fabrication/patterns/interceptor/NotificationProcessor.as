package org.puremvc.as3.multicore.utilities.fabrication.patterns.interceptor
{
   import flash.events.EventDispatcher;
   import org.puremvc.as3.multicore.utilities.fabrication.interfaces.IDisposable;
   import org.puremvc.as3.multicore.interfaces.INotification;
   import org.puremvc.as3.multicore.utilities.fabrication.interfaces.IInterceptor;
   import org.puremvc.as3.multicore.utilities.fabrication.events.NotificationProcessorEvent;
   
   public class NotificationProcessor extends EventDispatcher implements IDisposable
   {
      
      protected var interceptors:Array;
      
      protected var notification:INotification;
      
      protected var finished:Boolean = false;
      
      protected var skipCount:int;
      
      public function NotificationProcessor(param1:INotification)
      {
         super();
         this.notification = param1;
         this.interceptors = new Array();
         this.skipCount = 0;
      }
      
      public function dispose() : void
      {
         var _loc2_:IInterceptor = null;
         var _loc1_:int = this.interceptors.length;
         var _loc3_:* = 0;
         while(_loc3_ < _loc1_)
         {
            _loc2_ = this.interceptors[_loc3_];
            _loc2_.dispose();
            this.interceptors[_loc3_] = null;
            _loc3_++;
         }
         this.interceptors = null;
         this.notification = null;
      }
      
      public function getNotification() : INotification
      {
         return this.notification;
      }
      
      public function addInterceptor(param1:IInterceptor) : void
      {
         param1.processor = this;
         this.interceptors.push(param1);
      }
      
      public function removeInterceptor(param1:IInterceptor) : void
      {
         var _loc2_:int = this.interceptors.indexOf(param1);
         if(_loc2_ >= 0)
         {
            this.interceptors.splice(_loc2_,1);
            param1.dispose();
         }
      }
      
      public function run() : void
      {
         var _loc2_:IInterceptor = null;
         var _loc1_:int = this.interceptors.length;
         var _loc3_:* = 0;
         while(_loc3_ < _loc1_)
         {
            _loc2_ = this.interceptors[_loc3_];
            _loc2_.notification = this.notification;
            _loc2_.intercept();
            _loc3_++;
         }
      }
      
      public function proceed(param1:INotification = null) : void
      {
         if(!this.finished)
         {
            dispatchEvent(new NotificationProcessorEvent(NotificationProcessorEvent.PROCEED,param1));
            this.finish();
         }
      }
      
      public function abort() : void
      {
         if(!this.finished)
         {
            dispatchEvent(new NotificationProcessorEvent(NotificationProcessorEvent.ABORT));
            this.finish();
         }
      }
      
      public function skip() : void
      {
         if(!this.finished && ++this.skipCount == this.interceptors.length)
         {
            this.finish();
         }
      }
      
      public function finish() : void
      {
         this.finished = true;
         dispatchEvent(new NotificationProcessorEvent(NotificationProcessorEvent.FINISH));
      }
   }
}
