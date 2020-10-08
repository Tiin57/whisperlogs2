WL2.eventHandlers = {}

local function getClassColorARGB(lineId)
  local playerLocation = PlayerLocation:CreateFromChatLineID(lineId)
  local _, class = C_PlayerInfo.GetClass(playerLocation)
  local r, g, b, hex = GetClassColor(class)
  return hex
end

local function onChatMessageReceived(args)
  local text = args[1]
  local author = args[2]
  local lineId = args[11]

  WL2.store.push({
    otherPlayer = {
      name = author,
      color = getClassColorARGB(lineId)
    },
    text = text,
    receivedAt = WL2.date.toISO(time()),
    type = "received"
  })
end
WL2.eventHandlers.CHAT_MSG_WHISPER = onChatMessageReceived
WL2.eventHandlers.CHAT_MSG_BN_WHISPER = onChatMessageReceived

local function onChatMessageSent(args)
  local text = args[1]
  local recipient = args[2]
  local lineId = args[11]

  WL2.store.push({
    otherPlayer = {
      name = recipient,
      color = getClassColorARGB(lineId)
    },
    text = text,
    receivedAt = WL2.date.toISO(time()),
    type = "sent"
  })
end
WL2.eventHandlers.CHAT_MSG_WHISPER_INFORM = onChatMessageSent
WL2.eventHandlers.CHAT_MSG_BN_WHISPER_INFORM = onChatMessageSent

function WL2.eventHandlers.ADDON_LOADED(args)
  local addonName = args[1]
  if addonName ~= WL2.ADDON_NAME then
    return
  end
  WL2.commands.init()
  WL2.store.init()
end
