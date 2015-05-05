package pptv.skin.view.ui
{
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.text.TextField;
   import flash.events.MouseEvent;
   import flash.utils.clearTimeout;
   import flash.system.System;
   import cn.pplive.player.utils.CommonUtils;
   import flash.utils.setTimeout;
   import fl.controls.RadioButtonGroup;
   import flash.events.Event;
   import pptv.skin.view.events.SkinEvent;
   
   public class ShareEditorUI extends MovieClip
   {
      
      private var _icon_arr:Array;
      
      private var _data_arr:Array;
      
      private var _icon_domain:String = null;
      
      private var _link_arr:Array;
      
      private var _timeout:uint;
      
      private var _copy_arr:Array;
      
      private const SUCCESS_TIP:String = "复制成功！请按CTRL+V复制给你的好友！";
      
      private var _copy_btn:SimpleButton;
      
      private var _addr_txt:TextField;
      
      private var $curr:int = 0;
      
      private var rbArr:Array;
      
      private var $rb:RadioButtonGroup;
      
      public function ShareEditorUI()
      {
         this._icon_arr = [];
         this._data_arr = [];
         this._link_arr = [];
         this._copy_arr = ["复制视频地址","复制Flash地址","复制HTML代码"];
         this.rbArr = [];
         super();
         this._addr_txt = this.getChildByName("addr_txt") as TextField;
         this._copy_btn = this.getChildByName("copy_btn") as SimpleButton;
         this._copy_btn.addEventListener(MouseEvent.CLICK,this.onCopyHandler);
      }
      
      private function onCopyHandler(param1:MouseEvent) : void
      {
         this.showCopyTips();
      }
      
      private function showCopyTips() : void
      {
         var $temp:String = null;
         clearTimeout(this._timeout);
         $temp = this._addr_txt.text;
         System.setClipboard($temp);
         this._addr_txt.htmlText = CommonUtils.getHtml(this.SUCCESS_TIP,"#ffffff");
         this._timeout = setTimeout(function():void
         {
            _addr_txt.htmlText = CommonUtils.getHtml($temp.replace(new RegExp("<","g"),"&lt;").replace(new RegExp(">","g"),"&gt;").replace(new RegExp("\"","g"),"&quot;"),"#ffffff");
         },1.5 * 1000);
      }
      
      public function setShare(param1:Array, param2:Object) : void
      {
         var p:String = null;
         var i:int = 0;
         var arr:Array = param1;
         var obj:Object = param2;
         if(this._icon_arr.length > 0)
         {
            for(p in this._icon_arr)
            {
               removeChild(this._icon_arr[p]);
            }
            this._icon_arr = [];
         }
         if(arr)
         {
            this._data_arr = arr;
            if(!this._icon_domain)
            {
               this._icon_domain = this._data_arr[0]["bu"].toString();
            }
            i = 1;
            while(i < this._data_arr.length)
            {
               try
               {
                  this._icon_arr[i] = new IconBox(this._icon_domain + this._data_arr[i]["ic"],20,20);
                  addChild(this._icon_arr[i]);
                  this._icon_arr[i].x = 10 + 20 * ((i - 1) % 15);
                  this._icon_arr[i].y = 10;
                  this._icon_arr[i].link = this._data_arr[i]["lk"].toString();
                  this._icon_arr[i].sapp = this._data_arr[i]["nm"].toString();
                  this._icon_arr[i].buttonMode = true;
                  this._icon_arr[i].addEventListener(MouseEvent.CLICK,this.onIconHandler);
               }
               catch(evt:Error)
               {
               }
               i++;
            }
         }
         if(obj["link"])
         {
            this._link_arr[0] = obj["link"];
         }
         if(obj["swf"])
         {
            this._link_arr[1] = obj["swf"];
            this._link_arr[2] = this.setHtml(obj["swf"]);
         }
         i = 0;
         while(i < this._copy_arr.length)
         {
            this.rbArr[i] = new RadioBox();
            addChild(this.rbArr[i]);
            this.rbArr[i].index = i;
            this.rbArr[i].addEventListener("_select_",this.onRadioHandler);
            this.rbArr[i].text = this._copy_arr[i];
            this.rbArr[i].x = i == 0?5:this.rbArr[i - 1].x + this.rbArr[i - 1].width + 5;
            this.rbArr[i].y = 50;
            i++;
         }
         this.setSelect(this.$curr);
      }
      
      private function setHtml(param1:String) : String
      {
         return "<embed src=\"" + param1 + "\" quality=\"high\" width=\"480\" height=\"400\" bgcolor=\"#000000\" align=\"middle\" allowScriptAccess=\"always\" allownetworking=\"all\" allowfullscreen=\"true\" type=\"application/x-shockwave-flash\" wmode=\"direct\" />";
      }
      
      private function onRadioHandler(param1:Event) : void
      {
         this.$curr = param1.target.index;
         this.setSelect(this.$curr);
      }
      
      private function setSelect(param1:int) : void
      {
         if(this._link_arr[param1])
         {
            this._addr_txt.htmlText = CommonUtils.getHtml(this._link_arr[param1].replace(new RegExp("<","g"),"&lt;").replace(new RegExp(">","g"),"&gt;").replace(new RegExp("\"","g"),"&quot;"),"#ffffff");
         }
         var _loc2_:* = 0;
         while(_loc2_ < this.rbArr.length)
         {
            this.rbArr[_loc2_].select = _loc2_ == param1;
            _loc2_++;
         }
      }
      
      private function onIconHandler(param1:Event) : void
      {
         this.dispatchEvent(new SkinEvent(SkinEvent.MEDIA_ICON,{
            "value":param1.currentTarget.link,
            "sapp":param1.currentTarget.sapp
         }));
      }
   }
}
