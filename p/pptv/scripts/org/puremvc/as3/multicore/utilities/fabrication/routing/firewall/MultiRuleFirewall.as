package org.puremvc.as3.multicore.utilities.fabrication.routing.firewall
{
   import flash.events.EventDispatcher;
   import org.puremvc.as3.multicore.utilities.fabrication.interfaces.IRouterFirewall;
   import org.puremvc.as3.multicore.utilities.fabrication.interfaces.IFirewallRule;
   import org.puremvc.as3.multicore.utilities.fabrication.interfaces.IRouterMessage;
   import org.puremvc.as3.multicore.interfaces.INotification;
   import org.puremvc.as3.multicore.utilities.fabrication.events.RouterFirewallEvent;
   
   public class MultiRuleFirewall extends EventDispatcher implements IRouterFirewall
   {
      
      protected var rules:Array;
      
      public function MultiRuleFirewall()
      {
         super();
         this.rules = new Array();
      }
      
      public function dispose() : void
      {
         this.rules.splice(0);
         this.rules = null;
      }
      
      public function addRule(param1:IFirewallRule) : void
      {
         this.rules.push(param1);
      }
      
      public function removeRule(param1:IFirewallRule) : void
      {
         var _loc2_:int = this.findRuleIndex(param1);
         if(_loc2_ >= 0)
         {
            this.rules.splice(_loc2_,1);
         }
      }
      
      public function hasRule(param1:IFirewallRule) : Boolean
      {
         return this.findRuleIndex(param1) >= 0;
      }
      
      public function process(param1:IRouterMessage) : IRouterMessage
      {
         var _loc3_:IFirewallRule = null;
         var _loc9_:* = false;
         var _loc2_:int = this.rules.length;
         var _loc4_:INotification = param1.getNotification();
         var _loc5_:String = _loc4_.getName();
         var _loc6_:String = param1.getFrom();
         var _loc7_:String = param1.getTo();
         var _loc8_:* = true;
         var _loc10_:* = 0;
         while(_loc10_ < _loc2_)
         {
            _loc3_ = this.rules[_loc10_] as IFirewallRule;
            _loc9_ = _loc3_.process(_loc5_,_loc6_,_loc7_,param1);
            _loc8_ = (_loc8_) && (_loc9_);
            _loc10_++;
         }
         if(_loc8_)
         {
            dispatchEvent(new RouterFirewallEvent(RouterFirewallEvent.ALLOWED_MESSAGE,param1));
            return param1;
         }
         dispatchEvent(new RouterFirewallEvent(RouterFirewallEvent.BLOCKED_MESSAGE,param1));
         return null;
      }
      
      private function findRuleIndex(param1:IFirewallRule) : int
      {
         var _loc3_:IFirewallRule = null;
         var _loc2_:int = this.rules.length;
         var _loc4_:* = 0;
         while(_loc4_ < _loc2_)
         {
            _loc3_ = this.rules[_loc4_];
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
