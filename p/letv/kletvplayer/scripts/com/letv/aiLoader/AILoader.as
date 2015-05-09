package com.letv.aiLoader
{
   import flash.events.EventDispatcher;
   import com.letv.aiLoader.kernel.IKernel;
   import com.letv.aiLoader.events.AILoaderEvent;
   import com.letv.aiLoader.tools.GC;
   import com.letv.aiLoader.type.LoadOrderType;
   
   public class AILoader extends EventDispatcher implements IAILoader
   {
      
      public static const VERSION:String = "1.0.0";
      
      protected var kernel:IKernel;
      
      private var _loadOrderType:String = "loadSingle";
      
      public function AILoader(param1:String = "loadSingle")
      {
         super();
         if(!(param1 == LoadOrderType.LOAD_SINGLE) && !(param1 == LoadOrderType.LOAD_MULTIPLE))
         {
            var param1:String = LoadOrderType.LOAD_SINGLE;
         }
         this._loadOrderType = param1;
      }
      
      public function get loadOrderType() : String
      {
         return this._loadOrderType;
      }
      
      public function destroy() : void
      {
         if(this.kernel)
         {
            this.kernel.destroy();
            this.kernel.removeEventListener(AILoaderEvent.WHOLE_COMPLETE,this.onAllComplete);
            this.kernel.removeEventListener(AILoaderEvent.LOAD_COMPLETE,this.onLoadComplete);
            this.kernel.removeEventListener(AILoaderEvent.LOAD_ERROR,this.onLoadError);
            this.kernel.removeEventListener(AILoaderEvent.LOAD_PROGRESS,this.onMediaStateChange);
            this.kernel.removeEventListener(AILoaderEvent.LOAD_STATE_CHANGE,this.onMediaStateChange);
         }
         this.kernel = null;
         GC.gc();
      }
      
      public function setup(param1:Array) : void
      {
         this.kernel = KernelFactory.create(this.loadOrderType);
         this.kernel.addEventListener(AILoaderEvent.WHOLE_COMPLETE,this.onAllComplete);
         this.kernel.addEventListener(AILoaderEvent.LOAD_COMPLETE,this.onLoadComplete);
         this.kernel.addEventListener(AILoaderEvent.LOAD_ERROR,this.onLoadError);
         this.kernel.addEventListener(AILoaderEvent.LOAD_PROGRESS,this.onMediaStateChange);
         this.kernel.addEventListener(AILoaderEvent.LOAD_STATE_CHANGE,this.onMediaStateChange);
         this.kernel.start(param1);
      }
      
      private function onAllComplete(param1:AILoaderEvent) : void
      {
         var _loc2_:AILoaderEvent = new AILoaderEvent(AILoaderEvent.WHOLE_COMPLETE);
         _loc2_.dataProvider = param1.dataProvider;
         dispatchEvent(_loc2_);
      }
      
      private function onLoadComplete(param1:AILoaderEvent) : void
      {
         var _loc2_:AILoaderEvent = new AILoaderEvent(AILoaderEvent.LOAD_COMPLETE,param1.sourceType,param1.index,param1.retry);
         _loc2_.dataProvider = param1.dataProvider;
         dispatchEvent(_loc2_);
      }
      
      private function onLoadError(param1:AILoaderEvent) : void
      {
         var _loc2_:AILoaderEvent = new AILoaderEvent(AILoaderEvent.LOAD_ERROR,param1.sourceType,param1.index,param1.retry);
         _loc2_.dataProvider = param1.dataProvider;
         _loc2_.errorCode = param1.errorCode;
         _loc2_.infoCode = param1.infoCode;
         dispatchEvent(_loc2_);
      }
      
      private function onMediaStateChange(param1:AILoaderEvent) : void
      {
         var _loc2_:AILoaderEvent = new AILoaderEvent(param1.type,param1.sourceType,param1.index,param1.retry);
         _loc2_.dataProvider = param1.dataProvider;
         _loc2_.infoCode = param1.infoCode;
         _loc2_.errorCode = param1.errorCode;
         dispatchEvent(_loc2_);
      }
   }
}
