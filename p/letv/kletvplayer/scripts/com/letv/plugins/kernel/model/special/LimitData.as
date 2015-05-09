package com.letv.plugins.kernel.model.special
{
   public class LimitData extends Object
   {
      
      public static const FIRSTLOOKNAME:String = "firstlookname";
      
      public static const LOGINLOOKNAME:String = "loginlookname";
      
      public static const CUTOFFPCNAME:String = "cutoffpcname";
      
      private var _list:LimitList;
      
      private var _user:UserSetting;
      
      public function LimitData()
      {
         this._list = new LimitList();
         this._user = UserSetting.getInstance();
         super();
         this._list.firstlook.time = 240;
         this._list.login.time = 360;
         this._list.firstlook.name = FIRSTLOOKNAME;
         this._list.login.name = LOGINLOOKNAME;
         this._list.cutPC.name = CUTOFFPCNAME;
      }
      
      public function get stopTime() : Number
      {
         var _loc1_:Array = [];
         if(this.firstlook)
         {
            _loc1_.push(this.firstlookTime);
         }
         if(this.login)
         {
            _loc1_.push(this.loginTime);
         }
         if(this.cutPC)
         {
            _loc1_.push(this.cutoffPCTime);
         }
         if(_loc1_.length > 0)
         {
            _loc1_.sort(Array.NUMERIC);
            return _loc1_[0];
         }
         return 0;
      }
      
      public function get stopName() : String
      {
         var _loc1_:Number = this.stopTime;
         if((this.firstlook) && _loc1_ == this.firstlookTime)
         {
            return this._list.firstlook.name;
         }
         if((this.login) && _loc1_ == this.loginTime)
         {
            return this._list.login.name;
         }
         if((this.cutPC) && _loc1_ == this.cutoffPCTime)
         {
            return this._list.cutPC.name;
         }
         return "";
      }
      
      public function get limitPlay() : Boolean
      {
         return (this.firstlook) || (this.login) || (this.cutPC);
      }
      
      public function get firstlookTime() : Number
      {
         return this._list.firstlook.time;
      }
      
      public function get loginTime() : Number
      {
         return this._list.login.time;
      }
      
      public function get cutoffPCTime() : Number
      {
         return this._list.cutPC.time;
      }
      
      public function set cutoffPCTime(param1:Number) : void
      {
         this._list.cutPC.time = param1;
      }
      
      public function get firstlook() : Boolean
      {
         return this._list.firstlook.limitPlay;
      }
      
      public function set firstlook(param1:Boolean) : void
      {
         this._list.firstlook.limitPlay = param1;
      }
      
      public function get login() : Boolean
      {
         return (this._list.login.limitPlay) && !this._user.isLogin;
      }
      
      public function set login(param1:Boolean) : void
      {
         this._list.login.limitPlay = param1;
      }
      
      public function get cutPC() : Boolean
      {
         return this._list.cutPC.limitPlay;
      }
      
      public function set cutPC(param1:Boolean) : void
      {
         this._list.cutPC.limitPlay = param1;
      }
   }
}

class LimitList extends Object
{
   
   public var firstlook:ItemData;
   
   public var login:ItemData;
   
   public var cutPC:ItemData;
   
   function LimitList()
   {
      this.firstlook = new ItemData();
      this.login = new ItemData();
      this.cutPC = new ItemData();
      super();
   }
}

class ItemData extends Object
{
   
   public var limitPlay:Boolean = false;
   
   public var time:Number = 0;
   
   public var name:String = "";
   
   function ItemData()
   {
      super();
   }
}
