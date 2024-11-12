-- 原始字符串输出，用来实现分号临时英文，再输入分号顶屏上字

-- local log = require 'log'
-- log.outfile = "D:\\aux_code.log"

local function append_original_filter(input, env)
    local envengine = env.engine
    local envcontext = envengine.context
    local composition = envcontext.composition
    local segmentation = composition:toSegmentation()
    local schema = envengine.schema

    if(not composition:empty()) then
        local seg = composition:back()
        local segInput = segmentation.input
        local segInputLen = string.len(segInput)
        if schema.schema_id == "easy_en" then
            yield(Candidate("string", seg.start, seg._end, segInput, ""))
        elseif segInput:sub(1, 1) == ";"  then
            -- 分号是引导的，输入字符大于一个才有效
            if segInputLen > 1 then 
                -- 这里和正则字符集和 default.custom.yaml recognizer/patterns/english 配置有关联
                local word = string.match(segInput, ".*[-._+'a-zA-Z]$")
                -- log.info('s', segInput, word==nil, segInputLen, string.sub(segInput,segInputLen, segInputLen), string.sub(segInput,segInputLen, segInputLen)==";")
                -- 如果是英语单词，则在候选栏里显示
                if word ~= nil then 
                    -- log.info('t', segInput)
                    yield(Candidate("word", seg.start, seg._end, string.sub(segInput, 2), ""))
                elseif string.sub(segInput,segInputLen, segInputLen) == ";" then
                    -- 如果是以分号结尾的则上屏
                    -- log.info('u', segInput)
                    envengine:commit_text(string.sub(segInput, 2))
                    envcontext:clear()
                    return
                end
            end
        else
            local word = string.match(segInput, "^[A-Z][-._+'a-zA-Z]*$")
            -- 如果是以大写字母开关的,则在候选栏里显示
            if word ~= nil then 
                yield(Candidate("word", seg.start, seg._end, segInput, ""))
            elseif string.sub(segInput,segInputLen, segInputLen) == ";" then
                -- 如果是以分号结尾的则上屏
                envengine:commit_text(segInput, 2)
                envcontext:clear()
                return
            end
        end
    end
    for cand in input:iter() do
        yield(cand)
    end
end


return append_original_filter




