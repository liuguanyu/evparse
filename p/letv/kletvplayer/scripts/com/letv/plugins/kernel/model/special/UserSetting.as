package com.letv.plugins.kernel.model.special
{
   import com.letv.plugins.kernel.interfaces.IClone;
   import com.letv.pluginsAPI.kernel.User;
   import com.letv.plugins.kernel.Kernel;
   
   public class UserSetting extends BaseClone implements IClone
   {
      
      private static var _instance:UserSetting;
      
      public var payLook:Boolean;
      
      public var payType:String;
      
      public var payTicketSize:int;
      
      public var payPrice:Number = 0;
      
      public var payVipPrice:Number = 0;
      
      public var payURL:String;
      
      public const VOD_URL:String = "http://zhifu.letv.com/tobuy/db/";
      
      public var status:String = "-1";
      
      public var canceltime:String = "没有记录";
      
      private var _originalUname:String;
      
      private var _uname:String;
      
      private var _originalUid:String;
      
      private var _uid:String;
      
      private var _baiduid:String;
      
      private var _unick:String;
      
      private var _yuanxianinfo:Object;
      
      private var _token:String;
      
      private var _uinfo:String;
      
      public function UserSetting()
      {
         super();
      }
      
      public static function getInstance() : UserSetting
      {
         if(_instance == null)
         {
            _instance = new UserSetting();
         }
         return _instance;
      }
      
      public function flushPayData(param1:Object) : void
      {
         this._yuanxianinfo = param1;
         if(param1 != null)
         {
            if(param1.hasOwnProperty("isvip"))
            {
               this.status = String(param1["isvip"] + "");
            }
            else
            {
               this.status = this.uid != null?User.VIP_NOT:User.NO_LOGIN;
            }
            if(param1.hasOwnProperty("canceltime"))
            {
               this.canceltime = String(param1["canceltime"] + "");
            }
            else
            {
               this.canceltime = "没有记录";
            }
            if((param1.hasOwnProperty("status")) && String(param1["status"]) == "1")
            {
               this.payLook = true;
            }
            else
            {
               this.payLook = false;
            }
            if(param1.hasOwnProperty("size"))
            {
               this.payTicketSize = Number(param1["size"]);
            }
            else
            {
               this.payTicketSize = 0;
            }
            if(param1.hasOwnProperty("price"))
            {
               this.payPrice = Number(param1["price"]);
            }
            else
            {
               this.payPrice = 0;
            }
            if(param1.hasOwnProperty("vipPrice"))
            {
               this.payVipPrice = Number(param1["vipPrice"]);
            }
            else
            {
               this.payVipPrice = 0;
            }
            if(param1.hasOwnProperty("url"))
            {
               this.payURL = String(param1["url"]);
            }
            else
            {
               this.payURL = null;
            }
            if((param1.hasOwnProperty("token")) && !(String(param1["token"]) == ""))
            {
               this._token = param1["token"];
            }
            else
            {
               this._token = null;
            }
            if((param1.hasOwnProperty("uinfo")) && !(String(param1["uinfo"]) == ""))
            {
               this._uinfo = param1["uinfo"];
            }
            else
            {
               this._uinfo = null;
            }
            if((param1.hasOwnProperty("username")) && !(String(param1["username"]) == ""))
            {
               this.uname = String(param1["username"]);
            }
            if((param1.hasOwnProperty("nickname")) && !(String(param1["nickname"]) == ""))
            {
               this.unick = String(param1["nickname"]);
            }
         }
         else
         {
            this.status = User.NO_LOGIN;
            this.canceltime = "没有记录";
            this.payLook = false;
            this.payTicketSize = 0;
            this.payPrice = 0;
            this.payVipPrice = 0;
            this.payURL = null;
         }
      }
      
      public function flushUserData(param1:Object) : void
      {
         if(param1)
         {
            this.uid = param1["uid"];
            this.uname = param1["uname"];
            this.unick = param1["unick"];
            this.baiduid = param1["baiduid"];
         }
         else
         {
            this.uid = null;
            this.uname = null;
            this.unick = null;
            this.baiduid = null;
         }
         Kernel.sendLog("[User Data] " + this.uid + " " + this.uname + " " + this.unick + " " + this.baiduid);
      }
      
      public function set uname(param1:String) : void
      {
         switch(param1)
         {
            case "":
            case " ":
            case "-":
               this._uname = null;
               this._originalUname = "-";
               break;
            default:
               this._uname = param1;
               this._originalUname = param1;
         }
      }
      
      public function set uid(param1:String) : void
      {
         switch(param1)
         {
            case "":
            case " ":
            case "-":
               this._uid = null;
               this._originalUid = "-";
               break;
            default:
               this._uid = param1;
               this._originalUid = param1;
         }
      }
      
      public function set unick(param1:String) : void
      {
         if(param1 == " " || param1 == "-" || param1 == "")
         {
            this._unick = null;
         }
         else
         {
            this._unick = param1;
         }
      }
      
      public function set baiduid(param1:String) : void
      {
         if(param1 == " " || param1 == "-" || param1 == "")
         {
            this._baiduid = null;
         }
         else
         {
            this._baiduid = param1;
         }
      }
      
      public function get canGetUserScriptAndNotLogin() : Boolean
      {
         return this._originalUid == "-";
      }
      
      public function get uname() : String
      {
         return this._uname;
      }
      
      public function get uid() : String
      {
         return this._uid;
      }
      
      public function get unick() : String
      {
         return this._unick;
      }
      
      public function get baiduid() : String
      {
         return this._baiduid;
      }
      
      public function get isVip() : Boolean
      {
         return this.status == User.VIP_NORMAL;
      }
      
      public function get isLogin() : Boolean
      {
         return !(this._uid == null);
      }
      
      public function get yuanxianinfo() : Object
      {
         return this._yuanxianinfo;
      }
      
      public function get token() : String
      {
         var _loc1_:String = this._token;
         this._token = null;
         return _loc1_;
      }
      
      public function get uinfo() : String
      {
         return this._uinfo;
      }
      
      public function reset() : void
      {
         this._uid = null;
         this._uname = null;
         this._unick = null;
         this._originalUid = null;
         this._originalUname = null;
         this.status = User.NO_LOGIN;
         this.canceltime = "没有记录";
      }
      
      public function forvip() : void
      {
         this.status = User.VIP_NORMAL;
         this.canceltime = "有效期内";
      }
      
      public function clone() : Object
      {
         var _loc1_:Object = super.cloneByClass(UserSetting,this);
         if(_loc1_)
         {
            _loc1_["uid"] = this.uid;
            _loc1_["uname"] = this.uname;
            _loc1_["unick"] = this.unick == null?"用户":this.unick;
            _loc1_["vip"] = this.isVip;
         }
         return _loc1_;
      }
   }
}
