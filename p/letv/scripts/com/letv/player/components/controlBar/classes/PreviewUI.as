package com.letv.player.components.controlBar.classes
{
   import com.letv.player.components.BaseConfigComponent;
   import flash.events.MouseEvent;
   import com.alex.utils.TimeUtil;
   import flash.text.TextFieldAutoSize;
   
   public class PreviewUI extends BaseConfigComponent
   {
      
      public function PreviewUI(param1:Object)
      {
         super(param1);
      }
      
      override public function destroy() : void
      {
         super.destroy();
      }
      
      public function setPreviewTime(param1:Number) : void
      {
         if(skin != null)
         {
            if(skin.label != null)
            {
               skin.label.addEventListener(MouseEvent.ROLL_OVER,this.onHideLabel);
            }
            if(skin.seedata != null)
            {
               if(skin.seedata.visible)
               {
                  skin.seedata.visible = false;
               }
            }
            if(skin.blackSeedata != null)
            {
               if(skin.blackSeedata.visible)
               {
                  skin.blackSeedata.visible = false;
               }
            }
            if(skin.label != null)
            {
               if(!skin.label.visible)
               {
                  skin.label.visible = true;
               }
               skin.label.text = TimeUtil.swap(param1);
               skin.label.autoSize = TextFieldAutoSize.LEFT;
               skin.label.x = -skin.label.width / 2;
            }
         }
      }
      
      override protected function initialize() : void
      {
         super.initialize();
         mouseEnabled = false;
         if(skin.line != null)
         {
            skin.line.mouseEnabled = false;
            skin.line.mouseChildren = false;
         }
         if(skin.visualBack != null)
         {
            skin.visualBack.mouseEnabled = false;
            skin.visualBack.mouseChildren = false;
         }
      }
      
      private function onHideLabel(param1:MouseEvent) : void
      {
         visible = false;
      }
   }
}
