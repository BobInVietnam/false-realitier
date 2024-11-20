extends Area2D

signal hit

func _on_body_entered(body: Node2D) -> void:
	if body is Frab:
		body.hurt();
		print("Hit spike")
	
