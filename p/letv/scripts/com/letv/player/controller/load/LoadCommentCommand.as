package com.letv.player.controller.load
{
   import org.puremvc.as3.patterns.command.SimpleCommand;
   import org.puremvc.as3.interfaces.INotification;
   import com.letv.player.model.proxy.CommentProxy;
   
   public class LoadCommentCommand extends SimpleCommand
   {
      
      public function LoadCommentCommand()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         facade.registerProxy(new CommentProxy());
         var _loc2_:CommentProxy = facade.retrieveProxy(CommentProxy.NAME) as CommentProxy;
         _loc2_.load(param1.getBody());
      }
   }
}
