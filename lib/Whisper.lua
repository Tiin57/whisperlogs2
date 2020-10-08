WL2.Whisper = {}
WL2.Whisper.__index = WL2.Whisper

function WL2.Whisper.new(init)
  return setmetatable(init, WL2.Whisper)
end

function WL2.Whisper:toString()
  local receivedAt = date("%I:%M:%S", WL2.date.fromISO(self.receivedAt))
  local otherPlayerName = self.otherPlayer.name
  local otherTokens = WL2.string.split(otherPlayerName, "-")
  if otherTokens[2] == WL2.REALM then
    otherPlayerName = otherTokens[1]
  end
  local format = "|c%s%s [|c%s%s|c%s] whispers: %s"
  if self.type == "sent" then
    format = "|c%s%s To [|c%s%s|c%s]: %s"
  end
  return string.format(format,
    WL2.COLORS.whisper,
    receivedAt,
    self.otherPlayer.color,
    otherPlayerName,
    WL2.COLORS.whisper,
    self.text
  )
end
