function table.find(tbl, fn)
  for _, v in ipairs(tbl) do
    if fn(v) then
      return v
    end
  end
  return nil
end
