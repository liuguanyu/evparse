package org.puremvc.as3.core
{
   import org.puremvc.as3.interfaces.*;
   import org.puremvc.as3.patterns.observer.Observer;
   
   public class View extends Object implements IView
   {
      
      protected static var instance:IView;
      
      protected var mediatorMap:Array;
      
      protected var observerMap:Array;
      
      protected const SINGLETON_MSG:String = "View Singleton already constructed!";
      
      public function View()
      {
         super();
         if(instance != null)
         {
            throw Error(this.SINGLETON_MSG);
         }
         else
         {
            instance = this;
            this.mediatorMap = new Array();
            this.observerMap = new Array();
            this.initializeView();
            return;
         }
      }
      
      public static function getInstance() : IView
      {
         if(instance == null)
         {
            instance = new View();
         }
         return instance;
      }
      
      protected function initializeView() : void
      {
      }
      
      public function registerObserver(param1:String, param2:IObserver) : void
      {
         var _loc3_:Array = this.observerMap[param1];
         if(_loc3_)
         {
            _loc3_.push(param2);
         }
         else
         {
            this.observerMap[param1] = [param2];
         }
      }
      
      public function notifyObservers(param1:INotification) : void
      {
         var _loc2_:Array = null;
         var _loc3_:Array = null;
         var _loc4_:IObserver = null;
         var _loc5_:* = NaN;
         if(this.observerMap[param1.getName()] != null)
         {
            _loc2_ = this.observerMap[param1.getName()] as Array;
            _loc3_ = new Array();
            _loc5_ = 0;
            while(_loc5_ < _loc2_.length)
            {
               _loc4_ = _loc2_[_loc5_] as IObserver;
               _loc3_.push(_loc4_);
               _loc5_++;
            }
            _loc5_ = 0;
            while(_loc5_ < _loc3_.length)
            {
               _loc4_ = _loc3_[_loc5_] as IObserver;
               _loc4_.notifyObserver(param1);
               _loc5_++;
            }
         }
      }
      
      public function removeObserver(param1:String, param2:Object) : void
      {
         var _loc3_:Array = this.observerMap[param1] as Array;
         var _loc4_:* = 0;
         while(_loc4_ < _loc3_.length)
         {
            if(Observer(_loc3_[_loc4_]).compareNotifyContext(param2) == true)
            {
               _loc3_.splice(_loc4_,1);
               break;
            }
            _loc4_++;
         }
         if(_loc3_.length == 0)
         {
            delete this.observerMap[param1];
            true;
         }
      }
      
      public function registerMediator(param1:IMediator) : void
      {
         var _loc2_:Array = null;
         var _loc3_:* = 0;
         var _loc4_:Observer = null;
         var _loc5_:* = 0;
         if(this.mediatorMap[param1.getMediatorName()] != null)
         {
            var param1:IMediator = this.mediatorMap[param1.getMediatorName()] as IMediator;
            _loc2_ = param1.listNotificationInterests();
            _loc3_ = 0;
            while(_loc3_ < _loc2_.length)
            {
               this.removeObserver(_loc2_[_loc3_],param1);
               _loc3_++;
            }
            _loc4_ = new Observer(param1.handleNotification,param1);
            _loc3_ = 0;
            while(_loc3_ < _loc2_.length)
            {
               this.registerObserver(_loc2_[_loc3_],_loc4_);
               _loc3_++;
            }
            return;
         }
         this.mediatorMap[param1.getMediatorName()] = param1;
         _loc2_ = param1.listNotificationInterests();
         if(_loc2_.length > 0)
         {
            _loc4_ = new Observer(param1.handleNotification,param1);
            _loc5_ = 0;
            while(_loc5_ < _loc2_.length)
            {
               this.registerObserver(_loc2_[_loc5_],_loc4_);
               _loc5_++;
            }
         }
         param1.onRegister();
      }
      
      public function retrieveMediator(param1:String) : IMediator
      {
         return this.mediatorMap[param1];
      }
      
      public function removeMediator(param1:String) : IMediator
      {
         var _loc3_:Array = null;
         var _loc4_:* = NaN;
         var _loc2_:IMediator = this.mediatorMap[param1] as IMediator;
         if(_loc2_)
         {
            _loc3_ = _loc2_.listNotificationInterests();
            _loc4_ = 0;
            while(_loc4_ < _loc3_.length)
            {
               this.removeObserver(_loc3_[_loc4_],_loc2_);
               _loc4_++;
            }
            delete this.mediatorMap[param1];
            true;
            _loc2_.onRemove();
         }
         return _loc2_;
      }
      
      public function hasMediator(param1:String) : Boolean
      {
         return !(this.mediatorMap[param1] == null);
      }
   }
}
