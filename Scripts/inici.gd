extends Node
# script global (Autoload)

const NUM_NIVELLS := 4

# variables globals-escena
const ESC_PERS:= preload("res://Scenes/Personaje.tscn")
const ESC_LEVEL1:= preload("res://Scenes/World.tscn")
const ESC_LEVEL2:= preload("res://Scenes/World2.tscn")
const ESC_LEVEL3:= preload("res://Scenes/World3.tscn")
const ESC_LEVELFINAL:= preload("res://Scenes/WorldFINAL.tscn")

# variables globals del joc 
var _nivells:Array # array de packed scenes corresponents als nivells
var _personatge:Personatge  # aquí mantenim el personatge
var _nivellActual:int 


# s'executarà a l'inici, només 1 cop. Creem instàncies del joc i les guardem en var. globals 
func _ready():
	_nivellActual = 1
	_nivells.append(ESC_LEVEL1)
	_nivells.append(ESC_LEVEL2)
	_nivells.append(ESC_LEVEL3)
	_nivells.append(ESC_LEVELFINAL)
	_personatge = ESC_PERS.instance()
	
func canvia_nivell():
	_nivellActual += 1
	if _nivellActual > NUM_NIVELLS: # esquema circular 
		get_tree().change_scene("res://Scenes/Win.tscn")
	elif get_tree().change_scene_to(_nivells[_nivellActual-1]): # Array comença per 0
		print("canvi exitós")
	else:
		print("no s'ha pogut canviar")
	
