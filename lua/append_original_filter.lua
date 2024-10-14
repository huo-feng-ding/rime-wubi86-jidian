-- 原始字符串输出，用来实现分号临时英文，再输入分号顶屏上字

function append_original_filter(input, env)
    local envengine = env.engine
    local envcontext = envengine.context
    local composition = envcontext.composition
    local segmentation = composition:toSegmentation()
    local schema = envengine.schema

    if(not composition:empty()) then
        local seg = composition:back()
        if schema.schema_id == "easy_en" then
            yield(Candidate("string", seg.start, seg._end, segmentation.input, ""))
        elseif segmentation.input:sub(1, 1) == ";" and segmentation.input:len() > 1  then
            if segmentation.input:sub(segmentation.input:len(), segmentation.input:len()) == ";" then
                envengine:commit_text(string.sub(segmentation.input, 2))
                -- envengine:commit_text(";")
                envcontext:clear()
                return
            -- else
                -- yield(Candidate("space", seg.start, seg._end, string.sub(segmentation.input, 2), ""))
            end
        end
    end
    for cand in input:iter() do
        yield(cand)
    end
end


return append_original_filter




