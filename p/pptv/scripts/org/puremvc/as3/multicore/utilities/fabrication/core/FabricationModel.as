package org.puremvc.as3.multicore.utilities.fabrication.core
{
   import org.puremvc.as3.multicore.core.Model;
   import org.puremvc.as3.multicore.utilities.fabrication.interfaces.IDisposable;
   import org.puremvc.as3.multicore.utilities.fabrication.utils.HashMap;
   import org.puremvc.as3.multicore.interfaces.IProxy;
   
   public class FabricationModel extends Model implements IDisposable
   {
      
      protected var proxyHashMap:HashMap;
      
      public function FabricationModel(param1:String)
      {
         super(param1);
         this.proxyHashMap = new HashMap();
      }
      
      public static function getInstance(param1:String) : FabricationModel
      {
         if(instanceMap[param1] == null)
         {
            instanceMap[param1] = new FabricationModel(param1);
         }
         return instanceMap[param1] as FabricationModel;
      }
      
      override public function registerProxy(param1:IProxy) : void
      {
         param1.initializeNotifier(multitonKey);
         this.proxyHashMap.put(param1.getProxyName(),param1);
         param1.onRegister();
      }
      
      override public function retrieveProxy(param1:String) : IProxy
      {
         return this.proxyHashMap.find(param1) as IProxy;
      }
      
      override public function hasProxy(param1:String) : Boolean
      {
         return this.proxyHashMap.exists(param1);
      }
      
      override public function removeProxy(param1:String) : IProxy
      {
         var _loc2_:IProxy = this.proxyHashMap.remove(param1) as IProxy;
         _loc2_.onRemove();
         return _loc2_;
      }
      
      public function dispose() : void
      {
         this.proxyHashMap.dispose();
         this.proxyHashMap = null;
         removeModel(multitonKey);
      }
   }
}
