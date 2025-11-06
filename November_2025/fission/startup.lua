local side = "left";
local env = require("env")
local webhook = require("WebhookDiscord")
local embed = require("CreateEmbed")
local rla = peripheral.find("fusionReactorLogicAdapter")
local TITLE = "Fisson Reactor Alert #1";
local reported = {
  white = false,
  orange = false,
  magenta = false,
  lightBlue = false,
  yellow = false,
  lime = false,
  pink = false,
  gray = false,
  lightGray = false,
  cyan = false,
  purple = false,
  blue = false,
  brown = false,
  green = false,
  red = false,
  black = false,
}

local function getAllcolor()
  return {
    white = redstone.testBundledInput(side, colors.white),
    orange = redstone.testBundledInput(side, colors.orange),
    magenta = redstone.testBundledInput(side, colors.magenta),
    lightBlue = redstone.testBundledInput(side, colors.lightBlue),
    yellow = redstone.testBundledInput(side, colors.yellow),
    lime = redstone.testBundledInput(side, colors.lime),
    pink = redstone.testBundledInput(side, colors.pink),
    gray = redstone.testBundledInput(side, colors.gray),
    lightGray = redstone.testBundledInput(side, colors.lightGray),
    cyan = redstone.testBundledInput(side, colors.cyan),
    purple = redstone.testBundledInput(side, colors.purple),
    blue = redstone.testBundledInput(side, colors.blue),
    brown = redstone.testBundledInput(side, colors.brown),
    green = redstone.testBundledInput(side, colors.green),
    red = redstone.testBundledInput(side, colors.red),
    black = redstone.testBundledInput(side, colors.black),
  };
end

local function warnEmbed(color, about)
  webhook(env.DISCORD_WEBHOOK, "<@778582802504351745>", nil, nil,
    { embed.Embed(
      TITLE,
      about,
      nil, embed.getNowIso(), color) });
end

repeat
  local color = getAllcolor();
  if color.red and not reported.red then
    warnEmbed(0xff0000, "High Damage")
  end
  if color.orange and not reported.orange then
    warnEmbed(0xf2b233, "High Temp")
  end
  if color.blue and not reported.blue then
    warnEmbed(0x3344ff, "Too Low Water")
  end
  if color.magenta and not reported.magenta then
    warnEmbed(0x7F664C, "Too Many Waste")
  end
  if color.yellow and not reported.yellow then
    warnEmbed(0xffffff, "Too Many Steam")
  end
  reported = color;
  sleep(0.1)
until false
