-- local log = require("log")
-- log.outfile = "D:\\aux_code.log"

_G.kRejected, _G.kAccepted, _G.kNoop = 0, 1, 2

local tags = { "english", "pinyin" }

local function check_tag(context)
	local composition = context.composition
	if not composition:empty() then
		local segment = composition:back()
		for _, x in ipairs(tags) do
			if segment:has_tag(x) then
				return true
			end
		end
	end
	return false
end

local function processor(key, env)
	local engine = env.engine
	local context = engine.context
	local repr = key:repr()
	local input = context.input
	-- log.info(repr, input, env.trigger_key)

	if check_tag(context) and repr == "Return" then
		-- 如果是以分号开头的，则剔除开头的分号上屏
		if string.sub(input, 1, 1) == ";" then
			engine:commit_text(string.sub(input, 2))
		else
			-- 否则是按大写字母开头的，全部上屏
			engine:commit_text(input)
		end
		context.input = ""
		return kAccepted
	end

	-- 如果是Control+space，则上屏编码并切换输入法。使用此功能需要修改window注册表禁用Control+space快捷键
	if not key:release() and (key:repr() == "Control+space") then
		local target_state = not context:get_option("ascii_mode")
		if context:is_composing() then
			context:clear_non_confirmed_composition()
			context:commit()
		end
		context:set_option("ascii_mode", target_state)
		return 1
	end

	-- 四码无候选词时按空格只清空不上屏
	if repr == "space" and input:len() == 4 and not context:has_menu() then
		context.input = ""
		context:clear() -- 清空编码,好像不起太大作用，主要是上边 context.input="" 起了作用
		return 1
	end

	return kNoop
end

return processor
