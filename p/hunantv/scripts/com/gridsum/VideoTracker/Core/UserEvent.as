package com.gridsum.VideoTracker.Core
{
   class UserEvent extends Object
   {
      
      private var _action:String = "-";
      
      private var _category:String = "-";
      
      private var _label:String = "-";
      
      public var value:int = 0;
      
      function UserEvent()
      {
         super();
      }
      
      public function get action() : String
      {
         return this._action;
      }
      
      public function set action(param1:String) : void
      {
         if(param1 == null || param1 == "")
         {
            var param1:* = "-";
         }
         else
         {
            this._action = param1.replace(new RegExp("[!~]","g"),"-");
         }
      }
      
      public function get category() : String
      {
         return this._category;
      }
      
      public function set category(param1:String) : void
      {
         if(param1 == null || param1 == "")
         {
            var param1:* = "-";
         }
         else
         {
            this._category = param1.replace(new RegExp("[!~]","g"),"-");
         }
      }
      
      public function get label() : String
      {
         return this._label;
      }
      
      public function set label(param1:String) : void
      {
         if(param1 == null || param1 == "")
         {
            var param1:* = "-";
         }
         else
         {
            this._label = param1.replace(new RegExp("[!~]","g"),"-");
         }
      }
      
      public function get type() : int
      {
         return 0;
      }
      
      public function get duration() : Number
      {
         return 0;
      }
      
      public function getKey() : String
      {
         var _loc1_:String = this.action + "!" + this.category + "!" + this.label + "!" + this.value + "!" + this.type;
         return _loc1_;
      }
   }
}
