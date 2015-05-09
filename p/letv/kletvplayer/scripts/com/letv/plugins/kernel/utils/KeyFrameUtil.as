package com.letv.plugins.kernel.utils
{
   import com.letv.plugins.kernel.model.Model;
   import com.letv.plugins.kernel.model.special.MetaData;
   
   public class KeyFrameUtil extends Object
   {
      
      public function KeyFrameUtil()
      {
         super();
      }
      
      public static function getLastKeyFrame(param1:Number, param2:Model, param3:Number) : Array
      {
         var offsetList:Array = null;
         var timeList:Array = null;
         var len:int = 0;
         var count:int = 0;
         var i:int = 0;
         var time:Number = param1;
         var model:Model = param2;
         var duration:Number = param3;
         var metadata:MetaData = model.metadata;
         if(duration <= 0 || metadata == null)
         {
            return [time,0];
         }
         try
         {
            offsetList = metadata.keyframes.filepositions;
            timeList = metadata.keyframes.times;
            len = timeList.length;
            count = 1;
            i = count;
            while(i < len)
            {
               if(timeList[i] <= time)
               {
                  count = i;
                  i++;
                  continue;
               }
               return [timeList[count],offsetList[count]];
            }
         }
         catch(e:Error)
         {
         }
         return [0,0];
      }
      
      public static function getStartKeyFrame(param1:Number, param2:Model, param3:Number) : Array
      {
         var offsetList:Array = null;
         var timeList:Array = null;
         var len:int = 0;
         var count:int = 0;
         var value:Number = NaN;
         var i:int = 0;
         var currentValue:Number = NaN;
         var time:Number = param1;
         var model:Model = param2;
         var duration:Number = param3;
         var metadata:MetaData = model.metadata;
         if(duration <= 0 || metadata == null)
         {
            return [time,0];
         }
         try
         {
            offsetList = metadata.keyframes.filepositions;
            timeList = metadata.keyframes.times;
            if(time <= 0)
            {
               time = 0;
            }
            len = timeList.length;
            count = -1;
            value = Math.abs(timeList[1] - time);
            i = 2;
            while(i < len)
            {
               currentValue = Math.abs(timeList[i] - time);
               if(currentValue <= value)
               {
                  value = currentValue;
                  count = i;
                  i++;
                  continue;
               }
               break;
            }
            if(count < 0)
            {
               return [0,offsetList[1]];
            }
            if(count >= len - 1)
            {
               count = len - 3;
            }
            return [timeList[count],offsetList[count]];
         }
         catch(e:Error)
         {
         }
         return [0,offsetList[1]];
      }
      
      public static function getStopKeyFrame(param1:Number, param2:Model, param3:Number) : Array
      {
         var offsetList:Array = null;
         var timeList:Array = null;
         var len:int = 0;
         var count:int = 0;
         var value:Number = NaN;
         var i:int = 0;
         var currentValue:Number = NaN;
         var time:Number = param1;
         var model:Model = param2;
         var duration:Number = param3;
         time = time + 420;
         var metadata:MetaData = model.metadata;
         if(duration <= 0 || metadata == null)
         {
            return [time,0];
         }
         try
         {
            offsetList = metadata.keyframes.filepositions;
            timeList = metadata.keyframes.times;
            if(time <= 0)
            {
               return [0,offsetList[1]];
            }
            len = timeList.length;
            count = -1;
            value = Math.abs(timeList[1] - time);
            i = 2;
            while(i < len)
            {
               currentValue = Math.abs(timeList[i] - time);
               if(currentValue <= value)
               {
                  value = currentValue;
                  count = i;
                  i++;
                  continue;
               }
               break;
            }
            if(count < 0)
            {
               return [0,offsetList[1]];
            }
            if(count == len - 1)
            {
               return [duration,metadata.filesize];
            }
            return [timeList[count],offsetList[count]];
         }
         catch(e:Error)
         {
         }
         return [0,offsetList[1]];
      }
      
      public static function getKeyFramePosition(param1:Number, param2:Model, param3:Number) : uint
      {
         var offsetList:Array = null;
         var timeList:Array = null;
         var len:int = 0;
         var count:int = 0;
         var value:Number = NaN;
         var i:int = 0;
         var currentValue:Number = NaN;
         var time:Number = param1;
         var model:Model = param2;
         var duration:Number = param3;
         var metadata:MetaData = model.metadata;
         if(duration <= 0 || metadata == null)
         {
            return 0;
         }
         try
         {
            offsetList = metadata.keyframes.filepositions;
            timeList = metadata.keyframes.times;
            if(time <= 0)
            {
               time = 0;
            }
            len = timeList.length;
            count = -1;
            value = Math.abs(timeList[1] - time);
            i = 2;
            while(i < len)
            {
               currentValue = Math.abs(timeList[i] - time);
               if(currentValue <= value)
               {
                  value = currentValue;
                  count = i;
                  i++;
                  continue;
               }
               break;
            }
            if(count < 0)
            {
               return 0;
            }
            if(count >= len - 1)
            {
               count = len - 3;
            }
            return count;
         }
         catch(e:Error)
         {
         }
         return 0;
      }
      
      public static function getScreenshots(param1:Number, param2:Model, param3:Number) : Array
      {
         var snapw:int = 0;
         var snaph:int = 0;
         var url:String = null;
         var time:Number = param1;
         var model:Model = param2;
         var duration:Number = param3;
         var arr:Array = [];
         try
         {
            snapw = 435;
            snaph = int(435 / model.setting.originalScale);
            if(snaph > 360)
            {
               snaph = 360;
               snapw = int(360 * model.setting.originalScale);
            }
            url = model.gslb.urlist[0][model.setting.definition].location;
            url = url.replace(new RegExp("\\.m3u8","g"),".mp4");
            url = url + ("&snapw=" + snapw);
            url = url + ("&snaph=" + snaph);
            url = url + "&snapq=1";
            url = url + ("&snaptm=" + time);
            arr.push(url);
         }
         catch(e:Error)
         {
         }
         return arr;
      }
   }
}
