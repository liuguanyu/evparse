package com.letv.player.components.controlBar.classes
{
   import com.letv.player.components.BaseConfigComponent;
   import com.greensock.TweenLite;
   import com.letv.pluginsAPI.infoTip.InfoTipStyle;
   import com.letv.player.model.stat.LetvStatistics;
   import flash.utils.Timer;
   import flash.events.TimerEvent;
   import flash.utils.getTimer;
   import flash.text.StyleSheet;
   import flash.text.TextFieldAutoSize;
   import flash.utils.clearTimeout;
   import flash.utils.setTimeout;
   import flash.events.TextEvent;
   import flash.events.MouseEvent;
   import com.letv.player.components.controlBar.events.InfoTipEvent;
   import com.letv.player.notify.LogicNotify;
   
   public class InfoTipUI extends BaseConfigComponent
   {
      
      private var _timeout:int;
      
      private var TIME_OUT:uint = 5000;
      
      private var _priority:int = -1;
      
      private var _styleInterval:Timer;
      
      private var _styleArr:Array;
      
      private var showTime:Number = -1;
      
      private var laveTime:Number;
      
      private var hideTime:Number = -1;
      
      public function InfoTipUI(param1:Object)
      {
         super(param1);
      }
      
      override public function destroy() : void
      {
         this.setDelay(false);
         this.removeListener();
         if(skin != null)
         {
            TweenLite.killTweensOf(skin);
            if(skin.parent != null)
            {
               skin.parent.removeChild(skin);
            }
         }
         super.destroy();
         this._priority = -1;
      }
      
      public function resize(param1:Number = -1) : void
      {
         if(param1 == -1)
         {
            skin.y = skin.stage.stageHeight - 69;
         }
         else
         {
            skin.y = param1;
         }
      }
      
      public function show(param1:Object, param2:Object, param3:Object) : void
      {
         var style:String = null;
         var value:Object = param1;
         var setting:Object = param2;
         var usersetting:Object = param3;
         if(value == null)
         {
            return;
         }
         if(value.style == null)
         {
            return;
         }
         if(value.priority < this._priority)
         {
            return;
         }
         if(value.type == InfoTipStyle.TIP_VIDEO_BUFFER && (this.vipSpeed()))
         {
            return;
         }
         if(value.style is Array)
         {
            style = (value.style as Array)[0];
         }
         else
         {
            if(value.style.toString().length < 2)
            {
               return;
            }
            style = value.style;
         }
         this.resetStyleInterval(value);
         this.TIME_OUT = (value.time) || (5000);
         try
         {
            this._priority = value.priority;
            if(!(skin == null) && !(skin.label == null))
            {
               visible = true;
               skin.label.htmlText = style;
               skin.label.y = (skin.height - skin.label.height) / 2;
               skin.back.width = skin.label.width + skin.closeBtn.width + 50;
               skin.closeBtn.x = skin.back.width - skin.closeBtn.width - 10;
               if(skin.stage.stageWidth >= skin.label.x + skin.label.width)
               {
                  this.addListener();
                  this.resize(skin.stage.stageHeight - 69);
                  skin.alpha = 0;
                  TweenLite.killTweensOf(skin);
                  this.showTime = -1;
                  TweenLite.to(skin,0.4,{
                     "alpha":1,
                     "onComplete":this.onShowComplete
                  });
               }
               if((!(value.info == null)) && (value.info.hasOwnProperty("shutdown")) && value.info.showdown == true)
               {
                  this.setDelay(false);
                  this.hide();
               }
               else if((!(value.info == null)) && (value.info.hasOwnProperty("stoptip")) && value.info.stoptip == true)
               {
                  this.setDelay(false);
                  if(skin.closeBtn != null)
                  {
                     skin.closeBtn;
                  }
               }
               else
               {
                  this.setDelay(true);
               }
               
            }
         }
         catch(e:Error)
         {
            trace("--x InfoTipUI.show Error",e.message);
         }
         if(value.type == InfoTipStyle.TIP_PAUSE_VIDEO)
         {
            R.stat.sendDocDebug(LetvStatistics.STAT_PAUSE_TIP);
         }
      }
      
      private function resetStyleInterval(param1:Object = null) : void
      {
         var _loc2_:* = 0;
         if(this._styleInterval)
         {
            this._styleInterval.removeEventListener(TimerEvent.TIMER,this.styleInterHandler);
            this._styleInterval.stop();
            this._styleInterval = null;
            this._styleArr = null;
         }
         if(param1)
         {
            _loc2_ = (parseInt(param1.interval)) || 300;
            this._styleArr = param1.style as Array;
            if((this._styleArr) && this._styleArr.length > 1)
            {
               this._styleInterval = new Timer(_loc2_);
               this._styleInterval.addEventListener(TimerEvent.TIMER,this.styleInterHandler);
               this._styleInterval.start();
            }
         }
      }
      
      private function styleInterHandler(param1:TimerEvent) : void
      {
         var _loc2_:int = this._styleInterval.currentCount % this._styleArr.length;
         skin.label.htmlText = String(this._styleArr[_loc2_]);
      }
      
      public function hide(param1:Boolean = false) : void
      {
         this.resetStyleInterval();
         if(param1)
         {
            this.onHideComplete();
         }
         else if(!(skin == null) && !(skin.parent == null))
         {
            this.hideTime = getTimer();
            TweenLite.to(skin,0.4,{
               "alpha":0,
               "onComplete":this.onHideComplete
            });
         }
         
      }
      
      private function onHideComplete() : void
      {
         visible = false;
         this._priority = -1;
         this.hideTime = -1;
         this.removeListener();
      }
      
      private function onShowComplete() : void
      {
         visible = true;
      }
      
      public function setAnimation(param1:Boolean) : void
      {
         if(param1)
         {
            if(this.showTime > 0)
            {
               this.laveTime = (getTimer() - this.showTime) / 1000;
               if(this.laveTime > 0.1 && this.laveTime < this.TIME_OUT / 1000)
               {
                  TweenLite.killTweensOf(skin);
                  TweenLite.to(skin,this.laveTime,{"y":skin.stage.stageHeight - 69});
                  if(this.hideTime > 0)
                  {
                     this.laveTime = (getTimer() - this.hideTime) / 1000;
                     TweenLite.to(skin,this.laveTime,{
                        "alpha":0,
                        "onComplete":this.onHideComplete
                     });
                  }
               }
            }
            this.resize(skin.stage.stageHeight - 69);
         }
         else
         {
            this.showTime = getTimer();
         }
      }
      
      override protected function initialize() : void
      {
         var _loc1_:StyleSheet = null;
         var _loc2_:String = null;
         super.initialize();
         visible = false;
         this._priority = -1;
         if(skin.label != null)
         {
            _loc1_ = new StyleSheet();
            _loc2_ = "a{font-family:Microsoft YaHei,微软雅黑,Arial;color:#30BAFE;}a:hover{color:#00ABFF;}";
            _loc1_.parseCSS(_loc2_);
            skin.label.styleSheet = _loc1_;
            skin.label.autoSize = TextFieldAutoSize.LEFT;
         }
      }
      
      private function setDelay(param1:Boolean) : void
      {
         clearTimeout(this._timeout);
         if(param1)
         {
            this._timeout = setTimeout(this.onDelay,this.TIME_OUT);
         }
      }
      
      private function onDelay() : void
      {
         this.hide();
      }
      
      private function addListener() : void
      {
         if(skin.label != null)
         {
            skin.label.addEventListener(TextEvent.LINK,this.onTextLink);
         }
         if(skin.closeBtn != null)
         {
            skin.closeBtn.addEventListener(MouseEvent.CLICK,this.onClose);
         }
      }
      
      private function removeListener() : void
      {
         if(skin.label != null)
         {
            skin.label.removeEventListener(TextEvent.LINK,this.onTextLink);
         }
         if(skin.closeBtn != null)
         {
            skin.closeBtn.removeEventListener(MouseEvent.CLICK,this.onClose);
         }
         TweenLite.killTweensOf(skin);
      }
      
      private function onTextLink(param1:TextEvent) : void
      {
         var _loc2_:InfoTipEvent = new InfoTipEvent(InfoTipEvent.CHANGE);
         _loc2_.dataProvider = param1.text;
         dispatchEvent(_loc2_);
      }
      
      private function onClose(param1:MouseEvent) : void
      {
         this.hide();
      }
      
      private function vipSpeed() : Boolean
      {
         if(!sdk.getUserinfo().vip)
         {
            if(Math.random() < 0.5)
            {
               if(sdk.getUserinfo().uid == null)
               {
                  sendNotification(LogicNotify.TELETEXT_TIP,{"value":0});
                  return true;
               }
               sendNotification(LogicNotify.TELETEXT_TIP,{"value":1});
               return true;
            }
         }
         return false;
      }
   }
}
