package com.letv.plugins.kernel.model.special
{
   import com.letv.plugins.kernel.interfaces.IClone;
   import flash.geom.Rectangle;
   import com.letv.plugins.kernel.controller.auth.transfer.TransferResult;
   import com.letv.plugins.kernel.controller.auth.transfer.TransferPlayData;
   
   public class VideoSetting extends BaseClone implements IClone
   {
      
      private static var _instance:VideoSetting;
      
      public var fullscreen:Boolean;
      
      public var barrage:Boolean;
      
      public var aiBufferTime:uint = 3;
      
      public var adEnabled:Boolean = true;
      
      public var shareSwf:String;
      
      public var cid:String = "0";
      
      public var pid:String;
      
      public var mmsid:String;
      
      public var total:int;
      
      public var vid:String;
      
      public var nextvid:String;
      
      public var duration:Number = 0;
      
      public var title:String;
      
      public var url:String;
      
      public var pic:String;
      
      public var trylook:Boolean;
      
      public var barrageSupport:Boolean;
      
      public var download:Object;
      
      public var definition:String;
      
      public var upDefinition:String;
      
      public var defaultDefinition:String = "auto";
      
      public var fullScale:Boolean;
      
      public var originalScale:Number = 1.33;
      
      public var currentScale:Number = 1.33;
      
      public var percent:Number = 1;
      
      public var originalRect:Rectangle;
      
      public var rect:Rectangle;
      
      public var rotation:int;
      
      public var volume:Number = 0.9;
      
      public var upVolume:Number = 0.5;
      
      public var muteBeforeVolume:Number = 1;
      
      public var jump:Boolean = true;
      
      public var continuePlay:Boolean = true;
      
      public var fullscreenInput:Boolean = false;
      
      public var color:Array;
      
      public var autoPlay:Boolean = true;
      
      public var isBp:Boolean;
      
      public var setDefinitionRecordTime:Number = 0;
      
      public var playerErrorTime:Number = -1;
      
      public var playerErrorCode:String;
      
      public var playStartType:Object;
      
      public var beforeCloseTime:Number = 0;
      
      public function VideoSetting()
      {
         this.shareSwf = ConfigData.getInstance().shareSwfUrl;
         this.originalRect = new Rectangle(0,0,640,480);
         super();
      }
      
      public static function getInstance() : VideoSetting
      {
         if(_instance == null)
         {
            _instance = new VideoSetting();
         }
         return _instance;
      }
      
      public function flushFromFlashVars(param1:Object) : void
      {
         var _loc2_:String = null;
         for(_loc2_ in param1)
         {
            if(this.hasOwnProperty(_loc2_))
            {
               this[_loc2_] = param1[_loc2_];
            }
         }
      }
      
      public function flushFromTransfer(param1:TransferResult) : void
      {
         this.barrageSupport = param1.barrageSupport;
         var _loc2_:TransferPlayData = param1.playData;
         this.nextData(_loc2_);
         this.download = _loc2_.download;
         this.pid = _loc2_.pid;
         this.cid = _loc2_.cid;
         this.vid = _loc2_.vid;
         this.total = _loc2_.total;
         this.pic = _loc2_.pic;
         this.url = _loc2_.url || "http://www.letv.com/ptv/vplay/" + this.vid + ".html";
         this.title = _loc2_.title;
         this.mmsid = _loc2_.mmsid;
         this.nextvid = _loc2_.nextvid;
         this.duration = _loc2_.duration;
         this.adEnabled = !this.trylook;
         this.shareSwf = ConfigData.getInstance().shareSwfUrl + "&id=" + this.vid;
      }
      
      private function nextData(param1:TransferPlayData) : void
      {
         var _loc2_:FlashVars = ConfigData.getInstance().flashvars;
         var _loc3_:Object = _loc2_.flashvars;
         if(_loc3_ == null)
         {
            return;
         }
         if(param1.nextvid == null && (_loc3_.hasOwnProperty("nextvid")))
         {
            param1.nextvid = _loc3_.nextvid;
         }
         if(param1.nextvid == param1.vid || param1.nextvid == "0")
         {
            param1.nextvid = null;
         }
         _loc2_.clearNextData();
      }
      
      public function clone() : Object
      {
         return super.cloneByClass(VideoSetting,this);
      }
   }
}
