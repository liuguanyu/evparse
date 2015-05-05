package com
{
   import com.utl.consolelog;
   import com.utl.helpMethods;
   
   public class FLVMetaData extends Object
   {
      
      public var mediaURL:String;
      
      public var admediaURL:String;
      
      public var videoFormat:String;
      
      public var mediaTitle:String;
      
      public var canSeekToEnd:Boolean;
      
      public var audiocodecid:Number;
      
      public var audiodelay:Number;
      
      public var audiodatarate:Number;
      
      public var videocodecid:Number;
      
      public var framerate:Number;
      
      public var videodatarate:Number;
      
      public var videoheight:Number;
      
      public var videowidth:Number;
      
      public var duration:Number;
      
      public var duration_ex:Number;
      
      public var cuePoints:Array;
      
      public var streamSeekTime:Number;
      
      public var streamSeekPos:Number;
      
      public var mediaInfoObject:Object;
      
      public var connKey:String;
      
      public var connCount:Number;
      
      public var offsetType:String = "0";
      
      public var videoRatio:Number;
      
      public function FLVMetaData()
      {
         this.mediaInfoObject = new Object();
         super();
         this.connKey = "";
         this.connCount = 1;
         this.videodatarate = 800;
         this.videoheight = 480;
         this.videowidth = 720;
         this.framerate = 25;
         this.mediaTitle = "芒果TV视频";
         this.admediaURL = "";
         this.mediaURL = "";
         this.videoFormat = "1";
         this.canSeekToEnd = true;
         this.duration = 1;
         this.duration_ex = 1;
         this.streamSeekTime = 0;
         this.streamSeekPos = 0;
      }
      
      public function get aspectRatio() : Number
      {
         return this.videowidth / this.videoheight;
      }
      
      public function get PlayMediaUrl() : String
      {
         if(this.mediaURL == "")
         {
            return "";
         }
         var _loc1_:String = this.mediaURL;
         var _loc2_:Number = parseInt(this.streamSeekTime.toString());
         var _loc3_:Number = parseInt(this.streamSeekPos.toString());
         if(this.offsetType == "0")
         {
            if(_loc3_ > 0)
            {
               if(_loc1_.indexOf("?") != -1)
               {
                  _loc1_ = _loc1_ + ("&start=" + _loc3_);
               }
               else
               {
                  _loc1_ = _loc1_ + ("?start=" + _loc3_);
               }
            }
         }
         else if(this.offsetType == "1")
         {
            if(_loc2_ > 0)
            {
               if(_loc1_.indexOf("?") != -1)
               {
                  _loc1_ = _loc1_ + ("&start=" + _loc2_);
               }
               else
               {
                  _loc1_ = _loc1_ + ("?start=" + _loc2_);
               }
            }
         }
         
         trace("streamurl:" + _loc1_);
         consolelog.log("streamurl:" + _loc1_);
         return _loc1_;
      }
      
      public function getTheSeekPos(param1:Number) : Number
      {
         var _loc5_:Array = null;
         var _loc6_:Array = null;
         var _loc8_:* = undefined;
         var _loc2_:* = 0;
         var _loc3_:* = param1;
         var _loc4_:* = false;
         var _loc7_:* = false;
         if(!(this.mediaInfoObject["timeslist"] == null) && !(this.mediaInfoObject["filepositionslist"] == null))
         {
            _loc5_ = this.mediaInfoObject["timeslist"].toString().split(",");
            _loc6_ = this.mediaInfoObject["filepositionslist"].toString().split(",");
            _loc4_ = true;
         }
         if(_loc4_)
         {
            _loc8_ = 0;
            while(_loc8_ < _loc5_.length)
            {
               if(helpMethods.roundParseInt(_loc5_[_loc8_]) > _loc3_)
               {
                  if(_loc8_ > 0)
                  {
                     _loc2_ = _loc6_[_loc8_ - 1];
                  }
                  else
                  {
                     _loc2_ = _loc6_[_loc8_];
                  }
                  _loc7_ = true;
                  break;
               }
               if(helpMethods.roundParseInt(_loc5_[_loc8_]) == _loc3_)
               {
                  _loc2_ = _loc6_[_loc8_];
                  _loc7_ = true;
                  break;
               }
               _loc8_++;
            }
            if(!_loc7_)
            {
               _loc2_ = _loc6_[_loc5_.length - 1];
            }
         }
         return _loc2_;
      }
   }
}
