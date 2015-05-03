# -*- coding: utf-8 -*-
# entry.py, part for evparse : EisF Video Parse, evdh Video Parse. 
# evparse:lib/entry: evparse main lib entry. 
# version 0.0.2.0 test201505031500
# author sceext <sceext@foxmail.com> 2009EisF2015, 2015.05. 
# copyright 2015 sceext
#
# This is FREE SOFTWARE, released under GNU GPLv3+ 
# please see README.md and LICENSE for more information. 
#
#    evparse : EisF Video Parse, evdh Video Parse. 
#    Copyright (C) 2015 sceext <sceext@foxmail.com> 
#
#    This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with this program.  If not, see <http://www.gnu.org/licenses/>.
#

# import

import re

from . import hd_quality

# static data

# global config obj
etc = {}
etc.flag_debug = False

etc.hd_max = hd_quality.HD_MAX
etc.hd_min = hd_quality.HD_MIN

etc.EV_INFO_VERSION = 'evdh info_source info_version 0.2.0.0 test201505031420'
etc.EV_INFO_SOURCE = 'evparse1'

# lists

LIST_URL_TO_EXTRACTOR = {	# re of url to extractor_name
    # http://www.iqiyi.com/v_19rrn64t40.html
    '^http://www\.iqiyi\.com/v_.+\.html$' : 'iqiyi', 
    # http://tv.sohu.com/20150215/n409034362.shtml
    '^http://tv\.sohu\.com/(19|20)[0-9]{4}/n[0-9]+\.shtml$' : 'sohu', 
}

LIST_SITE = {	# list of site to site_name
    'iqiyi' : '爱奇艺', 
    'sohu' : '搜狐视频', 
}

LIST_EXTRACTOR_NAME = {	# export evinfo extractor_name
    'iqiyi' : 'iqiyi1', 
    'sohu' : 'sohu1', 
}

# functions

def url_to_extractor(url_to):	# url to extractor_name
    re_list = LIST_URL_TO_EXTRACTOR
    en = None	# extractor_name
    for i in re_list:
        # check if match
        ma = re.match(i, url_to)
        if ma:
            # done
            en = re_list[i]
            break
    return en

# import extractor functions
def extractor_import_iqiyi():
    from .iqiyi import entry as entry0
    return entry0

def extractor_import_sohu():
    from .sohu import entry as entry0
    return entry0

# list used for extractor_name to extractor
EXTRACTOR_IMPORT_LIST = {
    'iqiyi' : extractor_import_iqiyi, 
    'sohu' : extractor_import_sohu, 
}

def dy_import_extractor(extractor_name):
    '''
    dynamic import a extractor by name
    '''
    fun_import = EXTRACTOR_IMPORT_LIST[extractor_name]
    extractor0 = fun_import()
    return extractor0

# add more info to evinfo
def add_more_info(evinfo):
    # add info for evinfo.info part
    info = evinfo['info']
    info['info_version'] = etc.EV_INFO_VERSION
    info['info_source'] = etc.EV_INFO_SOURCE
    if not 'error' in info:	# no error
        info['error'] = ''
    info['extractor_name'] = LIST_EXTRACTOR_NAME[info['extractor']]
    info['site_name'] = LIST_SITE[info['site']]
    # add info for evinfo.video part
    video = evinfo['video']
    for i in video:
        video[i] = add_more_info_one_video(video[i])
    # done
    return evinfo

def add_more_info_one_video(one):
    # add quality
    quality = hd_quality.get(one['hd'])
    if 'quality' in one:
        one['quality'] = quality + '_' + one['quality']
    else:
        one['quality'] = quality
    # check size_px
    if not 'size_px' in one:
        one['size_px'] = [0, 0]
    # count
    size_byte = 0
    time_s = 0
    for i in one['file']:
        size_byte += i['size']
        time_s += i['time_s']
    # add count
    one['size_byte'] = size_byte
    one['time_s'] = time_s
    # done
    return one

# entry main function
def parse(url_to, config=etc):
    # check input url
    extractor_name = url_to_extractor(url_to)
    if extractor_name == None:	# not support this url
        raise Exception('not support this url \"' + url_to + '\" ')
    # import extractor
    extractor = dy_import(extractor_name)
    # set it
    extractor.set_config(config)
    # just parse
    evinfo0 = extractor.parse(url_to)
    # add more info
    evinfo['info']['extractor'] = extractor_name	# set in extractor_name
    evinfo = add_more_info(evinfo0)
    # done
    return evinfo

# end entry.py


