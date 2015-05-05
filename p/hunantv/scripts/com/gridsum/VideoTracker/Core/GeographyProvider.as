package com.gridsum.VideoTracker.Core
{
   import flash.net.URLLoader;
   import flash.net.URLRequest;
   import flash.net.URLLoaderDataFormat;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.events.SecurityErrorEvent;
   import com.gridsum.VideoTracker.Store.*;
   import com.gridsum.Debug.TextTracer;
   
   public class GeographyProvider extends Object
   {
      
      private static const _ipServerUrl:String = "http://g.gridsum.com/v2/g.aspx";
      
      private static const _commonKey:String = "GridsumCommon";
      
      private static var _geographyInfo:String = null;
      
      private static var _isInfoAvailable:Boolean = false;
      
      private static var _loader:URLLoader = null;
      
      public function GeographyProvider()
      {
         super();
      }
      
      public static function getGeographyInfo() : String
      {
         if(!GeographyProvider._isInfoAvailable)
         {
            GeographyProvider.prepare();
            return "-";
         }
         return _geographyInfo;
      }
      
      public static function prepare() : void
      {
         var _loc1_:Object = null;
         var _loc2_:Object = null;
         var _loc3_:* = NaN;
         var _loc4_:Date = null;
         if(!_isInfoAvailable)
         {
            _loc1_ = PersistInfoProvider.getInstance().loadGeography();
            _loc2_ = PersistInfoProvider.getInstance().loadGeographyRecordTime();
            if(_loc1_ == null || _loc2_ == null)
            {
               getInfoFromServer();
            }
            else
            {
               _loc3_ = _loc2_ as Number;
               _loc4_ = new Date();
               if(_loc4_.getTime() - _loc3_ > 10 * 3600 * 1000)
               {
                  getInfoFromServer();
               }
               else
               {
                  _isInfoAvailable = true;
                  _geographyInfo = _loc1_ as String;
               }
            }
         }
      }
      
      private static function getInfoFromServer() : void
      {
         var req:URLRequest = null;
         try
         {
            _loader = new URLLoader();
            _loader.dataFormat = URLLoaderDataFormat.TEXT;
            req = new URLRequest(_ipServerUrl);
            _loader.addEventListener(Event.COMPLETE,loadComplete);
            _loader.addEventListener(IOErrorEvent.IO_ERROR,OnLoaderIOError);
            _loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR,OnSecurityError);
            _loader.load(req);
         }
         catch(e:Error)
         {
            trace("Exception occurred: " + e.message);
         }
      }
      
      private static function loadComplete(param1:Event) : void
      {
         var receivedStr:String = null;
         var arr:Array = null;
         var geoStr:String = null;
         var i:int = 0;
         var persistInfoProvider:PersistInfoProvider = null;
         var evt:Event = param1;
         try
         {
            receivedStr = _loader.data;
            arr = receivedStr.split("-");
            geoStr = "";
            i = 0;
            while(i < arr.length)
            {
               geoStr = geoStr + String.fromCharCode(parseInt(arr[i]));
               i++;
            }
            _isInfoAvailable = true;
            _geographyInfo = geoStr;
            persistInfoProvider = PersistInfoProvider.getInstance();
            persistInfoProvider.saveGeography(_geographyInfo);
            persistInfoProvider.saveGeographyRecordTime(new Date().getTime());
         }
         catch(e:Error)
         {
            trace("获取地理位置的时候发生错误，可能无法得知正确的位置。");
         }
         trace(geoStr);
      }
      
      private static function OnLoaderIOError(param1:IOErrorEvent) : void
      {
         TextTracer.writeLine("IOError occur while sending message: " + param1.text);
      }
      
      private static function OnSecurityError(param1:SecurityErrorEvent) : void
      {
         TextTracer.writeLine("SecurityError occur while sending message: " + param1.text);
      }
   }
}
