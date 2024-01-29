function table.find(tbl, fn)
  for i, v in ipairs(tbl) do
    if fn(v) then
      return v
    end
  end
  return nil
end
