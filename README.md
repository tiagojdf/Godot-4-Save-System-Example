# Godot 4 Save System Demo

This is an example on how to implement a Save System in Godot 4, using resources, and creating a save slot system.

If you want to try and implement the Save System used here, you can check out the branch "game-only" and use that as a starting point.

You can check the follow youtube video to see how it was implemented:
	

# Basic Idea

This save system is implemented as follows:

- Define a SaveSystem autoload
- Define a folder to store the saves, in this case: "user://saves/"
- Use DirAccess to recover the list of files in that folder
- Show a SaveSlot component for each file.

When you create a new game, we define a new Resource File for that game. In it we store the game data using ResourceSaver.
Selecting a SaveSlot loads the GameData using ResourceLoader and moves to the game scene.
