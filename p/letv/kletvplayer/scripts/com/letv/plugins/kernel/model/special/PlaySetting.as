package com.letv.plugins.kernel.model.special
{
   import com.letv.plugins.kernel.interfaces.IClone;
   import flash.utils.getTimer;
   
   public class PlaySetting extends BaseClone implements IClone
   {
      
      private static var _instance:PlaySetting;
      
      public var swapDefinition:Boolean;
      
      public var autoReplay:Boolean;
      
      private var _lastBufferTime:int;
      
      private var _playDuration:Number = 360;
      
      public var limitData:LimitData;
      
      public function PlaySetting()
      {
         this.limitData = new LimitData();
         super();
      }
      
      public static function getInstance() : PlaySetting
      {
         if(_instance == null)
         {
            _instance = new PlaySetting();
         }
         return _instance;
      }
      
      public function get playDuration() : Number
      {
         return this._playDuration;
      }
      
      public function set playDuration(param1:Number) : void
      {
         if(isNaN(param1))
         {
            var param1:Number = 360;
         }
         else if(param1 < 60)
         {
            param1 = 360;
         }
         
         this._playDuration = param1;
      }
      
      public function set bufferedUtime(param1:int) : void
      {
         this._lastBufferTime = param1;
      }
      
      public function get bufferedUtime() : int
      {
         if(this._lastBufferTime > 0)
         {
            return getTimer() - this._lastBufferTime;
         }
         return int(200 + Math.random() * 800);
      }
      
      public function clone() : Object
      {
         return super.cloneByClass(PlaySetting,this);
      }
      
      public function setLimitData(param1:Object) : void
      {
         this.limitData.firstlook = param1.firstlook;
         this.limitData.login = param1.login;
         this.limitData.cutPC = param1.cutPC;
         this.limitData.cutoffPCTime = param1.cutoffPCTime;
      }
   }
}
