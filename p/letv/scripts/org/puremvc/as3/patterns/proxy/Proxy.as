package org.puremvc.as3.patterns.proxy
{
   import org.puremvc.as3.patterns.observer.Notifier;
   import org.puremvc.as3.interfaces.IProxy;
   import org.puremvc.as3.interfaces.INotifier;
   
   public class Proxy extends Notifier implements IProxy, INotifier
   {
      
      public static var hadRenderPlugins:Boolean;
      
      public static var NAME:String = "Proxy";
      
      protected var proxyName:String;
      
      protected var data:Object;
      
      public function Proxy(param1:String = null, param2:Object = null)
      {
         super();
         this.proxyName = param1 != null?param1:NAME;
         if(param2 != null)
         {
            this.setData(param2);
         }
      }
      
      public function getProxyName() : String
      {
         return this.proxyName;
      }
      
      public function setData(param1:Object) : void
      {
         this.data = param1;
      }
      
      public function getData() : Object
      {
         return this.data;
      }
      
      public function onRegister() : void
      {
      }
      
      public function onRemove() : void
      {
      }
   }
}
