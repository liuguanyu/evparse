package org.puremvc.as3.multicore.utilities.fabrication.interfaces
{
   public interface IFirewallRule extends IDisposable
   {
      
      function process(param1:String, param2:String, param3:String, param4:IRouterMessage) : Boolean;
   }
}
