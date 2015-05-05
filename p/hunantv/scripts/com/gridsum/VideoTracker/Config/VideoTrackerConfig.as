package com.gridsum.VideoTracker.Config
{
   import com.gridsum.Debug.TextTracer;
   import com.gridsum.VideoTracker.Util.UniqueIDGenerator;
   
   public class VideoTrackerConfig extends Object
   {
      
      private static var _generalDataSendingSettings:GeneralDataSendingIntervalSettings = new GeneralDataSendingIntervalSettings();
      
      private static const SAMPLING_BASE:int = 1000;
      
      private static var _version:String = "2.0.0.1";
      
      private static var _samplingRate:Number = 1;
      
      private static var _clipViewedThreasholdRate:Number = 0.2;
      
      private static var _bounceThreasholdRate:Number = 0.2;
      
      private static var _bounceThreasholdTime:int = 60;
      
      private static var _destinationAddresses:Array = ["http://recv-vd.gridsumdissector.com/gs.gif","http://recv-vd.gridsumdissector.cn/gs.gif"];
      
      private static var _recentLength:Number = 5;
      
      private static var _loadingTimeoutForSD:Number = 15 * 1000;
      
      private static var _loadingTimeoutForVD:Number = 30 * 1000;
      
      public function VideoTrackerConfig()
      {
         super();
      }
      
      public static function get version() : String
      {
         return _version;
      }
      
      public static function get destinationAddresses() : Array
      {
         return _destinationAddresses;
      }
      
      public static function get generalDataSendingInterval() : GeneralDataSendingIntervalSettings
      {
         return _generalDataSendingSettings;
      }
      
      public static function getGeneralDataSendingInterval(param1:Number = 900) : Number
      {
         return _generalDataSendingSettings.GetSendingInterval(param1);
      }
      
      public static function getLoadingDataSendingInterval() : Number
      {
         return 5;
      }
      
      public static function get bounceThreasholdRate() : Number
      {
         return _bounceThreasholdRate;
      }
      
      public static function set bounceThreasholdRate(param1:Number) : void
      {
         if(param1 < 0 || param1 > 1)
         {
            throw new RangeError("BounceThreshold must be between 0 and 1.");
         }
         else
         {
            _bounceThreasholdRate = param1;
            return;
         }
      }
      
      public static function get bounceThreasholdTime() : int
      {
         return _bounceThreasholdTime;
      }
      
      public static function get clipViewedThreasholdRate() : Number
      {
         return _clipViewedThreasholdRate;
      }
      
      public static function get recentLength() : Number
      {
         return _recentLength;
      }
      
      public static function get samplingRate() : Number
      {
         return _samplingRate;
      }
      
      public static function set samplingRate(param1:Number) : void
      {
         if(param1 >= 0 && param1 <= 1)
         {
            _samplingRate = param1;
         }
         else
         {
            TextTracer.writeLine("Sampling rate should be between 0 and 1.");
         }
      }
      
      public static function get loadingTimeoutForSD() : int
      {
         return _loadingTimeoutForSD;
      }
      
      public static function set loadingTimeoutForSD(param1:int) : void
      {
         if(param1 > 0)
         {
            _loadingTimeoutForSD = param1;
         }
      }
      
      public static function get loadingTimeoutForVD() : int
      {
         return _loadingTimeoutForVD;
      }
      
      public static function set loadingTimeoutForVD(param1:int) : void
      {
         if(param1 > 0)
         {
            _loadingTimeoutForVD = param1;
         }
      }
      
      public static function getIsSelected(param1:String) : Boolean
      {
         var _loc2_:int = UniqueIDGenerator.GetCodeOfID(param1);
         var _loc3_:int = _loc2_ % SAMPLING_BASE;
         var _loc4_:Number = SAMPLING_BASE * _samplingRate;
         return _loc3_ < _loc4_;
      }
   }
}
