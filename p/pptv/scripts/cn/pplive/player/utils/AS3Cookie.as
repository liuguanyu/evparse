package cn.pplive.player.utils
{
   import flash.utils.Proxy;
   import flash.net.SharedObject;
   import flash.utils.flash_proxy;
   
   public dynamic class AS3Cookie extends Proxy
   {
      
      private var _expires:uint;
      
      private var _name:String;
      
      private var _so:SharedObject;
      
      private var _isClear:Boolean;
      
      private var _isOften:Boolean = true;
      
      public function AS3Cookie(param1:String, param2:Boolean = false, param3:uint = 24)
      {
         super();
         this._name = param1;
         this._isClear = param2;
         this._expires = Math.max(param3,1);
         this._so = SharedObject.getLocal(this._name,"/");
         this.removeTimeout();
      }
      
      override flash_proxy function getProperty(param1:*) : *
      {
         return this.getData(param1);
      }
      
      override flash_proxy function setProperty(param1:*, param2:*) : void
      {
         this.setData(param1,param2);
      }
      
      public function removeTimeout() : void
      {
         var _loc1_:String = null;
         var _loc2_:Object = null;
         var _loc3_:* = NaN;
         if(!this._isClear)
         {
            return;
         }
         for(_loc1_ in this._so.data)
         {
            if(this._so.data[_loc1_] is Object)
            {
               _loc2_ = this._so.data[_loc1_];
               if(!this.isNullOrUndefined(_loc2_["expires"]) && !this.isNullOrUndefined(_loc2_["value"]))
               {
                  _loc3_ = new Date().getTime();
                  if(Number(_loc2_["expires"]) > _loc3_)
                  {
                     continue;
                  }
               }
            }
            delete this._so.data[_loc1_];
            true;
         }
      }
      
      public function getData(param1:String) : *
      {
         var _loc2_:* = this._isClear?this._so.data[param1]["value"]:this._so.data[param1];
         return this.contains(param1)?_loc2_:null;
      }
      
      public function setData(param1:String, param2:*) : *
      {
         var _loc3_:* = this.getData(param1);
         if(this._isClear)
         {
            this._so.data[param1] = {
               "expires":new Date().getTime() + this._expires * 60 * 60 * 1000,
               "value":param2
            };
         }
         else
         {
            this._so.data[param1] = param2;
         }
         this.flush();
         return _loc3_;
      }
      
      public function remove(param1:String) : *
      {
         var _loc2_:* = this.getData(param1);
         if(_loc2_ != null)
         {
            delete this._so.data[param1];
            true;
            this.flush();
         }
         return _loc2_;
      }
      
      public function flush() : void
      {
         try
         {
            if(this._isOften)
            {
               this._so.flush();
            }
         }
         catch(evt:Error)
         {
         }
      }
      
      public function removeAll() : void
      {
         this._so.clear();
      }
      
      public function contains(param1:String) : Boolean
      {
         var _loc2_:* = undefined;
         var _loc3_:* = NaN;
         if(this._so.data.hasOwnProperty(param1))
         {
            if(this._so.data[param1] is Object)
            {
               _loc2_ = this._so.data[param1];
               if(this._isClear)
               {
                  if(!this.isNullOrUndefined(_loc2_["expires"]) && !this.isNullOrUndefined(_loc2_["value"]))
                  {
                     _loc3_ = new Date().getTime();
                     if(Number(_loc2_["expires"]) > _loc3_)
                     {
                        return true;
                     }
                  }
               }
               else
               {
                  return !this.isNullOrUndefined(_loc2_);
               }
            }
            delete this._so.data[param1];
            true;
            this.flush();
         }
         return false;
      }
      
      public function isNullOrUndefined(param1:*) : Boolean
      {
         return param1 == undefined || param1 == null;
      }
      
      public function get name() : String
      {
         return this._name;
      }
      
      public function get expires() : uint
      {
         return this._expires;
      }
      
      public function get isOften() : Boolean
      {
         return this._isOften;
      }
      
      public function set isOften(param1:Boolean) : void
      {
         this._isOften = param1;
      }
   }
}
