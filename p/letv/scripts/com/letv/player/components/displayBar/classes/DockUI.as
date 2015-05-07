package com.letv.player.components.displayBar.classes
{
   import com.letv.player.components.BaseConfigComponent;
   import com.greensock.TweenLite;
   import flash.text.TextFieldAutoSize;
   import com.letv.player.components.types.UIState;
   import flash.display.MovieClip;
   import flash.text.TextFormat;
   import com.alex.controls.Label;
   import com.letv.player.components.displayBar.DisplayBarEvent;
   import flash.events.MouseEvent;
   import flash.events.Event;
   import com.letv.player.notify.BarrageNotify;
   import com.letv.player.model.stat.LetvStatistics;
   import flash.utils.clearInterval;
   import flash.utils.setInterval;
   import com.alex.utils.TimeUtil;
   
   public class DockUI extends BaseConfigComponent
   {
      
      private var timer:int;
      
      private var totalNum:uint = 0;
      
      private var _maxAlpha:Number = 1;
      
      private var _opening:Boolean;
      
      private var _stack:Array;
      
      private var _label:Label;
      
      public function DockUI(param1:Object)
      {
         super(param1);
      }
      
      override public function get height() : Number
      {
         if(skin.back != null)
         {
            return skin.back.height;
         }
         return super.height;
      }
      
      public function set maxAlpha(param1:Number) : void
      {
         this._maxAlpha = param1;
         TweenLite.to(skin.back,0.3,{"alpha":this._maxAlpha});
         TweenLite.to(skin.label,0.3,{"alpha":this._maxAlpha});
      }
      
      public function resize() : void
      {
         var GAP:uint = 0;
         var rightX:Number = NaN;
         var i:int = 0;
         var frame:int = 0;
         var curF:int = 0;
         if(stage != null)
         {
            GAP = 15;
            this.maxAlpha = this._maxAlpha;
            rightX = applicationWidth - GAP;
            if(skin.back != null)
            {
               skin.back.x = 0;
               skin.back.y = 0;
               skin.back.width = applicationWidth;
            }
            if(skin.labelTime != null)
            {
               skin.labelTime.autoSize = TextFieldAutoSize.LEFT;
               skin.labelTime.y = (skin.back.height - skin.labelTime.height) * 0.5;
            }
            if(!fullscreen)
            {
               skin.leaveBtn.visible = false;
               this._label.x = 10;
            }
            else
            {
               this.setTimeLoop(true);
               skin.leaveBtn.visible = true;
               this._label.x = skin.leaveBtn.x + skin.leaveBtn.width + 10;
            }
            if(applicationWidth < 500 || applicationHeight < 400)
            {
               this.setRightDockVisible(false);
            }
            else if(this._opening)
            {
               this.setRightDockVisible(true);
            }
            
            i = 0;
            while(i < this._stack.length)
            {
               if(this._stack[i] != null)
               {
                  if(this._stack[i].parent == null)
                  {
                     this._stack[i].visible = false;
                  }
                  else if(rightX < this._stack[i].width)
                  {
                     this._stack[i].visible = false;
                  }
                  else if(this._stack[i].name == "outscreenBtn" && !fullscreen)
                  {
                     this._stack[i].visible = false;
                  }
                  else if(this._stack[i].name == "listBtn" && (this.totalNum <= 0 || !R.skin.screenNormalVideoListBtnVisible && !fullscreen))
                  {
                     this._stack[i].visible = false;
                  }
                  else if(this._stack[i].name == "barrageBtn" && !R.skin.barrageSupport)
                  {
                     this._stack[i].visible = false;
                  }
                  else if(this._stack[i].name == "labelTime" && !fullscreen)
                  {
                     this._stack[i].visible = false;
                     this.setTimeLoop(false);
                  }
                  else
                  {
                     if((this._stack[i].hasOwnProperty("back")) && !(this._stack[i].back == null))
                     {
                        this._stack[i].x = rightX - this._stack[i].back.width;
                     }
                     else
                     {
                        this._stack[i].x = rightX - this._stack[i].width;
                     }
                     this._stack[i].visible = true;
                     rightX = this._stack[i].x - GAP;
                  }
                  
                  
                  
                  
                  
               }
               i++;
            }
            if(!R.skin.screenNormalDockVisible && !fullscreen)
            {
               visible = false;
               return;
            }
            try
            {
               this._label.width = rightX - GAP - this._label.x;
               this._label.y = (skin.back.height - this._label.height) * 0.5;
            }
            catch(e:Error)
            {
            }
            frame = (fullscreen) || (R.displaybar.dockVisible)?2:1;
            if(skin.back != null)
            {
               skin.back.visible = fullscreen || R.displaybar.dockVisible;
            }
            if(skin.label != null)
            {
               skin.label.visible = fullscreen || R.displaybar.dockVisible;
            }
            if(skin.barrageBtn != null)
            {
               curF = skin.barrageBtn.btn.currentFrame;
               skin.barrageBtn.gotoAndStop(frame);
               skin.barrageBtn.btn.gotoAndStop(curF);
            }
            if(skin.cameraBtn != null)
            {
               skin.cameraBtn.gotoAndStop(frame);
            }
            if(skin.moreBtn != null)
            {
               skin.moreBtn.gotoAndStop(frame);
            }
            if(skin.shareBtn != null)
            {
               skin.shareBtn.gotoAndStop(frame);
            }
         }
      }
      
      public function setData(param1:Object) : void
      {
         var value:Object = param1;
         try
         {
            this.totalNum = int(value.total);
            if(value.title == null)
            {
               value.title = "未知标题";
            }
            this._label.text = value.title;
         }
         catch(e:Error)
         {
         }
         this.resize();
      }
      
      public function show() : void
      {
         if(uistate == UIState.PLAY || uistate == UIState.PAUSE || uistate == UIState.REC)
         {
            if(!this._opening && !(stage == null))
            {
               if(!R.skin.screenNormalDockVisible && !fullscreen)
               {
                  return;
               }
               this._opening = true;
               visible = true;
               TweenLite.to(this,0.3,{"alpha":1});
            }
         }
      }
      
      public function hide() : void
      {
         if((this._opening) && !(stage == null))
         {
            this._opening = false;
            TweenLite.to(this,0.3,{
               "alpha":0,
               "onComplete":this.onHideComplete
            });
         }
      }
      
      protected function onHideComplete() : void
      {
         visible = false;
      }
      
      protected function setRightDockVisible(param1:Boolean) : void
      {
         var stack:Array = null;
         var i:int = 0;
         var flag:Boolean = param1;
         try
         {
            stack = [skin.outscreenBtn,skin.moreBtn,skin.listBtn,skin.cameraBtn,skin.shareBtn,skin.greenBtn,skin.barrageBtn,skin.labelTime];
            i = 0;
            while(i < stack.length)
            {
               if(stack[i] != null)
               {
                  if(flag)
                  {
                     addChild(stack[i]);
                  }
                  else
                  {
                     removeChild(stack[i]);
                  }
               }
               i++;
            }
         }
         catch(e:Error)
         {
         }
      }
      
      override protected function initialize() : void
      {
         var _loc1_:MovieClip = null;
         var _loc2_:TextFormat = null;
         super.initialize();
         this.x = 0;
         this.y = 0;
         this.visible = false;
         if(skin.label != null)
         {
            _loc1_ = new MovieClip();
            _loc2_ = new TextFormat();
            _loc2_.font = "Microsoft YaHei,微软雅黑,Arial,宋体";
            skin.label.defaultTextFormat = _loc2_;
            _loc1_.addChild(skin.label);
            _loc1_.label = skin.label;
            this._label = new Label(_loc1_);
            this._label.tooltipEnabled = true;
            addElement(this._label);
         }
         if(!R.displaybar.shareVisible && !(skin.shareBtn == null))
         {
            skin.removeChild(skin.shareBtn);
            delete skin.shareBtn;
            true;
         }
         if(!R.displaybar.cameraVisible && !(skin.cameraBtn == null))
         {
            skin.removeChild(skin.cameraBtn);
            delete skin.cameraBtn;
            true;
         }
         if(!R.displaybar.listVisible && !(skin.listBtn == null))
         {
            skin.removeChild(skin.listBtn);
            delete skin.listBtn;
            true;
         }
         if(!R.displaybar.moreVisible && !(skin.moreBtn == null))
         {
            skin.removeChild(skin.moreBtn);
            delete skin.moreBtn;
            true;
         }
         if(!R.displaybar.barrageVisible && !(skin.barrageBtn == null))
         {
            skin.removeChild(skin.barrageBtn);
            delete skin.barrageBtn;
            true;
         }
         this._stack = [skin.outscreenBtn,skin.moreBtn,skin.listBtn,skin.cameraBtn,skin.shareBtn,skin.greenBtn,skin.barrageBtn,skin.labelTime];
         this.dockheight = this.height;
         R.addEventListener(DisplayBarEvent.OPEN_BARRAGE,this.onOpenBarrage);
         R.addEventListener(DisplayBarEvent.CLOSE_BARRAGE,this.onCloseBarrage);
         if(skin.shareBtn != null)
         {
            skin.shareBtn.addEventListener(MouseEvent.CLICK,this.onShare);
         }
         if(skin.cameraBtn != null)
         {
            skin.cameraBtn.addEventListener(MouseEvent.CLICK,this.onCamera);
         }
         if(skin.listBtn != null)
         {
            skin.listBtn.addEventListener(MouseEvent.CLICK,this.onDisplayVideoList);
         }
         if(skin.leaveBtn != null)
         {
            skin.leaveBtn.addEventListener(MouseEvent.CLICK,this.onQuiteFullScreen);
         }
         if(skin.outscreenBtn != null)
         {
            skin.outscreenBtn.addEventListener(MouseEvent.CLICK,this.onQuiteFullScreen);
         }
         if(skin.moreBtn != null)
         {
            skin.moreBtn.addEventListener(MouseEvent.CLICK,this.onDisplayMore);
         }
         if(skin.greenBtn != null)
         {
            skin.greenBtn.addEventListener(MouseEvent.CLICK,this.onDisplayGreen);
         }
         if(skin.barrageBtn != null)
         {
            skin.barrageBtn.addEventListener(MouseEvent.CLICK,this.onDisplayBarrage);
         }
      }
      
      private function onOpenBarrage(param1:Event) : void
      {
         var event:Event = param1;
         try
         {
            this.barrage = true;
            skin.barrageBtn.btn.gotoAndStop(2);
            sendNotification(BarrageNotify.BARRAGE_UPDATE);
         }
         catch(e:Error)
         {
         }
      }
      
      private function onCloseBarrage(param1:Event) : void
      {
         var event:Event = param1;
         try
         {
            this.barrage = false;
            skin.barrageBtn.btn.gotoAndStop(1);
            sendNotification(BarrageNotify.BARRAGE_UPDATE);
            this.resize();
         }
         catch(e:Error)
         {
         }
      }
      
      private function onShare(param1:MouseEvent) : void
      {
         R.stat.sendDocDebug(LetvStatistics.STAT_CLK_SHARE);
         dispatchEvent(new DisplayBarEvent(DisplayBarEvent.DOCK_SHARE));
      }
      
      private function onCamera(param1:MouseEvent) : void
      {
         R.stat.sendDocDebug(LetvStatistics.STAT_CLK_LIKE);
         dispatchEvent(new DisplayBarEvent(DisplayBarEvent.DOCK_CAMERA_SHARE));
      }
      
      private function onDisplayVideoList(param1:MouseEvent) : void
      {
         dispatchEvent(new DisplayBarEvent(DisplayBarEvent.DOCK_VIDEO_LIST));
      }
      
      private function onQuiteFullScreen(param1:MouseEvent) : void
      {
         systemManager.setFullScreen(false);
      }
      
      private function onDisplayMore(param1:MouseEvent) : void
      {
         dispatchEvent(new DisplayBarEvent(DisplayBarEvent.DOCK_MORE));
      }
      
      private function onDisplayGreen(param1:MouseEvent) : void
      {
         var event:MouseEvent = param1;
         try
         {
            if(event.currentTarget.currentFrame == 1)
            {
               R.stat.sendDocDebug(LetvStatistics.STAT_CLK_HOT);
               event.currentTarget.gotoAndStop(2);
               dispatchEvent(new DisplayBarEvent(DisplayBarEvent.DOCK_GREEN,true));
            }
            else
            {
               event.currentTarget.gotoAndStop(1);
               dispatchEvent(new DisplayBarEvent(DisplayBarEvent.DOCK_GREEN,false));
            }
         }
         catch(e:Error)
         {
         }
      }
      
      private function onDisplayBarrage(param1:MouseEvent) : void
      {
         if(skin.barrageBtn.btn.currentFrame == 1)
         {
            R.stat.sendDocDebug(LetvStatistics.BARRAGE);
            this.barrage = true;
            skin.barrageBtn.btn.gotoAndStop(2);
         }
         else
         {
            this.barrage = false;
            skin.barrageBtn.btn.gotoAndStop(1);
         }
         sdk.setBarrage(this.barrage);
         sendNotification(BarrageNotify.BARRAGE_UPDATE);
         if(barrage)
         {
            sendNotification(BarrageNotify.BARRAGE_CLICK2DOWNLOAD);
         }
      }
      
      private function setTimeLoop(param1:Boolean) : void
      {
         clearInterval(this.timer);
         if((param1) && !(skin.labelTime == null))
         {
            this.onTimeLoop();
            this.timer = setInterval(this.onTimeLoop,1000);
         }
      }
      
      private function onTimeLoop() : void
      {
         var _loc1_:Array = TimeUtil.getTime();
         skin.labelTime.text = _loc1_[0] + " : " + _loc1_[1];
         skin.labelTime.autoSize = TextFieldAutoSize.LEFT;
      }
   }
}
