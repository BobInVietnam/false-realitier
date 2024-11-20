class_name Frab extends CharacterBody2D

enum PlayerState {OK, PILL, NOK}
signal isHurt;

const SPEED = 100.0
const JUMP_VELOCITY = -250.0
const HURT_JUMP_VELOCITY = -80.0
const TERMINAL_VELOCITY = 400.0
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

var pstate: PlayerState = PlayerState.OK;

func set_p_state(state: int) -> void:
	if state == 0:
		pstate = PlayerState.OK
	else:
		pstate = PlayerState.PILL
		
func isPilled() -> bool:
	match pstate:
		PlayerState.PILL:
			return true;
	return false;

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		velocity.y = minf(TERMINAL_VELOCITY, velocity.y);
		
	if pstate != PlayerState.NOK:
		# Handle jump.
		if Input.is_action_just_pressed("jump") and is_on_floor():
			velocity.y = JUMP_VELOCITY

		# Get the input direction and handle the movement/deceleration.
		# As good practice, you should replace UI actions with custom gameplay actions.
		var direction := Input.get_axis("move_left", "move_right")
		set_animation(direction)
		if direction:
			velocity.x = direction * SPEED;
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED / 4);
		if Input.is_action_just_pressed("debug_player"):
			print(position)
	else:
		if is_on_floor:
			velocity.x = move_toward(velocity.x, 0, SPEED / 4)
	move_and_slide()
	
func set_animation(direction: float) -> void:
	if direction:
		match pstate:
			PlayerState.OK:
				animated_sprite_2d.animation = "run";
			PlayerState.PILL:
				animated_sprite_2d.animation = "run_real";
		if direction > 0:
			animated_sprite_2d.flip_h = false;
		else:
			animated_sprite_2d.flip_h = true;
	else:
		match pstate:
			PlayerState.OK:
				animated_sprite_2d.animation = "idle";
			PlayerState.PILL:
				animated_sprite_2d.animation = "idle_real";

func hurt() -> void:
	if pstate != PlayerState.NOK:
		pstate = PlayerState.NOK;
		velocity.y = HURT_JUMP_VELOCITY;
		animated_sprite_2d.animation = "trip_real";
		isHurt.emit();


func _on_area_2d_body_entered(body: Node2D) -> void:
	hurt();
