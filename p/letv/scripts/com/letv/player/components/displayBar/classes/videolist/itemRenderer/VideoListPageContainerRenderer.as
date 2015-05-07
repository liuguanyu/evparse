package com.letv.player.components.displayBar.classes.videolist.itemRenderer
{
   import com.alex.containers.Canvas;
   import com.alex.core.ICellRenderer;
   import flash.display.MovieClip;
   
   public class VideoListPageContainerRenderer extends Canvas implements ICellRenderer
   {
      
      public function VideoListPageContainerRenderer(param1:MovieClip = null, param2:Object = null)
      {
         super(param1,param2);
      }
      
      override public function destroy() : void
      {
         var _loc1_:ICellRenderer = null;
         while(numElement > 0)
         {
            _loc1_ = removeElementAt(0) as VideoListPageItemRenderer;
            if(_loc1_ != null)
            {
               _loc1_.destroy();
            }
         }
         super.destroy();
      }
      
      public function setSize(param1:Number, param2:Number) : void
      {
      }
      
      public function set selected(param1:Boolean) : void
      {
      }
      
      public function get selected() : Boolean
      {
         return false;
      }
   }
}
