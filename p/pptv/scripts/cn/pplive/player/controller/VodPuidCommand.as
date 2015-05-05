package cn.pplive.player.controller
{
   import org.puremvc.as3.multicore.utilities.fabrication.patterns.command.SimpleFabricationCommand;
   import org.puremvc.as3.multicore.interfaces.INotification;
   import cn.pplive.player.common.*;
   
   public class VodPuidCommand extends SimpleFabricationCommand
   {
      
      public function VodPuidCommand()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         if(param1.getBody())
         {
            VodCommon.puid = param1.getBody()["value"] as String;
            if(param1.getBody()["rlen"])
            {
               VodCommon.cookie.setData("rlen",param1.getBody()["rlen"].toString());
            }
            sendNotification(VodNotification.VOD_PUID_SUCCESS);
         }
      }
   }
}
