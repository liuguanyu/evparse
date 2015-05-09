package com.letv.aiLoader.media
{
   import com.letv.aiLoader.type.ResourceType;
   
   public class AIDataFactory extends Object
   {
      
      private static var pool:Object;
      
      public function AIDataFactory()
      {
         super();
      }
      
      public static function transformData(param1:Array) : Array
      {
         var _loc5_:Object = null;
         if(pool == null)
         {
            pool = {};
            pool[ResourceType.TEXT] = 1;
            pool[ResourceType.FLASH] = 1;
            pool[ResourceType.BITMAP] = 1;
            pool[ResourceType.VIDEO] = 1;
            pool[ResourceType.BYTES] = 1;
            pool[ResourceType.BINARY] = 1;
            pool[ResourceType.ORIGINAL] = 1;
         }
         var _loc2_:Array = [];
         var _loc3_:int = param1.length;
         var _loc4_:* = 0;
         while(_loc4_ < _loc3_)
         {
            _loc5_ = param1[_loc4_];
            if(_loc5_ != null)
            {
               if(_loc5_.hasOwnProperty("type"))
               {
                  if(pool.hasOwnProperty(_loc5_.type))
                  {
                     if(!_loc5_.hasOwnProperty("url") || _loc5_.url == "")
                     {
                        _loc5_.url = null;
                     }
                     if(!_loc5_.hasOwnProperty("retryMax") || (isNaN(_loc5_.retryMax)) || int(_loc5_.retryMax) <= 0)
                     {
                        _loc5_.retryMax = 3;
                     }
                     if(!_loc5_.hasOwnProperty("retryDelayTime") || (isNaN(_loc5_.retryDelayTime)) || int(_loc5_.retryDelayTime) <= 0)
                     {
                        _loc5_.retryDelayTime = 3000;
                     }
                     if(!_loc5_.hasOwnProperty("first") || (isNaN(_loc5_.first)) || int(_loc5_.first) <= 1000)
                     {
                        _loc5_.first = 5000;
                     }
                     if(!_loc5_.hasOwnProperty("gap") || (isNaN(_loc5_.gap)))
                     {
                        _loc5_.gap = 1000;
                     }
                     _loc2_.push(_loc5_);
                  }
               }
            }
            _loc4_++;
         }
         return _loc2_;
      }
      
      public static function createMedia(param1:int, param2:Object) : IMedia
      {
         var _loc3_:IMedia = null;
         switch(param2.type)
         {
            case ResourceType.FLASH:
               _loc3_ = new FlashMedia(param1,param2);
               break;
            case ResourceType.TEXT:
               _loc3_ = new TextMedia(param1,param2);
               break;
            case ResourceType.VIDEO:
               _loc3_ = new VideoMedia(param1,param2);
               break;
            case ResourceType.BITMAP:
               _loc3_ = new BitmapMedia(param1,param2);
               break;
            case ResourceType.BYTES:
               _loc3_ = new BytesMedia(param1,param2);
               break;
            case ResourceType.BINARY:
               _loc3_ = new BinaryMedia(param1,param2);
               break;
            case ResourceType.ORIGINAL:
               _loc3_ = new OriginalMedia(param1,param2);
               break;
         }
         return _loc3_;
      }
   }
}
