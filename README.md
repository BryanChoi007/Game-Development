# Master Chief's Adventure

A top-down action game featuring Master Chief from Halo in a Legend of Zelda-style world with dirt and grass terrain.

## Game Features

- **Master Chief as the protagonist** - Play as the iconic Spartan in a top-down view
- **Zelda-style gameplay** - Explore and fight in a top-down perspective
- **Terrain system** - Dirt and grass tiles for varied environments
- **Combat system** - Shoot enemies with Master Chief's weapon
- **Enemy AI** - Enemies that chase and attack the player
- **Health system** - Manage your health as you fight enemies
- **Dynamic spawning** - Enemies spawn around the player for continuous action

## Controls

- **WASD** - Move Master Chief
- **Mouse** - Aim weapon
- **Left Click / Space** - Shoot
- **ESC** - Quit game

## How to Run

1. **Install Godot 4.2** or later from [godotengine.org](https://godotengine.org/)
2. **Open the project** in Godot by selecting the `project.godot` file
3. **Run the game** by pressing F5 or clicking the play button

**Note:** The game is now ready to run! All texture loading errors have been fixed.

## Project Structure

```
Game Development/
├── project.godot          # Main project configuration
├── scripts/               # Game scripts
│   ├── Player.gd         # Master Chief player controller
│   ├── Bullet.gd         # Projectile system
│   ├── Enemy.gd          # Enemy AI
│   ├── EnemySpawner.gd   # Enemy spawning system
│   ├── Main.gd           # Main game logic
│   └── UI.gd             # User interface
├── scenes/               # Scene files
│   ├── Main.tscn         # Main game scene
│   ├── Bullet.tscn       # Bullet scene
│   └── Enemy.tscn        # Enemy scene
├── assets/               # Game assets (placeholders)
│   ├── master_chief.png  # Master Chief sprite
│   ├── terrain_texture.png # Dirt and grass tiles
│   ├── bullet_placeholder.png # Bullet sprite
│   ├── enemy_placeholder.png # Enemy sprite
│   ├── crosshair_placeholder.png # Aiming crosshair
│   └── impact_placeholder.png # Impact effects
└── tilesets/             # Tile system
    └── terrain_tileset.tres # Terrain tileset configuration
```

## Game Mechanics

### Player (Master Chief)
- **Movement**: Smooth 8-directional movement
- **Combat**: Aim with mouse, shoot with left click or spacebar
- **Health**: 100 HP with visual health bar
- **Camera**: Follows player with zoom for better visibility

### Enemies
- **AI**: Chase player when in detection range
- **Combat**: Attack when close enough
- **Health**: 50 HP with individual health bars
- **Spawning**: Continuously spawn around the player

### Environment
- **Terrain**: Dirt and grass tiles for varied landscapes
- **Collision**: Proper collision detection for all entities
- **Effects**: Visual feedback for damage and impacts

## Development Notes

This is a complete Godot 4.2 project with all necessary scripts and scene configurations. The placeholder texture files indicate where you would add actual sprites and textures for a polished game.

### To Add Real Graphics:
1. Replace placeholder files in `assets/` with actual PNG images
2. Update scene files to reference the new textures
3. Add proper animations to the AnimationPlayer nodes

### To Extend the Game:
- Add more enemy types
- Implement power-ups and weapons
- Create multiple levels or areas
- Add sound effects and music
- Implement a scoring system

## Requirements

- Godot 4.2 or later
- Windows, macOS, or Linux
- No additional dependencies required

Enjoy playing as Master Chief in this top-down adventure! 