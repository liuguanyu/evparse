package mx.core
{
   import flash.display.MovieClip;
   import mx.utils.NameUtil;
   
   public class FlexMovieClip extends MovieClip
   {
      
      mx_internal  static const VERSION:String = "4.10.0.0";
      
      public function FlexMovieClip()
      {
         super();
         try
         {
            name = NameUtil.createUniqueName(this);
         }
         catch(e:Error)
         {
         }
      }
      
      override public function toString() : String
      {
         return NameUtil.displayObjectToString(this);
      }
   }
}
