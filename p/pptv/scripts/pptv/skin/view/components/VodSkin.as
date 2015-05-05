package pptv.skin.view.components
{
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.utils.getDefinitionByName;
   import flash.filters.DropShadowFilter;
   import flash.events.Event;
   import flash.geom.ColorTransform;
   import pptv.skin.view.events.SkinEvent;
   import flash.events.MouseEvent;
   import flash.display.SimpleButton;
   import cn.pplive.player.common.VodParser;
   import cn.pplive.player.view.ui.SubtitleShowUI;
   import flash.text.TextField;
   import flash.geom.Point;
   import cn.pplive.player.utils.hash.Global;
   import cn.pplive.player.utils.CommonUtils;
   import com.greensock.TweenLite;
   import com.greensock.easing.Bounce;
   import flash.filters.GlowFilter;
   import flash.filters.BitmapFilterQuality;
   import cn.pplive.player.common.VodCommon;
   import cn.pplive.player.view.ui.SmartClickPanel;
   import flash.display.DisplayObject;
   import cn.pplive.player.view.ui.ToolTips;
   
   public dynamic class VodSkin extends BaseSkin
   {
      
      private var $includeClass:IncludeClass;
      
      private var $hdis:Number = 0;
      
      private var $vdis:Number = 0;
      
      private var $light:PlayLightMc;
      
      private var $adjW:Number;
      
      private var $adjH:Number;
      
      private var $pcolor:ColorTransform;
      
      private var $loadingTxt:TextField;
      
      private var $progressEnable:Boolean = true;
      
      private var $controlEnable:Boolean = true;
      
      public function VodSkin()
      {
         super();
         Global.getInstance()["tip"] = new ToolTips();
         addChild(Global.getInstance()["tip"]);
         Global.getInstance()["tip"].bgColor = 2236962;
         Global.getInstance()["tip"].bgAlpha = 0.95;
         Global.getInstance()["tip"].cornerRadius = 0;
         Global.getInstance()["tip"].hookSize = 5;
         Global.getInstance()["tip"].spacing = 2;
         Global.getInstance()["tip"].visible = false;
         this.$light = new PlayLightMc();
         this.$light.mouseEnabled = this.$light.mouseChildren = false;
         this.$light.alpha = 0;
         this.$light.scaleX = this.$light.scaleY = 0.2;
      }
      
      private function checkValue(param1:Object, param2:String) : Boolean
      {
         if(param1["name"] == param2)
         {
            if(!(param1["value"] == undefined) && !(param1["value"].length == 0))
            {
               return true;
            }
         }
         return false;
      }
      
      public function setData(param1:Array) : void
      {
         var _controlArr:Array = null;
         var j:int = 0;
         var k:int = 0;
         var LClassMc:Class = null;
         var tempObj:Object = null;
         var m:int = 0;
         var RClassMc:Class = null;
         var _dis:Number = NaN;
         var n:int = 0;
         var HClassMc:Class = null;
         var list:Array = param1;
         var i:int = 0;
         while(i < list.length)
         {
            if(this.checkValue(list[i],"controlUI"))
            {
               _controlMc = new MovieClip();
               addChild(_controlMc);
               _controlArr = list[i]["value"] as Array;
               j = 0;
               while(j < _controlArr.length)
               {
                  if(!(_controlArr[j]["name"] == "leftUI") && !(_controlArr[j]["name"] == "rightUI"))
                  {
                     this.showUI(_controlMc,_controlArr[j]);
                  }
                  else
                  {
                     if((this.checkValue(_controlArr[j],"leftUI")) || (this.checkValue(_controlArr[j],"rightUI")))
                     {
                        if(!_contrlBgMc)
                        {
                           _contrlBgMc = new ControlBgMc();
                           _controlMc.addChild(_contrlBgMc);
                        }
                     }
                     if(this.checkValue(_controlArr[j],"leftUI"))
                     {
                        _leftMc = new Sprite();
                        _controlMc.addChild(_leftMc);
                        k = 0;
                        while(k < _controlArr[j]["value"].length)
                        {
                           try
                           {
                              LClassMc = getDefinitionByName(_controlArr[j]["value"][k]["value"]) as Class;
                              tempObj = {};
                              tempObj["mc"] = new LClassMc();
                              tempObj["name"] = _controlArr[j]["value"][k]["name"];
                              tempObj["visible"] = true;
                              _leftMc.addChild(tempObj["mc"]);
                              tempObj["mc"].name = tempObj["name"].replace(new RegExp("UI","g"),"") + "_mc";
                              if(!(_controlArr[j]["value"][k]["attr"] == undefined) && !(_controlArr[j]["value"][k]["attr"]["cu"] == undefined) && !(_controlArr[j]["value"][k]["attr"]["cu"].length == 0))
                              {
                                 tempObj["cu"] = _controlArr[j]["value"][k]["attr"]["cu"];
                              }
                              if(!(_controlArr[j]["value"][k]["attr"] == undefined) && !(_controlArr[j]["value"][k]["attr"]["ru"] == undefined) && !(_controlArr[j]["value"][k]["attr"]["ru"].length == 0))
                              {
                                 tempObj["mc"]["changeRU"](_controlArr[j]["value"][k]["attr"]["ru"]);
                              }
                              _leftArr.push(tempObj);
                              _elementNum++;
                           }
                           catch(evt:Error)
                           {
                           }
                           k++;
                        }
                        k = 0;
                        while(k < _leftArr.length)
                        {
                           _leftArr[k]["mc"].x = k == 0?0:_leftArr[k - 1]["mc"].x + _leftArr[k - 1]["mc"].width;
                           _leftArr[k]["mc"].y = 0;
                           k++;
                        }
                        _objArr = _objArr.concat(_leftArr);
                     }
                     else if(this.checkValue(_controlArr[j],"rightUI"))
                     {
                        _rightMc = new Sprite();
                        _controlMc.addChild(_rightMc);
                        m = 0;
                        while(m < _controlArr[j]["value"].length)
                        {
                           try
                           {
                              RClassMc = getDefinitionByName(_controlArr[j]["value"][m]["value"]) as Class;
                              tempObj = {};
                              tempObj["mc"] = new RClassMc();
                              tempObj["name"] = _controlArr[j]["value"][m]["name"];
                              tempObj["visible"] = true;
                              _rightMc.addChild(tempObj["mc"]);
                              tempObj["mc"].name = tempObj["name"].replace(new RegExp("UI","g"),"") + "_mc";
                              if(!(_controlArr[j]["value"][m]["attr"] == undefined) && !(_controlArr[j]["value"][m]["attr"]["cu"] == undefined) && !(_controlArr[j]["value"][m]["attr"]["cu"].length == 0))
                              {
                                 tempObj["cu"] = _controlArr[j]["value"][m]["attr"]["cu"];
                              }
                              if(!(_controlArr[j]["value"][m]["attr"] == undefined) && !(_controlArr[j]["value"][m]["attr"]["ru"] == undefined) && !(_controlArr[j]["value"][m]["attr"]["ru"].length == 0))
                              {
                                 tempObj["mc"]["changeRU"](_controlArr[j]["value"][m]["attr"]["ru"]);
                              }
                              _rightArr.push(tempObj);
                              _elementNum++;
                           }
                           catch(evt:Error)
                           {
                           }
                           m++;
                        }
                        m = 0;
                        while(m < _rightArr.length)
                        {
                           _rightArr[m]["mc"].x = m == 0?0:_rightArr[m - 1]["mc"].x + _rightArr[m - 1]["mc"].width;
                           _rightArr[m]["mc"].y = 0;
                           m++;
                        }
                        _objArr = _objArr.concat(_rightArr);
                     }
                     
                  }
                  j++;
               }
            }
            else if(this.checkValue(list[i],"handyUI"))
            {
               _handyMc = new MovieClip();
               addChild(_handyMc);
               _dis = 3;
               n = 0;
               while(n < list[i]["value"].length)
               {
                  try
                  {
                     HClassMc = getDefinitionByName(list[i]["value"][n]["value"]) as Class;
                     tempObj = {};
                     tempObj["mc"] = new HClassMc();
                     tempObj["name"] = list[i]["value"][n]["name"];
                     tempObj["visible"] = true;
                     _handyMc.addChild(tempObj["mc"]);
                     tempObj["mc"].name = tempObj["name"].replace(new RegExp("UI","g"),"") + "_mc";
                     _handyArr.push(tempObj);
                     _elementNum++;
                  }
                  catch(evt:Error)
                  {
                  }
                  n++;
               }
               n = 0;
               while(n < _handyArr.length)
               {
                  _handyArr[n]["mc"].x = 0;
                  _handyArr[n]["mc"].y = n == 0?0:_handyArr[n - 1]["mc"].y + _handyArr[n - 1]["mc"].height + 10;
                  n++;
               }
               _objArr = _objArr.concat(_handyArr);
            }
            else if(!(list[i]["value"] == undefined) && !(list[i]["value"] is Array))
            {
               this.showUI(this,list[i]);
            }
            
            
            i++;
         }
         _adjustMc = new AdjustMc();
         addChild(_adjustMc);
         _adjustMc.visible = false;
         _adjustMc.filters = [new DropShadowFilter(2,45,0,0.4,15,15,1,3)];
         this.$adjW = _adjustMc.width;
         this.$adjH = _adjustMc.height;
         addEventListener(Event.ENTER_FRAME,this.onEnterFrameHandler);
      }
      
      public function get adjW() : Number
      {
         return this.$adjW;
      }
      
      public function get adjH() : Number
      {
         return this.$adjH;
      }
      
      private function showUI(param1:Sprite, param2:Object) : void
      {
         var _loc3_:Class = null;
         var _loc4_:Object = null;
         try
         {
            _loc3_ = getDefinitionByName(param2["value"]) as Class;
            _loc4_ = {};
            _loc4_["mc"] = new _loc3_();
            _loc4_["name"] = param2["name"];
            _loc4_["visible"] = true;
            param1.addChild(_loc4_["mc"]);
            if(!(param2["attr"] == undefined) && !(param2["attr"]["ru"] == undefined) && !(param2["attr"]["ru"] == ""))
            {
               _loc4_["mc"]["changeRU"](param2["attr"]["ru"]);
            }
            _objArr.push(_loc4_);
            _elementNum++;
         }
         catch(evt:Error)
         {
         }
      }
      
      private function rebuild(param1:*) : void
      {
         var _loc2_:Array = null;
         var _loc3_:Array = null;
         var _loc4_:* = 0;
         try
         {
            if(param1["parent"] == _leftMc)
            {
               _loc2_ = _leftArr;
            }
            if(param1["parent"] == _rightMc)
            {
               _loc2_ = _rightArr;
            }
            _loc3_ = [];
            _loc4_ = 0;
            while(_loc4_ < _loc2_.length)
            {
               _loc2_[_loc4_]["mc"].x = 0;
               _loc2_[_loc4_]["mc"]["visible"] = _loc2_[_loc4_]["visible"];
               if(_loc2_[_loc4_]["visible"] == true)
               {
                  _loc3_.push(_loc2_[_loc4_]);
               }
               _loc4_++;
            }
            _loc4_ = 0;
            while(_loc4_ < _loc3_.length)
            {
               _loc3_[_loc4_]["mc"].x = _loc4_ == 0?0:_loc3_[_loc4_ - 1]["mc"].x + _loc3_[_loc4_ - 1]["mc"].width;
               _loc4_++;
            }
            this.resize(_showWidth,_showHeight);
         }
         catch(evt:Error)
         {
         }
      }
      
      private function onEnterFrameHandler(param1:Event) : void
      {
         var _loc2_:* = 0;
         if(_objArr.length == _elementNum)
         {
            removeEventListener(Event.ENTER_FRAME,this.onEnterFrameHandler);
            _loc2_ = 0;
            while(_loc2_ < _elementNum)
            {
               if(_objArr[_loc2_]["name"] == "playpauseUI")
               {
                  _playpauseMc = _objArr[_loc2_]["mc"] as MovieClip;
                  this.$pcolor = _playpauseMc["PlayBtn"].transform.colorTransform;
                  _playpauseMc.addEventListener(SkinEvent.MEDIA_PLAY,this.onClickHandler);
                  _playpauseMc.addEventListener(SkinEvent.MEDIA_PAUSE,this.onClickHandler);
                  _playpauseMc.addEventListener(MouseEvent.MOUSE_OVER,this.onMouseHandler);
                  _playpauseMc.addEventListener(MouseEvent.MOUSE_OUT,this.onMouseHandler);
               }
               if(_objArr[_loc2_]["name"] == "nextUI")
               {
                  _nextMc = _objArr[_loc2_]["mc"] as SimpleButton;
                  _nextMc.addEventListener(MouseEvent.CLICK,this.onClickHandler);
                  _nextMc.addEventListener(MouseEvent.MOUSE_OVER,this.onMouseHandler);
                  _nextMc.addEventListener(MouseEvent.MOUSE_OUT,this.onMouseHandler);
               }
               if(_objArr[_loc2_]["name"] == "timeUI")
               {
                  _timeMc = _objArr[_loc2_]["mc"] as MovieClip;
               }
               if(_objArr[_loc2_]["name"] == "soundUI")
               {
                  _soundMc = _objArr[_loc2_]["mc"] as MovieClip;
                  _soundMc.addEventListener(SkinEvent.MEDIA_SOUND,this.onClickHandler);
               }
               if(_objArr[_loc2_]["name"] == "accelerateUI")
               {
                  _accelerateMc = _objArr[_loc2_]["mc"] as MovieClip;
                  _accelerateMc.addEventListener(SkinEvent.MEDIA_ACCELERATE,this.onClickHandler);
                  _accelerateMc.addEventListener(MouseEvent.MOUSE_OVER,this.onMouseHandler);
                  _accelerateMc.addEventListener(MouseEvent.MOUSE_OUT,this.onMouseHandler);
                  _accelerateMc.addEventListener(SkinEvent.MEDIA_HREF,this.onClickHandler);
               }
               if(_objArr[_loc2_]["name"] == "hdUI")
               {
                  _hdMc = _objArr[_loc2_]["mc"] as MovieClip;
                  _hdMc.addEventListener(SkinEvent.MEDIA_STREAM,this.onClickHandler);
                  _hdMc.addEventListener(SkinEvent.MEDIA_CHANGE_STREAM,this.onClickHandler);
                  _hdMc.addEventListener(MouseEvent.MOUSE_OVER,this.onMouseHandler);
                  _hdMc.addEventListener(MouseEvent.MOUSE_OUT,this.onMouseHandler);
               }
               if(_objArr[_loc2_]["name"] == "fullScreenUI")
               {
                  _fullscreenMc = _objArr[_loc2_]["mc"] as MovieClip;
                  _fullscreenMc.addEventListener(MouseEvent.MOUSE_OVER,this.onMouseHandler);
                  _fullscreenMc.addEventListener(MouseEvent.MOUSE_OUT,this.onMouseHandler);
               }
               if(_objArr[_loc2_]["name"] == "theatreUI")
               {
                  _theatreMc = _objArr[_loc2_]["mc"] as MovieClip;
                  _theatreMc.addEventListener(MouseEvent.MOUSE_OVER,this.onMouseHandler);
                  _theatreMc.addEventListener(MouseEvent.MOUSE_OUT,this.onMouseHandler);
                  _theatreMc.addEventListener(SkinEvent.MEDIA_THEATRE,this.onClickHandler);
               }
               if(_objArr[_loc2_]["name"] == "barrageUI")
               {
                  _barrageMc = _objArr[_loc2_]["mc"] as MovieClip;
                  _barrageMc.addEventListener(SkinEvent.MEDIA_BARRAGE,this.onClickHandler);
                  _barrageMc.addEventListener(MouseEvent.MOUSE_OVER,this.onMouseHandler);
                  _barrageMc.addEventListener(MouseEvent.MOUSE_OUT,this.onMouseHandler);
               }
               if(_objArr[_loc2_]["name"] == "progressUI")
               {
                  _vodprogressMc = _objArr[_loc2_]["mc"] as MovieClip;
                  _controlMc.setChildIndex(_vodprogressMc,_controlMc.numChildren - 1);
                  _vodprogressMc.addEventListener(SkinEvent.MEDIA_VOD_POSITION,this.onClickHandler);
                  _vodprogressMc.addEventListener(SkinEvent.MEDIA_PREVIEW_SNAPSHOT,this.onClickHandler);
               }
               if(_objArr[_loc2_]["name"] == "topUI")
               {
                  _topMc = _objArr[_loc2_]["mc"] as MovieClip;
                  _topMc.addEventListener(SkinEvent.MEDIA_SEARCH,this.onClickHandler);
               }
               if(_objArr[_loc2_]["name"] == "bigPlayUI")
               {
                  _bigPlayMc = _objArr[_loc2_]["mc"] as SimpleButton;
                  _bigPlayMc.addEventListener(SkinEvent.MEDIA_PLAY,this.onClickHandler);
               }
               if(_objArr[_loc2_]["name"] == "startFreshUI")
               {
                  _startFreshMc = _objArr[_loc2_]["mc"] as MovieClip;
                  if(VodParser.hl)
                  {
                     _startFreshMc.visible = false;
                  }
               }
               if(_objArr[_loc2_]["name"] == "loadingUI")
               {
                  _loadingMc = _objArr[_loc2_]["mc"] as MovieClip;
               }
               if(_objArr[_loc2_]["name"] == "logoUI")
               {
                  _logoMc = _objArr[_loc2_]["mc"] as MovieClip;
                  if(_objArr[_loc2_]["cu"] != undefined)
                  {
                     _logoMc.link = _objArr[_loc2_]["cu"];
                     _logoMc.addEventListener(SkinEvent.MEDIA_LOGO,this.onClickHandler);
                  }
               }
               if(_objArr[_loc2_]["name"] == "errorUI")
               {
                  _errorMc = _objArr[_loc2_]["mc"] as MovieClip;
                  _errorMc.addEventListener(SkinEvent.MEDIA_HREF,this.onClickHandler);
               }
               if(_objArr[_loc2_]["name"] == "playerTipUI")
               {
                  _playerTipMc = _objArr[_loc2_]["mc"] as MovieClip;
                  _playerTipMc.addEventListener(SkinEvent.MEDIA_HREF,this.onClickHandler);
               }
               if(_objArr[_loc2_]["name"] == "optionUI")
               {
                  _optionMc = _objArr[_loc2_]["mc"] as SimpleButton;
                  _handyArr.push(_objArr[_loc2_]);
                  _optionMc.addEventListener(MouseEvent.CLICK,this.onClickHandler);
                  _optionMc.addEventListener(MouseEvent.MOUSE_OVER,this.onMouseHandler);
                  _optionMc.addEventListener(MouseEvent.MOUSE_OUT,this.onMouseHandler);
               }
               if(_objArr[_loc2_]["name"] == "codeUI")
               {
                  _codeMc = _objArr[_loc2_]["mc"] as SimpleButton;
                  _codeMc.addEventListener(MouseEvent.CLICK,this.onClickHandler);
               }
               if(_objArr[_loc2_]["name"] == "shareUI")
               {
                  _shareMc = _objArr[_loc2_]["mc"] as SimpleButton;
                  _shareMc.addEventListener(MouseEvent.CLICK,this.onClickHandler);
               }
               if(_objArr[_loc2_]["name"] == "subTitleUI")
               {
                  _subTitleMc = _objArr[_loc2_]["mc"] as SimpleButton;
                  _handyArr.push(_objArr[_loc2_]);
                  _subTitleMc.addEventListener(MouseEvent.CLICK,this.onClickHandler);
               }
               _loc2_++;
            }
            if(_startFreshMc)
            {
               this.setChildIndex(_startFreshMc,0);
            }
            if(_bigPlayMc)
            {
               this.setChildIndex(_bigPlayMc,this.numChildren - 1);
            }
            if(_errorMc)
            {
               this.setChildIndex(_errorMc,this.numChildren - 1);
            }
            if(_adjustMc)
            {
               _adjustMc.init(_handyArr);
               _adjustMc.addEventListener(SkinEvent.MEDIA_ICON,this.onClickHandler);
               _adjustMc.addEventListener(SkinEvent.MEDIA_ADJUST,this.onClickHandler);
               _adjustMc.addEventListener(SkinEvent.MEDIA_SETTING,this.onClickHandler);
               _adjustMc.addEventListener(SkinEvent.MEDIA_HUE,this.onClickHandler);
               _adjustMc.addEventListener(SkinEvent.MEDIA_SUBTITLE_CHANGE,this.onClickHandler);
               _adjustMc.addEventListener(SkinEvent.MEDIA_SUBTITLE_SETTING,this.onClickHandler);
            }
            if(_subTitleMc)
            {
               if(!_subTitleShowMc)
               {
                  _subTitleShowMc = new SubtitleShowUI();
               }
               this.addChild(_subTitleShowMc);
            }
            this.sendEvent(SkinEvent.LAYOUT_SUCCESS);
         }
      }
      
      private function onMouseHandler(param1:MouseEvent) : void
      {
         var _loc2_:TextField = null;
         var _loc3_:Point = null;
         var _loc4_:String = null;
         switch(param1.type)
         {
            case MouseEvent.MOUSE_OVER:
               addChild(Global.getInstance()["tip"]);
               Global.getInstance()["tip"].name = "buttontip";
               Global.getInstance()["tip"].source = null;
               _loc2_ = new TextField();
               _loc3_ = param1.currentTarget["parent"].localToGlobal(new Point(param1.currentTarget.x,param1.currentTarget.y));
               if(param1.target.name == "PlayBtn")
               {
                  return;
               }
               if(param1.target.name == "PauseBtn")
               {
                  _loc4_ = "暂停";
               }
               else if(param1.target.name == "FullscreenBtn")
               {
                  _loc4_ = "全屏";
               }
               else if(param1.target.name == "NormalBtn")
               {
                  _loc4_ = "退出全屏";
               }
               else if(param1.target.name == "option_mc")
               {
                  _loc4_ = "设置";
               }
               else if(param1.currentTarget.name == "hd_mc")
               {
                  _loc4_ = "清晰度";
               }
               else if(param1.target.name == "TheatreBtn")
               {
                  _loc4_ = "剧场模式";
               }
               else if(param1.target.name == "UntheatreBtn")
               {
                  _loc4_ = "默认视图";
               }
               else if(param1.target.name == "OpenBtn")
               {
                  _loc4_ = "关闭弹幕";
               }
               else if(param1.target.name == "CloseBtn")
               {
                  _loc4_ = "开启弹幕";
               }
               else if(param1.currentTarget.name == "accelerate_mc")
               {
                  _loc4_ = "加速";
               }
               else if(param1.target.name == "next_mc")
               {
                  _loc4_ = "下一集";
               }
               
               
               
               
               
               
               
               
               
               
               _loc2_.htmlText = CommonUtils.getHtml(_loc4_,"#cccccc");
               Global.getInstance()["tip"].visible = true;
               Global.getInstance()["tip"].dir = "bottom";
               Global.getInstance()["tip"].source = _loc2_;
               Global.getInstance()["tip"].x = _loc3_.x - (Global.getInstance()["tip"].width - param1.currentTarget.width) / 2 >> 0;
               if(Global.getInstance()["tip"].x + Global.getInstance()["tip"].width >= _showWidth)
               {
                  Global.getInstance()["tip"].x = _showWidth - Global.getInstance()["tip"].width - this.$hdis;
               }
               else if(Global.getInstance()["tip"].x <= 0)
               {
                  Global.getInstance()["tip"].x = this.$hdis;
               }
               
               Global.getInstance()["tip"].y = _loc3_.y - Global.getInstance()["tip"].height - 2;
               Global.getInstance()["tip"].offSet = _loc3_.x - Global.getInstance()["tip"].x + param1.currentTarget.width / 2;
               break;
            case MouseEvent.MOUSE_OUT:
               Global.getInstance()["tip"].visible = false;
               break;
         }
      }
      
      private function sendEvent(param1:String, param2:Object = null) : void
      {
         this.dispatchEvent(new SkinEvent(param1,param2));
      }
      
      private function onClickHandler(param1:*) : void
      {
         switch(param1.type)
         {
            case SkinEvent.MEDIA_ACCELERATE:
               this.sendEvent(SkinEvent.MEDIA_ACCELERATE);
               break;
            case SkinEvent.MEDIA_THEATRE:
               this.sendEvent(SkinEvent.MEDIA_THEATRE,param1.currObj);
               break;
            case SkinEvent.MEDIA_BARRAGE:
               this.sendEvent(SkinEvent.MEDIA_BARRAGE,param1.currObj);
               break;
            case SkinEvent.MEDIA_STREAM:
               this.sendEvent(SkinEvent.MEDIA_STREAM,param1.currObj);
               break;
            case SkinEvent.MEDIA_CHANGE_STREAM:
               this.sendEvent(SkinEvent.MEDIA_CHANGE_STREAM,param1.currObj);
               break;
            case SkinEvent.MEDIA_SETTING:
               _adjustMc.visible = false;
               this.sendEvent(SkinEvent.MEDIA_SETTING,param1.currObj);
               break;
            case SkinEvent.MEDIA_HUE:
               this.sendEvent(SkinEvent.MEDIA_HUE,param1.currObj);
               break;
            case SkinEvent.MEDIA_PLAY:
               this.sendEvent(SkinEvent.MEDIA_PLAY);
               break;
            case SkinEvent.MEDIA_PAUSE:
               this.sendEvent(SkinEvent.MEDIA_PAUSE);
               break;
            case SkinEvent.MEDIA_SOUND:
               this.sendEvent(SkinEvent.MEDIA_SOUND,param1.currObj);
               break;
            case SkinEvent.MEDIA_VOD_POSITION:
               this.sendEvent(SkinEvent.MEDIA_VOD_POSITION,param1.currObj);
               break;
            case SkinEvent.MEDIA_PREVIEW_SNAPSHOT:
               this.sendEvent(SkinEvent.MEDIA_PREVIEW_SNAPSHOT,param1.currObj);
               break;
            case SkinEvent.MEDIA_SEARCH:
               this.sendEvent(SkinEvent.MEDIA_SEARCH,param1.currObj);
               break;
            case SkinEvent.MEDIA_LOGO:
               this.sendEvent(SkinEvent.MEDIA_LOGO,{"value":param1.target.link});
               break;
            case SkinEvent.MEDIA_HREF:
               this.sendEvent(SkinEvent.MEDIA_HREF,param1.currObj);
               break;
            case SkinEvent.MEDIA_ICON:
               this.sendEvent(SkinEvent.MEDIA_ICON,param1.currObj);
               break;
            case SkinEvent.MEDIA_SMARTCLICK:
               this.sendEvent(SkinEvent.MEDIA_SMARTCLICK,param1.currObj);
               break;
            case SkinEvent.MEDIA_ADJUST:
               _adjustMc.visible = false;
               this.sendEvent(SkinEvent.MEDIA_ADJUST,{
                  "pos":"300003",
                  "visible":true
               });
               break;
            case SkinEvent.MEDIA_SUBTITLE_SETTING:
               this.sendEvent(SkinEvent.MEDIA_SUBTITLE_SETTING,param1.currObj);
               break;
            case SkinEvent.MEDIA_SUBTITLE_CHANGE:
               this.sendEvent(SkinEvent.MEDIA_SUBTITLE_CHANGE,param1.currObj);
               break;
            case MouseEvent.CLICK:
               if(param1.target == _nextMc)
               {
                  this.sendEvent(SkinEvent.MEDIA_NEXT);
               }
               if(param1.target == _optionMc)
               {
                  this.sendEvent(SkinEvent.MEDIA_OPTION);
               }
               else if(param1.target == _shareMc)
               {
                  this.sendEvent(SkinEvent.MEDIA_SHARE);
               }
               else if(param1.target == _codeMc)
               {
                  this.sendEvent(SkinEvent.MEDIA_CODE);
               }
               else if(param1.target == _subTitleMc)
               {
                  this.sendEvent(SkinEvent.MEDIA_SHOW_SUBSETTING);
               }
               else
               {
                  return;
               }
               
               
               
               this.openAdjustUI(param1.target.name);
               break;
         }
      }
      
      public function get isCheckControlVisible() : Boolean
      {
         try
         {
            if(!isNaN(_showWidth))
            {
               return _showWidth >= _leftMc.width + _rightMc.width;
            }
         }
         catch(evt:Error)
         {
         }
         return true;
      }
      
      public function resize(param1:Number, param2:Number) : void
      {
         var _loc3_:* = NaN;
         var _loc4_:* = NaN;
         var _loc5_:* = NaN;
         _showWidth = param1;
         _showHeight = param2;
         if(_topMc)
         {
            _topMc.x = 0;
            _topMc.y = 0;
            _topMc.resize(_showWidth);
         }
         if(_adjustMc)
         {
            _loc3_ = _showWidth;
            _loc4_ = _showHeight;
            if(_adjustMc.width > _loc3_ || _adjustMc.height > _loc4_)
            {
               _loc5_ = _adjustMc.width / _adjustMc.height;
               if(_loc3_ / _loc4_ > _loc5_)
               {
                  _adjustMc.height = _loc4_;
                  _adjustMc.width = Math.round(_adjustMc.height * _loc5_);
               }
               else
               {
                  _adjustMc.width = _loc3_;
                  _adjustMc.height = Math.round(_adjustMc.width / _loc5_);
               }
            }
            else
            {
               _adjustMc.width = this.$adjW;
               _adjustMc.height = this.$adjH;
            }
            _adjustMc.x = _loc3_ - _adjustMc.width >> 1;
            _adjustMc.y = _loc4_ - _adjustMc.height >> 1;
         }
         if(_handyMc)
         {
            _handyMc.x = _showWidth - _handyMc.width - 10;
            _handyMc.y = _showHeight - _handyMc.height >> 1;
         }
         if(_bigPlayMc)
         {
            _bigPlayMc.x = this.$hdis;
            _bigPlayMc.y = _showHeight - (_contrlBgMc?_contrlBgMc.height:0) - _bigPlayMc.height - 30;
         }
         if(_vodprogressMc)
         {
            _vodprogressMc.x = 0;
            _vodprogressMc.y = -_vodprogressMc.height;
            if(this.$progressEnable)
            {
               _vodprogressMc.width = _showWidth;
            }
         }
         if(_startFreshMc)
         {
            _startFreshMc.setSize(_showWidth,_showHeight);
         }
         if(_loadingMc)
         {
            _loadingMc.x = _showWidth - _loadingMc.width >> 1;
            _loadingMc.y = _showHeight - _loadingMc.height >> 1;
         }
         if(_errorMc)
         {
            _errorMc.resize(_showWidth,stage.displayState == "fullScreen"?_showHeight:_showHeight - (_contrlBgMc?_contrlBgMc.height:0));
         }
         if(_playerTipMc)
         {
            _playerTipMc.x = _showWidth - _playerTipMc.width >> 1;
            _playerTipMc.y = 0;
         }
         if(_controlMc)
         {
            addChild(_controlMc);
            _controlMc.x = this.$hdis;
            _controlMc.y = _showHeight - (_contrlBgMc?_contrlBgMc.height:0) - this.$vdis;
            _contrlBgMc.resize(_showWidth - this.$hdis * 2);
            if(_rightMc)
            {
               _rightMc.x = _contrlBgMc.width - _rightMc.width;
            }
         }
         if(_subTitleShowMc)
         {
            _subTitleShowMc.resize(_showWidth,_showHeight - (_contrlBgMc?_contrlBgMc.height:0) - this.$vdis);
         }
      }
      
      public function set playstate(param1:String) : void
      {
         var $local:Point = null;
         var playAnimation:Function = null;
         var attr:Object = null;
         var inObj:Object = null;
         var outObj:Object = null;
         var value:String = param1;
         if(_bigPlayMc)
         {
            _bigPlayMc.visible = false;
         }
         if(_playpauseMc)
         {
            _playpauseMc.playstate = value;
            _controlMc.addChild(this.$light);
            $local = this.globalToLocal(new Point(_playpauseMc.x,_playpauseMc.y));
            this.$light.x = $local.x + _playpauseMc.width / 2 >> 0;
            this.$light.y = $local.y + _playpauseMc.height / 2 >> 0;
            playAnimation = function(param1:Object):void
            {
               TweenLite.to($light,0.6,param1);
            };
            attr = {
               "scaleX":(value == "playing"?0.2:1),
               "scaleY":(value == "playing"?0.2:1),
               "alpha":(value == "playing"?0:1),
               "ease":Bounce.easeOut
            };
            inObj = attr;
            inObj["onComplete"] = function():void
            {
               var _loc1_:ColorTransform = new ColorTransform();
               _loc1_.color = 3381759;
               _playpauseMc["PlayBtn"].transform.colorTransform = _loc1_;
               _playpauseMc["PlayBtn"].filters = [new GlowFilter(1530524,1,8,8,1,BitmapFilterQuality.HIGH)];
               playAnimation({"rotation":360});
            };
            outObj = {
               "rotation":-360,
               "onComplete":function():void
               {
                  _playpauseMc["PlayBtn"].transform.colorTransform = $pcolor;
                  _playpauseMc["PlayBtn"].filters = null;
                  playAnimation(attr);
               }
            };
            playAnimation(value == "playing"?outObj:inObj);
         }
      }
      
      public function showError(param1:Object) : void
      {
         if(_errorMc)
         {
            _errorMc.showError(_showWidth,_showHeight - (_contrlBgMc?_contrlBgMc.height:0),param1);
         }
      }
      
      public function hideError() : void
      {
         if(_errorMc)
         {
            _errorMc.hideError();
         }
      }
      
      public function setTimeArea(param1:Object) : void
      {
         if((_vodprogressMc) && (this.$controlEnable))
         {
            _vodprogressMc.setTimeArea(param1);
         }
         if((_timeMc) && (this.$controlEnable))
         {
            _timeMc.setTimeArea(param1);
         }
      }
      
      public function setPosition(param1:Number) : void
      {
         if((_vodprogressMc) && (this.$controlEnable))
         {
            _vodprogressMc.setPosition(param1);
         }
      }
      
      public function setColumnData(param1:Object) : void
      {
         if(_vodprogressMc)
         {
            _vodprogressMc.setColumnData(param1);
         }
      }
      
      public function liveStopDrag() : void
      {
         try
         {
            _vodprogressMc.liveStopDrag();
         }
         catch(evt:Error)
         {
         }
      }
      
      public function showLoading(param1:Boolean = true, param2:Number = -1) : void
      {
         try
         {
            if(!this.$loadingTxt)
            {
               this.$loadingTxt = CommonUtils.addDynamicTxt();
               this.$loadingTxt.wordWrap = this.$loadingTxt.multiline = true;
            }
            addChild(this.$loadingTxt);
            this.$loadingTxt.width = 200;
            this.$loadingTxt.x = 10;
            this.$loadingTxt.y = _topMc?_topMc.y + _topMc.height + 15:20;
            this.$loadingTxt.htmlText = CommonUtils.getHtml(param2 > 0?"正在缓冲：" + param2.toString() + "%":"正在缓冲...","#ffffff",16);
            this.$loadingTxt.visible = param1;
         }
         catch(evt:Error)
         {
         }
         try
         {
            if(param1)
            {
               _startFreshMc.visible = false;
            }
         }
         catch(evt:Error)
         {
         }
      }
      
      public function setTitle(param1:String, param2:Boolean, param3:String) : void
      {
         if(_topMc)
         {
            _topMc.setTitle(param1,param2,param3);
         }
      }
      
      public function setSound(param1:Number) : void
      {
         try
         {
            _soundMc.setSound(param1);
         }
         catch(evt:Error)
         {
         }
      }
      
      public function setPreSnapshot(param1:Object) : void
      {
         try
         {
            _vodprogressMc.setPreSnapshot(param1);
         }
         catch(evt:Error)
         {
         }
      }
      
      public function setStream(param1:Array, param2:Number) : void
      {
         if(_hdMc)
         {
            _hdMc.setStream(param1,param2);
         }
      }
      
      public function setHdTitle(param1:int) : void
      {
         if(_hdMc)
         {
            _hdMc.setHdTitle(param1);
         }
      }
      
      public function setSkipPrelude(param1:Object = null) : void
      {
         if(_adjustMc)
         {
            _adjustMc.setSkipPrelude(param1["skip"]);
         }
         try
         {
            _vodprogressMc.setPoint(param1);
         }
         catch(evt:Error)
         {
         }
      }
      
      public function setCode(param1:String) : void
      {
         try
         {
            _adjustMc.showCode(param1);
         }
         catch(evt:Error)
         {
         }
      }
      
      public function setShare(param1:Array, param2:Object) : void
      {
         try
         {
            _adjustMc.setShare(param1,param2);
         }
         catch(evt:Error)
         {
         }
      }
      
      public function reset() : void
      {
         if(_playerTipMc)
         {
            _playerTipMc.visible = false;
         }
         if(_adjustMc)
         {
            _adjustMc.visible = false;
         }
         this.controlEnable = false;
         if(_bigPlayMc)
         {
            _bigPlayMc.mouseEnabled = true;
            _bigPlayMc.alpha = 1;
         }
         if(_playpauseMc)
         {
            _playpauseMc.mouseEnabled = _playpauseMc.mouseChildren = true;
            _playpauseMc.alpha = 1;
         }
      }
      
      public function set soundEnable(param1:Boolean) : void
      {
         if(_soundMc)
         {
            _soundMc.mouseChildren = _soundMc.mouseEnabled = param1;
            _soundMc.alpha = param1?1:0.2;
         }
      }
      
      public function set progressEnable(param1:Boolean) : void
      {
         this.$progressEnable = param1;
         if(_vodprogressMc)
         {
            _vodprogressMc.mouseChildren = _vodprogressMc.mouseEnabled = param1;
            _vodprogressMc.alpha = param1?1:0.2;
            if(!param1)
            {
               _vodprogressMc.reset();
            }
         }
         this.timeEnable = param1;
      }
      
      public function set timeEnable(param1:Boolean) : void
      {
         if(_timeMc)
         {
            _timeMc.mouseEnabled = _timeMc.mouseChildren = param1;
            _timeMc.alpha = param1?1:0.2;
            if(!param1)
            {
               _timeMc.reset();
            }
         }
      }
      
      public function get controlEnable() : Boolean
      {
         return this.$controlEnable;
      }
      
      public function set controlEnable(param1:Boolean) : void
      {
         this.$controlEnable = param1;
         if(_bigPlayMc)
         {
            _bigPlayMc.mouseEnabled = param1;
            _bigPlayMc.alpha = param1?1:0.2;
         }
         if(_playpauseMc)
         {
            _playpauseMc.mouseEnabled = _playpauseMc.mouseChildren = param1;
            _playpauseMc.alpha = param1?1:0.2;
         }
         if(_optionMc)
         {
            _optionMc.mouseEnabled = param1;
            _optionMc.alpha = param1?1:0.2;
         }
         if(_hdMc)
         {
            _hdMc.mouseEnabled = _hdMc.mouseChildren = param1;
            _hdMc.alpha = param1?1:0.2;
         }
         if(_barrageMc)
         {
            _barrageMc.mouseEnabled = _barrageMc.mouseChildren = param1;
            _barrageMc.alpha = param1?1:0.2;
         }
         if(_accelerateMc)
         {
            _accelerateMc.mouseEnabled = _accelerateMc.mouseChildren = param1;
            _accelerateMc.alpha = param1?1:0.2;
         }
         if(_subTitleMc)
         {
            _subTitleMc.mouseEnabled = param1;
            _subTitleMc.alpha = param1?1:0.2;
         }
         this.progressEnable = this.$controlEnable;
      }
      
      public function setBarrage(param1:Object = null) : void
      {
         var _loc2_:* = 0;
         var _loc3_:* = false;
         try
         {
            this.sendEvent(SkinEvent.MEDIA_SETUP_BARRAGE,{"mode":Number(Boolean(_barrageMc && param1))});
            _loc2_ = 0;
            while(_loc2_ < _objArr.length)
            {
               if(_objArr[_loc2_]["mc"] == _barrageMc)
               {
                  _objArr[_loc2_]["visible"] = Boolean(param1);
                  if(param1)
                  {
                     _barrageMc.mouseEnabled = _barrageMc.mouseChildren = true;
                     _barrageMc.alpha = 1;
                     _loc3_ = param1["display"];
                     if(VodCommon.cookie.contains("default_display"))
                     {
                        _loc3_ = VodCommon.cookie.getData("default_display");
                     }
                     _barrageMc.setBarrage(_loc3_);
                     VodCommon.cookie.setData("default_display",_loc3_);
                  }
                  this.rebuild(_barrageMc);
                  break;
               }
               _loc2_++;
            }
         }
         catch(evt:Error)
         {
         }
      }
      
      public function setPlayerTip(param1:Object = null) : void
      {
         if(_playerTipMc)
         {
            addChild(_playerTipMc);
            _playerTipMc.visible = true;
            if(param1)
            {
               _playerTipMc.setObj(param1);
            }
            _playerTipMc.x = Math.floor((_showWidth - _playerTipMc.width) / 2);
         }
      }
      
      public function setDisplayState(param1:Boolean) : void
      {
         if(_fullscreenMc)
         {
            _fullscreenMc.setDisplayState(param1);
         }
         if((_vodprogressMc) && (this.$controlEnable))
         {
            _vodprogressMc.setColumnState(param1);
         }
      }
      
      public function setTheatre(param1:Boolean) : void
      {
         if(_theatreMc)
         {
            _theatreMc.setTheatre(param1);
         }
      }
      
      public function setAccelerateState(param1:Object = null) : void
      {
         var _loc2_:* = 0;
         try
         {
            _loc2_ = 0;
            while(_loc2_ < _objArr.length)
            {
               if(_objArr[_loc2_]["mc"] == _accelerateMc)
               {
                  _objArr[_loc2_]["visible"] = Boolean(param1);
                  if(param1)
                  {
                     _accelerateMc.setAccelerateState(param1);
                  }
                  this.rebuild(_accelerateMc);
                  break;
               }
               _loc2_++;
            }
         }
         catch(evt:Error)
         {
         }
      }
      
      public function setAccSpeed(param1:Object) : void
      {
         if(_accelerateMc)
         {
            _accelerateMc.setAccSpeed(param1);
         }
      }
      
      public function smartClickData(param1:Object = null) : void
      {
         try
         {
            if(!_smartClickPanel)
            {
               _smartClickPanel = new SmartClickPanel();
               _smartClickPanel.addEventListener(SkinEvent.MEDIA_SMARTCLICK,this.onClickHandler);
               this.addChild(_smartClickPanel);
            }
            _smartClickPanel.resize(Global.getInstance()["rect"]);
            _smartClickPanel.smartClickData = param1 as Array;
         }
         catch(e:Event)
         {
         }
      }
      
      public function smartClickPanelVisible(param1:Object) : void
      {
         if(_smartClickPanel)
         {
            _smartClickPanel.visible = param1;
         }
      }
      
      public function setSmartClickTime(param1:Number) : void
      {
         if(_smartClickPanel)
         {
            _smartClickPanel.playTime = param1;
         }
      }
      
      public function openAdjustUI(param1:String) : void
      {
         if(_adjustMc)
         {
            _adjustMc.visible = true;
            _adjustMc.reset(param1);
            this.sendEvent(SkinEvent.MEDIA_ADJUST,{
               "pos":"300003",
               "visible":false
            });
         }
      }
      
      public function uiShareDisable(param1:Boolean = false) : void
      {
         var _loc3_:* = undefined;
         var _loc2_:Array = [];
         if(_shareMc)
         {
            _loc2_.push(_shareMc);
         }
         if(_codeMc)
         {
            _loc2_.push(_codeMc);
         }
         for each(_loc3_ in _loc2_)
         {
            _loc3_.alpha = param1?0.4:1;
            _loc3_.enabled = _loc3_.mouseChildren = _loc3_.mouseEnabled = !param1;
         }
      }
      
      public function changeSubTitle(param1:Object = null) : void
      {
         if(_subTitleShowMc)
         {
            _subTitleShowMc.changeSubTitle(param1);
         }
      }
      
      public function setSubTitleShowInfo(param1:Object = null) : void
      {
         if(_subTitleShowMc)
         {
            _subTitleShowMc.setSubTitleShowInfo(param1);
         }
      }
      
      public function setTitleListInfo(param1:Object) : void
      {
         if(_adjustMc)
         {
            _adjustMc.setTitleListInfo(param1);
         }
         var _loc2_:* = 0;
         while(_loc2_ < _objArr.length)
         {
            if(_objArr[_loc2_]["mc"] == _subTitleMc)
            {
               _objArr[_loc2_]["visible"] = Boolean(param1);
               this.rebuild(_subTitleMc);
            }
            _loc2_++;
         }
      }
      
      public function setSubTitlePosition(param1:Object) : void
      {
         if(_subTitleShowMc)
         {
            _subTitleShowMc.setTime(param1);
         }
      }
      
      public function clearCurrentSub() : void
      {
         if(_subTitleShowMc)
         {
            _subTitleShowMc.clearCurrentSub();
         }
      }
      
      public function get adjustMc() : MovieClip
      {
         return _adjustMc;
      }
      
      public function get startFreshMc() : MovieClip
      {
         return _startFreshMc;
      }
      
      public function get bigPlayMc() : SimpleButton
      {
         return _bigPlayMc;
      }
      
      public function get barrageMc() : MovieClip
      {
         return _barrageMc;
      }
      
      public function get smartClickPanel() : SmartClickPanel
      {
         return _smartClickPanel;
      }
      
      public function get controlMc() : MovieClip
      {
         return _controlMc;
      }
      
      public function get handyMc() : MovieClip
      {
         return _handyMc;
      }
      
      public function get topMc() : MovieClip
      {
         return _topMc;
      }
      
      public function get loadingMc() : DisplayObject
      {
         return this.$loadingTxt;
      }
      
      public function get subTitleMc() : DisplayObject
      {
         return _subTitleMc;
      }
      
      public function get disH() : Number
      {
         return _contrlBgMc?_contrlBgMc.height:0;
      }
   }
}
