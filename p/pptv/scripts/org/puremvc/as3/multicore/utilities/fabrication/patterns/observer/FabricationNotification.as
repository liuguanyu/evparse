package org.puremvc.as3.multicore.utilities.fabrication.patterns.observer
{
   import org.puremvc.as3.multicore.patterns.observer.Notification;
   import org.puremvc.as3.multicore.utilities.fabrication.interfaces.IDisposable;
   
   public class FabricationNotification extends Notification implements IDisposable
   {
      
      public static const STARTUP:String = "startup";
      
      public static const SHUTDOWN:String = "shutdown";
      
      public static const BOOTSTRAP:String = "bootstrap";
      
      public static const UNDO:String = "undo";
      
      public static const REDO:String = "redo";
      
      public static const CHANGE_UNDO_GROUP:String = "changeUndoGroup";
      
      public function FabricationNotification(param1:String, param2:Object = null, param3:String = null)
      {
         super(param1,param2,param3);
      }
      
      public function steps() : int
      {
         return getBody() as int;
      }
      
      public function dispose() : void
      {
         setBody(null);
         setType(null);
      }
   }
}
