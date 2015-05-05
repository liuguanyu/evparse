package cn.pplive.player.view.ui
{
   import flash.display.Sprite;
   import flash.text.TextField;
   import flash.display.Shape;
   import flash.events.Event;
   import flash.text.TextFormat;
   
   public class Loading extends Sprite
   {
      
      private var nums:Number = 12;
      
      private var segAngle:Number;
      
      private var seg:Number;
      
      private var arr:Array;
      
      private var _circle:Sprite;
      
      private var j:Number = 1;
      
      private var initseg:Number;
      
      private var _perTxt:TextField;
      
      private var _diameter:Number;
      
      private var _tipTxt:TextField;
      
      public function Loading()
      {
         this.arr = [];
         super();
         this.seg = this.initseg = 1 / this.nums;
         this.initseg = Math.round(this.initseg * 100) / 100;
         this.segAngle = Math.PI * 2 / this.nums;
         this._circle = new Sprite();
         addChild(this._circle);
      }
      
      public function init(param1:String = null, param2:Number = 30, param3:Number = 3) : void
      {
         var _shape:Shape = null;
         var tip:String = param1;
         var diameter:Number = param2;
         var radius:Number = param3;
         this._diameter = diameter;
         this._circle.x = diameter / 2;
         this._circle.y = diameter / 2;
         var i:int = 0;
         while(i < this.nums)
         {
            _shape = new Shape();
            this._circle.addChild(_shape);
            with(_shape)
            {
               
               graphics.beginFill(16777215);
               graphics.drawCircle(0,0,radius);
               graphics.endFill();
            }
            _shape.alpha = this.seg * i;
            _shape.x = diameter / 2 * Math.cos(i * this.segAngle) + _shape.width / 2;
            _shape.y = diameter / 2 * Math.sin(i * this.segAngle) + _shape.height / 2;
            this.arr[i] = _shape;
            i++;
         }
         addEventListener(Event.ENTER_FRAME,this.onAlphaHalder);
         if(tip)
         {
            this._tipTxt = new TextField();
            addChild(this._tipTxt);
            this._tipTxt.mouseEnabled = false;
            this._tipTxt.autoSize = "left";
            this._tipTxt.defaultTextFormat = new TextFormat("宋体",14,16777215);
            this._tipTxt.text = tip;
            if(this._circle.width <= this._tipTxt.width)
            {
               this._circle.x = (this._tipTxt.width - this._circle.width + diameter) / 2;
            }
            else
            {
               this._tipTxt.x = (this._circle.width - this._tipTxt.width) / 2;
            }
            this._tipTxt.y = this._circle.y + this._circle.height - 10;
         }
         try
         {
            this.resize();
         }
         catch(evt:Error)
         {
         }
      }
      
      public function resize() : void
      {
         this.x = (stage.stageWidth - this.width) / 2;
         this.y = (stage.stageHeight - this.height) / 2;
      }
      
      public function setTip(param1:String) : void
      {
         if(this._tipTxt)
         {
            this._tipTxt.text = param1;
            if(this._circle.width <= this._tipTxt.width)
            {
               this._circle.x = (this._tipTxt.width - this._circle.width + this._diameter) / 2;
            }
            else
            {
               this._tipTxt.x = (this._circle.width - this._tipTxt.width) / 2;
            }
         }
         this.x = (stage.stageWidth - this.width) / 2;
         this.y = (stage.stageHeight - this.height) / 2;
      }
      
      private function onAlphaHalder(param1:Event) : void
      {
         var _loc3_:Shape = null;
         var _loc2_:* = 0;
         while(_loc2_ < this.nums)
         {
            _loc3_ = this.arr[_loc2_] as Shape;
            _loc3_.alpha = this.j;
            this.j = this.j - this.seg;
            if(Math.round(this.j * 100) / 100 == this.initseg)
            {
               this.j = 1;
            }
            _loc2_++;
         }
      }
      
      public function loading(param1:Number, param2:Number) : void
      {
         if(!this._perTxt)
         {
            this._perTxt = new TextField();
            addChild(this._perTxt);
            this._perTxt.mouseEnabled = false;
            this._perTxt.autoSize = "left";
            this._perTxt.defaultTextFormat = new TextFormat("Verdana",12,16777215);
         }
         this._perTxt.text = Math.floor(param1 / param2 * 100) + "%";
         this._perTxt.x = (this._diameter - this._perTxt.width) / 2;
         this._perTxt.y = (this._diameter - this._perTxt.height) / 2;
      }
      
      public function destroy() : void
      {
         removeEventListener(Event.ENTER_FRAME,this.onAlphaHalder);
         this["parent"].removeChild(this);
      }
   }
}
