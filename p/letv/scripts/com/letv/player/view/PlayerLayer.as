package com.letv.player.view
{
   import com.letv.player.Player;
   import com.letv.pluginsAPI.sdk.SDK;
   import com.letv.pluginsAPI.interfaces.IRecommend;
   import com.alex.containers.Canvas;
   import com.letv.player.facade.MyResource;
   import com.letv.player.facade.MyFacade;
   import com.letv.player.components.types.UIState;
   import com.letv.player.sdk.Recommend;
   
   public class PlayerLayer extends Object
   {
      
      private static var _instance:PlayerLayer;
      
      public var main:Player;
      
      public var sdk:com.letv.pluginsAPI.sdk.SDK;
      
      public var recommend:IRecommend;
      
      public var sdkLayer:Canvas;
      
      public var footballLayer:Canvas;
      
      public var barrageLayer:Canvas;
      
      public var recommendLayer:Canvas;
      
      public var loadingLayer:Canvas;
      
      public var controlBarLayer:Canvas;
      
      public var videolistLayer:Canvas;
      
      public var sleepLayer:Canvas;
      
      public var displayBarLayer:Canvas;
      
      public var trylookLayer:Canvas;
      
      public var extendLayer:Canvas;
      
      public var warnLayer:Canvas;
      
      public var debugLayer:Canvas;
      
      public var firstlookLayer:Canvas;
      
      public function PlayerLayer()
      {
         this.sdkLayer = new Canvas();
         this.footballLayer = new Canvas();
         this.barrageLayer = new Canvas();
         this.recommendLayer = new Canvas();
         this.loadingLayer = new Canvas();
         this.controlBarLayer = new Canvas();
         this.videolistLayer = new Canvas();
         this.sleepLayer = new Canvas();
         this.displayBarLayer = new Canvas();
         this.trylookLayer = new Canvas();
         this.extendLayer = new Canvas();
         this.warnLayer = new Canvas();
         this.debugLayer = new Canvas();
         this.firstlookLayer = new Canvas();
         super();
      }
      
      public static function getInstance() : PlayerLayer
      {
         if(_instance == null)
         {
            _instance = new PlayerLayer();
         }
         return _instance;
      }
      
      public function init(param1:Player) : void
      {
         this.main = param1;
         param1.setMsg(MyResource.POPUP,false);
         param1.setMsg(MyResource.R,MyResource.getInstance());
         param1.setMsg(MyResource.FACADE,MyFacade.getInstance());
         param1.setMsg(MyResource.UISTATE,UIState.INIT);
         this.sdkLayer.tabChildren = false;
         this.sdkLayer.tabEnabled = false;
         this.controlBarLayer.tabChildren = false;
         this.controlBarLayer.tabEnabled = false;
         this.displayBarLayer.tabChildren = false;
         this.displayBarLayer.tabEnabled = false;
         param1.addElement(this.sdkLayer);
         param1.addElement(this.footballLayer);
         param1.addElement(this.barrageLayer);
         param1.addElement(this.recommendLayer);
         param1.addElement(this.loadingLayer);
         param1.addElement(this.trylookLayer);
         param1.addElement(this.firstlookLayer);
         param1.addElement(this.sleepLayer);
         param1.addElement(this.controlBarLayer);
         param1.addElement(this.videolistLayer);
         param1.addElement(this.displayBarLayer);
         param1.addElement(this.warnLayer);
         param1.addElement(this.extendLayer);
         param1.addElement(this.debugLayer);
      }
      
      public function initPlugins(param1:Object) : void
      {
         if(param1 != null)
         {
            if(param1.hasOwnProperty(MyResource.SDK))
            {
               this.sdk = new com.letv.pluginsAPI.sdk.SDK(param1[MyResource.SDK]);
               this.main.setMsg(MyResource.SDK,this.sdk);
            }
            if(param1.hasOwnProperty(MyResource.RECOMMEND))
            {
               this.recommend = new Recommend(param1[MyResource.RECOMMEND]);
            }
            if(param1.hasOwnProperty(MyResource.SKIN_DOMAIN))
            {
               this.main.setMsg(MyResource.SKIN_DOMAIN,param1[MyResource.SKIN_DOMAIN]);
            }
         }
      }
      
      public function adLamuLayer() : void
      {
         this.sdkLayer.visible = true;
         this.barrageLayer.viewData = false;
         this.footballLayer.visible = false;
         this.recommendLayer.visible = false;
         this.loadingLayer.visible = false;
         this.trylookLayer.visible = false;
         this.firstlookLayer.visible = false;
         this.sleepLayer.visible = false;
         this.controlBarLayer.visible = false;
         this.videolistLayer.visible = false;
         this.extendLayer.visible = false;
      }
      
      public function adNormalLayer() : void
      {
         this.sdkLayer.visible = true;
         this.barrageLayer.visible = true;
         this.footballLayer.visible = true;
         this.recommendLayer.visible = true;
         this.loadingLayer.visible = true;
         this.trylookLayer.visible = true;
         this.firstlookLayer.visible = true;
         this.sleepLayer.visible = true;
         this.controlBarLayer.visible = true;
         this.videolistLayer.visible = true;
         this.displayBarLayer.visible = true;
         this.extendLayer.visible = true;
         this.main.addElement(this.sdkLayer);
         this.main.addElement(this.footballLayer);
         this.main.addElement(this.barrageLayer);
         this.main.addElement(this.recommendLayer);
         this.main.addElement(this.loadingLayer);
         this.main.addElement(this.trylookLayer);
         this.main.addElement(this.firstlookLayer);
         this.main.addElement(this.sleepLayer);
         this.main.addElement(this.controlBarLayer);
         this.main.addElement(this.videolistLayer);
         this.main.addElement(this.displayBarLayer);
         this.main.addElement(this.warnLayer);
         this.main.addElement(this.extendLayer);
         this.main.addElement(this.debugLayer);
      }
   }
}
