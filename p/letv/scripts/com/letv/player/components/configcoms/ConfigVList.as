package com.letv.player.components.configcoms
{
   import com.alex.controls.VList;
   import com.letv.player.facade.MyResource;
   import flash.system.ApplicationDomain;
   import com.letv.player.facade.MyFacade;
   import flash.display.MovieClip;
   
   public class ConfigVList extends VList
   {
      
      public function ConfigVList(param1:Object = null, param2:Boolean = true, param3:uint = 0)
      {
         super(param1 as MovieClip,param2,param3);
      }
      
      protected function get R() : MyResource
      {
         return getMsg(MyResource.R) as MyResource;
      }
      
      protected function get skinApplicationDomain() : ApplicationDomain
      {
         return getMsg(MyResource.SKIN_DOMAIN) as ApplicationDomain;
      }
      
      protected function sendNotification(param1:String, param2:Object = null) : void
      {
         (getMsg(MyResource.FACADE) as MyFacade).sendNotification(param1,param2);
      }
   }
}
