print("installing Application...")
for index, value in ipairs(fs.list("/disk/app")) do
    fs.move("/disk/app/" .. value, "/" .. value);
end
print("installed!")
shell.run("exit")
