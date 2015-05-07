package com.letv.player.components.controlBar.classes.seeDataPreview
{
   import com.letv.player.components.BaseConfigComponent;
   import flash.text.StyleSheet;
   import flash.display.MovieClip;
   import flash.text.TextFieldAutoSize;
   import flash.events.MouseEvent;
   import flash.events.TextEvent;
   import flash.geom.Point;
   import com.greensock.TweenLite;
   import com.letv.player.view.PlayerLayer;
   import com.alex.utils.TimeUtil;
   import com.letv.player.components.controlBar.events.SeePointEvent;
   import flash.events.EventDispatcher;
   
   public class SeePoint extends BaseConfigComponent implements ISeePoint
   {
      
      public static const POINT_NORMAL:uint = 0;
      
      public static const POINT_HEAD:uint = 1;
      
      public static const POINT_TAIL:uint = 2;
      
      private var eventdispatcher:EventDispatcher;
      
      private var pointData:Object;
      
      private var duration:Number = 0;
      
      private var panel:MovieClip;
      
      private var CSS1:String = "p{font-family:Microsoft YaHei,微软雅黑,Arila,宋体;color:#CCCCCC}a{color:#FFFFFF;}a:hover{color:#02A0E9;}";
      
      private var CSS2:String = "p{font-family:Microsoft YaHei,微软雅黑,Arila,宋体;color:#CCCCCC}a{color:#FFFFFF;}a:hover{color:#02A0E9;}";
      
      public function SeePoint(param1:Class, param2:EventDispatcher, param3:Object, param4:Number = 0)
      {
         this.pointData = param3;
         this.duration = param4;
         this.eventdispatcher = param2;
         super(new param1());
      }
      
      override public function destroy() : void
      {
         clearparent();
         this.removeListener();
         this.panel = null;
         this.pointData = null;
         this.eventdispatcher = null;
         super.destroy();
      }
      
      public function get type() : int
      {
         return this.pointData.type;
      }
      
      public function get content() : String
      {
         return this.pointData.mess;
      }
      
      public function get time() : Number
      {
         return this.pointData.step;
      }
      
      override protected function initialize() : void
      {
         var css:StyleSheet = null;
         super.initialize();
         if(this.type == POINT_HEAD)
         {
            this.pointData.mess = "跳过片头";
         }
         else if(this.type == POINT_TAIL)
         {
            this.pointData.mess = "跳过片尾";
         }
         
         try
         {
            css = new StyleSheet();
            switch(this.type)
            {
               case POINT_HEAD:
               case POINT_TAIL:
                  css.parseCSS(this.CSS2);
                  this.panel = skin.jumpSeedata as MovieClip;
                  if(skin.normalSeedata.visible)
                  {
                     skin.normalSeedata.visible = false;
                  }
                  break;
               default:
                  css.parseCSS(this.CSS1);
                  this.panel = skin.normalSeedata as MovieClip;
                  if(skin.jumpSeedata.visible)
                  {
                     skin.jumpSeedata.visible = false;
                  }
            }
            if(this.panel != null)
            {
               this.panel.visible = false;
               if(this.panel.label != null)
               {
                  this.panel.label.styleSheet = css;
                  this.panel.label.autoSize = TextFieldAutoSize.LEFT;
               }
            }
         }
         catch(e:Error)
         {
         }
         try
         {
            skin.addChild(skin.btn);
            skin.addEventListener(MouseEvent.ROLL_OUT,this.onRollOut);
            skin.btn.addEventListener(MouseEvent.ROLL_OVER,this.onRollOver);
            this.panel.addEventListener(MouseEvent.ROLL_OVER,this.onRollOver);
            this.panel.label.addEventListener(TextEvent.LINK,this.onLabelLink);
         }
         catch(e:Error)
         {
         }
      }
      
      private function removeListener() : void
      {
         try
         {
            skin.removeEventListener(MouseEvent.CLICK,this.onClkPoint);
            skin.removeEventListener(MouseEvent.ROLL_OUT,this.onRollOut);
            skin.btn.removeEventListener(MouseEvent.CLICK,this.onClkPoint);
            skin.btn.removeEventListener(MouseEvent.ROLL_OVER,this.onRollOver);
            this.panel.removeEventListener(MouseEvent.ROLL_OVER,this.onRollOver);
            this.panel.label.removeEventListener(TextEvent.LINK,this.onLabelLink);
         }
         catch(e:Error)
         {
         }
      }
      
      private function onRollOver(param1:MouseEvent) : void
      {
         var pointStr:String = null;
         var rectX:Number = NaN;
         var p:Point = null;
         var jump:Boolean = false;
         var event:MouseEvent = param1;
         try
         {
            buttonMode = true;
            mouseEnabled = true;
            this.panel.visible = true;
            TweenLite.to(this.panel,0.3,{"alpha":1});
            pointStr = "<p>" + this.content;
            switch(this.type)
            {
               case POINT_HEAD:
               case POINT_TAIL:
                  this.panel.label.wordWrap = false;
                  this.panel.label.mouseEnabled = true;
                  jump = PlayerLayer.getInstance().sdk.getPlayset()["jump"];
                  pointStr = pointStr + TimeUtil.swap(this.time);
                  pointStr = pointStr + (jump?"已经开启跳过片头/片尾 | <a href=\'event:closeJump\'>关闭</a></p>":"已经关闭跳过片头/片尾 | <a href=\'event:openJump\'>开启</a></p>");
                  pointStr = "<font face=\'Microsoft YaHei,微软雅黑,Arial\' size=\'16\' color=\'#0099FF\'>" + pointStr + "</font>";
                  skin.btn.addEventListener(MouseEvent.CLICK,this.onClkPoint);
                  break;
               default:
                  this.panel.label.width = 160;
                  this.panel.label.wordWrap = true;
                  this.panel.label.mouseEnabled = false;
                  if(pointStr.length > 26)
                  {
                     pointStr = pointStr.substring(0,23) + "...</p>";
                  }
                  pointStr = TimeUtil.swap(this.time) + " " + pointStr;
                  skin.addEventListener(MouseEvent.CLICK,this.onClkPoint);
            }
            this.panel.label.htmlText = pointStr;
            this.panel.label.autoSize = TextFieldAutoSize.LEFT;
            this.panel.rect.width = this.panel.label.width + 10;
            this.panel.rect.height = this.panel.label.height + 4;
            rectX = -this.panel.rect.width / 2;
            p = this.panel.localToGlobal(new Point(rectX,0));
            if(p.x <= 0)
            {
               p = this.panel.globalToLocal(new Point(5,0));
               rectX = p.x;
            }
            else if(p.x + this.panel.rect.width > skin.stage.stageWidth)
            {
               p = this.panel.globalToLocal(new Point(skin.stage.stageWidth - 5,0));
               rectX = p.x - this.panel.rect.width;
            }
            
            this.panel.rect.x = rectX;
            this.panel.rect.y = -this.panel.rect.height;
            this.panel.label.x = rectX + 10 * 0.5;
            this.panel.label.y = this.panel.rect.y + 4 * 0.5;
            this.eventdispatcher.dispatchEvent(new SeePointEvent(SeePointEvent.SHOW_SEE_POINT));
         }
         catch(e:Error)
         {
         }
      }
      
      private function onRollOut(param1:MouseEvent = null) : void
      {
         if(this.type == POINT_NORMAL)
         {
            TweenLite.to(this.panel,0.3,{
               "alpha":0,
               "onComplete":this.onHideComplete
            });
         }
         else if(this.panel.alpha == 1)
         {
            TweenLite.to(this.panel,0.3,{
               "alpha":0,
               "delay":1,
               "onComplete":this.onHideComplete
            });
         }
         else
         {
            TweenLite.to(this.panel,0.3,{
               "alpha":0,
               "onComplete":this.onHideComplete
            });
         }
         
      }
      
      private function onHideComplete() : void
      {
         buttonMode = false;
         try
         {
            this.panel.visible = false;
            skin.removeEventListener(MouseEvent.CLICK,this.onClkPoint);
            skin.btn.removeEventListener(MouseEvent.CLICK,this.onClkPoint);
         }
         catch(e:Error)
         {
         }
      }
      
      private function onClkPoint(param1:MouseEvent) : void
      {
         var _loc2_:SeePointEvent = new SeePointEvent(SeePointEvent.SELECT_SEE_POINT);
         _loc2_.time = this.time;
         _loc2_.dataProvider = this.type == POINT_TAIL;
         this.eventdispatcher.dispatchEvent(_loc2_);
      }
      
      private function onLabelLink(param1:TextEvent) : void
      {
         var _loc2_:SeePointEvent = new SeePointEvent(SeePointEvent.SET_JUMP);
         switch(param1.text)
         {
            case "closeJump":
               _loc2_.dataProvider = false;
               break;
            case "openJump":
               _loc2_.dataProvider = true;
               break;
            default:
               return;
         }
         this.onHideComplete();
         this.eventdispatcher.dispatchEvent(_loc2_);
      }
   }
}
