:: README.md for evparse
*last update* `2015-05-26 19:45 GMT+0800 CST`


# evparse

evparse: parse videos on web pages and output information with json format. 

evparse: EisF Video Parse, evdh Video Parse. <br />
evparse: first hand code from video player of flash. (1st hand code)


## Features

**Supported sites**
> 
+ `sohu` *(搜狐)* [**高码4K, h265**] *(high bit rate 4K video, with h265 encoding)*
+ `pptv` *(PPTV聚力)* [**高码1080p**] *(high bit rate 1080p video)*
+ `hunantv` *(芒果tv)* [**720p**] *(超清)*
> 
+ **[info only]** *(仅信息)* `iqiyi` (271) *[1080p]*
+ **[info only]** *(仅信息)* `letv` *(乐视网)* *[1080p]*
> 


## Usage

An example:

> ```
> $ ./evp "http://www.hunantv.com/v/2/150668/f/1525093.html#" --min 2
> {
>     "info": {
>         "error": "",
>         "info_version": "evdh info_source info_version 0.2.1.0 test201505251439",
>         "info_source": "evparse",
>         "extractor": "hunantv",
>         "extractor_name": "hunantv1",
>         "title": "聊斋新编 第39集",
>         "title_short": "聊斋新编 卫视版",
>         "title_no": 39,
>         "title_sub": "谢鳌献出内丹帮助于璟",
>         "site": "hunantv",
>         "site_name": "芒果tv",
>         "url": "http://www.hunantv.com/v/2/150668/f/1525093.html#"
>     },
>     "video": [
>         {
>             "hd": 2,
>             "quality": "720p",
>             "size_px": [
>                 -1,
>                 -1
>             ],
>             "size_byte": -1,
>             "time_s": 2472,
>             "format": "fhv",
>             "count": 1,
>             "file": [
>                 {
>                     "size": -1,
>                     "time_s": 2472,
>                     "url": "http://pcvideows.imgo.tv/1b88b916ee188994cc3f796f3462372c/55644c13/c1/2015/dianshiju/liaozhaixinbianshouluban/2015052500fd23d5-d76b-42b4-9644-131e4277ddbf.fhv?uuid=8acf709e94fd44c0a9224069ad9f9879",
>                     "user_agent": "Mozilla/5.0 (Windows NT 6.1; WOW64; rv:37.0) Gecko/20100101 Firefox/37.0",
>                     "referer": "http://i1.hunantv.com/ui/swf/player/v0415/main.swf"
>                 }
>             ]
>         },
>         {
>             "hd": 1,
>             "quality": "高清",
>             "size_px": [
>                 -1,
>                 -1
>             ],
>             "size_byte": -1,
>             "time_s": 2472,
>             "format": "fhv",
>             "count": 1,
>             "file": []
>         },
>         {
>             "hd": 0,
>             "quality": "普清",
>             "size_px": [
>                 -1,
>                 -1
>             ],
>             "size_byte": -1,
>             "time_s": 2472,
>             "format": "fhv",
>             "count": 1,
>             "file": []
>         }
>     ]
> }
> $ 
> ```

### Help

> ```
> $ ./evp --help
> evparse: HELP
> 
> Usage:
>     evp [OPTIONS] <url>
>     evp --version
>     evp --help
> Options:
>     <url>           URL of the video play page, to be analysed 
>                     and get information from. 
> 
>     --min <hd_min>  set min hd number of video info to get
>     --max <hd_max>  set max hd number of video info to get
> 
>     --version       show version of evparse
>     --help          show this help information of evparse
> 
>   More help info please see <https://github.com/sceext2/evparse> 
> 
> $ 
> ```

### version

> ```
> $ ./evp --version
> evparse version 0.1.4.0 test201505251510
> ```


## License

`This` is **FREE SOFTWARE**, released under *GNU GPLv3+* <br />
please see *README.md* and *LICENSE* for more information. 

> ```
>     evparse : EisF Video Parse, evdh Video Parse. 
>     Copyright (C) 2015 sceext <sceext@foxmail.com> 
> 
>     This program is free software: you can redistribute it and/or modify
>     it under the terms of the GNU General Public License as published by
>     the Free Software Foundation, either version 3 of the License, or
>     (at your option) any later version.
> 
>     This program is distributed in the hope that it will be useful,
>     but WITHOUT ANY WARRANTY; without even the implied warranty of
>     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>     GNU General Public License for more details.
> 
>     You should have received a copy of the GNU General Public License
>     along with this program.  If not, see <http://www.gnu.org/licenses/>.
> ```


:: end README.md


