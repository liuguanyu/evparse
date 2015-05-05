package com.statistics.bigdata
{
   import flash.display.MovieClip;
   import com.utl.timeInfo;
   import com.datasvc.setupSharedObject;
   import com.parmParse;
   import com.utl.helpMethods;
   import com.playerEvents;
   import flash.net.*;
   import flash.events.*;
   import com.statistics.GUID;
   import flash.external.ExternalInterface;
   import com.utl.consolelog;
   import flash.system.Capabilities;
   import com.utl.Encrypt;
   
   public class BigData extends MovieClip
   {
      
      private static var mServerAddress:String = "http://log.hunantv.com/s.gif?";
      
      private static var mSeverrAddressOnError:String = "http://118.26.188.4:80?";
      
      private static var UUID:String = "uuid=";
      
      private static var WGUID:String = "&guid=";
      
      private static var REF:String = "&ref=";
      
      private static var OS:String = "&os=";
      
      private static var UA:String = "&ua=";
      
      private static var URL:String = "&url=";
      
      private static var BID:String = "&bid=";
      
      private static var VID:String = "&vid=";
      
      private static var VTS:String = "&vts=";
      
      private static var CID:String = "&cid=";
      
      private static var TID:String = "&tid=";
      
      private static var PLID:String = "&plid=";
      
      private static var COOKIE:String = "&cookie=";
      
      private static var UID:String = "&uid=";
      
      private static var DID:String = "&did=";
      
      private static var CT:String = "&ct=";
      
      private static var ET:String = "&et=";
      
      private static var TD:String = "&td=";
      
      private static var IDX:String = "&idx=";
      
      private static var ADID:String = "&adid=";
      
      private static var ADTTPID:String = "&adtpid=";
      
      private static var ADTMS:String = "&adtms=";
      
      private static var CDNIP:String = "&cdnip=";
      
      private static var PT:String = "&pt=";
      
      private static var TP:String = "&tp=";
      
      private static var LN:String = "&ln=";
      
      private static var CF:String = "&cf=";
      
      private static var ISDRM:String = "&isdrm=";
      
      private static var PURL:String = "&purl=";
      
      private static var DEFINITION:String = "&definition=";
      
      private static var PVER:String = "&pver=";
      
      private static var ACT:String = "&act=";
      
      private var mMovieInfo:Object;
      
      private var PlayInfo:Object;
      
      private var mTimeInfo:timeInfo = null;
      
      public var shareObj:setupSharedObject;
      
      private var uuid:String = "";
      
      private var wguid:String = "";
      
      private var ref:String = "";
      
      private var os:String = "";
      
      private var ua:String = "";
      
      private var url:String = "";
      
      private var bid:String = "1";
      
      private var vid:String = "";
      
      private var cid:String = "";
      
      private var tid:String = "";
      
      private var plid:String = "";
      
      private var vts:String = "";
      
      private var cookie:String = "";
      
      private var uid:String = "";
      
      private var did:String = "";
      
      private var ct:String = "";
      
      private var et:String = "";
      
      private var td:String = "";
      
      private var idx:String = "";
      
      private var adid:String = "";
      
      private var adtpid:String = "";
      
      private var adtms:String = "";
      
      private var cdnip:String = "";
      
      private var pt:String = "flash";
      
      private var tp:String = "1";
      
      private var ln:String = "";
      
      private var cf:String = "";
      
      private var isdrm:String = "0";
      
      private var purl:String = "";
      
      private var definition:String = "2";
      
      private var pver:String = "";
      
      private var act:String = "";
      
      private var str:String = "";
      
      private var mInitStates:Boolean = false;
      
      private var msgQueue:Array;
      
      var objParm:Object = null;
      
      private var mTimeOutFirst:int = 3;
      
      private var mTimeOutSecond:int = 2;
      
      private var mTimeOutThree:int = 1;
      
      private var mDragIndex:int = 0;
      
      private var mBlockIndex:int = 0;
      
      private var mBufferIndex:int = 0;
      
      private var mHeartBeatIndex:int = 0;
      
      private var mParmParse:parmParse = null;
      
      public function BigData(param1:parmParse)
      {
         this.shareObj = new setupSharedObject();
         this.msgQueue = new Array();
         super();
         this.mParmParse = param1;
      }
      
      public function Init() : *
      {
         this.SetConfigure();
         helpMethods.addMutiEventListener(stage,this.OnHandleEvent,playerEvents.MOVIE_INFO,playerEvents.PLAY_INFO,playerEvents.STREAM_TIME,playerEvents.VIDEO_REPLAY,playerEvents.STATISTICS_BIGDATA_PLAY,playerEvents.STATISTICS_BIGDATA_OVER,playerEvents.CONTORL_PAUSE,playerEvents.STATISTICS_BIGDATA_RESUME,playerEvents.STATISTICS_BIGDATA_FORWARD,playerEvents.STATISTICS_BIGDATA_BACKWARD,playerEvents.STATISTICS_BIGDATA_DRAG,playerEvents.STATISTICS_BIGDATA_BLOCK,playerEvents.STATISTICS_BIGDATA_BUFFER,playerEvents.STATISTICS_BIGDATA_ADBEGIN,playerEvents.STATISTICS_BIGDATA_ADEND,playerEvents.STATISTICS_BIGDATA_HEARTBEAT,playerEvents.STATISTICS_BIGDATA_ERROR);
      }
      
      private function OnHandleEvent(param1:playerEvents) : *
      {
         switch(param1.type)
         {
            case playerEvents.VIDEO_REPLAY:
               this.mInitStates = false;
               this.InitParm();
               break;
            case playerEvents.MOVIE_INFO:
               this.SetMovieInfo(param1);
               break;
            case playerEvents.PLAY_INFO:
               this.SetPlayInfo(param1);
               break;
            case playerEvents.STREAM_TIME:
               this.ReceDataStreams(param1);
               break;
            case playerEvents.STATISTICS_BIGDATA_PLAY:
               this.td = param1.data as String;
               if(!this.mInitStates)
               {
                  this.mInitStates = true;
                  this.CreateReportEvent("play","",this.td);
                  this.mHeartBeatIndex++;
                  this.CreateReportEvent("heartbeat","","",this.mHeartBeatIndex.toString());
               }
               break;
            case playerEvents.STATISTICS_BIGDATA_OVER:
               this.CreateReportEvent("stop");
               break;
            case playerEvents.CONTORL_PAUSE:
               this.CreateReportEvent("pause");
               break;
            case playerEvents.STATISTICS_BIGDATA_RESUME:
               this.CreateReportEvent("resume");
               break;
            case playerEvents.STATISTICS_BIGDATA_FORWARD:
               this.objParm = param1.data as Object;
               this.CreateReportEvent("forward",this.objParm.et,this.objParm.td);
               break;
            case playerEvents.STATISTICS_BIGDATA_BACKWARD:
               this.objParm = param1.data as Object;
               this.CreateReportEvent("backward",this.objParm.et,this.objParm.td);
               break;
            case playerEvents.STATISTICS_BIGDATA_DRAG:
               this.mDragIndex++;
               this.objParm = param1.data as Object;
               this.CreateReportEvent("drag",this.objParm.et,this.objParm.td,this.mDragIndex.toString());
               break;
            case playerEvents.STATISTICS_BIGDATA_BLOCK:
               this.mBlockIndex++;
               this.CreateReportEvent("block","","",this.mBlockIndex.toString());
               break;
            case playerEvents.STATISTICS_BIGDATA_BUFFER:
               this.mBufferIndex++;
               this.objParm = param1.data as Object;
               this.CreateReportEvent("buffer",this.objParm.et,this.objParm.td,this.mBufferIndex.toString());
               break;
            case playerEvents.STATISTICS_BIGDATA_ADBEGIN:
               this.objParm = param1.data as Object;
               this.CreateReportEvent("ad_begin","","","",this.objParm.adid,this.objParm.adtms);
               break;
            case playerEvents.STATISTICS_BIGDATA_ADEND:
               this.objParm = param1.data as Object;
               this.CreateReportEvent("ad_end","","","",this.objParm.adid,this.objParm.adtms);
               break;
            case playerEvents.STATISTICS_BIGDATA_HEARTBEAT:
               this.mHeartBeatIndex++;
               this.CreateReportEvent("heartbeat","","",this.mHeartBeatIndex.toString());
               break;
            case playerEvents.STATISTICS_BIGDATA_ERROR:
               this.objParm = param1.data as Object;
               break;
         }
      }
      
      private function InitParm() : *
      {
         this.SetUUID();
         this.mDragIndex = 0;
         this.mBlockIndex = 0;
         this.mBufferIndex = 0;
         this.mHeartBeatIndex = 0;
      }
      
      private function SetConfigure() : *
      {
         this.uuid = GUID.create();
         this.SetOS();
         this.SetUA();
         this.SetURL();
         this.SetCookie();
         this.SetFlashVar();
         if(this.mParmParse != null)
         {
            this.vid = this.mParmParse.video_id;
            this.cid = this.mParmParse.root_id;
            this.tid = this.mParmParse.clip_type;
            this.plid = this.mParmParse.collection_id;
         }
      }
      
      private function SetUUID() : *
      {
         try
         {
            this.uuid = GUID.create(this.mMovieInfo.data.user.ip != undefined?this.mMovieInfo.data.user.ip:"");
         }
         catch(e:*)
         {
         }
      }
      
      private function GetWGUID() : String
      {
         var _loc1_:String = null;
         var _loc2_:Array = null;
         try
         {
            if(this.wguid == "")
            {
               if(parmParse.INSTATION)
               {
                  if(ExternalInterface.available)
                  {
                     _loc1_ = helpMethods.callPageJs("getGUID");
                     _loc2_ = new Array();
                     _loc2_ = _loc1_.split("|");
                     if(_loc2_.length > 1)
                     {
                        this.wguid = _loc2_[0];
                        this.ref = encodeURIComponent(_loc2_[1]);
                     }
                  }
               }
            }
         }
         catch(e:*)
         {
         }
         return this.wguid;
      }
      
      private function SetOS() : *
      {
         var uaInfo:String = null;
         try
         {
            if(ExternalInterface.available)
            {
               uaInfo = ExternalInterface.call("function BrowserAgent(){return navigator.userAgent;}");
               consolelog.log("uaInfo:" + uaInfo);
               if(uaInfo.indexOf("Windows 98") != -1)
               {
                  this.os = "1";
               }
               else if(uaInfo.indexOf("Windows NT 5.1") != -1)
               {
                  this.os = "2";
               }
               else if(uaInfo.indexOf("Windows NT 5.0") != -1)
               {
                  this.os = "3";
               }
               else if(uaInfo.indexOf("Windows NT 5.2") != -1)
               {
                  this.os = "4";
               }
               else if(uaInfo.indexOf("Windows NT 6.1") != -1)
               {
                  this.os = "5";
               }
               else if(uaInfo.indexOf("Windows NT 6.2") != -1)
               {
                  this.os = "6";
               }
               else if(uaInfo.indexOf("Windows NT 6.0") != -1)
               {
                  this.os = "7";
               }
               else if(uaInfo.indexOf("Macintosh") != -1)
               {
                  this.os = "8";
               }
               else if(uaInfo.indexOf("Linux") != -1)
               {
                  this.os = "9";
               }
               else
               {
                  this.os = "20";
               }
               
               
               
               
               
               
               
               
               consolelog.log("os:" + this.os);
            }
         }
         catch(e:*)
         {
            os = "20";
         }
      }
      
      private function SetUA() : *
      {
         var uaInfo:String = null;
         try
         {
            if(ExternalInterface.available)
            {
               uaInfo = ExternalInterface.call("function BrowserAgent(){return navigator.userAgent;}");
               consolelog.log("uaInfo:" + uaInfo);
               if(uaInfo.indexOf("Maxthon") != -1)
               {
                  this.ua = "12";
               }
               else if(!(uaInfo.indexOf("TencentTraveler") == -1) || !(uaInfo.indexOf("QQBrowser") == -1))
               {
                  this.ua = "13";
               }
               else if(uaInfo.indexOf("LBBROWSER") != -1)
               {
                  this.ua = "14";
               }
               else if(uaInfo.indexOf("MetaSr") != -1)
               {
                  this.ua = "7";
               }
               else if(uaInfo.indexOf("MSIE 10.0") != -1)
               {
                  this.ua = "1";
               }
               else if(uaInfo.indexOf("MSIE 9.0") != -1)
               {
                  this.ua = "2";
               }
               else if(uaInfo.indexOf("MSIE 8.0") != -1)
               {
                  this.ua = "3";
               }
               else if(uaInfo.indexOf("MSIE 7.0") != -1)
               {
                  this.ua = "4";
               }
               else if(uaInfo.indexOf("MSIE 6.0") != -1)
               {
                  this.ua = "5";
               }
               else if(uaInfo.indexOf("Chrome") != -1)
               {
                  if(Capabilities.manufacturer == "Google Pepper")
                  {
                     this.ua = "6";
                  }
                  else
                  {
                     this.ua = "9";
                  }
               }
               else if(uaInfo.indexOf("Safari") != -1)
               {
                  this.ua = "10";
               }
               else if(uaInfo.indexOf("Firefox") != -1)
               {
                  this.ua = "8";
               }
               else if(uaInfo.indexOf("Opera") != -1)
               {
                  this.ua = "11";
               }
               else
               {
                  this.ua = "20";
               }
               
               
               
               
               
               
               
               
               
               
               
               
               consolelog.log("ua:" + this.ua);
            }
         }
         catch(e:*)
         {
            ua = "20";
         }
      }
      
      private function SetURL() : *
      {
         try
         {
            if(ExternalInterface.available)
            {
               if(this.url == "")
               {
                  this.url = ExternalInterface.call("function getUrl(){return document.location.href;}");
                  this.url = encodeURIComponent(this.url);
               }
            }
         }
         catch(e:*)
         {
         }
      }
      
      private function SetCookie() : *
      {
         this.cookie = this.shareObj.GetCookie();
      }
      
      private function SetFlashVar() : *
      {
         this.pver = Capabilities.version;
      }
      
      private function GetDefinition() : String
      {
         this.definition = "2";
         var _loc1_:String = this.shareObj.getQualityConfig();
         switch(_loc1_)
         {
            case "超清":
               this.definition = "3";
               break;
            case "高清":
               this.definition = "2";
               break;
            case "标清":
               this.definition = "1";
               break;
         }
         return this.definition;
      }
      
      private function SetMovieInfo(param1:playerEvents) : *
      {
         try
         {
            this.mMovieInfo = param1.data as Object;
            this.vid = this.mMovieInfo.data.info.video_id;
            this.cid = this.mMovieInfo.data.info.root_id;
            this.tid = this.mMovieInfo.data.info.clip_type;
            this.plid = this.mMovieInfo.data.info.collection_id;
            this.uid = this.mMovieInfo.data.user.id;
            this.cf = this.mMovieInfo.data.info.clip_type;
            this.isdrm = this.mMovieInfo.data.info.isdrm;
            this.SetUUID();
         }
         catch(e:*)
         {
         }
      }
      
      private function SetPlayInfo(param1:playerEvents) : *
      {
         try
         {
            this.PlayInfo = param1.data as Object;
            this.purl = this.PlayInfo.HttpServerUrl;
            this.purl = encodeURIComponent(this.purl);
         }
         catch(e:*)
         {
         }
      }
      
      private function ReceDataStreams(param1:playerEvents) : *
      {
         this.mTimeInfo = param1.data as timeInfo;
         this.vts = int(this.mTimeInfo.totaltime).toString();
         this.ct = int(this.mTimeInfo.streamtime).toString();
      }
      
      private function CreateReportEvent(param1:String, param2:String = "", param3:String = "", param4:String = "", param5:String = "", param6:String = "") : *
      {
         this.act = param1;
         this.et = param2;
         this.td = param3;
         this.idx = param4;
         this.adid = param5;
         this.adtms = param6;
         this.str = mServerAddress + UUID + this.uuid + WGUID + this.GetWGUID() + REF + this.ref + OS + this.os + UA + this.ua + URL + this.url + BID + this.bid + VID + this.vid + VTS + this.vts + CID + this.cid + TID + this.tid + PLID + this.plid + COOKIE + this.cookie + UID + this.uid + DID + this.did + CT + this.ct + ET + this.et + TD + this.td + IDX + this.idx + ADID + this.adid + ADTTPID + this.adtpid + ADTMS + this.adtms + CDNIP + this.cdnip + PT + this.pt + TP + this.tp + LN + this.ln + CF + this.cf + ISDRM + this.isdrm + PURL + this.purl + DEFINITION + this.GetDefinition() + PVER + this.pver + ACT + this.act;
         if(this.msgQueue.length > 0)
         {
            this.msgQueue.push(this.str);
         }
         else
         {
            this.msgQueue.push(this.str);
            this.URLGetData();
         }
      }
      
      private function HandleMsg() : *
      {
         this.msgQueue.shift();
         if(this.msgQueue.length > 0)
         {
            this.URLGetData();
         }
      }
      
      private function URLGetData() : *
      {
         if(this.mTimeOutFirst <= 0 && this.mTimeOutSecond <= 0 && this.mTimeOutThree <= 0)
         {
            return;
         }
         var _loc1_:URLLoader = new URLLoader();
         this.ConfigureListeners(_loc1_);
         var _loc2_:URLRequest = new URLRequest(this.msgQueue[0]);
         _loc1_.load(_loc2_);
         trace("BIGDATA URL:" + this.msgQueue[0]);
         consolelog.log("BIGDATA URL:" + this.msgQueue[0]);
      }
      
      private function ConfigureListeners(param1:IEventDispatcher) : void
      {
         param1.addEventListener(Event.COMPLETE,this.CompleteHandler);
         param1.addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.SecurityErrorHandler);
         param1.addEventListener(IOErrorEvent.IO_ERROR,this.IOErrorHandler);
         param1.addEventListener(Event.OPEN,this.OpenHandler);
         param1.addEventListener(ProgressEvent.PROGRESS,this.ProgressHandler);
         param1.addEventListener(HTTPStatusEvent.HTTP_STATUS,this.HttpStatusHandler);
      }
      
      private function CompleteHandler(param1:Event) : *
      {
         trace("BIGDATA Event.COMPLETE:" + param1);
         this.mTimeOutFirst = 3;
         this.mTimeOutSecond = 2;
         this.mTimeOutThree = 1;
         this.HandleMsg();
      }
      
      private function SecurityErrorHandler(param1:SecurityErrorEvent) : void
      {
         trace("BIGDATA Event.SecurityErrorEvent:" + param1);
      }
      
      private function IOErrorHandler(param1:IOErrorEvent) : void
      {
         trace("BIGDATA Event.IOErrorEvent:" + param1);
      }
      
      private function OpenHandler(param1:Event) : void
      {
         trace("BIGDATA Event.OPEN:" + param1);
      }
      
      private function ProgressHandler(param1:ProgressEvent) : void
      {
         trace("BIGDATA ProgressEvent.PROGRESS:" + param1);
      }
      
      private function HttpStatusHandler(param1:HTTPStatusEvent) : void
      {
         trace("BIGDATA HTTPStatusEvent:" + param1);
         if(param1.status != 200)
         {
            if(this.mTimeOutFirst > 0)
            {
               this.mTimeOutFirst--;
               if(this.mTimeOutFirst == 0)
               {
                  this.HandleMsg();
               }
            }
            else if(this.mTimeOutSecond > 0)
            {
               this.mTimeOutSecond--;
               if(this.mTimeOutSecond == 0)
               {
                  this.HandleMsg();
               }
            }
            else if(this.mTimeOutThree > 0)
            {
               this.mTimeOutThree--;
               if(this.mTimeOutThree == 0)
               {
                  this.HandleMsg();
               }
            }
            
            
         }
      }
      
      private function OnErrorReported(param1:String = "", param2:String = "") : *
      {
         var _loc11_:String = null;
         var _loc12_:URLLoader = null;
         var _loc13_:URLRequest = null;
         var _loc3_:* = "";
         if(ExternalInterface.available)
         {
            _loc3_ = ExternalInterface.call("function BrowserAgent(){return navigator.userAgent;}");
         }
         var _loc4_:* = new Date();
         var _loc5_:Number = _loc4_.getTime();
         var _loc6_:* = "";
         try
         {
            _loc6_ = GUID.create(this.mMovieInfo.data.user.ip != undefined?this.mMovieInfo.data.user.ip:"");
         }
         catch(e:*)
         {
         }
         var _loc7_:* = "";
         try
         {
            _loc7_ = this.mMovieInfo.data.user.id;
         }
         catch(e:*)
         {
         }
         var _loc8_:Encrypt = new Encrypt();
         var _loc9_:String = _loc8_.creatRandomCode(8);
         var _loc10_:* = "0";
         try
         {
            _loc10_ = this.mMovieInfo.data.info.ispay;
         }
         catch(e:*)
         {
         }
         try
         {
            _loc11_ = mSeverrAddressOnError + "ua=" + _loc3_ + "&time=" + _loc5_ + "&bid=1.1.3" + "&guid=" + this.GetWGUID() + "&ref=" + this.ref + "&uid=" + _loc7_ + "&net=5" + "&isdebug=0" + "&rd=" + _loc9_ + "&uuid=" + _loc6_ + "&url=" + this.url + VID + this.vid + CID + this.cid + PLID + this.plid + PVER + this.pver + CT + this.ct + TID + this.tid + CF + this.cf + PURL + this.purl + "&ap=0" + "&pt=0" + "&pay=" + _loc10_ + DEFINITION + this.GetDefinition() + "&act=error" + ISDRM + this.isdrm + "&ecoed=" + param1 + "&err=" + encodeURIComponent(param2);
            trace("error url:" + _loc11_);
            consolelog.log("error url:" + _loc11_);
            _loc12_ = new URLLoader();
            _loc13_ = new URLRequest(_loc11_);
            _loc12_.load(_loc13_);
         }
         catch(e:*)
         {
         }
      }
   }
}
