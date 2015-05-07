package com.alex.utils
{
   import flash.utils.getDefinitionByName;
   import com.adobe.serialization.json.JSON;
   
   public class JSONUtil extends Object
   {
      
      public function JSONUtil()
      {
         super();
      }
      
      public static function encode(param1:Object) : String
      {
         var value:Object = param1;
         try
         {
            return getDefinitionByName("JSON")["stringify"](value);
         }
         catch(e:Error)
         {
         }
         return com.adobe.serialization.json.JSON.encode(value);
      }
      
      public static function decode(param1:String) : Object
      {
         var value:String = param1;
         try
         {
            return getDefinitionByName("JSON")["parse"](value);
         }
         catch(e:Error)
         {
         }
         return com.adobe.serialization.json.JSON.decode(value);
      }
   }
}
