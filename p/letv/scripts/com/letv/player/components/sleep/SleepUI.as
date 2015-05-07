package com.letv.player.components.sleep
{
   import com.letv.player.components.BaseConfigComponent;
   import com.alex.controls.Image;
   import flash.events.MouseEvent;
   import com.alex.utils.BrowserUtil;
   
   public class SleepUI extends BaseConfigComponent
   {
      
      private var _headPic:Image;
      
      private var _tailPic:Image;
      
      private var _imageInfo:Object;
      
      private var _imageLink:String;
      
      public function SleepUI(param1:Object)
      {
         this._imageInfo = param1;
         super();
      }
      
      public function resize() : void
      {
         var _loc1_:Image = null;
         if(stage != null)
         {
            if(!(this._headPic == null) && (this._headPic.visible))
            {
               _loc1_ = this._headPic;
            }
            else if(!(this._tailPic == null) && (this._tailPic.visible))
            {
               _loc1_ = this._tailPic;
            }
            
            if(_loc1_ != null)
            {
               _loc1_.width = applicationWidth;
               _loc1_.height = applicationHeight - R.controlbar.cHeight;
            }
         }
      }
      
      public function showHead() : void
      {
         if(this._tailPic != null)
         {
            this._tailPic.visible = false;
         }
         if(!(this._imageInfo.picStartUrl == null) && !(this._imageInfo.picStartUrl == ""))
         {
            if(this._headPic == null)
            {
               this._headPic = new Image();
               this._headPic.backgroundColor = 0;
               this._headPic.source = this._imageInfo.picStartUrl;
               addElement(this._headPic);
            }
            this._headPic.visible = true;
            this._imageLink = this._imageInfo.picStartTo;
            buttonMode = !(this._imageInfo.picStartTo == null) && !(this._imageInfo.picStartTo == "");
            if(buttonMode)
            {
               addEventListener(MouseEvent.CLICK,this.onClk);
            }
            else
            {
               removeEventListener(MouseEvent.CLICK,this.onClk);
            }
            this.resize();
         }
      }
      
      public function showTail() : void
      {
         if(this._headPic != null)
         {
            this._headPic.visible = false;
         }
         if(!(this._imageInfo.picEndUrl == null) && !(this._imageInfo.picEndUrl == ""))
         {
            if(this._tailPic == null)
            {
               this._tailPic = new Image();
               this._tailPic.backgroundColor = 0;
               this._tailPic.source = this._imageInfo.picEndUrl;
               addElement(this._tailPic);
            }
            this._tailPic.visible = true;
            this._imageLink = this._imageInfo.picEndTo;
            buttonMode = !(this._imageInfo.picEndTo == null) && !(this._imageInfo.picEndTo == "");
            if(buttonMode)
            {
               addEventListener(MouseEvent.CLICK,this.onClk);
            }
            else
            {
               removeEventListener(MouseEvent.CLICK,this.onClk);
            }
            this.resize();
         }
      }
      
      override protected function initialize() : void
      {
         super.initialize();
         mouseChildren = false;
      }
      
      private function onClk(param1:MouseEvent) : void
      {
         browserManager.callScript("avdTCPage");
         browserManager.callScript("clickPlayerSwapStatus");
         if(!(this._imageLink == null) && !(this._imageLink == ""))
         {
            BrowserUtil.openBlankWindow(this._imageLink,stage);
         }
      }
   }
}
