package com.letv.player.model.proxy
{
   import com.letv.player.facade.MyProxy;
   import com.alex.rpc.AutoLoader;
   import com.letv.player.notify.LoadNotify;
   import com.letv.player.components.displayBar.classes.videolist.VideoListPageUI;
   import com.alex.rpc.events.AutoLoaderEvent;
   import com.alex.utils.JSONUtil;
   
   public class ListNewProxy extends MyProxy
   {
      
      public static const NAME:String = "listNewProxy";
      
      private const URL:String = "http://api.letv.com/mms/out/album/videos";
      
      private var loader:AutoLoader;
      
      private var _vid:String = "";
      
      private var _listHaxe:Object;
      
      public function ListNewProxy()
      {
         this._listHaxe = {};
         super(NAME);
      }
      
      public function load(param1:Object) : void
      {
         var value:Object = param1;
         if(value.settings == null || !value.settings.hasOwnProperty("pid"))
         {
            this.onLoadListError();
            return;
         }
         var page:int = uint(value.page + 1);
         if(this._vid == value.settings["vid"])
         {
            if((this._listHaxe) && (this._listHaxe[page]))
            {
               sendNotification(LoadNotify.VIDEO_LIST_READY,this._listHaxe[page]);
               return;
            }
         }
         else
         {
            this._vid = value.settings["vid"];
            this._listHaxe = {};
         }
         var url:String = this.URL;
         url = url + ("?id=" + value.settings["pid"]);
         url = url + ("&cid=" + value.settings["cid"]);
         url = url + "&platform=pc";
         url = url + ("&page=" + page);
         url = url + ("&size=" + VideoListPageUI.MAX_NUM);
         url = url + ("&vid=" + value.settings["vid"]);
         url = url + "&queryType=1";
         R.log.append("[UI V2]Load NewVideoList " + url);
         try
         {
            this.loader = new AutoLoader();
            this.loader.addEventListener(AutoLoaderEvent.LOAD_COMPLETE,this.onLoadListComplete);
            this.loader.addEventListener(AutoLoaderEvent.LOAD_ERROR,this.onLoadListError);
            this.loader.setup([{
               "type":"text",
               "url":url,
               "page":page
            }]);
         }
         catch(e:Error)
         {
            onLoadListError(e.message);
         }
      }
      
      private function onLoadListComplete(param1:AutoLoaderEvent) : void
      {
         var result:Object = null;
         var arr:Array = null;
         var str:String = null;
         var joinMode:Boolean = false;
         var event:AutoLoaderEvent = param1;
         R.log.append("[UI V2]Load List Success");
         var page:int = int(event.dataProvider.data["page"]);
         try
         {
            str = String(event.dataProvider.content);
            result = JSONUtil.decode(str);
            if(result != null)
            {
               joinMode = (result.hasOwnProperty("model")) && String(result["model"]) == "0";
               if(result.hasOwnProperty("data"))
               {
                  arr = result["data"] as Array;
               }
               if((joinMode) && (result.hasOwnProperty("dataOther")))
               {
                  arr = arr.concat(result["dataOther"] as Array);
               }
            }
            this.gc();
         }
         catch(e:Error)
         {
            onLoadListError(e.message + "\n" + str);
            return;
         }
         this._listHaxe[page] = arr;
         sendNotification(LoadNotify.VIDEO_LIST_READY,arr);
      }
      
      private function onLoadListError(param1:* = null) : void
      {
         R.log.append("[UI V2]Load NewList Error " + param1,"error");
         this.gc();
         facade.removeProxy(NAME);
      }
      
      private function gc() : void
      {
         if(this.loader != null)
         {
            this.loader.removeEventListener(AutoLoaderEvent.LOAD_COMPLETE,this.onLoadListComplete);
            this.loader.removeEventListener(AutoLoaderEvent.LOAD_ERROR,this.onLoadListError);
            this.loader.destroy();
            this.loader = null;
         }
      }
      
      override public function onRemove() : void
      {
         super.onRemove();
         this.gc();
      }
   }
}
