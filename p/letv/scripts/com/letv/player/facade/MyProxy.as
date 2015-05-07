package com.letv.player.facade
{
   import org.puremvc.as3.patterns.proxy.Proxy;
   import com.letv.player.view.PlayerLayer;
   import com.letv.player.Player;
   
   public class MyProxy extends Proxy
   {
      
      protected var layer:PlayerLayer;
      
      public function MyProxy(param1:String = null, param2:Object = null)
      {
         this.layer = PlayerLayer.getInstance();
         super(param1,param2);
      }
      
      public function get main() : Player
      {
         return this.layer.main;
      }
      
      public function get R() : MyResource
      {
         return this.main.getMsg(MyResource.R) as MyResource;
      }
      
      override public function onRemove() : void
      {
         super.onRemove();
         this.layer = null;
      }
   }
}
