package com.letv.player.components.controlBar.classes
{
   import com.letv.player.components.BaseConfigComponent;
   import flash.events.MouseEvent;
   import com.letv.pluginsAPI.kernel.Config;
   import com.letv.player.components.configcoms.ConfigVDragbar;
   import flash.events.Event;
   import com.letv.player.model.stat.LetvStatistics;
   import com.letv.player.components.controlBar.events.ControlBarEvent;
   import com.greensock.TweenLite;
   import com.alex.utils.BrowserUtil;
   import flash.utils.clearTimeout;
   import flash.utils.setTimeout;
   
   public class VolumeUI extends BaseConfigComponent
   {
      
      private var timeout:int;
      
      private var _opening:Boolean;
      
      private var drag:ConfigVDragbar;
      
      private var volumeValue:Number = 1.0;
      
      private var upVolumeValue:Number = 0.5;
      
      public function VolumeUI(param1:Object)
      {
         super(param1);
      }
      
      override public function get width() : Number
      {
         if(skin.select != null)
         {
            return skin.select.width;
         }
         return super.width;
      }
      
      public function get opening() : Boolean
      {
         return this._opening;
      }
      
      override public function set enabled(param1:Boolean) : void
      {
         _enabled = param1;
         if(param1)
         {
            skin.addEventListener(MouseEvent.ROLL_OVER,this.onMouseRollOver);
         }
         else
         {
            if(skin.panel != null)
            {
               skin.panel.visible = false;
            }
            skin.removeEventListener(MouseEvent.ROLL_OVER,this.onMouseRollOver);
         }
      }
      
      public function set initvolume(param1:Object) : void
      {
         var value:Number = NaN;
         var info:Object = param1;
         try
         {
            value = info.volume;
            if(info.hasOwnProperty("upVolume"))
            {
               this.upVolumeValue = info.upVolume;
            }
            if(this.upVolumeValue == 0)
            {
               this.upVolumeValue = 0.5;
            }
            if(!isNaN(value) && value >= 0)
            {
               this.volumeValue = value;
               this.drag.percent = (1 - this.volumeValue) / Config.VOLUME_MAX;
               this.rendererIcon(this.volumeValue);
            }
         }
         catch(e:Error)
         {
         }
      }
      
      public function set toggleVolume(param1:int) : void
      {
         var _loc2_:Number = this.volumeValue;
         if(param1 > 0)
         {
            this.volumeValue = this.volumeValue + Config.VOLUME_MAX * 0.1;
         }
         else
         {
            this.volumeValue = this.volumeValue - Config.VOLUME_MAX * 0.1;
         }
         this.volumeValue = Number(this.volumeValue.toFixed(2));
         if(_loc2_ < 1 && this.volumeValue > 1 || _loc2_ > 1 && this.volumeValue < 1)
         {
            this.volumeValue = 1;
         }
         if(this.volumeValue > Config.VOLUME_TOTAL)
         {
            this.volumeValue = Config.VOLUME_TOTAL;
         }
         if(this.volumeValue < 0)
         {
            this.volumeValue = 0;
            this.drag.percent = 1;
         }
         this.drag.percent = (Config.VOLUME_MAX - this.volumeValue) / Config.VOLUME_MAX;
         this.rendererIcon(this.volumeValue);
         this.sendVolume(this.volumeValue);
      }
      
      public function set scriptVolume(param1:Object) : void
      {
         this.volumeValue = Number(param1.toFixed(2));
         if(this.volumeValue > Config.VOLUME_TOTAL)
         {
            this.volumeValue = Config.VOLUME_TOTAL;
         }
         if(this.volumeValue < 0)
         {
            this.volumeValue = 0;
            this.drag.percent = 1;
         }
         this.drag.percent = (1 - this.volumeValue) / Config.VOLUME_MAX;
         this.rendererIcon(this.volumeValue);
      }
      
      override protected function initialize() : void
      {
         super.initialize();
         try
         {
            this.drag = new ConfigVDragbar(skin.panel.drag,true);
            if(skin.panel.txt != null)
            {
               skin.panel.txt.mouseEnabled = false;
               skin.panel.txt.mouseWheelEnabled = false;
            }
            try
            {
               this.drag.percent = (1 - this.volumeValue) / Config.VOLUME_MAX;
            }
            catch(e:Error)
            {
            }
            try
            {
               this.rendererIcon(this.volumeValue);
            }
            catch(e:Error)
            {
            }
            try
            {
               skin.tip.visible = false;
               skin.tip.mouseEnabled = false;
               skin.tip.mouseChildren = false;
            }
            catch(e:Error)
            {
            }
            this.onMouseRollOut();
            this.addListener();
         }
         catch(e:Error)
         {
         }
         addAppResize(this.onStageResize);
      }
      
      protected function onStageResize(param1:Object = null) : void
      {
         if(_enabled)
         {
            this.onMouseRollOut();
         }
      }
      
      private function addListener() : void
      {
         this.drag.addEventListener(Event.CHANGE,this.onDragBarChange);
         if(skin.icon != null)
         {
            skin.icon.addEventListener(MouseEvent.CLICK,this.onMute);
         }
         try
         {
            skin.panel.dubi.addEventListener(MouseEvent.CLICK,this.onDubi);
         }
         catch(e:Error)
         {
         }
         skin.addEventListener(MouseEvent.ROLL_OVER,this.onMouseRollOver);
      }
      
      private function onMouseRollOver(param1:MouseEvent = null) : void
      {
         if(skin.panel != null)
         {
            this.setOpen(true,!(param1 == null));
         }
         if(skin.select != null)
         {
            skin.select.visible = true;
         }
         if(skin.visualBack != null)
         {
            skin.visualBack.visible = true;
         }
         R.stat.sendDocDebug(LetvStatistics.DUBI_SHOW);
         skin.removeEventListener(MouseEvent.ROLL_OVER,this.onMouseRollOver);
         skin.addEventListener(MouseEvent.ROLL_OUT,this.onMouseRollOut);
      }
      
      private function onMouseRollOut(param1:MouseEvent = null) : void
      {
         if(skin.panel != null)
         {
            this.setOpen(false,!(param1 == null));
         }
         if(skin.select != null)
         {
            skin.select.visible = false;
         }
         if(skin.visualBack != null)
         {
            skin.visualBack.visible = false;
         }
         skin.addEventListener(MouseEvent.ROLL_OVER,this.onMouseRollOver);
         skin.removeEventListener(MouseEvent.ROLL_OUT,this.onMouseRollOut);
      }
      
      private function rendererIcon(param1:Number) : void
      {
         var frames:int = 0;
         var value:Number = param1;
         try
         {
            frames = skin.icon.totalFrames;
         }
         catch(e:Error)
         {
         }
         if(frames >= 1)
         {
            if(this.drag.percent <= 0)
            {
               skin.icon.gotoAndStop(frames * 1);
            }
            else if(this.drag.percent > 0 && this.drag.percent <= 0.5)
            {
               skin.icon.gotoAndStop(Math.ceil(frames * 0.75));
            }
            else if(this.drag.percent > 0.5 && this.drag.percent < 1)
            {
               skin.icon.gotoAndStop(Math.ceil(frames * 0.5));
            }
            else
            {
               skin.icon.gotoAndStop(1);
            }
            
            
         }
         if(skin.panel.txt != null)
         {
            skin.panel.txt.text = int(value * 100 / Config.VOLUME_MAX) + "%";
         }
      }
      
      private function onMute(param1:MouseEvent) : void
      {
         if(skin.icon.currentFrame == 1)
         {
            if(this.volumeValue == 0)
            {
               this.volumeValue = this.upVolumeValue;
            }
            this.drag.percent = (1 - this.volumeValue) / Config.VOLUME_MAX;
            this.sendVolume(this.volumeValue);
            this.rendererIcon(this.volumeValue);
         }
         else
         {
            this.drag.percent = 1;
            this.sendVolume(0);
            this.rendererIcon(0);
         }
      }
      
      private function onDragBarChange(param1:Event) : void
      {
         var _loc2_:Number = Config.VOLUME_MAX * (1 - this.drag.percent);
         this.volumeValue = Number(_loc2_.toFixed(2));
         this.rendererIcon(this.volumeValue);
         this.sendVolume(this.volumeValue);
      }
      
      private function sendVolume(param1:Number) : void
      {
         var _loc2_:ControlBarEvent = new ControlBarEvent(ControlBarEvent.SET_VOLUME);
         _loc2_.dataProvider = param1;
         dispatchEvent(_loc2_);
         this.setDelay(param1);
      }
      
      private function setOpen(param1:Boolean, param2:Boolean = true) : void
      {
         this._opening = param1;
         if(param1)
         {
            skin.panel.visible = true;
            if(param2)
            {
               skin.panel.alpha = 0;
               TweenLite.to(skin.panel,0.2,{"alpha":1});
            }
         }
         else if(param2)
         {
            TweenLite.to(skin.panel,0.2,{
               "alpha":0,
               "onComplete":this.onHideComplete
            });
         }
         else
         {
            this.onHideComplete();
         }
         
      }
      
      private function onHideComplete() : void
      {
         if(skin.panel != null)
         {
            skin.panel.visible = false;
         }
      }
      
      private function onDubi(param1:MouseEvent) : void
      {
         R.stat.sendDocDebug(LetvStatistics.DUBI_CLICK);
         BrowserUtil.openBlankWindow("http://shop.letv.com",stage);
      }
      
      private function setDelay(param1:Number = 0) : void
      {
         if(skin.tip != null)
         {
            if(this.drag.percent == 0 && this.volumeValue == Config.VOLUME_MAX)
            {
               skin.tip.visible = true;
               clearTimeout(this.timeout);
               this.timeout = setTimeout(this.onDelay,1500);
            }
         }
      }
      
      private function onDelay() : void
      {
         try
         {
            skin.tip.visible = false;
         }
         catch(e:Error)
         {
         }
      }
   }
}
