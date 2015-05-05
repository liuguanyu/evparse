package org.puremvc.as3.multicore.utilities.fabrication.patterns.proxy
{
   import org.puremvc.as3.multicore.patterns.proxy.Proxy;
   import org.puremvc.as3.multicore.utilities.fabrication.interfaces.IDisposable;
   import org.puremvc.as3.multicore.utilities.fabrication.utils.HashMap;
   import org.puremvc.as3.multicore.utilities.fabrication.interfaces.IFabrication;
   import flash.utils.getQualifiedClassName;
   import flash.utils.describeType;
   import org.puremvc.as3.multicore.patterns.observer.Notification;
   import org.puremvc.as3.multicore.interfaces.INotification;
   import org.puremvc.as3.multicore.utilities.fabrication.patterns.facade.FabricationFacade;
   import org.puremvc.as3.multicore.utilities.fabrication.injection.ProxyInjector;
   
   public class FabricationProxy extends Proxy implements IDisposable
   {
      
      public static const NAME:String = "FabricationProxy";
      
      public static const NOTIFICATION_FROM_PROXY:String = "notificationFromProxy";
      
      public static var proxyNameCacheKey:String = "proxyNameCache";
      
      public static const classRegExp:RegExp = new RegExp(".*::(.*)$","");
      
      public var expansion:Boolean = true;
      
      protected var proxyNameCache:HashMap;
      
      protected var injectionFieldsNames:Array;
      
      public function FabricationProxy(param1:String = null, param2:Object = null)
      {
         super(param1,param2);
      }
      
      override public function onRegister() : void
      {
         super.onRegister();
         this.performInjections();
      }
      
      public function dispose() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:* = 0;
         var _loc3_:String = null;
         data = null;
         this.proxyNameCache = null;
         if(this.injectionFieldsNames)
         {
            _loc1_ = this.injectionFieldsNames.length;
            _loc2_ = 0;
            while(_loc2_ < _loc1_)
            {
               _loc3_ = "" + this.injectionFieldsNames[_loc2_];
               this[_loc3_] = null;
               _loc2_++;
            }
            this.injectionFieldsNames = null;
         }
      }
      
      public function getNotificationName(param1:String) : String
      {
         if(!this.expansion)
         {
            return param1;
         }
         var _loc2_:String = getProxyName();
         if(_loc2_ == this.getDefaultProxyName() || _loc2_ == Proxy.NAME)
         {
            return param1;
         }
         return _loc2_ + "/" + param1;
      }
      
      public function getDefaultProxyName() : String
      {
         var classname:String = null;
         var clazzInfo:XML = null;
         var proxyName:String = null;
         if(this.hasCachedDefaultProxyName())
         {
            return this.getCachedDefaultProxyName();
         }
         var qpath:String = getQualifiedClassName(this);
         var classpath:String = qpath;
         var matchResult:Object = classRegExp.exec(classpath);
         if(matchResult != null)
         {
            classname = matchResult[1];
         }
         else
         {
            classname = classpath;
         }
         classpath.replace("::",".");
         var fabrication:IFabrication = this.fabFacade.getFabrication();
         var clazz:Class = fabrication.getClassByName(classpath);
         clazzInfo = describeType(clazz);
         var constants:XMLList = clazzInfo..constant.(@name == "NAME");
         if(constants.length() == 1)
         {
            proxyName = clazz["NAME"];
         }
         else
         {
            proxyName = classname;
         }
         this.proxyNameCache.put(qpath,proxyName);
         constants = null;
         clazzInfo = null;
         clazz = null;
         matchResult = null;
         return proxyName;
      }
      
      override public function sendNotification(param1:String, param2:Object = null, param3:String = null) : void
      {
         var param1:String = this.getNotificationName(param1);
         var _loc4_:INotification = new Notification(param1,param2,param3);
         super.sendNotification(param1,param2,param3);
         super.sendNotification(NOTIFICATION_FROM_PROXY,_loc4_,getProxyName());
      }
      
      public function routeNotification(param1:Object, param2:Object = null, param3:String = null, param4:Object = null) : void
      {
         if(this.fabFacade != null)
         {
            this.fabFacade.routeNotification(param1,param2,param3,param4);
         }
      }
      
      public function notifyObservers(param1:INotification) : void
      {
         if(this.fabFacade != null)
         {
            this.fabFacade.notifyObservers(param1);
            super.sendNotification(NOTIFICATION_FROM_PROXY,param1,getProxyName());
         }
      }
      
      override public function initializeNotifier(param1:String) : void
      {
         super.initializeNotifier(param1);
         this.initializeProxyNameCache();
      }
      
      protected function initializeProxyNameCache() : void
      {
         if(!this.fabFacade.hasInstance(proxyNameCacheKey))
         {
            this.proxyNameCache = this.fabFacade.saveInstance(proxyNameCacheKey,new HashMap()) as HashMap;
         }
         else
         {
            this.proxyNameCache = this.fabFacade.findInstance(proxyNameCacheKey) as HashMap;
         }
      }
      
      protected function get fabFacade() : FabricationFacade
      {
         return facade as FabricationFacade;
      }
      
      protected function hasCachedDefaultProxyName() : Boolean
      {
         return !(this.getCachedDefaultProxyName() == null);
      }
      
      protected function getCachedDefaultProxyName() : String
      {
         return this.proxyNameCache.find(getQualifiedClassName(this)) as String;
      }
      
      protected function performInjections() : void
      {
         this.injectionFieldsNames = [];
         this.injectionFieldsNames = this.injectionFieldsNames.concat(new ProxyInjector(this.fabFacade,this).inject());
      }
   }
}
