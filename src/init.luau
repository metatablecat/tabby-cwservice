-- Tabby, downgraded to just a library inside Catwork
local Tabby = {}
local Common = require(script.Common)
local Types = require(script.Types)

local Plugin = script:FindFirstAncestorWhichIsA("Plugin")
Common.Plugin = Plugin
Tabby.Plugin = Plugin

if not Plugin then
	error("Invalid load context for Tabby, cancelling load.")
end

-- service ctor
local Service = require(script.Service)

function Tabby:CreateFragment(fragmentName): Service.TabbyFragment
	return Service:CreateFragment(fragmentName)
end

-- exports
Tabby.Form = require(script.Form)
Tabby.Input = require(script.Input)
Tabby.QtInterface = require(script.QtInterface)

export type Form<O..., C...> = Types.Form<O..., C...>
export type TabbyFragment = Service.TabbyFragment
export type TabbyInputObject = Types.TabbyInputObject

-- qt interface types
export type QtAction = Types.QtAction
export type QtMenu = Types.QtMenu
export type QtToolbar = Types.QtToolbar

return Tabby