package com.letv.player.components
{
   import flash.display.MovieClip;
   
   public dynamic class RecommendLoading extends MovieClip
   {
      
      public function RecommendLoading()
      {
         super();
         addFrameScript(0,this.frame1,1,this.frame2);
      }
      
      function frame1() : *
      {
         stop();
      }
      
      function frame2() : *
      {
         stop();
      }
   }
}
