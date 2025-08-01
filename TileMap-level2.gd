extends TileMap

@onready var camera_2d = $"../Camera2D"
const tile_size = 8
@onready var node = $".."
@onready var character_body_2d = $"../CharacterBody2D"
var last_tile = Vector2i(0,26)
var starting_pos = Vector2i(4,26)
@onready var main = $".."
var gap_difficulty = 0.73
var pattern_type

var enemy1 = preload("res://enemies/enemy1.tscn")
var enemy2 = preload("res://enemies/enemy2.tscn")
var enemy3 = preload("res://enemies/enemy3.tscn")
var enemy4 = preload("res://enemies/enemy4.tscn")
var enemy5 = preload("res://enemies/enemy5.tscn")
var flag = preload("res://transition_flag.tscn")
var building1 = preload("res://obstacle scenes/building1tscn.tscn")
var building2 = preload("res://obstacle scenes/building2.tscn")
var building3 = preload("res://obstacle scenes/building3.tscn")
var building4 = preload("res://obstacle scenes/building4.tscn")
var building5 = preload("res://obstacle scenes/building5.tscn")
var rocket = preload("res://obstacle scenes/rocket.tscn")
var platform1 = tile_set.get_pattern(11)
var slide_pattern1 = tile_set.get_pattern(12)
var slide_pattern2 = tile_set.get_pattern(13)
var slide_pattern3 = tile_set.get_pattern(14)
var slide_pattern4 = tile_set.get_pattern(15)
var slide_pattern5 = tile_set.get_pattern(16)
var slide_pattern6 = tile_set.get_pattern(17)
var slide_pattern7 = tile_set.get_pattern(18)
var slide_pattern8 = tile_set.get_pattern(19)
var slide_obstables = [slide_pattern1,slide_pattern2,slide_pattern3,slide_pattern4,slide_pattern5,slide_pattern6,slide_pattern7,slide_pattern8]
var obstacles = [building1,building2,building3,building4,building5,rocket]
var obs_array = []
var enemies_array = []
var tile_edge_limit = 8 
var og_game
var transitioned
#var slide_pattern_size = slide_pattern.get_size()

func slide_obs():
	var obs_type = slide_obstables.pick_random()
	var slide_pattern_size = obs_type.get_size()
	var pattern_size = pattern_type.get_size()
	var obs_width = slide_pattern_size.x
	var enemy1in = enemy1.instantiate()
	var enemy_width = enemy1in.get_node("Area2D").get_node("HitBox").shape.radius * 2 
	
	
	#boundaries on where obstacles can potentially be placed on specific pattern
	var lower_boundary = tile_edge_limit
	var upper_boundary = (pattern_size.x - tile_edge_limit ) - (obs_width)
	
	#randomise location to place obstacles
	var offset = randf_range(lower_boundary , upper_boundary)
	
	var x = last_tile.x + offset
	var y = (last_tile.y - slide_pattern_size.y) - (character_body_2d.get_node("Sliding").shape.height / tile_size)
	
	
	##ranges for where enemy can be placed
	var enemy_boundary1 = tile_edge_limit
	#8 is wiggle room 
	var enemy_boundary2 = offset - (enemy_width/tile_size) - 8
	var enemy
	var spawned = false
	var final_offset
	
	if enemy_boundary2 > enemy_boundary1:
		
		final_offset = randi_range(enemy_boundary1, enemy_boundary2)
		var x2 = ((last_tile.x + final_offset) * tile_size) 
		var y2 = last_tile.y * tile_size
		enemy = main.spawn_enemy(x2,y2,enemy5)
		enemies_array.append(enemy)
		spawned = true
	
	if not spawned or not enemy.moving:
		set_pattern(0,Vector2i(x,y),obs_type)
	
	

func generate_obs():
	var obs_type = obstacles.pick_random()
	
	var obs = obs_type.instantiate()
	
	
	var obs_width = obs.get_node("Sprite2D").texture.get_width()
	var enemy1in = enemy1.instantiate()
	
	var enemy_width = enemy1in.get_node("Area2D").get_node("HitBox").shape.radius * 2 
	var pattern_size = pattern_type.get_size()
	
	#boundaries on where obstacles can potentially be placed on specific pattern
	var lower_boundary = tile_edge_limit
	var upper_boundary = (pattern_size.x - tile_edge_limit ) - (obs_width / 8)
	
	#randomise location to place obstacles
	var offset = randf_range(lower_boundary , upper_boundary)
	var offset2 = randf_range(lower_boundary, upper_boundary)
	var x = (last_tile.x + offset) * 16
	var y = last_tile.y * 16
	
	##ranges for where enemy can be placed
	var enemy_boundary1 = tile_edge_limit
	#8 is wiggle room 
	var enemy_boundary2 = offset - (enemy_width/tile_size) - 8
	var enemy
	var spawned = false
	var final_offset
	
	if enemy_boundary2 > enemy_boundary1:
		
		final_offset = randi_range(enemy_boundary1, enemy_boundary2)
		var x2 = ((last_tile.x + final_offset) * tile_size) 
		var y2 = last_tile.y * tile_size
		enemy = main.spawn_enemy(x2,y2,enemy5)
		enemies_array.append(enemy)
		#print(enemies_array)
		spawned = true
	
	if not spawned or not enemy.moving:
		#print(obs_array)
		add_child(obs)
		obs.position = Vector2i(x,y)
		obs_array.append(obs)
		
	

# Called when the node enters the scene tree for the first time.
func place_obs(x,y ,obs_type):
	var obs = obs_type.instantiate()
	add_child(obs)
	
	obs.position = Vector2i(x,y)


func _ready():
	
	og_game = true
	print("ready")
	generate_tiles()
	transitioned = false
	
	#print(obs_array)
	#print(enemies_array)
	#generate_obs()
	#slide_obs()
	##test coords
	
	var pattern_height = 5
	var test_y = (starting_pos.y) * 16
	var test_x = 62 * 16
	
	#place_obs(250 * 2,208 * 2,tree6)
	
	#place_obs(test_x-500,test_y,stone2)
	
	#node.spawn_enemy(336,208,enemy1)
	#main.spawn_enemy(test_x,test_y,enemy1)
	
	
func reset():
	og_game = false
	last_tile = Vector2i(0,26)
	starting_pos = Vector2i(4,26)

	
	if not enemies_array.is_empty():
		for enemy in enemies_array:
			enemy.queue_free()
			
	if not obs_array.is_empty():
		for obs in obs_array:
			obs.queue_free()
		
	enemies_array.clear()
	obs_array.clear()
	
	generate_tiles()
	
func generate_tiles():
	#find upper and lower limit to where tiles can spawn
	var screen_size = camera_2d.position
	var screen_limit_min = screen_size.y - (0.5 * screen_size.y)
	var screen_limit_max = screen_size.y + (0.5 * screen_size.y)
	
	#calculate max gap between tiles
	var t_air = -2 * character_body_2d.JUMP_VELOCITY / character_body_2d.gravity
	var max_gap = ((GameSpeed.camSpeed * 100) - (GameSpeed.camSpeed * 100 * 0.2)) * t_air
	#covert to tile format
	var max_tile_gap = max_gap / tile_size
	
	var min_gap = 6
	
	# Ensure get_pattern method exists and returns a valid pattern
	pattern_type = platform1
	var pattern_size = pattern_type.get_size()
	
	if pattern_type == null:
		print("get_pattern(1) returned null")
		return
	
	#initial placement
	if last_tile.x == 0 :
		set_pattern(0, starting_pos, pattern_type)
		#flag sprite
		if og_game:
			var checkpoint_sprite = Sprite2D.new()
			
			#child of tilemap
			add_child(checkpoint_sprite)
		
			var texture_path = "res://Checkpoints/Checkpoint/Checkpoint (No Flag).png"
			var texture = load(texture_path)
			if texture == null:
				print("Failed to load texture at path:", texture_path)
				return

			checkpoint_sprite.texture = texture
			
			#coords doubled as its child of tilemap so its normal coords * 2
			checkpoint_sprite.position = Vector2i(1032,385)# Test coordinates
	#rest of patterns
	else: 
		var placement_tile = Vector2i(last_tile.x , last_tile.y)
		set_pattern(0, placement_tile, pattern_type)
	
	#randomise gaps and height change
	var random_gap = randf_range(min_gap, max_tile_gap * gap_difficulty)
	var random_height_change = randf_range(-3.5, 4 ) 
	
	#update last tile position
	last_tile.x += pattern_size.x + random_gap
	
	#print("last tile: " + str(last_tile.y) + " Height Change: " + str(random_height_change) )
	
	#check if changes are within screen bounds
	if ( (last_tile.y + random_height_change) * tile_size) > screen_limit_max:
		#print("yes")
		last_tile.y -= random_height_change
	elif ( (last_tile.y + random_height_change) * tile_size) < screen_limit_min:
		#print("no")
		last_tile.y -= random_height_change
	else:
		last_tile.y += random_height_change
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	var screen_size = get_window().size
	var pattern_size = pattern_type.get_size()
	var camera = camera_2d.position.x + screen_size.x
	#print(str(camera) + " " + str(last_tile.x * tile_size) + " " + str(last_tile.y * tile_size))
	
	var randomiser = randi_range(1,2)
	
	if camera > (last_tile.x * tile_size):
		generate_tiles()
		if randomiser == 1:
			generate_obs()
		else:
			slide_obs()
	#using singletons to store score and high score across scenes 
	if ScoreSingleton.score % 7 == 0 and ScoreSingleton.score != 0 and not transitioned :
		print("spawned")
		var ins = flag.instantiate()
		get_parent().add_child(ins)
		#ins.position = Vector2i( (last_tile.x + pattern_size.x - 2) * tile_size,last_tile.y * tile_size)
		obs_array.append(ins)
		transitioned = true
		
	if ScoreSingleton.score % 7 != 0:
		transitioned = false


func _on_animation_player_animation_finished(anim_name):
	#transition after fade in anim
	if anim_name == "fade_out":
		get_tree().change_scene_to_file("res://level2.tscn")
