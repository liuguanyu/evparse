package org.puremvc.as3.multicore.utilities.fabrication.logging
{
   import flash.net.LocalConnection;
   import org.puremvc.as3.multicore.utilities.fabrication.interfaces.IFabrication;
   import org.puremvc.as3.multicore.utilities.fabrication.logging.action.Action;
   import org.puremvc.as3.multicore.utilities.fabrication.logging.action.ActionType;
   import org.puremvc.as3.multicore.interfaces.IMediator;
   import flash.display.DisplayObject;
   import flash.utils.getQualifiedClassName;
   import org.puremvc.as3.multicore.interfaces.IProxy;
   import org.puremvc.as3.multicore.interfaces.INotification;
   import org.as3commons.reflect.Accessor;
   import org.as3commons.reflect.Field;
   import org.as3commons.reflect.Type;
   import flash.events.StatusEvent;
   import flash.events.SecurityErrorEvent;
   import org.as3commons.reflect.IMember;
   import flash.net.registerClassAlias;
   
   public class FabricationLogger extends Object
   {
      
      private static var INSTANCE:FabricationLogger;
      
      private static const LOGGER_ID:String = "_org.puremvc.as3.multicore.utilities.fabrication";
      
      private var _lc:LocalConnection;
      
      private var _flowActionsCounter:int = 0;
      
      public function FabricationLogger(param1:SingletonEnforcer)
      {
         super();
         if(param1 == null)
         {
            throw new Error("Private constructor invocation error");
         }
         else
         {
            registerClassAlias("org.puremvc.as3.multicore.utilities.fabrication.logging.action.Action",Action);
            this._lc = new LocalConnection();
            this._lc.addEventListener(SecurityErrorEvent.SECURITY_ERROR,this._lc_securityErrorHandler,false,0,true);
            this._lc.addEventListener(StatusEvent.STATUS,this._lc_securityStatusHandler,false,0,true);
            return;
         }
      }
      
      public static function getInstance() : FabricationLogger
      {
         return INSTANCE?INSTANCE:INSTANCE = new FabricationLogger(new SingletonEnforcer());
      }
      
      public function logFabricatorStart(param1:IFabrication, param2:String) : void
      {
         var _loc3_:Action = new Action();
         _loc3_.actorName = param2;
         _loc3_.message = " [ " + param2 + " ] " + "fabrication has started";
         _loc3_.type = ActionType.FABRICATION_START;
         var _loc4_:Object = {};
         _loc4_.fabrication = param2;
         _loc4_.id = param1.id;
         _loc4_.config = param1.config;
         _loc3_.infoObject = _loc4_;
         this.logAction(_loc3_);
      }
      
      public function logMediatorRegistration(param1:IMediator) : void
      {
         var _loc2_:Action = new Action();
         var _loc3_:String = param1.getMediatorName();
         _loc2_.actorName = _loc3_;
         _loc2_.message = "[ " + _loc2_.actorName + " ] mediator has been registered";
         _loc2_.type = ActionType.MEDIATOR_REGISTERED;
         var _loc4_:Object = {};
         _loc4_.mediatorName = _loc3_;
         var _loc5_:DisplayObject = param1.getViewComponent() as DisplayObject;
         if(_loc5_)
         {
            _loc4_.viewComponentClass = getQualifiedClassName(_loc5_);
            _loc4_.notificationInterests = param1.listNotificationInterests();
         }
         _loc2_.infoObject = _loc4_;
         this.logAction(_loc2_);
      }
      
      public function logProxyRegistration(param1:IProxy) : void
      {
         var _loc2_:Action = new Action();
         var _loc3_:String = param1.getProxyName();
         _loc2_.actorName = _loc3_;
         _loc2_.message = "[ " + _loc2_.actorName + " ] proxy has been registered";
         _loc2_.type = ActionType.PROXY_REGISTERD;
         var _loc4_:Object = {};
         _loc4_.proxyName = _loc3_;
         _loc4_.data = param1.getData();
         _loc4_ = this.retreieveProps(param1,_loc4_);
         _loc2_.infoObject = _loc4_;
         this.logAction(_loc2_);
      }
      
      public function logCommandRegistration(param1:Class, param2:String) : void
      {
         var _loc3_:Action = null;
         if(!this.isFrameworkClassFlow(param1))
         {
            _loc3_ = new Action();
            _loc3_.actorName = this.getClassName(param1);
            _loc3_.message = "[ " + _loc3_.actorName + " ] command has been registered for notification [ " + param2 + " ]";
            _loc3_.type = ActionType.COMMAND_REGISTERED;
            this.logAction(_loc3_);
         }
      }
      
      public function logInterceptorRegistration(param1:Class, param2:String, param3:Object = null) : void
      {
         var _loc4_:Action = null;
         var _loc5_:String = null;
         if(!this.isFrameworkClassFlow(param1))
         {
            _loc4_ = new Action();
            _loc5_ = this.getClassName(param1);
            _loc4_.actorName = _loc5_;
            _loc4_.message = "[ " + _loc4_.actorName + " ] interceptor has been registered";
            _loc4_.message = _loc4_.message + (" for notification [ " + param2 + " ]");
            _loc4_.type = ActionType.INTERCEPTOR_REGISTERED;
            if(param3)
            {
               _loc4_.infoObject = {
                  "interceptorClass":_loc5_,
                  "parameters":param3
               };
            }
            this.logAction(_loc4_);
         }
      }
      
      public function logRouteNotificationAction(param1:Object, param2:INotification, param3:Object) : void
      {
         var _loc12_:IProxy = null;
         var _loc13_:IMediator = null;
         var _loc4_:* = param1 is IProxy;
         var _loc5_:* = param1 is IMediator;
         var _loc6_:String = _loc4_?(param1 as IProxy).getProxyName():_loc5_?(param1 as IMediator).getMediatorName():"command";
         var _loc7_:Action = new Action();
         var _loc8_:String = param2.getName() + " routed by " + _loc6_;
         _loc7_.actorName = _loc8_;
         _loc7_.message = (_loc4_?" proxy":" mediator") + " [ ";
         _loc7_.message = _loc7_.message + (_loc6_ + " ]");
         _loc7_.message = _loc7_.message + (" route notification [ " + _loc8_ + " ]");
         if(param3)
         {
            _loc7_.message = _loc7_.message + (" to [ " + param3 + " ]");
         }
         _loc7_.type = ActionType.NOTIFICATION_ROUTE;
         var _loc9_:Object = {};
         _loc9_.name = _loc8_;
         _loc9_.body = param2.getBody();
         _loc9_.type = param2.getType();
         _loc9_ = this.retreieveProps(_loc9_,_loc9_);
         var _loc10_:Object = {};
         var _loc11_:Object = {};
         if(_loc4_)
         {
            _loc12_ = param1 as IProxy;
            _loc11_.proxyName = _loc12_.getProxyName();
            _loc11_.data = _loc12_.getData();
            _loc11_ = this.retreieveProps(_loc12_,_loc11_);
            _loc10_.proxy = _loc11_;
         }
         else if(_loc5_)
         {
            _loc13_ = param1 as IMediator;
            _loc11_.mediatorName = _loc13_.getMediatorName();
            _loc11_.viewComponent = _loc13_.getViewComponent();
            _loc10_.mediator = _loc11_;
         }
         
         _loc10_.notification = _loc9_;
         _loc7_.infoObject = _loc10_;
         this.logAction(_loc7_);
      }
      
      public function logSendNotificationAction(param1:Object, param2:INotification) : void
      {
         var _loc11_:IProxy = null;
         var _loc12_:IMediator = null;
         var _loc3_:* = param1 is IProxy;
         var _loc4_:* = param1 is IMediator;
         var _loc5_:String = _loc3_?(param1 as IProxy).getProxyName():_loc4_?(param1 as IMediator).getMediatorName():"command";
         var _loc6_:Action = new Action();
         var _loc7_:String = param2.getName();
         _loc6_.actorName = _loc7_ + " sent by " + _loc5_;
         _loc6_.message = (_loc3_?" proxy":" mediator") + " [ ";
         _loc6_.message = _loc6_.message + (_loc5_ + " ]");
         _loc6_.message = _loc6_.message + (" sent notification [ " + _loc7_ + " ]");
         _loc6_.type = ActionType.NOTIFICATION_SENT;
         var _loc8_:Object = {};
         _loc8_.name = _loc7_;
         _loc8_.body = param2.getBody();
         _loc8_.type = param2.getType();
         _loc8_ = this.retreieveProps(_loc8_,_loc8_);
         var _loc9_:Object = {};
         var _loc10_:Object = {};
         if(_loc3_)
         {
            _loc11_ = param1 as IProxy;
            _loc10_.proxyName = _loc11_.getProxyName();
            _loc10_.data = _loc11_.getData();
            _loc10_ = this.retreieveProps(_loc11_,_loc10_);
            _loc9_.proxy = _loc10_;
         }
         else if(_loc4_)
         {
            _loc12_ = param1 as IMediator;
            _loc10_.mediatorName = _loc12_.getMediatorName();
            _loc10_.viewComponent = _loc12_.getViewComponent();
            _loc9_.mediator = _loc10_;
         }
         
         _loc9_.notification = _loc8_;
         _loc6_.infoObject = _loc9_;
         this.logAction(_loc6_);
      }
      
      public function error(param1:String) : void
      {
         this.logFrameworkMessage(param1,LogLevel.ERROR.getName());
      }
      
      public function warn(param1:String) : void
      {
         this.logFrameworkMessage(param1,LogLevel.WARN.getName());
      }
      
      private function logFrameworkMessage(param1:String, param2:String) : void
      {
         this._lc.send(LOGGER_ID,"logFrameworkMessage",param1,param2);
      }
      
      private function logAction(param1:Action) : void
      {
         var action:Action = param1;
         action.index = ++this._flowActionsCounter;
         try
         {
            this._lc.send(LOGGER_ID,"logAction",action);
         }
         catch(e:Error)
         {
            _flowActionsCounter--;
         }
      }
      
      private function retreieveProps(param1:Object, param2:Object, param3:int = 0) : Object
      {
         var _loc5_:Object = null;
         var _loc6_:Object = null;
         var _loc8_:Accessor = null;
         var _loc11_:Field = null;
         var _loc4_:Type = Type.forInstance(param1);
         var _loc7_:Array = _loc4_.accessors;
         var _loc9_:* = 0;
         while(_loc9_ < _loc7_.length)
         {
            _loc8_ = Accessor(_loc7_[_loc9_]);
            if(!(_loc8_.name == "prototype" || (_loc8_.isStatic) || (_loc8_.isWriteable())))
            {
               _loc5_ = {};
               _loc6_ = param1[_loc8_.name];
               if(param3 < 2 && !(_loc6_ == null) && !this.isSimple(_loc6_))
               {
                  _loc5_ = this.retreieveProps(_loc6_,_loc5_,param3 + 1);
                  param2[_loc8_.name] = _loc5_;
               }
               else
               {
                  param2[_loc8_.name] = _loc6_;
               }
            }
            _loc9_++;
         }
         var _loc10_:Array = _loc4_.fields.filter(this.filterArrayForProxyProps);
         _loc9_ = 0;
         while(_loc9_ < _loc10_.length)
         {
            _loc11_ = Field(_loc10_[_loc9_]);
            if(!_loc11_.isStatic)
            {
               _loc5_ = {};
               _loc6_ = param1[_loc11_.name];
               if(param3 < 2 && !(_loc6_ == null) && !this.isSimple(_loc6_))
               {
                  _loc5_ = this.retreieveProps(_loc6_,_loc5_,param3 + 1);
                  param2[_loc11_.name] = _loc5_;
               }
               else
               {
                  param2[_loc11_.name] = _loc6_;
               }
            }
            _loc9_++;
         }
         return param2;
      }
      
      private function getClassName(param1:Class) : String
      {
         return getQualifiedClassName(param1).replace(new RegExp("^[\\w\\.]*::"),"");
      }
      
      private function isFrameworkClassFlow(param1:Class) : Boolean
      {
         return !(getQualifiedClassName(param1).indexOf("org.puremvc.as3.multicore.utilities.fabrication") == -1);
      }
      
      private function _lc_securityStatusHandler(param1:StatusEvent) : void
      {
      }
      
      private function _lc_securityErrorHandler(param1:SecurityErrorEvent) : void
      {
         this.error(param1.toString());
      }
      
      private function filterArrayForProxyProps(param1:IMember, param2:int, param3:Array) : Boolean
      {
         var _loc4_:String = param1.name;
         return !(_loc4_ == "expansion");
      }
      
      private function isSimple(param1:Object) : Boolean
      {
         var _loc2_:* = typeof param1;
         switch(_loc2_)
         {
            case "number":
            case "string":
            case "boolean":
               return true;
            case "object":
               return param1 is Date || param1 is Array;
            default:
               return false;
         }
      }
   }
}

class SingletonEnforcer extends Object
{
   
   function SingletonEnforcer()
   {
      super();
   }
}
