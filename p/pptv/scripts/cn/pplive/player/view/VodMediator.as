package cn.pplive.player.view
{
   import org.puremvc.as3.multicore.utilities.fabrication.patterns.mediator.FlashMediator;
   import flash.display.MovieClip;
   import flash.display.Stage;
   import cn.pplive.player.common.*;
   import cn.pplive.player.view.ui.*;
   import flash.utils.Timer;
   import cn.pplive.player.utils.hash.Global;
   import flash.events.MouseEvent;
   import flash.events.StageVideoAvailabilityEvent;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import cn.pplive.player.manager.ViewManager;
   import flash.events.TimerEvent;
   import flash.ui.Mouse;
   import flash.media.StageVideoAvailability;
   import cn.pplive.player.utils.PrintDebug;
   import flash.ui.ContextMenu;
   import flash.ui.ContextMenuItem;
   import flash.events.ContextMenuEvent;
   import org.puremvc.as3.multicore.interfaces.INotification;
   import flash.ui.Keyboard;
   import flash.text.TextField;
   import flash.text.TextFieldType;
   
   public class VodMediator extends FlashMediator
   {
      
      public static const NAME:String = "vod_mediator";
      
      private var contentBox:MovieClip;
      
      private var $isOver:Boolean = true;
      
      private var $dt:Timer;
      
      private var $tip:Tip = null;
      
      public function VodMediator(param1:String = null, param2:Object = null)
      {
         super(param1,param2);
      }
      
      public function get stage() : Stage
      {
         return this.view.stage;
      }
      
      public function get view() : PPNewVodApp
      {
         return viewComponent as PPNewVodApp;
      }
      
      override public function onRegister() : void
      {
         this.contentBox = new MovieClip();
         this.view.addChild(this.contentBox);
         with(_loc2_)
         {
            
            graphics.clear();
            graphics.beginFill(0,1);
            graphics.drawRect(0,0,isNaN(VodParser.vw)?stage.stageWidth:VodParser.vw,isNaN(VodParser.vw)?stage.stageHeight:VodParser.vh);
            graphics.endFill();
         }
         this.$dt = new Timer(2000);
         Global.getInstance()["effect"] = [];
         this.stage.addEventListener(MouseEvent.MOUSE_MOVE,this.onMoveHandler);
         this.stage.addEventListener(MouseEvent.MOUSE_OVER,this.onMoveHandler);
         this.stage.addEventListener(MouseEvent.MOUSE_OUT,this.onMoveHandler);
         this.stage.addEventListener(StageVideoAvailabilityEvent.STAGE_VIDEO_AVAILABILITY,this.onStageVideoHandler);
         this.stage.addEventListener(Event.RESIZE,this.onResizeHandler);
         this.stage.addEventListener(KeyboardEvent.KEY_DOWN,this.onKeyDownHandler);
         this.stage.addEventListener(KeyboardEvent.KEY_UP,this.onKeyUpHandler);
         fabFacade.registerMediator(new SkinMediator(SkinMediator.NAME,this.contentBox));
         if(!Global.getInstance()["skin"])
         {
            Global.getInstance()["skin"] = [];
         }
         sendNotification(VodNotification.VOD_SKIN_SUCCESS,Global.getInstance()["skin"]);
         Global.getInstance()["setSize"] = this.setSize;
      }
      
      private function setSize(param1:Number, param2:Number) : void
      {
         var w:Number = param1;
         var h:Number = param2;
         with(this.contentBox)
         {
            
            graphics.clear();
            graphics.beginFill(0,Number(!VodCommon.isSVavailable));
            graphics.drawRect(0,0,w,h);
            graphics.endFill();
         }
         try
         {
            ViewManager.getInstance().getMediator("skin").setSize(w,h);
         }
         catch(evt:Error)
         {
         }
      }
      
      private function onResizeHandler(param1:Event) : void
      {
         this.setSize(this.stage.stageWidth,this.stage.stageHeight);
      }
      
      public function changeMouseMoveEffect(param1:Boolean) : void
      {
         var _loc2_:* = 0;
         var _loc3_:* = 0;
         if(param1)
         {
            this.$dt = new Timer(2000);
         }
         else
         {
            this.$dt.stop();
            this.$dt.removeEventListener(TimerEvent.TIMER,this.onTimerHandler);
            this.$dt = null;
            _loc2_ = 0;
            _loc3_ = Global.getInstance()["effect"].length;
            while(_loc2_ < _loc3_)
            {
               if(Global.getInstance()["effect"][_loc2_]["target"])
               {
                  Global.getInstance()["effect"][_loc2_]["target"].visible = true;
                  Global.getInstance()["effect"][_loc2_]["target"].alpha = 1;
                  Global.getInstance()["effect"][_loc2_]["target"].removeEventListener(Event.ENTER_FRAME,this.onHideHandler);
                  Global.getInstance()["effect"][_loc2_]["target"].removeEventListener(Event.ENTER_FRAME,this.onShowHandler);
               }
               _loc2_++;
            }
         }
      }
      
      private function onMoveHandler(param1:MouseEvent) : void
      {
         var _loc2_:* = 0;
         var _loc3_:* = 0;
         switch(param1.type)
         {
            case MouseEvent.MOUSE_MOVE:
               _loc2_ = 0;
               _loc3_ = Global.getInstance()["effect"].length;
               while(_loc2_ < _loc3_)
               {
                  if((Global.getInstance()["effect"][_loc2_]["target"]) && (Global.getInstance()["effect"][_loc2_]["status"]))
                  {
                     Global.getInstance()["effect"][_loc2_]["target"].visible = true;
                     Global.getInstance()["effect"][_loc2_]["target"].removeEventListener(Event.ENTER_FRAME,this.onHideHandler);
                     Global.getInstance()["effect"][_loc2_]["target"].addEventListener(Event.ENTER_FRAME,this.onShowHandler);
                  }
                  _loc2_++;
               }
               break;
            case MouseEvent.MOUSE_OVER:
               this.$isOver = true;
               break;
            case MouseEvent.MOUSE_OUT:
               this.$isOver = false;
               break;
         }
         try
         {
            ViewManager.getInstance().getMediator("skin").skin.smartClickPanelVisible(this.$isOver);
         }
         catch(evt:Error)
         {
         }
      }
      
      private function mouseState(param1:Boolean) : void
      {
         _loc2_[this.stage.displayState == "fullScreen" && !param1?"hide":"show"]();
      }
      
      private function onShowHandler(param1:Event) : void
      {
         this.$dt.removeEventListener(TimerEvent.TIMER,this.onTimerHandler);
         if(param1.target.alpha >= 1)
         {
            param1.target.alpha = 1;
            if(!param1.target.hitTestPoint(this.stage.mouseX,this.stage.mouseY,false) || !this.$isOver)
            {
               param1.target.removeEventListener(Event.ENTER_FRAME,this.onShowHandler);
               this.$dt.addEventListener(TimerEvent.TIMER,JEventDelegate.create(this.onTimerHandler,param1.target));
               this.$dt.start();
            }
            else
            {
               this.$dt.stop();
            }
         }
         else
         {
            this.mouseState(true);
            param1.target.alpha = param1.target.alpha + 0.1;
            if(param1.target.alpha > 0.9)
            {
               param1.target.visible = true;
            }
         }
      }
      
      private function onHideHandler(param1:Event) : void
      {
         if(param1.target.alpha <= 0)
         {
            param1.target.alpha = 0;
            param1.target.removeEventListener(Event.ENTER_FRAME,this.onHideHandler);
            this.$dt.addEventListener(TimerEvent.TIMER,JEventDelegate.create(this.onTimerHandler,param1.target));
         }
         else
         {
            this.mouseState(false);
            param1.target.alpha = param1.target.alpha - 0.1;
            if(param1.target.alpha < 0.1)
            {
               param1.target.visible = false;
            }
         }
      }
      
      private function onTimerHandler(param1:TimerEvent, param2:*) : void
      {
         this.$dt.stop();
         param2.addEventListener(Event.ENTER_FRAME,this.onHideHandler);
      }
      
      private function onStageVideoHandler(param1:StageVideoAvailabilityEvent) : void
      {
         VodCommon.isSVavailable = param1.availability == StageVideoAvailability.AVAILABLE;
         PrintDebug.Trace("stage 侦听监测  StageVideoAvailability ===>>> ",VodCommon.isSVavailable);
         this.changeHardwareItem(VodCommon.isSVavailable);
         if(VodCommon.isSV == true)
         {
            VodCommon.isSV = VodCommon.isSVavailable;
         }
         try
         {
            Global.getInstance()["player"].setup(VodCommon.isSV);
         }
         catch(evt:Error)
         {
         }
      }
      
      private function changeHardwareItem(param1:Boolean) : void
      {
         var $cm:ContextMenu = null;
         var i:int = 0;
         var $cmi:ContextMenuItem = null;
         var on:Boolean = param1;
         with(_loc3_)
         {
            
            graphics.clear();
            graphics.beginFill(0,Number(!VodCommon.isSVavailable));
            graphics.drawRect(0,0,isNaN(VodParser.vw)?stage.stageWidth:VodParser.vw,isNaN(VodParser.vw)?stage.stageHeight:VodParser.vh);
            graphics.endFill();
         }
         if(Global.getInstance()["root"])
         {
            $cm = Global.getInstance()["root"].contextMenu;
            i = 0;
            while(i < $cm.customItems.length)
            {
               if($cm.customItems[i].caption.indexOf("硬件加速") != -1)
               {
                  $cm.customItems.splice(i,1);
                  break;
               }
               i++;
            }
            $cmi = new ContextMenuItem((on?"关闭":"开启") + " 硬件加速");
            $cmi.enabled = VodCommon.isSVavailable;
            $cm.customItems.splice(1,0,$cmi);
            $cmi.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT,this.onMenuHandler);
            Global.getInstance()["root"].contextMenu = $cm;
         }
      }
      
      private function onMenuHandler(param1:ContextMenuEvent) : void
      {
         try
         {
            Global.getInstance()["player"].setup(!VodCommon.isSV);
         }
         catch(evt:Error)
         {
         }
      }
      
      public function respondToVodStageVideo(param1:INotification) : void
      {
         this.changeHardwareItem(VodCommon.isSV);
      }
      
      private function onKeyDownHandler(param1:KeyboardEvent) : void
      {
         try
         {
            if(param1.keyCode == Keyboard.UP || param1.keyCode == Keyboard.DOWN || param1.keyCode == Keyboard.LEFT || param1.keyCode == Keyboard.RIGHT)
            {
               sendNotification(VodNotification.VOD_KEYBOARD,param1.keyCode);
            }
         }
         catch(e:Error)
         {
         }
      }
      
      private function onKeyUpHandler(param1:KeyboardEvent) : void
      {
         var $logArr:Array = null;
         var e:KeyboardEvent = param1;
         try
         {
            var onTipHandler:Function = function(param1:Event):void
            {
               var _loc2_:String = null;
               var _loc3_:Vector.<String> = null;
               if($tip)
               {
                  if($tip.index == 0)
                  {
                     _loc2_ = PrintDebug.log;
                  }
                  else if($tip.index == 1)
                  {
                     if(ViewManager.getInstance().getMediator("skin").kernel)
                     {
                        try
                        {
                           _loc3_ = ViewManager.getInstance().getMediator("skin").kernel["getLogStatements"]();
                           _loc2_ = _loc3_.join("\r");
                        }
                        catch(evt:Error)
                        {
                        }
                     }
                  }
                  else if($tip.index == 2)
                  {
                     if(ViewManager.getInstance().getMediator("adver").content)
                     {
                        try
                        {
                           _loc2_ = ViewManager.getInstance().getMediator("adver").content["adLog"];
                           _loc2_ = _loc2_.split("##").join("\r");
                        }
                        catch(evt:Error)
                        {
                        }
                     }
                  }
                  else if($tip.index == 3)
                  {
                     if(ViewManager.getInstance().getMediator("barrage").content)
                     {
                        try
                        {
                           _loc2_ = ViewManager.getInstance().getMediator("barrage").content["Log"];
                           _loc2_ = _loc2_.split("##").join("\r");
                        }
                        catch(evt:Error)
                        {
                        }
                     }
                  }
                  
                  
                  
                  $tip.text = _loc2_;
               }
            };
            if(e.keyCode == Keyboard.SPACE)
            {
               if((this.stage.focus) && (this.stage.focus is TextField) && TextField(this.stage.focus).type == TextFieldType.INPUT)
               {
                  return;
               }
               if(ViewManager.getInstance().getMediator("skin"))
               {
                  ViewManager.getInstance().getMediator("skin").toggleVideo();
               }
            }
            if((e.shiftKey) && e.keyCode == Keyboard.HOME)
            {
               if(!this.$tip)
               {
                  $logArr = [{
                     "label":"播放器日志",
                     "index":0
                  }];
                  if(ViewManager.getInstance().getMediator("skin").kernel)
                  {
                     $logArr.push({
                        "label":"内核日志",
                        "index":1
                     });
                  }
                  if(ViewManager.getInstance().getMediator("adver").content)
                  {
                     $logArr.push({
                        "label":"广告日志",
                        "index":2
                     });
                  }
                  if(ViewManager.getInstance().getMediator("barrage").content)
                  {
                     $logArr.push({
                        "label":"弹幕日志",
                        "index":3
                     });
                  }
                  this.$tip = new Tip($logArr,this.stage.stageWidth,this.stage.stageHeight);
                  this.stage.addChild(this.$tip);
                  this.$tip.addEventListener("_change_",onTipHandler);
                  this.$tip.addEventListener(Event.ENTER_FRAME,onTipHandler);
               }
            }
            if((e.shiftKey) && e.keyCode == Keyboard.END)
            {
               if(this.$tip)
               {
                  this.$tip.removeEventListener("_change_",onTipHandler);
                  this.$tip.removeEventListener(Event.ENTER_FRAME,onTipHandler);
                  this.stage.removeChild(this.$tip);
                  this.$tip = null;
               }
            }
         }
         catch(evt:Error)
         {
         }
      }
      
      public function respondToPlayerLoadingDelete(param1:INotification) : void
      {
         if(Global.getInstance()["loading"])
         {
            Global.getInstance()["loading"].destroy();
            delete Global.getInstance()["loading"];
            true;
         }
      }
   }
}

import flash.display.MovieClip;
import flash.text.TextField;
import flash.events.MouseEvent;
import flash.events.Event;
import flash.display.Sprite;

dynamic class Tip extends MovieClip
{
   
   private var $txt:TextField = null;
   
   private var $labelArr:Array;
   
   private var $currBtn:MovieClip;
   
   private var $index:int = 0;
   
   function Tip(param1:Array, param2:Number, param3:Number)
   {
      var labelArr:Array = param1;
      var w:Number = param2;
      var h:Number = param3;
      this.$labelArr = [];
      super();
      var $tip:Sprite = new Sprite();
      addChild($tip);
      with($tip)
      {
         
         graphics.clear();
         graphics.beginFill(16777215,0.5);
         graphics.drawRect(0,0,w,h);
         graphics.endFill();
      }
      var i:int = 0;
      while(i < labelArr.length)
      {
         this.$labelArr[i] = this.addBtn(labelArr[i]["label"]);
         addChild(this.$labelArr[i]);
         this.$labelArr[i]["buttonMode"] = true;
         this.$labelArr[i].index = labelArr[i]["index"];
         this.$labelArr[i].x = (this.$labelArr[i].width + 10) * i;
         this.$labelArr[i].addEventListener(MouseEvent.CLICK,this.onClickHandler);
         i++;
      }
      this.$txt = new TextField();
      this.$txt.autoSize = "left";
      this.$txt.width = w;
      this.$txt.wordWrap = true;
      this.$txt.textColor = 0;
      $tip.addChild(this.$txt);
      this.$txt.y = 35;
      this.$currBtn = this.$labelArr[this.$index];
      (this.$currBtn.getChildByName("_label_") as TextField).textColor = 16711680;
   }
   
   public function get index() : int
   {
      return this.$index;
   }
   
   private function onClickHandler(param1:MouseEvent) : void
   {
      this.$index = param1.target.index;
      (this.$currBtn.getChildByName("_label_") as TextField).textColor = 0;
      this.$currBtn = param1.target as MovieClip;
      (this.$currBtn.getChildByName("_label_") as TextField).textColor = 16711680;
      dispatchEvent(new Event("_change_"));
   }
   
   public function set text(param1:String) : void
   {
      this.$txt.text = param1;
   }
   
   private function addBtn(param1:String) : MovieClip
   {
      var label:String = param1;
      var $temp:MovieClip = new MovieClip();
      with($temp)
      {
         
         graphics.clear();
         graphics.beginFill(16777215);
         graphics.drawRect(0,0,70,30);
         graphics.endFill();
      }
      this.$txt = new TextField();
      this.$txt.name = "_label_";
      $temp.addChild(this.$txt);
      this.$txt.autoSize = "left";
      this.$txt.mouseEnabled = false;
      this.$txt.textColor = 0;
      this.$txt.text = label;
      this.$txt.x = ($temp.width - this.$txt.width) / 2;
      this.$txt.y = ($temp.height - this.$txt.height) / 2;
      return $temp;
   }
}

import flash.events.Event;

class JEventDelegate extends Object
{
   
   function JEventDelegate()
   {
      super();
   }
   
   public static function create(param1:Function, ... rest) : Function
   {
      var f:Function = param1;
      var arg:Array = rest;
      return function(param1:Event):void
      {
         f.apply(null,[param1].concat(arg));
      };
   }
}
