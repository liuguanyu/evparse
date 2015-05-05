package com.pplive.dac.logclient
{
   import flash.utils.ByteArray;
   
   public final class DataLogSource extends Object
   {
      
      public static const IKanVodApp:DataLogSource = new DataLogSource("http://ik.synacast.com/1.html?","pplive",DataLogSourceKind.Normal);
      
      public static const IKanOnlineApp:DataLogSource = new DataLogSource("http://ol.synacast.com/2.html?","&#$EOQWIU31!DA421",DataLogSourceKind.RealtimeOnline);
      
      public static const IKanBehaApp:DataLogSource = new DataLogSource("http://action.data.pplive.com/event/1.html?key=IKanApp&data=","pplive",DataLogSourceKind.Normal);
      
      private var _baseUrl:String;
      
      private var _key:String;
      
      private var _keyBytes:ByteArray;
      
      private var _kind:DataLogSourceKind;
      
      public function DataLogSource(param1:String, param2:String, param3:DataLogSourceKind)
      {
         super();
         this._baseUrl = param1;
         this._kind = param3;
         this._key = param2;
         var _loc4_:ByteArray = new ByteArray();
         _loc4_.writeUTFBytes(this._key);
         _loc4_.position = 0;
         this._keyBytes = _loc4_;
      }
      
      public function getBaseUrl() : String
      {
         return this._baseUrl;
      }
      
      public function getKey() : String
      {
         return this._key;
      }
      
      public function getKeyBytes() : ByteArray
      {
         return this._keyBytes;
      }
      
      public function getKind() : DataLogSourceKind
      {
         return this._kind;
      }
      
      public function isSourceKindNormal() : Boolean
      {
         return this._kind == DataLogSourceKind.Normal;
      }
      
      public function isSourceKindRealtimeOnline() : Boolean
      {
         return this._kind == DataLogSourceKind.RealtimeOnline;
      }
   }
}
