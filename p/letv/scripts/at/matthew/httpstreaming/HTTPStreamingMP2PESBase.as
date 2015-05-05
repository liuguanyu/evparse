package at.matthew.httpstreaming
{
   import flash.utils.ByteArray;
   
   class HTTPStreamingMP2PESBase extends Object
   {
      
      protected var _timestamp:Number;
      
      protected var _compositionTime:Number;
      
      function HTTPStreamingMP2PESBase()
      {
         super();
      }
      
      public function processES(param1:Boolean, param2:ByteArray, param3:Boolean = false) : ByteArray
      {
         return null;
      }
   }
}
