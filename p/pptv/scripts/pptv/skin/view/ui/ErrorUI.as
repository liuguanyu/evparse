package pptv.skin.view.ui
{
   import flash.display.MovieClip;
   import cn.pplive.player.utils.CommonUtils;
   import flash.events.TextEvent;
   import flash.events.MouseEvent;
   import pptv.skin.view.events.SkinEvent;
   import cn.pplive.player.common.VodCommon;
   
   public class ErrorUI extends MovieClip
   {
      
      public var error_mc:MovieClip;
      
      public var bg_mc:MovieClip;
      
      private var _recommend_mc:MovieClip;
      
      private var _tip_mc:MovieClip;
      
      private var $error:MovieClip;
      
      private var _groupArr:Array;
      
      private var $type:String = null;
      
      public function ErrorUI()
      {
         super();
         this.init();
      }
      
      private function init() : void
      {
         this.visible = false;
         this._groupArr = new Array();
         this.$error = this.getChildByName("error_mc") as MovieClip;
      }
      
      public function hideError() : void
      {
         this["bg_mc"].graphics.clear();
         this.visible = false;
      }
      
      public function showError(param1:Number, param2:Number, param3:Object = null) : void
      {
         var w:Number = param1;
         var h:Number = param2;
         var obj:Object = param3;
         if(obj == null)
         {
            return;
         }
         if(this.visible)
         {
            return;
         }
         this.visible = true;
         this["bg_mc"].graphics.clear();
         this["bg_mc"].graphics.beginFill(1579032);
         this["bg_mc"].graphics.drawRect(0,0,w,h);
         this["bg_mc"].graphics.endFill();
         this.$type = obj["type"];
         if(this.$type)
         {
            this.showModule(this.$type);
            if(this.$type == "error")
            {
               this.$error[this.$type + "_mc"]["tipTxt"].htmlText = CommonUtils.getHtml(obj["title"],"#ffffff",16);
               this.$error[this.$type + "_mc"]["tipTxt"].addEventListener(TextEvent.LINK,this.onTextLinkHandler);
            }
            else if(this.$type == "ppap")
            {
               this.$error[this.$type + "_mc"].buttonMode = true;
               this.$error[this.$type + "_mc"].mouseChildren = false;
               this.$error[this.$type + "_mc"].addEventListener(MouseEvent.CLICK,function(param1:MouseEvent):void
               {
                  dispatchEvent(new SkinEvent(SkinEvent.MEDIA_HREF,{
                     "value":"click",
                     "link":VodCommon.purl
                  }));
               });
            }
            
         }
         this.resize(w,h);
      }
      
      private function showModule(param1:String) : void
      {
         var _loc2_:* = 0;
         while(_loc2_ < this.$error.numChildren)
         {
            this.$error.getChildAt(_loc2_).visible = this.$error.getChildAt(_loc2_).name.indexOf(param1) != -1?true:false;
            _loc2_++;
         }
      }
      
      private function onTextLinkHandler(param1:TextEvent) : void
      {
         this.dispatchEvent(new SkinEvent(SkinEvent.MEDIA_HREF,{"value":param1.text}));
      }
      
      public function resize(param1:Number, param2:Number) : void
      {
         if(this.visible)
         {
            if(this.$type)
            {
               this.$error.x = param1 - this.$error[this.$type + "_mc"].width >> 1;
               this.$error.y = param2 - this.$error[this.$type + "_mc"].height >> 1;
            }
            this["bg_mc"].graphics.clear();
            this["bg_mc"].graphics.beginFill(1579032);
            this["bg_mc"].graphics.drawRect(0,0,param1,param2);
            this["bg_mc"].graphics.endFill();
         }
         else
         {
            this["bg_mc"].graphics.clear();
         }
      }
   }
}
