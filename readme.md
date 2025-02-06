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

## Status: [DISCONTINUED]
> I've lost interest in this project. It may contain bugs or performance issues.

---
<br><br>

## Table of Contents
- [Downloads](#downloads)
- [Documentation](#documentation)
  - [Item ESP Guide](#item-esp-guide)
  - [Multiple Locations](#multiple-locations)

---
<br><br>

## Downloads

<details>
<summary><h3>Dx9ware [DISCONTINUED]</h3></summary>

[Source code](https://raw.githubusercontent.com/NotLockTheHobo/LocksNpcAimbot/refs/heads/main/src/dx9ware.lua)
</details>

<details>
<summary><h3>Severe [DISCONTINUED] - Last updated Feb 6, 2025</h3></summary>

The current settings are configured for ESP items (No Big Deal).

```lua
-- v1.02
-- game: No Big Deal
-- type: items esp
_G.settings = {
    ["Aimbot"] = {
        ["enabled"] = false,
        ["jitter_fix"] = true,
        ["max_distance"] = 200,
        ["closes_to_crosshair"] = true,
        ["aimbot_offset"] = {
            ["x"] = 0,
            ["y"] = 0,
        },
        ["show_fov"] = false,
        ["fov_size"] = 220,
        ["fov_color"] = { 255, 255, 255 },
        ["smoothness"] = 1,
        ["sensitivity"] = 1,
        ["target_dot"] = true,
        ["target_dot_size"] = 3,
        ["target_dot_color"] = { 255, 5, 50 },
    },
    ["Esp"] = {
        ["enabled"] = true,
        ["tracer"] = false,
        ["tracer_color"] = { 100, 100, 255 },
        ["tracer_offset"] = {
            ["y"] = -2,
        },
        ["stick"] = false,
        ["stick_color"] = { 255, 255, 255 },
        ["stick_offset"] = {
            ["y"] = 2,
        },
        ["name"] = true,
        ["name_custom_text"] = "",
        ["name_color"] = { 255, 255, 255 },
        ["name_offset"] = {
            ["x"] = 20,
            ["y"] = -7,
        },
        ["distance"] = false,
        ["distance_behind_text"] = "m",
        ["distance_color"] = { 100, 100, 100 },
        ["distance_offset"] = {
            ["x"] = 20,
            ["y"] = 5,
        },
        ["head_dot"] = true,
        ["head_dot_size"] = 1,
        ["head_dot_color"] = { 255, 255, 255 },
    },
    ["Npc Path"] = {
        [1] = { "Workspace" },
    },
    ["In Npc Path"] = { "Root" },
}

-- Main
loadstring(game:HttpGet("https://raw.githubusercontent.com/NotLockTheHobo/LocksNpcAimbot/refs/heads/main/src/severe.lua"))()
```
</details>

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
