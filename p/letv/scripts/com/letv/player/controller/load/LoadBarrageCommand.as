package com.letv.player.controller.load
{
   import org.puremvc.as3.patterns.command.SimpleCommand;
   import org.puremvc.as3.interfaces.INotification;
   import com.letv.player.model.proxy.BarrageProxy;
   import com.letv.player.controller.command.BarrageCommand;
   
   public class LoadBarrageCommand extends SimpleCommand
   {
      
      public function LoadBarrageCommand()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         var _loc3_:Object = null;
         var _loc4_:BarrageProxy = null;
         var _loc2_:Object = param1.getBody();
         if(_loc2_.hasOwnProperty("command"))
         {
            _loc3_ = _loc2_.command;
            if(!facade.hasProxy(BarrageProxy.NAME))
            {
               facade.registerProxy(new BarrageProxy());
            }
            _loc4_ = facade.retrieveProxy(BarrageProxy.NAME) as BarrageProxy;
            switch(_loc3_)
            {
               case BarrageCommand.LOOP_BARRAGE:
                  _loc4_.loop(_loc2_.value);
                  break;
               case BarrageCommand.INIT_BARRAGE:
                  _loc4_.init();
                  break;
               case BarrageCommand.ADD_BARRAGE:
                  _loc4_.add(_loc2_.value);
                  break;
               case BarrageCommand.RESET_BARRAGE:
                  _loc4_.reset(_loc2_.value);
                  break;
               case BarrageCommand.SHUTDOWN_BARRAGE:
                  _loc4_.destroy();
                  break;
               case BarrageCommand.DOWNLOAD_BARRAGE:
                  _loc4_.download(_loc2_.value);
                  break;
               case BarrageCommand.UPLOAD_BARRAGE:
                  _loc4_.upload(_loc2_.value);
                  break;
            }
         }
      }
   }
}
