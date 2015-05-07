package com.letv.player.components.displayBar.classes
{
   import com.letv.player.components.BaseRightDisplayPopup;
   import com.alex.controls.CheckBox2;
   import flash.events.Event;
   
   public class FullScreenInputUI extends BaseRightDisplayPopup
   {
      
      private var checkbox:CheckBox2;
      
      public function FullScreenInputUI(param1:Object = null, param2:String = "")
      {
         super(param1,param2);
      }
      
      override public function show(param1:Object = null) : void
      {
         super.show();
         if(!(param1 == null) && (param1.hasOwnProperty("fullscreenInput")))
         {
            this.checkbox.selected = param1["fullscreenInput"];
         }
      }
      
      override public function hide(param1:Object = null) : void
      {
         if((opening) && !(skin == null) && !(skin.stage == null))
         {
            super.hide();
         }
      }
      
      override protected function initialize() : void
      {
         super.initialize();
         this.checkbox = new CheckBox2(skin.checkbox);
      }
      
      override protected function addListener() : void
      {
         super.addListener();
         if(this.checkbox != null)
         {
            this.checkbox.addEventListener(Event.CHANGE,this.onCheckBoxChange);
         }
      }
      
      override protected function removeListener() : void
      {
         super.removeListener();
         if(this.checkbox != null)
         {
            this.checkbox.removeEventListener(Event.CHANGE,this.onCheckBoxChange);
         }
      }
      
      private function onCheckBoxChange(param1:Event) : void
      {
         sdk.setFullscreenInput(this.checkbox.selected);
      }
   }
}
