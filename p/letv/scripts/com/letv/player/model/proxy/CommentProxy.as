package com.letv.player.model.proxy
{
   import com.letv.player.facade.MyProxy;
   import com.adobe.crypto.MD5;
   import com.alex.rpc.AutoLoader;
   import com.alex.rpc.events.AutoLoaderEvent;
   import com.alex.rpc.type.ResourceType;
   import com.alex.utils.JSONUtil;
   import com.letv.player.notify.LoadNotify;
   import flash.external.ExternalInterface;
   
   public class CommentProxy extends MyProxy
   {
      
      public static const NAME:String = "commentProxy";
      
      private var loader:AutoLoader;
      
      private const URL:String = "http://api.my.letv.com/vcm/api/add?type=video";
      
      private const KEY:String = "6d57a5705b7fea57f6142ed2cf71e283";
      
      public function CommentProxy(param1:Object = null)
      {
         super(NAME,param1);
      }
      
      public function load(param1:Object) : void
      {
         var setting:Object = null;
         var info:Object = null;
         var url:String = null;
         var value:Object = param1;
         if(value == null)
         {
            this.onLoadError();
            return;
         }
         try
         {
            setting = value.setting;
            info = value.info;
            url = this.URL;
            url = url + ("&xid=" + setting["vid"]);
            url = url + ("&pid=" + setting["pid"]);
            url = url + ("&cid=" + setting["cid"]);
            url = url + ("&htime=" + value["time"]);
            url = url + ("&title=" + encodeURIComponent(setting["title"]));
            url = url + ("&imgurl=" + encodeURIComponent(info["pic"]));
            url = url + ("&content=" + encodeURIComponent(info["content"]));
            url = url + ("&imgx=" + MD5.hash(info["pic"] + this.KEY));
            url = url + ("&tn=" + Math.random());
            R.log.append(this + " load " + url);
            this.gc();
            this.loader = new AutoLoader();
            this.loader.addEventListener(AutoLoaderEvent.LOAD_COMPLETE,this.onLoadComplete);
            this.loader.addEventListener(AutoLoaderEvent.LOAD_ERROR,this.onLoadError);
            this.loader.setup([{
               "type":ResourceType.TEXT,
               "url":url
            }]);
         }
         catch(e:Error)
         {
            onLoadError("提交失败");
         }
      }
      
      private function onLoadComplete(param1:AutoLoaderEvent) : void
      {
         var obj:Object = null;
         var event:AutoLoaderEvent = param1;
         R.log.append(this + " onLoadComplete " + event.dataProvider.content);
         var error:String = "提交失败";
         try
         {
            obj = JSONUtil.decode(String(event.dataProvider.content));
            if(obj != null)
            {
               this.gc();
               if((obj.hasOwnProperty("result")) && String(obj["result"]) == "200")
               {
                  if((obj.hasOwnProperty("data")) && !(obj["data"] == null))
                  {
                     this.sendOutterScript(obj["data"][0]);
                  }
                  sendNotification(LoadNotify.COMMENT_OVER);
                  return;
               }
               error = this.getErrorInfo(obj["result"]);
            }
         }
         catch(e:Error)
         {
         }
         this.onLoadError(error);
      }
      
      private function onLoadError(param1:* = null) : void
      {
         R.log.append(this + " onLoadError " + param1,"error");
         this.gc();
         facade.removeProxy(NAME);
         if(!(param1 == null) && param1 is AutoLoaderEvent)
         {
            var param1:* = "访问异常";
         }
         sendNotification(LoadNotify.COMMENT_OVER,param1);
      }
      
      private function sendOutterScript(param1:Object) : void
      {
         var value:Object = param1;
         try
         {
            ExternalInterface.call("LETV.CommentList.addComment",value);
         }
         catch(e:Error)
         {
         }
      }
      
      private function getErrorInfo(param1:Object) : String
      {
         switch(String(param1))
         {
            case "notlogged":
               return "用户未登录";
            case "error":
               return "参数不正确";
            case "type":
               return "评论类型不正确";
            case "short":
               return "评论内容过短";
            case "long":
               return "评论内容过长";
            case "content":
               return "评论内容，最少3个字，最多140字";
            case "fail":
               return "系统错误";
            case "time":
               return "评论过于频繁";
            case "forbidIP":
               return "评论IP限制";
            case "forbidUser":
               return "评论用户限制";
            case "more":
               return "5分钟发评论超过30条";
            case "repeat":
               return "评论内容重复";
            case "size":
               return "图片尺寸不符合";
            case "format":
               return "图片格式有误";
            default:
               return "提交失败";
         }
      }
      
      private function gc() : void
      {
         if(this.loader != null)
         {
            this.loader.removeEventListener(AutoLoaderEvent.LOAD_COMPLETE,this.onLoadComplete);
            this.loader.removeEventListener(AutoLoaderEvent.LOAD_ERROR,this.onLoadError);
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
