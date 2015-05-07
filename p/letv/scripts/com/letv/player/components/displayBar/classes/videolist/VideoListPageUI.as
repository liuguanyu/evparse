package com.letv.player.components.displayBar.classes.videolist
{
   import com.letv.player.components.configcoms.ConfigVList;
   import com.letv.player.components.displayBar.classes.videolist.itemRenderer.VideoListPageItemRenderer;
   import com.alex.core.ICellRenderer;
   import com.letv.player.components.displayBar.classes.videolist.itemRenderer.VideoListPageContainerRenderer;
   import com.letv.player.components.displayBar.DisplayBarEvent;
   import flash.events.TextEvent;
   import flash.display.MovieClip;
   
   public class VideoListPageUI extends ConfigVList
   {
      
      public static const MAX_ROW:uint = 4;
      
      public static const MAX_NUM:uint = 50;
      
      private var parentSkin:MovieClip;
      
      private var classRenderer:Class;
      
      private var _vid:String;
      
      private var _data:Array;
      
      private var _stack:Vector.<VideoListPageItemRenderer>;
      
      private var _total:int;
      
      private var _pageIndex:uint;
      
      private var _isLoding:Boolean;
      
      public function VideoListPageUI(param1:Object)
      {
         if(!(param1 == null) && !(param1.parent == null))
         {
            this.parentSkin = param1.parent as MovieClip;
         }
         super(param1);
      }
      
      override public function destroy() : void
      {
         var _loc1_:VideoListPageItemRenderer = null;
         super.destroy();
         if(this._stack != null)
         {
            while(this._stack.length > 0)
            {
               _loc1_ = this._stack.shift();
               _loc1_.destroy();
            }
            _loc1_ = null;
            this._stack = null;
         }
      }
      
      public function setListData() : void
      {
         var _loc3_:Vector.<ICellRenderer> = null;
         var _loc4_:VideoListPageContainerRenderer = null;
         var _loc5_:uint = 0;
         var _loc6_:VideoListPageItemRenderer = null;
         var _loc7_:uint = 0;
         var _loc8_:uint = 0;
         var _loc9_:uint = 0;
         if(this._total <= 0)
         {
            this.parentSkin.pageLabel.visible = false;
         }
         var _loc1_:uint = this._total;
         var _loc2_:uint = Math.ceil(_loc1_ / MAX_NUM);
         if(_loc2_ > 3)
         {
            this.parentSkin.pageCombo.visible = true;
            this._stack = new Vector.<VideoListPageItemRenderer>();
            _loc3_ = new Vector.<ICellRenderer>();
            _loc4_ = new VideoListPageContainerRenderer();
            _loc5_ = 3;
            _loc7_ = 0;
            _loc8_ = 0;
            _loc9_ = _loc5_;
            while(_loc9_ < _loc2_)
            {
               _loc6_ = new VideoListPageItemRenderer(this.classRenderer,this,{
                  "start":_loc9_ * MAX_NUM + 1,
                  "stop":(_loc9_ == _loc2_ - 1?this._total:(_loc9_ + 1) * MAX_NUM),
                  "index":_loc9_
               });
               this._stack.push(_loc6_);
               _loc6_.x = _loc7_ % 3 * _loc6_.width;
               _loc6_.y = int(_loc7_ / 3) * _loc6_.height;
               _loc4_.addElement(_loc6_);
               _loc7_++;
               _loc8_ = _loc8_ + _loc6_.height;
               _loc9_++;
            }
            _loc3_.push(_loc4_);
            this.dataProvider = _loc3_;
            this.height = _loc8_ > 40 * MAX_ROW?40 * MAX_ROW:_loc8_;
         }
         else
         {
            this.parentSkin.pageCombo.visible = false;
         }
      }
      
      public function setIndexData(param1:String, param2:int) : void
      {
         this._vid = param1;
         this._total = param2;
         this.setListData();
      }
      
      public function getPageData(param1:uint) : void
      {
         this._isLoding = true;
         this._pageIndex = param1;
         dispatchEvent(new DisplayBarEvent(DisplayBarEvent.GET_VIDEO_LIST,param1));
      }
      
      public function setPageByIndex(param1:Array) : void
      {
         var _loc8_:uint = 0;
         this._isLoding = false;
         if(param1 == null)
         {
            return;
         }
         var _loc2_:uint = this._pageIndex;
         var _loc3_:uint = this._total;
         var _loc4_:uint = Math.ceil(_loc3_ / MAX_NUM);
         if(_loc2_ < 0)
         {
            _loc8_ = 0;
            while(_loc8_ < this._data.length)
            {
               if(this._vid == this._data[_loc8_].vid)
               {
                  _loc2_ = _loc8_;
                  break;
               }
               _loc8_++;
            }
            _loc8_ = 0;
            while(_loc8_ < _loc4_)
            {
               if(_loc8_ == _loc4_ - 1)
               {
                  _loc2_ = _loc8_;
                  break;
               }
               if(_loc2_ >= _loc8_ * MAX_NUM && _loc2_ < (_loc8_ + 1) * MAX_NUM)
               {
                  _loc2_ = _loc8_;
                  break;
               }
               _loc8_++;
            }
         }
         var _loc5_:* = "";
         var _loc6_:uint = _loc4_ > 3?3:_loc4_;
         var _loc7_:uint = _loc4_ > 3?3 * MAX_NUM:_loc3_;
         _loc8_ = 0;
         while(_loc8_ < _loc6_)
         {
            if(_loc2_ == _loc8_)
            {
               _loc5_ = _loc5_ + ("<font color=\'#31BAFF\' face=\'Microsoft YaHei,微软雅黑,Arial\'>" + (_loc8_ * MAX_NUM + 1) + "-");
               _loc5_ = _loc5_ + (_loc8_ == _loc6_ - 1?_loc7_ + "</font>":(_loc8_ + 1) * MAX_NUM + "</font> | ");
            }
            else
            {
               _loc5_ = _loc5_ + ("<font face=\'Microsoft YaHei,微软雅黑,Arial\'><a href=\'event:" + _loc8_ + "\'>" + (_loc8_ * MAX_NUM + 1) + "-");
               _loc5_ = _loc5_ + (_loc8_ == _loc6_ - 1?_loc7_ + "</a></font>":(_loc8_ + 1) * MAX_NUM + "</a></font> | ");
            }
            _loc8_++;
         }
         this.parentSkin.pageLabel.htmlText = _loc5_;
         if(this._stack != null)
         {
            _loc8_ = 0;
            while(_loc8_ < this._stack.length)
            {
               this._stack[_loc8_].selected = this._stack[_loc8_].index == _loc2_;
               _loc8_++;
            }
         }
         dispatchEvent(new DisplayBarEvent(DisplayBarEvent.CHANGE_PAGE,param1));
      }
      
      override protected function initialize() : void
      {
         super.initialize();
         visible = false;
         try
         {
            this.parentSkin.pageLabel.addEventListener(TextEvent.LINK,this.onLabelChangePage);
         }
         catch(e:Error)
         {
         }
         try
         {
            this.classRenderer = skinApplicationDomain.getDefinition("VideoListPageItem") as Class;
         }
         catch(e:Error)
         {
         }
      }
      
      public function onLabelChangePage(param1:TextEvent = null) : void
      {
         var _loc2_:uint = 0;
         if(this._isLoding)
         {
            return;
         }
         if(param1 != null)
         {
            _loc2_ = uint((param1 as TextEvent).text);
         }
         this.getPageData(_loc2_);
      }
   }
}
