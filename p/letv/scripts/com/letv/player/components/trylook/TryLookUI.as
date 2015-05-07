package com.letv.player.components.trylook
{
   import com.letv.player.components.BaseCenterDisplayPopup;
   import flash.events.MouseEvent;
   import com.letv.pluginsAPI.kernel.PayType;
   import com.letv.pluginsAPI.kernel.User;
   import flash.text.TextFormat;
   import flash.text.TextFieldAutoSize;
   import com.alex.utils.BrowserUtil;
   
   public class TryLookUI extends BaseCenterDisplayPopup
   {
      
      public static const BTN_BUY_VOD:String = "确认购买";
      
      public static const BTN_USE_TICKET:String = "确认使用";
      
      public static const BTN_BE_VIP:String = "立即开通会员";
      
      public static const BTN_VIP_FREE:String = "开通会员免费看";
      
      private var btns:Array;
      
      private var _buyVodURL:String;
      
      private var _buyBtnOriginalY:Number = 0;
      
      private var _payStatistics:Boolean;
      
      public function TryLookUI(param1:Object)
      {
         super(param1);
      }
      
      override public function show(param1:Object = null) : void
      {
         var _loc2_:* = 0;
         super.show();
         if(this._payStatistics)
         {
            R.stat.sendTrylookStat();
         }
         if(skin.buyBtn != null)
         {
            if(skin.buyBtn.hasOwnProperty("buttonMode"))
            {
               skin.buyBtn.buttonMode = true;
            }
            skin.buyBtn.addEventListener(MouseEvent.CLICK,this.onBuy);
         }
         while(_loc2_ < this.btns.length)
         {
            if(this.btns[_loc2_] != null)
            {
               this.btns[_loc2_].addEventListener(MouseEvent.CLICK,this.onClkPanelBtnClk);
            }
            _loc2_++;
         }
      }
      
      override public function hide(param1:Object = null) : void
      {
         var _loc2_:* = 0;
         if((opening) && !(stage == null))
         {
            super.hide(false);
            onHideComplete();
            if(skin.buyBtn != null)
            {
               skin.buyBtn.removeEventListener(MouseEvent.CLICK,this.onBuy);
            }
            while(_loc2_ < this.btns.length)
            {
               if(this.btns[_loc2_] != null)
               {
                  this.btns[_loc2_].removeEventListener(MouseEvent.CLICK,this.onClkPanelBtnClk);
               }
               _loc2_++;
            }
         }
      }
      
      public function usePayTicketCallBack(param1:Boolean) : void
      {
         if((skin.buyBtn) && (skin.buyBtn.loading))
         {
            skin.buyBtn.loading.visible = false;
            skin.buyBtn.loading.gotoAndStop(1);
         }
         if(param1)
         {
            this.hide();
         }
         else
         {
            mouseChildren = true;
         }
      }
      
      public function setBuyBtnStateByVip(param1:Object) : void
      {
         var vip:Boolean = false;
         var status:String = null;
         var canceltime:String = null;
         var unick:String = null;
         var value:Object = param1;
         if(value != null)
         {
            vip = value["vip"];
            status = value["status"];
            canceltime = value["canceltime"];
            try
            {
               if(value["unick"] == null)
               {
                  value["unick"] = value["uname"];
               }
               unick = value["unick"];
               unick = unick.length > 15?unick.substr(0,12) + "...":unick;
               value["unick"] = unick;
            }
            catch(e:Error)
            {
               value["unick"] = "";
            }
            if(!(skin.buyBtn == null) && !(skin.infoLabel == null))
            {
               if(value["payType"] == PayType.VOD)
               {
                  if(vip == true)
                  {
                     if(value["payTicketSize"] > 0)
                     {
                        skin.buyBtn.label.text = BTN_USE_TICKET;
                        skin.infoLabel.text = "试看已结束，继续欣赏请使用观影券。";
                        this.setPanelVisible(false,true,false);
                     }
                     else
                     {
                        this._buyVodURL = value["vodUrl"] + "";
                        skin.buyBtn.label.text = BTN_BUY_VOD;
                        skin.infoLabel.text = "试看已结束，继续欣赏请点播。";
                        this.setPanelVisible(false,false,true);
                     }
                  }
                  else
                  {
                     this._payStatistics = true;
                     skin.buyBtn.label.text = BTN_BE_VIP;
                     skin.infoLabel.text = "试看已结束，继续欣赏请开通会员。";
                     this.setPanelVisible(true,false,false);
                  }
               }
               else
               {
                  this._payStatistics = true;
                  skin.buyBtn.label.text = BTN_VIP_FREE;
                  skin.infoLabel.text = "试看已结束，继续欣赏请开通会员，免费观看。";
                  this.setPanelVisible(true,false,false);
               }
            }
            if(!(skin.nickLabel == null) && !(skin.vipTip == null))
            {
               if(status == User.NO_LOGIN)
               {
                  skin.vipTip.visible = false;
                  skin.nickLabel.text = "亲爱的用户";
               }
               else if(vip == true)
               {
                  skin.vipTip.visible = true;
                  skin.vipTip.gotoAndStop(1);
                  skin.nickLabel.text = "亲爱的 " + value["unick"];
               }
               else
               {
                  skin.vipTip.visible = true;
                  skin.vipTip.gotoAndStop(2);
                  skin.nickLabel.text = "亲爱的 " + value["unick"];
               }
               
               if(skin.vipTip.visible)
               {
                  skin.vipTip.x = skin.nickLabel.x + skin.nickLabel.width + 5;
               }
            }
            if(skin.payPanel_1.ticketSize != null)
            {
               skin.payPanel_1.ticketSize.htmlText = "<font face=\'Microsoft YaHei,微软雅黑,Arila,宋体\'>" + "您有观影券 : <b><font size=\'16\'>" + value["payTicketSize"] + "</font></b> 张" + "</font>";
            }
            if(skin.payPanel_2.normalPrice != null)
            {
               skin.payPanel_2.normalPrice.htmlText = "<font face=\'Microsoft YaHei,微软雅黑,Arila,宋体\'>" + "原价 : <b><font size=\'16\'>" + value["payPrice"] + "</font></b> 元" + "</font>";
            }
            if(skin.payPanel_2.vipPrice != null)
            {
               skin.payPanel_2.vipPrice.htmlText = "<font face=\'Microsoft YaHei,微软雅黑,Arila,宋体\'>" + "会员价 : <b><font size=\'16\'>" + value["payVipPrice"] + "</font></b> 元" + "</font>";
            }
         }
         if(value != null)
         {
            return;
         }
      }
      
      protected function setPanelVisible(param1:Boolean, param2:Boolean = false, param3:Boolean = false) : void
      {
         if(skin.clkPanel != null)
         {
            skin.clkPanel.visible = param1;
         }
         if(skin.payPanel_1 != null)
         {
            skin.payPanel_1.visible = param2;
         }
         if(skin.payPanel_2 != null)
         {
            skin.payPanel_2.visible = param3;
         }
         if(!(skin.buyBtn == null) && !(skin.line == null))
         {
            skin.buyBtn.y = param1?this._buyBtnOriginalY:skin.line.y + 30;
         }
      }
      
      override protected function initialize() : void
      {
         var format:TextFormat = null;
         super.initialize();
         try
         {
            this.btns = [skin.clkPanel.btn0,skin.clkPanel.btn1,skin.clkPanel.btn2,skin.clkPanel.btn3,skin.clkPanel.btn4,skin.clkPanel.btn5];
            format = new TextFormat();
            format.font = "Microsoft YaHei,微软雅黑,Arial,宋体";
            if(skin.vipTip != null)
            {
               skin.vipTip.visible = false;
               skin.vipTip.mouseEnabled = false;
               skin.vipTip.mouseChildren = false;
            }
            if(skin.nickLabel != null)
            {
               skin.nickLabel.mouseEnabled = false;
               skin.nickLabel.defaultTextFormat = format;
               skin.nickLabel.autoSize = TextFieldAutoSize.LEFT;
            }
            if(skin.infoLabel != null)
            {
               skin.infoLabel.defaultTextFormat = format;
               skin.infoLabel.mouseEnabled = false;
            }
            if(skin.buyBtn != null)
            {
               this._buyBtnOriginalY = skin.buyBtn.y;
               if(skin.buyBtn.hasOwnProperty("mouseChildren"))
               {
                  skin.buyBtn.mouseChildren = false;
               }
               if(skin.buyBtn.hasOwnProperty("label"))
               {
                  skin.buyBtn.label.defaultTextFormat = format;
                  skin.buyBtn.label.mouseEnabled = false;
               }
               if(skin.buyBtn.hasOwnProperty("loading"))
               {
                  skin.buyBtn.loading.gotoAndStop(1);
                  skin.buyBtn.loading.visible = false;
               }
            }
            if(skin.payPanel_1 != null)
            {
               skin.payPanel_1.mouseEnabled = false;
               skin.payPanel_1.mouseChildren = false;
               if(skin.payPanel_1.paySize != null)
               {
                  skin.payPanel_1.paySize.setTextFormat(format);
               }
            }
            if(skin.payPanel_2 != null)
            {
               skin.payPanel_2.mouseEnabled = false;
               skin.payPanel_2.mouseChildren = false;
               if(skin.payPanel_2.ticketSize != null)
               {
                  skin.payPanel_2.ticketSize.setTextFormat(format);
               }
            }
            if(skin.clkPanel != null)
            {
               skin.clkPanel.mouseEnabled = false;
            }
         }
         catch(e:Error)
         {
         }
      }
      
      private function onClkPanelBtnClk(param1:MouseEvent) : void
      {
         var event:MouseEvent = param1;
         try
         {
            switch(event.currentTarget.name)
            {
               case "btn0":
                  BrowserUtil.openBlankWindow("http://yuanxian.letv.com/list/search_1_1.html",stage);
                  break;
               case "btn1":
                  BrowserUtil.openBlankWindow("http://yuanxian.letv.com/list/search_1_0.html",stage);
                  break;
               default:
                  BrowserUtil.openBlankWindow("http://movie.letv.com/zt/dp/index.shtml#top_header_1_lf3408",stage);
            }
         }
         catch(e:Error)
         {
         }
      }
      
      private function onBuy(param1:MouseEvent) : void
      {
         var _loc2_:TryLookEvent = new TryLookEvent(TryLookEvent.BUY_VIDEO);
         var _loc3_:Object = {"type":skin.buyBtn.label.text};
         switch(param1.currentTarget.label.text)
         {
            case BTN_USE_TICKET:
               skin.buyBtn.loading.visible = true;
               skin.buyBtn.loading.gotoAndPlay(1);
               skin.mouseChildren = false;
               break;
            case BTN_BUY_VOD:
               _loc3_["data"] = this._buyVodURL;
               break;
         }
         _loc2_.dataProvider = _loc3_;
         dispatchEvent(_loc2_);
      }
   }
}
