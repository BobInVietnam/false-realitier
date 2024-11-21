extends Area2D

@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

func _on_body_entered(body: Node2D) -> void:
	if body is Frab:
		body.save_checkpoint(position);
		set_deferred("monitoring", false);
		print("signal sent")
