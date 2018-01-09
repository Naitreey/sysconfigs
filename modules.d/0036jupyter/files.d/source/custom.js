// external gvim editting
Jupyter.keyboard_manager.command_shortcuts.add_shortcut('g', {
    handler : function (event) {
        var cur_cell = Jupyter.notebook.get_selected_cell();
        var cell_type = cur_cell.cell_type;
        if (cell_type === "markdown") {
            var ext = "md";
        }
        else if (cell_type == "code") {
            var ext = "py";
        }
        var input = cur_cell.get_text();
        var cell_file = `/tmp/${cur_cell.cell_id}.${ext}`;
        var cmd = `f = open('${cell_file}', 'w');f.close()`;
        if (input != "") {
            cmd = `%%writefile ${cell_file}\n${input}`;
        }
        Jupyter.notebook.kernel.execute(cmd);
        cmd = `import os;os.system('gvim ${cell_file}')`;
        Jupyter.notebook.kernel.execute(cmd);
        return false;
    }}
);

Jupyter.keyboard_manager.command_shortcuts.add_shortcut('u', {
    handler : function (event) {
        function handle_output(msg) {
            var ret = msg.content.text;
            Jupyter.notebook.get_selected_cell().set_text(ret);
        }
        var cur_cell = Jupyter.notebook.get_selected_cell();
        var cell_type = cur_cell.cell_type;
        if (cell_type === "markdown") {
            var ext = "md";
        }
        else if (cell_type == "code") {
            var ext = "py";
        }
        var cell_file = `/tmp/${cur_cell.cell_id}.${ext}`;
        var callback = {'output': handle_output};
        var cmd = `f = open('${cell_file}', 'r');print(f.read())`;
        Jupyter.notebook.kernel.execute(cmd, {iopub: callback}, {silent: false});
        return false;
    }}
);
