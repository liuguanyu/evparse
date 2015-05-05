package com.gridsum.VideoTracker
{
   import com.gridsum.VideoTracker.Core.PlayLogic;
   import com.gridsum.VideoTracker.Util.UniqueIDGenerator;
   import com.gridsum.VideoTracker.Core.AdvStatusInfo;
   import com.gridsum.Debug.TextTracer;
   
   public class Play extends Object
   {
      
      private var _playID:String = null;
      
      private var _parentPlayID:String = null;
      
      private var _vdProfileID:String = null;
      
      private var _sdProfileID:String = null;
      
      private var _disposed:Boolean = false;
      
      protected var _playLogic:PlayLogic = null;
      
      public function Play(param1:String, param2:String, param3:String, param4:String, param5:VideoInfo, param6:PlayLogic)
      {
         super();
         TextTracer.writeLine("Create New Play:" + param1);
         if(param5 == null)
         {
            throw new RangeError("Parameter videoInfo should not be null.");
         }
         else
         {
            this._playID = param1;
            this._parentPlayID = param2;
            this._vdProfileID = param3;
            this._sdProfileID = param4;
            this._playLogic = param6;
            return;
         }
      }
      
      public function setVideoInfo(param1:VideoInfo) : void
      {
         this._playLogic.setVideoInfo(param1);
      }
      
      public function newVideoAdPlay(param1:VideoInfo, param2:IVodInfoProvider, param3:int) : VideoAdPlay
      {
         if(param1 == null)
         {
            throw new ArgumentError("NewVideoAdPlay\'s parameter:VideoInfo should not be null.");
         }
         else
         {
            var _loc4_:String = UniqueIDGenerator.Generate();
            var _loc5_:VideoAdPlay = new VideoAdPlay(_loc4_,this.PlayID,this._vdProfileID,this._sdProfileID,param1,param2);
            VideoTracker.getInstance(this._vdProfileID,this._sdProfileID).addPlay(_loc4_,_loc5_);
            var _loc6_:AdvStatusInfo = new AdvStatusInfo();
            _loc6_.advPlayID = _loc4_;
            _loc6_.videoInfo = param1;
            _loc6_.isFinished = false;
            this._playLogic.addAdvertismentInfo(_loc6_);
            return _loc5_;
         }
      }
      
      public function beginLoading() : void
      {
         if(!this._playLogic.IsVideoReady)
         {
            TextTracer.writeLine("BeginLoading");
            this._playLogic.beginLoading();
         }
      }
      
      public function generalEndLoading(param1:Boolean, param2:MetaInfo) : void
      {
         if(!this._playLogic.IsVideoReady)
         {
            TextTracer.writeLine("EndLoading");
            if(param1)
            {
               this._playLogic.setMetaData(param2);
               this._playLogic.openSuccess();
            }
            else
            {
               this._playLogic.openFailed();
            }
         }
      }
      
      public function setLoadingBeginTime(param1:Date) : void
      {
         this._playLogic.setLoadingBeginTime(param1);
      }
      
      public function setLoadingEndTime(param1:Date) : void
      {
         this._playLogic.setLoadingEndTime(param1);
      }
      
      public function get isVideoReady() : Boolean
      {
         return this._playLogic.IsVideoReady;
      }
      
      public function onStateChanged(param1:String) : void
      {
         this._playLogic.OnCurrentStateChanged(param1);
      }
      
      public function setPageUrl(param1:String) : void
      {
         this._playLogic.setPageUrl(param1);
      }
      
      public function setPageTitle(param1:String) : void
      {
         this._playLogic.setPageTitle(param1);
      }
      
      public function onBehavior(param1:String) : void
      {
         return this.trackEvent1(param1);
      }
      
      public function trackEvent1(param1:String) : void
      {
         this.trackEvent2(param1,1);
      }
      
      public function trackEvent2(param1:String, param2:int) : void
      {
         this.trackEvent3(param1,"-",param2);
      }
      
      public function trackEvent3(param1:String, param2:String, param3:int) : void
      {
         this.trackEvent(param1,param2,"-",param3);
      }
      
      public function trackEvent(param1:String, param2:String, param3:String, param4:int) : void
      {
         this._playLogic.trackEvent(param1,param2,param3,param4);
      }
      
      public function beginEvent1(param1:String) : int
      {
         return this.beginEvent2(param1,1);
      }
      
      public function beginEvent2(param1:String, param2:int) : int
      {
         return this.beginEvent3(param1,"-",param2);
      }
      
      public function beginEvent3(param1:String, param2:String, param3:int) : int
      {
         return this.beginEvent(param1,param2,"-",param3);
      }
      
      public function beginEvent(param1:String, param2:String, param3:String, param4:int) : int
      {
         return this._playLogic.beginEvent(param1,param2,param3,param4);
      }
      
      public function endEvent(param1:int) : void
      {
         this._playLogic.endEvent(param1);
      }
      
      public function onError(param1:String) : Boolean
      {
         return this._playLogic.onError(param1);
      }
      
      public function notifyChildPlayEnd(param1:String, param2:Boolean) : void
      {
         this._playLogic.notifyAdvEnd(param1,param2);
      }
      
      public function endPlay(param1:Boolean = true) : void
      {
         TextTracer.writeLine("End Play:" + this._playID);
         this._disposed = true;
         VideoTracker.getInstance(this._vdProfileID,this._sdProfileID).notifyPlayEnd(this._playID,this._parentPlayID,param1);
         this._playLogic.end(param1);
      }
      
      public function get isEnded() : Boolean
      {
         return this._disposed;
      }
      
      public function get PlayID() : String
      {
         return this._playID;
      }
   }
}
