package cn.pplive.player.utils
{
   import flash.utils.ByteArray;
   import flash.net.URLVariables;
   
   public class Utils extends Object
   {
      
      public static var BASE64_KEY:String = "kioe257ds";
      
      private static const BASE64_CHARS:String = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=";
      
      public static const SERVER_KEY:String = "qqqqqww";
      
      public static const DELTA:uint = 2.654435769E9;
      
      public static var ChListId:String;
      
      public static var CatalogId:String;
      
      public static var cid:String;
      
      public function Utils()
      {
         super();
      }
      
      public static function constructKey(param1:Number) : String
      {
         var _loc2_:String = time2String(param1);
         var _loc3_:Array = _loc2_.split("");
         if(_loc3_.length < 16)
         {
            _loc2_ = add(_loc2_,16 - _loc3_.length);
         }
         var _loc4_:* = "";
         var _loc5_:String = Utils.SERVER_KEY;
         if(_loc5_.length < 16)
         {
            _loc5_ = add(_loc5_,16 - _loc5_.length);
         }
         _loc4_ = Utils.encrypt(_loc2_,_loc5_);
         _loc4_ = Utils.Str2Hex(_loc4_);
         return _loc4_;
      }
      
      public static function getkey(param1:String) : uint
      {
         var _loc5_:String = null;
         var _loc6_:uint = 0;
         var _loc7_:uint = 0;
         var _loc2_:Array = param1.split("");
         var _loc3_:uint = 0;
         var _loc4_:Number = 0;
         while(_loc4_ < _loc2_.length)
         {
            _loc5_ = _loc2_[_loc4_];
            _loc6_ = _loc5_.charCodeAt(0);
            _loc7_ = _loc6_ << _loc4_ % 4 * 8;
            _loc3_ = _loc3_ ^ _loc7_;
            _loc4_++;
         }
         return _loc3_;
      }
      
      public static function add(param1:String, param2:Number) : String
      {
         var _loc3_:Number = 0;
         while(_loc3_ < param2)
         {
            var param1:String = param1 + getCharFromAscii(0);
            _loc3_++;
         }
         return param1;
      }
      
      public static function time2String(param1:Number) : String
      {
         var _loc8_:* = NaN;
         var _loc2_:Array = new Array(8);
         var _loc3_:ByteArray = new ByteArray();
         var _loc4_:* = "0123456789abcdef";
         var _loc5_:Array = _loc4_.split("");
         var _loc6_:uint = 0;
         while(_loc6_ < 8)
         {
            _loc8_ = param1 >>> 28 - _loc6_ % 8 * 4 & 15;
            _loc2_[_loc6_] = _loc5_[_loc8_];
            _loc6_++;
         }
         var _loc7_:String = _loc2_.join("");
         return _loc7_;
      }
      
      public static function encrypt(param1:String, param2:String) : String
      {
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         var _loc7_:uint = 0;
         var _loc13_:uint = 0;
         var _loc14_:uint = 0;
         var _loc15_:uint = 0;
         var _loc16_:uint = 0;
         var _loc17_:uint = 0;
         var _loc18_:uint = 0;
         var _loc19_:uint = 0;
         var _loc20_:uint = 0;
         var _loc21_:uint = 0;
         var _loc22_:uint = 0;
         var _loc23_:uint = 0;
         var _loc24_:* = 0;
         var _loc25_:uint = 0;
         var _loc26_:uint = 0;
         var _loc27_:uint = 0;
         var _loc28_:uint = 0;
         var _loc29_:uint = 0;
         var _loc30_:uint = 0;
         var _loc31_:uint = 0;
         var _loc32_:uint = 0;
         var _loc33_:uint = 0;
         var _loc34_:uint = 0;
         var _loc35_:uint = 0;
         var _loc36_:uint = 0;
         var _loc37_:uint = 0;
         var _loc38_:uint = 0;
         var _loc39_:uint = 0;
         var _loc40_:uint = 0;
         var _loc41_:uint = 0;
         var _loc3_:* = 16;
         var _loc4_:uint = getkey(param2);
         var _loc8_:Array = param1.split("");
         var _loc9_:Array = param2.split("");
         var _loc10_:Number = _loc4_;
         _loc5_ = _loc10_ << 8 | _loc10_ >>> 24;
         _loc6_ = _loc10_ << 16 | _loc10_ >>> 16;
         _loc7_ = _loc10_ << 24 | _loc10_ >>> 8;
         var _loc11_:* = "";
         var _loc12_:uint = 0;
         while(_loc12_ + _loc3_ <= _loc8_.length)
         {
            _loc13_ = _loc8_[_loc12_].charCodeAt(0) << 0;
            _loc14_ = _loc8_[_loc12_ + 1].charCodeAt(0) << 8;
            _loc15_ = _loc8_[_loc12_ + 2].charCodeAt(0) << 16;
            _loc16_ = _loc8_[_loc12_ + 3].charCodeAt(0) << 24;
            _loc17_ = _loc8_[_loc12_ + 4].charCodeAt(0) << 0;
            _loc18_ = _loc8_[_loc12_ + 5].charCodeAt(0) << 8;
            _loc19_ = _loc8_[_loc12_ + 6].charCodeAt(0) << 16;
            _loc20_ = _loc8_[_loc12_ + 7].charCodeAt(0) << 24;
            _loc21_ = 0 | _loc13_ | _loc14_ | _loc15_ | _loc16_;
            _loc22_ = 0 | _loc17_ | _loc18_ | _loc19_ | _loc20_;
            _loc23_ = 0;
            _loc24_ = 0;
            while(_loc24_ < 32)
            {
               _loc23_ = _loc23_ + DELTA;
               _loc33_ = (_loc22_ << 4) + _loc4_;
               _loc34_ = _loc22_ + _loc23_;
               _loc35_ = (_loc22_ >>> 5) + _loc5_;
               _loc36_ = _loc33_ ^ _loc34_ ^ _loc35_;
               _loc21_ = _loc21_ + _loc36_;
               _loc37_ = (_loc21_ << 4) + _loc6_;
               _loc38_ = _loc21_ + _loc23_;
               _loc39_ = _loc21_ >>> 5;
               _loc40_ = _loc39_ + _loc7_;
               _loc41_ = _loc37_ ^ _loc38_ ^ _loc40_;
               _loc22_ = _loc22_ + _loc41_;
               _loc24_++;
            }
            _loc25_ = _loc21_ >>> 0 & 255;
            _loc26_ = _loc21_ >>> 8 & 255;
            _loc27_ = _loc21_ >>> 16 & 255;
            _loc28_ = _loc21_ >>> 24 & 255;
            _loc29_ = _loc22_ >>> 0 & 255;
            _loc30_ = _loc22_ >>> 8 & 255;
            _loc31_ = _loc22_ >>> 16 & 255;
            _loc32_ = _loc22_ >>> 24 & 255;
            _loc11_ = _loc11_ + getCharFromAscii(_loc21_ >>> 0 & 255);
            _loc11_ = _loc11_ + getCharFromAscii(_loc21_ >>> 8 & 255);
            _loc11_ = _loc11_ + getCharFromAscii(_loc21_ >>> 16 & 255);
            _loc11_ = _loc11_ + getCharFromAscii(_loc21_ >>> 24 & 255);
            _loc11_ = _loc11_ + getCharFromAscii(_loc22_ >>> 0 & 255);
            _loc11_ = _loc11_ + getCharFromAscii(_loc22_ >>> 8 & 255);
            _loc11_ = _loc11_ + getCharFromAscii(_loc22_ >>> 16 & 255);
            _loc11_ = _loc11_ + getCharFromAscii(_loc22_ >>> 24 & 255);
            _loc12_ = _loc12_ + _loc3_;
         }
         _loc11_ = _loc11_ + param1.substr(8,8);
         return _loc11_;
      }
      
      public static function getCharFromAscii(param1:uint) : String
      {
         return String.fromCharCode(param1);
      }
      
      public static function Str2Hex(param1:String) : String
      {
         var _loc7_:* = NaN;
         var _loc8_:* = NaN;
         var _loc2_:* = "0123456789abcdef";
         var _loc3_:Array = _loc2_.split("");
         var _loc4_:Array = param1.split("");
         var _loc5_:Array = new Array(2 * _loc4_.length + 1);
         var _loc6_:int = _loc4_.length;
         var _loc9_:* = 0;
         while(_loc9_ < _loc6_)
         {
            if(_loc9_ < 8)
            {
               _loc7_ = _loc4_[_loc9_].charCodeAt(0) & 15;
               _loc8_ = _loc4_[_loc9_].charCodeAt(0) >>> 4 & 15;
               _loc5_[2 * _loc9_] = _loc3_[_loc4_[_loc9_].charCodeAt(0) & 15];
               _loc5_[2 * _loc9_ + 1] = _loc3_[_loc4_[_loc9_].charCodeAt(0) >>> 4 & 15];
            }
            else
            {
               _loc5_[2 * _loc9_] = _loc3_[Math.floor(Math.random() * 15)];
               _loc5_[2 * _loc9_ + 1] = _loc3_[Math.floor(Math.random() * 15)];
            }
            _loc9_++;
         }
         return _loc5_.join("");
      }
      
      public static function playLink(param1:String = "") : String
      {
         var param1:String = param1.replace(new RegExp("pptv:\\/\\/([^\\/]+)\\.*"),"$1").replace(" ","+").replace("%20","+").replace("%2B","+");
         return param1;
      }
      
      public static function decodePlayLink(param1:String = "") : void
      {
         var _loc6_:Object = null;
         var param1:String = playLink(param1);
         var _loc2_:URLVariables = new URLVariables(decodeBase64(param1,"pplive"));
         var _loc3_:* = "-1";
         var _loc4_:* = "-1";
         var _loc5_:* = "0";
         for(_loc6_ in _loc2_)
         {
            switch(_loc6_.toString())
            {
               case "a":
                  _loc3_ = _loc2_[_loc6_].toString();
                  ChListId = _loc3_;
                  continue;
               case "b":
                  if(_loc2_[_loc6_].toString().length > 0)
                  {
                     CatalogId = _loc2_[_loc6_].toString();
                  }
                  else
                  {
                     CatalogId = "0";
                  }
                  continue;
               case "c":
                  _loc5_ = _loc2_[_loc6_].toString();
                  continue;
               case "d":
                  _loc4_ = _loc2_[_loc6_].toString();
                  continue;
               default:
                  continue;
            }
         }
         if(_loc5_ != "0")
         {
            ChListId = _loc4_;
         }
      }
      
      public static function decodeBase64(param1:String, param2:String = null) : String
      {
         if(!param2)
         {
            var param2:String = BASE64_KEY;
         }
         var _loc3_:ByteArray = new ByteArray();
         _loc3_ = decodeToByteArray(param1);
         _loc3_.position = 0;
         var _loc4_:ByteArray = new ByteArray();
         _loc4_.length = _loc3_.length;
         _loc4_.position = 0;
         var _loc5_:ByteArray = new ByteArray();
         _loc5_.writeUTFBytes(param2);
         _loc5_.position = 0;
         var _loc6_:Number = 0;
         while(_loc6_ < _loc3_.length)
         {
            _loc4_[_loc6_] = _loc3_[_loc6_] - _loc5_[_loc6_ % _loc5_.length];
            _loc6_++;
         }
         _loc4_.position = 0;
         return _loc4_.readUTFBytes(_loc4_.bytesAvailable);
      }
      
      public static function decodeToByteArray(param1:String) : ByteArray
      {
         var _loc6_:uint = 0;
         var _loc7_:uint = 0;
         var _loc2_:ByteArray = new ByteArray();
         var _loc3_:Array = new Array(4);
         var _loc4_:Array = new Array(3);
         var _loc5_:uint = 0;
         while(_loc5_ < param1.length)
         {
            _loc6_ = 0;
            while(_loc6_ < 4 && _loc5_ + _loc6_ < param1.length)
            {
               _loc3_[_loc6_] = BASE64_CHARS.indexOf(param1.charAt(_loc5_ + _loc6_));
               _loc6_++;
            }
            _loc4_[0] = (_loc3_[0] << 2) + ((_loc3_[1] & 48) >> 4);
            _loc4_[1] = ((_loc3_[1] & 15) << 4) + ((_loc3_[2] & 60) >> 2);
            _loc4_[2] = ((_loc3_[2] & 3) << 6) + _loc3_[3];
            _loc7_ = 0;
            while(_loc7_ < _loc4_.length)
            {
               if(_loc3_[_loc7_ + 1] == 64)
               {
                  break;
               }
               _loc2_.writeByte(_loc4_[_loc7_]);
               _loc7_++;
            }
            _loc5_ = _loc5_ + 4;
         }
         _loc2_.position = 0;
         return _loc2_;
      }
   }
}
