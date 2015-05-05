package cn.pplive.player.utils.hash
{
   import flash.utils.Proxy;
   import flash.utils.flash_proxy;
   
   public dynamic class Global extends Proxy
   {
      
      private static var instance:Global = null;
      
      private static var isSingleton:Boolean = false;
      
      private var _hashMap:HashMap;
      
      public function Global(param1:Boolean = true)
      {
         super();
         if(!Global.isSingleton)
         {
            throw new Error("只能用 getInstance() 来获取实例...");
         }
         else
         {
            this._hashMap = new HashMap(param1);
            return;
         }
      }
      
      public static function getInstance(param1:Boolean = true) : Global
      {
         if(Global.instance == null)
         {
            Global.isSingleton = true;
            Global.instance = new Global(param1);
            Global.isSingleton = false;
         }
         return Global.instance;
      }
      
      override flash_proxy function callProperty(param1:*, ... rest) : *
      {
         var _loc3_:Array = null;
         var _loc4_:* = NaN;
         var _loc5_:Array = null;
         var _loc6_:String = null;
         var _loc7_:String = null;
         var _loc8_:String = null;
         switch(param1.toString())
         {
            case "reset":
               this._hashMap.reset();
               break;
            case "clear":
               this._hashMap.deleteKey();
               break;
            case "length":
               return this._hashMap.length();
            case "toString":
               _loc3_ = [];
               for(_loc6_ in this._hashMap)
               {
                  if(this._hashMap[_loc6_] != null)
                  {
                     _loc3_.push(_loc6_ + "=" + this._hashMap[_loc6_]);
                  }
               }
               return _loc3_.join("&");
            case "sum":
               _loc4_ = 0;
               for(_loc7_ in this._hashMap)
               {
                  if(!isNaN(this._hashMap[_loc7_]))
                  {
                     _loc4_ = _loc4_ + Number(this._hashMap[_loc7_]);
                  }
               }
               return _loc4_;
            case "toArray":
               _loc5_ = [];
               for(_loc8_ in this._hashMap)
               {
                  if(this._hashMap[_loc8_] != null)
                  {
                     _loc5_.push("{\"" + _loc8_ + "\":" + this._hashMap[_loc8_] + "}");
                  }
               }
               return _loc5_;
            default:
               return this._hashMap.getValue(param1).apply(this._hashMap,rest);
         }
      }
      
      override flash_proxy function getProperty(param1:*) : *
      {
         return this._hashMap.getValue(param1);
      }
      
      override flash_proxy function setProperty(param1:*, param2:*) : void
      {
         this._hashMap.put(param1,param2);
      }
      
      override flash_proxy function hasProperty(param1:*) : Boolean
      {
         return this._hashMap.containsKey(param1);
      }
      
      override flash_proxy function deleteProperty(param1:*) : Boolean
      {
         delete this[this._hashMap.deleteKey(param1)];
         return true;
      }
   }
}
