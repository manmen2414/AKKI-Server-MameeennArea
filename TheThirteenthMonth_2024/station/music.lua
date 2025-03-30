local speakers = { peripheral.find("speaker") };

local function newMusicFile(path)
    ---@class MusicFile
    local instance = {};
    local pipe = fs.open(path, "r");
    local data = pipe.readAll();
    pipe.close();
    local json = textutils.unserialiseJSON(data);
    ---@type number
    instance.bpm = json.bpm;
    ---@type number
    instance.start = json.start;
    ---@type {part:string,elements:[number,number][]}[]
    instance.items = json.items;

    function instance:play(speakers)
        local function playNote(part, pitch)
            for index, speaker in ipairs(speakers) do
                speaker.playNote(part, nil, pitch + self.start)
            end
        end
        local function sleepWithBpm(time)
            local kSound = 30 / self.bpm;
            sleep(kSound*(time+1));
        end
        local function playElement(part,element)
            sleepWithBpm(element[1]);
            playNote(part,element[2]);
        end
        local function playPart(item)
            for index, element in ipairs(item.elements) do
                playElement(item.part,element)
            end
        end
        local playFuncs = {};
        for index, value in ipairs(self.items) do
            playFuncs[#playFuncs+1] = function ()
                playPart(value)
            end
        end
        parallel.waitForAll(table.unpack(playFuncs))
    end

    return instance
end

return newMusicFile;