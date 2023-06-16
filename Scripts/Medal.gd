extends Area2D

signal objetiu_assolit(player)

func _on_Area2D_body_entered(body:Node):
	print("AAAAAAAAAAAAA")
	if body.name == "Player":
		emit_signal("objetiu_assolit",body)
