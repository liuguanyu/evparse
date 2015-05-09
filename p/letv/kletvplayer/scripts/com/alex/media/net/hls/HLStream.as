package com.alex.media.net.hls
{
   import flash.net.NetStream;
   import com.alex.media.error.NetStreamError;
   import com.as3.hls.flv.FLVHeader;
   import flash.utils.ByteArray;
   import com.as3.hls.plugin.HLSPlugin;
   import flash.events.TimerEvent;
   import com.as3.hls.flv.FLVTag;
   import flash.utils.Timer;
   import flash.net.NetConnection;
   import com.alex.utils.PlayerVersion;
   
   public class HLStream extends NetStream
   {
      
      private const MAX_TS_UNIT:uint = 1880000;
      
      private var packageVector:Vector.<ByteArray>;
      
      private var timer:Timer;
      
      private var plugin:HLSPlugin;
      
      public function HLStream(param1:NetConnection)
      {
         super(param1);
         if(!PlayerVersion.supportP2P)
         {
            throw new NetStreamError(NetStreamError.VERSION_ERROR);
         }
         else
         {
            return;
         }
      }
      
      override public function play(... rest) : void
      {
         throw new NetStreamError(NetStreamError.FAULT_FUNCTION);
      }
      
      override public final function close() : void
      {
         this.setLoopVideoPackage(false);
         if(this.packageVector != null)
         {
            while(this.packageVector.length > 0)
            {
               this.packageVector.shift().clear();
            }
            this.packageVector = null;
         }
         if(this.plugin != null)
         {
            this.plugin.destroy();
            this.plugin = null;
         }
         super.close();
      }
      
      public final function resetBegin() : void
      {
         this.close();
         super.play(null);
         this["appendBytesAction"]("resetBegin");
         var _loc1_:FLVHeader = new FLVHeader();
         var _loc2_:ByteArray = new ByteArray();
         _loc1_.write(_loc2_);
         this.attemptAppendBytes(_loc2_);
         if(this.plugin != null)
         {
            this.plugin.destroy();
         }
         this.plugin = new HLSPlugin();
         this.plugin.cpuControl = 20000;
         this.packageVector = new Vector.<ByteArray>();
      }
      
      public final function append(param1:ByteArray) : void
      {
         var _loc2_:ByteArray = null;
         var _loc3_:* = 0;
         if(param1 == null)
         {
            return;
         }
         if(this.plugin == null)
         {
            throw new NetStreamError(NetStreamError.APPEND_ERROR);
         }
         else
         {
            while(param1.bytesAvailable > 0)
            {
               if(this.packageVector.length == 0)
               {
                  _loc2_ = new ByteArray();
                  param1.readBytes(_loc2_,_loc2_.length,param1.bytesAvailable >= this.MAX_TS_UNIT?this.MAX_TS_UNIT:param1.bytesAvailable);
                  this.packageVector.push(_loc2_);
               }
               else
               {
                  _loc2_ = this.packageVector[this.packageVector.length - 1];
                  _loc3_ = this.MAX_TS_UNIT - _loc2_.length;
                  if(_loc3_ > 0)
                  {
                     param1.readBytes(_loc2_,_loc2_.length,param1.bytesAvailable >= _loc3_?_loc3_:param1.bytesAvailable);
                  }
                  else
                  {
                     _loc2_ = new ByteArray();
                     param1.readBytes(_loc2_,_loc2_.length,param1.bytesAvailable >= this.MAX_TS_UNIT?this.MAX_TS_UNIT:param1.bytesAvailable);
                     this.packageVector.push(_loc2_);
                  }
               }
            }
            this.setLoopVideoPackage(true);
            return;
         }
      }
      
      public final function get packageNum() : int
      {
         if(this.packageVector != null)
         {
            return this.packageVector.length;
         }
         return 0;
      }
      
      protected function onLoopVideoPackage(param1:TimerEvent) : void
      {
         var _loc2_:ByteArray = null;
         if(this.packageVector.length == 0)
         {
            return;
         }
         while(true)
         {
            _loc2_ = this.plugin.processFileSegment(this.packageVector[0]);
            if(_loc2_ != null)
            {
               this.processAndAppend(_loc2_);
               continue;
            }
            break;
         }
         if(this.packageVector[0].length == this.MAX_TS_UNIT && this.packageVector[0].bytesAvailable == 0)
         {
            this.packageVector.shift().clear();
         }
      }
      
      protected function processAndAppend(param1:ByteArray) : uint
      {
         if(!param1 || param1.length == 0)
         {
            return 0;
         }
         this.attemptAppendBytes(param1);
         return param1.length;
      }
      
      protected function onTag(param1:FLVTag) : Boolean
      {
         var _loc2_:ByteArray = new ByteArray();
         param1.write(_loc2_);
         this.attemptAppendBytes(_loc2_);
         return false;
      }
      
      protected function setLoopVideoPackage(param1:Boolean) : void
      {
         if(param1)
         {
            if(this.timer == null)
            {
               this.timer = new Timer(30);
            }
            if(!this.timer.running)
            {
               this.timer.addEventListener(TimerEvent.TIMER,this.onLoopVideoPackage);
               this.timer.reset();
               this.timer.start();
            }
         }
         else if(this.timer != null)
         {
            this.timer.removeEventListener(TimerEvent.TIMER,this.onLoopVideoPackage);
            this.timer.stop();
         }
         
      }
      
      protected function attemptAppendBytes(param1:ByteArray) : void
      {
         if(param1 != null)
         {
            this["appendBytes"](param1);
         }
      }
      
      public function refresh() : Boolean
      {
         var _loc1_:FLVHeader = null;
         var _loc2_:ByteArray = null;
         if(this.packageVector.length == 0 || this.packageVector[0].bytesAvailable == 0)
         {
            this["appendBytesAction"]("resetBegin");
            _loc1_ = new FLVHeader();
            _loc2_ = new ByteArray();
            _loc1_.write(_loc2_);
            this.attemptAppendBytes(_loc2_);
            if(this.packageVector != null)
            {
               while(this.packageVector.length > 0)
               {
                  this.packageVector.shift().clear();
               }
               this.packageVector = null;
            }
            if(this.plugin != null)
            {
               this.plugin.destroy();
               this.plugin = null;
            }
            this.plugin = new HLSPlugin();
            this.plugin.cpuControl = 20000;
            this.packageVector = new Vector.<ByteArray>();
            return true;
         }
         return false;
      }
   }
}
