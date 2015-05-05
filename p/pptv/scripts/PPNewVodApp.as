package
{
   import org.puremvc.as3.multicore.utilities.fabrication.components.FlashApplication;
   import cn.pplive.player.controller.VodStartUpCommand;
   import flash.utils.getDefinitionByName;
   
   public class PPNewVodApp extends FlashApplication
   {
      
      public function PPNewVodApp()
      {
         super();
      }
      
      override public function getStartupCommand() : Class
      {
         return VodStartUpCommand;
      }
      
      override public function getClassByName(param1:String) : Class
      {
         return getDefinitionByName(param1) as Class;
      }
   }
}
