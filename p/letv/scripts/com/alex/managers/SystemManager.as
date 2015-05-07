package com.alex.managers
{
   import flash.display.Stage;
   import flash.geom.Rectangle;
   import com.alex.states.Screen;
   
   public final class SystemManager extends Object implements ISystemManager
   {
      
      private var _saver:Object;
      
      private var _resizer:Vector.<Function>;
      
      private var _stage:Stage;
      
      private var _screen:Screen;
      
      public function SystemManager()
      {
         this._saver = {};
         this._screen = new Screen(Screen.APP_MIN_WIDTH_PIXEL,Screen.APP_MIN_HEIGHT_PIXEL);
         super();
         this._resizer = new Vector.<Function>();
         this._screen = new Screen(Screen.APP_MIN_WIDTH_PIXEL,Screen.APP_MIN_HEIGHT_PIXEL);
      }
      
      public function setMsg(param1:String, param2:Object) : Boolean
      {
         if(param1 == null || param1 == "")
         {
            return false;
         }
         this._saver[param1] = param2;
         return true;
      }
      
      public function getMsg(param1:String) : Object
      {
         return this._saver[param1];
      }
      
      public function delMsg(param1:String) : void
      {
         delete this._saver[param1];
         true;
      }
      
      public function addResize(param1:Function) : void
      {
         var _loc2_:uint = this._resizer.length;
         var _loc3_:* = 0;
         while(_loc3_ < _loc2_)
         {
            if(this._resizer[_loc3_] == param1)
            {
               return;
            }
            _loc3_++;
         }
         this._resizer.push(param1);
      }
      
      public function removeResize(param1:Function) : void
      {
         var _loc2_:uint = this._resizer.length;
         var _loc3_:* = 0;
         while(_loc3_ < _loc2_)
         {
            if(this._resizer[_loc3_] == param1)
            {
               this._resizer.splice(_loc3_,1);
               break;
            }
            _loc3_++;
         }
      }
      
      public function setStage(param1:Stage) : void
      {
         this._stage = param1;
      }
      
      public function setFullScreen(param1:Boolean, param2:Boolean = false) : void
      {
         var value:Boolean = param1;
         var interactive:Boolean = param2;
         try
         {
            if(value)
            {
               this._stage.displayState = interactive?"fullScreenInteractive":"fullScreen";
            }
            else
            {
               this._stage.displayState = "normal";
            }
         }
         catch(e:Error)
         {
            try
            {
               if(value)
               {
                  _stage.displayState = "fullScreen";
               }
            }
            catch(e:Error)
            {
            }
         }
      }
      
      public function set screen(param1:Rectangle) : void
      {
         if(param1 != null)
         {
            this._screen = new Screen(param1.width,param1.height);
         }
         else
         {
            this._screen = new Screen(Screen.APP_MIN_WIDTH_PIXEL,Screen.APP_MIN_HEIGHT_PIXEL);
         }
         this.dispatchResize();
      }
      
      public function set applicationWidth(param1:Number) : void
      {
         if(param1 < Screen.APP_MIN_WIDTH_PIXEL)
         {
            var param1:Number = Screen.APP_MIN_WIDTH_PIXEL;
         }
         this._screen.width = param1;
         this.dispatchResize();
      }
      
      public function get applicationWidth() : Number
      {
         return this._screen.width;
      }
      
      public function set applicationHeight(param1:Number) : void
      {
         if(param1 < Screen.APP_MIN_HEIGHT_PIXEL)
         {
            var param1:Number = Screen.APP_MIN_HEIGHT_PIXEL;
         }
         this._screen.height = param1;
         this.dispatchResize();
      }
      
      public function get applicationHeight() : Number
      {
         return this._screen.height;
      }
      
      protected function dispatchResize() : void
      {
         var _loc1_:uint = this._resizer.length;
         var _loc2_:* = 0;
         while(_loc2_ < _loc1_)
         {
            if(!(this._resizer[_loc2_] == null) && this._resizer[_loc2_] is Function)
            {
               this._resizer[_loc2_](this._screen);
            }
            _loc2_++;
         }
      }
   }
}
