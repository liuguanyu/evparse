package com.letv.aiLoader.tools
{
   import flash.net.LocalConnection;
   
   public class GC extends Object
   {
      
      public function GC()
      {
         super();
      }
      
      public static function gc() : void
      {
         try
         {
            new LocalConnection().connect("letv");
            new LocalConnection().connect("letv");
         }
         catch(e:Error)
         {
         }
      }
   }
}
