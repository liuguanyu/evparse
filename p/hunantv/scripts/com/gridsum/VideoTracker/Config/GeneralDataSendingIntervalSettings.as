package com.gridsum.VideoTracker.Config
{
   import flash.utils.Dictionary;
   
   class GeneralDataSendingIntervalSettings extends Object
   {
      
      private var _settings:Dictionary = null;
      
      function GeneralDataSendingIntervalSettings()
      {
         super();
         this._settings = new Dictionary();
         this.AddSetting(30,5);
         this.AddSetting(60,10);
         this.AddSetting(150,15);
         this.AddSetting(300,20);
         this.AddSetting(600,30);
         this.AddSetting(900,60);
      }
      
      public function AddSetting(param1:Number, param2:Number) : void
      {
         if(param1 <= 0 && param2 <= 0)
         {
            throw new RangeError();
         }
         else
         {
            this._settings[param1] = param2;
            return;
         }
      }
      
      public function RemoveSetting(param1:Number) : void
      {
         if(this._settings.hasOwnProperty(param1))
         {
            delete this._settings[param1];
            true;
         }
      }
      
      public function GetSendingInterval(param1:Number) : Number
      {
         if(param1 < 0)
         {
            throw new RangeError("videoDurationSeconds must be bigger than 0.");
         }
         else
         {
            var _loc2_:Array = this.getSortedKeyArray();
            var _loc3_:uint = _loc2_.length;
            var _loc4_:uint = 0;
            while(_loc4_ < _loc3_)
            {
               if(param1 <= _loc2_[_loc4_])
               {
                  return this._settings[_loc2_[_loc4_]];
               }
               _loc4_++;
            }
            return this._settings[_loc2_[_loc3_ - 1]];
         }
      }
      
      public function getSortedKeyArray(param1:Boolean = true) : Array
      {
         var _loc3_:Object = null;
         var _loc2_:Array = new Array();
         for(_loc3_ in this._settings)
         {
            _loc2_.push(_loc3_);
         }
         if(param1)
         {
            _loc2_.sort(Array.NUMERIC);
         }
         else
         {
            _loc2_.sort(Array.NUMERIC | Array.DESCENDING);
         }
         return _loc2_;
      }
      
      public function get Settings() : Dictionary
      {
         return this._settings;
      }
   }
}
