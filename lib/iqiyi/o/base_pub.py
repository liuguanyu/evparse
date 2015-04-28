# -*- coding: utf-8 -*-
# base_pub.py, part for evparse : EisF Video Parse, evdh Video Parse. 
# base_pub: iqiyi, com.qiyi.player.base.pub 

class EnumItem(object):
    
    def __init__(self, param1, param2, param3):
        self.id = param1
        self.name = param2
        param3.append(self)
    
    def __str__(self):
        return self.name

# end base_pub.py


