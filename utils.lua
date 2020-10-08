WL2.date = {}
function WL2.date.fromISO(str)
  local dtTokens = WL2.string.split(str, "T|Z")
  local dateTokens = WL2.string.split(dtTokens[1], "-")
  local timeTokens = WL2.string.split(dtTokens[2], ":")
  return time({
    year = tonumber(dateTokens[1]),
    month = tonumber(dateTokens[2]),
    day = tonumber(dateTokens[3]),
    hour = tonumber(timeTokens[1]),
    min = tonumber(timeTokens[2]),
    sec = tonumber(timeTokens[3])
  })
end
function WL2.date.toISO(ts)
  return date("%Y-%m-%dT%XZ", ts)
end

WL2.table = {}
function WL2.table.concat(t1, t2)
  for _, v in pairs(t2) do
    table.insert(t1, v)
  end
  return t1
end
function WL2.table.slice(source, startIndex, endIndex)
  local sliced = {}
  for i = startIndex or 0, endIndex or #source do
    table.insert(sliced, source[i])
  end
  return sliced
end

WL2.string = {}
function WL2.string.trim(s)
  -- from PiL2 20.4
  return (s:gsub("^%s*(.-)%s*$", "%1"))
end
function WL2.string.split(s, sep)
  if not sep then sep = "%s" end
  local tokens = {}
  for token in string.gmatch(s, "[^" .. sep .. "]+") do
    table.insert(tokens, token)
  end
  return tokens
end
