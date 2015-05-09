package com.letv.plugins.kernel.utils
{
   import flash.display.Sprite;
   import com.letv.plugins.kernel.components.VideoUI;
   import com.letv.plugins.kernel.model.Model;
   import com.letv.plugins.kernel.components.WaterMarkUI;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import com.greensock.TweenLite;
   import flash.display.StageDisplayState;
   import com.letv.plugins.kernel.Kernel;
   import com.letv.pluginsAPI.kernel.PlayerStateEvent;
   
   public class VideoShapeUtil extends Object
   {
      
      public function VideoShapeUtil()
      {
         super();
      }
      
      public static function change(param1:Sprite, param2:VideoUI, param3:Model, param4:WaterMarkUI, param5:Boolean = false) : void
      {
         var video:Object = null;
         var rect:Rectangle = null;
         var videoScale:Number = NaN;
         var percent:Number = NaN;
         var wid:Number = NaN;
         var hei:Number = NaN;
         var useWid:Number = NaN;
         var useHei:Number = NaN;
         var cHei:Number = NaN;
         var changeBeforeScaleX:Number = NaN;
         var changeBeforeScaleY:Number = NaN;
         var position:Rectangle = null;
         var areaScale:Number = NaN;
         var videoX:Number = NaN;
         var videoY:Number = NaN;
         var videoWid:Number = NaN;
         var videoHei:Number = NaN;
         var changeScale:Number = NaN;
         var changeScaleX:Number = NaN;
         var changeScaleY:Number = NaN;
         var main:Sprite = param1;
         var videoUI:VideoUI = param2;
         var model:Model = param3;
         var markUI:WaterMarkUI = param4;
         var action:Boolean = param5;
         try
         {
            video = videoUI.oneVideo;
            rect = model.setting.rect;
            videoScale = model.setting.currentScale;
            percent = model.setting.percent;
            wid = -1;
            hei = -1;
            useWid = -1;
            useHei = -1;
            cHei = 0;
            TweenLite.killTweensOf(videoUI);
            changeBeforeScaleX = videoUI.scaleX;
            changeBeforeScaleY = videoUI.scaleY;
            if(!model.config.autoHide)
            {
               if(main.stage.displayState == StageDisplayState.NORMAL)
               {
                  cHei = model.config.controlbarheight;
               }
            }
            if(rect)
            {
               wid = rect.width;
               hei = rect.height;
               position = rect.clone();
            }
            else
            {
               wid = main.stage.stageWidth;
               hei = main.stage.stageHeight - cHei;
               position = new Rectangle(0,0,wid,hei);
            }
            useWid = wid * percent;
            useHei = hei * percent;
            areaScale = useWid / useHei;
            if(model.setting.fullScale)
            {
               videoScale = wid / hei;
               model.setting.currentScale = videoScale;
            }
            videoX = wid / 2;
            videoY = hei / 2;
            videoWid = 0;
            videoHei = 0;
            videoUI.x = videoX;
            videoUI.y = videoY;
            if(videoScale > areaScale)
            {
               videoWid = useWid;
               videoHei = useWid / videoScale;
            }
            else
            {
               videoHei = useHei;
               videoWid = useHei * videoScale;
            }
            videoUI.rotation = 0;
            videoUI.width = videoWid;
            videoUI.height = videoHei;
            main.graphics.clear();
            videoUI.rotation = model.setting.rotation;
            videoScale = videoUI.width / videoUI.height;
            changeScale = 1;
            if(videoScale > areaScale)
            {
               changeScale = useWid / videoUI.width;
            }
            else
            {
               changeScale = useHei / videoUI.height;
            }
            if(action)
            {
               changeScaleX = videoUI.scaleX * changeScale;
               changeScaleY = videoUI.scaleY * changeScale;
               videoUI.scaleX = changeBeforeScaleX;
               videoUI.scaleY = changeBeforeScaleY;
               TweenLite.to(videoUI,0.3,{
                  "scaleX":changeScaleX,
                  "scaleY":changeScaleY
               });
            }
            else
            {
               videoUI.scaleX = videoUI.scaleX * changeScale;
               videoUI.scaleY = videoUI.scaleY * changeScale;
            }
            main.graphics.beginFill(0);
            if(rect != null)
            {
               main.graphics.drawRect(0,0,rect.width,rect.height);
            }
            else
            {
               main.graphics.drawRect(0,0,main.stage.stageWidth,main.stage.stageHeight);
            }
            main.graphics.endFill();
            main.x = position.x;
            main.y = position.y;
            markUI.resize(main);
         }
         catch(e:Error)
         {
            Kernel.sendLog("Error In VideoShapeUtil.change " + e.message,"error");
         }
         var point:Point = new Point(0,0);
         if(videoUI.oneVideo != null)
         {
            point = videoUI.oneVideo.localToGlobal(point);
            model.videoRect = new Rectangle(point.x,point.y,videoUI.width,videoUI.height);
            model.dispatchEvent(new PlayerStateEvent(PlayerStateEvent.VIDEO_RECT));
         }
      }
   }
}
