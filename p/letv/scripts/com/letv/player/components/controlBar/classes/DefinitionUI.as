package com.letv.player.components.controlBar.classes
{
   import com.letv.player.components.BaseConfigComponent;
   import com.letv.pluginsAPI.kernel.DefinitionType;
   import com.alex.controls.RadioButtonGroup2;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import com.letv.player.components.controlBar.events.ControlBarEvent;
   import com.greensock.TweenLite;
   import com.letv.player.model.stat.LetvStatistics;
   import com.alex.utils.BrowserUtil;
   import flash.display.MovieClip;
   
   public class DefinitionUI extends BaseConfigComponent
   {
      
      private var _opening:Boolean;
      
      private var _currentGroup:MovieClip;
      
      private var _defaultGroup:RadioButtonGroup2;
      
      private var _unitHeight:uint = 0;
      
      private var _unitWidth:uint = 0;
      
      private var defaultSkins:Array;
      
      private var defaultVipSkins:Array;
      
      private var newLevelStack:Array;
      
      private var payLevelStack:Array;
      
      private var _currentDefinition:String;
      
      private var _animation:MovieClip;
      
      private var _lastDefinition:int;
      
      public function DefinitionUI(param1:Object)
      {
         super(param1);
      }
      
      override public function get width() : Number
      {
         if(skin.select != null)
         {
            return skin.select.width;
         }
         return super.width;
      }
      
      public function get opening() : Boolean
      {
         return this._opening;
      }
      
      public function show() : void
      {
         this.onMouseRollOver();
      }
      
      public function hide() : void
      {
         this.onMouseRollOut();
      }
      
      public function setData(param1:String, param2:String, param3:Object, param4:Object, param5:Boolean = false) : void
      {
         var GAP:uint = 0;
         var startFreeX:Number = NaN;
         var startFreeY:Number = NaN;
         var startVipX:Number = NaN;
         var startVipY:Number = NaN;
         var defaultDLevel:int = 0;
         var totalSkins:Array = null;
         var freeSkins:Array = null;
         var vipSkins:Array = null;
         var i:int = 0;
         var currentLevel:int = 0;
         var hadPayD:Boolean = false;
         var wid:Number = NaN;
         var hei:Number = NaN;
         var currentD:String = param1;
         var defaultD:String = param2;
         var list:Object = param3;
         var matchlist:Object = param4;
         var animation:Boolean = param5;
         if(matchlist == null)
         {
            matchlist = {
               "vip":DefinitionType.VIP_QUEUE,
               "free":DefinitionType.FREE_STACK
            };
         }
         if(!matchlist.hasOwnProperty("free"))
         {
            matchlist.free = DefinitionType.FREE_STACK;
         }
         if(!matchlist.hasOwnProperty("vip"))
         {
            matchlist.vip = DefinitionType.VIP_QUEUE;
         }
         var listFree:Array = matchlist.free;
         var listVip:Array = matchlist.vip;
         this._currentDefinition = currentD;
         try
         {
            GAP = 2;
            skin.panel["defaultAuto"].x = GAP;
            skin.panel["defaultAuto"].y = GAP;
            startFreeX = skin.panel["defaultAuto"].x;
            startFreeY = skin.panel["defaultAuto"].y + this._unitHeight + GAP;
            startVipX = skin.panel["defaultAuto"].x + this._unitWidth + GAP * 2;
            startVipY = GAP;
            defaultDLevel = 0;
            totalSkins = [skin.panel["defaultAuto"]];
            freeSkins = [];
            vipSkins = [];
            this.payLevelStack = [];
            this.newLevelStack = [DefinitionType.AUTO];
            i = 0;
            while(i < this.defaultSkins.length)
            {
               if(!list.hasOwnProperty(this.defaultSkins[i].type))
               {
                  this.defaultSkins[i].ui.visible = false;
                  this.defaultVipSkins[i].ui.visible = false;
               }
               else
               {
                  if((this.hasType(this.defaultSkins[i].type,listFree)) && freeSkins.length < 5)
                  {
                     if(this.defaultSkins[i].type == defaultD)
                     {
                        defaultDLevel = totalSkins.length;
                     }
                     this.newLevelStack[totalSkins.length] = this.defaultSkins[i].type;
                     this.defaultSkins[i].ui.visible = true;
                     freeSkins.push(this.defaultSkins[i].ui);
                     totalSkins.push(this.defaultSkins[i].ui);
                  }
                  else
                  {
                     this.defaultSkins[i].ui.visible = false;
                  }
                  if((this.hasType(this.defaultVipSkins[i].type,listVip)) && vipSkins.length < 5)
                  {
                     if(this.defaultVipSkins[i].type == defaultD)
                     {
                        defaultDLevel = totalSkins.length;
                     }
                     this.newLevelStack[totalSkins.length] = this.defaultSkins[i].type;
                     this.defaultVipSkins[i].ui.visible = true;
                     this.payLevelStack.push(totalSkins.length);
                     vipSkins.push(this.defaultVipSkins[i].ui);
                     totalSkins.push(this.defaultVipSkins[i].ui);
                  }
                  else
                  {
                     this.defaultVipSkins[i].ui.visible = false;
                  }
               }
               i++;
            }
            if(freeSkins.length > 1)
            {
               skin.panel["superTV"].visible = true;
               skin.panel["super4K"].visible = true;
               if(skin.panel["vipAD"])
               {
                  skin.panel["vipAD"].visible = true;
               }
               vipSkins.push(skin.panel["superTV"]);
               vipSkins.push(skin.panel["super4K"]);
            }
            else
            {
               skin.panel["superTV"].visible = false;
               skin.panel["super4K"].visible = false;
               if(skin.panel["vipAD"])
               {
                  skin.panel["vipAD"].visible = false;
               }
            }
            i = 0;
            while(i < freeSkins.length)
            {
               freeSkins[i].x = startFreeX;
               freeSkins[i].y = startFreeY;
               startFreeY = freeSkins[i].y + this._unitHeight + GAP;
               i++;
            }
            i = 0;
            while(i < vipSkins.length)
            {
               vipSkins[i].x = startVipX;
               vipSkins[i].y = startVipY;
               startVipY = vipSkins[i].y + vipSkins[i].height + GAP;
               i++;
            }
            this._defaultGroup.dataProvider = totalSkins;
            this._defaultGroup.level = defaultDLevel;
            switch(currentD)
            {
               case DefinitionType.LW:
                  currentLevel = 0;
                  break;
               case DefinitionType.SD:
                  currentLevel = 1;
                  break;
               case DefinitionType.HD:
                  currentLevel = 2;
                  break;
               case DefinitionType.P720:
                  currentLevel = 3;
                  break;
               case DefinitionType.P1080:
                  currentLevel = 4;
                  break;
            }
            if(animation)
            {
               this.setAnimation(this._lastDefinition,currentLevel);
            }
            this._currentGroup["lv" + this._lastDefinition].visible = false;
            this._currentGroup["lv" + currentLevel].visible = true;
            this._lastDefinition = currentLevel;
            hadPayD = !(vipSkins == null) && vipSkins.length > 0;
            wid = 0;
            hei = startFreeY > startVipY?startFreeY:startVipY;
            if(hadPayD)
            {
               wid = startVipX + skin.panel["defaultLw_V"].width + GAP;
               skin.panel.line.height = hei - skin.panel.line.y * 2;
               skin.panel.line.visible = true;
            }
            else
            {
               wid = skin.panel["defaultAuto"].x * 2 + skin.panel["defaultAuto"].width;
               skin.panel.line.visible = false;
            }
            if(skin.panel.rect != null)
            {
               skin.panel.rect.width = wid;
               skin.panel.rect.height = hei;
            }
            if(skin.panel.line.visible)
            {
               skin.panel.tail.x = skin.panel.line.x;
            }
            else
            {
               skin.panel.tail.x = wid / 2;
            }
            skin.panel.tail.y = hei;
            skin.panel.x = 50 / 2 - skin.panel.tail.x;
            skin.panel.y = -(hei + skin.panel.tail.height);
         }
         catch(e:Error)
         {
         }
      }
      
      override protected function initialize() : void
      {
         super.initialize();
         visible = false;
         this._currentGroup = skin["currentGroup"];
         var i:int = 0;
         while(i < this._currentGroup.numChildren)
         {
            this._currentGroup.getChildAt(i).visible = false;
            i++;
         }
         this._animation = skin["animation"];
         this._animation.visible = false;
         this._animation.addEventListener("animationComplete",this.showBtn);
         if(skin.panel != null)
         {
            this._defaultGroup = new RadioButtonGroup2([skin.panel["defaultAuto"],skin.panel["defaultLw"],skin.panel["defaultSD"],skin.panel["defaultHD"],skin.panel["defaultVHD"],skin.panel["defaultP1080"]]);
            this.defaultSkins = [{
               "type":DefinitionType.LW,
               "ui":skin.panel["defaultLw"]
            },{
               "type":DefinitionType.SD,
               "ui":skin.panel["defaultSD"]
            },{
               "type":DefinitionType.HD,
               "ui":skin.panel["defaultHD"]
            },{
               "type":DefinitionType.P720,
               "ui":skin.panel["defaultVHD"]
            },{
               "type":DefinitionType.P1080,
               "ui":skin.panel["defaultP1080"]
            }];
            this.defaultVipSkins = [{
               "type":DefinitionType.LW,
               "ui":skin.panel["defaultLw_V"]
            },{
               "type":DefinitionType.SD,
               "ui":skin.panel["defaultHD_V"]
            },{
               "type":DefinitionType.HD,
               "ui":skin.panel["defaultHD_V"]
            },{
               "type":DefinitionType.P720,
               "ui":skin.panel["defaultVHD_V"]
            },{
               "type":DefinitionType.P1080,
               "ui":skin.panel["defaultP1080_V"]
            }];
            this._defaultGroup.addEventListener(Event.CHANGE,this.onDefinitionChange);
         }
         this.onMouseRollOut();
         addEventListener(MouseEvent.ROLL_OVER,this.onMouseRollOver);
         try
         {
            this._unitWidth = skin.panel["defaultAuto"].width;
            this._unitHeight = skin.panel["defaultAuto"].height;
         }
         catch(e:Error)
         {
         }
         try
         {
            skin.panel.superTV.addEventListener(MouseEvent.CLICK,this.onSuperTV);
            skin.panel.super4K.addEventListener(MouseEvent.CLICK,this.onSuperTV);
            if(skin.panel["vipAD"])
            {
               skin.panel["vipAD"].addEventListener(MouseEvent.CLICK,this.onSuperTV);
            }
         }
         catch(e:Error)
         {
         }
         addAppResize(this.onStageResize);
      }
      
      protected function onStageResize(param1:Object = null) : void
      {
         this.onMouseRollOut();
      }
      
      protected function hasType(param1:Object, param2:Array) : Boolean
      {
         var _loc3_:* = 0;
         if(param2 == null || param2.length == 0)
         {
            return false;
         }
         while(_loc3_ < param2.length)
         {
            if(param2[_loc3_] == param1)
            {
               return true;
            }
            _loc3_++;
         }
         return false;
      }
      
      protected function refreshDisplay(param1:String = "default") : void
      {
         var _loc2_:Object = null;
         if(sdk != null)
         {
            _loc2_ = {
               "defaultD":sdk.getDefaultDefinition(),
               "currentD":sdk.getDefinition()
            };
            if(param1 == "default")
            {
               var param1:String = sdk.getDefinition();
            }
            this.setData(param1,sdk.getDefaultDefinition(),sdk.getDefinitionList(),sdk.getDefinitionMatchList());
         }
      }
      
      private function onMouseRollOver(param1:MouseEvent = null) : void
      {
         if(skin.panel != null)
         {
            this.setOpen(true,!(param1 == null));
         }
         if(skin.select != null)
         {
            skin.select.visible = true;
         }
         if(skin.visualBack != null)
         {
            skin.visualBack.visible = true;
         }
         this.refreshDisplay(this._currentDefinition);
         skin.removeEventListener(MouseEvent.ROLL_OVER,this.onMouseRollOver);
         skin.addEventListener(MouseEvent.ROLL_OUT,this.onMouseRollOut);
      }
      
      private function onMouseRollOut(param1:MouseEvent = null) : void
      {
         if(skin.panel != null)
         {
            this.setOpen(false,!(param1 == null));
         }
         if(skin.select != null)
         {
            skin.select.visible = false;
         }
         if(skin.visualBack != null)
         {
            skin.visualBack.visible = false;
         }
         addEventListener(MouseEvent.ROLL_OVER,this.onMouseRollOver);
         removeEventListener(MouseEvent.ROLL_OUT,this.onMouseRollOut);
      }
      
      private function onDefinitionChange(param1:Event) : void
      {
         var _loc3_:ControlBarEvent = null;
         var _loc2_:String = this.newLevelStack[this._defaultGroup.level];
         if((this.hasType(this._defaultGroup.level,this.payLevelStack)) && !sdk.getUserinfo()["vip"])
         {
            _loc3_ = new ControlBarEvent(ControlBarEvent.DEFINITION_VIP);
            _loc3_.dataProvider = _loc2_;
         }
         else
         {
            _loc3_ = new ControlBarEvent(ControlBarEvent.DEFINITION_REGULATE);
            _loc3_.dataProvider = _loc2_;
         }
         dispatchEvent(_loc3_);
         this.onMouseRollOut();
      }
      
      private function setOpen(param1:Boolean, param2:Boolean = true) : void
      {
         this._opening = param1;
         if(param1)
         {
            skin.panel.visible = true;
            if(param2)
            {
               skin.panel.alpha = 0;
               TweenLite.to(skin.panel,0.2,{"alpha":1});
            }
         }
         else if(param2)
         {
            TweenLite.to(skin.panel,0.2,{
               "alpha":0,
               "onComplete":this.onHideComplete
            });
         }
         else
         {
            this.onHideComplete();
         }
         
      }
      
      private function onHideComplete() : void
      {
         if(skin.panel != null)
         {
            skin.panel.visible = false;
         }
      }
      
      private function onSuperTV(param1:MouseEvent) : void
      {
         switch(param1.currentTarget.name)
         {
            case "super4K":
               R.stat.sendDocDebug(LetvStatistics.STAT_CLK_4K);
               BrowserUtil.openBlankWindow("http://www.lemall.com/product/x50airzh.html?cps_id=le_pc_pcrx_other_bfy4k_x50air_c",stage);
               break;
            case "superTV":
               R.stat.sendDocDebug(LetvStatistics.STAT_CLK_2K);
               BrowserUtil.openBlankWindow("http://www.lemall.com/huodong/0519_phone.html?cps_id=lec_pc_rx_2kgqwmhm_bfy_ds_p",stage);
               break;
            case "vipAD":
               R.stat.sendDocDebug(LetvStatistics.STAT_CLK_DEFINITION_AD_SP);
               BrowserUtil.openBlankWindow("http://www.lemall.com/huodong/0519_phone.html?cps_id=lec_pc_rx_cjsjssk_bfy_ds_p",stage);
               break;
         }
      }
      
      private function setAnimation(param1:int, param2:int) : void
      {
         this._currentGroup.visible = false;
         var _loc3_:* = 0;
         while(_loc3_ < this._animation.groups.group.numChildren)
         {
            this._animation.groups.group.getChildAt(_loc3_).visible = false;
            this._animation.groups.group1.getChildAt(_loc3_).visible = false;
            _loc3_++;
         }
         this._animation.groups.group["lv" + param1].visible = true;
         this._animation.groups.group1["lv" + param2].visible = true;
         this._animation.visible = true;
         this._animation.gotoAndPlay(0);
      }
      
      private function showBtn(param1:Event) : void
      {
         this._currentGroup.visible = true;
      }
   }
}
