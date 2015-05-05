package cn.pplive.player.utils.hash
{
   import flash.utils.Dictionary;
   
   public dynamic class HashMap extends Dictionary
   {
      
      public function HashMap(param1:Boolean = true)
      {
         super(param1);
      }
      
      public function put(param1:String, param2:*) : void
      {
         this[param1] = param2;
      }
      
      public function remove(param1:String) : void
      {
         this[param1] = null;
      }
      
      public function getKey(param1:*) : String
      {
         var _loc2_:String = null;
         for(_loc2_ in this)
         {
            if(this[_loc2_] == param1)
            {
               return _loc2_;
            }
         }
         return null;
      }
      
      public function getValue(param1:String) : *
      {
         if(!this.isNullOrUndefined(this[param1]))
         {
            return this[param1];
         }
         return null;
      }
      
      public function containsKey(param1:String) : Boolean
      {
         return this.isNullOrUndefined(this[param1]);
      }
      
      public function containsValue(param1:*) : Boolean
      {
         var _loc2_:String = null;
         for(_loc2_ in this)
         {
            if(this[_loc2_] == param1)
            {
               return true;
            }
         }
         return false;
      }
      
      public function length() : int
      {
         var _loc2_:String = null;
         var _loc1_:* = 0;
         for(_loc2_ in this)
         {
            if(!this.isNullOrUndefined(this[_loc2_]))
            {
               _loc1_++;
            }
         }
         return _loc1_;
      }
      
      public function reset() : void
      {
         var _loc1_:String = null;
         for(_loc1_ in this)
         {
            this[_loc1_] = null;
         }
      }
      
      public function deleteKey(param1:String = null) : void
      {
         var _loc2_:String = null;
         var _loc3_:String = null;
         if(param1 != null)
         {
            for(_loc2_ in this)
            {
               if(_loc2_ == param1)
               {
                  delete this[param1];
                  true;
                  break;
               }
            }
         }
         else
         {
            for(_loc3_ in this)
            {
               delete this[_loc3_];
               true;
            }
         }
      }
      
      private function isNullOrUndefined(param1:*) : Boolean
      {
         return param1 == undefined || param1 == null;
      }
   }
}
