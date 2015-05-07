package com.letv.player.sdk
{
   import flash.events.EventDispatcher;
   import com.letv.pluginsAPI.interfaces.IRecommend;
   import flash.events.Event;
   import com.letv.pluginsAPI.recommend.RecommendEvent;
   import flash.display.DisplayObject;
   
   public class Recommend extends EventDispatcher implements IRecommend
   {
      
      private var _recommend:Object;
      
      public function Recommend(param1:Object)
      {
         super();
         if(!(param1 == null) && (param1.hasOwnProperty("setVolume")))
         {
            this._recommend = param1;
            this._recommend.addEventListener(RecommendEvent.RECOMMEND_REPLAY,this.onEventDispatch);
            this._recommend.addEventListener(RecommendEvent.RECOMMEND_LOCK_TRACK,this.onEventDispatch);
         }
      }
      
      private function onEventDispatch(param1:Event) : void
      {
         var _loc2_:RecommendEvent = new RecommendEvent(param1.type);
         _loc2_.dataProvider = param1["dataProvider"];
         dispatchEvent(_loc2_);
      }
      
      public function get surface() : DisplayObject
      {
         return this._recommend as DisplayObject;
      }
      
      public function setVolume(param1:Number) : void
      {
         if(!(this._recommend == null) && (this._recommend.hasOwnProperty("setVolume")))
         {
            this._recommend.setVolume(param1);
         }
      }
      
      public function stopvideo() : void
      {
         if(!(this._recommend == null) && (this._recommend.hasOwnProperty("stopvideo")))
         {
            this._recommend.stopvideo();
         }
      }
      
      public function startvideo(param1:Object) : void
      {
         if(!(this._recommend == null) && (this._recommend.hasOwnProperty("startvideo")))
         {
            this._recommend.startvideo(param1);
         }
      }
      
      public function setRect(param1:Object = null, param2:Object = null) : void
      {
         if(!(this._recommend == null) && (this._recommend.hasOwnProperty("setRect")))
         {
            this._recommend.setRect(param1,param2);
         }
      }
   }
}
