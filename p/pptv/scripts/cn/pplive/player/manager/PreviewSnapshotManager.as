package cn.pplive.player.manager
{
   import flash.events.IEventDispatcher;
   import flash.events.EventDispatcher;
   import cn.pplive.player.utils.loader.DisplayLoader;
   import cn.pplive.player.utils.PrintDebug;
   import flash.events.Event;
   
   public class PreviewSnapshotManager extends Object implements IEventDispatcher
   {
      
      private static var $instance:PreviewSnapshotManager = null;
      
      private static var $isSingleton:Boolean = false;
      
      private static var $dispatcher:EventDispatcher;
      
      public static const PREVIEW_SNAPSHOT:String = "preview_snapshot";
      
      private static var $dataObj:Object;
      
      private static var $requestArr:Array = [];
      
      private static var $isRequest:Boolean = false;
      
      private static var $lo:DisplayLoader;
      
      public function PreviewSnapshotManager()
      {
         super();
         if(!$isSingleton)
         {
            throw new Error("只能用 getInstance() 来获取实例......");
         }
         else
         {
            $dispatcher = new EventDispatcher(this);
            return;
         }
      }
      
      public static function getInstance() : PreviewSnapshotManager
      {
         if($instance == null)
         {
            $isSingleton = true;
            $instance = new PreviewSnapshotManager();
            $isSingleton = false;
         }
         return $instance;
      }
      
      public function dispose() : void
      {
         if($lo)
         {
            $lo.clear();
            $lo = null;
         }
         $requestArr = [];
         $isRequest = false;
         $dataObj = null;
      }
      
      public function loadData(param1:String, param2:Object = null) : void
      {
         var _loc3_:* = undefined;
         if($requestArr.length > 0)
         {
            for each(_loc3_ in $requestArr)
            {
               if(_loc3_["url"] == param1)
               {
                  return;
               }
            }
         }
         $requestArr.unshift({
            "url":param1,
            "snapshot":param2
         });
         this.execute();
      }
      
      private function execute() : void
      {
         if(!$isRequest && $requestArr.length > 0)
         {
            this.load($requestArr[0]);
         }
      }
      
      private function load(param1:Object) : void
      {
         $isRequest = true;
         $dataObj = {};
         $dataObj["snapshot"] = param1["snapshot"];
         PrintDebug.Trace("预览大图请求地址  ===>>>  " + param1["url"],", 请求时间点  ===>>> ",param1["snapshot"]["posi"]);
         $lo = new DisplayLoader(param1["url"],10);
         $lo.addEventListener("_complete_",this.onTargetHandler);
         $lo.addEventListener("_ioerror_",this.onTargetHandler);
         $lo.addEventListener("_securityerror_",this.onTargetHandler);
         $lo.addEventListener("_timeout_",this.onTargetHandler);
      }
      
      private function onTargetHandler(param1:Event) : void
      {
         var _loc2_:* = undefined;
         if($requestArr.length > 0)
         {
            for each(_loc2_ in $requestArr)
            {
               if(_loc2_["url"] == param1.target.url)
               {
                  $requestArr.splice($requestArr.indexOf(_loc2_),1);
                  PrintDebug.Trace("请求结束后，删除请求队列中的相关元素  ===>>>");
                  break;
               }
            }
         }
         switch(param1.type)
         {
            case "_ioerror_":
            case "_securityerror_":
            case "_timeout_":
               param1.target.clear();
               PrintDebug.Trace("预览截图请求错误 | 超时  ===>>>  ",param1.toString());
               break;
            case "_complete_":
               $dataObj["content"] = param1.target.content;
               this.dispatchEvent(new Event(PreviewSnapshotManager.PREVIEW_SNAPSHOT));
               break;
         }
         $isRequest = false;
         this.execute();
      }
      
      public function get dataObj() : Object
      {
         return $dataObj;
      }
      
      public function addEventListener(param1:String, param2:Function, param3:Boolean = false, param4:int = 0, param5:Boolean = false) : void
      {
         $dispatcher.addEventListener(param1,param2,param3,param4,param5);
      }
      
      public function dispatchEvent(param1:Event) : Boolean
      {
         return $dispatcher.dispatchEvent(param1);
      }
      
      public function hasEventListener(param1:String) : Boolean
      {
         return $dispatcher.hasEventListener(param1);
      }
      
      public function removeEventListener(param1:String, param2:Function, param3:Boolean = false) : void
      {
         $dispatcher.removeEventListener(param1,param2,param3);
      }
      
      public function willTrigger(param1:String) : Boolean
      {
         return $dispatcher.willTrigger(param1);
      }
   }
}
