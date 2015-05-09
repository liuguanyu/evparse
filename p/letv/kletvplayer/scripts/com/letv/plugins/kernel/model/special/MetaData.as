package com.letv.plugins.kernel.model.special
{
   import com.alex.utils.JSONUtil;
   
   public class MetaData extends Object
   {
      
      public var width:Number = 0;
      
      public var height:Number = 0;
      
      public var scale:Number = 1.333;
      
      public var duration:Number = 0;
      
      public var keyframes:Object;
      
      public var filesize:int;
      
      public function MetaData(param1:Object)
      {
         var item:String = null;
         var creatorInfo:Object = null;
         var info:Object = param1;
         super();
         for(item in info)
         {
            if(this.hasOwnProperty(item))
            {
               this[item] = info[item];
            }
         }
         if(!info.hasOwnProperty("width") || !info.hasOwnProperty("height"))
         {
            if(info.hasOwnProperty("creator"))
            {
               try
               {
                  creatorInfo = JSONUtil.decode(info.creator);
                  this.width = Number(creatorInfo.width);
                  this.height = Number(creatorInfo.height);
                  this.scale = this.width / this.height;
               }
               catch(e:Error)
               {
                  scale = -1;
               }
            }
         }
         else
         {
            this.scale = this.width / this.height;
         }
         if((isNaN(this.scale)) || this.scale <= 0)
         {
            this.width = 400;
            this.height = 300;
            this.scale = 1.333;
            return;
         }
      }
   }
}
