package at.matthew.httpstreaming
{
   import flash.utils.ByteArray;
   
   public class HTTPStreamingH264NALU extends Object
   {
      
      private var data:ByteArray;
      
      public function HTTPStreamingH264NALU(param1:ByteArray)
      {
         super();
         this.data = param1;
      }
      
      public function get NALtype() : uint
      {
         return this.data[0] & 31;
      }
      
      public function get length() : uint
      {
         return this.data.length;
      }
      
      public function get NALdata() : ByteArray
      {
         return this.data;
      }
   }
}
