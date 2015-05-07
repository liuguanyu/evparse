package com.letv.player.view.plugin
{
   import com.letv.player.facade.MyMediator;
   import com.letv.player.notify.RecommendNotify;
   import com.letv.player.notify.GlobalNofity;
   import com.letv.player.notify.LogicNotify;
   import com.letv.player.notify.LoadNotify;
   import org.puremvc.as3.interfaces.INotification;
   import com.letv.player.components.RecommendLoading;
   import com.letv.player.facade.MyResource;
   import com.letv.pluginsAPI.kernel.User;
   import com.letv.pluginsAPI.api.JsAPI;
   import com.letv.pluginsAPI.recommend.RecommendEvent;
   import flash.events.Event;
   
   public class RecommendMediator extends MyMediator
   {
      
      public static const NAME:String = "recommendMediator";
      
      private var _showing:Boolean;
      
      private var _hadload:Boolean;
      
      private var _loading:RecommendLoading;
      
      public function RecommendMediator(param1:Object)
      {
         super(NAME,param1);
      }
      
      override public function listNotificationInterests() : Array
      {
         return [RecommendNotify.SHOW_RECOMMEND,GlobalNofity.GLOBAL_RESIZE,LogicNotify.SET_VOLUME,LogicNotify.VIDEO_NEXT,LogicNotify.VIDEO_REPLAY,LogicNotify.VIDEO_SLEEP,LogicNotify.SEEK_TO,LoadNotify.PLUGIN_LOAD_FAILED,LoadNotify.PLUGIN_LOAD_SUCCESS];
      }
      
      override public function handleNotification(param1:INotification) : void
      {
         var notification:INotification = param1;
         try
         {
            switch(notification.getName())
            {
               case RecommendNotify.SHOW_RECOMMEND:
                  this.showRecommend();
                  break;
               case GlobalNofity.GLOBAL_RESIZE:
                  this.resizeRecommend();
                  break;
               case LogicNotify.SET_VOLUME:
                  this.setRecommendVolume(notification.getBody());
                  break;
               case LogicNotify.VIDEO_NEXT:
               case LogicNotify.VIDEO_REPLAY:
               case LogicNotify.VIDEO_SLEEP:
               case LogicNotify.SEEK_TO:
                  this.hideRecommend();
                  break;
               case LoadNotify.PLUGIN_LOAD_FAILED:
               case LoadNotify.PLUGIN_LOAD_SUCCESS:
                  this.setPlugin(notification.getName(),notification.getBody());
                  break;
            }
         }
         catch(e:Error)
         {
            R.log.append("[UI V3]RecommendMediator.handleNotification " + notification.getName() + " Error " + e.message,"error");
         }
      }
      
      override public function onRegister() : void
      {
         super.onRegister();
         this._loading = new RecommendLoading();
      }
      
      override public function onRemove() : void
      {
         super.onRemove();
         try
         {
            this.removeListener();
         }
         catch(e:Error)
         {
         }
      }
      
      private function setRecommendVolume(param1:Object) : void
      {
         if(recommend != null)
         {
            recommend.setVolume(Number(param1));
         }
      }
      
      private function setPlugin(param1:String, param2:Object) : void
      {
         var _loc3_:Object = null;
         if(param2["name"] == MyResource.RECOMMEND)
         {
            switch(param1)
            {
               case LoadNotify.PLUGIN_LOAD_FAILED:
                  this.setRecommendLoadState(0);
                  break;
               case LoadNotify.PLUGIN_LOAD_SUCCESS:
                  if((this._loading) && (this._loading.parent))
                  {
                     viewComponent.removeChild(this._loading);
                  }
                  _loc3_ = {};
                  _loc3_[MyResource.RECOMMEND] = param2["content"];
                  layer.initPlugins(_loc3_);
                  if(this._showing)
                  {
                     this.showRecommend();
                  }
                  break;
            }
         }
      }
      
      private function showRecommend() : void
      {
         var userinfo:Object = null;
         var obj:Object = null;
         this._showing = true;
         try
         {
            this._loading.visible = true;
         }
         catch(e:Error)
         {
         }
         if(recommend != null)
         {
            R.stat.sendPgvStat({
               "ref":"101010",
               "islogin":sdk.getUserinfo()["uid"]
            });
            this.addListener();
            viewComponent.addChild(recommend.surface);
            this.resizeRecommend();
            try
            {
               userinfo = sdk.getUserinfo();
               obj = sdk.getVideoSetting();
               obj["flashvars"] = R.flashvars.flashvars;
               obj["userinfo"] = userinfo;
               obj["cHei"] = R.controlbar.cHeight;
               obj["vip"] = userinfo["status"] == User.VIP_NORMAL?true:false;
               obj["idInfo"] = sdk.getIdInfo();
               recommend.startvideo(obj);
               main.browserManager.callScript(R.flashvars.callbackJs,JsAPI.SHOW_RECOMMEND);
            }
            catch(e:Error)
            {
               R.log.append("[UI V3]Call Recommend startvideo " + e.message,"error");
            }
         }
         else if(!this._hadload && !(R.plugins.recommendUrl == null))
         {
            this.setRecommendLoadState(1);
            sendNotification(LoadNotify.PLUGIN_LOAD,{
               "name":MyResource.RECOMMEND,
               "url":R.plugins.recommendUrl
            });
         }
         else
         {
            this._showing = false;
            try
            {
               this._loading.visible = false;
            }
            catch(e:Error)
            {
            }
         }
         
         if(recommend != null)
         {
            return;
         }
      }
      
      private function hideRecommend() : void
      {
         this._showing = false;
         this.setRecommendLoadState(-1);
         if(recommend != null)
         {
            this.removeListener();
            try
            {
               viewComponent.removeChild(recommend.surface);
            }
            catch(e:Error)
            {
            }
            try
            {
               recommend.stopvideo();
            }
            catch(e:Error)
            {
            }
         }
      }
      
      private function resizeRecommend() : void
      {
         if(!(this._loading == null) && (this._loading.visible))
         {
            this._loading.x = (main.width - this._loading.width) / 2;
            this._loading.y = (main.height - this._loading.height) / 2;
         }
         if(recommend != null)
         {
            recommend.setRect({
               "width":main.width,
               "height":main.height - R.controlbar.cHeight
            },{
               "width":main.width,
               "height":main.height
            });
         }
      }
      
      private function addListener() : void
      {
         recommend.addEventListener(RecommendEvent.RECOMMEND_REPLAY,this.onReplay);
         recommend.addEventListener(RecommendEvent.RECOMMEND_LOCK_TRACK,this.onLockTrack);
      }
      
      private function removeListener() : void
      {
         recommend.removeEventListener(RecommendEvent.RECOMMEND_REPLAY,this.onReplay);
         recommend.removeEventListener(RecommendEvent.RECOMMEND_LOCK_TRACK,this.onLockTrack);
      }
      
      private function onCatchLog(param1:Event) : void
      {
         R.log[param1["level"]](param1["value"],"recommend");
      }
      
      private function onReplay(param1:Event) : void
      {
         sendNotification(LogicNotify.VIDEO_REPLAY);
      }
      
      private function onLockTrack(param1:Event) : void
      {
         sendNotification(RecommendNotify.RECOMMEND_LOCK_TRACK);
      }
      
      private function setRecommendLoadState(param1:int) : void
      {
         switch(param1)
         {
            case -1:
               if(this._loading)
               {
                  this._loading.visible = false;
               }
               break;
            case 0:
               if(this._loading)
               {
                  this._loading.gotoAndStop(2);
                  viewComponent.addChild(this._loading);
               }
               break;
            case 1:
               this._hadload = true;
               if(this._loading)
               {
                  this._loading.gotoAndStop(1);
                  viewComponent.addChild(this._loading);
               }
               break;
         }
      }
   }
}
