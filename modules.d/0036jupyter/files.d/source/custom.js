require([
    'nbextensions/vim_binding/vim_binding',
], function () {
      CodeMirror.Vim.map("<C-h>", "<Esc>s", "insert");
      CodeMirror.Vim.map("<C-u>", "<Esc>S", "insert");
});
