package com.letv.player.components.displayBar.classes
{
   import com.letv.player.components.BaseRightDisplayPopup;
   import com.letv.player.components.configcoms.ConfigVDragbar;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class ColorUI extends BaseRightDisplayPopup
   {
      
      private var brightUI:ConfigVDragbar;
      
      private var contrastUI:ConfigVDragbar;
      
      private var colorInfo:Object;
      
      private var setInfo:int;
      
      private const SET_VECTOR:Array = [{
         "bright":0,
         "contrast":0,
         "saturation":0
      },{
         "bright":50,
         "contrast":30,
         "saturation":0
      },{
         "bright":0,
         "contrast":-20,
         "saturation":0
      },{
         "bright":0,
         "contrast":0,
         "saturation":50
      }];
      
      public function ColorUI(param1:Object, param2:String = "")
      {
         super(param1,param2);
      }
      
      override public function backDefault() : void
      {
         sdk.setVideoColor(this.colorInfo[0],this.colorInfo[1]);
      }
      
      override public function show(param1:Object = null) : void
      {
         super.show();
         if(param1 != null)
         {
            this.colorInfo = param1;
            this.brightUI.percent = (50 - this.colorInfo[0]) / 100;
            this.contrastUI.percent = (50 - this.colorInfo[1]) / 100;
         }
         else
         {
            this.colorInfo = [0,0,0];
            this.brightUI.percent = 0.5;
            this.contrastUI.percent = 0.5;
         }
      }
      
      override protected function initialize() : void
      {
         super.initialize();
         this.brightUI = new ConfigVDragbar(skin["brightDragbar"],true);
         this.contrastUI = new ConfigVDragbar(skin["contrastDragbar"],true);
      }
      
      override protected function addListener() : void
      {
         super.addListener();
         this.brightUI.addEventListener(Event.CHANGE,this.onColorChange);
         this.contrastUI.addEventListener(Event.CHANGE,this.onColorChange);
         if(skin.okBtn != null)
         {
            skin.okBtn.addEventListener(MouseEvent.CLICK,this.onOk);
         }
         if(skin.closeBtn != null)
         {
            skin.closeBtn.addEventListener(MouseEvent.CLICK,this.onCancel);
         }
         if(skin.defaultBtn != null)
         {
            skin.defaultBtn.addEventListener(MouseEvent.CLICK,this.onDefault);
         }
      }
      
      override protected function removeListener() : void
      {
         super.removeListener();
         this.brightUI.removeEventListener(Event.CHANGE,this.onColorChange);
         this.contrastUI.removeEventListener(Event.CHANGE,this.onColorChange);
         if(skin.okBtn != null)
         {
            skin.okBtn.removeEventListener(MouseEvent.CLICK,this.onOk);
         }
         if(skin.closeBtn != null)
         {
            skin.closeBtn.removeEventListener(MouseEvent.CLICK,this.onCancel);
         }
         if(skin.defaultBtn != null)
         {
            skin.defaultBtn.removeEventListener(MouseEvent.CLICK,this.onDefault);
         }
      }
      
      private function onColorChange(param1:Event) : void
      {
         var _loc2_:Object = {
            "bright":(0.5 - this.brightUI.percent) * 100,
            "contrast":(0.5 - this.contrastUI.percent) * 100
         };
         sdk.setVideoColor(_loc2_.bright,_loc2_.contrast);
      }
      
      private function onOk(param1:MouseEvent) : void
      {
         hide();
         var _loc2_:Object = {
            "bright":(0.5 - this.brightUI.percent) * 100,
            "contrast":(0.5 - this.contrastUI.percent) * 100
         };
         sdk.setVideoColor(_loc2_.bright,_loc2_.contrast);
      }
      
      private function onCancel(param1:MouseEvent = null) : void
      {
         hide();
      }
      
      private function onDefault(param1:MouseEvent) : void
      {
         this.brightUI.percent = 0.5;
         this.contrastUI.percent = 0.5;
         var _loc2_:Object = {
            "bright":0,
            "contrast":0,
            "saturation":0
         };
         sdk.setVideoColor(_loc2_.bright,_loc2_.contrast);
      }
   }
}
