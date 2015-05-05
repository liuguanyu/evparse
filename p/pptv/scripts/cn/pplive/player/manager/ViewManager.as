package cn.pplive.player.manager
{
   import org.puremvc.as3.multicore.utilities.fabrication.patterns.facade.FabricationFacade;
   import cn.pplive.player.dac.DACMediator;
   import cn.pplive.player.utils.hash.*;
   import cn.pplive.player.view.*;
   import cn.pplive.player.model.*;
   
   public class ViewManager extends Object
   {
      
      private static var $instance:ViewManager = null;
      
      private static var $isSingleton:Boolean = false;
      
      private static var $facade:FabricationFacade = null;
      
      public function ViewManager()
      {
         super();
         if(!$isSingleton)
         {
            throw new Error("只能用 getInstance() 来获取实例......");
         }
         else
         {
            return;
         }
      }
      
      public static function getInstance() : ViewManager
      {
         if($instance == null)
         {
            $isSingleton = true;
            $instance = new ViewManager();
            $isSingleton = false;
         }
         return $instance;
      }
      
      public static function get mediatorItem() : HashMap
      {
         var _loc1_:HashMap = new HashMap();
         _loc1_.put("barrage",{"mediatorName":BarrageMediator});
         _loc1_.put("adver",{"mediatorName":AdverMediator});
         _loc1_.put("skin",{"mediatorName":SkinMediator});
         _loc1_.put("vod",{"mediatorName":VodMediator});
         _loc1_.put("dac",{"mediatorName":DACMediator});
         _loc1_.put("smart",{"mediatorName":SmartMediator});
         return _loc1_;
      }
      
      public static function get proxyItem() : HashMap
      {
         var _loc1_:HashMap = new HashMap();
         _loc1_.put("kernel",{"proxyName":VodKernelProxy});
         _loc1_.put("adver",{"proxyName":VodAdvProxy});
         _loc1_.put("play",{"proxyName":VodPlayProxy});
         _loc1_.put("puid",{"proxyName":VodPuidProxy});
         _loc1_.put("mark",{"proxyName":VodMarkProxy});
         _loc1_.put("markadv",{"proxyName":VodWaterMarkAdvProxy});
         _loc1_.put("recom",{"proxyName":VodRecommendProxy});
         _loc1_.put("ppap",{"proxyName":VodPPAPProxy});
         _loc1_.put("presnapshot",{"proxyName":VodPreSnapshotProxy});
         _loc1_.put("barrage",{"proxyName":VodBarrageProxy});
         _loc1_.put("clouddarg",{"proxyName":VodCloudDargProxy});
         _loc1_.put("smart",{"proxyName":VodSmartProxy});
         _loc1_.put("subtitleinfo",{"proxyName":VodSubTitleInfoProxy});
         _loc1_.put("subtitlelist",{"proxyName":VodSubTitleListProxy});
         return _loc1_;
      }
      
      public function getMediator(param1:String) : *
      {
         if(Global.getInstance()["fab"].hasMediator(mediatorItem[param1]["mediatorName"].NAME))
         {
            return Global.getInstance()["fab"].retrieveMediator(mediatorItem[param1]["mediatorName"].NAME) as mediatorItem[param1]["mediatorName"];
         }
         return null;
      }
      
      public function getProxy(param1:String) : *
      {
         if(Global.getInstance()["fab"].hasProxy(proxyItem[param1]["proxyName"].NAME))
         {
            return Global.getInstance()["fab"].retrieveProxy(proxyItem[param1]["proxyName"].NAME) as proxyItem[param1]["proxyName"];
         }
         return null;
      }
   }
}
