package com.alex.rpc
{
   import flash.events.EventDispatcher;
   import com.alex.rpc.interfaces.ILoader;
   import com.alex.rpc.events.AutoLoaderEvent;
   import com.alex.rpc.core.LoaderFactory;
   import com.alex.rpc.type.LoadOrderType;
   
   public class AutoLoader extends EventDispatcher
   {
      
      public static const VERSION:String = "2.0.1";
      
      protected var kernel:ILoader;
      
      private var _loadOrderType:String = "loadSingle";
      
      public function AutoLoader(param1:String = "loadSingle")
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
         if(this.kernel != null)
         {
            this.kernel.destroy();
            this.kernel.removeEventListener(AutoLoaderEvent.WHOLE_COMPLETE,this.onAllComplete);
            this.kernel.removeEventListener(AutoLoaderEvent.LOAD_COMPLETE,this.onLoadComplete);
            this.kernel.removeEventListener(AutoLoaderEvent.LOAD_ERROR,this.onLoadError);
            this.kernel.removeEventListener(AutoLoaderEvent.LOAD_PROGRESS,this.onMediaStateChange);
            this.kernel.removeEventListener(AutoLoaderEvent.LOAD_STATE_CHANGE,this.onMediaStateChange);
            this.kernel = null;
         }
      }
      
      public function setup(param1:Array) : void
      {
         this.kernel = LoaderFactory.create(this.loadOrderType);
         this.kernel.addEventListener(AutoLoaderEvent.WHOLE_COMPLETE,this.onAllComplete);
         this.kernel.addEventListener(AutoLoaderEvent.LOAD_COMPLETE,this.onLoadComplete);
         this.kernel.addEventListener(AutoLoaderEvent.LOAD_ERROR,this.onLoadError);
         this.kernel.addEventListener(AutoLoaderEvent.LOAD_PROGRESS,this.onMediaStateChange);
         this.kernel.addEventListener(AutoLoaderEvent.LOAD_STATE_CHANGE,this.onMediaStateChange);
         this.kernel.start(param1);
      }
      
      private function onAllComplete(param1:AutoLoaderEvent) : void
      {
         var _loc2_:AutoLoaderEvent = new AutoLoaderEvent(AutoLoaderEvent.WHOLE_COMPLETE);
         _loc2_.total = param1.total;
         _loc2_.dataProvider = param1.dataProvider;
         dispatchEvent(_loc2_);
      }
      
      private function onLoadComplete(param1:AutoLoaderEvent) : void
      {
         var _loc2_:AutoLoaderEvent = new AutoLoaderEvent(AutoLoaderEvent.LOAD_COMPLETE,param1.sourceType,param1.index,param1.retry);
         _loc2_.total = param1.total;
         _loc2_.dataProvider = param1.dataProvider;
         dispatchEvent(_loc2_);
      }
      
      private function onLoadError(param1:AutoLoaderEvent) : void
      {
         var _loc2_:AutoLoaderEvent = new AutoLoaderEvent(AutoLoaderEvent.LOAD_ERROR,param1.sourceType,param1.index,param1.retry);
         _loc2_.dataProvider = param1.dataProvider;
         _loc2_.errorCode = param1.errorCode;
         _loc2_.infoCode = param1.infoCode;
         _loc2_.total = param1.total;
         dispatchEvent(_loc2_);
      }
      
      private function onMediaStateChange(param1:AutoLoaderEvent) : void
      {
         var _loc2_:AutoLoaderEvent = new AutoLoaderEvent(param1.type,param1.sourceType,param1.index,param1.retry);
         _loc2_.dataProvider = param1.dataProvider;
         _loc2_.errorCode = param1.errorCode;
         _loc2_.infoCode = param1.infoCode;
         _loc2_.total = param1.total;
         dispatchEvent(_loc2_);
      }
   }
}
