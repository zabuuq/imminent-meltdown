# Imminent Meltdown

A 2D top-down time-pressure game built with Godot 4.6.1 for the **Toledo Codes Game Jam**.

Play as a technician racing against a nuclear meltdown countdown. Collect radioactive conduit pipes scattered around the reactor and deliver them to broken conduits before the timer hits zero. Every fix buys you more time — but radioactive workers are hunting you down.

**Play it on itch.io:** *(link TBD)*

---

## Gameplay

- Move with **WASD** or **Arrow Keys**
- Walk over a conduit pipe to pick it up (hold one at a time)
- Carry it to a glowing damage indicator on a broken reactor conduit to fix it
- Each fix extends the meltdown timer by **+15 seconds**
- Press **Space** to drop your held item

### Win / Lose

- **Win:** Fix all broken conduits before the timer expires
- **Lose:** The meltdown timer reaches zero, or your health drops to zero

### Enemies

Radioactive workers spawn continuously and chase you. They deal 1 damage on contact, steal conduit pipes, and drop them randomly. Your health regenerates slowly between hits. Kill them by... well, you can't — just avoid them or wait for them to decay on their own after 5–60 seconds.

### Progression

Each level starts with more broken conduits. Win to advance; your cumulative score carries over. Lose and you start over.

---

## Scenes

| Scene | Description |
|-------|-------------|
| `start_screen.tscn` | Title screen — press Space to begin |
| `main.tscn` | Core gameplay — reactor, player, enemies, HUD |
| `win_game.tscn` | Victory screen with score and time remaining |
| `game_over.tscn` | Game over screen with final stats |
| `player.tscn` | Player character (CharacterBody2D, health, item holding) |
| `radioactive_worker.tscn` | Enemy with AI pathfinding (NavigationAgent2D) |
| `conduit.tscn` | Collectible pipe object with bobbing animation |
| `damage_indicator.tscn` | Floating marker on broken conduits; drives win condition |
| `hud.tscn` | HUD showing damage count, cooldowns, timer, lives, score |

---

## Running Locally

Open the project in **Godot 4.6.1** and press **F5** (Run Project).

No CLI build process — all development happens through the Godot editor.

## Web Export

**Project > Export > HTML5** in the Godot editor. Requires the HTML5 export template installed via the Export Templates manager. Upload the resulting `.html`, `.js`, `.wasm`, and `.pck` files to itch.io and set game kind to "HTML".

---

## Assets

- Custom pixel art characters and tilemap (source: `art/raw/`)
- Floor/wall tiles from [Kenney.nl](https://kenney.nl) (`roguelikeDungeon_transparent.png`)
- Sound effects from [Freesound](https://freesound.org) community contributors
- Ambient audio: reactor hum, steam, turbine sounds

---

## Controls

| Action | Keys |
|--------|------|
| Move | WASD / Arrow Keys |
| Drop item | Space |
| Start game | Space |
