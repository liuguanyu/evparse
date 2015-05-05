package cn.pplive.player.view.source
{
   import flash.net.URLVariables;
   import cn.pplive.player.common.*;
   import cn.pplive.player.utils.PrintDebug;
   
   public class CTXQuery extends Object
   {
      
      public static var ctx:Object = {};
      
      private static var reg:RegExp = new RegExp("{[p|d|a|v|s]+}","g");
      
      public function CTXQuery()
      {
         super();
      }
      
      public static function setCTX(param1:String) : void
      {
         var _loc3_:String = null;
         var _loc4_:String = null;
         var _loc5_:Array = null;
         var _loc6_:* = 0;
         var _loc2_:URLVariables = new URLVariables(decodeURIComponent(param1));
         for(_loc3_ in _loc2_)
         {
            if(typeof _loc2_[_loc3_] == "string")
            {
               _loc4_ = _loc2_[_loc3_];
            }
            if(typeof _loc2_[_loc3_] == "object" && (_loc2_[_loc3_].hasOwnProperty("length")))
            {
               _loc4_ = _loc2_[_loc3_][_loc2_[_loc3_].length - 1];
            }
            if(_loc4_.search(reg) != -1)
            {
               _loc5_ = _loc4_.match(reg).toString().replace("{","").replace("}","").split("|");
               _loc6_ = 0;
               while(_loc6_ < _loc5_.length)
               {
                  if(ctx[_loc5_[_loc6_]] == undefined)
                  {
                     ctx[_loc5_[_loc6_]] = {};
                  }
                  ctx[_loc5_[_loc6_]][_loc3_] = _loc4_.replace(reg,"");
                  _loc6_++;
               }
            }
            else
            {
               if(ctx["c"] == undefined)
               {
                  ctx["c"] = {};
               }
               ctx["c"][_loc3_] = _loc4_;
            }
            PrintDebug.Trace("ctx字段中包含 " + _loc3_ + " 字段，value值 ： " + _loc2_[_loc3_] + " ......");
         }
      }
      
      private static function getCTX(param1:Object, param2:String) : String
      {
         var _loc4_:String = null;
         var _loc3_:* = "";
         if(param1[param2])
         {
            for(_loc4_ in param1[param2])
            {
               if(_loc4_ != "isVip")
               {
                  _loc3_ = _loc3_ + ((_loc3_ != ""?"&":"") + _loc4_ + "=" + encodeURIComponent(param1[param2][_loc4_]));
                  if(_loc4_ == "type" && (VIPPrivilege.isVip) && param1[param2][_loc4_].indexOf("vip") == -1)
                  {
                     _loc3_ = _loc3_ + ".vip";
                  }
               }
            }
         }
         return _loc3_;
      }
      
      public static function get pctx() : String
      {
         return getCTX(ctx,"p");
      }
      
      public static function get dctx() : String
      {
         return getCTX(ctx,"d");
      }
      
      public static function get actx() : String
      {
         return getCTX(ctx,"a");
      }
      
      public static function get vctx() : String
      {
         return getCTX(ctx,"v");
      }
      
      public static function get cctx() : String
      {
         return getCTX(ctx,"c");
      }
      
      public static function contain(param1:String) : Boolean
      {
         return Boolean(getAttr(param1));
      }
      
      public static function getAttr(param1:String) : String
      {
         var _loc2_:String = null;
         var _loc3_:String = null;
         for(_loc2_ in ctx)
         {
            for(_loc3_ in ctx[_loc2_])
            {
               if(_loc3_ == param1)
               {
                  return ctx[_loc2_][_loc3_];
               }
            }
         }
         return null;
      }
      
      public static function setAttr(param1:String, param2:String) : void
      {
         if(ctx["c"] == undefined)
         {
            ctx["c"] = {};
         }
         ctx["c"][param1] = param2;
      }
   }
}
