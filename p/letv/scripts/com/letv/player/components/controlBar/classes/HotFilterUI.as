package com.letv.player.components.controlBar.classes
{
   import com.letv.player.components.BaseConfigComponent;
   import flash.geom.Rectangle;
   import com.greensock.TweenLite;
   import flash.display.LineScaleMode;
   import flash.display.CapsStyle;
   import flash.display.JointStyle;
   import flash.display.Shape;
   
   public class HotFilterUI extends BaseConfigComponent
   {
      
      private var _opening:Boolean;
      
      private var _list:Array;
      
      private var _rect:Rectangle;
      
      private var canvas:Shape;
      
      private var masker:Shape;
      
      private const MAX:uint = 1000;
      
      public function HotFilterUI(param1:Object = null)
      {
         var instance:Object = param1;
         this._rect = new Rectangle(0,0,0,0);
         this.canvas = new Shape();
         this.masker = new Shape();
         super();
         try
         {
            instance.addChild(skin);
         }
         catch(e:Error)
         {
         }
      }
      
      public function resize(param1:Rectangle) : void
      {
         this._rect = param1;
         this.masker.width = this.WID;
         this.masker.height = this.HEI;
         this.masker.x = -this.WID;
         if(!(skin == null) && !(stage == null))
         {
            if(this.opening)
            {
               this.update(false);
            }
            else
            {
               this.visible = false;
            }
         }
      }
      
      override public function set visible(param1:Boolean) : void
      {
         this._opening = param1;
         super.visible = param1;
         if(param1)
         {
            this.update(true);
         }
         else
         {
            this.canvas.graphics.clear();
            this.setTween(false);
         }
      }
      
      public function display(param1:Boolean) : void
      {
         this._opening = param1;
         if(param1)
         {
            super.visible = true;
            this.update(true);
         }
         else
         {
            this.canvas.mask = this.masker;
            TweenLite.to(this.masker,1.5,{
               "x":-this.WID,
               "onComplete":this.onHideTweenComplete
            });
         }
      }
      
      public function setData(param1:Object) : void
      {
         var data:Array = null;
         var len:int = 0;
         var percent:Number = NaN;
         var i:int = 0;
         var value:Object = param1;
         try
         {
            data = value["values"];
            len = data.length;
            percent = 0;
            this._list = [];
            i = 0;
            while(i < len)
            {
               percent = data[i] / this.MAX;
               if(percent > 1)
               {
                  this._list[i] = 1;
               }
               else
               {
                  this._list[i] = percent;
               }
               i++;
            }
            this.update(true);
         }
         catch(e:Error)
         {
         }
      }
      
      protected function get opening() : Boolean
      {
         return this._opening;
      }
      
      protected function get HEI() : Number
      {
         return this._rect.height;
      }
      
      protected function get WID() : Number
      {
         return this._rect.width;
      }
      
      protected function update(param1:Boolean = false) : void
      {
         var _loc2_:* = 0;
         var _loc3_:* = 0;
         var _loc4_:Array = null;
         var _loc5_:Array = null;
         var _loc6_:Array = null;
         var _loc7_:* = 0;
         if((this.opening) && !(this._rect == null) && !(this._list == null))
         {
            _loc2_ = this._list.length;
            _loc3_ = this.WID / _loc2_;
            this.setTween(param1);
            this.canvas.graphics.clear();
            this.canvas.graphics.lineStyle(1,3126004,0.6,true,LineScaleMode.NONE,CapsStyle.ROUND,JointStyle.ROUND,8);
            this.canvas.graphics.beginFill(8442361,0.6);
            this.canvas.graphics.moveTo(0,this.HEI);
            _loc7_ = 0;
            while(_loc7_ < _loc2_)
            {
               _loc4_ = this.getItemPoint(_loc7_,_loc3_,_loc2_);
               this.canvas.graphics.lineTo(_loc4_[0],_loc4_[1]);
               _loc7_++;
            }
            this.canvas.graphics.lineTo(this.WID,this.HEI);
            this.canvas.graphics.lineStyle(1,16777215,0);
            this.canvas.graphics.lineTo(0,this.HEI);
            this.canvas.graphics.endFill();
         }
      }
      
      private function setTween(param1:Boolean) : void
      {
         if(param1)
         {
            this.masker.visible = true;
            this.canvas.mask = this.masker;
            TweenLite.to(this.masker,1.5,{
               "x":0,
               "onComplete":this.onShowTweenComplete
            });
         }
         else
         {
            TweenLite.killTweensOf(this.masker);
            this.canvas.mask = null;
            this.masker.visible = false;
         }
      }
      
      private function onShowTweenComplete() : void
      {
         this.canvas.mask = null;
         this.masker.visible = false;
      }
      
      private function onHideTweenComplete() : void
      {
         this.canvas.mask = null;
         this.canvas.graphics.clear();
         this.masker.visible = false;
         super.visible = false;
      }
      
      protected function getItemPoint(param1:int, param2:Number, param3:int) : Array
      {
         return [int(param2 * 0.5 + param1 / param3 * this.WID),int((1 - this._list[param1]) * this.HEI)];
      }
      
      override protected function initialize() : void
      {
         super.initialize();
         this.visible = false;
         mouseEnabled = false;
         mouseChildren = false;
         this.canvas.cacheAsBitmap = true;
         addChild(this.canvas);
         addChild(this.masker);
         this.masker.graphics.beginFill(16711680);
         this.masker.graphics.drawRect(0,0,100,100);
         this.masker.graphics.endFill();
         this.masker.visible = false;
      }
   }
}
