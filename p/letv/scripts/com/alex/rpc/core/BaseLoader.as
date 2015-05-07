package com.alex.rpc.core
{
   import flash.events.EventDispatcher;
   import com.alex.rpc.interfaces.ILoader;
   import com.alex.rpc.errors.AutoError;
   
   public class BaseLoader extends EventDispatcher implements ILoader
   {
      
      protected var list:Array;
      
      public function BaseLoader()
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
            throw new AutoError("加载器所需描述信息不完整1");
         }
         else
         {
            this.list = MediaFactory.transformData(param1);
            if(this.list == null || this.list.length <= 0)
            {
               throw new AutoError("加载器所需描述信息不完整2");
            }
            else
            {
               return;
            }
         }
      }
   }
}
