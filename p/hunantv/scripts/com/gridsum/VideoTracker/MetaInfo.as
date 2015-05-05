package com.gridsum.VideoTracker
{
   public class MetaInfo extends Object
   {
      
      private var _bitRateKbps:int = 0;
      
      private var _isBitrateChangeable:Boolean = true;
      
      private var _framesPerSecond:int = 0;
      
      public function MetaInfo()
      {
         super();
      }
      
      public function get isBitrateChangeable() : Boolean
      {
         return this._isBitrateChangeable;
      }
      
      public function set isBitrateChangeable(param1:Boolean) : void
      {
         this._isBitrateChangeable = param1;
      }
      
      public function set bitrateKbps(param1:int) : void
      {
         this._bitRateKbps = param1;
      }
      
      public function get bitrateKbps() : int
      {
         return this._bitRateKbps;
      }
      
      public function get framesPerSecond() : int
      {
         return this._framesPerSecond;
      }
      
      public function set framesPerSecond(param1:int) : void
      {
         this._framesPerSecond = param1;
      }
   }
}
