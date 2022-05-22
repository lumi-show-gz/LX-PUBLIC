--[[

    88          88        88  888b         d888  88
    88          88        88  88`8b       d8'88  88
    88          88        88  88 `8b     d8' 88  88
    88          88        88  88  `8b   d8'  88  88
    88          88        88  88   `8b d8'   88  88
    88          Y8a.    .a8P  88    `888'    88  88
    88          88        88  88b    d8b      d88  88  888
    88888888888  `"Y8888Y"'   88     `8'     88  88  888

     ad88888ba   88        88    ,ad8888ba,   I8,        8        ,8I
    d8"     "8b  88        88   d8"'    `"8b  `8b       d8b       d8'
    Y8,          88        88  d8'        `8b  "8,     ,8"8,     ,8"
    `Y8aaaaa,    88aaaaaaaa88  88          88   Y8     8P Y8     8P
      `"""""8b,  88""""""""88  88          88   `8b   d8' `8b   d8'
            `8b  88        88  Y8,        ,8P    `8a a8'   `8a a8'
    Y8a     a8P  88        88   Y8a.    .a8P      `8a8'     `8a8'  888
     "Y88888P"   88        88    `"Y8888Y"'        `8'       `8'   888

      ,ad8888ba,   888888888888
     d8"'    `"8b           ,88
    d8'                   ,88"
    88                  ,88"
    88      88888     ,88"
    Y8,        88   ,88"
     Y8a.    .a88  88"
      `"Y88888P"   888888888888


    Instance Group Creator
    v1.0
    by: Jean-Benoit Meunier
    2022-05-22
]]--

-- GMA2 API shortcuts
local internal_name        = select(1,...);
local visible_name        = select(2,...);

local echo               =gma.feedback;
local cmd                =gma.cmd;
local gui                =gma.gui;
local confirm             = gui.confirm;
local obj                =gma.show.getobj;
local handle             =obj.handle;
local input              =gma.textinput;
local mflr               =math.floor;

-- plugin loaded message --
echo("Plugin " .. internal_name .. " successfully loaded.")
echo("Plugin will appear as " .. visible_name .. " in plugin pool.")


local function CheckExist(o)
    local h = handle(o);
    if(h) then
        return true;
    else
        return false;
    end;
end

function InstanceGroup()

    local valid = false;
    local sourcePointer = "";
    local destinationGroup = "";
    local groupPrefix = "";

    while not valid do 
        sourcePointer = input("Group or Fixture to split?","[Group X] OR [Fixture Y]");
        destinationGroup = input("ID of Group to store?","[X]");
        groupPrefix = input("Prefix for group?","[NAME]")
        local searchReturn = CheckExist(sourcePointer);
        if searchReturn then
            valid = true;
        else
            valid = false;
            confirm("Object " .. sourcePointer .. " was not found.");
        end
    end

    local curHandle = handle(sourcePointer);
    local childAmounts = obj.amount(curHandle)
    echo("Fixture has " .. childAmounts .. " instances.")

    for i=1, childAmounts, 1 do
        cmd("ClearAll");
        cmd(sourcePointer);
        cmd("If Fixture *." .. i);
        cmd("Store Group " .. destinationGroup .. "/m /nc")
        cmd("Label Group " .. destinationGroup .. " " .. "\"" .. groupPrefix .. "." .. i .. "\"")
        destinationGroup = mflr(destinationGroup + 1);
    end
    cmd("ClearAll")
end
