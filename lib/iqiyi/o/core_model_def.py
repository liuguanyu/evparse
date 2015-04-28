# -*- coding: utf-8 -*-
# core_model_def.py, part for evparse : EisF Video Parse, evdh Video Parse. 
# core_model_def: iqiyi, com.qiyi.player.core.model.def 
# author sceext <sceext@foxmail.com> 2009EisF2015, 2015.04. 
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
from .base_pub import EnumItem

# class
class DefinitionEnum(object):
    # 视频清晰度定义
    
    def __init__(self):
        self.ITEMS = []
        
        # 官方清晰度	实际清晰度	hd
        items = self.ITEMS
        # (极速)	超渣		-3
        self.LIMIT 	= EnumItem(96, 'topspeed', items)
        # (流畅)	渣清		-2
        self.NONE 	= EnumItem(0, 'none', items)
        # (标清)	低清		-1
        self.STANDARD 	= EnumItem(1, 'standard', items)
        # (高清)	普清		0
        self.HIGH 	= EnumItem(2, 'high', items)
        # (超清)	高清		1
        self.SUPER 	= EnumItem(3, 'super', items)
        # (720p)	720p		2
        self.SUPER_HIGH = EnumItem(4, 'super-high', items)
        # (1080p)	1080p		4
        self.FULL_HD 	= EnumItem(5, 'fullhd', items)
        # (4K)		4K		5
        self.FOUR_K 	= EnumItem(10, '4k', items)
        # done

# end core_model_def.py


