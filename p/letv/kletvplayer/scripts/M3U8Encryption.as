package
{
   import flash.utils.ByteArray;
   
   public class M3U8Encryption extends Object implements IM3U8Encryption
   {
      
      private static var _instance:M3U8Encryption;
      
      public function M3U8Encryption()
      {
         super();
      }
      
      public static function getInstance() : M3U8Encryption
      {
         if(!_instance)
         {
            _instance = new M3U8Encryption();
         }
         return _instance;
      }
      
      public function decodeB2T(param1:ByteArray) : String
      {
         var a:ByteArray = null;
         var version:String = null;
         var b:ByteArray = param1;
         if(!b && !b.length)
         {
            return "";
         }
         try
         {
            a = new ByteArray();
            b.position = 0;
            b.readBytes(a,0,5);
            version = a.readUTFBytes(a.length);
            switch(version.toLowerCase())
            {
               case "vc_01":
                  return this.decodeBytesV1(b);
               default:
                  return this.decodeBytes(b);
            }
         }
         catch(e:Error)
         {
         }
         return "";
      }
      
      private function decodeBytes(param1:ByteArray) : String
      {
         param1.position = 0;
         var _loc2_:String = param1.readUTFBytes(param1.length);
         return _loc2_;
      }
      
      private function decodeBytesV1(param1:ByteArray) : String
      {
         var _loc4_:ByteArray = null;
         var _loc2_:ByteArray = new ByteArray();
         param1.position = 5;
         param1.readBytes(_loc2_);
         var _loc3_:int = _loc2_.length;
         _loc4_ = new ByteArray();
         var _loc5_:* = 0;
         while(_loc5_ < _loc3_)
         {
            _loc4_[2 * _loc5_] = _loc2_[_loc5_] >> 4;
            _loc4_[2 * _loc5_ + 1] = _loc2_[_loc5_] & 15;
            _loc5_++;
         }
         var _loc6_:ByteArray = new ByteArray();
         _loc4_.position = _loc4_.length - 11;
         _loc4_.readBytes(_loc6_);
         _loc4_.position = 0;
         _loc4_.readBytes(_loc6_,11,_loc4_.length - 11);
         var _loc7_:ByteArray = new ByteArray();
         _loc5_ = 0;
         while(_loc5_ < _loc3_)
         {
            _loc7_[_loc5_] = (_loc6_[2 * _loc5_] << 4) + _loc6_[2 * _loc5_ + 1];
            _loc5_++;
         }
         _loc7_.position = 0;
         var _loc8_:String = _loc7_.readUTFBytes(_loc7_.length);
         return _loc8_;
      }
   }
}
