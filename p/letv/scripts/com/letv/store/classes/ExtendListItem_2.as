package com.letv.store.classes
{
   import com.letv.player.components.ExtendItem_2;
   import flash.events.MouseEvent;
   import flash.text.TextFieldAutoSize;
   import com.letv.store.events.ExtendListEvent;
   
   public class ExtendListItem_2 extends ExtendItem_2
   {
      
      public static const GAP:uint = 30;
      
      private var _data:Object;
      
      private var _yy:Number = 0;
      
      public function ExtendListItem_2(param1:Object = null)
      {
         super();
         this._data = param1;
         this.init();
      }
      
      override public function get width() : Number
      {
         return back.width;
      }
      
      public function get id() : String
      {
         try
         {
            return this._data.id;
         }
         catch(e:Error)
         {
         }
         return null;
      }
      
      public function get eventid() : String
      {
         try
         {
            return this._data.eventid;
         }
         catch(e:Error)
         {
         }
         return null;
      }
      
      public function get title() : String
      {
         try
         {
            return this._data.title;
         }
         catch(e:Error)
         {
         }
         return "";
      }
      
      public function set selected(param1:Boolean) : void
      {
         this.icon.visible = true;
         this.loading.visible = false;
         if(param1)
         {
            icon.gotoAndStop(2);
            this.addEventListener(MouseEvent.CLICK,this.onCloseItem);
         }
         else
         {
            icon.gotoAndStop(1);
            this.addEventListener(MouseEvent.CLICK,this.onOpenItem);
         }
      }
      
      public function get selected() : Boolean
      {
         return (icon.visible) && icon.currentFrame == 2;
      }
      
      public function set yy(param1:Number) : void
      {
         this._yy = param1;
      }
      
      public function get yy() : Number
      {
         return this._yy;
      }
      
      public function destroy() : void
      {
         this.removeListener();
         this._data = null;
         if(parent)
         {
            parent.removeChild(this);
         }
      }
      
      private function init() : void
      {
         buttonMode = true;
         this.selected = false;
         back.mouseEnabled = false;
         back.mouseChildren = false;
         label.mouseEnabled = false;
         label.autoSize = TextFieldAutoSize.CENTER;
         label.text = "" + this.title;
         if(this.eventid == null || this.id == null)
         {
            return;
         }
         this.addListener();
      }
      
      private function addListener() : void
      {
         addEventListener(MouseEvent.CLICK,this.onOpenItem);
         addEventListener(MouseEvent.ROLL_OVER,this.onRollOver);
         addEventListener(MouseEvent.ROLL_OUT,this.onRollOut);
      }
      
      private function removeListener() : void
      {
         removeEventListener(MouseEvent.CLICK,this.onOpenItem);
         removeEventListener(MouseEvent.CLICK,this.onCloseItem);
      }
      
      private function onOpenItem(param1:MouseEvent) : void
      {
         this.removeListener();
         icon.visible = false;
         loading.gotoAndPlay(1);
         loading.visible = true;
         var _loc2_:ExtendListEvent = new ExtendListEvent(ExtendListEvent.CHANGE);
         _loc2_.eventid = this.eventid;
         _loc2_.id = this.id;
         dispatchEvent(_loc2_);
      }
      
      private function onCloseItem(param1:MouseEvent) : void
      {
         var _loc2_:ExtendListEvent = new ExtendListEvent(ExtendListEvent.CLOSE_PLUGIN);
         _loc2_.eventid = this.eventid;
         _loc2_.id = this.id;
         dispatchEvent(_loc2_);
      }
      
      private function onRollOver(param1:MouseEvent) : void
      {
         var event:MouseEvent = param1;
         try
         {
            back.gotoAndStop(2);
         }
         catch(e:Error)
         {
         }
      }
      
      private function onRollOut(param1:MouseEvent) : void
      {
         var event:MouseEvent = param1;
         try
         {
            back.gotoAndStop(1);
         }
         catch(e:Error)
         {
         }
      }
   }
}
