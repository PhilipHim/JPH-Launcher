# JPH Launcher

<p align="center">
  <img src="emblem.png" alt="JPH Launcher" width="420">
</p>

A Minecraft launcher for the Mac. Built as a learning project, to see how a launcher actually starts the game: which Java version, which profile, which mods, and where the world lives.

The window is a native Mac app. Black, light type, gold only where it matters.

## What it can do

- Start Minecraft Java. Set up for 26.3, with Fabric.
- Three pages: Start, Skins, Mods.
- A loading bar on Play that reads the real progress from the game log.
- Switch skins between your own skin, Steve, and Alex. The skin is applied as a resource pack.
- Search mods and choose them yourself. **Add** puts a mod in the folder, **In** takes it out. Nothing is preselected except what the launcher itself needs.
- **JPH Mod** stays at the top of the mod list. In a world, Right Shift opens a list: flight, speed, reach, velocity, fullbright, and a few more values you can set. They apply in a singleplayer world.
- Settings behind the gear: RAM, fullscreen, instances, the log from the last launch, and an account button.

## What it cannot do

Multiplayer. The sign-in from the official launcher belongs to Mojang and does not come along. JPH needs its own app id, approved by Mojang. The button under the gear is ready for that. Until the id exists, real servers stay closed. The official launcher still plays those.

## Start

A clone is not the app yet. Double-click `Open.command`. It builds the app, sets up Python, and opens it.

The first time, macOS asks. Right-click the file and choose **Open**.

After that, `JPH Launcher.app` sits in the same folder. Open that directly.

Minecraft has to be installed on the Mac already. The launcher keeps its own copy under `game/` and does not touch worlds from the official launcher.
