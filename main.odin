package main

import rl "vendor:raylib"


SCREEN_WIDTH :: 1000
SCREEN_HEIGHT :: 480


GameState: struct {
	running:          bool,
	background_color: rl.Color,
}

game_state := GameState

game_init :: proc() {
	rl.InitWindow(SCREEN_WIDTH, SCREEN_HEIGHT, "Animal crossing")
	rl.SetTargetFPS(60)
	game_state.running = true
	game_state.background_color = {147, 211, 196, 255}
}

game_update :: proc() {
	game_state.running = !rl.WindowShouldClose()
}

draw_scene :: proc() {
}

game_render :: proc() {
	rl.BeginDrawing()
	rl.ClearBackground(game_state.background_color)

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
	for game_state.running {
		game_input()
		game_update()
		game_render()
	}

	game_quit()
}
