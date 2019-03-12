--------------------------------------------------
--    LICENSE: 
--     Author: 
--    Version: 
-- CreateTime: 2018-07-31 23:08:48
-- LastUpdate: 2018-07-31 23:08:48
--       Desc: 
--------------------------------------------------

local module = {}
local private = {}

local ncm = require("nvim-completor/completor")
local helper = require("nvim-completor/helper")
local log = require("nvim-completor/log")
local lsp = require("nvim-completor/lsp")

private.call_lsp_complete = function(ctx)
	if ctx == nil then
		log.debug("vim-lsc private.call_lsp_complete ctx is nil")
		return
	end
	vim.api.nvim_call_function('vim_lsc#complete', {ctx})
end

private.complete = function(ctx)
	if ctx == nil then
		return
	end
	private.call_lsp_complete(ctx)
end

private.complete_callback = function(ctx, data)
	local incomplete = data['isIncomplete']
	local data_items = data['items']
	if data_items == nil then
		data_items = data
	end

	local complete_items = lsp.complete_items_lsp2vim(ctx, data_items)
	if complete_items == nil then
		return
	end

	ctx.incomplete = incomplete

	ncm.add_complete_items(ctx, complete_items)
end

private.init = function()
	ncm.add_engine(private.complete, "all")
	log.info("add vim-lsc engine success")
end

module.complete_callback = private.complete_callback
module.init = private.init

return module
