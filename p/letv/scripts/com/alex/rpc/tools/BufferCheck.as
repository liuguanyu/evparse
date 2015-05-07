package com.alex.rpc.tools
{
   import flash.events.EventDispatcher;
   import flash.net.NetStream;
   import flash.utils.clearInterval;
   import flash.utils.setInterval;
   import com.alex.rpc.events.BufferCheckEvent;
   
   public class BufferCheck extends EventDispatcher
   {
      
      protected var ns:NetStream;
      
      protected var originalSize:Number = 0;
      
      private var inter:int;
      
      private const SPEED:uint = 100;
      
      public function BufferCheck(param1:NetStream)
      {
         super();
         this.ns = param1;
         this.originalSize = param1.bytesTotal;
      }
      
      public function start() : void
      {
         this.setLoop(true);
      }
      
      public function close() : void
      {
         this.setLoop(false);
         this.ns = null;
      }
      
      protected function setLoop(param1:Boolean) : void
      {
         clearInterval(this.inter);
         if(param1)
         {
            this.inter = setInterval(this.onLoop,this.SPEED);
         }
      }
      
      protected function onLoop() : void
      {
         try
         {
            if((this.ns) && (this.ns.bytesTotal > 0) && this.ns.bytesLoaded >= this.ns.bytesTotal)
            {
               this.close();
               dispatchEvent(new BufferCheckEvent(BufferCheckEvent.VIDEO_LOAD_COMPLETE));
            }
         }
         catch(e:Error)
         {
         }
      }
   }
}
