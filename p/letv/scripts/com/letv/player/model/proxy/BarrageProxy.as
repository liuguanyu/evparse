package com.letv.player.model.proxy
{
   import com.letv.player.facade.MyProxy;
   import com.alex.rpc.AutoLoader;
   import com.alex.rpc.events.AutoLoaderEvent;
   import com.alex.rpc.type.ResourceType;
   import com.letv.player.notify.LoadNotify;
   import com.alex.utils.JSONUtil;
   import com.letv.barrage.Barrage;
   import com.letv.player.notify.BarrageNotify;
   
   public class BarrageProxy extends MyProxy
   {
      
      public static const UNIT:uint = 2;
      
      public static const MAX_PER_UNIT:uint = 10;
      
      public static const NAME:String = "barrageProxy";
      
      private var refreshRight:Boolean;
      
      private var list:Object;
      
      private var loader:AutoLoader;
      
      private const UPLOAD_URL:String = "http://hd.my.letv.com/danmu/add";
      
      private const DOWNLOAD_URL:String = "http://hd.my.letv.com/danmu/get";
      
      public function BarrageProxy()
      {
         super(NAME);
      }
      
      public function destroy() : void
      {
         this.uploadGC();
         this.downloadGC();
      }
      
      public function init() : void
      {
         this.refreshRight = true;
      }
      
      public function download(param1:Object) : void
      {
         var url:String = null;
         var value:Object = param1;
         if(!this.refreshRight)
         {
            return;
         }
         this.refreshRight = false;
         this.destroy();
         this.list = null;
         if(value == null)
         {
            return;
         }
         try
         {
            this.loader = new AutoLoader();
            this.loader.addEventListener(AutoLoaderEvent.LOAD_ERROR,this.onDownloadError);
            this.loader.addEventListener(AutoLoaderEvent.LOAD_COMPLETE,this.onDownloadComplete);
            url = this.DOWNLOAD_URL;
            url = url + ("?vid=" + value);
            url = url + "&amount=1000";
            url = url + ("&tn=" + Math.random());
            R.log.append(this + " download " + url);
            this.loader.setup([{
               "url":url,
               "type":ResourceType.TEXT
            }]);
         }
         catch(e:Error)
         {
            onDownloadError();
         }
      }
      
      private function onDownloadError(param1:AutoLoaderEvent = null) : void
      {
         this.list = null;
         this.destroy();
         R.log.append(this + " onDownloadError","error");
         sendNotification(LoadNotify.BARRAGE_DOWNLOAD_FAILED);
      }
      
      private function onDownloadComplete(param1:AutoLoaderEvent) : void
      {
         var obj:Object = null;
         var user:Array = null;
         var other:Array = null;
         var total:Object = null;
         var result:Object = null;
         var i:int = 0;
         var len:int = 0;
         var totalcount:int = 0;
         var item:String = null;
         var event:AutoLoaderEvent = param1;
         try
         {
            R.log.append(this + " onDownloadComplete");
            obj = JSONUtil.decode(String(event.dataProvider.content));
            if((obj.hasOwnProperty("code")) && String(obj["code"]) == "200")
            {
               if((obj.hasOwnProperty("data")) && !(obj.data == null))
               {
                  user = obj.data.user as Array;
                  other = obj.data.list as Array;
                  total = {};
                  i = 0;
                  len = 0;
                  if(user != null)
                  {
                     len = user.length;
                     i = 0;
                     while(i < len)
                     {
                        if(!((isNaN(Number(user[i].start))) || Number(user[i].start) < 0))
                        {
                           result = this.findUnit(Number(user[i].start),total);
                           if(result.value.length < MAX_PER_UNIT)
                           {
                              user[i].self = true;
                              if(user[i].type == null)
                              {
                                 user[i].type = Barrage.TYPE_TXT;
                              }
                              result.value.push(user[i]);
                           }
                        }
                        i++;
                     }
                  }
                  if(other != null)
                  {
                     len = other.length;
                     i = 0;
                     while(i < len)
                     {
                        if(!((isNaN(Number(other[i].start))) || Number(other[i].start) < 0))
                        {
                           result = this.findUnit(Number(other[i].start),total);
                           if(result.value.length < MAX_PER_UNIT)
                           {
                              if(other[i].type == null)
                              {
                                 other[i].type = Barrage.TYPE_TXT;
                              }
                              result.value.push(other[i]);
                           }
                        }
                        i++;
                     }
                  }
                  totalcount = 0;
                  for(item in total)
                  {
                     totalcount++;
                  }
                  if(total.length == 0)
                  {
                     total = null;
                  }
                  this.list = total;
                  sendNotification(LoadNotify.BARRAGE_DOWNLOAD_COMPLETE);
                  return;
               }
            }
         }
         catch(e:Error)
         {
         }
         this.onDownloadError();
      }
      
      private function findUnit(param1:Number, param2:Object) : Object
      {
         var _loc3_:int = Math.floor(param1 / UNIT);
         var _loc4_:int = UNIT * _loc3_;
         var _loc5_:int = UNIT * (_loc3_ + 1);
         var _loc6_:String = _loc4_ + "-" + _loc5_;
         if(param2[_loc6_] == null)
         {
            param2[_loc6_] = {
               "start":_loc4_,
               "stop":_loc5_,
               "value":[]
            };
         }
         return {
            "index":_loc3_,
            "name":_loc6_,
            "value":param2[_loc6_].value
         };
      }
      
      public function upload(param1:Object) : void
      {
         var url:String = null;
         var value:Object = param1;
         this.destroy();
         try
         {
            this.loader = new AutoLoader();
            this.loader.addEventListener(AutoLoaderEvent.LOAD_ERROR,this.onUploadError);
            this.loader.addEventListener(AutoLoaderEvent.LOAD_COMPLETE,this.onUploadComplete);
            url = this.UPLOAD_URL;
            url = url + ("?vid=" + value.vid);
            url = url + ("&cid=" + value.cid);
            url = url + ("&start=" + value.time);
            url = url + ("&txt=" + encodeURIComponent(value.txt));
            url = url + ("&tn=" + Math.random());
            url = url + ("&type=" + value.type);
            switch(value.type)
            {
               case Barrage.TYPE_EM:
                  url = url + ("&x=" + value.x);
                  url = url + ("&y=" + value.y);
                  break;
               case Barrage.TYPE_TXT:
                  url = url + ("&color=" + value.color);
                  break;
            }
            R.log.append(this + " upload " + url);
            this.loader.setup([{
               "url":url,
               "type":ResourceType.TEXT,
               "barrage":value
            }]);
         }
         catch(e:Error)
         {
            onUploadError();
         }
      }
      
      private function onUploadError(param1:AutoLoaderEvent = null) : void
      {
         this.destroy();
         R.log.append(this + " onUploadError");
         sendNotification(LoadNotify.BARRAGE_UPLOAD_FAILED);
      }
      
      private function onUploadComplete(param1:AutoLoaderEvent) : void
      {
         var obj:Object = null;
         var barrageType:String = null;
         var event:AutoLoaderEvent = param1;
         try
         {
            obj = JSONUtil.decode(String(event.dataProvider.content));
            barrageType = event.dataProvider.data.barrage.type;
            if(obj.hasOwnProperty("code"))
            {
               if(String(obj["code"]) == "200")
               {
                  if(barrageType == Barrage.TYPE_TXT)
                  {
                     sendNotification(LoadNotify.BARRAGE_SEND_DONE,event.dataProvider.data.barrage);
                  }
                  else
                  {
                     sendNotification(LoadNotify.BARRAGE_UPLOAD_COMPLETE);
                  }
               }
               else if(String(obj["code"]) == "402")
               {
                  if(barrageType == Barrage.TYPE_TXT)
                  {
                     sendNotification(LoadNotify.BARRAGE_SEND_FAIL);
                  }
               }
               else if(barrageType == Barrage.TYPE_TXT)
               {
                  sendNotification(LoadNotify.BARRAGE_UPLOAD_FAILED);
               }
               
               
            }
         }
         catch(e:Error)
         {
            onUploadError();
         }
      }
      
      private function downloadGC() : void
      {
         if(this.loader != null)
         {
            this.loader.removeEventListener(AutoLoaderEvent.LOAD_ERROR,this.onDownloadError);
            this.loader.removeEventListener(AutoLoaderEvent.LOAD_COMPLETE,this.onDownloadComplete);
            this.loader.destroy();
            this.loader = null;
         }
      }
      
      private function uploadGC() : void
      {
         if(this.loader != null)
         {
            this.loader.removeEventListener(AutoLoaderEvent.LOAD_ERROR,this.onUploadError);
            this.loader.removeEventListener(AutoLoaderEvent.LOAD_COMPLETE,this.onUploadComplete);
            this.loader.destroy();
            this.loader = null;
         }
      }
      
      public function add(param1:Object) : void
      {
         var _loc2_:Object = null;
         var _loc3_:String = null;
         if(!(this.list == null) && !(param1 == null))
         {
            _loc2_ = this.findUnit(param1.time,this.list);
            this.loop(param1.time);
            for(_loc3_ in this.list)
            {
               if(_loc3_ == _loc2_.name)
               {
                  if(this.list[_loc3_].value.length == MAX_PER_UNIT)
                  {
                     this.list[_loc3_].value.shift();
                  }
                  this.list[_loc3_].value.push(param1);
                  break;
               }
            }
         }
      }
      
      public function reset(param1:Boolean = false) : void
      {
         var _loc2_:Object = null;
         if(param1)
         {
            this.list = null;
            return;
         }
         if(this.list != null)
         {
            for each(_loc2_ in this.list)
            {
               _loc2_.hold = false;
            }
         }
      }
      
      public function loop(param1:Number) : void
      {
         var _loc2_:Object = null;
         if(this.list != null)
         {
            for each(_loc2_ in this.list)
            {
               if(param1 >= _loc2_.start && param1 < _loc2_.stop && !_loc2_.hold)
               {
                  _loc2_.hold = true;
                  sendNotification(BarrageNotify.BARRAGE_PUSH,_loc2_.value);
               }
            }
         }
      }
   }
}
