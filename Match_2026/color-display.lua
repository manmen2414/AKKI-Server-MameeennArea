local TEXT = "Welcome to Minecrant!";
local TEXT_LENG = #TEXT;
local PLAYERS = {
  "Friderich", "AM_107ryu"
}
local monitor = peripheral.find("monitor");
local playersJoined = table.concat(PLAYERS, "   ") .. "   ";
local playersJoinedLeng = #playersJoined;
local playersJoinedLooped = playersJoined:rep(10);
monitor.clear();
local function writeText()
  repeat
    monitor.setCursorPos(1, 1);
    monitor.setTextColor(colors.red);
    monitor.write(TEXT);
    monitor.setTextColor(colors.white);
    monitor.setCursorPos(1, 2);
    monitor.write(os.date());
    for i = 1, TEXT_LENG, 1 do
      monitor.setTextColor(colors.yellow);
      monitor.setCursorPos(i, 1);
      monitor.write(TEXT:sub(i, i));
      monitor.setTextColor(colors.red);
      monitor.setCursorPos(i - 1, 1);
      monitor.write(TEXT:sub(i - 1, i - 1));
      sleep(0.1)
    end
  until false
end


local function writePlayers()
  monitor.setCursorPos(1, 4);
  monitor.setTextColor(colors.red);
  monitor.write("Players (" .. #PLAYERS .. ")");
  monitor.setCursorPos(1, 5);
  repeat
    for i = 1, playersJoinedLeng, 1 do
      monitor.setCursorPos(1, 5);
      monitor.setTextColor(colors.white);
      monitor.write(playersJoinedLooped:sub(i));
      sleep(0.2)
    end
  until false
end

parallel.waitForAll(writeText, writePlayers)
