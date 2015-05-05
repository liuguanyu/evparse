package com.gridsum.VideoTracker.Core
{
   import flash.utils.Dictionary;
   
   class UserEventLogic extends Object
   {
      
      private var _activeIntervalUserEvent:Dictionary = null;
      
      private var _newestId:int = 0;
      
      private var _userEventStatistics:Dictionary = null;
      
      function UserEventLogic()
      {
         super();
         this._activeIntervalUserEvent = new Dictionary();
         this._userEventStatistics = new Dictionary();
      }
      
      private function addToEventCollection(param1:UserEvent) : void
      {
         var _loc2_:String = param1.getKey();
         var _loc3_:Object = null;
         if(this._userEventStatistics.hasOwnProperty(_loc2_))
         {
            _loc3_ = this._userEventStatistics[_loc2_];
            _loc3_.count++;
            _loc3_.duration = _loc3_.duration + param1.duration;
         }
         else
         {
            _loc3_ = new Object();
            _loc3_.count = 1;
            _loc3_.duration = param1.duration;
            this._userEventStatistics[_loc2_] = _loc3_;
         }
      }
      
      public function trackEvent(param1:String, param2:String, param3:String, param4:int) : void
      {
         var _loc5_:PointUserEvent = new PointUserEvent();
         _loc5_.action = param1;
         _loc5_.category = param2;
         _loc5_.label = param3;
         _loc5_.value = param4;
         this.addToEventCollection(_loc5_);
      }
      
      public function beginEvent(param1:String, param2:String, param3:String, param4:int) : int
      {
         var _loc5_:IntervalUserEvent = new IntervalUserEvent();
         _loc5_.action = param1;
         _loc5_.category = param2;
         _loc5_.label = param3;
         _loc5_.value = param4;
         this._newestId++;
         this._activeIntervalUserEvent[this._newestId] = _loc5_;
         _loc5_.beginEvent();
         return this._newestId;
      }
      
      public function endEvent(param1:int) : void
      {
         var _loc2_:IntervalUserEvent = null;
         if(this._activeIntervalUserEvent.hasOwnProperty(param1))
         {
            _loc2_ = this._activeIntervalUserEvent[param1];
            _loc2_.endEvent();
            this._activeIntervalUserEvent[param1] = null;
            this.addToEventCollection(_loc2_);
         }
      }
      
      public function toString() : String
      {
         var _loc3_:Object = null;
         var _loc4_:String = null;
         var _loc5_:String = null;
         var _loc1_:* = "";
         var _loc2_:Object = null;
         for(_loc3_ in this._userEventStatistics)
         {
            _loc2_ = this._userEventStatistics[_loc3_];
            _loc4_ = _loc2_.duration.toFixed(3);
            _loc5_ = _loc2_.duration.toString();
            if(_loc4_.length < _loc5_.length)
            {
               _loc5_ = _loc4_;
            }
            _loc1_ = _loc1_ + (_loc3_ + "!" + _loc5_ + "!" + _loc2_.count + "~");
         }
         return _loc1_;
      }
   }
}
