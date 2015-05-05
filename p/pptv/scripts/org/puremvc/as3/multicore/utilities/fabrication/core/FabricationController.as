package org.puremvc.as3.multicore.utilities.fabrication.core
{
   import org.puremvc.as3.multicore.core.Controller;
   import org.puremvc.as3.multicore.utilities.fabrication.interfaces.IDisposable;
   import org.puremvc.as3.multicore.utilities.fabrication.utils.HashMap;
   import org.puremvc.as3.multicore.utilities.fabrication.patterns.interceptor.NotificationProcessor;
   import org.puremvc.as3.multicore.patterns.observer.Observer;
   import org.puremvc.as3.multicore.interfaces.INotification;
   import org.puremvc.as3.multicore.interfaces.ICommand;
   import org.puremvc.as3.multicore.utilities.fabrication.interfaces.IUndoableCommand;
   import org.puremvc.as3.multicore.patterns.observer.Notification;
   import org.puremvc.as3.multicore.utilities.fabrication.patterns.observer.UndoableNotification;
   import org.puremvc.as3.multicore.utilities.fabrication.vo.UndoRedoGroupStore;
   import org.puremvc.as3.multicore.utilities.fabrication.vo.InterceptorMapping;
   import org.puremvc.as3.multicore.utilities.fabrication.interfaces.IInterceptor;
   import org.puremvc.as3.multicore.utilities.fabrication.events.NotificationProcessorEvent;
   import org.puremvc.as3.multicore.utilities.fabrication.utils.Stack;
   
   public class FabricationController extends Controller implements IDisposable
   {
      
      public static const DEFAULT_GROUP_ID:String = "default";
      
      protected var groupsHashMap:HashMap;
      
      protected var _groupID:String = "default";
      
      protected var interceptorMappings:HashMap;
      
      protected var activeProcessors:Array;
      
      public function FabricationController(param1:String)
      {
         super(param1);
         this.groupsHashMap = new HashMap();
         this.interceptorMappings = new HashMap();
         this.activeProcessors = new Array();
      }
      
      public static function getInstance(param1:String) : FabricationController
      {
         if(instanceMap[param1] == null)
         {
            instanceMap[param1] = new FabricationController(param1);
         }
         return instanceMap[param1] as FabricationController;
      }
      
      public function dispose() : void
      {
         var _loc2_:NotificationProcessor = null;
         this.groupsHashMap.dispose();
         this.groupsHashMap = null;
         commandMap.splice(0);
         commandMap = null;
         var _loc1_:int = this.activeProcessors.length;
         var _loc3_:* = 0;
         while(_loc3_ < _loc1_)
         {
            _loc2_ = this.activeProcessors[_loc3_];
            _loc2_.dispose();
            this.activeProcessors[_loc3_] = null;
            _loc3_++;
         }
         this.interceptorMappings.dispose();
         this.interceptorMappings = null;
         this.activeProcessors = null;
         view = null;
         removeController(multitonKey);
      }
      
      override protected function initializeController() : void
      {
         view = FabricationView.getInstance(multitonKey);
      }
      
      override public function registerCommand(param1:String, param2:Class) : void
      {
         var _loc3_:Array = commandMap[param1];
         if(_loc3_ == null)
         {
            _loc3_ = commandMap[param1] = new Array();
            view.registerObserver(param1,new Observer(this.executeCommand,this));
         }
         _loc3_.push(param2);
      }
      
      override public function executeCommand(param1:INotification) : void
      {
         var _loc4_:ICommand = null;
         var _loc5_:Class = null;
         var _loc6_:IUndoableCommand = null;
         var _loc2_:Array = commandMap[param1.getName()];
         if(_loc2_ == null)
         {
            return;
         }
         var _loc3_:int = _loc2_.length;
         var _loc7_:* = 0;
         while(_loc7_ < _loc3_)
         {
            _loc5_ = _loc2_[_loc7_] as Class;
            _loc4_ = new _loc5_();
            _loc4_.initializeNotifier(multitonKey);
            if(_loc4_ is IUndoableCommand)
            {
               _loc6_ = _loc4_ as IUndoableCommand;
               _loc6_.initializeUndoableCommand(param1);
            }
            _loc4_.execute(param1);
            if(_loc4_ is IUndoableCommand)
            {
               this.addCommand(_loc6_);
            }
            else if(_loc4_ is IDisposable)
            {
               (_loc4_ as IDisposable).dispose();
            }
            
            _loc7_++;
         }
      }
      
      public function executeCommandClass(param1:Class, param2:Object = null, param3:INotification = null) : ICommand
      {
         if(param3 == null)
         {
            var param3:INotification = new Notification(null,param2);
         }
         var _loc4_:ICommand = new param1();
         _loc4_.initializeNotifier(multitonKey);
         if(_loc4_ is IUndoableCommand)
         {
            (_loc4_ as IUndoableCommand).initializeUndoableCommand(param3);
         }
         _loc4_.execute(param3);
         return _loc4_;
      }
      
      public function removeSingleCommand(param1:String, param2:Class) : void
      {
         var _loc3_:Array = null;
         var _loc4_:* = 0;
         if(hasCommand(param1))
         {
            _loc3_ = commandMap[param1] as Array;
            if(_loc3_.length == 1)
            {
               removeCommand(param1);
            }
            else
            {
               _loc4_ = this.findCommandIndex(_loc3_,param2);
               if(_loc4_ >= 0)
               {
                  _loc3_.splice(_loc4_,1);
               }
            }
         }
      }
      
      public function canUndo() : Boolean
      {
         return !this.undoStack.isEmpty();
      }
      
      public function canRedo() : Boolean
      {
         return !this.redoStack.isEmpty();
      }
      
      public function undoSize() : int
      {
         return this.undoStack.length();
      }
      
      public function redoSize() : int
      {
         return this.redoStack.length();
      }
      
      public function undo(param1:int = 1) : Boolean
      {
         var _loc3_:IUndoableCommand = null;
         var _loc2_:* = false;
         var _loc4_:* = 0;
         while(_loc4_ < param1)
         {
            if(!this.undoStack.isEmpty())
            {
               _loc3_ = this.undoStack.pop() as IUndoableCommand;
               this.unexecuteCommand(_loc3_,_loc3_.getNotification());
               this.redoStack.push(_loc3_);
               _loc2_ = true;
            }
            _loc4_++;
         }
         if(_loc2_)
         {
            this.notifyCommandHistoryChanged();
         }
         return _loc2_;
      }
      
      public function redo(param1:int = 1) : Boolean
      {
         var _loc3_:IUndoableCommand = null;
         var _loc2_:* = false;
         var _loc4_:* = 0;
         while(_loc4_ < param1)
         {
            if(!this.redoStack.isEmpty())
            {
               _loc3_ = this.redoStack.pop() as IUndoableCommand;
               _loc3_.execute(_loc3_.getNotification());
               this.undoStack.push(_loc3_);
               _loc2_ = true;
            }
            _loc4_++;
         }
         if(_loc2_)
         {
            this.notifyCommandHistoryChanged();
         }
         return _loc2_;
      }
      
      protected function addCommand(param1:IUndoableCommand) : void
      {
         this.redoStack.clear();
         if((this.undoStack.isEmpty()) || !(this.undoStack.peek() as IUndoableCommand).merge(param1))
         {
            this.undoStack.push(param1);
         }
         this.notifyCommandHistoryChanged();
      }
      
      protected function unexecuteCommand(param1:IUndoableCommand, param2:INotification) : void
      {
         param1.unexecute(param2);
      }
      
      protected function notifyCommandHistoryChanged() : void
      {
         var _loc1_:UndoableNotification = new UndoableNotification(UndoableNotification.COMMAND_HISTORY_CHANGED);
         _loc1_.undoable = this.canUndo();
         _loc1_.redoable = this.canRedo();
         _loc1_.undoableCommands = this.undoStack.getElements();
         _loc1_.redoableCommands = this.redoStack.getElements();
         _loc1_.groupID = this.groupID;
         if(_loc1_.undoable)
         {
            _loc1_.undoCommand = (this.undoStack.peek() as IUndoableCommand).getUndoPresentationName();
         }
         if(_loc1_.redoable)
         {
            _loc1_.redoCommand = (this.redoStack.peek() as IUndoableCommand).getRedoPresentationName();
         }
         view.notifyObservers(_loc1_);
      }
      
      protected function notifyCommandGroupChanged() : void
      {
         var _loc1_:UndoableNotification = new UndoableNotification(UndoableNotification.COMMAND_GROUP_CHANGED);
         view.notifyObservers(_loc1_);
      }
      
      private function findCommandIndex(param1:Array, param2:Class) : int
      {
         var _loc4_:Class = null;
         var _loc3_:int = param1.length;
         var _loc5_:* = 0;
         while(_loc5_ < _loc3_)
         {
            _loc4_ = param1[_loc5_];
            if(_loc4_ == param2)
            {
               return _loc5_;
            }
            _loc5_++;
         }
         return -1;
      }
      
      public function get groupID() : String
      {
         return this._groupID;
      }
      
      public function set groupID(param1:String) : void
      {
         if(param1 == null || param1 == "")
         {
            throw new Error("groupID must not be null.");
         }
         else
         {
            this._groupID = param1;
            this.notifyCommandGroupChanged();
            this.notifyCommandHistoryChanged();
            return;
         }
      }
      
      public function removeGroup(param1:String) : void
      {
         var _loc2_:UndoRedoGroupStore = this.getUndoRedoGroupStore(param1);
         if(_loc2_ != null)
         {
            _loc2_.dispose();
            this.groupsHashMap.remove(param1);
         }
      }
      
      public function registerInterceptor(param1:String, param2:Class, param3:Object = null) : void
      {
         var _loc4_:Array = null;
         if(this.interceptorMappings.exists(param1))
         {
            _loc4_ = this.interceptorMappings.find(param1) as Array;
         }
         else
         {
            _loc4_ = this.interceptorMappings.put(param1,new Array()) as Array;
         }
         _loc4_.push(new InterceptorMapping(param1,param2,param3));
      }
      
      public function removeInterceptor(param1:String, param2:Class = null) : void
      {
         var _loc3_:Array = null;
         var _loc4_:* = 0;
         var _loc5_:* = 0;
         var _loc6_:* = 0;
         if(param2 == null)
         {
            this.interceptorMappings.remove(param1);
         }
         else
         {
            _loc3_ = this.interceptorMappings.find(param1) as Array;
            _loc4_ = -1;
            _loc5_ = _loc3_.length;
            _loc6_ = 0;
            while(_loc6_ < _loc5_)
            {
               if(_loc3_[_loc6_].clazz == param2)
               {
                  _loc4_ = _loc6_;
                  break;
               }
               _loc6_++;
            }
            if(_loc4_ >= 0)
            {
               _loc3_.splice(param2,1);
            }
            if(_loc3_.length == 0)
            {
               this.interceptorMappings.remove(param1);
            }
         }
      }
      
      public function hasInterceptor(param1:String) : Boolean
      {
         return this.interceptorMappings.exists(param1);
      }
      
      public function intercept(param1:INotification) : Boolean
      {
         var _loc3_:Array = null;
         var _loc4_:NotificationProcessor = null;
         var _loc5_:* = 0;
         var _loc6_:IInterceptor = null;
         var _loc7_:InterceptorMapping = null;
         var _loc8_:* = 0;
         var _loc2_:String = param1.getName();
         if(this.hasInterceptor(_loc2_))
         {
            _loc3_ = this.interceptorMappings.find(_loc2_) as Array;
            _loc4_ = new NotificationProcessor(param1);
            _loc5_ = _loc3_.length;
            _loc8_ = 0;
            while(_loc8_ < _loc5_)
            {
               _loc7_ = _loc3_[_loc8_];
               _loc6_ = this.createInterceptor(_loc7_);
               _loc4_.addInterceptor(_loc6_);
               _loc8_++;
            }
            _loc4_.addEventListener(NotificationProcessorEvent.PROCEED,this.proceedListener);
            _loc4_.addEventListener(NotificationProcessorEvent.FINISH,this.finishListener);
            _loc4_.run();
            return true;
         }
         return false;
      }
      
      public function get fabricationView() : FabricationView
      {
         return view as FabricationView;
      }
      
      protected function createInterceptor(param1:InterceptorMapping) : IInterceptor
      {
         var _loc2_:Class = param1.clazz;
         var _loc3_:IInterceptor = new _loc2_() as IInterceptor;
         _loc3_.initializeNotifier(multitonKey);
         _loc3_.parameters = param1.parameters;
         return _loc3_;
      }
      
      protected function proceedListener(param1:NotificationProcessorEvent) : void
      {
         var _loc2_:NotificationProcessor = param1.target as NotificationProcessor;
         var _loc3_:INotification = param1.notification;
         if(_loc3_ == null)
         {
            _loc3_ = _loc2_.getNotification();
         }
         this.fabricationView.notifyObserversAfterInterception(_loc3_);
      }
      
      protected function finishListener(param1:NotificationProcessorEvent) : void
      {
         var _loc2_:NotificationProcessor = param1.target as NotificationProcessor;
         this.removeProcessor(_loc2_);
      }
      
      protected function addProcessor(param1:NotificationProcessor) : void
      {
         this.activeProcessors.push(param1);
      }
      
      protected function removeProcessor(param1:NotificationProcessor) : void
      {
         var _loc2_:int = this.activeProcessors.indexOf(param1);
         if(_loc2_ >= 0)
         {
            param1.removeEventListener(NotificationProcessorEvent.PROCEED,this.proceedListener);
            param1.removeEventListener(NotificationProcessorEvent.FINISH,this.finishListener);
            this.activeProcessors.splice(_loc2_,1);
         }
      }
      
      protected function getUndoRedoGroupStore(param1:String = null) : UndoRedoGroupStore
      {
         if(param1 == null)
         {
            var param1:String = this.groupID;
         }
         var _loc2_:UndoRedoGroupStore = this.groupsHashMap.find(param1) as UndoRedoGroupStore;
         if(_loc2_ == null)
         {
            _loc2_ = this.createUndoRedoGroupStore(param1);
         }
         return _loc2_;
      }
      
      protected function createUndoRedoGroupStore(param1:String = null) : UndoRedoGroupStore
      {
         return this.groupsHashMap.put(param1,new UndoRedoGroupStore(new Stack(),new Stack())) as UndoRedoGroupStore;
      }
      
      protected function get undoStack() : Stack
      {
         return this.getUndoRedoGroupStore().undoStack;
      }
      
      protected function get redoStack() : Stack
      {
         return this.getUndoRedoGroupStore().redoStack;
      }
   }
}
