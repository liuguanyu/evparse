package com.letv.player.components
{
   import com.alex.containers.Canvas;
   import com.letv.pluginsAPI.interfaces.ISDK;
   import com.letv.player.facade.MyResource;
   import flash.system.ApplicationDomain;
   import com.letv.player.facade.MyFacade;
   import flash.display.MovieClip;
   
   public class BaseConfigComponent extends Canvas
   {
      
      public function BaseConfigComponent(param1:Object = null)
      {
         super(param1 as MovieClip);
      }
      
      protected function get sdk() : ISDK
      {
         return getMsg(MyResource.SDK) as ISDK;
      }
      
      protected function get R() : MyResource
      {
         return getMsg(MyResource.R) as MyResource;
      }
      
      protected function get skinApplicationDomain() : ApplicationDomain
      {
         return getMsg(MyResource.SKIN_DOMAIN) as ApplicationDomain;
      }
      
      protected function set uistate(param1:int) : void
      {
         setMsg(MyResource.UISTATE,param1);
      }
      
      protected function get uistate() : int
      {
         return int(getMsg(MyResource.UISTATE));
      }
      
      protected function set uipopup(param1:Boolean) : void
      {
         setMsg(MyResource.POPUP,param1);
      }
      
      protected function get uipopup() : Boolean
      {
         return Boolean(getMsg(MyResource.POPUP));
      }
      
      protected function set dockheight(param1:uint) : void
      {
         setMsg(MyResource.DOCK_HEIGHT,param1);
      }
      
      protected function get dockheight() : uint
      {
         return uint(getMsg(MyResource.DOCK_HEIGHT));
      }
      
      protected function set barrage(param1:Boolean) : void
      {
         setMsg(MyResource.BARRAGE,param1);
      }
      
      protected function get barrage() : Boolean
      {
         return Boolean(getMsg(MyResource.BARRAGE));
      }
      
      protected function sendNotification(param1:String, param2:Object = null) : void
      {
         (getMsg(MyResource.FACADE) as MyFacade).sendNotification(param1,param2);
      }
   }
}
