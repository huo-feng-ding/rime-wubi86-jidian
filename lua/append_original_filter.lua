-- 原始字符串输出，用来实现分号临时英文，再输入分号顶屏上字

-- local log = require("log")
-- log.outfile = "D:\\aux_code.log"

local function append_original_filter(input, env)
	local envengine = env.engine
	local envcontext = envengine.context
	local composition = envcontext.composition
	local segmentation = composition:toSegmentation()
	local schema = envengine.schema

	if not composition:empty() then
		local seg = composition:back()
		local segInput = segmentation.input
		local segInputLen = string.len(segInput)

		if schema.schema_id == "easy_en" then
			yield(Candidate("string", seg.start, seg._end, segInput, ""))
		elseif segInput:match("^[;A-Z][-.;_+'0-9a-zA-Z]*$") then
			-- 上边的正则表达式和 default.custom.yaml recognizer/patterns/english 配置有关联
			-- log.info('inputInfo:', segInput, segInputLen, string.sub(segInput,segInputLen, segInputLen), string.sub(segInput,segInputLen, segInputLen)==";")

			-- 以分号开头引导临时英
			if segInput:sub(1, 1) == ";" and segInputLen > 1 then
				-- 如果是以分号结尾的则上屏, 其它字符结尾的会自动顶屏
				if string.sub(segInput, segInputLen, segInputLen) == ";" then
					envengine:commit_text(string.sub(segInput, 2))
					envcontext:clear()
					return
				else
					yield(Candidate("word", seg.start, seg._end, string.sub(segInput, 2), ""))
					return
				end
			elseif segInput:match("^[A-Z]") then
				-- 以大写开头引导临时英文, 以分号结尾则上屏
				if string.sub(segInput, segInputLen, segInputLen) == ";" then
					envengine:commit_text(segInput, 2)
					envcontext:clear()
					return
				else
					yield(Candidate("word", seg.start, seg._end, segInput, ""))
					return
				end
			end
		end
	end

	for cand in input:iter() do
		yield(cand)
	end
end

return append_original_filter
