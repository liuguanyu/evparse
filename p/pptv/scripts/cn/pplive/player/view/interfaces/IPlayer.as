package cn.pplive.player.view.interfaces
{
   public interface IPlayer
   {
      
      function play() : void;
      
      function pause() : void;
      
      function stop() : void;
      
      function seek() : void;
      
      function resize(param1:Number = NaN, param2:Number = NaN, param3:Number = NaN) : void;
      
      function setVolume(param1:Number) : void;
      
      function get headTime() : Number;
   }
}
