package cn.pplive.player.dac
{
   public class DACNotification extends Object
   {
      
      public static const ERROR:String = "error";
      
      public static const ACTION:String = "action";
      
      public static const SET_VALUE:String = "setValue";
      
      public static const ADD_VALUE:String = "addValue";
      
      public static const START_RECORD:String = "startRecord";
      
      public static const STOP_RECORD:String = "stopRecord";
      
      public static const DAC_MARK:String = "dacMark";
      
      public static const UPDATE_SESSION:String = "updateSession";
      
      public static const ADDOBJECTVALUE:String = "addObjectValue";
      
      public static const P2PLOG:String = "p2pLog";
      
      public function DACNotification()
      {
         super();
      }
   }
}
