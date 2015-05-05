package org.puremvc.as3.multicore.utilities.fabrication.patterns.command.routing
{
   import org.puremvc.as3.multicore.utilities.fabrication.patterns.command.SimpleFabricationCommand;
   import org.puremvc.as3.multicore.interfaces.INotification;
   import org.puremvc.as3.multicore.utilities.fabrication.interfaces.IModuleAddress;
   import org.puremvc.as3.multicore.utilities.fabrication.interfaces.IRouter;
   import org.puremvc.as3.multicore.utilities.fabrication.patterns.observer.TransportNotification;
   import org.puremvc.as3.multicore.utilities.fabrication.routing.RouterMessage;
   import org.puremvc.as3.multicore.utilities.pipes.messages.Message;
   import org.puremvc.as3.multicore.utilities.fabrication.interfaces.IRouterMessage;
   import org.puremvc.as3.multicore.utilities.fabrication.vo.ModuleAddress;
   import org.puremvc.as3.multicore.utilities.fabrication.plumbing.DynamicJunction;
   
   public class RouteNotificationCommand extends SimpleFabricationCommand
   {
      
      public static const allInstanceRegExp:RegExp = new RegExp(".*/\\*","");
      
      public static const unqualifiedGroupRegExp:RegExp = new RegExp("^.*/#$","");
      
      public function RouteNotificationCommand()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         var _loc2_:IModuleAddress = fabrication.moduleAddress;
         var _loc3_:IRouter = fabrication.router;
         var _loc4_:TransportNotification = param1.getBody() as TransportNotification;
         var _loc5_:Object = _loc4_.getTo();
         var _loc6_:String = _loc5_ as String;
         var _loc7_:IRouterMessage = new RouterMessage(Message.NORMAL);
         if(_loc5_ == null)
         {
            _loc5_ = fabrication.defaultRoute;
            if(_loc5_ == null)
            {
               _loc5_ = "*";
            }
         }
         else if(_loc5_ is String && !(_loc6_ == "*") && !allInstanceRegExp.test(_loc6_) && !ModuleAddress.inputSuffixRegExp.test(_loc6_) && !DynamicJunction.MODULE_GROUP_REGEXP.test(_loc6_))
         {
            if((unqualifiedGroupRegExp.test(_loc6_)) && !(fabrication.moduleGroup == null))
            {
               _loc5_ = _loc6_ + fabrication.moduleGroup;
            }
            else
            {
               _loc5_ = _loc6_ + ModuleAddress.INPUT_SUFFIX;
            }
         }
         else if(_loc5_ is IModuleAddress)
         {
            _loc5_ = (_loc5_ as IModuleAddress).getInputName();
         }
         
         
         _loc7_.setFrom(_loc2_.getOutputName());
         _loc7_.setTo(_loc5_ as String);
         _loc7_.setNotification(_loc4_);
         _loc3_.route(_loc7_);
      }
   }
}
