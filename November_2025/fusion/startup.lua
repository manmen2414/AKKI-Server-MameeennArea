local env = require("env")
local webhook = require("WebhookDiscord")
local embed = require("CreateEmbed")
local rla = peripheral.find("fusionReactorLogicAdapter")
local webhookSendable = env.SEND_TO_DISCORD and not not env.DISCORD_WEBHOOK;
local reported = true
if not rla then
  error("Fusion not found");
end
local ADJUST_REACTIVITY_TIME = 100
local function tweakEfficiency()
  local EF = rla.getEfficiency()
  local difference = 100 * ((1 / (EF + 10) * 22) - 0.2)
  rla.adjustReactivity(difference)
  sleep(ADJUST_REACTIVITY_TIME / 20)
  EF = rla.getEfficiency()
  if EF == 0 then
    return false
  end
  difference = 100 * ((1 / (EF + 10) * 22) - 0.2)
  if difference > 0.01 then
    rla.adjustReactivity(-difference)
    sleep(ADJUST_REACTIVITY_TIME / 20)
  end
  return true
end

while 1 do
  local currentEff = rla.getEfficiency()
  if currentEff <= 99.99 and currentEff ~= 0 then
    print("TR change was detected.\ntweak Efficiency.")
    if tweakEfficiency() then
      print("done!!")
    else
      print("failed")
    end
  end
  local currentErr = rla.getErrorLevel();
  if currentErr > 80 and webhookSendable and not reported then
    webhook(env.DISCORD_WEBHOOK, nil, nil, nil,
      { embed.Embed(
        "Fusion Reactor Alert",
        "Error level reached " .. currentErr .. "%",
        nil, embed.getNowIso(), 0xffff00) });
    reported = true;
  end
  if currentErr < 30 then
    reported = false;
  end
  sleep(0.05)
  if currentEff ~= 0 and rla.getEfficiency() == 0 then
    print("reactor has been stopped")
    if webhookSendable then
      webhook(env.DISCORD_WEBHOOK, nil, nil, nil,
        { embed.Embed(
          "Fusion Reactor Alert",
          "Stoped",
          nil, embed.getNowIso(), 0xff0000) });
      reported = true;
    end
  end
end
