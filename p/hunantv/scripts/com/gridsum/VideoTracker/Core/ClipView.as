package com.gridsum.VideoTracker.Core
{
   import com.gridsum.VideoTracker.Config.VideoTrackerConfig;
   
   class ClipView extends Object
   {
      
      private var _index:int = -1;
      
      private var _viewCount:Number = 0;
      
      function ClipView(param1:int)
      {
         super();
         this._viewCount = 0;
         this._index = param1;
      }
      
      public function view(param1:Number) : void
      {
         this._viewCount = this._viewCount + param1;
      }
      
      public function getViewCount() : int
      {
         var _loc1_:int = Math.round(this._viewCount);
         if(_loc1_ == 0 && this._viewCount > VideoTrackerConfig.clipViewedThreasholdRate)
         {
            _loc1_ = 1;
         }
         return _loc1_;
      }
      
      public function get index() : int
      {
         return this._index;
      }
   }
}
