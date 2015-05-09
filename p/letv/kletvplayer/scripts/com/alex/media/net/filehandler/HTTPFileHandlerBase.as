package com.alex.media.net.filehandler
{
   import com.alex.media.log.BaseLog;
   
   public class HTTPFileHandlerBase extends BaseLog
   {
      
      protected var _httpCode:int = -1;
      
      protected var _errorCode:int = -1;
      
      public function HTTPFileHandlerBase()
      {
         super();
      }
      
      public function clearCode() : void
      {
         this._httpCode = -1;
         this._errorCode = -1;
      }
      
      public function get httpCode() : int
      {
         return this._httpCode;
      }
      
      public function get errorCode() : int
      {
         return this._errorCode;
      }
      
      public function get result() : Object
      {
         return null;
      }
      
      public function setQueue(param1:Array) : void
      {
      }
      
      public function start(param1:Object) : void
      {
      }
      
      public function destroy() : void
      {
      }
   }
}
