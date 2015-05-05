package pptv.skin.view.ui
{
   import flash.display.MovieClip;
   import flash.display.LoaderInfo;
   import flash.display.Loader;
   import flash.events.Event;
   import flash.geom.Rectangle;
   import flash.net.URLRequest;
   
   public class StartFreshUI extends MovieClip
   {
      
      private var Loading:Class;
      
      private var $content:MovieClip;
      
      private var $info:LoaderInfo;
      
      private var _ld:Loader;
      
      private var $cw:Number;
      
      private var $ch:Number;
      
      public function StartFreshUI()
      {
         this.Loading = StartFreshUI_Loading;
         super();
         var _loc1_:* = new this.Loading();
         var _loc2_:Loader = Loader(_loc1_.getChildAt(0));
         _loc2_.contentLoaderInfo.addEventListener(Event.COMPLETE,this.onCompleteHandler);
      }
      
      private function onCompleteHandler(param1:Event) : void
      {
         while(this.numChildren > 0)
         {
            this.removeChildAt(0);
         }
         this.$info = param1.target as LoaderInfo;
         this.$content = this.$info.content as MovieClip;
         addChild(this.$content);
         this.setSize(this.$cw,this.$ch);
      }
      
      public function setSize(param1:Number, param2:Number) : void
      {
         var _loc3_:* = NaN;
         var _loc4_:* = NaN;
         var _loc5_:* = NaN;
         var _loc6_:* = NaN;
         this.$cw = param1;
         this.$ch = param2;
         try
         {
            _loc3_ = this.$info.width;
            _loc4_ = this.$info.height;
            _loc5_ = _loc3_ / _loc4_;
            this.$content.scrollRect = new Rectangle(0,0,_loc3_,_loc4_);
            if(_loc3_ > this.$cw || _loc4_ > this.$ch)
            {
               _loc6_ = _loc3_ / _loc4_;
               if(this.$cw / this.$ch > _loc6_)
               {
                  _loc4_ = this.$ch;
                  _loc3_ = Math.round(_loc4_ * _loc6_);
                  this.$content.scaleX = this.$content.scaleY = _loc4_ / this.$info.height;
               }
               else
               {
                  _loc3_ = this.$cw;
                  _loc4_ = Math.round(_loc3_ / _loc6_);
                  this.$content.scaleX = this.$content.scaleY = _loc3_ / this.$info.width;
               }
            }
            else
            {
               _loc3_ = this.$info.width;
               _loc4_ = this.$info.height;
               this.$content.scaleX = this.$content.scaleY = 1;
            }
            this.x = this.$cw - _loc3_ >> 1;
            this.y = this.$ch - _loc4_ >> 1;
         }
         catch(evt:Error)
         {
         }
         if(this._ld)
         {
            this.x = this.$cw - this._ld.width >> 1;
            this.y = this.$ch - this._ld.height >> 1;
         }
      }
      
      public function changeRU(param1:String) : void
      {
         while(this.numChildren > 0)
         {
            this.removeChildAt(0);
         }
         this._ld = new Loader();
         addChild(this._ld);
         try
         {
            this._ld.load(new URLRequest(param1));
         }
         catch(e:Error)
         {
         }
      }
   }
}
