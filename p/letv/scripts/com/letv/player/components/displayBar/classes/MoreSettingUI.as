package com.letv.player.components.displayBar.classes
{
   import com.letv.player.components.BaseRightDisplayPopup;
   import flash.events.MouseEvent;
   import com.letv.player.model.stat.LetvStatistics;
   import com.letv.player.components.displayBar.DisplayBarEvent;
   import com.letv.pluginsAPI.popup.PopupState;
   
   public class MoreSettingUI extends BaseRightDisplayPopup
   {
      
      private const DEFAULT_Y:int = 42;
      
      private const GAP:int = 12;
      
      private var _stack:Array;
      
      public function MoreSettingUI(param1:Object = null)
      {
         super(param1);
      }
      
      override protected function initialize() : void
      {
         super.initialize();
         if(skin.hotBtn != null)
         {
            skin.hotBtn.visible = false;
         }
         this._stack = [skin.testspeedBtn,skin.colorBtn,skin.feedbackBtn,skin.fullscreenInputBtn,skin.scanBtn,skin.loopPlayBtn,skin.hotBtn];
      }
      
      override protected function addListener() : void
      {
         super.addListener();
         if(skin.testspeedBtn != null)
         {
            skin.testspeedBtn.addEventListener(MouseEvent.CLICK,this.onMore);
         }
         if(skin.colorBtn != null)
         {
            skin.colorBtn.addEventListener(MouseEvent.CLICK,this.onMore);
         }
         if(skin.feedbackBtn != null)
         {
            skin.feedbackBtn.addEventListener(MouseEvent.CLICK,this.onMore);
         }
         if(skin.fullscreenInputBtn != null)
         {
            skin.fullscreenInputBtn.addEventListener(MouseEvent.CLICK,this.onMore);
         }
         if(skin.loopPlayBtn != null)
         {
            skin.loopPlayBtn.addEventListener(MouseEvent.CLICK,this.onMore);
         }
         if(skin.scanBtn != null)
         {
            skin.scanBtn.addEventListener(MouseEvent.CLICK,this.onMore);
         }
         if(skin.hotBtn != null)
         {
            skin.hotBtn.addEventListener(MouseEvent.CLICK,this.onMore);
         }
      }
      
      override protected function removeListener() : void
      {
         super.removeListener();
         if(skin.testspeedBtn != null)
         {
            skin.testspeedBtn.removeEventListener(MouseEvent.CLICK,this.onMore);
         }
         if(skin.colorBtn != null)
         {
            skin.colorBtn.removeEventListener(MouseEvent.CLICK,this.onMore);
         }
         if(skin.feedbackBtn != null)
         {
            skin.feedbackBtn.removeEventListener(MouseEvent.CLICK,this.onMore);
         }
         if(skin.fullscreenInputBtn != null)
         {
            skin.fullscreenInputBtn.removeEventListener(MouseEvent.CLICK,this.onMore);
         }
         if(skin.loopPlayBtn != null)
         {
            skin.loopPlayBtn.removeEventListener(MouseEvent.CLICK,this.onMore);
         }
         if(skin.scanBtn != null)
         {
            skin.scanBtn.removeEventListener(MouseEvent.CLICK,this.onMore);
         }
         if(skin.hotBtn != null)
         {
            skin.hotBtn.removeEventListener(MouseEvent.CLICK,this.onMore);
         }
      }
      
      private function onMore(param1:MouseEvent) : void
      {
         switch(param1.currentTarget)
         {
            case skin.testspeedBtn:
               R.stat.sendDocDebug(LetvStatistics.STAT_CLK_TESTSPEED);
               dispatchEvent(new DisplayBarEvent(DisplayBarEvent.CHANGE_FUNCTION,PopupState.NETWORK_TESTPSEED));
               break;
            case skin.colorBtn:
               dispatchEvent(new DisplayBarEvent(DisplayBarEvent.CHANGE_FUNCTION,PopupState.COLOR));
               break;
            case skin.feedbackBtn:
               dispatchEvent(new DisplayBarEvent(DisplayBarEvent.CHANGE_FUNCTION,PopupState.FEEDBACK));
               break;
            case skin.fullscreenInputBtn:
               dispatchEvent(new DisplayBarEvent(DisplayBarEvent.CHANGE_FUNCTION,PopupState.FULLSCREEN_INPUT));
               break;
            case skin.loopPlayBtn:
               dispatchEvent(new DisplayBarEvent(DisplayBarEvent.CHANGE_FUNCTION,PopupState.LOOP_PLAY_VIDEO));
               break;
            case skin.scanBtn:
               R.stat.sendDocDebug(LetvStatistics.STAT_CLK_QRCODE);
               dispatchEvent(new DisplayBarEvent(DisplayBarEvent.CHANGE_FUNCTION,PopupState.TWOCODE));
               break;
            case skin.hotBtn:
               dispatchEvent(new DisplayBarEvent(DisplayBarEvent.CHANGE_FUNCTION,PopupState.HOT));
               break;
         }
      }
      
      private function resetBtn() : void
      {
         var _loc1_:* = 0;
         var _loc2_:* = 0;
         while(_loc2_ < this._stack.length)
         {
            if(this._stack[_loc2_].visible)
            {
               this._stack[_loc2_].y = this.DEFAULT_Y + (this.GAP + this._stack[_loc2_].height) * (_loc2_ - _loc1_);
            }
            else
            {
               _loc1_++;
            }
            _loc2_++;
         }
      }
      
      public function setGreenData(param1:Object) : void
      {
         if(skin.hotBtn != null)
         {
            skin.hotBtn.visible = !(param1 == null);
            if(skin.hotBtn.visible)
            {
               skin.hotBtn.addEventListener(MouseEvent.CLICK,this.onMore);
            }
            else
            {
               skin.hotBtn.removeEventListener(MouseEvent.CLICK,this.onMore);
            }
         }
         this.resetBtn();
      }
   }
}
