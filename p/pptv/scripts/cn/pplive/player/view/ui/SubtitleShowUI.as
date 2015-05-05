package cn.pplive.player.view.ui
{
   import flash.display.MovieClip;
   import flash.text.TextField;
   import flash.text.TextFormat;
   import flash.filters.GlowFilter;
   import flash.filters.BitmapFilterQuality;
   
   public class SubtitleShowUI extends MovieClip
   {
      
      private var _subData:Object = null;
      
      private var _subTxt:TextField;
      
      private var _curItemContent:Object;
      
      private var _h:Number = 0;
      
      private var _w:Number = 100;
      
      private var _color:uint = 16777215;
      
      private var _size:uint = 28;
      
      private var _time:int = 0;
      
      private var _setTimeInfo:Object;
      
      public function SubtitleShowUI()
      {
         super();
         this.init();
      }
      
      public function changeSubTitle(param1:Object = null) : void
      {
         try
         {
            this._subData = param1;
            this.showText();
            this._curItemContent = null;
         }
         catch(e:Error)
         {
         }
      }
      
      public function clearCurrentSub() : void
      {
         this.showText();
      }
      
      public function setSubTitleShowInfo(param1:Object = null) : void
      {
         var _loc2_:TextFormat = null;
         try
         {
            if(!param1)
            {
               return;
            }
            if(param1["size"])
            {
               this._size = param1["size"];
               _loc2_ = new TextFormat("Microsoft YaHei,微软雅黑,Arial,Tahoma",this._size,this._color);
               _loc2_.align = "center";
               this._subTxt.defaultTextFormat = _loc2_;
            }
            if(param1["time"] != undefined)
            {
               this._time = param1["time"];
            }
            this.showText();
            this._curItemContent = null;
            if(this._setTimeInfo)
            {
               this.setTime(this._setTimeInfo);
            }
         }
         catch(e:Error)
         {
         }
      }
      
      public function setTime(param1:Object) : void
      {
         var _loc2_:* = 0;
         var _loc3_:* = 0;
         var _loc4_:Object = null;
         try
         {
            if(this._subData == null || param1 == null || param1["posi"] + this._time <= 0 || this._subData["item"] == null)
            {
               return;
            }
            this._setTimeInfo = param1;
            _loc2_ = int(param1["posi"]) + this._time;
            if(this._curItemContent)
            {
               if(!(_loc2_ >= this._curItemContent.st && _loc2_ <= this._curItemContent.et))
               {
                  _loc3_ = this._subData["item"].indexOf(this._curItemContent);
                  if(_loc3_ < this._subData["item"].length - 1)
                  {
                     _loc4_ = this._subData["item"][++_loc3_];
                     if(_loc2_ > this._curItemContent.et && _loc2_ < _loc4_.st)
                     {
                        this.showText();
                     }
                     else if(_loc2_ >= _loc4_.st && _loc2_ <= _loc4_.et)
                     {
                        if(!(_loc4_.sub == null) || !(_loc4_.sub == ""))
                        {
                           this.showText(_loc4_.sub);
                        }
                        else
                        {
                           this.showText();
                        }
                        this._curItemContent = _loc4_;
                     }
                     else
                     {
                        this.searchSubItem(_loc2_);
                     }
                     
                  }
               }
            }
            else
            {
               this.searchSubItem(_loc2_);
            }
         }
         catch(err:Error)
         {
         }
      }
      
      public function resize(param1:Number = 0, param2:Number = 0) : void
      {
         this._h = param2;
         this._w = param1;
         this._subTxt.width = this._w;
         this._subTxt.y = this._h - this._subTxt.textHeight - 20;
      }
      
      private function init() : void
      {
         this._subTxt = new TextField();
         this._subTxt.autoSize = "center";
         this._subTxt.mouseEnabled = false;
         this._subTxt.wordWrap = this._subTxt.multiline = true;
         this._subTxt.width = this._w;
         var _loc1_:TextFormat = new TextFormat("Microsoft YaHei,微软雅黑,Arial,Tahoma",this._size,this._color);
         _loc1_.align = "center";
         this._subTxt.defaultTextFormat = _loc1_;
         var _loc2_:GlowFilter = new GlowFilter();
         _loc2_.blurX = 5;
         _loc2_.blurY = 5;
         _loc2_.quality = BitmapFilterQuality.LOW;
         _loc2_.color = 3355443;
         this._subTxt.filters = [_loc2_];
         addChild(this._subTxt);
      }
      
      private function searchSubItem(param1:Number = 0) : void
      {
         var _loc2_:Object = null;
         try
         {
            if(!this._subData)
            {
               return;
            }
            for each(_loc2_ in this._subData["item"])
            {
               if(param1 >= _loc2_.st && param1 <= _loc2_.et)
               {
                  this.showText(_loc2_.sub);
                  this._curItemContent = _loc2_;
                  break;
               }
            }
         }
         catch(err:Error)
         {
         }
      }
      
      private function showText(param1:String = "") : void
      {
         if(param1 == "")
         {
            this._subTxt.htmlText = "";
         }
         else
         {
            this._subTxt.text = param1;
         }
         this._subTxt.y = this._h - this._subTxt.textHeight - 20;
      }
   }
}
