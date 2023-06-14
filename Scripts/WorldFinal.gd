extends Node2D

var _pers:Personatge
export (PackedScene) var Enemy
export (PackedScene) var Boss
var rng = RandomNumberGenerator.new()
func _ready():
	var scr = get_node("/root/inici")
	_pers = scr._personatge
	_pers.set_name("Player")
	_pers.set_pos_start($StartPoint.position)
	_pers.changeZoom(2)
	add_child(_pers) 
	for i in range(1):
		yield(get_tree().create_timer(2.0), "timeout")
		print(i)
		generateEnemy()
	generateBoss()
	

func _on_GOAL_objetiu_assolit(player):
	_pers.suma_vides(1)
	_pers.restaurar_energia()
	remove_child(_pers) 
	get_node("/root/inici").canvia_nivell()


func _on_Area2D_objetiu_assolit(player):
	_pers.suma_vides(2)
	_pers.restaurar_energia()
	remove_child(_pers) 
	get_node("/root/inici").canvia_nivell()
	
func generateEnemy():
	var randomX = rng.randf_range(60, 500)
	var enem = Enemy.instance()
	enem.global_position.x = randomX
	enem.global_position.y = -270
	enem.changeFloorDetection()
	get_tree().call_group("World2","add_child",enem)
	pass

func generateBoss():
	#265 -230
	var boss = Boss.instance()
	boss.global_position.x=265
	boss.global_position.y=-230
	get_tree().call_group("World2","add_child",boss)
	pass
