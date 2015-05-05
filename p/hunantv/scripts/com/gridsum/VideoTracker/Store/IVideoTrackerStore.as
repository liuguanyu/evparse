package com.gridsum.VideoTracker.Store
{
   interface IVideoTrackerStore
   {
      
      function addOrSetValue(param1:String, param2:Object) : void;
      
      function getValue(param1:String) : Object;
   }
}
