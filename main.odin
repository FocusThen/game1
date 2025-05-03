package main

import rl "vendor:raylib"


SCREEN_WIDTH :: 1000
SCREEN_HEIGHT :: 480


Game: struct {
	running:          bool,
	background_color: rl.Color,
}

Entities: struct {
	grass_sprite: rl.Texture2D,
}

game := Game
game_entities := Entities

game_init :: proc() {
	rl.InitWindow(SCREEN_WIDTH, SCREEN_HEIGHT, "Animal crossing")
	rl.SetTargetFPS(60)
	game.running = true
	game.background_color = {147, 211, 196, 255}

  game_entities.grass_sprite = rl.LoadTexture("./assets/Tilesets/Grass.png")
}

game_update :: proc() {
	game.running = !rl.WindowShouldClose()
}

draw_scene :: proc() {
  rl.DrawTexture(game_entities.grass_sprite, 100,50 ,rl.WHITE)
}

game_render :: proc() {
	rl.BeginDrawing()
	rl.ClearBackground(game.background_color)

	draw_scene()

	rl.EndDrawing()
}

game_input :: proc() {

}
game_quit :: proc() {

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
