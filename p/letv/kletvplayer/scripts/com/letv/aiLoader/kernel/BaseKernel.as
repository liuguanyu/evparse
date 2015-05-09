package com.letv.aiLoader.kernel
{
   import flash.events.EventDispatcher;
   import com.letv.aiLoader.errors.AIError;
   import com.letv.aiLoader.media.AIDataFactory;
   
   public class BaseKernel extends EventDispatcher implements IKernel
   {
      
      protected var list:Array;
      
      public function BaseKernel()
      {
         super();
      }
      
      public function destroy() : void
      {
      }
      
      public function start(param1:Array) : void
      {
         if(param1 == null || param1.length <= 0)
         {
            throw new AIError("加载器所需描述信息不完整1");
         }
         else
         {
            this.list = AIDataFactory.transformData(param1);
            if(this.list == null || this.list.length <= 0)
            {
               throw new AIError("加载器所需描述信息不完整2");
            }
            else
            {
               return;
            }
         }
      }
   }
}
