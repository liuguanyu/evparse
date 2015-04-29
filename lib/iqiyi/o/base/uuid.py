# -*- coding: utf-8 -*-
# uuid.py, part for evparse : EisF Video Parse, evdh Video Parse. 
# uuid: iqiyi, com.qiyi.player.base.uuid 

# import

import random

# import from out
base = None
# NOTE should be set by exports
def set_import(base1):
    global base
    base = base1

# global static config
UUID_URL = 'http://data.video.qiyi.com/uid'

# class

class UUIDManager(object):
    
    def __init__(self):
        self.uuid = ''
    
    def get_uuid(self):
        # check uuid
        if self.uuid != '':
            return self.uuid
        # load from server
        self._load_from_server()
        return self.uuid
    
    # load a user uuid from iqiyi server
    def _load_from_server(self):
        # make a url to request
        url_to = UUID_URL + '?tn=' + str(random.random())
        # get uuid by http request
        info = base.get_html_content(url_to)
        # TODO analyse received url
        # FIXME not finished, only debug
        print('DEBUG: url \"' + url_to + '\"')
        print('DEBUG: result [' + info + '] ')
        pass
    
    pass

# end uuid.py


