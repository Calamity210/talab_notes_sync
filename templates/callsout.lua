function BlockQuote(el)
  if el.content[1] and el.content[1].t == "Para" then
    local first = el.content[1].content[1]
    
    if first and first.t == "Str" then
      -- Matches [!note], [warning!], etc.
      local ctype = first.text:match("^%[%!?(%a+)%!?%]")
      
      if ctype then
        ctype = ctype:lower()
        el.content[1].content:remove(1) -- Remove the bracket tag
        
        if el.content[1].content[1] and el.content[1].content[1].t == "Space" then
          el.content[1].content:remove(1) -- Remove trailing space
        end
        
        -- Wrap the blockquote contents in the LaTeX environment
        local result = { pandoc.RawBlock('latex', '\\begin{' .. ctype .. '}') }
        for _, block in ipairs(el.content) do
          table.insert(result, block)
        end
        table.insert(result, pandoc.RawBlock('latex', '\\end{' .. ctype .. '}'))
        
        return result
      end
    end
  end
end