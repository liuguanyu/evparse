package com.alex.rpc.core
{
   import com.alex.rpc.interfaces.IMedia;
   import com.alex.rpc.events.AutoLoaderEvent;
   
   public class MultiLoader extends BaseLoader
   {
      
      private var mediaStack:Array;
      
      private var count:int;
      
      public function MultiLoader()
      {
         super();
      }
      
      override public function destroy() : void
      {
         var _loc3_:IMedia = null;
         if(this.mediaStack == null)
         {
            return;
         }
         var _loc1_:int = this.mediaStack.length;
         var _loc2_:* = 0;
         while(_loc2_ < _loc1_)
         {
            _loc3_ = this.mediaStack[_loc2_];
            if(_loc3_)
            {
               _loc3_.destroy();
               _loc3_.removeEventListener(AutoLoaderEvent.LOAD_COMPLETE,this.onMediaComplete);
               _loc3_.removeEventListener(AutoLoaderEvent.LOAD_ERROR,this.onMediaError);
               _loc3_.removeEventListener(AutoLoaderEvent.LOAD_PROGRESS,this.onMediaStateChange);
               _loc3_.removeEventListener(AutoLoaderEvent.LOAD_STATE_CHANGE,this.onMediaStateChange);
            }
            _loc2_++;
         }
         this.mediaStack = null;
         list = null;
      }
      
      override public function start(param1:Array) : void
      {
         super.start(param1);
         this.loopAll();
      }
      
      private function loopAll() : void
      {
         var _loc3_:IMedia = null;
         var _loc1_:int = list.length;
         if(this.mediaStack == null)
         {
            this.mediaStack = [];
         }
         var _loc2_:* = 0;
         while(_loc2_ < _loc1_)
         {
            _loc3_ = MediaFactory.createMedia(_loc2_,list[_loc2_]);
            if(_loc3_ != null)
            {
               this.mediaStack.push(_loc3_);
               _loc3_.addEventListener(AutoLoaderEvent.LOAD_COMPLETE,this.onMediaComplete);
               _loc3_.addEventListener(AutoLoaderEvent.LOAD_ERROR,this.onMediaError);
               _loc3_.addEventListener(AutoLoaderEvent.LOAD_PROGRESS,this.onMediaStateChange);
               _loc3_.addEventListener(AutoLoaderEvent.LOAD_STATE_CHANGE,this.onMediaStateChange);
               _loc3_.start();
            }
            _loc2_++;
         }
      }
      
      private function addNums() : void
      {
         var _loc1_:AutoLoaderEvent = null;
         this.count++;
         if(this.count >= list.length)
         {
            _loc1_ = new AutoLoaderEvent(AutoLoaderEvent.WHOLE_COMPLETE);
            _loc1_.dataProvider = this.mediaStack;
            if(list != null)
            {
               _loc1_.total = list.length;
            }
            dispatchEvent(_loc1_);
         }
      }
      
      private function onMediaComplete(param1:AutoLoaderEvent) : void
      {
         var _loc2_:AutoLoaderEvent = new AutoLoaderEvent(AutoLoaderEvent.LOAD_COMPLETE,param1.sourceType,param1.index,param1.retry);
         _loc2_.dataProvider = param1.dataProvider;
         if(list != null)
         {
            _loc2_.total = list.length;
         }
         dispatchEvent(_loc2_);
         this.addNums();
      }
      
      private function onMediaError(param1:AutoLoaderEvent) : void
      {
         var _loc2_:AutoLoaderEvent = new AutoLoaderEvent(AutoLoaderEvent.LOAD_ERROR,param1.sourceType,param1.index,param1.retry);
         _loc2_.dataProvider = param1.dataProvider;
         _loc2_.infoCode = param1.infoCode;
         _loc2_.errorCode = param1.errorCode;
         if(list != null)
         {
            _loc2_.total = list.length;
         }
         dispatchEvent(_loc2_);
         this.addNums();
      }
      
      private function onMediaStateChange(param1:AutoLoaderEvent) : void
      {
         var _loc3_:Object = null;
         var _loc2_:AutoLoaderEvent = new AutoLoaderEvent(param1.type,param1.sourceType,param1.index,param1.retry);
         if(param1.type == AutoLoaderEvent.LOAD_PROGRESS)
         {
            _loc3_ = {
               "percent":param1.dataProvider,
               "totalPercent":param1.dataProvider
            };
            _loc2_.dataProvider = _loc3_;
         }
         else
         {
            _loc2_.dataProvider = param1.dataProvider;
         }
         _loc2_.infoCode = param1.infoCode;
         _loc2_.errorCode = param1.errorCode;
         if(list != null)
         {
            _loc2_.total = list.length;
         }
         dispatchEvent(_loc2_);
      }
   }
}
