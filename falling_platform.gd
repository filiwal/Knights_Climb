extends Node2D

var has_fallen := false

@onready var collision := $StaticBody2D/"standing platform"
@onready var sprite := $Sprite2D

var start_position : Vector2

func _ready() -> void:
	start_position = position


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D and !has_fallen:
		has_fallen = true
		
		await get_tree().create_timer(1.0).timeout
		
		collision.disabled = true
		
		var tween := create_tween()
		
		tween.tween_property(
			self,
			"position:y",
			position.y + 300,
			1.5
		)
		
		tween.parallel().tween_property(
			sprite,
			"modulate:a",
			0.0,
			1.5
		)
		
		await tween.finished
		
		await get_tree().create_timer(10.0).timeout
		
		position = start_position
		sprite.modulate.a = 1.0
		collision.disabled = false
		
		has_fallen = false
