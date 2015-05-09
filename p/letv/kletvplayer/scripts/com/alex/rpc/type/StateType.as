package com.alex.rpc.type
{
   public class StateType extends Object
   {
      
      public static const ERROR_TIMEOUT:String = "timeout";
      
      public static const ERROR_IO:String = "ioError";
      
      public static const ERROR_SECURITY:String = "securityError";
      
      public static const ERROR_ANALY:String = "analyError";
      
      public static const ERROR_OTHER:String = "otherError";
      
      public static const ERROR_ASYNC:String = "asyncError";
      
      public static const INFO_METADATA:String = "metadata";
      
      public static const INFO_START:String = "start";
      
      public static const INFO_OPEN:String = "open";
      
      public static const INFO_HTTP_STATUS:String = "httpStatus";
      
      public static const STREAM_START:String = "NetStream.Play.Start";
      
      public static const STREAM_STOP:String = "NetStream.Play.Stop";
      
      public static const STREAM_FULL:String = "NetStream.Buffer.Full";
      
      public static const STREAM_EMPTY:String = "NetStream.Buffer.Empty";
      
      public static const STREAM_NOT_FOUND:String = "NetStream.Play.StreamNotFound";
      
      public static const STREAM_INVALID:String = "NetStream.Play.FileStructureInvalid";
      
      public function StateType()
      {
         super();
      }
   }
}
