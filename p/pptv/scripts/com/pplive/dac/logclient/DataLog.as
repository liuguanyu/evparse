package com.pplive.dac.logclient
{
   import flash.net.sendToURL;
   import flash.net.URLRequest;
   import cn.pplive.player.utils.PrintDebug;
   
   public class DataLog extends Object
   {
      
      private var _logSource:DataLogSource;
      
      public function DataLog(param1:DataLogSource = null)
      {
         super();
         this._logSource = param1;
      }
      
      public function getDataLogSource() : DataLogSource
      {
         return this._logSource;
      }
      
      public function sendLogRequestAsync(param1:Vector.<DataLogItem>, param2:Vector.<DataLogItem>) : void
      {
         var _loc3_:String = this.getLogUrl(param1,param2);
         if(_loc3_)
         {
            sendToURL(new URLRequest(_loc3_));
         }
         PrintDebug.Trace("报文地址   >>>>>>>  " + _loc3_);
      }
      
      public function getLogUrl(param1:Vector.<DataLogItem>, param2:Vector.<DataLogItem>) : String
      {
         var _loc3_:LogUrlGenerator = this.CreateLogUrlGenerator();
         return _loc3_.getLogUrl(param1,param2);
      }
      
      private function CreateLogUrlGenerator() : LogUrlGenerator
      {
         if(this._logSource == DataLogSource.IKanVodApp || this._logSource == DataLogSource.IKanBehaApp)
         {
            return new Base64LogUrlGenerator(this._logSource);
         }
         if(this._logSource == DataLogSource.IKanOnlineApp)
         {
            return new RealtimeLogUrlGenerator(this._logSource);
         }
         return new Base64LogUrlGenerator(this._logSource);
      }
   }
}
