---@class utils.plugin: UtilsPlugin
local M = {}

function M.setup()
	M.lazy_file()
end

function M.lazy_file()
	-- Add support for the LazyFile event. Nonblocking file event
	local Event = require('lazy.core.handler.event')

	Event.mappings.LazyFile = { id = 'LazyFile', event = { 'BufReadPost', 'BufNewFile', 'BufWritePre' }}
	Event.mappings['User LazyFile'] = Event.mappings.LazyFile
end


return M
