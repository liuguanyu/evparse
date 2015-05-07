package com.letv.player.components.displayBar.classes.videolist.itemRenderer
{
   import com.alex.containers.Canvas;
   import com.alex.core.ICellRenderer;
   import flash.text.TextFormat;
   import flash.text.TextField;
   import com.alex.utils.RichStringUtil;
   import flash.text.TextFieldAutoSize;
   import flash.events.MouseEvent;
   import com.letv.player.components.displayBar.DisplayBarEvent;
   import flash.events.EventDispatcher;
   import flash.display.MovieClip;
   
   public class VideoListDisplayItemRenderer extends Canvas implements ICellRenderer
   {
      
      public static const FORMAT_ROLL_OVER:TextFormat = new TextFormat("Microsoft YaHei,微软雅黑,Arial",14,16777215);
      
      public static const FORMAT_ROLL_OUT:TextFormat = new TextFormat("Microsoft YaHei,微软雅黑,Arial",14,10066329);
      
      private var _selected:Boolean;
      
      private var data:Object;
      
      private var dispatcher:EventDispatcher;
      
      public function VideoListDisplayItemRenderer(param1:Class, param2:EventDispatcher, param3:Object)
      {
         this.data = param3;
         this.dispatcher = param2;
         super(new param1() as MovieClip);
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
      
      override public function destroy() : void
      {
         this.removeListener();
         clearparent();
         this.data = null;
         this.dispatcher = null;
         super.destroy();
      }
      
      public function setSize(param1:Number, param2:Number) : void
      {
      }
      
      public function get selected() : Boolean
      {
         return false;
      }
      
      public function get key() : uint
      {
         if(!(this.data == null) && (this.data.hasOwnProperty("key")))
         {
            return uint(this.data.key);
         }
         return 1;
      }
      
      public function get vid() : String
      {
         if(!(this.data == null) && (this.data.hasOwnProperty("vid")))
         {
            return this.data["vid"];
         }
         return "";
      }
      
      public function get title() : String
      {
         if(!(this.data == null) && (this.data.hasOwnProperty("title")))
         {
            return this.data.title;
         }
         return "未知";
      }
      
      public function get subTitle() : String
      {
         if(!(this.data == null) && (this.data.hasOwnProperty("subTitle")) && !(String(this.data["subTitle"]) == ""))
         {
            return ":" + this.data.subTitle;
         }
         return "";
      }
      
      public function set selected(param1:Boolean) : void
      {
         var flag:Boolean = param1;
         this._selected = flag;
         if(flag)
         {
            mouseEnabled = false;
            (skin.label as TextField).setTextFormat(FORMAT_ROLL_OVER);
            this.removeListener();
         }
         else
         {
            mouseEnabled = true;
            (skin.label as TextField).setTextFormat(FORMAT_ROLL_OUT);
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
         skin.label.x = (skin.back.width - skin.label.width) / 2;
         skin.label.y = (skin.back.height - skin.label.height) / 2;
      }
      
      override protected function initialize() : void
      {
         var _loc1_:String = null;
         super.initialize();
         buttonMode = true;
         cacheAsBitmap = true;
         mouseChildren = false;
         _loc1_ = RichStringUtil.removeNewlineOrEnter(this.title + this.subTitle);
         _loc1_ = RichStringUtil.trim(_loc1_);
         _loc1_ = _loc1_.length > 23?_loc1_.substr(0,20) + "...":_loc1_;
         skin.label.text = _loc1_;
         skin.label.autoSize = TextFieldAutoSize.LEFT;
         this.selected = false;
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
         switch(param1.type)
         {
            case MouseEvent.ROLL_OVER:
               (skin.label as TextField).setTextFormat(FORMAT_ROLL_OVER);
               break;
            case MouseEvent.ROLL_OUT:
               (skin.label as TextField).setTextFormat(FORMAT_ROLL_OUT);
               break;
            case MouseEvent.CLICK:
               this.dispatcher.dispatchEvent(new DisplayBarEvent(DisplayBarEvent.CHANGE_PLAY,this.data));
               break;
         }
      }
   }
}
