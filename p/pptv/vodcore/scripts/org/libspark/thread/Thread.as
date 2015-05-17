package org.libspark.thread
{
	import flash.events.IEventDispatcher;
	import org.libspark.thread.errors.CurrentThreadNotFoundError;
	import flash.utils.Dictionary;
	import flash.events.Event;
	import flash.utils.getQualifiedClassName;
	import flash.utils.getQualifiedSuperclassName;
	import flash.utils.getDefinitionByName;
	import org.libspark.thread.errors.IllegalThreadStateError;
	import org.libspark.thread.errors.InterruptedError;
	import org.libspark.thread.errors.ThreadLibraryNotInitializedError;
	
	public class Thread extends Monitor
	{
		
		private static var _toplevelThreads:Array = [];
		
		private static var _currentThread:Thread = null;
		
		private static var _threadIndex:uint = 0;
		
		private static var _executor:IThreadExecutor;
		
		private static var _uncaughtErrorHandler:Function = null;
		
		private var _error:Object;
		
		private var _joinMonitor:IMonitor;
		
		private var _state:uint;
		
		private var _errorHandlers:Dictionary;
		
		private var _event:Event;
		
		private var _eventHandlers:Array;
		
		private var _eventMonitor:IMonitor;
		
		private var _isInterrupted:Boolean;
		
		private var _id:uint;
		
		private var _interruptedHandler:Function;
		
		private var _timeoutHandler:Function;
		
		private var _children:Array;
		
		private var _runHandler:Function;
		
		private var _waitMonitor:IMonitor;
		
		private var _savedRunHandler:Function;
		
		private var _name:String;
		
		private var _sleepMonitor:IMonitor;
		
		private var _errorThread:Thread;
		
		private var _runningState:uint;
		
		public function Thread()
		{
			super();
			_id = ++_threadIndex;
			_name = "Thread" + _id;
			_state = ThreadState.NEW;
			_runningState = ThreadState.NEW;
			_children = null;
			_runHandler = null;
			_savedRunHandler = null;
			_timeoutHandler = null;
			_interruptedHandler = null;
			_waitMonitor = null;
			_joinMonitor = null;
			_sleepMonitor = null;
			_eventMonitor = null;
			_event = null;
			_errorHandlers = null;
			_error = null;
			_errorThread = null;
			_eventHandlers = null;
			_isInterrupted = false;
		}
		
		public static function interrupted(param1:Function) : void
		{
			getCurrentThread()._interruptedHandler = param1;
		}
		
		private static function getUncaughtErrorHandler() : Function
		{
			return uncaughtErrorHandler || defaultUncaughtErrorHandler;
		}
		
		public static function error(param1:Class, param2:Function, param3:Boolean = true) : void
		{
			if(param2 != null)
			{
				getCurrentThread().addErrorHandler(param1,param2,param3);
			}
			else
			{
				getCurrentThread().removeErrorHandler(param1);
			}
		}
		
		public static function initialize(param1:IThreadExecutor) : void
		{
			_threadIndex = 0;
			_currentThread = null;
			_toplevelThreads.length = 0;
			if(_executor != null)
			{
				_executor.stop();
			}
			_executor = param1;
			if(_executor != null)
			{
				_executor.start();
			}
		}
		
		public static function get uncaughtErrorHandler() : Function
		{
			return _uncaughtErrorHandler;
		}
		
		public static function get isReady() : Boolean
		{
			return !(_executor == null);
		}
		
		public static function event(param1:IEventDispatcher, param2:String, param3:Function, param4:Boolean = false, param5:int = 0, param6:Boolean = false) : void
		{
			getCurrentThread().addEventHandler(param1,param2,param3,param4,param5,param6);
		}
		
		public static function executeAllThreads() : void
		{
			var thread:Thread = null;
			var threads:Array = _toplevelThreads;
			var l:uint = threads.length;
			var i:uint = 0;
			while(i < l)
			{
				thread = Thread(threads[i]);
				if(!thread.execute())
				{
					threads.splice(i,1);
					l--;
				}
				else
				{
					i++;
				}
				if(!(thread._error == null) && !(thread._errorThread == null))
				{
					try
					{
						getUncaughtErrorHandler()(thread._error,thread._errorThread);
					}
					catch(e:Object)
					{
						defaultUncaughtErrorHandler(e,null);
					}
					thread._error = null;
					thread._errorThread = null;
				}
			}
		}
		
		public static function sleep(param1:uint) : void
		{
			if(param1 == 0)
			{
				var param1:uint = 1;
			}
			var _loc2:Thread = getCurrentThread();
			if(_loc2._sleepMonitor == null)
			{
				_loc2._sleepMonitor = new Monitor();
			}
			_loc2._sleepMonitor.wait(param1);
		}
		
		public static function timeout(param1:Function) : void
		{
			getCurrentThread()._timeoutHandler = param1;
		}
		
		public static function get currentThread() : Thread
		{
			return _currentThread;
		}
		
		static function getCurrentThread() : Thread
		{
			var _loc1:Thread = currentThread;
			if(_loc1 != null)
			{
				return _loc1;
			}
			throw new CurrentThreadNotFoundError("Expected Thread.currentThread is not null, but actual null.");
		}
		
		public static function set uncaughtErrorHandler(param1:Function) : void
		{
			_uncaughtErrorHandler = param1;
		}
		
		public static function next(param1:Function) : void
		{
			getCurrentThread()._runHandler = param1;
		}
		
		private static function defaultUncaughtErrorHandler(param1:Object, param2:Thread) : void
		{
			trace((param2?param2.toString() + " ":"") + (param1 is Error?Error(param1).getStackTrace():param1.toString()));
		}
		
		private static function addToplevelThreads(param1:Array) : void
		{
			_toplevelThreads.push.apply(_toplevelThreads,param1);
		}
		
		private static function addToplevelThread(param1:Thread) : void
		{
			_toplevelThreads.push(param1);
		}
		
		public static function checkInterrupted() : Boolean
		{
			var _loc1:Thread = getCurrentThread();
			var _loc2:Boolean = _loc1._isInterrupted;
			if(_loc2)
			{
				_loc1._isInterrupted = false;
			}
			return _loc2;
		}
		
		private function resetErrorHandlers() : void
		{
			var _loc1:String = null;
			if(_errorHandlers == null)
			{
				return;
			}
			for(_loc1 in _errorHandlers)
			{
				if(ErrorHandler(_errorHandlers[_loc1]).reset)
				{
					delete _errorHandlers[_loc1];
					true;
				}
			}
		}
		
		private function execute() : Boolean
		{
			var _loc4:uint = 0;
			var _loc5:uint = 0;
			var _loc6:Thread = null;
			if(_state == ThreadState.NEW)
			{
				return true;
			}
			if(_state == ThreadState.TERMINATED)
			{
				return false;
			}
			var _loc1:Object = _error;
			var _loc2:Thread = _errorThread || this;
			var _loc3:Array = _children;
			if(_loc3 != null)
			{
				_loc4 = _loc3.length;
				_loc5 = 0;
				while(_loc5 < _loc4)
				{
					_loc6 = Thread(_loc3[_loc5]);
					if(!_loc6.execute())
					{
						_loc3.splice(_loc5,1);
						_loc4--;
					}
					else
					{
						_loc5++;
					}
					if(!(_loc6._error == null) && !(_loc6._errorThread == null) && _loc1 == null)
					{
						_loc1 = _loc6._error;
						_loc2 = _loc6._errorThread;
						_loc6._error = null;
						_loc6._errorThread = null;
					}
				}
			}
			return internalExecute(_loc1,_loc2);
		}
		
		public function get name() : String
		{
			return _name;
		}
		
		private function resetEventHandlers() : void
		{
			var _loc1:EventHandler = null;
			if(_eventHandlers == null)
			{
				return;
			}
			for each(_loc1 in _eventHandlers)
			{
				_loc1.unregister();
			}
			_eventHandlers.length = 0;
		}
		
		public function set name(param1:String) : void
		{
			_name = param1;
		}
		
		public function get state() : uint
		{
			return _state;
		}
		
		private function getJoinMonitor() : IMonitor
		{
			return _joinMonitor || (_joinMonitor = new Monitor());
		}
		
		protected function finalize() : void
		{
		}
		
		private function getErrorHandler(param1:Object) : ErrorHandler
		{
			var handler:ErrorHandler = null;
			var error:Object = param1;
			if(_errorHandlers == null)
			{
				return null;
			}
			var className:String = getQualifiedClassName(error);
			while(className != null)
			{
				handler = _errorHandlers[className];
				if(handler != null)
				{
					return handler;
				}
				try
				{
					className = getQualifiedSuperclassName(getDefinitionByName(className));
				}
				catch(e:ReferenceError)
				{
					className = null;
					continue;
				}
			}
			return null;
		}
		
		private function addEventHandler(param1:IEventDispatcher, param2:String, param3:Function, param4:Boolean, param5:int, param6:Boolean) : void
		{
			getEventHandlers().push(new EventHandler(param1,param2,eventHandler,param3,param4,param5,param6));
		}
		
		public function get className() : String
		{
			var _loc1:Array = getQualifiedClassName(this).split(new RegExp("::"));
			return _loc1.length == 2?_loc1[1]:_loc1[0];
		}
		
		public function toString() : String
		{
			return formatName(name);
		}
		
		function monitorTimeout(param1:IMonitor) : void
		{
			if(!(_state == ThreadState.TIMED_WAITING) || !(_waitMonitor == param1))
			{
				throw new IllegalThreadStateError("Thread can not wakeup.");
			}
			else
			{
				_state = _runningState;
				if(_waitMonitor != _sleepMonitor)
				{
					if(_timeoutHandler != null)
					{
						_runHandler = _timeoutHandler;
					}
				}
				_waitMonitor = null;
				return;
			}
		}
		
		protected function formatName(param1:String) : String
		{
			return "[" + className + " " + param1 + "]";
		}
		
		public function join(param1:uint = 0) : Boolean
		{
			if(_state == ThreadState.TERMINATED)
			{
				return false;
			}
			getJoinMonitor().wait(param1);
			return true;
		}
		
		protected function run() : void
		{
		}
		
		public function get isInterrupted() : Boolean
		{
			return _isInterrupted;
		}
		
		function monitorWakeup(param1:IMonitor) : void
		{
			if(!(_state == ThreadState.WAITING) && !(_state == ThreadState.TIMED_WAITING) || !(_waitMonitor == param1))
			{
				throw new IllegalThreadStateError("Thread can not wakeup.");
			}
			else
			{
				_state = _runningState;
				_waitMonitor = null;
				return;
			}
		}
		
		public function get id() : uint
		{
			return _id;
		}
		
		private function removeErrorHandler(param1:Class) : void
		{
			if(_errorHandlers == null)
			{
				return;
			}
			delete _errorHandlers[getQualifiedClassName(param1)];
			true;
		}
		
		private function eventHandler(param1:Event, param2:EventHandler) : void
		{
			var e:Event = param1;
			var handler:EventHandler = param2;
			if(_event != null)
			{
				return;
			}
			_event = e;
			_runHandler = handler.func;
			resetEventHandlers();
			if(_waitMonitor != null)
			{
				_waitMonitor.leave(this);
				_waitMonitor = null;
			}
			_state = _runningState;
			var current:Thread = _currentThread;
			try
			{
				internalExecute(null,this);
			}
			finally
			{
				_currentThread = current;
			}
		}
		
		private function getEventMonitor() : IMonitor
		{
			return _eventMonitor || (_eventMonitor = new Monitor());
		}
		
		private function getErrorHandlers() : Dictionary
		{
			return _errorHandlers || (_errorHandlers = new Dictionary());
		}
		
		public function interrupt() : void
		{
			if(_state == ThreadState.WAITING || _state == ThreadState.TIMED_WAITING)
			{
				_waitMonitor.leave(this);
				_waitMonitor = null;
				_state = _runningState;
				if(_interruptedHandler != null)
				{
					_runHandler = _interruptedHandler;
				}
				else
				{
					_error = new InterruptedError();
				}
			}
			else
			{
				_isInterrupted = true;
			}
		}
		
		public function start() : void
		{
			if(!isReady)
			{
				throw new ThreadLibraryNotInitializedError("Thread Library is not initialized. Please call Thread#initialize before.");
			}
			else if(_state != ThreadState.NEW)
			{
				throw new IllegalThreadStateError("Thread is already running.");
			}
			else
			{
				_state = ThreadState.RUNNABLE;
				_runningState = ThreadState.RUNNABLE;
				_runHandler = run;
				var _loc1:Thread = currentThread;
				if(_loc1 != null)
				{
					_loc1.addChildThread(this);
				}
				else
				{
					addToplevelThread(this);
				}
				return;
			}
			
		}
		
		private function addChildThread(param1:Thread) : void
		{
			getChildren().push(param1);
		}
		
		function monitorWait(param1:Boolean, param2:IMonitor) : void
		{
			if(!(_state == ThreadState.RUNNABLE) && !(_state == ThreadState.TERMINATING) || !(_waitMonitor == null))
			{
				throw new IllegalThreadStateError("Thread can not wait.");
			}
			else
			{
				_state = param1?ThreadState.TIMED_WAITING:ThreadState.WAITING;
				_waitMonitor = param2;
				return;
			}
		}
		
		private function getChildren() : Array
		{
			return _children || (_children = []);
		}
		
		private function addErrorHandler(param1:Class, param2:Function, param3:Boolean) : void
		{
			getErrorHandlers()[getQualifiedClassName(param1)] = new ErrorHandler(param2,param3);
		}
		
		private function getEventHandlers() : Array
		{
			return _eventHandlers || (_eventHandlers = []);
		}
		
		private function internalExecute(param1:Object, param2:Thread) : Boolean
		{
			/*
			 * Decompilation error
			 * Code may be obfuscated
			 * Tip: You can try enabling "Automatic deobfuscation" in Settings
			 * Error type: TranslateException (printGraph max recursion level reached.)
			 */
			throw new flash.errors.IllegalOperationError("Not decompiled due to error");
		}
	}
}

class ErrorHandler extends Object
{
	
	public var handler:Function;
	
	public var reset:Boolean;
	
	function ErrorHandler(param1:Function, param2:Boolean)
	{
		super();
		this.handler = param1;
		this.reset = param2;
	}
}

import flash.events.IEventDispatcher;
import flash.events.Event;

class EventHandler extends Object
{
	
	public var priority:int;
	
	public var dispatcher:IEventDispatcher;
	
	public var func:Function;
	
	public var useWeakReference:Boolean;
	
	public var listener:Function;
	
	public var type:String;
	
	public var useCapture:Boolean;
	
	function EventHandler(param1:IEventDispatcher, param2:String, param3:Function, param4:Function, param5:Boolean, param6:int, param7:Boolean)
	{
		super();
		this.dispatcher = param1;
		this.type = param2;
		this.listener = param3;
		this.func = param4;
		this.useCapture = param5;
		this.priority = param6;
		this.useWeakReference = param7;
	}
	
	public function register() : void
	{
		dispatcher.addEventListener(type,handler,useCapture,priority,useWeakReference);
	}
	
	private function handler(param1:Event) : void
	{
		listener(param1,this);
	}
	
	public function unregister() : void
	{
		dispatcher.removeEventListener(type,handler,useCapture);
	}
}
