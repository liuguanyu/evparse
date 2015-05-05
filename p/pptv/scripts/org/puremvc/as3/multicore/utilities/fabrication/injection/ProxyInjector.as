package org.puremvc.as3.multicore.utilities.fabrication.injection
{
   import org.puremvc.as3.multicore.interfaces.IProxy;
   import org.puremvc.as3.multicore.interfaces.IFacade;
   
   public class ProxyInjector extends Injector
   {
      
      public function ProxyInjector(param1:IFacade, param2:*)
      {
         super(param1,param2,INJECT_PROXY);
      }
      
      override protected function elementExist(param1:String) : Boolean
      {
         return !(null == param1);
      }
      
      override protected function getPatternElementForInjection(param1:String, param2:Class) : Object
      {
         var _loc3_:IProxy = facade.retrieveProxy(param1) as IProxy;
         if((_loc3_) && _loc3_ is param2)
         {
            return _loc3_;
         }
         return null;
      }
   }
}
