package com.alex.utils
{
   public class ID extends Object
   {
      
      public function ID()
      {
         super();
      }
      
      public static function createGUID() : String
      {
         return GUID.create();
      }
   }
}
