package com.hurlant.crypto.prng
{
   import flash.utils.ByteArray;
   import com.hurlant.crypto.hash.HMAC;
   import flash.utils.IDataOutput;
   import com.hurlant.util.Memory;
   import com.hurlant.crypto.hash.MD5;
   import com.hurlant.crypto.hash.SHA1;
   
   public class TLSPRF extends Object
   {
      
      private var seed:ByteArray;
      
      private var s1:ByteArray;
      
      private var s2:ByteArray;
      
      private var a1:ByteArray;
      
      private var a2:ByteArray;
      
      private var p1:ByteArray;
      
      private var p2:ByteArray;
      
      private var d1:ByteArray;
      
      private var d2:ByteArray;
      
      private var hmac_md5:HMAC;
      
      private var hmac_sha1:HMAC;
      
      public function TLSPRF(param1:ByteArray, param2:String, param3:ByteArray)
      {
         super();
         var _loc4_:int = Math.ceil(param1.length / 2);
         var _loc5_:ByteArray = new ByteArray();
         var _loc6_:ByteArray = new ByteArray();
         _loc5_.writeBytes(param1,0,_loc4_);
         _loc6_.writeBytes(param1,param1.length - _loc4_,_loc4_);
         var _loc7_:ByteArray = new ByteArray();
         _loc7_.writeUTFBytes(param2);
         _loc7_.writeBytes(param3);
         this.seed = _loc7_;
         this.s1 = _loc5_;
         this.s2 = _loc6_;
         this.hmac_md5 = new HMAC(new MD5());
         this.hmac_sha1 = new HMAC(new SHA1());
         this.a1 = this.hmac_md5.compute(_loc5_,this.seed);
         this.a2 = this.hmac_sha1.compute(_loc6_,this.seed);
         this.p1 = new ByteArray();
         this.p2 = new ByteArray();
         this.d1 = new ByteArray();
         this.d2 = new ByteArray();
         this.d1.position = MD5.HASH_SIZE;
         this.d1.writeBytes(this.seed);
         this.d2.position = SHA1.HASH_SIZE;
         this.d2.writeBytes(this.seed);
      }
      
      public function nextBytes(param1:IDataOutput, param2:int) : void
      {
         while(param2--)
         {
            param1.writeByte(this.nextByte());
         }
      }
      
      public function nextByte() : int
      {
         if(this.p1.bytesAvailable == 0)
         {
            this.more_md5();
         }
         if(this.p2.bytesAvailable == 0)
         {
            this.more_sha1();
         }
         return this.p1.readUnsignedByte() ^ this.p2.readUnsignedByte();
      }
      
      public function dispose() : void
      {
         this.seed = this.dba(this.seed);
         this.s1 = this.dba(this.s1);
         this.s2 = this.dba(this.s2);
         this.a1 = this.dba(this.a1);
         this.a2 = this.dba(this.a2);
         this.p1 = this.dba(this.p1);
         this.p2 = this.dba(this.p2);
         this.d1 = this.dba(this.d1);
         this.d2 = this.dba(this.d2);
         this.hmac_md5.dispose();
         this.hmac_md5 = null;
         this.hmac_sha1.dispose();
         this.hmac_sha1 = null;
         Memory.gc();
      }
      
      public function toString() : String
      {
         return "tls-prf";
      }
      
      private function dba(param1:ByteArray) : ByteArray
      {
         var _loc2_:uint = 0;
         while(_loc2_ < param1.length)
         {
            param1[_loc2_] = 0;
            _loc2_++;
         }
         param1.length = 0;
         return null;
      }
      
      private function more_md5() : void
      {
         this.d1.position = 0;
         this.d1.writeBytes(this.a1);
         var _loc1_:int = this.p1.position;
         var _loc2_:ByteArray = this.hmac_md5.compute(this.s1,this.d1);
         this.a1 = this.hmac_md5.compute(this.s1,this.a1);
         this.p1.writeBytes(_loc2_);
         this.p1.position = _loc1_;
      }
      
      private function more_sha1() : void
      {
         this.d2.position = 0;
         this.d2.writeBytes(this.a2);
         var _loc1_:int = this.p2.position;
         var _loc2_:ByteArray = this.hmac_sha1.compute(this.s2,this.d2);
         this.a2 = this.hmac_sha1.compute(this.s2,this.a2);
         this.p2.writeBytes(_loc2_);
         this.p2.position = _loc1_;
      }
   }
}
