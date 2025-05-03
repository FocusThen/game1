package main

import rl "vendor:raylib"


SCREEN_WIDTH :: 1000
SCREEN_HEIGHT :: 480


Game: struct {
	running:          bool,
	background_color: rl.Color,
}

Entities: struct {
	grass_sprite:  rl.Texture2D,
	//
	// Player
	//
	player_sprite: rl.Texture2D,
	player_source: rl.Rectangle,
	player_dest:   rl.Rectangle,
	player_speed:  f32,
}

game := Game
game_entities := Entities

game_init :: proc() {
	rl.InitWindow(SCREEN_WIDTH, SCREEN_HEIGHT, "Animal crossing")
	rl.SetTargetFPS(60)
	game.running = true
	game.background_color = {147, 211, 196, 255}

	game_entities.grass_sprite = rl.LoadTexture("./assets/Tilesets/Grass.png")
	game_entities.player_sprite = rl.LoadTexture(
		"./assets/Characters/Basic Charakter Spritesheet.png",
	)
	game_entities.player_source = rl.Rectangle{0, 0, 48, 48}
	game_entities.player_dest = rl.Rectangle{200, 200, 100, 100}
	game_entities.player_speed = 3
}

game_update :: proc() {
	game.running = !rl.WindowShouldClose()
}

draw_scene :: proc() {
	rl.DrawTexture(game_entities.grass_sprite, 100, 50, rl.WHITE)
	rl.DrawTexturePro(
		game_entities.player_sprite,
		game_entities.player_source,
		game_entities.player_dest,
		rl.Vector2{game_entities.player_dest.width, game_entities.player_dest.height},
		0,
		rl.WHITE,
	)
}

game_render :: proc() {
	rl.BeginDrawing()
	rl.ClearBackground(game.background_color)

	draw_scene()

	rl.EndDrawing()
}

game_input :: proc() {
	if rl.IsKeyDown(.W) {
		game_entities.player_dest.y -= game_entities.player_speed
	}
	if rl.IsKeyDown(.S) {
		game_entities.player_dest.y += game_entities.player_speed
	}
	if rl.IsKeyDown(.A) {
		game_entities.player_dest.x -= game_entities.player_speed
	}
	if rl.IsKeyDown(.D) {
		game_entities.player_dest.x += game_entities.player_speed
	}
}

game_quit :: proc() {
	rl.UnloadTexture(game_entities.grass_sprite)
	rl.UnloadTexture(game_entities.player_sprite)
	rl.CloseWindow()
}

main :: proc() {
	game_init()
	for game.running {
		game_input()
		game_update()
		game_render()
	}

	game_quit()
}
