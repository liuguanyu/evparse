package pptv.skin.view.ui
{
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.text.TextField;
   import flash.events.MouseEvent;
   import cn.pplive.player.utils.CommonUtils;
   import pptv.skin.view.events.SkinEvent;
   import flash.events.Event;
   
   public class SubtitleSettingUI extends MovieClip
   {
      
      private var _selectSubTitle:MovieClip = null;
      
      private var _subTitleInfo:MovieClip = null;
      
      private var _autoSubBtn:MovieClip = null;
      
      private var _subInfoBtn:MovieClip = null;
      
      private var _subSize0:MovieClip = null;
      
      private var _subSize1:MovieClip = null;
      
      private var _subSize2:MovieClip = null;
      
      private var _subSize3:MovieClip = null;
      
      private var _timeSub:SimpleButton = null;
      
      private var _timeAdd:SimpleButton = null;
      
      private var _adjustTime:TextField = null;
      
      private var _defaultBtn:SimpleButton = null;
      
      private var _tabPanel:Array;
      
      private var _subSizeArr:Array;
      
      private var _subTitleInfoArr:Array;
      
      private var _currSubTitle:int = 0;
      
      private var _currentAdjustTime:int = 0;
      
      public function SubtitleSettingUI()
      {
         this._subTitleInfoArr = [];
         super();
         this._autoSubBtn = this.getChildByName("autoSubBtn") as MovieClip;
         this._subInfoBtn = this.getChildByName("subInfoBtn") as MovieClip;
         this._subTitleInfo = this.getChildByName("subTitleInfo") as MovieClip;
         this._selectSubTitle = this.getChildByName("selectSubTitle") as MovieClip;
         this._subSize0 = this._subTitleInfo.getChildByName("size0") as MovieClip;
         this._subSize1 = this._subTitleInfo.getChildByName("size1") as MovieClip;
         this._subSize2 = this._subTitleInfo.getChildByName("size2") as MovieClip;
         this._subSize3 = this._subTitleInfo.getChildByName("size3") as MovieClip;
         this._timeAdd = this._subTitleInfo.getChildByName("timeAdd") as SimpleButton;
         this._timeSub = this._subTitleInfo.getChildByName("timeSub") as SimpleButton;
         this._adjustTime = this._subTitleInfo.getChildByName("adjustTime") as TextField;
         this._defaultBtn = this._subTitleInfo.getChildByName("defaultBtn") as SimpleButton;
         this._autoSubBtn.mouseChildren = this._subInfoBtn.mouseChildren = false;
         this._subSize0.buttonMode = this._subSize1.buttonMode = this._subSize2.buttonMode = this._subSize3.buttonMode = this._autoSubBtn.buttonMode = this._subInfoBtn.buttonMode = true;
         this._tabPanel = [{
            "mc":this._subTitleInfo,
            "tab":this._subInfoBtn
         },{
            "mc":this._selectSubTitle,
            "tab":this._autoSubBtn
         }];
         this._subSizeArr = [{
            "mc":this._subSize0,
            "size":12
         },{
            "mc":this._subSize1,
            "size":14
         },{
            "mc":this._subSize2,
            "size":28
         },{
            "mc":this._subSize3,
            "size":36
         }];
         this.init();
         this.addEvent();
      }
      
      public function setTitleListInfo(param1:Object) : void
      {
         var _loc2_:* = 0;
         var _loc3_:Object = null;
         try
         {
            if(this._subTitleInfoArr)
            {
               for(_loc3_ in this._subTitleInfoArr)
               {
                  if(this._selectSubTitle)
                  {
                     this._selectSubTitle.removeContent(this._subTitleInfoArr[_loc3_]);
                  }
               }
            }
            this._subTitleInfoArr = [];
            if(!param1)
            {
               return;
            }
            _loc2_ = 0;
            while(_loc2_ < param1.length)
            {
               this._subTitleInfoArr[_loc2_] = new RadioBox();
               this._subTitleInfoArr[_loc2_].color = "#FFFFFF";
               if(this._selectSubTitle)
               {
                  this._selectSubTitle.addChildContent(this._subTitleInfoArr[_loc2_]);
               }
               this._subTitleInfoArr[_loc2_].index = _loc2_;
               this._subTitleInfoArr[_loc2_].url = param1[_loc2_]["downloadUrl"];
               this._subTitleInfoArr[_loc2_].addEventListener("_select_",this.onRadioHandler);
               this._subTitleInfoArr[_loc2_].text = param1[_loc2_]["index"]?param1[_loc2_]["lang"] + "(" + param1[_loc2_]["index"] + ")":param1[_loc2_]["lang"];
               this._subTitleInfoArr[_loc2_].y = _loc2_ == 0?5:this._subTitleInfoArr[_loc2_ - 1].y + this._subTitleInfoArr[_loc2_ - 1].height + 5;
               if(param1[_loc2_]["lang"] == "中文" && this._currSubTitle == 0)
               {
                  this._currSubTitle = _loc2_;
               }
               _loc2_++;
            }
            this.setSelect(this._currSubTitle);
         }
         catch(e:Error)
         {
         }
      }
      
      private function init() : void
      {
         this.changeTab(this._autoSubBtn);
         this.changeSubTitleSize(this._subSize2);
      }
      
      private function addEvent() : void
      {
         this._autoSubBtn.addEventListener(MouseEvent.CLICK,this.clickHandler);
         this._subInfoBtn.addEventListener(MouseEvent.CLICK,this.clickHandler);
         this._subSize0.addEventListener(MouseEvent.CLICK,this.clickHandler);
         this._subSize1.addEventListener(MouseEvent.CLICK,this.clickHandler);
         this._subSize2.addEventListener(MouseEvent.CLICK,this.clickHandler);
         this._subSize3.addEventListener(MouseEvent.CLICK,this.clickHandler);
         this._timeSub.addEventListener(MouseEvent.CLICK,this.clickHandler);
         this._timeAdd.addEventListener(MouseEvent.CLICK,this.clickHandler);
         this._defaultBtn.addEventListener(MouseEvent.CLICK,this.clickHandler);
      }
      
      private function clickHandler(param1:MouseEvent) : void
      {
         try
         {
            switch(param1.currentTarget)
            {
               case this._autoSubBtn:
               case this._subInfoBtn:
                  this.changeTab(param1.currentTarget);
                  break;
               case this._subSize0:
               case this._subSize1:
               case this._subSize2:
               case this._subSize3:
                  this.changeSubTitleSize(param1.currentTarget);
                  break;
               case this._timeAdd:
                  this._currentAdjustTime++;
                  this.changeAdjustTime();
                  break;
               case this._timeSub:
                  this._currentAdjustTime--;
                  this.changeAdjustTime();
                  break;
               case this._defaultBtn:
                  this._currentAdjustTime = 0;
                  this.changeSubTitleSize(this._subSize2);
                  this.changeAdjustTime();
                  break;
            }
         }
         catch(e:Error)
         {
         }
      }
      
      private function changeTab(param1:Object) : void
      {
         var _loc2_:* = 0;
         var _loc3_:* = 0;
         try
         {
            _loc2_ = 0;
            _loc3_ = this._tabPanel.length;
            while(_loc2_ < _loc3_)
            {
               this._tabPanel[_loc2_]["mc"].visible = this._tabPanel[_loc2_]["tab"] == param1;
               this._tabPanel[_loc2_]["tab"]["txt"].htmlText = CommonUtils.getHtml(this._tabPanel[_loc2_]["tab"]["txt"]["text"],"#999999");
               if(this._tabPanel[_loc2_]["tab"] == param1)
               {
                  this._tabPanel[_loc2_]["tab"]["txt"].htmlText = CommonUtils.getHtml(this._tabPanel[_loc2_]["tab"]["txt"]["text"],"#FFFFFF");
               }
               _loc2_++;
            }
         }
         catch(e:Error)
         {
         }
      }
      
      private function changeAdjustTime() : void
      {
         try
         {
            this._adjustTime.text = this._currentAdjustTime + "秒";
            this.dispatchEvent(new SkinEvent(SkinEvent.MEDIA_SUBTITLE_SETTING,{"time":this._currentAdjustTime}));
         }
         catch(e:Error)
         {
         }
      }
      
      private function changeSubTitleSize(param1:Object) : void
      {
         var _loc2_:* = 0;
         var _loc3_:* = 0;
         try
         {
            _loc2_ = 0;
            _loc3_ = this._subSizeArr.length;
            while(_loc2_ < _loc3_)
            {
               this._subSizeArr[_loc2_]["mc"].gotoAndStop(1);
               if(this._subSizeArr[_loc2_]["mc"] == param1)
               {
                  this._subSizeArr[_loc2_]["mc"].gotoAndStop(2);
                  this.dispatchEvent(new SkinEvent(SkinEvent.MEDIA_SUBTITLE_SETTING,{"size":this._subSizeArr[_loc2_]["size"]}));
               }
               _loc2_++;
            }
         }
         catch(e:Error)
         {
         }
      }
      
      private function onRadioHandler(param1:Event) : void
      {
         this._currSubTitle = param1.target.index;
         this.setSelect(this._currSubTitle);
      }
      
      private function setSelect(param1:int) : void
      {
         var _loc2_:* = 0;
         try
         {
            _loc2_ = 0;
            while(_loc2_ < this._subTitleInfoArr.length)
            {
               this._subTitleInfoArr[_loc2_].select = this._subTitleInfoArr[_loc2_]["index"] == param1;
               if(this._subTitleInfoArr[_loc2_]["index"] == param1)
               {
                  this.dispatchEvent(new SkinEvent(SkinEvent.MEDIA_SUBTITLE_CHANGE,this._subTitleInfoArr[_loc2_]["url"]));
               }
               _loc2_++;
            }
         }
         catch(e:Error)
         {
         }
      }
   }
}
