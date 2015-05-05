package cn.pplive.player.view
{
   import org.puremvc.as3.multicore.utilities.fabrication.patterns.mediator.FlashMediator;
   import flash.display.Stage;
   import flash.display.MovieClip;
   import cn.pplive.player.utils.hash.Global;
   import cn.pplive.player.common.*;
   import cn.pplive.player.dac.*;
   import cn.pplive.player.manager.*;
   import cn.pplive.player.utils.*;
   import org.puremvc.as3.multicore.interfaces.INotification;
   import cn.pplive.player.view.source.CTXQuery;
   import flash.events.Event;
   import cn.pplive.player.events.PPLiveEvent;
   
   public class BarrageMediator extends FlashMediator
   {
      
      public static const NAME:String = "barrage_mediator";
      
      private var $content = null;
      
      private var $infoObj:Object;
      
      public function BarrageMediator(param1:String = null, param2:Object = null)
      {
         super(param1,param2);
      }
      
      public function get stage() : Stage
      {
         return this.view.stage;
      }
      
      public function get view() : MovieClip
      {
         return viewComponent as MovieClip;
      }
      
      override public function onRegister() : void
      {
         Global.getInstance()["setBarrageInfo"] = this.setBarrageInfo;
         Global.getInstance()["sendBarrage"] = this.sendBarrage;
      }
      
      public function respondToVodBarrageFailed(param1:INotification) : void
      {
         PrintDebug.Trace("弹幕请求失败  ====>>>>");
         ViewManager.getInstance().getMediator("skin").skin.setBarrage();
      }
      
      public function respondToVodBarrageSuccess(param1:INotification) : void
      {
         ViewManager.getInstance().getMediator("skin").skin.setBarrage(VodPlay.barrage);
         this.$content = param1.getBody();
         if(ViewManager.getInstance().getMediator("skin").skin.topMc)
         {
            this.$content.y = 50;
         }
         this.$content.addEventListener("login",this.onBarrageHandler);
         this.$content.addEventListener("playbarrage",this.onBarrageHandler);
         try
         {
            this.$content.ctx = CTXQuery.cctx;
         }
         catch(evt:Error)
         {
         }
         this.setBarrageInfo();
         PrintDebug.Trace("弹幕容器加载完毕  ====>>>>");
         if(VodPlay.barrage)
         {
            this.destroy(true);
         }
         this.visible = VodCommon.barrageDisplay;
         this.setSize(VodCommon.playerWidth,VodCommon.playerHeight);
      }
      
      private function onBarrageHandler(param1:Event) : void
      {
         switch(param1.type)
         {
            case "login":
               InteractiveManager.sendEvent(PPLiveEvent.VOD_ONVIP_VALIDATE,"5");
               sendNotification(DACNotification.ADDOBJECTVALUE,{
                  "at":DACCommon.B_CLK,
                  "time":Math.floor(new Date().getTime() / 1000),
                  "pos1":DACCommon.B_BARRAGE_LOGIN
               },DACCommon.BEHA);
               break;
            case "playbarrage":
               InteractiveManager.sendEvent(PPLiveEvent.VOD_ONNOTIFICATION,{
                  "header":{"type":"playbarrage"},
                  "body":{"data":this.$content["barrageData"]}
               });
               break;
         }
      }
      
      private function sendBarrage(param1:Object) : void
      {
         try
         {
            this.$content.sendBarrage(param1);
         }
         catch(evt:Error)
         {
         }
      }
      
      private function setBarrageInfo(param1:Object = null) : void
      {
         var _loc2_:* = undefined;
         if(!this.$infoObj)
         {
            this.$infoObj = {"version":VodCommon.version};
         }
         if(VodParser.cid)
         {
            this.$infoObj["cid"] = VodParser.cid;
         }
         if(Global.getInstance()["userInfo"])
         {
            if(!this.$infoObj["token"])
            {
               this.$infoObj["token"] = Global.getInstance()["userInfo"]["ppToken"];
            }
            if(!this.$infoObj["username"])
            {
               this.$infoObj["username"] = VodParser.un;
            }
         }
         else
         {
            delete this.$infoObj["token"];
            true;
            delete this.$infoObj["username"];
            true;
         }
         if(param1)
         {
            for(_loc2_ in param1)
            {
               this.$infoObj[_loc2_] = param1[_loc2_];
            }
         }
         PrintDebug.Trace("设置弹幕相关信息  >>>>>  ",this.$infoObj);
         if(this.$content)
         {
            this.$content.setBarrageInfo(this.$infoObj);
         }
      }
      
      public function playBarrage() : void
      {
         PrintDebug.Trace("弹幕播放  ====>>>>");
         if(this.$content)
         {
            this.$content.playBarrage();
         }
      }
      
      public function pauseBarrage() : void
      {
         PrintDebug.Trace("弹幕暂停  ====>>>>");
         if(this.$content)
         {
            this.$content.pauseBarrage();
         }
      }
      
      public function clearBarrage() : void
      {
         PrintDebug.Trace("直播内seek，弹幕清屏  ====>>>>");
         if(this.$content)
         {
            this.$content.clearBarrage();
         }
      }
      
      public function destroy(param1:Boolean = false) : void
      {
         if(this.$content)
         {
            this.$content.destroy();
            PrintDebug.Trace("弹幕销毁  ====>>>>");
            this.view.addChild(this.$content);
            if(Global.getInstance()["player"])
            {
               this.view.setChildIndex(this.$content,this.view.getChildIndex(Global.getInstance()["player"]) + 1);
            }
            if(param1)
            {
               this.$content.create("vod");
               if(VodCommon.playstate == "playing")
               {
                  this.playBarrage();
               }
               else
               {
                  this.pauseBarrage();
               }
               PrintDebug.Trace("弹幕重建  ====>>>>");
            }
         }
      }
      
      public function seekBarrage(param1:Number) : void
      {
         if(this.$content)
         {
            this.$content.seekBarrage(param1 * 10);
         }
      }
      
      public function setSize(param1:Number, param2:Number) : void
      {
         if(this.$content)
         {
            this.$content.setSize(param1,param2 - (ViewManager.getInstance().getMediator("skin").skin.topMc?60:10));
         }
      }
      
      public function set visible(param1:Boolean) : void
      {
         try
         {
            this.$content.visible = param1;
         }
         catch(evt:Error)
         {
         }
      }
      
      public function get content() : *
      {
         return this.$content;
      }
   }
}
