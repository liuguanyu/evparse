package com.letv.player.components.configcoms
{
   import com.alex.controls.VDragBar;
   import com.greensock.TweenLite;
   import flash.events.MouseEvent;
   import flash.events.Event;
   import com.letv.player.facade.MyResource;
   import flash.system.ApplicationDomain;
   import com.letv.player.facade.MyFacade;
   import flash.display.MovieClip;
   
   public class ConfigVDragbar extends VDragBar
   {
      
      public function ConfigVDragbar(param1:Object, param2:Boolean = false)
      {
         super(param1 as MovieClip,param2);
      }
      
      override public function set percent(param1:Number) : void
      {
         var _loc2_:* = NaN;
         super.percent = param1;
         if(skin.masker != null)
         {
            _loc2_ = height * (1 - percent);
            TweenLite.to(skin.masker,0.2,{
               "height":_loc2_,
               "y":height - _loc2_
            });
         }
         if(s.label != null)
         {
            s.label.text = int((1 - percent) * 100) + "%";
         }
      }
      
      override protected function onTrackMove(param1:MouseEvent) : void
      {
         var _loc2_:* = NaN;
         super.onTrackMove(param1);
         if(skin.masker != null)
         {
            _loc2_ = height * (1 - percent);
            skin.masker.height = _loc2_;
            skin.masker.y = height - _loc2_;
         }
      }
      
      override protected function onTrackDown(param1:MouseEvent) : void
      {
         var _loc2_:* = NaN;
         super.onTrackDown(param1);
         if(skin.masker != null)
         {
            _loc2_ = height * (1 - percent);
            skin.masker.height = _loc2_;
            skin.masker.y = height - _loc2_;
         }
      }
      
      override protected function onTrackUp(param1:MouseEvent = null) : void
      {
         var _loc2_:* = NaN;
         super.onTrackUp(param1);
         if(skin.masker != null)
         {
            _loc2_ = height * (1 - percent);
            skin.masker.height = _loc2_;
            skin.masker.y = height - _loc2_;
         }
      }
      
      override protected function renderer() : void
      {
         super.renderer();
         if(s.label != null)
         {
            s.label.text = int((1 - percent) * 100) + "%";
         }
      }
      
      override protected function sendChange() : void
      {
         if(s.label != null)
         {
            s.label.text = int((1 - percent) * 100) + "%";
         }
         dispatchEvent(new Event(Event.CHANGE));
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
