local M = {}

local function get_bufs()
    local bufs = {}
    for _, n in ipairs(vim.api.nvim_list_bufs()) do
        if (vim.api.nvim_buf_is_loaded(n) and vim.fn.buflisted(n) == 1) then
            table.insert(bufs, {n = n, name = vim.fn.bufname(n)})
        end
    end

    return bufs
end

local function set_keymaps(b)
    -- get buffer number under the cursor
    local function get_bn()
        local line = vim.api.nvim_get_current_line()
        local bn = string.gmatch(line, "([^:]+)")()
        bn = tonumber(bn)
        return bn
    end

    local opts = { buffer = b, nowait = true }
    vim.keymap.set('n', 'q', "<cmd>bd<cr>", opts)
    vim.keymap.set('n', '<esc>', "<cmd>bd<cr>", opts)

    vim.keymap.set('n', 'd', function()
        local bn = get_bn()

        -- workaround this bug when there's only one buffer
        -- https://github.com/neovim/neovim/issues/20315
        if vim.api.nvim_buf_line_count(b) == 1 then
            vim.api.nvim_buf_delete(0, {})
            vim.api.nvim_buf_delete(bn, {})
            return
        end

        vim.api.nvim_buf_delete(bn, {})
        vim.cmd.norm { args = {"dd"}, bang = true }
    end, opts)

    vim.keymap.set('n', '<CR>', function()
        local bn = get_bn()
        vim.api.nvim_buf_delete(0, {})
        vim.api.nvim_set_current_buf(bn)
    end, opts)

end

local function open_window(b)
    local gh = vim.api.nvim_list_uis()[1].height
    local gw = vim.api.nvim_list_uis()[1].width
    local w = math.floor(gw/2.0)
    local h = math.floor(gh/2.0)
    local row = (gh-h) * 0.5
    local col = (gw-w) * 0.5

    local opts = {
        relative = 'editor',
        style = 'minimal',
        width = w,
        height = h,
        row = row,
        col = col,
        border = "rounded"
    }

    vim.api.nvim_open_win(b, 0, opts)
end

local function set_lines(uiBuf, bufs)
    local lines = vim.tbl_map(function(b)
        local name = b.name
        if name == "" then
            name = "[No Name]"
        end

        return string.format("%-3s: %s", b.n, name)
    end, bufs)

    return vim.api.nvim_buf_set_lines(uiBuf, 0, -1, false, lines)
end

function M.ls()
    local uiBuf = vim.api.nvim_create_buf(false, true)
    local bufs = get_bufs()

    set_lines(uiBuf, bufs)
    open_window(uiBuf)
    set_keymaps(uiBuf)
end

return M
