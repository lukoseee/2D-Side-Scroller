extends Node


# Called when the node enters the scene tree for the first time.
var paul_start_pos = Vector2i(80,215)
var camera_start_pos = Vector2i(289,162)
var start_speed : float  = 2.5
var camSpeed = start_speed
var max_speed = 7
var tilemap
var screen_size
var score = 0
var speed_modifier = 10000
var bullet = preload("res://bullet.tscn")
var enemy1 = preload("res://enemies/enemy1.tscn")
var enemy = 1
var ins_enemies = []
var deduct = []
func _ready():
	#print(ins_enemies)
	screen_size = get_window().size
	start_game()
	#spawn_enemy(336,208,enemy1)
	#spawn_enemy(384,208,enemy1)
	#var ins = enemy1.instantiate()
	#self.add_child(ins)
	#ins.position = Vector2i(500,205)

func start_game():
	$CharacterBody2D.position = paul_start_pos
	$Camera2D.position = camera_start_pos
	

func spawn_bullet(x,y):
	var ins = bullet.instantiate()
	var offset = 15
	self.add_child(ins)
	ins.position = Vector2i(x+offset,y-offset)


func spawn_enemy(x,y,enemy_type):
	var ins = enemy_type.instantiate()
	self.add_child(ins)
	ins.position = Vector2i(x,y)
	return ins
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#print(deduct)
	camSpeed = start_speed +  score / speed_modifier
	if camSpeed > max_speed:
		camSpeed = max_speed
	
	#if not deduct.is_empty():
		#for i in range(0,1000):
			#camSpeed -= 0.1
		#deduct.remove_at(0)
		#
		
	print(camSpeed)
	$Camera2D.position.x += camSpeed
	$CharacterBody2D.position.x += camSpeed
	score += camSpeed
	#print(score)
	
