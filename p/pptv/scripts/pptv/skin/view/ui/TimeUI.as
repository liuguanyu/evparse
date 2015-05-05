package pptv.skin.view.ui
{
   import flash.display.MovieClip;
   import flash.text.TextField;
   import cn.pplive.player.utils.CommonUtils;
   
   public class TimeUI extends MovieClip
   {
      
      public var posiTime:TextField;
      
      private var $posiTimeTxt:TextField;
      
      private var $color:String = "#999999";
      
      public function TimeUI()
      {
         super();
         this.$posiTimeTxt = this.getChildByName("posiTime") as TextField;
      }
      
      public function setTimeArea(param1:Object) : void
      {
         var _loc2_:* = NaN;
         if(param1["playmodel"] == "vod")
         {
            _loc2_ = param1["posi"];
         }
         else if(param1["playmodel"] == "live")
         {
            _loc2_ = param1["posi"] - param1["start"] < 0?0:param1["posi"] - param1["start"];
         }
         
         this.$posiTimeTxt.htmlText = CommonUtils.getHtml(CommonUtils.setTimeFormat(_loc2_,false),"#9b999b") + CommonUtils.getHtml(" / " + CommonUtils.setTimeFormat(param1["dur"],false),"#696669");
      }
      
      public function reset() : void
      {
         this.$posiTimeTxt.htmlText = CommonUtils.getHtml("00:00:00 / 00:00:00");
      }
   }
}
