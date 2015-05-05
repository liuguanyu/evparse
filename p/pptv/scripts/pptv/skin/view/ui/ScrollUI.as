package pptv.skin.view.ui
{
   import flash.display.MovieClip;
   import flash.geom.Rectangle;
   import flash.display.DisplayObject;
   import flash.geom.Transform;
   import flash.geom.Matrix;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class ScrollUI extends MovieClip
   {
      
      private var _mContent:MovieClip;
      
      private var _mScrollHandler:MovieClip;
      
      private var _scroll_rect:Rectangle;
      
      private var maskRect:Rectangle;
      
      public function ScrollUI()
      {
         this.maskRect = new Rectangle(0,0,310,150);
         super();
         this._mContent = this.getChildByName("mContent") as MovieClip;
         this._mScrollHandler = this.getChildByName("mScrollHandler") as MovieClip;
         this._mContent.scrollRect = this.maskRect;
         this.addEventListener(Event.ADDED_TO_STAGE,this.initScrollBar);
      }
      
      public function addChildContent(param1:DisplayObject) : void
      {
         this._mContent.addChild(param1);
         this.checkScrollVisable();
      }
      
      public function removeContent(param1:DisplayObject) : void
      {
         try
         {
            this._mContent.removeChild(param1);
         }
         catch(e:Error)
         {
         }
      }
      
      public function getFullBounds(param1:*) : Rectangle
      {
         var _loc2_:Transform = param1.transform;
         var _loc3_:Matrix = _loc2_.matrix;
         var _loc4_:Matrix = _loc2_.concatenatedMatrix;
         _loc4_.invert();
         _loc2_.matrix = _loc4_;
         var _loc5_:Rectangle = _loc2_.pixelBounds.clone();
         _loc2_.matrix = _loc3_;
         return _loc5_;
      }
      
      private function initScrollBar(param1:Event = null) : void
      {
         this._scroll_rect = new Rectangle(this._mScrollHandler.mScrollArea.x,this._mScrollHandler.mScrollArea.y,0,this._mScrollHandler.mScrollArea.height - this._mScrollHandler.mThumb.height);
         this._mScrollHandler.mThumb.mouseChildren = false;
         this._mScrollHandler.mThumb.addEventListener(MouseEvent.MOUSE_DOWN,this.pressDown);
         this._mScrollHandler.mThumb.addEventListener(MouseEvent.MOUSE_UP,this.pressUp);
         this._mScrollHandler.mThumb.stage.addEventListener(MouseEvent.MOUSE_UP,this.pressUp);
         this._mScrollHandler.mThumb.addEventListener(MouseEvent.MOUSE_OVER,this.kmouseOver);
         this._mScrollHandler.mThumb.addEventListener(MouseEvent.MOUSE_OUT,this.kmouseOut);
      }
      
      private function kmouseOver(param1:MouseEvent) : void
      {
      }
      
      private function kmouseOut(param1:MouseEvent) : void
      {
      }
      
      private function pressDown(param1:MouseEvent) : void
      {
         this._mScrollHandler.mThumb.startDrag(false,this._scroll_rect);
         this._mScrollHandler.mThumb.addEventListener(Event.ENTER_FRAME,this.drag);
      }
      
      private function pressUp(param1:MouseEvent) : void
      {
         this._mScrollHandler.mThumb.stopDrag();
         this._mScrollHandler.mThumb.removeEventListener(Event.ENTER_FRAME,this.drag);
      }
      
      private function drag(param1:Event) : void
      {
         var _loc2_:Number = this.getFullBounds(this._mContent).height;
         var _loc3_:Number = (this.maskRect.height - _loc2_) * this._mScrollHandler.mThumb.y / (this._mScrollHandler.mScrollArea.height - this._mScrollHandler.mThumb.height);
         this.maskRect.y = -_loc3_;
         this._mContent.scrollRect = this.maskRect;
      }
      
      private function checkScrollVisable() : void
      {
         var _loc1_:Number = this.getFullBounds(this._mContent).height;
         this._mScrollHandler.visible = _loc1_ > this.maskRect.height;
      }
   }
}
