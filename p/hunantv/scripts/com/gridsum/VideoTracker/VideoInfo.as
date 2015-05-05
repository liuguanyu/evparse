package com.gridsum.VideoTracker
{
   public class VideoInfo extends Object
   {
      
      private var _videoID:String = null;
      
      private var _videoOriginalName:String = null;
      
      private var _videoName:String = null;
      
      private var _videoUrl:String = null;
      
      private var _videoTag:String = null;
      
      private var _videoTVChannel:String = null;
      
      private var _videoWebChannel:String = null;
      
      private var _videoFocus:String = null;
      
      private var _extendProperty1:String = null;
      
      private var _extendProperty2:String = null;
      
      private var _extendProperty3:String = null;
      
      private var _extendProperty4:String = null;
      
      private var _extendProperty5:String = null;
      
      private var _extendProperty6:String = null;
      
      private var _extendProperty7:String = null;
      
      private var _extendProperty8:String = null;
      
      private var _extendProperty9:String = null;
      
      private var _extendProperty10:String = null;
      
      private var _cdn:String = null;
      
      public function VideoInfo(param1:String)
      {
         super();
         this._videoID = param1;
         this._videoName = "";
         this._videoTag = "";
      }
      
      public function get videoID() : String
      {
         return this._videoID;
      }
      
      public function set videoID(param1:String) : void
      {
         this._videoID = param1;
      }
      
      public function get videoUrl() : String
      {
         return this._videoUrl;
      }
      
      public function set videoUrl(param1:String) : void
      {
         this._videoUrl = param1;
      }
      
      public function get videoOriginalName() : String
      {
         return this._videoOriginalName;
      }
      
      public function set videoOriginalName(param1:String) : void
      {
         this._videoOriginalName = param1;
      }
      
      public function get videoName() : String
      {
         return this._videoName;
      }
      
      public function set videoName(param1:String) : void
      {
         this._videoName = param1;
      }
      
      public function get videoTag() : String
      {
         return this._videoTag;
      }
      
      public function set videoTag(param1:String) : void
      {
         var _loc5_:* = 0;
         var _loc2_:RegExp = new RegExp("~","g");
         var param1:String = param1.replace(_loc2_,"");
         var _loc3_:RegExp = new RegExp("\\/","g");
         param1 = param1.replace(_loc3_,"~");
         var _loc4_:Array = param1.split("~");
         if(_loc4_.length > 5)
         {
            param1 = _loc4_[0];
            _loc5_ = 1;
            while(_loc5_ < 5)
            {
               param1 = param1 + ("~" + _loc4_[_loc5_]);
               _loc5_++;
            }
         }
         this._videoTag = param1;
      }
      
      public function get videoTVChannel() : String
      {
         return this._videoTVChannel;
      }
      
      public function set videoTVChannel(param1:String) : void
      {
         this._videoTVChannel = param1;
      }
      
      public function get videoWebChannel() : String
      {
         return this._videoWebChannel;
      }
      
      public function set videoWebChannel(param1:String) : void
      {
         var _loc5_:* = 0;
         var _loc2_:RegExp = new RegExp("~","g");
         var param1:String = param1.replace(_loc2_,"");
         var _loc3_:RegExp = new RegExp("\\/","g");
         param1 = param1.replace(_loc3_,"~");
         var _loc4_:Array = param1.split("~");
         if(_loc4_.length > 5)
         {
            param1 = _loc4_[0];
            _loc5_ = 1;
            while(_loc5_ < 5)
            {
               param1 = param1 + ("~" + _loc4_[_loc5_]);
               _loc5_++;
            }
         }
         this._videoWebChannel = param1;
      }
      
      public function get extendProperty1() : String
      {
         return this._extendProperty1;
      }
      
      public function set extendProperty1(param1:String) : void
      {
         this._extendProperty1 = param1;
      }
      
      public function get extendProperty2() : String
      {
         return this._extendProperty2;
      }
      
      public function set extendProperty2(param1:String) : void
      {
         this._extendProperty2 = param1;
      }
      
      public function get extendProperty3() : String
      {
         return this._extendProperty3;
      }
      
      public function set extendProperty3(param1:String) : void
      {
         this._extendProperty3 = param1;
      }
      
      public function get extendProperty4() : String
      {
         return this._extendProperty4;
      }
      
      public function set extendProperty4(param1:String) : void
      {
         this._extendProperty4 = param1;
      }
      
      public function get extendProperty5() : String
      {
         return this._extendProperty5;
      }
      
      public function set extendProperty5(param1:String) : void
      {
         this._extendProperty5 = param1;
      }
      
      public function get extendProperty6() : String
      {
         return this._extendProperty6;
      }
      
      public function set extendProperty6(param1:String) : void
      {
         this._extendProperty6 = param1;
      }
      
      public function get extendProperty7() : String
      {
         return this._extendProperty7;
      }
      
      public function set extendProperty7(param1:String) : void
      {
         this._extendProperty7 = param1;
      }
      
      public function get extendProperty8() : String
      {
         return this._extendProperty8;
      }
      
      public function set extendProperty8(param1:String) : void
      {
         this._extendProperty8 = param1;
      }
      
      public function get extendProperty9() : String
      {
         return this._extendProperty9;
      }
      
      public function set extendProperty9(param1:String) : void
      {
         this._extendProperty9 = param1;
      }
      
      public function get extendProperty10() : String
      {
         return this._extendProperty10;
      }
      
      public function set extendProperty10(param1:String) : void
      {
         this._extendProperty10 = param1;
      }
      
      public function get cdn() : String
      {
         return this._cdn;
      }
      
      public function set cdn(param1:String) : void
      {
         this._cdn = param1;
      }
      
      public function get videoFocus() : String
      {
         return this._videoFocus;
      }
      
      public function set videoFocus(param1:String) : void
      {
         this._videoFocus = param1;
      }
   }
}
