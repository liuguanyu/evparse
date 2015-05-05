package com.gridsum.VideoTracker.Store
{
   import flash.net.SharedObject;
   
   public class FlashStore extends Object implements IVideoTrackerStore
   {
      
      private var _sharedObject:SharedObject = null;
      
      public function FlashStore(param1:String = "GridsumCommon")
      {
         var _loc2_:Error = null;
         super();
         this._sharedObject = SharedObject.getLocal(param1);
         if(this._sharedObject == null)
         {
            _loc2_ = new Error("SharedObject.getLocal returns null。");
            throw _loc2_;
         }
         else
         {
            return;
         }
      }
      
      public function addOrSetValue(param1:String, param2:Object) : void
      {
         var _loc3_:Error = null;
         if(this._sharedObject == null)
         {
            _loc3_ = new Error("FlashStore cannot be used because the referrenced instance of SharedObject is null.");
            throw _loc3_;
         }
         else
         {
            this._sharedObject.data[param1] = param2;
            this._sharedObject.flush();
            return;
         }
      }
      
      public function getValue(param1:String) : Object
      {
         var _loc2_:Error = null;
         if(this._sharedObject == null)
         {
            _loc2_ = new Error("FlashStore cannot be used because the referrenced instance of SharedObject is null.");
            throw _loc2_;
         }
         else
         {
            return this._sharedObject.data[param1];
         }
      }
   }
}
