package com.letv.player.components.displayBar.classes
{
   import com.letv.player.components.BaseRightDisplayPopup;
   import flash.text.TextFieldAutoSize;
   import com.letv.player.components.displayBar.classes.videolist.VideoListPageUI;
   import com.letv.player.components.displayBar.classes.videolist.VideoListDisplayUI;
   import com.letv.player.components.displayBar.DisplayBarEvent;
   import flash.events.MouseEvent;
   
   public class VideoListUI extends BaseRightDisplayPopup
   {
      
      private var pageUI:VideoListPageUI;
      
      private var displayUI:VideoListDisplayUI;
      
      private var listDataCanLoad:Boolean = true;
      
      private var lastVid:uint = 0;
      
      public function VideoListUI(param1:Object)
      {
         super(param1);
      }
      
      override public function get width() : Number
      {
         try
         {
            return skin.back.width;
         }
         catch(e:Error)
         {
         }
         return super.width;
      }
      
      override public function resize(param1:Boolean = false) : void
      {
         var action:Boolean = param1;
         if(!(stage == null) && visible == true)
         {
            super.resize(action);
            if(skin.arrow != null)
            {
               skin.arrow.y = (applicationHeight - skin.arrow.height) / 2;
            }
            try
            {
               this.pageUI.width = this.width;
               this.pageUI.y = skin.pageBack.height;
               if(!skin.pageLabel.visible)
               {
                  this.displayUI.y = 0;
               }
               else if(!this.pageUI.visible)
               {
                  this.displayUI.y = skin.pageBack.height;
               }
               else
               {
                  this.displayUI.y = this.pageUI.y + this.pageUI.height;
               }
               
               this.displayUI.width = this.width;
               this.displayUI.height = skin.back.height - this.displayUI.y;
            }
            catch(e:Error)
            {
            }
            if(!fullscreen)
            {
               if((opening) && !R.skin.screenNormalVideoListBtnVisible)
               {
                  hide();
               }
            }
         }
         if(!(stage == null) && visible == true)
         {
            return;
         }
      }
      
      public function setPlayNewID() : void
      {
         this.listDataCanLoad = true;
      }
      
      public function setListData(param1:Object) : void
      {
         this.pageUI.setPageByIndex(param1 as Array);
      }
      
      public function setData(param1:Object) : void
      {
         if(param1 != null)
         {
            this.pageUI.setIndexData(param1.vid,param1.total);
            this.displayUI.setIndexData(param1.vid);
         }
      }
      
      override public function display(param1:Object = null) : void
      {
         if(opening)
         {
            hide(param1);
         }
         else
         {
            this.show(param1);
         }
      }
      
      override public function show(param1:Object = null) : void
      {
         super.show(param1);
         this.resize(true);
         if(this.lastVid == sdk.getVideoSetting().vid)
         {
            return;
         }
         this.pageUI.onLabelChangePage();
      }
      
      override protected function initialize() : void
      {
         super.initialize();
         try
         {
            skin.pageLabel.autoSize = TextFieldAutoSize.LEFT;
            skin.pageLabel.y = (skin.pageBack.height - skin.pageLabel.height) / 2;
         }
         catch(e:Error)
         {
         }
         this.pageUI = new VideoListPageUI(skin.pageBox);
         this.displayUI = new VideoListDisplayUI(skin.displayBox);
      }
      
      override protected function addListener() : void
      {
         super.addListener();
         this.pageUI.addEventListener(DisplayBarEvent.CHANGE_PAGE,this.onChangePage);
         this.pageUI.addEventListener(DisplayBarEvent.GET_VIDEO_LIST,this.getList);
         this.displayUI.addEventListener(DisplayBarEvent.CHANGE_PLAY,this.onChangePlay);
         if(skin.arrow != null)
         {
            skin.arrow.addEventListener(MouseEvent.CLICK,this.onHide);
         }
         if(skin.pageCombo != null)
         {
            skin.pageCombo.addEventListener(MouseEvent.CLICK,this.onSwapPageCombo);
         }
      }
      
      override protected function removeListener() : void
      {
         super.removeListener();
         this.pageUI.removeEventListener(DisplayBarEvent.CHANGE_PAGE,this.onChangePage);
         this.pageUI.removeEventListener(DisplayBarEvent.GET_VIDEO_LIST,this.getList);
         this.displayUI.removeEventListener(DisplayBarEvent.CHANGE_PLAY,this.onChangePlay);
         if(skin.arrow != null)
         {
            skin.arrow.removeEventListener(MouseEvent.CLICK,this.onHide);
         }
         if(skin.pageCombo != null)
         {
            skin.pageCombo.removeEventListener(MouseEvent.CLICK,this.onSwapPageCombo);
         }
      }
      
      private function onChangePage(param1:DisplayBarEvent) : void
      {
         this.displayUI.setListData(param1.dataProvider as Array);
      }
      
      private function onChangePlay(param1:DisplayBarEvent) : void
      {
         dispatchEvent(new DisplayBarEvent(param1.type,param1.dataProvider));
      }
      
      private function onHide(param1:MouseEvent) : void
      {
         hide();
      }
      
      private function onSwapPageCombo(param1:MouseEvent = null) : void
      {
         if(param1.currentTarget.currentFrame == 1)
         {
            this.pageUI.visible = true;
            param1.currentTarget.gotoAndStop(2);
         }
         else
         {
            this.pageUI.visible = false;
            param1.currentTarget.gotoAndStop(1);
         }
         this.resize();
      }
      
      private function getList(param1:DisplayBarEvent = null) : void
      {
         var _loc2_:uint = 0;
         if(param1 != null)
         {
            _loc2_ = param1.dataProvider as uint;
         }
         this.lastVid = sdk.getVideoSetting().vid;
         dispatchEvent(new DisplayBarEvent(DisplayBarEvent.GET_VIDEO_LIST,_loc2_));
      }
   }
}
