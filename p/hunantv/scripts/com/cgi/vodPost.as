package com.cgi
{
   import flash.display.MovieClip;
   import com.parmParse;
   import com.utl.helpMethods;
   import com.playerEvents;
   import com.utl.timeInfo;
   import com.utl.JSON;
   import com.utl.consolelog;
   import com.utl.GUID;
   import flash.events.Event;
   
   public class vodPost extends MovieClip
   {
      
      var parmobj:parmParse;
      
      var vdata:vodData;
      
      var totalTime:Number = 1;
      
      var streamTime:Number = 1;
      
      var seekToTime:Number = 0;
      
      var pauseInfo:playPause = null;
      
      var play_pause_times:Number = 0;
      
      var buffInfo:playBuffer = null;
      
      var authbuffInfo:playBuffer = null;
      
      var isFirst = true;
      
      var SeekStart:Boolean = false;
      
      var rangeInfo:playRange = null;
      
      var isover:Boolean = false;
      
      var formatterString:String = "YYYY-MM-DD LL:NN:SS";
      
      public function vodPost(param1:parmParse)
      {
         super();
         this.parmobj = param1;
      }
      
      public function init() : *
      {
         this.initValues();
         helpMethods.addMutiEventListener(stage,this.PostMsg,playerEvents.PARMS_READY,playerEvents.PARMS_ERROR,playerEvents.CONTORL_PAUSE,playerEvents.CONTORL_START,playerEvents.BUFF_START,playerEvents.BUFF_END,playerEvents.CONTORL_SEEKSTART,playerEvents.PLAYCORE_SEEKEND,playerEvents.PLAYURL_READY);
      }
      
      function PostMsg(param1:playerEvents) : void
      {
         var _loc2_:timeInfo = null;
         switch(param1.type)
         {
            case playerEvents.PARMS_READY:
               this.startRange(0);
               this.isover = false;
               break;
            case playerEvents.PARMS_ERROR:
               break;
            case playerEvents.META_READY:
               break;
            case playerEvents.STREAM_TIME:
               _loc2_ = new timeInfo();
               _loc2_ = param1.data as timeInfo;
               this.totalTime = _loc2_.totaltime;
               this.streamTime = _loc2_.streamtime;
               break;
            case playerEvents.CONTORL_PAUSE:
               this.BeginPause(this.streamTime);
               break;
            case playerEvents.CONTORL_START:
               this.EndPause();
               break;
            case playerEvents.BITSET_CHANGE:
               break;
            case playerEvents.BUFF_START:
               this.BeginBuff(param1.data as Number);
               break;
            case playerEvents.BUFF_END:
               this.Endbuff();
               this.SeekStart = false;
               break;
            case playerEvents.AUTH_START:
               this.BeginBuffAuth(param1.data as Number);
               break;
            case playerEvents.AUTH_END:
               this.EndbuffAuth();
               break;
            case playerEvents.CONTORL_SEEKSTART:
               this.SeekStart = true;
               this.endRange(this.streamTime);
               break;
            case playerEvents.PLAYCORE_SEEKEND:
               this.startRange(param1.data as Number);
               break;
            case playerEvents.PLAYCORE_COMPLETE:
               this.endRange(this.totalTime);
               this.isover = true;
               break;
            case playerEvents.PLAYURL_READY:
               this.vdata.play_url = this.parmobj.HttpServerUrl;
         }
      }
      
      public function PostJson() : String
      {
         if(!this.isover)
         {
            this.endRange(this.streamTime);
         }
         this.vdata.play_end_time = this.getDate();
         var _loc1_:* = com.utl.JSON.stringify(this.vdata);
         consolelog.log(_loc1_);
         return _loc1_;
      }
      
      function initValues() : void
      {
         this.vdata = new vodData();
         this.vdata.play_start_time = this.getDate();
         this.vdata.video_info.clip_id = this.parmobj.clipid;
         this.vdata.video_info.sndlvl_id = this.parmobj.typeid;
         this.vdata.video_info.file_id = this.parmobj.fileid;
         this.vdata.video_info.is_pay = this.parmobj.ispay;
         this.vdata.play_pause_times = "0";
         this.vdata.play_session = GUID.create();
         this.postFirst(this.vdata);
      }
      
      function postFirst(param1:vodData) : *
      {
         try
         {
         }
         catch(ex:*)
         {
         }
         param1.apk_version = "1.0.0.0.0.IMGOTV.1_Release";
         trace(this.vdata.apk_version);
      }
      
      private function completeHandler(param1:Event) : void
      {
         trace("submit");
      }
      
      function startRange(param1:Number) : void
      {
         this.rangeInfo = new playRange();
         this.rangeInfo.start_point = param1.toString();
         this.rangeInfo.start_time = this.getDate();
         this.rangeInfo.end_time = this.getDate();
         this.rangeInfo.end_point = param1.toString();
      }
      
      function endRange(param1:Number) : void
      {
         if(this.rangeInfo != null)
         {
            this.rangeInfo.end_time = this.getDate();
            this.rangeInfo.end_point = param1.toString();
            this.vdata.play_range.push(this.rangeInfo);
         }
      }
      
      function BeginPause(param1:Number) : void
      {
         this.pauseInfo = new playPause();
         this.pauseInfo.start_time = this.getDate();
         this.pauseInfo.pause_point = param1.toString();
         this.pauseInfo.end_time = this.getDate();
      }
      
      function EndPause() : void
      {
         if(this.pauseInfo != null)
         {
            this.pauseInfo.end_time = this.getDate();
            this.vdata.play_pause.push(this.pauseInfo);
            this.pauseInfo = null;
            this.play_pause_times = this.play_pause_times + 1;
            this.vdata.play_pause_times = this.play_pause_times.toString();
         }
      }
      
      function BeginBuff(param1:Number) : void
      {
         this.buffInfo = new playBuffer();
         this.buffInfo.start_time = this.getDate();
         this.buffInfo.buffer_point = Math.round(param1).toString();
         if(this.isFirst == true)
         {
            this.buffInfo.buffer_type = 1;
            this.isFirst = false;
         }
         else if(this.SeekStart)
         {
            this.buffInfo.buffer_type = 3;
         }
         else
         {
            this.buffInfo.buffer_type = 2;
         }
         
         this.buffInfo.end_time = this.getDate();
      }
      
      function Endbuff() : void
      {
         if(this.buffInfo != null)
         {
            this.buffInfo.end_time = this.getDate();
            this.vdata.play_buffering.push(this.buffInfo);
            this.buffInfo = null;
         }
      }
      
      function BeginBuffAuth(param1:Number) : void
      {
         this.authbuffInfo = new playBuffer();
         this.authbuffInfo.start_time = this.getDate();
         this.authbuffInfo.buffer_point = Math.round(param1).toString();
         this.authbuffInfo.buffer_type = 1;
         this.authbuffInfo.end_time = this.getDate();
      }
      
      function EndbuffAuth() : void
      {
         if(this.authbuffInfo != null)
         {
            this.authbuffInfo.end_time = this.getDate();
            this.vdata.play_buffering.push(this.authbuffInfo);
            this.authbuffInfo = null;
         }
      }
      
      public function getDate() : String
      {
         return this.toW3CDTF(new Date(),false);
      }
      
      public function toW3CDTF(param1:Date, param2:Boolean = false) : String
      {
         var _loc3_:Number = param1.getUTCDate();
         var _loc4_:Number = param1.getUTCMonth();
         var _loc5_:Number = param1.getUTCHours();
         var _loc6_:Number = param1.getUTCMinutes();
         var _loc7_:Number = param1.getUTCSeconds();
         var _loc8_:Number = param1.getUTCMilliseconds();
         var _loc9_:String = new String();
         _loc9_ = _loc9_ + param1.getUTCFullYear();
         _loc9_ = _loc9_ + "-";
         if(_loc4_ + 1 < 10)
         {
            _loc9_ = _loc9_ + "0";
         }
         _loc9_ = _loc9_ + (_loc4_ + 1);
         _loc9_ = _loc9_ + "-";
         if(_loc3_ < 10)
         {
            _loc9_ = _loc9_ + "0";
         }
         _loc9_ = _loc9_ + _loc3_;
         _loc9_ = _loc9_ + " ";
         _loc5_ = _loc5_ + 8;
         if(_loc5_ < 10)
         {
            _loc9_ = _loc9_ + "0";
         }
         _loc9_ = _loc9_ + _loc5_;
         _loc9_ = _loc9_ + ":";
         if(_loc6_ < 10)
         {
            _loc9_ = _loc9_ + "0";
         }
         _loc9_ = _loc9_ + _loc6_;
         _loc9_ = _loc9_ + ":";
         if(_loc7_ < 10)
         {
            _loc9_ = _loc9_ + "0";
         }
         _loc9_ = _loc9_ + _loc7_;
         return _loc9_;
      }
   }
}
