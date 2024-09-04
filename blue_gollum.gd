extends CharacterBody2D


var shielded 
var is_killed = false

@onready var character_body_2d = $"../CharacterBody2D"
@onready var camera_2d = $"../Camera2D"
@onready var main = $".."


@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var shape_box = $ShapeBox
@onready var area_2d = $Area2D
@onready var hit_box = $Area2D/HitBox
@onready var cast_down_left = $Cast_Down_Left
@onready var cast_right = $Cast_Right
@onready var cast_down_right = $Cast_Down_Right
@onready var cast_left = $Cast_Left


var speed = 50 
var start_pos : Vector2
var target_pos : Vector2
# Called when the node enters the scene tree for the first time.
var direction = 1
var moving
var me = preload("res://enemies/enemy1.tscn")

func _ready():
	main.ins_enemies.append(area_2d)
	
	animated_sprite_2d.material = animated_sprite_2d.material.duplicate()
	
	var randomiser = randi_range(1,2)
	var randomiser2 = randi_range(1,2)
	#randomising shield and if moving
	if randomiser == 1:
		shielded = false
		animated_sprite_2d.material.set_shader_parameter("line_thickness" , 0)
	else:
		shielded = true
		animated_sprite_2d.material.set_shader_parameter("line_thickness" , 1)
		
	if randomiser2 == 1:
		moving = true
	else:
		moving = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	var screen_size = get_window().size
	var half_offset = screen_size.x / 4
	var character_width = hit_box.shape.radius * 2
	
	#if camera_2d.position.x - half_offset - character_width > self.position.x:
		#queue_free()
	
	if moving and not is_killed:
		walking(delta)
	else:
		direction = 0
	
	
func walking(delta):
	#checking ray cast collisions 
	#checks if not null first then checks if its the main player
	
	if not cast_down_left.is_colliding() or (cast_left.get_collider() != null and cast_left.get_collider() != character_body_2d and not cast_left.get_collider() in main.ins_enemies ): 
		direction = 1
		animated_sprite_2d.flip_h = false
		
	elif not cast_down_right.is_colliding() or (cast_right.get_collider() != null and not cast_right.get_collider() in main.ins_enemies):
		direction = -1
		animated_sprite_2d.flip_h = true
		
	
		
	var movement = direction * delta * speed 
	
	position.x += movement
	
	if movement != 0:
		animated_sprite_2d.play("run")
	
	
func _on_area_2d_body_entered(body):
	
	if ( (body.name == "Bullet" and shielded == false) or ( body.name == "CharacterBody2D" and character_body_2d.animation_tree["parameters/playback"].get_current_node() == "attack")):
		animated_sprite_2d.play("death")
		is_killed = true
		ScoreSingleton.add_score()
		shape_box.set_deferred("disabled",true)
		hit_box.set_deferred("disabled",true)
		
	elif (body.name == "CharacterBody2D"):
		if not is_killed:
			main.game_over()
		
	
func despawn():
	queue_free()
