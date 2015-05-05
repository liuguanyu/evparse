package com.pplive.dac.logclient
{
   import flash.utils.ByteArray;
   
   class Base64LogUrlGenerator extends LogUrlGenerator
   {
      
      function Base64LogUrlGenerator(param1:DataLogSource)
      {
         super(param1);
      }
      
      override public function getLogUrl(param1:Vector.<DataLogItem>, param2:Vector.<DataLogItem>) : String
      {
         var _loc3_:* = "";
         if(param1 != null)
         {
            _loc3_ = super.appendUrlParam(_loc3_,param1);
         }
         if(param2 != null)
         {
            _loc3_ = super.appendUrlParam(_loc3_,param2);
         }
         if(_loc3_.length > 0 && _loc3_.charAt(_loc3_.length - 1) == "&")
         {
            _loc3_ = _loc3_.substring(0,_loc3_.length - 1);
         }
         var _loc4_:String = this.encodeUrlParams(_loc3_);
         return this.getLogSource().getBaseUrl() + _loc4_;
      }
      
      public function encodeUrlParams(param1:String) : String
      {
         var _loc2_:SimpleEncrypt = new SimpleEncrypt(this.getLogSource().getKeyBytes());
         var _loc3_:ByteArray = _loc2_.Encrypt(param1);
         var _loc4_:String = Base64.Encode(_loc3_);
         return _loc4_;
      }
   }
}
