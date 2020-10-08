WL2.store = {}

local tempWhispers = {}

function WL2.store.push(whisper)
  table.insert(SAVED_WHISPERS or tempWhispers, whisper)
  if SAVED_WHISPERS and #SAVED_WHISPERS > WL2.MESSAGE_LIMIT then
    table.remove(SAVED_WHISPERS, 1)
  end
end

WL2.store.isLoaded = false
function WL2.store.init()
  if SAVED_WHISPERS == nil then
    SAVED_WHISPERS = {}
  end
  WL2.table.concat(SAVED_WHISPERS, tempWhispers)
  WL2.store.isLoaded = true
end

function WL2.store.getAll()
  return SAVED_WHISPERS or tempWhispers
end

function WL2.store.clear()
  SAVED_WHISPERS = {}
  tempWhispers = {}
end

function WL2.store.removeByUsername(username)
  local newWhispers = {}
  local removedCount = 0
  for i, whisper in ipairs(SAVED_WHISPERS) do
    if whisper.author ~= username then
      table.insert(newWhispers, whisper)
    else
      removedCount = removedCount + 1
    end
  end
  SAVED_WHISPERS = newWhispers
  return removedCount
end
