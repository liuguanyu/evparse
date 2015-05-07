package com.alex.controls
{
   import com.alex.core.UIComponent;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.events.Event;
   
   public class RadioButtonGroup2 extends UIComponent
   {
      
      private var _level:uint = 0;
      
      protected var list:Vector.<RadioButton2>;
      
      public function RadioButtonGroup2(param1:Array)
      {
         super(null,param1);
      }
      
      public static function visibleLevel(param1:Array, param2:uint) : void
      {
         var _loc3_:* = 0;
         if(param1 != null)
         {
            _loc3_ = 0;
            while(_loc3_ < param1.length)
            {
               if(!(param1[_loc3_] == null) && param1[_loc3_] is DisplayObject)
               {
                  (param1[_loc3_] as DisplayObject).visible = param2 == _loc3_;
               }
               _loc3_++;
            }
         }
      }
      
      override public function destroy() : void
      {
         this.removeAll();
         super.destroy();
      }
      
      override public function set visible(param1:Boolean) : void
      {
         var _loc2_:* = 0;
         while(_loc2_ < this.list.length)
         {
            this.list[_loc2_].visible = param1;
            _loc2_++;
         }
      }
      
      override public function set enabled(param1:Boolean) : void
      {
         _enabled = param1;
         var _loc2_:* = 0;
         while(_loc2_ < this.list.length)
         {
            this.list[_loc2_].enabled = param1;
            _loc2_++;
         }
      }
      
      override public function get enabled() : Boolean
      {
         return _enabled;
      }
      
      public function set dataProvider(param1:Array) : void
      {
         var _loc2_:RadioButton2 = null;
         var _loc3_:* = 0;
         this.removeAll();
         this.list = new Vector.<RadioButton2>();
         if(param1 != null)
         {
            _loc3_ = 0;
            while(_loc3_ < param1.length)
            {
               if(!(param1[_loc3_] == null) && param1[_loc3_] is MovieClip)
               {
                  _loc2_ = new RadioButton2(param1[_loc3_]);
                  _loc2_.addEventListener(Event.CHANGE,this.onChange);
                  this.list.push(_loc2_);
               }
               _loc3_++;
            }
            this.onChange();
         }
      }
      
      public function set enabledList(param1:Array) : void
      {
         var _loc2_:* = 0;
         while(_loc2_ < this.list.length)
         {
            this.list[_loc2_].enabled = String(param1[_loc2_]) == "1";
            _loc2_++;
         }
      }
      
      public function set visibleList(param1:Array) : void
      {
         var _loc2_:* = 0;
         while(_loc2_ < this.list.length)
         {
            this.list[_loc2_].visible = String(param1[_loc2_]) == "1";
            _loc2_++;
         }
      }
      
      public function set visibleLevel(param1:uint) : void
      {
         var _loc2_:* = 0;
         while(_loc2_ < this.list.length)
         {
            this.list[_loc2_].visible = _loc2_ == param1;
            _loc2_++;
         }
      }
      
      public function set level(param1:uint) : void
      {
         this._level = param1;
         var _loc2_:* = 0;
         while(_loc2_ < this.list.length)
         {
            this.list[_loc2_].selected = _loc2_ == this._level;
            _loc2_++;
         }
      }
      
      public function get level() : uint
      {
         return this._level;
      }
      
      override protected function initialize() : void
      {
         super.initialize();
         if(viewData != null)
         {
            this.dataProvider = viewData as Array;
         }
      }
      
      protected function removeAll() : void
      {
         if(this.list != null)
         {
            while(this.list.length > 0)
            {
               this.list[0].removeEventListener(Event.CHANGE,this.onChange);
               this.list[0].destroy();
               this.list[0] = null;
               this.list.shift();
            }
            this.list = null;
         }
      }
      
      private function onChange(param1:Event = null) : void
      {
         var _loc2_:* = 0;
         if(param1 == null)
         {
            _loc2_ = 0;
            while(_loc2_ < this.list.length)
            {
               this.list[_loc2_].selected = _loc2_ == this._level;
               _loc2_++;
            }
            return;
         }
         _loc2_ = 0;
         while(_loc2_ < this.list.length)
         {
            if(this.list[_loc2_].skin == param1.target)
            {
               this._level = _loc2_;
               this.list[_loc2_].selected = true;
            }
            else
            {
               this.list[_loc2_].selected = false;
            }
            _loc2_++;
         }
         dispatchEvent(new Event(Event.CHANGE));
      }
   }
}
