package main

import rl "vendor:raylib"


SCREEN_WIDTH :: 1000
SCREEN_HEIGHT :: 480


Game: struct {
	running:          bool,
	background_color: rl.Color,
	camera:           rl.Camera2D,
}

Entities: struct {
	grass_sprite:       rl.Texture2D,
	//
	// Player
	//
	player_sprite:      rl.Texture2D,
	player_source:      rl.Rectangle,
	player_dest:        rl.Rectangle,
	player_dir:         int,
	player_moving:      bool,
	player_up:          bool,
	player_down:        bool,
	player_left:        bool,
	player_right:       bool,
	player_frame:       int,
	player_frame_count: int,
	player_speed:       f32,
}

game := Game
game_entities := Entities

game_init :: proc() {
	rl.InitWindow(SCREEN_WIDTH, SCREEN_HEIGHT, "Animal crossing")
	rl.SetTargetFPS(60)
	game.running = true
	game.background_color = {147, 211, 196, 255}

	game.camera = rl.Camera2D {
		rl.Vector2{SCREEN_WIDTH, SCREEN_HEIGHT} / 2,
		rl.Vector2 {
			f32(game_entities.player_dest.x - (game_entities.player_dest.width / 2)),
			f32(game_entities.player_dest.y - (game_entities.player_dest.height / 2)),
		},
		0,
		1,
	}

	game_entities.grass_sprite = rl.LoadTexture("./assets/Tilesets/Grass.png")
	game_entities.player_sprite = rl.LoadTexture(
		"./assets/Characters/Basic Charakter Spritesheet.png",
	)
	game_entities.player_source = rl.Rectangle {
		0,
		0,
		f32(game_entities.player_sprite.width / 4),
		f32(game_entities.player_sprite.height / 4),
	}
	game_entities.player_dest = rl.Rectangle{200, 200, 100, 100}
	game_entities.player_speed = 3

}

game_update :: proc() {
	game.running = !rl.WindowShouldClose()


	game_entities.player_source.x = 0
	if game_entities.player_moving {
		if game_entities.player_up {
			game_entities.player_dest.y -= game_entities.player_speed
		}
		if game_entities.player_down {
			game_entities.player_dest.y += game_entities.player_speed
		}
		if game_entities.player_left {
			game_entities.player_dest.x -= game_entities.player_speed
		}
		if game_entities.player_right {
			game_entities.player_dest.x += game_entities.player_speed
		}

		if game_entities.player_frame_count % 8 == 1 {
			game_entities.player_frame += 1
		}
	} else if game_entities.player_frame_count % 45 == 1 {
		game_entities.player_frame += 1
	}

	game_entities.player_frame_count += 1
	if game_entities.player_frame > 3 {
		game_entities.player_frame = 0
	}
	if !game_entities.player_moving && game_entities.player_frame > 1 {
		game_entities.player_frame = 0
	}

	game_entities.player_source.x =
		game_entities.player_source.width * f32(game_entities.player_frame)
	game_entities.player_source.y =
		game_entities.player_source.height * f32(game_entities.player_dir)


	game.camera.target = rl.Vector2 {
		f32(game_entities.player_dest.x - (game_entities.player_dest.width / 2)),
		f32(game_entities.player_dest.y - (game_entities.player_dest.height / 2)),
	}

	game_entities.player_moving = false
	game_entities.player_up = false
	game_entities.player_down = false
	game_entities.player_left = false
	game_entities.player_right = false
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
	rl.BeginMode2D(game.camera)
	draw_scene()

	rl.EndMode2D()
	rl.EndDrawing()
}

game_input :: proc() {
	if rl.IsKeyDown(.W) {
		game_entities.player_moving = true
		game_entities.player_dir = 1
		game_entities.player_up = true
	}
	if rl.IsKeyDown(.S) {
		game_entities.player_moving = true
		game_entities.player_dir = 0
		game_entities.player_down = true
	}
	if rl.IsKeyDown(.A) {
		game_entities.player_moving = true
		game_entities.player_dir = 2
		game_entities.player_left = true
	}
	if rl.IsKeyDown(.D) {
		game_entities.player_moving = true
		game_entities.player_dir = 3
		game_entities.player_right = true

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
