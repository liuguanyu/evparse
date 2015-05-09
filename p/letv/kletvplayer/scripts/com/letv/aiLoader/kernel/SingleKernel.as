package com.letv.aiLoader.kernel
{
   import com.letv.aiLoader.media.IMedia;
   import com.letv.aiLoader.events.AILoaderEvent;
   import com.letv.aiLoader.errors.AIError;
   import com.letv.aiLoader.media.AIDataFactory;
   
   public class SingleKernel extends BaseKernel
   {
      
      private var currentIndex:int = -1;
      
      private var media:IMedia;
      
      private var mediaStack:Array;
      
      public function SingleKernel()
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
         this.loop();
      }
      
      private function loop() : void
      {
         var _loc1_:AILoaderEvent = null;
         this.currentIndex++;
         if(list == null)
         {
            return;
         }
         if(this.currentIndex == list.length)
         {
            _loc1_ = new AILoaderEvent(AILoaderEvent.WHOLE_COMPLETE);
            _loc1_.dataProvider = this.mediaStack;
            dispatchEvent(_loc1_);
            return;
         }
         if(list[this.currentIndex] == null)
         {
            throw new AIError("加载器所需描述信息单元为空,资源长度：" + list.length);
         }
         else
         {
            this.media = AIDataFactory.createMedia(this.currentIndex,list[this.currentIndex]);
            if(this.media == null)
            {
               this.loop();
            }
            if(this.mediaStack == null)
            {
               this.mediaStack = [];
            }
            this.mediaStack.push(this.media);
            this.media.addEventListener(AILoaderEvent.LOAD_COMPLETE,this.onMediaComplete);
            this.media.addEventListener(AILoaderEvent.LOAD_ERROR,this.onMediaError);
            this.media.addEventListener(AILoaderEvent.LOAD_PROGRESS,this.onMediaStateChange);
            this.media.addEventListener(AILoaderEvent.LOAD_STATE_CHANGE,this.onMediaStateChange);
            this.media.start();
            return;
         }
      }
      
      private function onMediaComplete(param1:AILoaderEvent) : void
      {
         var _loc2_:AILoaderEvent = new AILoaderEvent(AILoaderEvent.LOAD_COMPLETE,param1.sourceType,param1.index,param1.retry);
         _loc2_.dataProvider = param1.dataProvider;
         dispatchEvent(_loc2_);
         this.loop();
      }
      
      private function onMediaError(param1:AILoaderEvent) : void
      {
         var _loc2_:AILoaderEvent = new AILoaderEvent(AILoaderEvent.LOAD_ERROR,param1.sourceType,param1.index,param1.retry);
         _loc2_.dataProvider = param1.dataProvider;
         _loc2_.infoCode = param1.infoCode;
         _loc2_.errorCode = param1.errorCode;
         dispatchEvent(_loc2_);
         this.loop();
      }
      
      private function onMediaStateChange(param1:AILoaderEvent) : void
      {
         var _loc3_:* = NaN;
         var _loc4_:* = NaN;
         var _loc5_:Object = null;
         var _loc2_:AILoaderEvent = new AILoaderEvent(param1.type,param1.sourceType,param1.index,param1.retry);
         if(param1.type == AILoaderEvent.LOAD_PROGRESS)
         {
            _loc3_ = Number(param1.dataProvider);
            _loc4_ = (_loc3_ + param1.index) / list.length;
            _loc5_ = {
               "percent":param1.dataProvider,
               "totalPercent":_loc4_
            };
            _loc2_.dataProvider = _loc5_;
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
