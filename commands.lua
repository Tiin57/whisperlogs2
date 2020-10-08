local aliases = { "wl", "wl2", "wlog", "wlogs", "whisperlog", "whisperlogs" }
for i, alias in ipairs(aliases) do
  _G["SLASH_WHISPERLOGS" .. i] = "/" .. alias
end

WL2.commands = {}

WL2.commands.handlers = {
  print = {
    handle = function(username, maxLogs)
      maxLogs = maxLogs or WL2.DEFAULTS.printLogMax
      local whispers = WL2.store.getAll()
      if #whispers == 0 then
        print("No whispers have been logged!")
        return
      end
      local startIndex = math.max(1, #whispers - 20)
      print(string.format("Here are your last %d whispers:", 1 + #whispers - startIndex))
      for i = startIndex, #whispers do
        local w = WL2.Whisper.new(whispers[i])
        print(w:toString())
      end
    end,
    helpText = string.format(WL2.string.trim([[
Usage: /wl print [player] [max]
  Prints the most recent [max] whispers (defaults to %d), optionally to/from [player]
]]), WL2.DEFAULTS.printLogMax)
  },
  help = {
    handle = function(commandName)
      if not commandName then
        for commandName, cmd in pairs(WL2.commands.handlers) do
          if commandName == "help" then
            return
          end
          WL2.commands.handlers.help.handle(commandName)
        end
        return
      end
      local cmd = WL2.commands.handlers[commandName]
      if not cmd then
        print(string.format("Unknown command %s, try just /wl help", commandName))
        return
      end
      print(cmd.helpText)
    end
  },
  clear = {
    handle = function(username)
      if not WL2.store.isLoaded then
        print("WL2 data hasn't finished loading, please try again in a minute!")
        return
      end
      if username then
        local removedCount = WL2.store.removeByUsername(username)
        if removedCount == 0 then
          print(string.format("Didn't find any whispers to/from %s", username))
        else
          print(string.format("Cleared all whispers to/from %s", username))
        end
      else
        WL2.store.clear()
        print("Cleared all whispers.")
      end
    end,
    helpText = WL2.string.trim([[
Usage: /wl clear [player]
  Clears all whispers from the log, optionally only to/from a [player].
    ]])
  }
}

function WL2.commands.init()
  SlashCmdList.WHISPERLOGS = function(msg)
    local args = WL2.string.split(msg)
    local commandName = args[1]
    if #args == 0 then
      commandName = WL2.DEFAULTS.command
    end
    local cmd = WL2.commands.handlers[commandName:lower()]
    if not cmd then
      print(string.format("Unknown command %s, try /wl help", cmd))
      return
    end
    cmd.handle(unpack(WL2.table.slice(args, 2)))
  end
end
