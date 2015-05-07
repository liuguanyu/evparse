package com.letv.player.model.proxy
{
   import com.letv.player.facade.MyProxy;
   import flash.utils.Timer;
   import com.alex.rpc.AutoLoader;
   import flash.events.TimerEvent;
   import com.alex.rpc.events.AutoLoaderEvent;
   import com.alex.rpc.type.ResourceType;
   import com.alex.utils.JSONUtil;
   import com.letv.player.notify.AssistNotify;
   
   public class PushProxy extends MyProxy
   {
      
      public static const NAME:String = "pushproxy";
      
      public static const RESULT:String = "A000000";
      
      private const URL:String = "http://pc.push.platform.letv.com/pc/flash?";
      
      private var _pushTimer:Timer;
      
      private var _pushLoader:AutoLoader;
      
      public function PushProxy(param1:Object = null)
      {
         super(NAME,param1);
      }
      
      public function start(param1:int = 600000) : void
      {
         if(this._pushTimer == null)
         {
            this._pushTimer = new Timer(param1);
            this._pushTimer.addEventListener(TimerEvent.TIMER,this.loadPushData);
         }
         if(!this._pushTimer.running)
         {
            this._pushTimer.start();
            this.loadPushData();
         }
      }
      
      private function loadPushData(param1:TimerEvent = null) : void
      {
         this.gc();
         this._pushLoader = new AutoLoader();
         this._pushLoader.addEventListener(AutoLoaderEvent.LOAD_COMPLETE,this.onLoadComplete);
         this._pushLoader.setup([{
            "type":ResourceType.TEXT,
            "url":this.getUrl()
         }]);
      }
      
      private function onLoadComplete(param1:AutoLoaderEvent) : void
      {
         var obj:Object = null;
         var internaltime:int = 0;
         var str:String = null;
         var event:AutoLoaderEvent = param1;
         try
         {
            obj = JSONUtil.decode(String(event.dataProvider.content));
            if(obj != null)
            {
               this.gc();
               if(obj.code == RESULT)
               {
                  if(!(obj.data.msg.text == null) && !(obj.data.msg.linkUrl == null))
                  {
                     str = "<font face=\'Microsoft YaHei,微软雅黑,Arial\' color=\'#FFFFFF\'>" + obj.data.msg.text + "<a href=\'" + obj.data.msg.linkUrl + "\' target=\'_blank\'>，立即前往</a></font>";
                     sendNotification(AssistNotify.DISPLAY_INFOTIP,{
                        "style":str,
                        "type":"pushTip",
                        "priority":3
                     });
                  }
                  internaltime = int(obj.data.interval);
                  if(internaltime > 0)
                  {
                     this._pushTimer.delay = obj.data.interval * 1000;
                  }
                  return;
               }
            }
         }
         catch(e:Error)
         {
         }
      }
      
      private function gc() : void
      {
         if(this._pushLoader != null)
         {
            this._pushLoader.removeEventListener(AutoLoaderEvent.LOAD_COMPLETE,this.onLoadComplete);
            this._pushLoader.destroy();
            this._pushLoader = null;
         }
      }
      
      private function getUrl() : String
      {
         var _loc1_:String = this.URL;
         _loc1_ = _loc1_ + ("lc=" + layer.sdk.getIdInfo().lc);
         _loc1_ = _loc1_ + ("&uid=" + layer.sdk.getIdInfo().uid);
         _loc1_ = _loc1_ + ("&cid=" + layer.sdk.getVideoSetting().cid);
         _loc1_ = _loc1_ + ("&pid=" + layer.sdk.getVideoSetting().pid);
         _loc1_ = _loc1_ + ("&vid=" + layer.sdk.getVideoSetting().vid);
         _loc1_ = _loc1_ + ("&duration=" + layer.sdk.getVideoSetting().duration);
         _loc1_ = _loc1_ + ("&htime=" + layer.sdk.getVideoTime());
         _loc1_ = _loc1_ + "&ptype=1";
         return _loc1_;
      }
   }
}
