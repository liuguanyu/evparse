package org.puremvc.as3.multicore.utilities.fabrication.vo
{
   import org.puremvc.as3.multicore.utilities.fabrication.interfaces.IDisposable;
   import org.puremvc.as3.multicore.utilities.fabrication.utils.Stack;
   
   public class UndoRedoGroupStore extends Object implements IDisposable
   {
      
      public var undoStack:Stack;
      
      public var redoStack:Stack;
      
      public function UndoRedoGroupStore(param1:Stack, param2:Stack)
      {
         super();
         this.undoStack = param1;
         this.redoStack = param2;
      }
      
      public function dispose() : void
      {
         this.undoStack.dispose();
         this.undoStack = null;
         this.redoStack.dispose();
         this.redoStack = null;
      }
   }
}
