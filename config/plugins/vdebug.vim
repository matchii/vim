Plug 'vim-vdebug/vdebug'

if (!exists('g:vdebug_options'))
    let g:vdebug_options = {}
endif
let g:vdebug_options['watch_window_style'] = 'compact'
let g:vdebug_keymap = {
\    "run" : "<F5>",
\    "run_to_cursor" : "<F9>",
\    "step_over" : "<F2>",
\    "step_into" : "<F3>",
\    "step_out" : "<F4>",
\    "close" : "<F6>",
\    "detach" : "<C-F7>",
\    "set_breakpoint" : "<C-F10>",
\    "get_context" : "<F11>",
\    "eval_under_cursor" : "<C-F12>",
\    "eval_visual" : "<Leader>e",
\}
