package com.utl
{
   import com.*;
   
   public class Encrypt extends Object
   {
      
      public var md5Obj:Md5;
      
      public function Encrypt()
      {
         super();
         this.md5Obj = new Md5();
      }
      
      public function md5Encrypt(param1:String) : String
      {
         return this.md5Obj.hash(param1);
      }
      
      public function base64encode(param1:*) : *
      {
         var _loc5_:* = undefined;
         var _loc6_:* = undefined;
         var _loc7_:* = undefined;
         var _loc8_:* = undefined;
         var _loc9_:* = undefined;
         var _loc10_:* = undefined;
         var _loc11_:* = undefined;
         var _loc12_:* = undefined;
         var _loc2_:* = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=";
         var _loc3_:* = [];
         var _loc4_:* = 0;
         while(_loc4_ < param1.length)
         {
            _loc5_ = param1.charCodeAt(_loc4_++);
            _loc6_ = param1.charCodeAt(_loc4_++);
            _loc7_ = param1.charCodeAt(_loc4_++);
            _loc8_ = (_loc5_ << 16) + ((_loc6_ || 0) << 8) + (_loc7_ || 0);
            _loc9_ = (_loc8_ & 63 << 18) >> 18;
            _loc10_ = (_loc8_ & 63 << 12) >> 12;
            _loc11_ = isNaN(_loc6_)?64:(_loc8_ & 63 << 6) >> 6;
            _loc12_ = isNaN(_loc7_)?64:_loc8_ & 63;
            _loc3_[_loc3_.length] = _loc2_.charAt(_loc9_);
            _loc3_[_loc3_.length] = _loc2_.charAt(_loc10_);
            _loc3_[_loc3_.length] = _loc2_.charAt(_loc11_);
            _loc3_[_loc3_.length] = _loc2_.charAt(_loc12_);
         }
         return _loc3_.join("");
      }
      
      public function base64decode(param1:*) : *
      {
         var _loc6_:* = undefined;
         var _loc7_:* = undefined;
         var _loc8_:* = undefined;
         var _loc9_:* = undefined;
         var _loc10_:* = undefined;
         var _loc11_:* = undefined;
         var _loc12_:* = undefined;
         var _loc13_:* = undefined;
         var _loc2_:* = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=";
         var _loc3_:* = {
            "strlen":!(param1.length % 4 == 0),
            "chars":new RegExp("[^" + _loc2_ + "]").test(param1),
            "equals":new RegExp("=").test(param1) && (new RegExp("=[^=]").test(param1) || new RegExp("={3}").test(param1))
         };
         if((_loc3_.strlen) || (_loc3_.chars) || (_loc3_.equals))
         {
            return param1;
         }
         var _loc4_:* = [];
         var _loc5_:* = 0;
         while(_loc5_ < param1.length)
         {
            _loc6_ = _loc2_.indexOf(param1.charAt(_loc5_++));
            _loc7_ = _loc2_.indexOf(param1.charAt(_loc5_++));
            _loc8_ = _loc2_.indexOf(param1.charAt(_loc5_++));
            _loc9_ = _loc2_.indexOf(param1.charAt(_loc5_++));
            _loc10_ = (_loc6_ << 18) + (_loc7_ << 12) + ((_loc8_ & 63) << 6) + (_loc9_ & 63);
            _loc11_ = (_loc10_ & 255 << 16) >> 16;
            _loc12_ = _loc8_ == 64?-1:(_loc10_ & 255 << 8) >> 8;
            _loc13_ = _loc9_ == 64?-1:_loc10_ & 255;
            _loc4_[_loc4_.length] = String.fromCharCode(_loc11_);
            if(_loc12_ >= 0)
            {
               _loc4_[_loc4_.length] = String.fromCharCode(_loc12_);
            }
            if(_loc13_ >= 0)
            {
               _loc4_[_loc4_.length] = String.fromCharCode(_loc13_);
            }
         }
         return _loc4_.join("");
      }
      
      public function creatRandomCode(param1:Number) : String
      {
         var _loc2_:* = new Date();
         var _loc3_:String = Math.random().toString();
         _loc3_ = _loc3_ + _loc2_.getMinutes().toString();
         _loc3_ = _loc3_ + _loc2_.getSeconds().toString();
         _loc3_ = _loc3_ + _loc2_.getMilliseconds().toString();
         _loc3_ = _loc3_.replace(".","");
         if(_loc3_.length > param1 + 1)
         {
            _loc3_ = _loc3_.substr(1,param1);
         }
         else
         {
            _loc3_ = _loc3_.substr(1,_loc3_.length - 1);
         }
         return _loc3_;
      }
      
      public function createSecuritKeyCode(param1:String, param2:int) : String
      {
         if(param1.length > 16)
         {
            return "";
         }
         var _loc3_:String = this.creatRandomCode(16);
         var _loc4_:* = 0;
         _loc4_ = 0;
         while(_loc4_ < param2)
         {
            _loc3_ = _loc3_ + this.creatRandomCode(16);
            _loc4_++;
         }
         var _loc5_:int = parseInt(_loc3_.charAt(5)) + 1;
         var _loc6_:* = "";
         var _loc7_:* = "";
         var _loc8_:* = 0;
         var _loc9_:int = _loc5_;
         _loc4_ = 0;
         while(_loc4_ < param1.length && _loc9_ < _loc3_.length)
         {
            _loc7_ = _loc7_ + _loc3_.substring(_loc8_,_loc9_);
            _loc7_ = _loc7_ + param1.charAt(_loc4_);
            _loc8_ = _loc9_;
            _loc9_ = _loc9_ + 3;
            _loc5_ = _loc7_.length - 1;
            if(_loc5_ >= 10)
            {
               _loc6_ = _loc6_ + ("2" + _loc5_.toString());
            }
            else
            {
               _loc6_ = _loc6_ + ("1" + _loc5_.toString());
            }
            _loc4_++;
         }
         _loc9_ = _loc3_.length;
         _loc7_ = _loc7_ + _loc3_.substring(_loc8_,_loc9_);
         _loc5_ = _loc7_.length;
         if(_loc5_ >= 10)
         {
            _loc7_ = "2" + _loc5_.toString() + _loc7_;
         }
         else
         {
            _loc7_ = "1" + _loc5_.toString() + _loc7_;
         }
         _loc7_ = _loc7_ + _loc6_;
         return _loc7_;
      }
      
      public function createSecuritKey(param1:String) : String
      {
         var _loc2_:* = "";
         _loc2_ = this.createSecuritKeyCode(param1,2);
         if(_loc2_ != "")
         {
            _loc2_ = this.base64encode(_loc2_);
            _loc2_ = _loc2_.replace("/","^");
            _loc2_ = _loc2_.replace("/","^");
            _loc2_ = _loc2_.replace("/","^");
            _loc2_ = _loc2_.replace("=","-");
            _loc2_ = _loc2_.replace("=","-");
            _loc2_ = _loc2_.replace("=","-");
         }
         return _loc2_;
      }
      
      public function rpTBZF(param1:String) : String
      {
         var param1:String = param1.replace("-","=");
         param1 = param1.replace("-","=");
         param1 = param1.replace("-","=");
         param1 = param1.replace("^","/");
         param1 = param1.replace("^","/");
         param1 = param1.replace("^","/");
         return param1;
      }
      
      public function rpTBZF_Rstore(param1:String) : String
      {
         var param1:String = param1.replace("/","^");
         param1 = param1.replace("/","^");
         param1 = param1.replace("/","^");
         param1 = param1.replace("=","-");
         param1 = param1.replace("=","-");
         param1 = param1.replace("=","-");
         return param1;
      }
   }
}
