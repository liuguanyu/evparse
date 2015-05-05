package org.puremvc.as3.multicore.utilities.fabrication.routing
{
   import org.puremvc.as3.multicore.utilities.fabrication.interfaces.IRouter;
   import org.puremvc.as3.multicore.utilities.fabrication.plumbing.DynamicJunction;
   import org.puremvc.as3.multicore.utilities.fabrication.interfaces.IRouterFirewall;
   import org.puremvc.as3.multicore.utilities.pipes.plumbing.TeeMerge;
   import org.puremvc.as3.multicore.utilities.pipes.plumbing.PipeListener;
   import org.puremvc.as3.multicore.utilities.fabrication.interfaces.IDisposable;
   import org.puremvc.as3.multicore.utilities.fabrication.interfaces.IRouterCable;
   import org.puremvc.as3.multicore.utilities.fabrication.interfaces.INamedPipeFitting;
   import org.puremvc.as3.multicore.utilities.pipes.plumbing.Junction;
   import org.puremvc.as3.multicore.utilities.fabrication.interfaces.IRouterMessage;
   
   public class Router extends Object implements IRouter
   {
      
      protected var junction:DynamicJunction;
      
      protected var firewall:IRouterFirewall;
      
      protected var teeMerge:TeeMerge;
      
      protected var teeMergeListener:PipeListener;
      
      protected var firewallLocked:Boolean = false;
      
      public function Router()
      {
         super();
         this.junction = new DynamicJunction();
         this.teeMerge = new TeeMerge();
      }
      
      public function dispose() : void
      {
         if(this.junction is IDisposable)
         {
            (this.junction as IDisposable).dispose();
         }
         this.junction = null;
         if(this.teeMerge is IDisposable)
         {
            (this.teeMerge as IDisposable).dispose();
         }
         this.teeMerge = null;
         this.firewall = null;
      }
      
      public function connect(param1:IRouterCable) : void
      {
         var _loc2_:INamedPipeFitting = param1.getInput();
         var _loc3_:INamedPipeFitting = param1.getOutput();
         this.teeMerge.connectInput(_loc3_);
         this.junction.registerPipe(_loc2_.getName(),Junction.OUTPUT,_loc2_);
         this.junction.registerPipe(_loc3_.getName(),Junction.INPUT,_loc2_);
      }
      
      public function disconnect(param1:IRouterCable) : void
      {
         var _loc2_:INamedPipeFitting = param1.getInput();
         var _loc3_:INamedPipeFitting = param1.getOutput();
         this.junction.removePipe(_loc3_.getName());
         this.junction.removePipe(_loc2_.getName());
         _loc3_.disconnect();
      }
      
      public function install(param1:IRouterFirewall) : void
      {
         if(!this.firewallLocked)
         {
            this.firewall = param1;
            return;
         }
         throw new SecurityError("Cannot install firewall on a locked router.");
      }
      
      public function lockFirewall() : void
      {
         if(this.firewall == null)
         {
            throw new SecurityError("Cannot lock firewall, A router must be installed before lockFirewall can be called.");
         }
         else
         {
            this.firewallLocked = true;
            return;
         }
      }
      
      public function route(param1:IRouterMessage) : void
      {
         var _loc2_:String = param1.getFrom();
         var _loc3_:String = param1.getTo();
         var _loc4_:IRouterMessage = param1;
         if(this.firewall != null)
         {
            _loc4_ = this.firewall.process(param1);
         }
         if(!(_loc2_ == null) && !(_loc4_ == null))
         {
            this.junction.sendMessage(_loc3_,param1);
         }
      }
   }
}
