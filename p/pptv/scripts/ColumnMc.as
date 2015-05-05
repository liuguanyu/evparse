package
{
   import pptv.skin.view.ui.ColumnUI;
   
   public dynamic class ColumnMc extends ColumnUI
   {
      
      public function ColumnMc()
      {
         super();
         addFrameScript(0,this.frame1);
      }
      
      function frame1() : *
      {
         stop();
      }
   }
}
