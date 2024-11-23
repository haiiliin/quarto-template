-- Adopted from https://github.com/quarto-dev/quarto-cli/discussions/2715#discussioncomment-3883630

local List = require("pandoc.List")
local utils = require("pandoc.utils")
local stringify = utils.stringify
local byAuthor
local byAffiliation
local Authors = {}
local Affiliations = {}

local authorHoriz

local Corresponding = nil
local function make_correspondance(name, email)
	correspondance = List:new({
		pandoc.Str("* Corresponding Author: "),
		pandoc.Str(name),
		pandoc.Str(" ("),
		pandoc.Link(email, "mailto:" .. email),
		pandoc.Str(")"),
	})
	Corresponding = List:new({ pandoc.Para(correspondance) })
end

local equalCont
local function make_equal_contributor()
	eq_statement = pandoc.Str("† These authors contributed equally to this work.")
	equalCont = List:new({ pandoc.Para(eq_statement) })
end

local function create_author_list(byAuthor)
	local authors = {}
	for i, author in ipairs(byAuthor) do
		local sups = {}

		for j, aff in ipairs(author.affiliations) do
			table.insert(sups, aff.number)
		end
		sups_str = table.concat(sups, ",")

		local name = stringify(author.name.literal)

		if author.attributes ~= nil then
			if author.attributes["equal-contributor"] ~= nil and author.attributes["equal-contributor"] then
				sups_str = sups_str .. ",†"
				make_equal_contributor()
			end
			if author.attributes.corresponding ~= nil and author.attributes.corresponding then
				local email = stringify(author.email)
				sups_str = sups_str .. ",*"
				make_correspondance(name, email)
			end
		end

		local authorEntry = List:new({
			pandoc.Str(name),
			pandoc.Superscript(pandoc.Str(sups_str)),
		})

		if authorHoriz and i < #byAuthor then
			authorEntry:extend({ pandoc.Str(", ") })
		end

		table.insert(authors, pandoc.Span(authorEntry))
	end

	if authorHoriz then
		Authors = { pandoc.Para(authors) }
	else
		Authors = authors
	end
end

local function create_affiliation_list(byAffiliation)
	for i, aff in ipairs(byAffiliation) do
		local full_aff = pandoc.List({})
		if aff.name then
			full_aff:insert(stringify(aff.name))
		end

		if aff.address then
			full_aff:insert(stringify(aff.address))
		end

		if aff.city then
			full_aff:insert(stringify(aff.city))
		end

		if aff["postal-code"] then
			full_aff:insert(stringify(aff["postal-code"]))
		end

		if aff.region then
			full_aff:insert(stringify(aff.region))
		end

		if aff.country then
			full_aff:insert(stringify(aff.country))
		end

		local entry = table.concat(full_aff, ", ")
		entry = aff.number .. ". " .. entry .. "."
		table.insert(Affiliations, pandoc.Para(pandoc.Str(entry)))
	end
end

local Abstract = nil
local function create_abstract(ab)
	Abstract = {}
	table.insert(Abstract, pandoc.Header(1, "Abstract"))
	table.insert(Abstract, pandoc.Para(pandoc.utils.stringify(ab)))  -- pandoc.utils.stringify is added
end

local Keywords = nil
local function create_keyword_list(kw)
	Keywords = {}
	-- quarto.log.output(kw)
	local kws = pandoc.List({})
	for i, keyword in ipairs(kw) do
		kws:insert(stringify(keyword))
	end
	local kwentry = table.concat(kws, "; ")
	kwentry = "Keywords: " .. kwentry .. "."
	table.insert(Keywords, pandoc.Para(pandoc.Str(kwentry)))
end

local function remove_author_meta(meta)
	meta.author = nil
	meta.authors = nil
	meta.affiliations = nil
	meta["by-author"] = nil
	meta["by-affiliation"] = nil
	meta["abstract"] = nil
	return meta
end

return {
	{
		Meta = function(meta)
			byAuthor = meta["by-author"]
			byAffiliation = meta["by-affiliation"]
			if meta["author-horizontal"] ~= nil then
				authorHoriz = meta["author-horizontal"]
			else
				authorHoriz = true
			end
			create_author_list(byAuthor)
			create_affiliation_list(byAffiliation)
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
			body:extend(Authors)
			body:extend(Affiliations)
			if equalCont ~= nil then
				body:extend(equalCont)
			end
			if Corresponding ~= nil then
				body:extend(Corresponding)
			end
			if Abstract then
				body:extend(Abstract)
			end
			if Keywords then
				body:extend(Keywords)
			end
			body:extend(doc.blocks)
			meta = remove_author_meta(meta)
			return pandoc.Pandoc(body, meta)
		end,
	},
}
