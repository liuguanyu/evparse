package pptv.skin.view.ui
{
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.text.TextField;
   import pptv.skin.view.events.SkinEvent;
   import flash.events.MouseEvent;
   
   public class AdjustUI extends MovieClip
   {
      
      private var _close_btn:SimpleButton;
      
      private var _option_mc:MovieClip;
      
      private var _share_mc:MovieClip;
      
      private var _code_mc:MovieClip;
      
      private var _sub_setting:MovieClip;
      
      private var _mcArr:Array;
      
      private var _panelArr:Array;
      
      private var _title_txt:TextField;
      
      private var _currTab:String;
      
      public function AdjustUI()
      {
         super();
         this._title_txt = this.getChildByName("title_txt") as TextField;
         this._close_btn = this.getChildByName("close_btn") as SimpleButton;
         this._close_btn.addEventListener(MouseEvent.CLICK,this.onCloseHandler);
         this._option_mc = this.getChildByName("option_mc") as MovieClip;
         this._share_mc = this.getChildByName("share_mc") as MovieClip;
         this._code_mc = this.getChildByName("code_mc") as MovieClip;
         this._sub_setting = this.getChildByName("subTitle_mc") as MovieClip;
         this._panelArr = [{
            "mc":this._option_mc,
            "title":"设置",
            "tab":"option"
         },{
            "mc":this._share_mc,
            "title":"分享",
            "tab":"share"
         },{
            "mc":this._code_mc,
            "title":"扫二维码，用手机看视频",
            "tab":"code"
         },{
            "mc":this._sub_setting,
            "title":"字幕",
            "tab":"subTitle"
         }];
      }
      
      public function init(param1:Array) : void
      {
         var _loc3_:* = 0;
         var _loc2_:* = 0;
         while(_loc2_ < param1.length)
         {
            _loc3_ = 0;
            while(_loc3_ < this._panelArr.length)
            {
               try
               {
                  if(this._panelArr[_loc3_]["mc"].name == param1[_loc2_]["mc"].name)
                  {
                     this._panelArr[_loc3_]["mc"].visible = false;
                     this._panelArr[_loc3_]["mc"].addEventListener(SkinEvent.MEDIA_ICON,this.onAdjustHandler);
                     this._panelArr[_loc3_]["mc"].addEventListener(SkinEvent.MEDIA_SETTING,this.onAdjustHandler);
                     this._panelArr[_loc3_]["mc"].addEventListener(SkinEvent.MEDIA_HUE,this.onAdjustHandler);
                     this._panelArr[_loc3_]["mc"].addEventListener(SkinEvent.MEDIA_SUBTITLE_CHANGE,this.onAdjustHandler);
                     this._panelArr[_loc3_]["mc"].addEventListener(SkinEvent.MEDIA_SUBTITLE_SETTING,this.onAdjustHandler);
                  }
               }
               catch(evt:Error)
               {
               }
               _loc3_++;
            }
            _loc2_++;
         }
      }
      
      private function onAdjustHandler(param1:SkinEvent) : void
      {
         switch(param1.type)
         {
            case SkinEvent.MEDIA_ICON:
               this.dispatchEvent(new SkinEvent(SkinEvent.MEDIA_ICON,param1.currObj));
               break;
            case SkinEvent.MEDIA_SETTING:
               this.dispatchEvent(new SkinEvent(SkinEvent.MEDIA_SETTING,param1.currObj));
               break;
            case SkinEvent.MEDIA_HUE:
               this.dispatchEvent(new SkinEvent(SkinEvent.MEDIA_HUE,param1.currObj));
               break;
            case SkinEvent.MEDIA_SUBTITLE_CHANGE:
               this.dispatchEvent(new SkinEvent(SkinEvent.MEDIA_SUBTITLE_CHANGE,param1.currObj));
               break;
            case SkinEvent.MEDIA_SUBTITLE_SETTING:
               this.dispatchEvent(new SkinEvent(SkinEvent.MEDIA_SUBTITLE_SETTING,param1.currObj));
               break;
         }
      }
      
      private function onCloseHandler(param1:MouseEvent) : void
      {
         this._option_mc["cancels"]();
         this.dispatchEvent(new SkinEvent(SkinEvent.MEDIA_ADJUST));
      }
      
      public function reset(param1:String) : void
      {
         var _loc2_:* = 0;
         var _loc3_:int = this._panelArr.length;
         while(_loc2_ < _loc3_)
         {
            if(this._panelArr[_loc2_]["mc"].name == param1)
            {
               this._title_txt.text = this._panelArr[_loc2_]["title"];
               this._currTab = this._panelArr[_loc2_]["tab"];
            }
            this._panelArr[_loc2_]["mc"].visible = this._panelArr[_loc2_]["mc"].name == param1;
            _loc2_++;
         }
      }
      
      public function setShare(param1:Array, param2:Object) : void
      {
         this._share_mc.setShare(param1,param2);
      }
      
      public function showCode(param1:String) : void
      {
         this._code_mc.showCode(param1);
      }
      
      public function setTitleListInfo(param1:Object) : void
      {
         if(this._sub_setting)
         {
            this._sub_setting.setTitleListInfo(param1);
         }
      }
      
      public function setSkipPrelude(param1:Boolean) : void
      {
         try
         {
            this._option_mc.setSkipPrelude(param1);
         }
         catch(evt:Error)
         {
         }
      }
   }
}
