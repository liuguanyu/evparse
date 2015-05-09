package com.as3.hls.es
{
   import flash.utils.ByteArray;
   
   class MP2PESBase extends Object
   {
      
      protected var _timestamp:Number;
      
      protected var _compositionTime:Number;
      
      function MP2PESBase()
      {
         super();
      }
      
      public function processES(param1:Boolean, param2:ByteArray, param3:Boolean = false) : ByteArray
      {
         return null;
      }
   }
}
