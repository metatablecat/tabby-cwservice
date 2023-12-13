local Catwork = require(script.Parent.Parent.Parent.Catwork)
local Common = require(script.Parent.Common)

export type TabbyFragment = Catwork.BaseFragment<{
	Plugin: Plugin
}>

local Me: Catwork.Service<TabbyFragment> = Catwork:GetService("tabby")
Me.Static = true
local priorityOrder: {TabbyFragment} = {}

local function fireMacro(macroName, ...)
	for _, fragment in priorityOrder do
		local f = fragment[macroName]
		if f then
			task.spawn(f, fragment, ...)
		end
	end
end

function Me:Init()
	local unprioritised = table.clone(self.Fragments)
	-- we should allocate based on the position in the tree, then scan the fragment
	-- tree for any unmarked objects
	
	-- unlike previous versions of Tabby, the only part we care about is "LoadingOrder"
	
	for _, v in self.ProjectChunk.LoadingOrder or {} do
		-- {string: short Fragment name}
		local fragment = unprioritised[v]
		if not fragment then
			warn(`Tabby: fragment {v} is undefined`)
			continue
		end
		
		table.insert(priorityOrder, fragment)
		unprioritised[v] = nil
	end
	
	-- fragments without a declared priority are placed last (this should warn about undeclared fragments)
	for idx, v in unprioritised do
		warn(`Tabby: fragment {idx} is not declared in LoadingOrder, loading last`)
		table.insert(priorityOrder, v)
	end
	
	fireMacro("Init")
end

function Me:Update(dt)
	fireMacro("Update", dt)
end

function Me:CreateFragment(fragmentName): TabbyFragment
	local frag = Catwork:CreateFragmentForService(fragmentName, self)
	frag.Plugin = Common.Plugin
	
	return frag
end

return Me