package com.alex.utils
{
   import flash.net.URLVariables;
   import flash.utils.ByteArray;
   
   public class RichStringUtil extends Object
   {
      
      private static var CHINESE_MAX:Number = 40959;
      
      private static var CHINESE_MIN:Number = 19968;
      
      private static var LOWER_MAX:Number = 122;
      
      private static var LOWER_MIN:Number = 97;
      
      private static var NUMBER_MAX:Number = 57;
      
      private static var NUMBER_MIN:Number = 48;
      
      private static var UPPER_MAX:Number = 90;
      
      private static var UPPER_MIN:Number = 65;
      
      private static var NEW_LINE_REPLACER:String = String.fromCharCode(6);
      
      private static const ChineseNumberTable:Array = [38646,19968,20108,19977,22235,20116,20845,19971,20843,20061,21313];
      
      public static const LV1_Split:String = ",";
      
      public static const LV2_Split:String = ":";
      
      public function RichStringUtil()
      {
         super();
         throw new Error("StringUtil class is static container only");
      }
      
      public static function getUrlParams(param1:String) : Object
      {
         var markIndex:int = 0;
         var effectValue:String = null;
         var vars:URLVariables = null;
         var value:String = param1;
         try
         {
            markIndex = value.indexOf("?");
            if(markIndex != -1)
            {
               markIndex++;
               effectValue = value.substring(markIndex);
               vars = new URLVariables(effectValue);
               return vars;
            }
         }
         catch(e:Error)
         {
         }
         return null;
      }
      
      public static function equalsIgnoreCase(param1:String, param2:String) : Boolean
      {
         return param1.toLowerCase() == param2.toLowerCase();
      }
      
      public static function equals(param1:String, param2:String) : Boolean
      {
         return param1 == param2;
      }
      
      public static function isEmail(param1:String) : Boolean
      {
         if(param1 == null)
         {
            return false;
         }
         var param1:String = trim(param1);
         var _loc2_:RegExp = new RegExp("(\\w|[_.\\-])+@((\\w|-)+\\.)+\\w{2,4}+");
         var _loc3_:Object = _loc2_.exec(param1);
         if(_loc3_ == null)
         {
            return false;
         }
         return true;
      }
      
      public static function isNumber(param1:String) : Boolean
      {
         if(param1 == null)
         {
            return false;
         }
         return !isNaN(parseInt(param1));
      }
      
      public static function isDouble(param1:String) : Boolean
      {
         var param1:String = trim(param1);
         var _loc2_:RegExp = new RegExp("^[-\\+]?\\d+(\\.\\d+)?$");
         var _loc3_:Object = _loc2_.exec(param1);
         if(_loc3_ == null)
         {
            return false;
         }
         return true;
      }
      
      public static function isInteger(param1:String) : Boolean
      {
         if(param1 == null)
         {
            return false;
         }
         var param1:String = trim(param1);
         var _loc2_:RegExp = new RegExp("^[-\\+]?\\d+$");
         var _loc3_:Object = _loc2_.exec(param1);
         if(_loc3_ == null)
         {
            return false;
         }
         return true;
      }
      
      public static function isEnglish(param1:String) : Boolean
      {
         if(param1 == null)
         {
            return false;
         }
         var param1:String = trim(param1);
         var _loc2_:RegExp = new RegExp("^[A-Za-z]+$");
         var _loc3_:Object = _loc2_.exec(param1);
         if(_loc3_ == null)
         {
            return false;
         }
         return true;
      }
      
      public static function isChinese(param1:String) : Boolean
      {
         if(param1 == null)
         {
            return false;
         }
         var param1:String = trim(param1);
         var _loc2_:RegExp = new RegExp("^[Α-￥]+$");
         var _loc3_:Object = _loc2_.exec(param1);
         if(_loc3_ == null)
         {
            return false;
         }
         return true;
      }
      
      public static function isDoubleChar(param1:String) : Boolean
      {
         if(param1 == null)
         {
            return false;
         }
         var param1:String = trim(param1);
         var _loc2_:RegExp = new RegExp("^[^\\x00-\\xff]+$");
         var _loc3_:Object = _loc2_.exec(param1);
         if(_loc3_ == null)
         {
            return false;
         }
         return true;
      }
      
      public static function hasChineseChar(param1:String) : Boolean
      {
         if(param1 == null)
         {
            return false;
         }
         var param1:String = trim(param1);
         var _loc2_:RegExp = new RegExp("[^\\x00-\\xff]");
         var _loc3_:Object = _loc2_.exec(param1);
         if(_loc3_ == null)
         {
            return false;
         }
         return true;
      }
      
      public static function hasAccountChar(param1:String, param2:uint = 15) : Boolean
      {
         if(param1 == null)
         {
            return false;
         }
         if(param2 < 10)
         {
            var param2:uint = 15;
         }
         var param1:String = trim(param1);
         var _loc3_:RegExp = new RegExp("^[a-zA-Z0-9][a-zA-Z0-9_-]{0," + param2 + "}$","");
         var _loc4_:Object = _loc3_.exec(param1);
         if(_loc4_ == null)
         {
            return false;
         }
         return true;
      }
      
      public static function isURL(param1:String) : Boolean
      {
         if(param1 == null)
         {
            return false;
         }
         var param1:String = trim(param1).toLowerCase();
         var _loc2_:RegExp = new RegExp("^http:\\/\\/[A-Za-z0-9]+\\.[A-Za-z0-9]+[\\/=\\?%\\-&_~`@[\\]\\\':+!]*([^<>\\\"\\\"])*$");
         var _loc3_:Object = _loc2_.exec(param1);
         if(_loc3_ == null)
         {
            return false;
         }
         return true;
      }
      
      public static function isWhitespace(param1:String) : Boolean
      {
         switch(param1)
         {
            case " ":
            case "\t":
            case "\r":
            case "\n":
            case "\f":
               return true;
            default:
               return false;
         }
      }
      
      public static function trim(param1:String, param2:Boolean = false) : String
      {
         var param1:String = param1 || "";
         param1 = rtrim(ltrim(param1));
         if(param2)
         {
            if(param1 == "null" || param1 == "undefined")
            {
               param1 = "";
            }
         }
         return param1;
      }
      
      public static function ltrim(param1:String) : String
      {
         if(param1 == null)
         {
            return null;
         }
         var _loc2_:RegExp = new RegExp("^\\s*");
         return param1.replace(_loc2_,"");
      }
      
      public static function rtrim(param1:String) : String
      {
         if(param1 == null)
         {
            return null;
         }
         var _loc2_:RegExp = new RegExp("\\s*$");
         return param1.replace(_loc2_,"");
      }
      
      public static function beginsWith(param1:String, param2:String) : Boolean
      {
         return param2 == param1.substring(0,param2.length);
      }
      
      public static function endsWith(param1:String, param2:String) : Boolean
      {
         return param2 == param1.substring(param1.length - param2.length);
      }
      
      public static function remove(param1:String, param2:String) : String
      {
         if(param1 == null)
         {
            return null;
         }
         return replace(param1,param2,"");
      }
      
      public static function replace(param1:String, param2:String, param3:String) : String
      {
         return param1.split(param2).join(param3);
      }
      
      public static function utf16to8(param1:String) : String
      {
         var _loc5_:* = 0;
         var _loc2_:Array = new Array();
         var _loc3_:uint = param1.length;
         var _loc4_:uint = 0;
         while(_loc4_ < _loc3_)
         {
            _loc5_ = param1.charCodeAt(_loc4_);
            if(_loc5_ >= 1 && _loc5_ <= 127)
            {
               _loc2_[_loc4_] = param1.charAt(_loc4_);
            }
            else if(_loc5_ > 2047)
            {
               _loc2_[_loc4_] = String.fromCharCode(224 | _loc5_ >> 12 & 15,128 | _loc5_ >> 6 & 63,128 | _loc5_ >> 0 & 63);
            }
            else
            {
               _loc2_[_loc4_] = String.fromCharCode(192 | _loc5_ >> 6 & 31,128 | _loc5_ >> 0 & 63);
            }
            
            _loc4_++;
         }
         return _loc2_.join("");
      }
      
      public static function utf8to16(param1:String) : String
      {
         var _loc5_:* = 0;
         var _loc6_:* = 0;
         var _loc7_:* = 0;
         var _loc8_:* = 0;
         var _loc2_:Array = new Array();
         var _loc3_:uint = param1.length;
         var _loc4_:uint = 0;
         while(_loc4_ < _loc3_)
         {
            _loc5_ = param1.charCodeAt(_loc4_++);
            switch(_loc5_ >> 4)
            {
               case 0:
               case 1:
               case 2:
               case 3:
               case 4:
               case 5:
               case 6:
               case 7:
                  _loc2_[_loc2_.length] = param1.charAt(_loc4_ - 1);
                  continue;
               case 12:
               case 13:
                  _loc6_ = param1.charCodeAt(_loc4_++);
                  _loc2_[_loc2_.length] = String.fromCharCode((_loc5_ & 31) << 6 | _loc6_ & 63);
                  continue;
               case 14:
                  _loc7_ = param1.charCodeAt(_loc4_++);
                  _loc8_ = param1.charCodeAt(_loc4_++);
                  _loc2_[_loc2_.length] = String.fromCharCode((_loc5_ & 15) << 12 | (_loc7_ & 63) << 6 | (_loc8_ & 63) << 0);
                  continue;
               default:
                  continue;
            }
         }
         return _loc2_.join("");
      }
      
      public static function autoReturn(param1:String, param2:int) : String
      {
         var _loc3_:int = param1.length;
         if(_loc3_ < 0)
         {
            return "";
         }
         var _loc4_:int = param2;
         var _loc5_:String = param1.substr(0,_loc4_);
         while(_loc4_ <= _loc3_)
         {
            _loc5_ = _loc5_ + "\n";
            _loc5_ = _loc5_ + param1.substr(_loc4_,param2);
            _loc4_ = _loc4_ + param2;
         }
         return _loc5_;
      }
      
      public static function limitStringLengthByByteCount(param1:String, param2:int, param3:String = "...") : String
      {
         var _loc4_:* = 0;
         var _loc5_:* = 0;
         var _loc6_:String = null;
         var _loc7_:* = 0;
         var _loc8_:uint = 0;
         if(param1 == null || param1 == "")
         {
            return param1;
         }
         _loc4_ = param1.length;
         _loc5_ = 0;
         _loc6_ = "";
         _loc7_ = 0;
         while(_loc7_ < _loc4_)
         {
            _loc8_ = param1.charCodeAt(_loc7_);
            if(_loc8_ > 16777215)
            {
               _loc5_ = _loc5_ + 4;
            }
            else if(_loc8_ > 65535)
            {
               _loc5_ = _loc5_ + 3;
            }
            else if(_loc8_ > 255)
            {
               _loc5_ = _loc5_ + 2;
            }
            else
            {
               _loc5_++;
            }
            
            
            if(_loc5_ < param2)
            {
               _loc6_ = _loc6_ + param1.charAt(_loc7_);
               _loc7_++;
               continue;
            }
            if(_loc5_ == param2)
            {
               _loc6_ = _loc6_ + param1.charAt(_loc7_);
               _loc6_ = _loc6_ + param3;
               break;
            }
            _loc6_ = _loc6_ + param3;
            break;
         }
         return _loc6_;
      }
      
      public static function getCharsArray(param1:String, param2:Boolean) : Array
      {
         var _loc3_:String = param1;
         if(param2 == false)
         {
            _loc3_ = trim(param1);
         }
         return _loc3_.split("");
      }
      
      public static function getStringBytes(param1:String) : int
      {
         return getStrActualLen(param1);
      }
      
      public static function substrByByteLen(param1:String, param2:int) : String
      {
         var _loc6_:String = null;
         if(param1 == "" || param1 == null)
         {
            return param1;
         }
         var _loc3_:* = 0;
         var _loc4_:int = param1.length;
         var _loc5_:* = 0;
         while(_loc5_ < _loc4_)
         {
            _loc6_ = param1.charAt(_loc5_);
            _loc3_ = _loc3_ + getStrActualLen(_loc6_);
            if(_loc3_ > param2)
            {
               var param1:String = param1.substr(0,_loc5_ - 1);
               break;
            }
            _loc5_++;
         }
         return param1;
      }
      
      public static function getStringByteLength(param1:String) : int
      {
         if(param1 == null)
         {
            return 0;
         }
         var _loc2_:ByteArray = new ByteArray();
         _loc2_.writeUTFBytes(param1);
         return _loc2_.length;
      }
      
      public static function getStrActualLen(param1:String) : int
      {
         if(param1 == "" || param1 == null)
         {
            return 0;
         }
         return param1.replace(new RegExp("[^\\x00-\\xff]","g"),"xx").length;
      }
      
      public static function isEmptyString(param1:String) : Boolean
      {
         return param1 == null || param1 == "";
      }
      
      public static function isNewlineOrEnter(param1:uint) : Boolean
      {
         return param1 == 13 || param1 == 10;
      }
      
      public static function removeNewlineOrEnter(param1:String) : String
      {
         var param1:String = replace(param1,"\n","");
         return replace(param1,"\r","");
      }
      
      public static function escapeNewline(param1:String) : String
      {
         return replace(param1,"\n",NEW_LINE_REPLACER);
      }
      
      public static function unescapeNewline(param1:String) : String
      {
         return replace(param1,NEW_LINE_REPLACER,"\n");
      }
      
      public static function judge(param1:String) : String
      {
         var _loc2_:* = "";
         var _loc3_:* = false;
         var _loc4_:Number = 0;
         while(_loc4_ < param1.length)
         {
            if(escape(param1.substring(_loc4_,_loc4_ + 1)).length > 3)
            {
               _loc2_ = _loc2_ + ("\'" + param1.substring(_loc4_,_loc4_ + 1) + "\' ");
               _loc3_ = true;
            }
            _loc4_++;
         }
         if(_loc3_)
         {
         }
         return _loc2_;
      }
      
      public static function changeToBj(param1:String) : String
      {
         var _loc4_:String = null;
         var _loc5_:* = NaN;
         var _loc6_:String = null;
         if(param1 == null)
         {
            return null;
         }
         var _loc2_:* = "";
         var _loc3_:Number = 0;
         while(_loc3_ < param1.length)
         {
            if(escape(param1.substring(_loc3_,_loc3_ + 1)).length > 3)
            {
               _loc4_ = param1.substring(_loc3_,_loc3_ + 1);
               if(_loc4_.charCodeAt(0) > 60000)
               {
                  _loc5_ = _loc4_.charCodeAt(0) - 65248;
                  _loc6_ = String.fromCharCode(_loc5_);
                  _loc2_ = _loc2_ + _loc6_;
               }
               else if(_loc4_.charCodeAt(0) == 12288)
               {
                  _loc2_ = _loc2_ + " ";
               }
               else
               {
                  _loc2_ = _loc2_ + param1.substring(_loc3_,_loc3_ + 1);
               }
               
            }
            else
            {
               _loc2_ = _loc2_ + param1.substring(_loc3_,_loc3_ + 1);
            }
            _loc3_++;
         }
         return _loc2_;
      }
      
      public static function changeToQj(param1:String) : String
      {
         var _loc4_:String = null;
         var _loc5_:* = NaN;
         var _loc6_:String = null;
         if(param1 == null)
         {
            return null;
         }
         var _loc2_:* = "";
         var _loc3_:Number = 0;
         while(_loc3_ < param1.length)
         {
            if(escape(param1.substring(_loc3_,_loc3_ + 1)).length > 3)
            {
               _loc4_ = param1.substring(_loc3_,_loc3_ + 1);
               if(_loc4_.charCodeAt(0) > 60000)
               {
                  _loc5_ = _loc4_.charCodeAt(0) + 65248;
                  _loc6_ = String.fromCharCode(_loc5_);
                  _loc2_ = _loc2_ + _loc6_;
               }
               else
               {
                  _loc2_ = _loc2_ + param1.substring(_loc3_,_loc3_ + 1);
               }
            }
            else
            {
               _loc2_ = _loc2_ + param1.substring(_loc3_,_loc3_ + 1);
            }
            _loc3_++;
         }
         return _loc2_;
      }
      
      public static function renewZero(param1:String, param2:int) : String
      {
         var _loc5_:* = 0;
         var _loc3_:* = "";
         var _loc4_:int = param1.length;
         if(_loc4_ < param2)
         {
            _loc5_ = 0;
            while(_loc5_ < param2 - _loc4_)
            {
               _loc3_ = _loc3_ + "0";
               _loc5_++;
            }
            return _loc3_ + param1;
         }
         return param1;
      }
      
      public static function isUpToRegExp(param1:String, param2:RegExp) : Boolean
      {
         if(!(param1 == null) && !(param2 == null))
         {
            return !(param1.match(param2) == null);
         }
         return false;
      }
      
      public static function isErrorFormatString(param1:String, param2:int = 0) : Boolean
      {
         if(param1 == null || !(param2 == 0) && param1.length > param2)
         {
            return true;
         }
         return !(param1.indexOf(String.fromCharCode(0)) == -1);
      }
      
      public static function getFormatMoney(param1:Number) : String
      {
         var _loc2_:String = param1.toString();
         var _loc3_:Array = new Array();
         var _loc4_:Number = -1;
         while(_loc2_.charAt(_loc2_.length + _loc4_) != "")
         {
            if(Math.abs(_loc4_ - 2) >= _loc2_.length)
            {
               _loc3_.push(_loc2_.substr(0,_loc2_.length + _loc4_ + 1));
            }
            else
            {
               _loc3_.push(_loc2_.substr(_loc4_ - 2,3));
            }
            _loc4_ = _loc4_ - 3;
         }
         _loc3_.reverse();
         return _loc3_.join(",");
      }
      
      public static function uintToChineseNumber(param1:uint) : String
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         if(param1 <= 10)
         {
            return String.fromCharCode(ChineseNumberTable[param1]);
         }
         if(param1 < 20)
         {
            return String.fromCharCode(ChineseNumberTable[10],ChineseNumberTable[param1 - 10]);
         }
         if(param1 < 100)
         {
            _loc2_ = Math.floor(param1 / 10);
            _loc3_ = param1 % 10;
            if(_loc3_ > 0)
            {
               return String.fromCharCode(ChineseNumberTable[_loc2_],ChineseNumberTable[10],ChineseNumberTable[_loc3_]);
            }
            return String.fromCharCode(ChineseNumberTable[_loc2_],ChineseNumberTable[10]);
         }
         return "";
      }
      
      public static function format(param1:String, ... rest) : String
      {
         var args:Array = null;
         var strFormat:String = param1;
         var additionalArgs:Array = rest;
         args = additionalArgs;
         var reg:RegExp = new RegExp("\\{(\\d+)\\}","g");
         return strFormat.replace(reg,function(param1:String, param2:String, param3:int, param4:String):String
         {
            return args[param2];
         });
      }
      
      public static function lv1ParseString(param1:String, param2:Function) : Boolean
      {
         var _loc4_:String = null;
         if(param1 == null || param1 == "")
         {
            return false;
         }
         var _loc3_:* = false;
         for each(_loc4_ in param1.split(LV1_Split))
         {
            param2(_loc4_);
            _loc3_ = true;
         }
         return _loc3_;
      }
      
      public static function lv2ParseString(param1:String, param2:Function) : Boolean
      {
         var _loc4_:String = null;
         var _loc5_:Array = null;
         if(param1 == null || param1 == "")
         {
            return false;
         }
         var _loc3_:* = false;
         for each(_loc4_ in param1.split(LV2_Split))
         {
            if(!(_loc4_ == null) && _loc4_ == "")
            {
               _loc5_ = param1.split(LV1_Split);
               if(_loc5_.length > 1)
               {
                  param2(_loc5_);
                  _loc3_ = true;
               }
            }
         }
         return _loc3_;
      }
      
      public static function getLv1SplitString(param1:Array, param2:Function) : String
      {
         if(param1 == null || param1.length == 0)
         {
            return "";
         }
         var _loc3_:int = param1.length;
         var _loc4_:String = param2(param1[0]);
         var _loc5_:* = 1;
         while(_loc5_ < _loc3_)
         {
            _loc4_ = _loc4_ + LV1_Split;
            _loc4_ = _loc4_ + param2(param1[_loc5_]);
            _loc5_++;
         }
         return _loc4_;
      }
      
      public static function getLv2SplitString(param1:Array, param2:Function) : String
      {
         if(param1 == null || param1.length == 0)
         {
            return "";
         }
         var _loc3_:int = param1.length;
         var _loc4_:String = param2(param1[0],LV2_Split);
         var _loc5_:* = 1;
         while(_loc5_ < _loc3_)
         {
            _loc4_ = _loc4_ + LV1_Split;
            _loc4_ = _loc4_ + param2(param1[_loc5_],LV2_Split);
            _loc5_++;
         }
         return _loc4_;
      }
   }
}
