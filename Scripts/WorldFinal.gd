extends Node2D

var _pers:Personatge
export (PackedScene) var Enemy
export (PackedScene) var Boss
var rng = RandomNumberGenerator.new()
var aux = 0
var finished=false
var startCompro = false
var boss

func _ready():
	var scr = get_node("/root/inici")
	_pers = scr._personatge
	_pers.set_name("Player")
	_pers.set_pos_start($StartPoint.position)
	_pers.changeZoom(1.5)
	add_child(_pers) 
	for i in range(1):
		yield(get_tree().create_timer(2.0), "timeout")
		print(i)
		generateEnemy()
		aux+=1
	generateBoss()
	startCompro = true
	

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
	var posX = 0
	var enem = Enemy.instance()
	if((aux%2)==0):
		posX=-270
		enem.scale.x=-1
		enem.changeMotion()
	else:
		posX = 625
	enem.global_position.x = posX
	enem.global_position.y = -130
	enem.changeFloorDetection()
	get_tree().call_group("World2","add_child",enem)
	print("aaa")
	pass

func generateBoss():
	print("a")
	boss = Boss.instance()
	boss.global_position.x=224
	boss.global_position.y=-231
	get_tree().call_group("World2","add_child",boss)
	pass
func _process(delta):
	if(self.get_child(8)==null && !finished && startCompro):
		finished=true
		yield(get_tree().create_timer(1.0), "timeout")
		get_tree().change_scene("res://Scenes/Win.tscn")
		
