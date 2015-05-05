package cn.pplive.player.view.ui
{
   import flash.display.Sprite;
   import flash.display.MovieClip;
   import flash.events.Event;
   import cn.pplive.player.utils.PrintDebug;
   import flash.events.MouseEvent;
   import pptv.skin.view.events.SkinEvent;
   
   public class SmartClickPanel extends Sprite
   {
      
      private var TipsMc:Class;
      
      private var _visible:Boolean = true;
      
      private var _data:Array;
      
      private var _smartUIs:Array;
      
      private var _w:Number = 0;
      
      private var _h:Number = 0;
      
      private var _x:Number = 0;
      
      private var _y:Number = 0;
      
      private var _tagID:String = "";
      
      private var _tipSMc:MovieClip;
      
      public function SmartClickPanel()
      {
         this.TipsMc = SmartClickPanel_TipsMc;
         this._smartUIs = [];
         super();
         this._tipSMc = new this.TipsMc();
         this.addChild(this._tipSMc);
         this._tipSMc.visible = false;
      }
      
      public function set smartClickData(param1:Array) : void
      {
         this.clearSmartClickUI();
         this._data = param1;
      }
      
      override public function set visible(param1:Boolean) : void
      {
         this._visible = param1;
         var _loc2_:int = this._smartUIs.length - 1;
         while(_loc2_ >= 0)
         {
            this._smartUIs[_loc2_].visible = this._visible;
            _loc2_--;
         }
      }
      
      override public function get visible() : Boolean
      {
         return this._visible;
      }
      
      public function set playTime(param1:Number) : void
      {
         var _loc2_:Object = null;
         var _loc3_:* = 0;
         var _loc4_:SmartClickMc = null;
         try
         {
            if(!this._data)
            {
               return;
            }
            for each(_loc2_ in this._data)
            {
               if(!_loc2_.display && _loc2_.time <= param1 && _loc2_.time + _loc2_.duration >= param1)
               {
                  this.creatClickUI(_loc2_);
               }
               if(_loc2_.time - 2 <= param1 && _loc2_.time + _loc2_.duration >= param1)
               {
                  this._tipSMc.visible = true;
               }
            }
            _loc3_ = this._smartUIs.length - 1;
            while(_loc3_ >= 0)
            {
               _loc4_ = this._smartUIs[_loc3_];
               if(param1 < _loc4_.data.time || param1 > _loc4_.data.time + _loc4_.data.duration)
               {
                  this.destroyClickUI(_loc4_);
               }
               _loc3_--;
            }
         }
         catch(e:Event)
         {
         }
      }
      
      public function resize(param1:Object = null) : void
      {
         var _loc2_:SmartClickMc = null;
         try
         {
            if(!param1)
            {
               return;
            }
            this._w = param1.width;
            this._h = param1.height;
            this._x = param1.x;
            this._y = param1.y;
            this._tipSMc.x = this._x + this._w - this._tipSMc.width - 10;
            this._tipSMc.y = 10;
            for each(_loc2_ in this._smartUIs)
            {
               this.updataUIPosition(_loc2_);
            }
         }
         catch(e:Event)
         {
         }
      }
      
      public function clearSmartClickUI() : void
      {
         var _loc2_:SmartClickMc = null;
         var _loc1_:int = this._smartUIs.length - 1;
         while(_loc1_ >= 0)
         {
            _loc2_ = this._smartUIs[_loc1_];
            this.destroyClickUI(_loc2_);
            _loc1_--;
         }
      }
      
      private function creatClickUI(param1:Object) : void
      {
         PrintDebug.Trace(param1,"创建一个广告可点击对象 >>>>>> " + param1.title);
         var _loc2_:SmartClickMc = new SmartClickMc();
         _loc2_.addEventListener(MouseEvent.CLICK,this.clickHandler);
         _loc2_.data = param1;
         _loc2_.visible = this._visible;
         this._smartUIs.push(_loc2_);
         this.addChild(_loc2_);
         param1.display = true;
         this.updataUIPosition(_loc2_);
      }
      
      private function clickHandler(param1:MouseEvent) : void
      {
         try
         {
            if(this._tagID != (param1.currentTarget as SmartClickUI).data.tagid)
            {
               this._tagID = (param1.currentTarget as SmartClickUI).data.tagid;
               this.dispatchEvent(new SkinEvent(SkinEvent.MEDIA_SMARTCLICK,{
                  "tag":this._tagID,
                  "time":(param1.currentTarget as SmartClickUI).data.time
               }));
            }
         }
         catch(e:Event)
         {
         }
      }
      
      private function destroyClickUI(param1:SmartClickMc) : void
      {
         var _loc2_:* = 0;
         try
         {
            PrintDebug.Trace("移除一个广告可点击对象 >>>>>> " + param1.data.title);
            _loc2_ = this._smartUIs.indexOf(param1);
            this._smartUIs.splice(_loc2_,1);
            if(param1.parent)
            {
               this.removeChild(param1);
               param1.data.display = false;
            }
            if(this._tagID == param1.data.tagid)
            {
               this._tagID = "";
            }
            param1.removeEventListener(MouseEvent.CLICK,this.clickHandler);
            param1.destroy();
            var param1:SmartClickMc = null;
            this._tipSMc.visible = false;
         }
         catch(e:Event)
         {
         }
      }
      
      private function updataUIPosition(param1:SmartClickMc) : void
      {
         var _loc2_:Array = null;
         var _loc3_:Array = null;
         var _loc4_:* = NaN;
         var _loc5_:* = NaN;
         var _loc6_:* = NaN;
         var _loc7_:* = NaN;
         try
         {
            _loc2_ = param1.data.tl.split(",");
            _loc3_ = param1.data.br.split(",");
            _loc4_ = _loc2_[0] * this._h;
            _loc5_ = _loc2_[1] * this._w;
            _loc6_ = _loc3_[0] * this._h;
            _loc7_ = _loc3_[1] * this._w;
            param1.x = this._x + _loc5_;
            param1.y = this._y + _loc4_;
            param1.height = _loc6_ - _loc4_ > 0?_loc6_ - _loc4_:0;
            param1.width = _loc7_ - _loc5_ > 0?_loc7_ - _loc5_:0;
         }
         catch(e:Event)
         {
         }
      }
   }
}
