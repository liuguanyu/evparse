package com.letv.player.components.controlBar.classes
{
   import com.letv.player.components.BaseConfigComponent;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import com.letv.player.components.controlBar.events.ControlBarEvent;
   
   public class NextBtnUI extends BaseConfigComponent
   {
      
      private var _total:uint = 1;
      
      private var _nextEnabled:Boolean = false;
      
      public function NextBtnUI(param1:Object = null)
      {
         super(param1);
      }
      
      override public function get width() : Number
      {
         try
         {
            return (skin.back as Sprite).width;
         }
         catch(e:Error)
         {
         }
         return super.width;
      }
      
      public function get total() : uint
      {
         return this._total;
      }
      
      override public function set enabled(param1:Boolean) : void
      {
         if((param1) && ((this._nextEnabled) || R.controlbar.nextBtnStatus == "on"))
         {
            this.alpha = 1;
            this.mouseEnabled = true;
            this.mouseChildren = true;
            skin.addEventListener(MouseEvent.CLICK,this.onClickNext);
         }
         else
         {
            this.alpha = 0.3;
            this.mouseEnabled = false;
            this.mouseChildren = false;
            skin.removeEventListener(MouseEvent.CLICK,this.onClickNext);
         }
      }
      
      public function setData(param1:Object) : void
      {
         if(param1 != null)
         {
            this._total = param1.total;
            switch(param1.nextvid)
            {
               case null:
               case "":
               case "0":
               case "null":
                  this._nextEnabled = false;
                  break;
               default:
                  this._nextEnabled = true;
            }
         }
         else
         {
            this._total = 1;
         }
      }
      
      override protected function initialize() : void
      {
         super.initialize();
         this.enabled = false;
      }
      
      private function onClickNext(param1:MouseEvent) : void
      {
         dispatchEvent(new ControlBarEvent(ControlBarEvent.PLAY_NEXT));
      }
   }
}
