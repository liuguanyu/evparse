package com.letv.player.facade
{
   import org.puremvc.as3.patterns.mediator.Mediator;
   import com.letv.player.view.PlayerLayer;
   import flash.display.Stage;
   import com.letv.pluginsAPI.sdk.SDK;
   import com.letv.pluginsAPI.interfaces.IRecommend;
   import com.letv.player.Player;
   
   public class MyMediator extends Mediator
   {
      
      protected var layer:PlayerLayer;
      
      public function MyMediator(param1:String = null, param2:Object = null)
      {
         this.layer = PlayerLayer.getInstance();
         super(param1,param2);
      }
      
      public function get stage() : Stage
      {
         return this.main.stage;
      }
      
      public function get sdk() : SDK
      {
         return this.layer.sdk;
      }
      
      public function get recommend() : IRecommend
      {
         return this.layer.recommend;
      }
      
      public function get main() : Player
      {
         return this.layer.main;
      }
      
      public function get R() : MyResource
      {
         return this.main.getMsg(MyResource.R) as MyResource;
      }
      
      public function get uistate() : Object
      {
         return this.main.getMsg(MyResource.UISTATE);
      }
      
      public function get uipopup() : Boolean
      {
         return this.main.getMsg(MyResource.POPUP);
      }
      
      override public function onRemove() : void
      {
         super.onRemove();
         this.layer = null;
      }
   }
}
