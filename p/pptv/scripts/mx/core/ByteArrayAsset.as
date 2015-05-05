package mx.core
{
   import flash.utils.ByteArray;
   
   public class ByteArrayAsset extends ByteArray implements IFlexAsset
   {
      
      mx_internal  static const VERSION:String = "4.10.0.0";
      
      public function ByteArrayAsset()
      {
         super();
      }
   }
}
