package org.puremvc.as3.multicore.utilities.fabrication.patterns.mediator
{
   import org.puremvc.as3.multicore.patterns.mediator.Mediator;
   import org.puremvc.as3.multicore.utilities.fabrication.interfaces.IDisposable;
   import org.puremvc.as3.multicore.utilities.fabrication.utils.HashMap;
   import org.puremvc.as3.multicore.utilities.fabrication.vo.Reaction;
   import org.puremvc.as3.multicore.utilities.fabrication.patterns.facade.FabricationFacade;
   import org.puremvc.as3.multicore.utilities.fabrication.interfaces.IFabrication;
   import org.puremvc.as3.multicore.utilities.fabrication.interfaces.IRouter;
   import org.puremvc.as3.multicore.utilities.fabrication.interfaces.IModuleAddress;
   import org.puremvc.as3.multicore.interfaces.IProxy;
   import org.puremvc.as3.multicore.interfaces.IMediator;
   import org.puremvc.as3.multicore.interfaces.INotification;
   import org.puremvc.as3.multicore.utilities.fabrication.vo.NotificationInterests;
   import flash.utils.getQualifiedClassName;
   import flash.utils.describeType;
   import org.puremvc.as3.multicore.utilities.fabrication.patterns.proxy.FabricationProxy;
   import flash.events.IEventDispatcher;
   import org.puremvc.as3.multicore.utilities.fabrication.logging.FabricationLogger;
   import org.puremvc.as3.multicore.utilities.fabrication.injection.ProxyInjector;
   import org.puremvc.as3.multicore.utilities.fabrication.injection.MediatorInjector;
   
   public class FabricationMediator extends Mediator implements IDisposable
   {
      
      public static var DEFAULT_NOTIFICATION_HANDLER_PREFIX:String = "respondTo";
      
      public static var DEFAULT_REACTION_PREFIX:String = "reactTo";
      
      public static var DEFAULT_CAPTURE_PREFIX:String = "trap";
      
      public static var proxyNameRegExp:RegExp = new RegExp(".*Proxy.*","");
      
      public static var notePartRegExp:RegExp = new RegExp("/","");
      
      public static var firstCharRegExp:RegExp = new RegExp("^(.)","");
      
      public static var notificationCacheKey:String = "notificationCache";
      
      public static var constantRegExp:RegExp = new RegExp("^[A-Z]w*","");
      
      protected var qualifiedNotifications:Object;
      
      protected var notificationHandlerPrefix:String;
      
      protected var reactionHandlerPrefix:String;
      
      protected var captureHandlerPrefix:String;
      
      protected var notificationCache:HashMap;
      
      protected var currentReactions:Array;
      
      protected var injectionFieldsNames:Array;
      
      public function FabricationMediator(param1:String = null, param2:Object = null)
      {
         this.notificationHandlerPrefix = DEFAULT_NOTIFICATION_HANDLER_PREFIX;
         this.reactionHandlerPrefix = DEFAULT_REACTION_PREFIX;
         this.captureHandlerPrefix = DEFAULT_CAPTURE_PREFIX;
         super(param1,param2);
      }
      
      public function dispose() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:String = null;
         var _loc3_:* = 0;
         var _loc4_:Reaction = null;
         var _loc5_:* = 0;
         if(this.injectionFieldsNames)
         {
            _loc1_ = this.injectionFieldsNames.length;
            _loc5_ = 0;
            while(_loc5_ < _loc1_)
            {
               _loc2_ = "" + this.injectionFieldsNames[_loc5_];
               this[_loc2_] = null;
               _loc5_++;
            }
            this.injectionFieldsNames = null;
         }
         this.qualifiedNotifications = null;
         this.notificationCache = null;
         if(this.currentReactions != null)
         {
            _loc3_ = this.currentReactions.length;
            _loc5_ = 0;
            while(_loc5_ < _loc3_)
            {
               _loc4_ = this.currentReactions[_loc5_];
               _loc4_.dispose();
               _loc5_++;
            }
            this.currentReactions = null;
         }
      }
      
      public function get fabFacade() : FabricationFacade
      {
         return facade as FabricationFacade;
      }
      
      public function get fabrication() : IFabrication
      {
         return this.fabFacade.getFabrication();
      }
      
      public function get applicationRouter() : IRouter
      {
         return this.fabrication.router;
      }
      
      public function get applicationAddress() : IModuleAddress
      {
         return this.fabrication.moduleAddress;
      }
      
      public function retrieveProxy(param1:String) : IProxy
      {
         return facade.retrieveProxy(param1);
      }
      
      public function hasProxy(param1:String) : Boolean
      {
         return facade.hasProxy(param1);
      }
      
      public function registerMediator(param1:IMediator) : IMediator
      {
         facade.registerMediator(param1);
         return param1;
      }
      
      public function retrieveMediator(param1:String) : IMediator
      {
         return facade.retrieveMediator(param1) as IMediator;
      }
      
      public function removeMediator(param1:String) : IMediator
      {
         return facade.removeMediator(param1);
      }
      
      public function hasMediator(param1:String) : Boolean
      {
         return facade.hasMediator(param1);
      }
      
      public function routeNotification(param1:Object, param2:Object = null, param3:String = null, param4:Object = null) : void
      {
         this.fabFacade.routeNotification(param1,param2,param3,param4);
      }
      
      public function notifyObservers(param1:INotification) : void
      {
         this.fabFacade.notifyObservers(param1);
      }
      
      override public function initializeNotifier(param1:String) : void
      {
         super.initializeNotifier(param1);
         this.initializeNotificationCache();
      }
      
      protected function initializeNotificationCache() : void
      {
         if(!this.fabFacade.hasInstance(notificationCacheKey))
         {
            this.notificationCache = this.fabFacade.saveInstance(notificationCacheKey,new HashMap()) as HashMap;
         }
         else
         {
            this.notificationCache = this.fabFacade.findInstance(notificationCacheKey) as HashMap;
         }
      }
      
      override public function listNotificationInterests() : Array
      {
         var qpath:String = null;
         var notificationInterests:NotificationInterests = null;
         var classpath:String = null;
         var clazzInfo:XML = null;
         var respondToMethodsCount:int = 0;
         var proxyNameRegExpMatch:Object = null;
         var methodNameReMatch:Object = null;
         var hasProxyInterests:Boolean = false;
         var methodXML:XML = null;
         var methodName:String = null;
         var noteName:String = null;
         var i:int = 0;
         var clazz:Class = null;
         qpath = getQualifiedClassName(this);
         notificationInterests = this.notificationCache.find(qpath) as NotificationInterests;
         if(notificationInterests != null)
         {
            this.qualifiedNotifications = notificationInterests.qualifications;
            return notificationInterests.interests;
         }
         var interests:Array = new Array();
         classpath = qpath.replace("::",".");
         try
         {
            clazz = this.fabrication.getClassByName(classpath);
         }
         catch(e:Error)
         {
            throw new Error("Unable to perform reflection for classpath " + classpath + ". Check if getClassByName is defined on the main fabrication class");
         }
         clazzInfo = describeType(clazz);
         var methodNameRe:RegExp = new RegExp("^" + this.notificationHandlerPrefix + "(.*)$","");
         var respondToMethods:XMLList = clazzInfo..method.((methodNameRe as RegExp).exec(@name) != null);
         respondToMethodsCount = respondToMethods.length();
         hasProxyInterests = false;
         this.qualifiedNotifications = this.qualifyNotificationInterests();
         if(this.qualifiedNotifications == null)
         {
            this.qualifiedNotifications = new Object();
         }
         i = 0;
         while(i < respondToMethodsCount)
         {
            methodXML = respondToMethods[i];
            methodName = methodXML.@name;
            proxyNameRegExpMatch = proxyNameRegExp.exec(methodName);
            if(!hasProxyInterests && !(proxyNameRegExpMatch == null))
            {
               hasProxyInterests = true;
            }
            else if(proxyNameRegExpMatch == null)
            {
               methodNameReMatch = methodNameRe.exec(methodName);
               if(methodNameReMatch != null)
               {
                  noteName = methodNameReMatch[1];
                  noteName = this.lcfirst(noteName);
                  if(this.isNotificationQualified(noteName))
                  {
                     noteName = this.getNotificationQualification(noteName) + "/" + noteName;
                  }
                  interests.push(noteName);
               }
            }
            
            i++;
         }
         if(hasProxyInterests)
         {
            interests.push(FabricationProxy.NOTIFICATION_FROM_PROXY);
         }
         respondToMethods = null;
         interests = interests.concat(this.listNotificationsInterestByNamespaces(clazzInfo));
         clazzInfo = null;
         this.notificationCache.put(qpath,new NotificationInterests(qpath,interests,this.qualifiedNotifications));
         return interests;
      }
      
      private function listNotificationsInterestByNamespaces(param1:XML) : Array
      {
         var interests:Array = null;
         var methodXML:XML = null;
         var respondToMethods:XMLList = null;
         var respondToMethodsCount:uint = 0;
         var noteName:String = null;
         var i:int = 0;
         var clazzInfo:XML = param1;
         interests = [];
         respondToMethods = clazzInfo..method.(@name == "processNotification");
         respondToMethodsCount = respondToMethods.length();
         i = 0;
         while(i < respondToMethodsCount)
         {
            methodXML = respondToMethods[i];
            noteName = methodXML.@uri;
            interests[interests.length] = noteName;
            i++;
         }
         return interests;
      }
      
      override public function handleNotification(param1:INotification) : void
      {
         var _loc3_:Array = null;
         var _loc4_:String = null;
         var _loc5_:String = null;
         var _loc6_:INotification = null;
         var _loc7_:String = null;
         var _loc8_:String = null;
         var _loc2_:String = param1.getName();
         if(_loc2_ == FabricationProxy.NOTIFICATION_FROM_PROXY)
         {
            _loc6_ = param1.getBody() as INotification;
            _loc7_ = _loc6_.getName();
            if(notePartRegExp.test(_loc6_.getName()))
            {
               _loc3_ = _loc7_.split("/");
               _loc4_ = _loc3_[0];
               _loc5_ = _loc3_[1];
               _loc4_ = this.ucfirst(_loc4_);
               this.invokeNotificationHandler(this.notificationHandlerPrefix + _loc4_,_loc6_);
            }
            else
            {
               _loc4_ = param1.getType();
               _loc4_ = this.ucfirst(_loc4_);
               this.invokeNotificationHandler(this.notificationHandlerPrefix + _loc4_,_loc6_);
            }
         }
         else if(notePartRegExp.test(_loc2_))
         {
            _loc3_ = _loc2_.split("/");
            _loc4_ = _loc3_[0];
            _loc5_ = _loc3_[1];
            _loc8_ = this.getNotificationQualification(_loc5_);
            if(!(_loc8_ == null) && _loc8_ == _loc4_)
            {
               _loc5_ = this.ucfirst(_loc5_);
               this.invokeNotificationHandler(this.notificationHandlerPrefix + _loc5_,param1);
            }
         }
         else
         {
            _loc2_ = this.ucfirst(_loc2_);
            this.invokeNotificationHandler(this.notificationHandlerPrefix + _loc2_,param1);
         }
         
      }
      
      public function qualifyNotificationInterests() : Object
      {
         return null;
      }
      
      public function isNotificationQualified(param1:String) : Boolean
      {
         return !(this.getNotificationQualification(param1) == null);
      }
      
      public function getNotificationQualification(param1:String) : String
      {
         return this.qualifiedNotifications[param1];
      }
      
      public function initializeReactions() : void
      {
         var reactionPattern:String = null;
         var reactionRegExp:RegExp = null;
         var qpath:String = null;
         var classpath:String = null;
         var clazzInfo:XML = null;
         var reactionMethods:XMLList = null;
         var reactionMethodsCount:int = 0;
         var accessorRegExp:RegExp = null;
         var accessorMethods:XMLList = null;
         var accessorMethodsCount:int = 0;
         var eventType:String = null;
         var eventSourceName:String = null;
         var eventSource:IEventDispatcher = null;
         var handlerName:String = null;
         var eventHandler:Function = null;
         var eventPhase:String = null;
         var useCapture:Boolean = false;
         var extractRegExp:RegExp = null;
         var patternList:Array = null;
         var matchResult:Object = null;
         var i:int = 0;
         var j:int = 0;
         var reactionCreated:Boolean = false;
         var fabricationLogger:FabricationLogger = null;
         var clazz:Class = null;
         reactionPattern = "(" + this.reactionHandlerPrefix + "|" + this.captureHandlerPrefix + ")";
         reactionRegExp = new RegExp("^" + reactionPattern + ".*$","");
         qpath = getQualifiedClassName(this);
         classpath = qpath.replace("::",".");
         try
         {
            clazz = this.fabrication.getClassByName(classpath);
         }
         catch(e:Error)
         {
            throw new Error("Unable to perform reflection for classpath " + classpath + ". Check if getClassByName is defined on the main fabrication class");
         }
         clazzInfo = describeType(clazz);
         reactionMethods = clazzInfo..method.((reactionRegExp as RegExp).test(@name));
         reactionMethodsCount = reactionMethods.length();
         if(reactionMethodsCount == 0)
         {
            reactionMethods = null;
            clazzInfo = null;
            return;
         }
         accessorRegExp = new RegExp("(::FabricationMediator$|::Mediator$|Class$)","");
         accessorMethods = clazzInfo..accessor.(!(accessorRegExp as RegExp).test(@declaredBy));
         accessorMethodsCount = accessorMethods.length();
         patternList = new Array();
         i = 0;
         j = 0;
         this.currentReactions = new Array();
         i = 0;
         while(i < accessorMethodsCount)
         {
            handlerName = accessorMethods[i].@name;
            extractRegExp = new RegExp("^" + reactionPattern + "(" + this.ucfirst(handlerName) + ")" + "(.*)$","");
            patternList.push(extractRegExp);
            i++;
         }
         accessorMethodsCount++;
         patternList.push(new RegExp("^(reactTo|trap)([a-zA-Z0-9]+)\\$(.*)$"));
         reactionCreated = false;
         fabricationLogger = this.fabFacade.logger as FabricationLogger;
         i = 0;
         while(i < reactionMethodsCount)
         {
            handlerName = reactionMethods[i].@name;
            reactionCreated = false;
            j = 0;
            while(j < accessorMethodsCount)
            {
               extractRegExp = patternList[j];
               matchResult = extractRegExp.exec(handlerName);
               if(matchResult != null)
               {
                  if(!matchResult[0] || !matchResult[1] || !matchResult[2])
                  {
                     fabricationLogger.error("Wrong reactTo method pattern [ " + handlerName + " ] at [ " + qpath + " ] mediator.");
                  }
                  else
                  {
                     eventPhase = matchResult[1];
                     eventSourceName = this.lcfirst(matchResult[2]);
                     eventSource = this.hasOwnProperty(eventSourceName)?this[eventSourceName]:viewComponent.hasOwnProperty(eventSourceName)?viewComponent[eventSourceName]:null;
                     eventType = matchResult[3];
                     if(eventType.indexOf("$") != 0)
                     {
                        eventType = this.formatEventType(eventType);
                        eventHandler = this[handlerName];
                        useCapture = eventPhase == this.captureHandlerPrefix;
                        if(null == eventSource)
                        {
                           fabricationLogger.error("Cannot acces eventSource for Reaction for [ " + eventSourceName + " ] at [ " + qpath + " ] mediator.");
                           break;
                        }
                        this.addReaction(eventSource,eventType,eventHandler,useCapture);
                        reactionCreated = true;
                     }
                  }
               }
               j++;
            }
            if(!reactionCreated)
            {
               fabricationLogger.warn("Cannot resolve reaction for [ " + handlerName + " ] at [ " + qpath + " ] mediator.");
            }
            i++;
         }
         accessorMethods = null;
         reactionMethods = null;
         accessorRegExp = null;
         reactionRegExp = null;
         clazzInfo = null;
      }
      
      public function addReaction(param1:IEventDispatcher, param2:String, param3:Function, param4:Boolean = false) : void
      {
         var _loc5_:Reaction = new Reaction(param1,param2,param3,param4);
         if(this.currentReactions == null)
         {
            this.currentReactions = [];
         }
         this.currentReactions.push(_loc5_);
         _loc5_.start();
      }
      
      public function haltReaction(param1:Object) : void
      {
         this.actOnReaction(param1,"stop");
      }
      
      public function resumeReaction(param1:Object) : void
      {
         this.actOnReaction(param1,"start");
      }
      
      public function removeReaction(param1:Object) : void
      {
         this.actOnReaction(param1,"dispose");
      }
      
      public function actOnReaction(param1:Object, param2:String) : void
      {
         var _loc4_:Reaction = null;
         if(param1 is String)
         {
            var param1:Object = this[param1];
         }
         var _loc3_:int = this.currentReactions.length;
         var _loc5_:* = 0;
         while(_loc5_ < _loc3_)
         {
            _loc4_ = this.currentReactions[_loc5_];
            if(_loc4_.handler == param1)
            {
               _loc4_[param2]();
               if(param2 == "dispose")
               {
                  this.currentReactions.splice(_loc5_,1);
               }
               break;
            }
            _loc5_++;
         }
      }
      
      override public function onRegister() : void
      {
         if(multitonKey != null)
         {
            this.initializeReactions();
         }
         this.performInjections();
      }
      
      protected function invokeNotificationHandler(param1:String, param2:INotification) : void
      {
         var _loc3_:Namespace = null;
         var _loc4_:QName = null;
         var _loc5_:Function = null;
         if(this.hasOwnProperty(param1))
         {
            this[param1](param2);
         }
         else
         {
            _loc3_ = new Namespace(param2.getName());
            _loc4_ = new QName(_loc3_,"processNotification");
            if((_loc4_) && (this[_loc4_]))
            {
               _loc5_ = this[_loc4_] as Function;
               if(_loc5_ != null)
               {
                  _loc5_.apply(this,[param2]);
               }
            }
         }
      }
      
      function isConstantFormat(param1:String) : Boolean
      {
         return !(null == param1.match(constantRegExp)) && param1 == param1.toUpperCase();
      }
      
      private function ucfirst(param1:String) : String
      {
         if(this.isConstantFormat(param1))
         {
            return param1;
         }
         var _loc2_:Object = param1.match(firstCharRegExp);
         return param1.replace(firstCharRegExp,_loc2_[1].toUpperCase());
      }
      
      private function lcfirst(param1:String) : String
      {
         if(this.isConstantFormat(param1))
         {
            return param1;
         }
         var _loc2_:Object = param1.match(firstCharRegExp);
         return param1.replace(firstCharRegExp,_loc2_[1].toLowerCase());
      }
      
      protected function formatEventType(param1:String) : String
      {
         var _loc2_:Object = null;
         var _loc3_:Array = null;
         var _loc4_:* = 0;
         var _loc5_:String = null;
         if(param1.indexOf("_") != -1)
         {
            _loc3_ = param1.split("_");
            _loc4_ = 0;
            while(_loc4_ < _loc3_.length)
            {
               _loc5_ = _loc3_[_loc4_];
               _loc5_ = _loc5_.toLowerCase();
               if(_loc4_ != 0)
               {
                  _loc2_ = _loc5_.match(firstCharRegExp);
                  _loc5_ = _loc5_.replace(firstCharRegExp,_loc2_[1].toUpperCase());
               }
               _loc3_[_loc4_] = _loc5_;
               _loc4_++;
            }
            return _loc3_.join("");
         }
         _loc2_ = param1.match(constantRegExp);
         if((_loc2_) && param1 == param1.toUpperCase())
         {
            return param1.toLowerCase();
         }
         _loc2_ = param1.match(firstCharRegExp);
         return param1.replace(firstCharRegExp,_loc2_[1].toLowerCase());
      }
      
      protected function performInjections() : void
      {
         this.injectionFieldsNames = [];
         this.injectionFieldsNames = this.injectionFieldsNames.concat(new ProxyInjector(this.fabFacade,this).inject());
         this.injectionFieldsNames = this.injectionFieldsNames.concat(new MediatorInjector(this.fabFacade,this).inject());
      }
   }
}
