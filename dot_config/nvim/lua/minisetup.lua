require('mini.statusline').setup()
require('mini.icons').setup()
require('mini.diff').setup()
require('mini.trailspace').setup()
require('mini.indentscope').setup()
require('mini.notify').setup()
require('mini.hipatterns').setup({
  highlighters = {
    todo      = { pattern = '%f[%w]()TODO()%f[%W]', group = 'MiniHipatternsTodo' },
    note      = { pattern = '%f[%w]()NOTE()%f[%W]', group = 'MiniHipatternsNote' },
    hex_color = require('mini.hipatterns').gen_highlighter.hex_color(),
  },
})
