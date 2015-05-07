package com.letv.player.components.loading
{
   import com.letv.player.components.BaseConfigComponent;
   import flash.display.DisplayObject;
   import flash.geom.Rectangle;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.net.sendToURL;
   import flash.net.URLRequest;
   import com.letv.player.components.MainLoading;
   import flash.text.TextFormat;
   import com.alex.utils.BrowserUtil;
   import flash.utils.clearInterval;
   import flash.utils.setInterval;
   
   public class LoadingUI extends BaseConfigComponent
   {
      
      private var mainLoading:DisplayObject;
      
      private var mainRect:Rectangle;
      
      private var mainInfo:Object;
      
      private var bufferLoading:MovieClip;
      
      private var inter:int;
      
      private var mainBG:LoadingBG;
      
      private var speed:int = 0;
      
      public function LoadingUI()
      {
         super();
      }
      
      public function resize() : void
      {
         var _loc3_:* = NaN;
         var _loc4_:* = 0;
         var _loc5_:* = 0;
         var _loc6_:* = NaN;
         var _loc7_:* = NaN;
         if(stage == null)
         {
            return;
         }
         var _loc1_:int = applicationWidth;
         var _loc2_:int = applicationHeight;
         if(!(this.mainLoading == null) && !(this.mainLoading.stage == null))
         {
            this.graphics.clear();
            this.graphics.beginFill(0);
            this.graphics.drawRect(0,0,applicationWidth,applicationHeight);
            this.graphics.endFill();
            this.mainBG.resize(applicationWidth,applicationHeight);
            _loc3_ = 1;
            _loc4_ = _loc1_ - 20;
            _loc5_ = _loc2_ - 20;
            _loc6_ = this.mainRect.width / this.mainRect.height;
            _loc7_ = _loc4_ / _loc5_;
            if(_loc4_ < this.mainRect.width || _loc5_ < this.mainRect.height)
            {
               if(_loc6_ > _loc7_)
               {
                  _loc3_ = _loc4_ / this.mainRect.width;
               }
               else
               {
                  _loc3_ = _loc5_ / this.mainRect.height;
               }
            }
            this.mainLoading.scaleX = this.mainLoading.scaleY = _loc3_;
            this.mainLoading.x = (_loc1_ - this.mainRect.width * _loc3_) * 0.5;
            this.mainLoading.y = (_loc2_ - this.mainRect.height * _loc3_) * 0.5;
         }
         _loc2_ = _loc2_ - R.controlbar.cHeight;
         if(!(this.bufferLoading == null) && !(this.bufferLoading.stage == null))
         {
            this.bufferLoading.x = _loc1_ * 0.5;
            this.bufferLoading.y = _loc2_ * 0.5;
         }
      }
      
      public function show(param1:int = 0) : void
      {
         var type:int = param1;
         if(type == 0)
         {
            this.setLoop(false);
            if(this.bufferLoading != null)
            {
               try
               {
                  this.bufferLoading.round.stop();
               }
               catch(e:Error)
               {
               }
               try
               {
                  skin.removeChild(this.bufferLoading);
               }
               catch(e:Error)
               {
               }
            }
            if(this.mainLoading != null)
            {
               if((this.mainLoading.hasOwnProperty("loadingUrl")) && (this.mainInfo) && (this.mainInfo.hasOwnProperty("clkurl")))
               {
                  this.mainLoading["loadingUrl"].buttonMode = true;
                  this.mainLoading["loadingUrl"].addEventListener(MouseEvent.CLICK,this.onClkMainLoading);
               }
               if((this.mainLoading.stage == null) && (this.mainInfo) && (this.mainInfo.hasOwnProperty("sc")))
               {
                  try
                  {
                     sendToURL(new URLRequest(this.mainInfo["sc"]));
                  }
                  catch(e:Error)
                  {
                  }
               }
               try
               {
                  skin.addChild(this.mainBG);
                  skin.addChild(this.mainLoading);
               }
               catch(e:Error)
               {
                  try
                  {
                     mainBG = new LoadingBG();
                     skin.addChild(mainBG);
                     mainLoading = new MainLoading();
                     mainRect = new Rectangle(0,0,mainLoading.width,mainLoading.height);
                     mainLoading["loading"].mouseEnabled = false;
                     mainLoading["loading"].mouseChildren = false;
                     skin.addChild(mainLoading);
                  }
                  catch(e:Error)
                  {
                  }
               }
            }
         }
         else if(type == 1)
         {
            this.graphics.clear();
            try
            {
               skin.removeChild(this.mainLoading);
            }
            catch(e:Error)
            {
            }
            try
            {
               skin.removeChild(this.mainBG);
            }
            catch(e:Error)
            {
            }
            if((this.bufferLoading) && !skin.hasOwnProperty(this.bufferLoading))
            {
               this.setLoop(true);
               try
               {
                  this.bufferLoading.round.play();
               }
               catch(e:Error)
               {
               }
               skin.addChild(this.bufferLoading);
            }
         }
         
         this.resize();
      }
      
      public function hide() : void
      {
         this.setLoop(false);
         this.graphics.clear();
         try
         {
            removeChild(this.mainLoading);
            removeChild(this.mainBG);
         }
         catch(e:Error)
         {
         }
         if((this.bufferLoading) && (this.bufferLoading.stage))
         {
            if(this.bufferLoading.txt)
            {
               this.bufferLoading.txt.text = "0%";
            }
            try
            {
               removeChild(this.bufferLoading);
            }
            catch(e:Error)
            {
            }
         }
      }
      
      public function setMainLoading(param1:Object) : void
      {
         var value:Object = param1;
         try
         {
            this.mainInfo = value["sys"];
            this.mainRect = value["rect"] as Rectangle;
            this.mainLoading = value["instance"] as DisplayObject;
            this.mainLoading["loading"].mouseEnabled = false;
            this.mainLoading["loading"].mouseChildren = false;
            this.mainBG = new LoadingBG();
            this.show();
         }
         catch(e:Error)
         {
         }
      }
      
      public function setData(param1:Object) : void
      {
         var _loc2_:TextFormat = null;
         if(param1 != null)
         {
            param1.x = param1.y = 0;
            this.bufferLoading = param1["bufferLoading"] as MovieClip;
            if(this.bufferLoading.tip != null)
            {
               _loc2_ = new TextFormat("Microsoft YaHei,微软雅黑,Arial,宋体");
               this.bufferLoading.tip.defaultTextFormat = _loc2_;
            }
         }
      }
      
      private function onClkMainLoading(param1:MouseEvent) : void
      {
         var event:MouseEvent = param1;
         if((this.mainInfo) && (this.mainInfo.hasOwnProperty("clkurl")))
         {
            BrowserUtil.openBlankWindow(this.mainInfo["clkurl"],stage);
         }
         if((this.mainInfo) && (this.mainInfo.hasOwnProperty("cc")))
         {
            try
            {
               sendToURL(new URLRequest(this.mainInfo["cc"]));
            }
            catch(e:Error)
            {
            }
         }
      }
      
      private function setLoop(param1:Boolean) : void
      {
         clearInterval(this.inter);
         if(param1)
         {
            if((this.bufferLoading) && (this.bufferLoading.txt))
            {
               this.bufferLoading.txt.text = "0%";
               this.speed = sdk.getDownloadSpeed();
               if((this.bufferLoading.hasOwnProperty("tip")) && this.speed > 0)
               {
                  this.bufferLoading.tip.text = "正在加载，请稍候…  " + this.speed + "KB/S";
               }
               else
               {
                  this.bufferLoading.tip.text = "正在加载，请稍候… ";
               }
            }
            this.inter = setInterval(this.onLoop,10);
         }
      }
      
      private function onLoop() : void
      {
         var _loc1_:* = NaN;
         if(this.bufferLoading.txt != null)
         {
            _loc1_ = sdk.getBufferPercent() * 100;
            if(_loc1_ > 100)
            {
               this.bufferLoading.txt.text = "100%";
            }
            else
            {
               this.bufferLoading.txt.text = int(_loc1_) + "%";
               this.speed = sdk.getDownloadSpeed();
               if(this.bufferLoading.hasOwnProperty("tip"))
               {
                  this.bufferLoading.tip.text = "正在加载，请稍候…  " + this.speed + "KB/S";
               }
            }
         }
      }
   }
}
