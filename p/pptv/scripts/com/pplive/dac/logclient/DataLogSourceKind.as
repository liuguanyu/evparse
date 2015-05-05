package com.pplive.dac.logclient
{
   public final class DataLogSourceKind extends Object
   {
      
      public static const Normal:DataLogSourceKind = new DataLogSourceKind("Normal");
      
      public static const RealtimeOnline:DataLogSourceKind = new DataLogSourceKind("RealtimeOnline");
      
      private var _name:String;
      
      public function DataLogSourceKind(param1:String)
      {
         super();
         this._name = param1;
      }
      
      public function getName() : String
      {
         return this._name;
      }
   }
}
