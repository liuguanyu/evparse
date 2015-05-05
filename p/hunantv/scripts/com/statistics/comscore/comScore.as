package com.statistics.comscore
{
   import flash.display.MovieClip;
   import com.utl.helpMethods;
   import com.playerEvents;
   import com.utl.consolelog;
   import com.parmParse;
   import flash.external.ExternalInterface;
   import flash.net.*;
   
   public class comScore extends MovieClip
   {
      
      private var mMovieInfo:Object;
      
      private var mInitStates:Boolean = false;
      
      private var C3:String = "";
      
      private var C4:String = "";
      
      private var C6:String = "";
      
      public function comScore()
      {
         super();
      }
      
      public function Init() : *
      {
         this.GetC4();
         helpMethods.addMutiEventListener(stage,this.OnHandlerEvent,playerEvents.MOVIE_INFO,playerEvents.VIDEO_REPLAY,playerEvents.STATISTICS_COMSCORE_START);
      }
      
      private function OnHandlerEvent(param1:playerEvents) : *
      {
         var _loc2_:String = null;
         switch(param1.type)
         {
            case playerEvents.VIDEO_REPLAY:
               this.mInitStates = false;
               break;
            case playerEvents.MOVIE_INFO:
               this.SetMovieInfo(param1);
               break;
            case playerEvents.STATISTICS_COMSCORE_START:
               if(!this.mInitStates)
               {
                  this.mInitStates = true;
                  _loc2_ = this.comScoreBeacon("1","18400293",this.C3,this.C4,"",this.C6,"");
                  trace("comScore url:" + _loc2_);
                  consolelog.log("comScore url:" + _loc2_);
               }
               break;
         }
      }
      
      private function GetC4() : *
      {
         var url:String = null;
         var httpIdx:int = 0;
         var doubleSlashsIdx:int = 0;
         var domainRootSlashIdx:int = 0;
         this.C4 = "";
         try
         {
            if(!parmParse.INSTATION)
            {
               if(ExternalInterface.available)
               {
                  url = ExternalInterface.call("function getUrl(){return document.location.href;}");
                  httpIdx = url.indexOf("http");
                  trace(httpIdx);
                  if(httpIdx == 0)
                  {
                     doubleSlashsIdx = url.indexOf("//");
                     trace(doubleSlashsIdx);
                     if(doubleSlashsIdx != -1)
                     {
                        domainRootSlashIdx = url.indexOf("/",doubleSlashsIdx + 2);
                        trace(domainRootSlashIdx);
                        if(domainRootSlashIdx != -1)
                        {
                           this.C4 = url.substring(doubleSlashsIdx + 2,domainRootSlashIdx);
                           trace("C4:" + this.C4);
                        }
                     }
                  }
               }
            }
         }
         catch(e:*)
         {
            trace("e:" + e);
         }
      }
      
      private function SetMovieInfo(param1:playerEvents) : *
      {
         this.mMovieInfo = param1.data as Object;
         this.C3 = this.mMovieInfo.data.info.root_id + "_" + this.mMovieInfo.data.info.collection_id;
         this.C6 = this.mMovieInfo.data.info.clip_type + "_" + this.mMovieInfo.data.info.video_id;
      }
      
      private function comScoreBeacon(param1:String, param2:String, param3:String, param4:String, param5:String, param6:String, param7:String) : String
      {
         var c1:String = param1;
         var c2:String = param2;
         var c3:String = param3;
         var c4:String = param4;
         var c5:String = param5;
         var c6:String = param6;
         var c10:String = param7;
         var page:String = "";
         var referrer:String = "";
         var title:String = "";
         try
         {
            page = ExternalInterface.call("function() { return document.location.href; }").toString();
            referrer = ExternalInterface.call("function() { return document.referrer; }").toString();
            title = ExternalInterface.call("function() { return document.title; }").toString();
            if("string" == "undefined" || page == "null")
            {
               page = loaderInfo.url;
            }
            if("string" == "undefined" || referrer == "null")
            {
               referrer = "";
            }
            if("string" == "undefined" || title == "null")
            {
               title = "";
            }
            if(!(page == null) && page.length > 512)
            {
               page = page.substr(0,512);
            }
            if(referrer.length > 512)
            {
               referrer = referrer.substr(0,512);
            }
         }
         catch(e:Error)
         {
            page = loaderInfo.url;
            trace(e);
         }
         var url:String = new Array(page.indexOf("https:") == 0?"https://sb":"http://b",".scorecardresearch.com/p","?c1=",c1,"&c2=",escape(c2),"&c3=",escape(c3),"&c4=",escape(c4),"&c5=",escape(c5),"&c6=",escape(c6),"&c10=",escape(c10),"&c7=",escape(page),"&c8=",escape(title),"&c9=",escape(referrer),"&rn=",Math.random(),"&cv=2.0").join("");
         if(url.length > 2080)
         {
            url = url.substr(0,2080);
         }
         var loader:URLLoader = new URLLoader();
         loader.load(new URLRequest(url));
         return url;
      }
   }
}
