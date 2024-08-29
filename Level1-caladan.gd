extends Node


# Called when the node enters the scene tree for the first time.
var paul_start_pos = Vector2i(80,225)
var camera_start_pos = Vector2i(289,164)


var start_speed : float  = 2.5
var camSpeed = start_speed
var max_speed = 6
var score = 0  
var speed_modifier = 10000


var screen_size
var bullet = preload("res://bullet.tscn")
var enemy1 = preload("res://enemies/enemy1.tscn")
var enemy = 1
var ins_enemies = []
var game_running
var player_dead 

func _ready():
	#print(ins_enemies)
	screen_size = get_window().size
	start_game()
	
	#spawn_enemy(384,208,enemy1)
	#var ins = enemy1.instantiate()
	#self.add_child(ins)
	#ins.position = Vector2i(500,205)
	
	
	
func start_game():
	#restart score and bool variables
	
	game_running = false
	player_dead = false
	$CanvasLayer.get_node("Intro").show()
	$CanvasLayer.get_node("Node2D").get_node("Game Over").hide()
	$CharacterBody2D.position = paul_start_pos
	$Camera2D.position = camera_start_pos
	start_speed = 2.5
	
	ins_enemies.clear()
	GameSpeed.reset()
	

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
	$CanvasLayer.get_node("Node2D").get_node("Game Over").show()
	$CanvasLayer/Node2D/AnimationPlayer.play("fadein")
	
	#stops game running - player speed and cameramovement
	game_running = false
	
	player_dead = true
	
	if ScoreSingleton.score > ScoreSingleton.high_score:
		ScoreSingleton.update()
		$CanvasLayer.get_node("HighScore").text = "High Score: " +str(ScoreSingleton.high_score)
	
	ScoreSingleton.reset()
	#resets score and camspeed as the camspeed is previous for the first few frames
	GameSpeed.reset()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#print(deduct)
	if game_running:
		
		GameSpeed.calculate_speed()
		GameSpeed.check_max()
		#using singletons to store score and high score and gamespeed  across scenes 
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
		$TileMap.clear()
		$TileMap.reset()
		start_game()
		
		
		
	
