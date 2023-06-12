extends Node2D

func _ready():
	$AnimatedSprite.play("End")

func _process(delta):
	if Input.is_action_just_pressed("ui_accept"):
		get_tree().quit()
