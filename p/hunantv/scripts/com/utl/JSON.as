package com.utl
{
   public class JSON extends Object
   {
      
      public function JSON()
      {
         super();
      }
      
      public static function stringify(param1:*) : String
      {
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         var _loc6_:* = undefined;
         var _loc5_:* = "";
         switch(typeof param1)
         {
            case "object":
               if(param1)
               {
                  if(param1 is Array)
                  {
                     _loc3_ = 0;
                     while(_loc3_ < param1.length)
                     {
                        _loc6_ = stringify(param1[_loc3_]);
                        if(_loc5_)
                        {
                           _loc5_ = _loc5_ + ",";
                        }
                        _loc5_ = _loc5_ + _loc6_;
                        _loc3_++;
                     }
                     return "[" + _loc5_ + "]";
                  }
                  if(typeof param1.toString != "undefined")
                  {
                     for(_loc3_ in param1)
                     {
                        _loc6_ = param1[_loc3_];
                        if(!(typeof _loc6_ == "undefined") && !(typeof _loc6_ == "function"))
                        {
                           _loc6_ = stringify(_loc6_);
                           if(_loc5_)
                           {
                              _loc5_ = _loc5_ + ",";
                           }
                           _loc5_ = _loc5_ + (stringify(_loc3_) + ":" + _loc6_);
                        }
                     }
                     return "{" + _loc5_ + "}";
                  }
               }
               return "null";
            case "number":
               return isFinite(param1)?String(param1):"null";
            case "string":
               _loc4_ = param1.length;
               _loc5_ = "\"";
               _loc3_ = 0;
               while(_loc3_ < _loc4_)
               {
                  _loc2_ = param1.charAt(_loc3_);
                  if(_loc2_ >= " ")
                  {
                     if(_loc2_ == "\\" || _loc2_ == "\"")
                     {
                        _loc5_ = _loc5_ + "\\";
                     }
                     _loc5_ = _loc5_ + _loc2_;
                  }
                  else
                  {
                     switch(_loc2_)
                     {
                        case "\b":
                           _loc5_ = _loc5_ + "\\b";
                           break;
                        case "\f":
                           _loc5_ = _loc5_ + "\\f";
                           break;
                        case "\n":
                           _loc5_ = _loc5_ + "\\n";
                           break;
                        case "\r":
                           _loc5_ = _loc5_ + "\\r";
                           break;
                        case "\t":
                           _loc5_ = _loc5_ + "\\t";
                           break;
                        default:
                           _loc2_ = _loc2_.charCodeAt();
                           _loc5_ = _loc5_ + ("\\u00" + Math.floor(_loc2_ / 16).toString(16) + (_loc2_ % 16).toString(16));
                     }
                  }
                  _loc3_ = _loc3_ + 1;
               }
               return _loc5_ + "\"";
            case "boolean":
               return String(param1);
            default:
               return "null";
         }
      }
      
      public static function parse(param1:String) : Object
      {
         var at:* = undefined;
         var ch:* = undefined;
         var text:String = param1;
         var error:Function = function(param1:*):*
         {
            throw {
               "name":"JSONError",
               "message":param1,
               "at":at - 1,
               "text":text
            };
         };
         var next:Function = function():*
         {
            ch = text.charAt(at);
            at = at + 1;
            return ch;
         };
         var white:Function = function():*
         {
            while(ch)
            {
               if(ch <= " ")
               {
                  next();
                  continue;
               }
               if(ch == "/")
               {
                  switch(next())
                  {
                     case "/":
                        while((next()) && (!(ch == "\n")) && !(ch == "\r"))
                        {
                        }
                        break;
                     case "*":
                        next();
                        while(true)
                        {
                           if(ch)
                           {
                              if(ch == "*")
                              {
                                 if(next() == "/")
                                 {
                                    break;
                                 }
                              }
                              else
                              {
                                 next();
                              }
                           }
                           else
                           {
                              error("Unterminated comment");
                           }
                        }
                        next();
                        break;
                     default:
                        error("Syntax error");
                  }
                  continue;
               }
               break;
            }
         };
         var string:Function = function():*
         {
            var _loc1_:* = undefined;
            var _loc3_:* = undefined;
            var _loc4_:* = undefined;
            var _loc2_:* = "";
            var _loc5_:* = false;
            if(ch == "\"")
            {
               while(next())
               {
                  if(ch == "\"")
                  {
                     next();
                     return _loc2_;
                  }
                  if(ch == "\\")
                  {
                     switch(next())
                     {
                        case "b":
                           _loc2_ = _loc2_ + "\b";
                           break;
                        case "f":
                           _loc2_ = _loc2_ + "\f";
                           break;
                        case "n":
                           _loc2_ = _loc2_ + "\n";
                           break;
                        case "r":
                           _loc2_ = _loc2_ + "\r";
                           break;
                        case "t":
                           _loc2_ = _loc2_ + "\t";
                           break;
                        case "u":
                           _loc4_ = 0;
                           _loc1_ = 0;
                           while(_loc1_ < 4)
                           {
                              _loc3_ = parseInt(next(),16);
                              if(!isFinite(_loc3_))
                              {
                                 _loc5_ = true;
                                 break;
                              }
                              _loc4_ = _loc4_ * 16 + _loc3_;
                              _loc1_ = _loc1_ + 1;
                           }
                           if(_loc5_)
                           {
                              _loc5_ = false;
                              break;
                           }
                           _loc2_ = _loc2_ + String.fromCharCode(_loc4_);
                           break;
                        default:
                           _loc2_ = _loc2_ + ch;
                     }
                  }
                  else
                  {
                     _loc2_ = _loc2_ + ch;
                  }
               }
            }
            error("Bad string");
         };
         var array:Function = function():*
         {
            var _loc1_:* = [];
            if(ch == "[")
            {
               next();
               white();
               if(ch == "]")
               {
                  next();
                  return _loc1_;
               }
               while(ch)
               {
                  _loc1_.push(value());
                  white();
                  if(ch == "]")
                  {
                     next();
                     return _loc1_;
                  }
                  if(ch != ",")
                  {
                     break;
                  }
                  next();
                  white();
               }
            }
            error("Bad array");
         };
         var object:Function = function():*
         {
            var _loc1_:* = undefined;
            var _loc2_:* = {};
            if(ch == "{")
            {
               next();
               white();
               if(ch == "}")
               {
                  next();
                  return _loc2_;
               }
               while(ch)
               {
                  _loc1_ = string();
                  white();
                  if(ch != ":")
                  {
                     break;
                  }
                  next();
                  _loc2_[_loc1_] = value();
                  white();
                  if(ch == "}")
                  {
                     next();
                     return _loc2_;
                  }
                  if(ch != ",")
                  {
                     break;
                  }
                  next();
                  white();
               }
            }
            error("Bad object");
         };
         var number:Function = function():*
         {
            var _loc2_:* = undefined;
            var _loc1_:* = "";
            if(ch == "-")
            {
               _loc1_ = "-";
               next();
            }
            while(ch >= "0" && ch <= "9")
            {
               _loc1_ = _loc1_ + ch;
               next();
            }
            if(ch == ".")
            {
               _loc1_ = _loc1_ + ".";
               while((next()) && (ch >= "0") && ch <= "9")
               {
                  _loc1_ = _loc1_ + ch;
               }
            }
            _loc2_ = _loc1_;
            if(!isFinite(_loc2_))
            {
               error("Bad number");
               return;
            }
            return _loc2_;
         };
         var word:Function = function():*
         {
            switch(ch)
            {
               case "t":
                  if(next() == "r" && next() == "u" && next() == "e")
                  {
                     next();
                     return true;
                  }
                  break;
               case "f":
                  if(next() == "a" && next() == "l" && next() == "s" && next() == "e")
                  {
                     next();
                     return false;
                  }
                  break;
               case "n":
                  if(next() == "u" && next() == "l" && next() == "l")
                  {
                     next();
                     return null;
                  }
                  break;
            }
            error("Syntax error");
         };
         var value:Function = function():*
         {
            white();
            switch(ch)
            {
               case "{":
                  return object();
               case "[":
                  return array();
               case "\"":
                  return string();
               case "-":
                  return number();
               default:
                  return ch >= "0" && ch <= "9"?number():word();
            }
         };
         at = 0;
         ch = " ";
         return value();
      }
   }
}
