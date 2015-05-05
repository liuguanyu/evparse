package com.datasvc
{
   import flash.net.*;
   import flash.events.*;
   import com.*;
   import com.utl.*;
   import flash.display.*;
   import flash.utils.*;
   
   public class setupSharedObject extends Sprite
   {
      
      private var ShareObj:SharedObject = null;
      
      private var CurrentConfigLevel:String = "自动";
      
      private var CurrenSelectLevel:String = "自动";
      
      private var CurrenZoomLevel:Number = 1;
      
      private var host:String = "www.imgo.tv.video.zoom_mark";
      
      public var mTimeRecoder:Number = 0;
      
      public function setupSharedObject()
      {
         super();
         this.getQualityConfig();
      }
      
      public function getQualityConfig() : String
      {
         try
         {
            this.ShareObj = SharedObject.getLocal("www.imgo.tv.video.quality");
            if(this.ShareObj.size > 0)
            {
               this.CurrentConfigLevel = this.ShareObj.data._level_;
               this.CurrenSelectLevel = this.CurrentConfigLevel;
            }
         }
         catch(e:*)
         {
            ShareObj = null;
         }
         return this.CurrenSelectLevel;
      }
      
      public function setQualityConfig(param1:String) : *
      {
         var s:String = param1;
         try
         {
            this.ShareObj = SharedObject.getLocal("www.imgo.tv.video.quality");
         }
         catch(e:*)
         {
            ShareObj = null;
         }
         this.CurrentConfigLevel = s;
         if(this.ShareObj != null)
         {
            this.ShareObj.data._level_ = this.CurrentConfigLevel;
            this.ShareObj.flush();
         }
      }
      
      public function setLastClipTime(param1:String, param2:Number) : *
      {
         var index:int = 0;
         var clipid:String = param1;
         var time:Number = param2;
         try
         {
            this.ShareObj = SharedObject.getLocal("www.imgo.tv.video.record");
         }
         catch(e:*)
         {
            ShareObj = null;
         }
         if(this.ShareObj.data.VideoIDArray == null && this.ShareObj.data.VideoTimeArray == null)
         {
            this.ShareObj.data.VideoIDArray = new Array();
            this.ShareObj.data.VideoTimeArray = new Array();
         }
         if(this.ShareObj != null)
         {
            this.mTimeRecoder = time;
            if(this.ShareObj.data.VideoIDArray.indexOf(clipid) != -1)
            {
               index = this.ShareObj.data.VideoIDArray.indexOf(clipid);
               this.ShareObj.data.VideoIDArray[index] = clipid;
               this.ShareObj.data.VideoTimeArray[index] = this.mTimeRecoder;
            }
            else
            {
               this.ShareObj.data.VideoIDArray.push(clipid);
               this.ShareObj.data.VideoTimeArray.push(this.mTimeRecoder);
            }
            this.ShareObj.flush();
         }
      }
      
      public function getLastClipTime(param1:String) : Number
      {
         var index:int = 0;
         var clipid:String = param1;
         if(this.mTimeRecoder == 0)
         {
            try
            {
               this.ShareObj = SharedObject.getLocal("www.imgo.tv.video.record");
               if(this.ShareObj.size > 0)
               {
                  if(this.ShareObj.data.VideoIDArray.indexOf(clipid) != -1)
                  {
                     index = this.ShareObj.data.VideoIDArray.indexOf(clipid);
                     this.mTimeRecoder = this.ShareObj.data.VideoTimeArray[index];
                     return this.mTimeRecoder;
                  }
               }
            }
            catch(e:*)
            {
               ShareObj = null;
            }
            return this.mTimeRecoder;
         }
         return this.mTimeRecoder;
      }
      
      public function setSkipHeadEnd(param1:Boolean) : *
      {
         var skip:Boolean = param1;
         try
         {
            this.ShareObj = SharedObject.getLocal("www.imgo.tv.video.skip");
         }
         catch(e:*)
         {
            ShareObj = null;
         }
         if(this.ShareObj != null)
         {
            this.ShareObj.data.skip = skip;
            this.ShareObj.flush();
         }
      }
      
      public function getSkipHeadEnd() : Boolean
      {
         var ret:Boolean = false;
         try
         {
            ret = false;
            this.ShareObj = SharedObject.getLocal("www.imgo.tv.video.skip");
            if(this.ShareObj.size > 0)
            {
               ret = this.ShareObj.data.skip;
            }
            else
            {
               ret = true;
               this.ShareObj.data.skip = ret;
               this.ShareObj.flush();
            }
         }
         catch(e:*)
         {
            ShareObj = null;
         }
         return ret;
      }
      
      public function GetCookie() : String
      {
         var cookie:String = "";
         try
         {
            this.ShareObj = SharedObject.getLocal("www.imgo.tv.video.cookie");
            if(this.ShareObj.size > 0)
            {
               cookie = this.ShareObj.data.cookie;
            }
         }
         catch(e:*)
         {
            ShareObj = null;
         }
         if(cookie == "")
         {
            cookie = this.SetCookie(GUID.create());
         }
         return cookie;
      }
      
      public function SetCookie(param1:String) : String
      {
         var cookie:String = param1;
         try
         {
            this.ShareObj = SharedObject.getLocal("www.imgo.tv.video.cookie");
         }
         catch(e:*)
         {
            ShareObj = null;
         }
         if(this.ShareObj != null)
         {
            this.ShareObj.data.cookie = cookie;
            this.ShareObj.flush();
         }
         return cookie;
      }
      
      public function GetTimerMS() : Number
      {
         var ms:Number = 0;
         try
         {
            this.ShareObj = SharedObject.getLocal("www.imgo.tv.video.timeMS");
            if(this.ShareObj.size > 0)
            {
               ms = this.ShareObj.data.ms;
            }
         }
         catch(e:*)
         {
            ShareObj = null;
         }
         if(ms == 0)
         {
            ms = this.SetTimerMS(getTimer());
         }
         return ms;
      }
      
      public function SetTimerMS(param1:Number) : Number
      {
         var ms:Number = param1;
         try
         {
            this.ShareObj = SharedObject.getLocal("www.imgo.tv.video.timeMS");
         }
         catch(e:*)
         {
            ShareObj = null;
         }
         if(this.ShareObj != null)
         {
            this.ShareObj.data.ms = ms;
            this.ShareObj.flush();
         }
         return ms;
      }
      
      public function getValue(param1:String) : String
      {
         var value:String = null;
         var key:String = param1;
         value = null;
         try
         {
            this.ShareObj = SharedObject.getLocal(this.host);
            consolelog.log("ShareObj-----------------get:" + this.ShareObj.data[key]);
            if(null != this.ShareObj)
            {
               value = this.ShareObj.data[key];
            }
            else
            {
               return value;
            }
         }
         catch(e:*)
         {
            return value;
         }
         return value;
      }
      
      public function setValue(param1:String, param2:String) : Boolean
      {
         var key:String = param1;
         var value:String = param2;
         try
         {
            this.ShareObj = SharedObject.getLocal(this.host);
            consolelog.log("ShareObj----------------set:" + value);
            if(null != this.ShareObj)
            {
               this.ShareObj.data[key] = value;
               this.ShareObj.flush();
            }
            else
            {
               return false;
            }
         }
         catch(e:*)
         {
            return false;
         }
         return true;
      }
   }
}
