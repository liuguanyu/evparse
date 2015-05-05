package com.gridsum.VideoTracker.Store
{
   import com.gridsum.Debug.TextTracer;
   import com.gridsum.VideoTracker.Util.UniqueIDGenerator;
   
   public class PersistInfoProvider extends Object
   {
      
      private static var _persistInfoProvider:PersistInfoProvider = null;
      
      private var _persistStore:StoreManager = null;
      
      private const UNKNOWN_VISITOR:String = "UnknownVisitor";
      
      public function PersistInfoProvider()
      {
         var flashStore:FlashStore = null;
         var browserStore:BrowserStore = null;
         super();
         this._persistStore = new StoreManager();
         try
         {
            flashStore = new FlashStore();
            this._persistStore.addConcreteStorage(flashStore);
         }
         catch(eFlashStore:Error)
         {
            TextTracer.writeLine(eFlashStore.name + " " + eFlashStore.message);
         }
         try
         {
            browserStore = new BrowserStore();
            this._persistStore.addConcreteStorage(browserStore);
         }
         catch(eBrowserStore:Error)
         {
            TextTracer.writeLine(eBrowserStore.name + " " + eBrowserStore.message);
         }
      }
      
      public static function getInstance() : PersistInfoProvider
      {
         if(_persistInfoProvider == null)
         {
            _persistInfoProvider = new PersistInfoProvider();
         }
         return _persistInfoProvider;
      }
      
      public function saveGeography(param1:Object) : void
      {
         var value:Object = param1;
         try
         {
            this._persistStore.addOrSetValue(StoreKeys.GeographyKey,value);
         }
         catch(err:Error)
         {
            TextTracer.writeLine("Warning: Fail to save geography info. " + err.message);
         }
      }
      
      public function loadGeography() : Object
      {
         var geoInfo:Object = null;
         try
         {
            geoInfo = this._persistStore.getValue(StoreKeys.GeographyKey);
         }
         catch(err:Error)
         {
            TextTracer.writeLine("Warning: Fail to get geography info. " + err.message);
         }
         return geoInfo;
      }
      
      public function saveGeographyRecordTime(param1:Object) : void
      {
         var value:Object = param1;
         try
         {
            this._persistStore.addOrSetValue(StoreKeys.GeographyTimeKey,value);
         }
         catch(err:Error)
         {
            TextTracer.writeLine("Warning: Fail to save geography record time. " + err.message);
         }
      }
      
      public function loadGeographyRecordTime() : Object
      {
         var geoRecordTime:Object = null;
         try
         {
            geoRecordTime = this._persistStore.getValue(StoreKeys.GeographyTimeKey);
         }
         catch(err:Error)
         {
            TextTracer.writeLine("Warning: Fail to get geography record time. " + err.message);
         }
         return geoRecordTime;
      }
      
      public function loadVisitorID() : String
      {
         var visitorID:Object = null;
         try
         {
            visitorID = this._persistStore.getValue(StoreKeys.CookieIDKey);
            if(visitorID == null)
            {
               this._persistStore.addOrSetValue(StoreKeys.CookieIDKey,UniqueIDGenerator.Generate());
               visitorID = this._persistStore.getValue(StoreKeys.CookieIDKey);
               if(visitorID == null)
               {
                  throw new Error("No error occurs when saving visitor ID, but the id read is null.");
               }
            }
         }
         catch(err:Error)
         {
            visitorID = UNKNOWN_VISITOR;
            TextTracer.writeLine("Warning: Fail to get visitor ID, the visitor is identified as unknown. " + err.message);
         }
         return visitorID == null?null:visitorID.toString();
      }
      
      public function savePlayCount(param1:String, param2:int) : void
      {
      }
      
      public function loadPlayCount(param1:String) : int
      {
         return 0;
      }
   }
}
