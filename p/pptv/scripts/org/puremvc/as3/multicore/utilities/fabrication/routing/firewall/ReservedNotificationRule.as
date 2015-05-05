package org.puremvc.as3.multicore.utilities.fabrication.routing.firewall
{
   import org.puremvc.as3.multicore.utilities.fabrication.interfaces.IFirewallRule;
   import org.puremvc.as3.multicore.utilities.fabrication.interfaces.IRouterMessage;
   import org.puremvc.as3.multicore.utilities.fabrication.patterns.observer.RouterNotification;
   import org.puremvc.as3.multicore.utilities.fabrication.patterns.observer.FabricationNotification;
   
   public class ReservedNotificationRule extends Object implements IFirewallRule
   {
      
      protected var reservedNotifications:Array;
      
      public function ReservedNotificationRule()
      {
         super();
         this.reservedNotifications = new Array();
         this.addNotification(RouterNotification.SEND_MESSAGE_VIA_ROUTER,RouterNotification.RECEIVED_MESSAGE_VIA_ROUTER,FabricationNotification.STARTUP,FabricationNotification.SHUTDOWN,FabricationNotification.BOOTSTRAP,FabricationNotification.UNDO,FabricationNotification.REDO);
      }
      
      public function dispose() : void
      {
         this.reservedNotifications.splice(0);
         this.reservedNotifications = null;
      }
      
      public function addNotification(... rest) : void
      {
         var _loc2_:int = rest.length;
         var _loc3_:* = 0;
         while(_loc3_ < _loc2_)
         {
            this.reservedNotifications.push(rest[_loc3_]);
            _loc3_++;
         }
      }
      
      public function removeNotification(... rest) : void
      {
         var _loc3_:* = 0;
         var _loc4_:String = null;
         var _loc2_:int = rest.length;
         var _loc5_:* = 0;
         while(_loc5_ < _loc2_)
         {
            _loc4_ = rest[_loc5_];
            _loc3_ = this.findNoteIndex(_loc4_);
            if(_loc3_ >= 0)
            {
               this.reservedNotifications.splice(_loc3_,1);
            }
            _loc5_++;
         }
      }
      
      public function hasNotification(param1:String) : Boolean
      {
         return this.findNoteIndex(param1) >= 0;
      }
      
      public function process(param1:String, param2:String, param3:String, param4:IRouterMessage) : Boolean
      {
         return !this.hasNotification(param1);
      }
      
      private function findNoteIndex(param1:String) : int
      {
         var _loc3_:String = null;
         var _loc2_:int = this.reservedNotifications.length;
         var _loc4_:* = 0;
         while(_loc4_ < _loc2_)
         {
            _loc3_ = this.reservedNotifications[_loc4_];
            if(_loc3_ == param1)
            {
               return _loc4_;
            }
            _loc4_++;
         }
         return -1;
      }
   }
}
