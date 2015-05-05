package com.pplive.dac.logclient
{
   public class DataLogItem extends Object
   {
      
      public var Name:String;
      
      public var Value:String;
      
      public function DataLogItem(param1:String, param2:String)
      {
         super();
         this.Name = param1;
         this.Value = param2;
      }
   }
}
