package org.puremvc.as3.multicore.utilities.fabrication.patterns.observer
{
   import org.puremvc.as3.multicore.patterns.observer.Notification;
   import org.puremvc.as3.multicore.utilities.fabrication.interfaces.IDisposable;
   
   public class UndoableNotification extends Notification implements IDisposable
   {
      
      public static const COMMAND_HISTORY_CHANGED:String = "commandHistoryChanged";
      
      public static const COMMAND_GROUP_CHANGED:String = "commandGroupChanged";
      
      public var undoable:Boolean;
      
      public var redoable:Boolean;
      
      public var undoableCommands:Array;
      
      public var redoableCommands:Array;
      
      public var undoCommand:String;
      
      public var redoCommand:String;
      
      public var groupID:String;
      
      public function UndoableNotification(param1:String, param2:Object = null, param3:String = null)
      {
         super(param1,param2,param3);
      }
      
      override public function toString() : String
      {
         return "UndoableNotification : " + "\r\tundoable : " + this.undoable + "\r\tredoable : " + this.redoable;
      }
      
      public function dispose() : void
      {
         setBody(null);
         setType(null);
         this.undoableCommands = null;
         this.redoableCommands = null;
         this.undoCommand = null;
         this.redoCommand = null;
         this.groupID = null;
      }
   }
}
