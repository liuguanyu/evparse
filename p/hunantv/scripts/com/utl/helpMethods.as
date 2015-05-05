package com.utl
{
   import fl.transitions.easing.*;
   import flash.events.IEventDispatcher;
   import flash.external.ExternalInterface;
   import flash.text.TextField;
   import com.parmParse;
   import fl.transitions.Tween;
   import flash.utils.ByteArray;
   
   public class helpMethods extends Object
   {
      
      public function helpMethods()
      {
         super();
      }
      
      public static function roundParseInt(param1:*) : *
      {
         var _loc3_:* = undefined;
         var _loc2_:* = param1.toString().split(".");
         if(_loc2_.length >= 2)
         {
            _loc3_ = _loc2_[1].substring(0,1);
            if(parseInt(_loc3_) >= 5)
            {
               param1++;
            }
         }
         return parseInt(param1);
      }
      
      public static function formattime(param1:*) : String
      {
         var _loc2_:* = "";
         var _loc3_:Number = Math.floor(param1 / 60);
         if(_loc3_ < 10)
         {
            _loc2_ = _loc2_ + "0";
         }
         _loc2_ = _loc2_ + (_loc3_ + ":");
         if(param1 % 60 < 10)
         {
            _loc2_ = _loc2_ + "0";
         }
         _loc2_ = _loc2_ + Math.floor(param1 % 60);
         return _loc2_;
      }
      
      public static function addMutiEventListener(param1:IEventDispatcher, param2:Function, ... rest) : void
      {
         var _loc4_:* = 0;
         while(_loc4_ < rest.length)
         {
            param1.addEventListener(rest[_loc4_],param2);
            _loc4_++;
         }
      }
      
      public static function removeMutiEventListener(param1:IEventDispatcher, param2:Function, ... rest) : void
      {
         var _loc4_:* = 0;
         while(_loc4_ < rest.length)
         {
            param1.removeEventListener(rest[_loc4_],param2);
            _loc4_++;
         }
      }
      
      public static function callPageJs(param1:String, param2:String = "", param3:String = "") : String
      {
         var _loc4_:* = "";
         try
         {
            if(ExternalInterface.available)
            {
               if(param2 == "")
               {
                  _loc4_ = ExternalInterface.call(param1);
               }
               else if(param3 == "")
               {
                  _loc4_ = ExternalInterface.call(param1,param2);
               }
               else
               {
                  _loc4_ = ExternalInterface.call(param1,param2,param3);
               }
               
            }
         }
         catch(e:*)
         {
         }
         return _loc4_;
      }
      
      public static function addPageJsCall(param1:String, param2:Function) : void
      {
         try
         {
            if(ExternalInterface.available)
            {
               ExternalInterface.addCallback(param1,param2);
            }
         }
         catch(e:*)
         {
         }
      }
      
      public static function SetLabelTextFormat(param1:TextField, param2:String) : *
      {
         param1.text = param2;
         param1.setTextFormat(parmParse.TFormat);
      }
      
      public static function ITweening(param1:Object, param2:String, param3:Number, param4:Number, param5:Number) : *
      {
         var _loc6_:Tween = new Tween(param1,param2,None.easeNone,param3,param4,param5,true);
      }
      
      public static function getByteLen(param1:String) : int
      {
         var _loc3_:ByteArray = null;
         var _loc2_:* = -1;
         if(param1 != null)
         {
            _loc3_ = new ByteArray();
            _loc3_.writeMultiByte(param1,"");
            _loc2_ = _loc3_.length;
         }
         return _loc2_;
      }
   }
}
