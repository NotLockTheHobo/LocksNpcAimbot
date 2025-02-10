<div align="center">
    <img src="assets/logo_censored.png" alt="logo" style="width: 20%">
    <br><br>
    <p>
        <strong>Lock's Npc Aimbot</strong>
    </p>
</div>

## Overview

Ever wanted to make item ESP quickly and easily?  
Well, you've found the right script for the job!

This script simplifies the process of adding ESP and aimbot functionality to any game.
<br> All you need to do is specify where your items/Npcs are located and assign their root part.

---
<br><br>

## Table of Contents
- [Downloads](#downloads)
- [Games](#games)
- [Documentation](#documentation)
  - [Item ESP Guide](#item-esp-guide)
  - [Multiple Locations](#multiple-locations)

---
<br><br>

## Downloads
> I don't have a subscription for dx9ware, and I'm not paying for a subscription, so it's pretty much discontinued.

Severe
[`Link`](https://raw.githubusercontent.com/NotLockTheHobo/LocksNpcAimbot/refs/heads/main/games/severe/sv_lna_baseplate.lua)

Dx9ware *[DISCONTINUED]*
[`Link`](https://raw.githubusercontent.com/NotLockTheHobo/LocksNpcAimbot/refs/heads/main/src/dx9ware.lua)


---
<br><br>

## Games
> Pre configured settings for different games.

Severe
[`Browse configs`](/games/severe/)

Dx9ware
~~`No configs`~~

---
<br><br>

## Documentation

### Item ESP Guide

#### 1. Locate Your Items
First, determine where your items are stored in the game:
- Open DEX
- Navigate through the game hierarchy
- Note down the full path to where items are located
- Example: If items are in `Workspace > SpawnedItems`, your path would be `{ "Workspace", "SpawnedItems" }`

#### 2. Identify the Root Part
Find the part of the item you want to track:
- Look for the main part (usually named "Handle", "MainPart", or "Root")
- This will be your `In Npc Path` setting

#### 3. Configure Settings
Apply the correct paths in your settings:
```lua
_G.settings {
    -- ["Aimbot"] ... 
    -- ["Esp"] ... 
    ["Npc Path"] = {
        { "Workspace", "SpawnedItems" },
    },
    ["In Npc Path"] = { "Handle" },
}
```

### Multiple Locations

If your items are spread across different locations, you can specify multiple paths:
```lua
["Npc Path"] = {
    { "Workspace", "SpawnedItems" },
    { "Workspace", "Loot", "Rare" },
    { "Workspace", "Loot", "Common" }
},
```
