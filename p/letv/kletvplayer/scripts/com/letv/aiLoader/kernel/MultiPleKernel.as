package com.letv.aiLoader.kernel
{
   import com.letv.aiLoader.media.IMedia;
   import com.letv.aiLoader.events.AILoaderEvent;
   import com.letv.aiLoader.media.AIDataFactory;
   
   public class MultiPleKernel extends BaseKernel
   {
      
      private var mediaStack:Array;
      
      private var count:int;
      
      public function MultiPleKernel()
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
               _loc3_.removeEventListener(AILoaderEvent.LOAD_COMPLETE,this.onMediaComplete);
               _loc3_.removeEventListener(AILoaderEvent.LOAD_ERROR,this.onMediaError);
               _loc3_.removeEventListener(AILoaderEvent.LOAD_PROGRESS,this.onMediaStateChange);
               _loc3_.removeEventListener(AILoaderEvent.LOAD_STATE_CHANGE,this.onMediaStateChange);
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
            _loc3_ = AIDataFactory.createMedia(_loc2_,list[_loc2_]);
            if(_loc3_ != null)
            {
               this.mediaStack.push(_loc3_);
               _loc3_.addEventListener(AILoaderEvent.LOAD_COMPLETE,this.onMediaComplete);
               _loc3_.addEventListener(AILoaderEvent.LOAD_ERROR,this.onMediaError);
               _loc3_.addEventListener(AILoaderEvent.LOAD_PROGRESS,this.onMediaStateChange);
               _loc3_.addEventListener(AILoaderEvent.LOAD_STATE_CHANGE,this.onMediaStateChange);
               _loc3_.start();
            }
            _loc2_++;
         }
      }
      
      private function addNums() : void
      {
         var _loc1_:AILoaderEvent = null;
         this.count++;
         if(this.count >= list.length)
         {
            _loc1_ = new AILoaderEvent(AILoaderEvent.WHOLE_COMPLETE);
            _loc1_.dataProvider = this.mediaStack;
            dispatchEvent(_loc1_);
         }
      }
      
      private function onMediaComplete(param1:AILoaderEvent) : void
      {
         var _loc2_:AILoaderEvent = new AILoaderEvent(AILoaderEvent.LOAD_COMPLETE,param1.sourceType,param1.index,param1.retry);
         _loc2_.dataProvider = param1.dataProvider;
         dispatchEvent(_loc2_);
         this.addNums();
      }
      
      private function onMediaError(param1:AILoaderEvent) : void
      {
         var _loc2_:AILoaderEvent = new AILoaderEvent(AILoaderEvent.LOAD_ERROR,param1.sourceType,param1.index,param1.retry);
         _loc2_.dataProvider = param1.dataProvider;
         _loc2_.infoCode = param1.infoCode;
         _loc2_.errorCode = param1.errorCode;
         dispatchEvent(_loc2_);
         this.addNums();
      }
      
      private function onMediaStateChange(param1:AILoaderEvent) : void
      {
         var _loc3_:Object = null;
         var _loc2_:AILoaderEvent = new AILoaderEvent(param1.type,param1.sourceType,param1.index,param1.retry);
         if(param1.type == AILoaderEvent.LOAD_PROGRESS)
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
         dispatchEvent(_loc2_);
      }
   }
}
