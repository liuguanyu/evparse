package com.letv.plugins.kernel.utils
{
   public class DataUtil extends Object
   {
      
      public function DataUtil()
      {
         super();
      }
      
      public static function cdnString(param1:Array) : String
      {
         var location:String = null;
         var i:int = 0;
         var arr:Array = param1;
         var value:String = "";
         try
         {
            i = 0;
            while(i < arr.length)
            {
               location = arr[i];
               if(location != null)
               {
                  location = location.split("?")[0];
                  if(i == 0)
                  {
                     value = value + location;
                  }
                  else
                  {
                     location = location.split("/")[2];
                     value = value + ("_" + location);
                  }
               }
               i++;
            }
         }
         catch(e:Error)
         {
            value = "-";
         }
         return value;
      }
   }
}
