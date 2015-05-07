package com.letv.player.components.displayBar.classes.videolist.itemRenderer
{
   import com.alex.containers.Canvas;
   import com.alex.core.ICellRenderer;
   import flash.text.TextFieldAutoSize;
   import flash.events.MouseEvent;
   import com.letv.player.components.displayBar.classes.videolist.VideoListPageUI;
   import flash.events.EventDispatcher;
   import flash.display.MovieClip;
   
   public class VideoListPageItemRenderer extends Canvas implements ICellRenderer
   {
      
      private var _data:Object;
      
      private var dispatcher:EventDispatcher;
      
      public function VideoListPageItemRenderer(param1:Class, param2:EventDispatcher, param3:Object)
      {
         this._data = param3;
         this.dispatcher = param2 as EventDispatcher;
         super(new param1() as MovieClip);
      }
      
      override public function destroy() : void
      {
         this._data = null;
         this.dispatcher = null;
         this.removeListener();
         super.destroy();
      }
      
      public function setSize(param1:Number, param2:Number) : void
      {
      }
      
      override public function get width() : Number
      {
         try
         {
            return uint(skin.back.width);
         }
         catch(e:Error)
         {
         }
         return super.width;
      }
      
      override public function get height() : Number
      {
         try
         {
            return uint(skin.back.height);
         }
         catch(e:Error)
         {
         }
         return super.height;
      }
      
      public function get index() : uint
      {
         try
         {
            return this.data["index"];
         }
         catch(e:Error)
         {
         }
         return 0;
      }
      
      public function get data() : Object
      {
         return this._data;
      }
      
      public function get pageContent() : String
      {
         try
         {
            return this.data["start"] + "-" + this.data["stop"];
         }
         catch(e:Error)
         {
         }
         return "error";
      }
      
      public function get selected() : Boolean
      {
         try
         {
            return skin.backSelected.visible;
         }
         catch(e:Error)
         {
         }
         return false;
      }
      
      public function set selected(param1:Boolean) : void
      {
         var flag:Boolean = param1;
         if(flag)
         {
            this.removeListener();
         }
         else
         {
            this.addListener();
         }
         try
         {
            skin.backRollOut.visible = true;
         }
         catch(e:Error)
         {
         }
         try
         {
            skin.backRollOver.visible = false;
         }
         catch(e:Error)
         {
         }
         try
         {
            skin.backSelected.visible = flag;
         }
         catch(e:Error)
         {
         }
      }
      
      override protected function initialize() : void
      {
         super.initialize();
         buttonMode = true;
         cacheAsBitmap = true;
         mouseChildren = false;
         this.selected = false;
         if(skin.label != null)
         {
            skin.label.autoSize = TextFieldAutoSize.LEFT;
            skin.label.text = this.pageContent;
            skin.label.x = (skin.back.width - skin.label.width) / 2;
            skin.label.y = (skin.back.height - skin.label.height) / 2;
         }
      }
      
      private function addListener() : void
      {
         addEventListener(MouseEvent.ROLL_OVER,this.onMouseEvent);
         addEventListener(MouseEvent.ROLL_OUT,this.onMouseEvent);
         addEventListener(MouseEvent.CLICK,this.onMouseEvent);
      }
      
      private function removeListener() : void
      {
         removeEventListener(MouseEvent.ROLL_OVER,this.onMouseEvent);
         removeEventListener(MouseEvent.ROLL_OUT,this.onMouseEvent);
         removeEventListener(MouseEvent.CLICK,this.onMouseEvent);
      }
      
      private function onMouseEvent(param1:MouseEvent) : void
      {
         var event:MouseEvent = param1;
         switch(event.type)
         {
            case MouseEvent.ROLL_OVER:
               try
               {
                  skin.backRollOut.visible = false;
               }
               catch(e:Error)
               {
               }
               try
               {
                  skin.backRollOver.visible = true;
               }
               catch(e:Error)
               {
               }
               break;
            case MouseEvent.ROLL_OUT:
               try
               {
                  skin.backRollOut.visible = true;
               }
               catch(e:Error)
               {
               }
               try
               {
                  skin.backRollOver.visible = false;
               }
               catch(e:Error)
               {
               }
               break;
            case MouseEvent.CLICK:
               (this.dispatcher as VideoListPageUI).getPageData(this.index);
               break;
         }
      }
   }
}
