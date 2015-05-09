package com.alex.encrypt
{
   import flash.utils.ByteArray;
   import com.alex.encrypt.abc.DeCompress;
   
   public class ABCSwfEncrypt extends Object
   {
      
      public static const ZLIB:String = "CWS";
      
      public static const LZMA:String = "ZWS";
      
      public static const ABC:String = "ABC";
      
      public function ABCSwfEncrypt()
      {
         super();
      }
      
      public static function encode(param1:ByteArray) : ByteArray
      {
         var compressType:String = null;
         var version:int = 0;
         var fileLength:uint = 0;
         var body:ByteArray = null;
         var newSource:ByteArray = null;
         var i:int = 0;
         var source:ByteArray = param1;
         try
         {
            if(source.length < 8)
            {
               return null;
            }
            compressType = source.readUTFBytes(3);
            version = source.readByte();
            fileLength = source.readUnsignedInt();
            body = new ByteArray();
            source.readBytes(body);
            if(compressType == ABC)
            {
               source.position = 0;
               return source;
            }
            if(compressType == ZLIB)
            {
               body["uncompress"]();
               body["compress"]("lzma");
               newSource = new ByteArray();
               newSource.writeUTFBytes(ABC);
               newSource.length = body.length + 8;
               i = 3;
               while(i < 8)
               {
                  newSource[i] = source[i];
                  i++;
               }
               newSource.position = 8;
               newSource.writeBytes(body);
               return newSource;
            }
            return null;
         }
         catch(e:Error)
         {
            trace("[FlashLzma.encode Error]",e.message);
         }
         return null;
      }
      
      public static function decode(param1:ByteArray) : ByteArray
      {
         var compressType:String = null;
         var version:int = 0;
         var fileLength:uint = 0;
         var body:ByteArray = null;
         var newSource:ByteArray = null;
         var i:int = 0;
         var source:ByteArray = param1;
         try
         {
            if(source.length < 8)
            {
               return null;
            }
            compressType = source.readUTFBytes(3);
            version = source.readByte();
            fileLength = source.readUnsignedInt();
            body = new ByteArray();
            source.readBytes(body);
            if(compressType == LZMA)
            {
               source.position = 0;
               return DeCompress.decodeSWF(source);
            }
            if(compressType == ZLIB)
            {
               return source;
            }
            if(compressType == ABC)
            {
               body = DeCompress.decode(body);
               body["compress"]();
               newSource = new ByteArray();
               newSource.writeUTFBytes(ZLIB);
               newSource.length = body.length + 8;
               i = 3;
               while(i < 8)
               {
                  newSource[i] = source[i];
                  i++;
               }
               newSource.position = 8;
               newSource.writeBytes(body);
               return newSource;
            }
         }
         catch(e:Error)
         {
            trace("[FlashLzma.decode Error]",e.message);
         }
         return null;
      }
   }
}
