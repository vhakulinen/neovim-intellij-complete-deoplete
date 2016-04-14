import re
from .base import Base

class Source(Base):
    def __init__(self, vim):
        Base.__init__(self, vim)

        self.name = 'intellij-complete'
        self.mark = '[idea]'
        self.filetypes = ['java']
        self.rank = 100
        self.max_pattern_length = 100
        self.is_bytepos = True
        self.input_pattern = '[^. \t0-9]\.\w*'

    def get_complete_position(self, context):
        m = re.search(r'\w*$', context['input'])
        return m.start() if m else -1


    def gather_candidates(self, context):
        buf = self.vim.current.buffer
        win = self.vim.current.window
        path = buf.name
        content = ''.join([i + '\n'
            for i in buf.get_line_slice(0, -1, True, True)])
        cid = self.vim.vars.get("intellijID")
        row = win.cursor[0] - 1
        col = win.cursor[1]
        return self.vim.call("rpcrequest", cid, "IntellijComplete", path,
                content, row, col)
