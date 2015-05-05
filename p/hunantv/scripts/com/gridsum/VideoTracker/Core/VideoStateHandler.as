package com.gridsum.VideoTracker.Core
{
   import com.gridsum.VideoTracker.GSVideoState;
   import flash.errors.IllegalOperationError;
   
   public class VideoStateHandler extends Object
   {
      
      protected var _playLogic:PlayLogic;
      
      protected var _isBeginCalled:Boolean = false;
      
      protected var _isEndCalled:Boolean = false;
      
      public function VideoStateHandler(param1:PlayLogic)
      {
         super();
         this._playLogic = param1;
      }
      
      public static function getInstance(param1:PlayLogic, param2:String) : VideoStateHandler
      {
         var _loc3_:VideoStateHandler = null;
         if(param2 == GSVideoState.BUFFERING)
         {
            _loc3_ = new BufferingVideoStateHandler(param1);
         }
         else if(param2 == GSVideoState.CONNECTION_ERROR)
         {
            _loc3_ = new ConnectionErrorVideoStateHandler(param1);
         }
         else if(param2 == GSVideoState.DISCONNECTED)
         {
            _loc3_ = new DisconnectedVideoStateHandler(param1);
         }
         else if(param2 == GSVideoState.LOADING)
         {
            _loc3_ = new LoadingVideoStateHandler(param1);
         }
         else if(param2 == GSVideoState.PAUSED)
         {
            _loc3_ = new PausedVideoStateHandler(param1);
         }
         else if(param2 == GSVideoState.PLAYING)
         {
            _loc3_ = new PlayingVideoStateHandler(param1);
         }
         else if(param2 == GSVideoState.SEEKING)
         {
            _loc3_ = new SeekingVideoStateHandler(param1);
         }
         else if(param2 == GSVideoState.REWINDING)
         {
            _loc3_ = new RewindingVideoStateHandler(param1);
         }
         else if(param2 == GSVideoState.STOPPED)
         {
            _loc3_ = new StoppedVideoStateHandler(param1);
         }
         else
         {
            _loc3_ = new InitialVideoStateHandler(param1);
         }
         
         
         
         
         
         
         
         
         return _loc3_;
      }
      
      public function beginHandle(param1:String) : void
      {
         if(this._isBeginCalled)
         {
            throw new IllegalOperationError("BeginHandle can only be called once.");
         }
         else
         {
            this._isBeginCalled = true;
            return;
         }
      }
      
      public function endHandle(param1:String) : void
      {
         if(!this._isBeginCalled)
         {
            throw new IllegalOperationError("EndHandle can only be called after BeginHandle is called.");
         }
         else if(this._isEndCalled)
         {
            throw new IllegalOperationError("EndHandle can only be called once.");
         }
         else
         {
            this._isEndCalled = true;
            return;
         }
         
      }
   }
}
