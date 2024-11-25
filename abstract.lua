-- Adopted from https://github.com/quarto-dev/quarto-cli/discussions/2715#discussioncomment-3883630

local List = require("pandoc.List")
local utils = require("pandoc.utils")
local stringify = utils.stringify

local Abstract = nil
local function create_abstract(ab)
    Abstract = {}
    table.insert(Abstract, pandoc.Header(1, "Abstract"))
    table.insert(Abstract, pandoc.Para(utils.stringify(ab)))  -- utils.stringify is added
end

local Keywords = nil
local function create_keyword_list(kw)
    Keywords = {}
    local kws = pandoc.List({})
    for i, keyword in ipairs(kw) do
        kws:insert(stringify(keyword))
    end
    local kwentry = table.concat(kws, "; ")
    kwentry = "Keywords: " .. kwentry .. "."
    table.insert(Keywords, pandoc.Para(pandoc.Str(kwentry)))
end

local function remove_abstract_meta(meta)
    meta["abstract"] = nil
    meta["keywords"] = nil
    return meta
end

return {
    {
        Meta = function(meta)
            if meta["abstract"] ~= nil then
                create_abstract(meta["abstract"])
            end
            if meta["keywords"] ~= nil then
                create_keyword_list(meta["keywords"])
            end
            return meta
        end,
    },
    {
        Pandoc = function(doc)
            local meta = doc.meta
            local body = List:new({})
            if Abstract then
                body:extend(Abstract)
            end
            if Keywords then
                body:extend(Keywords)
            end
            body:extend(doc.blocks)
            meta = remove_abstract_meta(meta)
            return pandoc.Pandoc(body, meta)
        end,
    },
}
