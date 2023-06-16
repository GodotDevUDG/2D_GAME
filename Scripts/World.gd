extends Node2D

var _pers:Personatge

func _ready():
	var scr = get_node("/root/inici")
	_pers = scr._personatge
	_pers.set_name("Player")
	_pers.set_pos_start($StartPoint.position)
	add_child(_pers) 

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


func _on_Lava_body_entered(body):
	if body.name == "Player":
		body.suma_vides(-1)
