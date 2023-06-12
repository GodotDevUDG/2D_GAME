extends Area2D

func _on_Energy_body_entered(body):
	if body.name == "Player":
		body.sumar_energia()
		queue_free()
