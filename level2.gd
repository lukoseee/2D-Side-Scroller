extends Node


# Called when the node enters the scene tree for the first time.
var paul_start_pos = Vector2i(80,225)
var camera_start_pos = Vector2i(289,164)
var screen_size
var bullet = preload("res://bullet.tscn")
var enemy1 = preload("res://enemies/enemy1.tscn")
var enemy = 1
var ins_enemies = []
var game_running
var player_dead 
@onready var tile_map = $TileMap

func _ready():
	print("ready")
	screen_size = get_window().size
	
	game_running = true
	player_dead = false
	
	$CanvasLayer.get_node("Node2D").get_node("Game Over").hide()
	$CharacterBody2D.position = paul_start_pos
	$Camera2D.position = camera_start_pos
	
	ins_enemies.clear()
	
	
	
	#spawn_enemy(384,208,enemy1)
	#var ins = enemy1.instantiate()
	#self.add_child(ins)
	#ins.position = Vector2i(500,205)
	

	
	

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

func despawn_enemy(enemy):
	remove_child(enemy)

func game_over():
	print("dead")
	$CanvasLayer.get_node("Node2D").get_node("Game Over").show()
	$CanvasLayer/Node2D/AnimationPlayer.play("fadein")
	#stops game running - player speed and cameramovement
	game_running = false
	
	player_dead = true
	
	if ScoreSingleton.score > ScoreSingleton.high_score:
		ScoreSingleton.update()
		$CanvasLayer.get_node("HighScore").text = "High Score: " +str(ScoreSingleton.high_score)
	
	ScoreSingleton.reset()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#print(deduct)
	if game_running:
		
		
		GameSpeed.calculate_speed()
		GameSpeed.check_max()
		
		#print(camSpeed)
		$Camera2D.position.x += GameSpeed.camSpeed
		$CharacterBody2D.position.x += GameSpeed.camSpeed
		GameSpeed.update_score()
		$CanvasLayer.get_node("Score").text = "Score: " +str(ScoreSingleton.score)
		$CanvasLayer.get_node("HighScore").text = "High Score: " +str(ScoreSingleton.high_score)
	else:
		if Input.is_action_pressed("ui_accept") and not player_dead:
			game_running = true
			
			$CanvasLayer.get_node("Intro").hide()
			
	
	if player_dead and Input.is_action_just_pressed("ui_accept"):
		get_tree().change_scene_to_file("res://Level1-caladan.tscn")
		
		
