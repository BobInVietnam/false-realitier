extends Node2D

@onready var collision_shape_2d: CollisionShape2D = $Area2D/CollisionShape2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var timer: Timer = $Timer

var velocity_vector = Vector2(160, -160);
const BOBBING_DISTANCE = 10;

var fly_away = false;
var enter_side: int = 1;

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Frab:
		fly_away = true;
		collision_shape_2d.disabled = true;
		animated_sprite_2d.play("fly")
		enter_side = sign(position.x - body.position.x);
		if enter_side > 0:
			animated_sprite_2d.flip_h = true;
		timer.start();
	
func _physics_process(delta: float) -> void:
	if fly_away:
		position.x += delta * velocity_vector.x * enter_side;
		position.y += delta * velocity_vector.y;
		
func _on_timer_timeout() -> void:
	queue_free();
