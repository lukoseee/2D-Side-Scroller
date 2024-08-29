extends CharacterBody2D
@export var move_speed : float = 700.0
@export var move_dir : Vector2 
@onready var animated_sprite_2d = $AnimatedSprite2D
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var start_pos : Vector2
var target_pos : Vector2

# Called when the node enters the scene tree for the first time.
func _ready():
	start_pos = global_position
	target_pos = start_pos + move_dir


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if (move_dir.x > 0 || move_dir.x < 0 ):
		animated_sprite_2d.animation = "walking"
	else:
		animated_sprite_2d.animation = "default"
	
	
	
	global_position = global_position.move_toward(target_pos , move_speed * delta)
	
	if global_position == target_pos:
		animated_sprite_2d.flip_h = true
		if global_position == start_pos:
			animated_sprite_2d.flip_h = false
			target_pos = start_pos + move_dir
		else:
			target_pos = start_pos

func _on_area_2d_body_entered(body):
	if (body.name == "CharacterBody2D"):
		get_tree().reload_current_scene()
