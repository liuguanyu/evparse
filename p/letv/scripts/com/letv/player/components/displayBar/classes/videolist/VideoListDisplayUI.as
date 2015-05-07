package com.letv.player.components.displayBar.classes.videolist
{
   import com.letv.player.components.configcoms.ConfigVList;
   import com.alex.core.ICellRenderer;
   import com.letv.player.components.displayBar.classes.videolist.itemRenderer.VideoListDisplayItemRenderer;
   
   public class VideoListDisplayUI extends ConfigVList
   {
      
      private var classRenderer:Class;
      
      private var _vid:String;
      
      public function VideoListDisplayUI(param1:Object = null)
      {
         super(param1);
      }
      
      override public function set height(param1:Number) : void
      {
         super.height = param1;
         this.renderPosition();
      }
      
      public function setListData(param1:Array) : void
      {
         var _loc2_:Vector.<ICellRenderer> = null;
         var _loc3_:VideoListDisplayItemRenderer = null;
         var _loc4_:uint = 0;
         removeAll();
         if(!(param1 == null) && param1.length > 0)
         {
            _loc2_ = new Vector.<ICellRenderer>();
            _loc4_ = 0;
            while(_loc4_ < param1.length)
            {
               _loc3_ = new VideoListDisplayItemRenderer(this.classRenderer,this,param1[_loc4_]);
               if(_loc3_.vid == this._vid)
               {
                  _loc3_.selected = true;
               }
               else
               {
                  _loc3_.selected = false;
               }
               _loc2_.push(_loc3_);
               _loc4_++;
            }
            dataProvider = _loc2_;
         }
         this.renderPosition();
      }
      
      private function renderPosition() : void
      {
         var _loc1_:* = 0;
         var _loc2_:uint = 0;
         if(stack != null)
         {
            _loc1_ = -1;
            _loc2_ = 0;
            while(_loc2_ < stack.length)
            {
               if(stack[_loc2_]["vid"] == this._vid)
               {
                  _loc1_ = _loc2_;
                  break;
               }
               _loc2_++;
            }
            if(_loc1_ >= 0)
            {
               displayIndex = _loc1_;
            }
            else
            {
               displayIndex = 0;
            }
         }
      }
      
      public function setIndexData(param1:String) : void
      {
         this._vid = param1;
      }
      
      override protected function initialize() : void
      {
         super.initialize();
         this.classRenderer = skinApplicationDomain.getDefinition("VideoListDisplayItem") as Class;
      }
   }
}
