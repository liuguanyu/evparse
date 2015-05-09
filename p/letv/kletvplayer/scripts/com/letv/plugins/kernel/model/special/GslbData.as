package com.letv.plugins.kernel.model.special
{
   import com.letv.pluginsAPI.kernel.DefinitionType;
   import com.letv.plugins.kernel.Kernel;
   
   public class GslbData extends Object
   {
      
      public var cantest:Boolean;
      
      public var hadControl:Boolean;
      
      public var geo:String = "";
      
      public var desc:String = "";
      
      public var playlevel:int = 1;
      
      public var remote:String = "0.0.0.0";
      
      public var usep2p:Boolean;
      
      public var gslbp2pRate:int = 600;
      
      public var gone:Object;
      
      public var nodeID:String;
      
      public var everNodeID:String;
      
      public var everNodeSpeed:Number = 0;
      
      public var currentGslbUrl:String;
      
      private var _ra:String;
      
      private var _gslblist:Object;
      
      private var _urlist:Array;
      
      public function GslbData()
      {
         this._gslblist = {};
         this._urlist = [];
         super();
      }
      
      public function get gslblist() : Object
      {
         return this._gslblist;
      }
      
      public function set gslblist(param1:Object) : void
      {
         this._gslblist = param1;
         var _loc2_:* = "";
         var _loc3_:* = 0;
         var _loc4_:* = 0;
         while(_loc4_ < DefinitionType.STACK.length)
         {
            if(this.gslblist.hasOwnProperty(DefinitionType.STACK[_loc4_]))
            {
               _loc2_ = _loc2_ + (_loc3_ == 0?DefinitionType.STACK[_loc4_]:"_" + DefinitionType.STACK[_loc4_]);
               _loc3_++;
            }
            _loc4_++;
         }
         this._ra = _loc2_;
      }
      
      public function get urlist() : Array
      {
         return this._urlist;
      }
      
      public function set urlist(param1:Array) : void
      {
         var _loc2_:Object = null;
         var _loc4_:* = 0;
         this._urlist = param1;
         var _loc3_:* = 0;
         while(_loc3_ < param1.length)
         {
            _loc4_ = 0;
            while(_loc4_ < DefinitionType.STACK.length)
            {
               if(param1[_loc3_].hasOwnProperty(DefinitionType.STACK[_loc4_]))
               {
                  _loc2_ = param1[_loc3_][DefinitionType.STACK[_loc4_]];
                  Kernel.sendLog("[" + _loc3_ + "]" + " Definition:" + DefinitionType.STACK[_loc4_] + " gone:" + _loc2_.gone + " playlevel:" + _loc2_.playlevel + " location:" + _loc2_.location);
               }
               _loc4_++;
            }
            _loc3_++;
         }
      }
      
      public function set ra(param1:String) : void
      {
         this._ra = param1;
      }
      
      public function get ra() : String
      {
         return this._ra;
      }
   }
}
