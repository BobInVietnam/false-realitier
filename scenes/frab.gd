class_name Frab extends CharacterBody2D

enum PlayerState {OK, PILL, NOK}
signal isHurt;
signal set_checkpoint(position: Vector2);

const SPEED = 100.0
const JUMP_VELOCITY = -250.0
const HURT_JUMP_VELOCITY = -80.0
const TERMINAL_VELOCITY = 400.0
const COYOTE_TIME = 0.08
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

var pstate: PlayerState = PlayerState.OK;
var off_platform_time = 0;

func set_p_state(state: int) -> void:
	if state == 0:
		pstate = PlayerState.OK
	else:
		pstate = PlayerState.PILL
		
func is_down() -> bool:
	if pstate == PlayerState.NOK:
		return true;
	return false;

func is_pilled() -> bool:
	if pstate == PlayerState.PILL:
		return true;
	return false;

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		velocity.y = minf(TERMINAL_VELOCITY, velocity.y);
		off_platform_time += delta
	else:
		off_platform_time = 0
		
	if pstate != PlayerState.NOK:
		# Handle jump.
		if Input.is_action_pressed("jump") and (is_on_floor() or off_platform_time < COYOTE_TIME):
			velocity.y = JUMP_VELOCITY
			off_platform_time += COYOTE_TIME;

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

func revive(checkpoint: Vector2, pilled: bool) -> void:
	position = checkpoint;
	if pilled:
		pstate = PlayerState.PILL;
	else:
		pstate = PlayerState.OK;
	
func save_checkpoint(position: Vector2) -> void:
	set_checkpoint.emit(position);

func _on_killzone_body_entered(body: Node2D) -> void:
	hurt();
