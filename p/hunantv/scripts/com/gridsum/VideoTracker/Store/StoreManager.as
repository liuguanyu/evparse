package com.gridsum.VideoTracker.Store
{
   import com.gridsum.Debug.TextTracer;
   
   class StoreManager extends Object
   {
      
      private var _storeArray:Array;
      
      function StoreManager()
      {
         this._storeArray = new Array();
         super();
      }
      
      public function addConcreteStorage(param1:IVideoTrackerStore) : void
      {
         if(param1 != null)
         {
            this._storeArray.push(param1);
         }
         else
         {
            TextTracer.writeLine("Warning: the parameter \'storage\' of StoreManager.addConcreteStorage is null, which is unexpected.");
         }
      }
      
      public function addOrSetValue(param1:String, param2:Object) : void
      {
         var key:String = param1;
         var value:Object = param2;
         if(this._storeArray.length == 0)
         {
            throw new Error("No concrete store referred in StoreManager.");
         }
         else
         {
            var succeedCount:int = 0;
            var i:int = 0;
            while(i < this._storeArray.length)
            {
               try
               {
                  this._storeArray[i].addOrSetValue(key,value);
                  succeedCount++;
               }
               catch(err:Error)
               {
                  TextTracer.writeLine("Warning: " + err.message);
               }
               i++;
            }
            if(succeedCount == 0)
            {
               throw new Error("All storages failed while saving. The key-value pair <" + key + " = " + value + "> is not stored.");
            }
            else
            {
               return;
            }
         }
      }
      
      public function getValue(param1:String) : Object
      {
         var key:String = param1;
         if(this._storeArray.length == 0)
         {
            throw new Error("No concrete store referred in StoreManager.");
         }
         else
         {
            var value:Object = null;
            var hasAvailableValue:Boolean = false;
            var i:int = 0;
            while(i < this._storeArray.length)
            {
               try
               {
                  value = this._storeArray[i].getValue(key);
                  if(value != null)
                  {
                     return value;
                  }
                  hasAvailableValue = true;
               }
               catch(err:Error)
               {
                  TextTracer.writeLine("Warning: " + err.message);
               }
               i++;
            }
            if(!hasAvailableValue)
            {
               throw new Error("All storages failed while fetching the value of the key <" + key + ">.");
            }
            else
            {
               return null;
            }
         }
      }
   }
}
