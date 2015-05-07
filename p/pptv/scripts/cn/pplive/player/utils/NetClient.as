package cn.pplive.player.utils
{
   public class NetClient extends Object
   {
      
      private var $callback:Object;
      
      public function NetClient(param1:Object)
      {
         super();
         this.$callback = param1;
      }
      
      public function close(... rest) : void
      {
         this.forward({"close":true},"close");
      }
      
      private function forward(param1:Object, param2:String) : void
      {
         var _loc4_:* = undefined;
         param1["type"] = param2;
         var _loc3_:Object = {};
         for(_loc4_ in param1)
         {
            _loc3_[_loc4_] = param1[_loc4_];
         }
         this.$callback["onData"](_loc3_);
      }
      
      public function onRtmfpData(param1:Object) : void
      {
      }
      
      public function onBWCheck(... rest) : Number
      {
         return 0;
      }
      
      public function onBWDone(... rest) : void
      {
         if(rest.length > 0)
         {
            this.forward({"bandwidth":rest[0]},"bandwidth");
         }
      }
      
      public function onCaption(param1:String, param2:Number) : void
      {
         this.forward({
            "captions":param1,
            "speaker":param2
         },"caption");
      }
      
      public function onCaptionInfo(param1:Object) : void
      {
         this.forward(param1,"captioninfo");
      }
      
      public function onCuePoint(param1:Object) : void
      {
         this.forward(param1,"cuepoint");
      }
      
      public function onMetaData(param1:Object) : void
      {
         this.forward(param1,"metadata");
      }
      
      public function onFCSubscribe(param1:Object) : void
      {
         this.forward(param1,"fcsubscribe");
      }
      
      public function onHeaderData(param1:Object) : void
      {
         var _loc5_:String = null;
         var _loc6_:String = null;
         var _loc2_:Object = new Object();
         var _loc3_:* = "-";
         var _loc4_:* = "_";
         for(_loc5_ in param1)
         {
            _loc6_ = _loc5_.replace("-","_");
            _loc2_[_loc6_] = param1[_loc5_];
         }
         this.forward(_loc2_,"headerdata");
      }
      
      public function onImageData(param1:Object) : void
      {
         this.forward(param1,"imagedata");
      }
      
      public function onLastSecond(param1:Object) : void
      {
         this.forward(param1,"lastsecond");
      }
      
      public function onPlayStatus(param1:Object) : void
      {
         if(param1.code == "NetStream.Play.Complete")
         {
            this.forward(param1,"complete");
         }
         else
         {
            this.forward(param1,"playstatus");
         }
      }
      
      public function onXMPData(... rest) : void
      {
         this.forward(rest[0],"xmp");
      }
      
      public function RtmpSampleAccess(param1:Object) : void
      {
         this.forward(param1,"rtmpsampleaccess");
      }
      
      public function onTextData(param1:Object) : void
      {
         this.forward(param1,"textdata");
      }
   }
}