extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -900.0

@export var tilemap: TileMapLayer

var broken_tiles = {}

func _physics_process(delta: float) -> void:

	# Gravity
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Jump
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Movement
	var direction := Input.get_axis("left", "right")

	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

	check_falling_platform()


func check_falling_platform():

	if tilemap == null:
		return

	if !is_on_floor():
		return

	# position under player
	var check_pos = global_position + Vector2(0, 16)

	# convert to tile position
	var tile_pos = tilemap.local_to_map(check_pos)

	# prevent re-trigger
	if broken_tiles.has(tile_pos):
		return

	# get tile data (layer 0)
	var tile_data = tilemap.get_cell_tile_data(0, tile_pos)

	if tile_data == null:
		return

	# check if it's breakable
	if tile_data.get_custom_data("breakable") == true:

		broken_tiles[tile_pos] = true
		collapse_tile(tile_pos)


func collapse_tile(tile_pos):

	await get_tree().create_timer(0.5).timeout

	tilemap.erase_cell(0, tile_pos)
