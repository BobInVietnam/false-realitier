extends CanvasLayer

@onready var pill_label: Label = $PillButton/PillLabel
@onready var help_label: Label = $HelpButton/HelpLabel
@onready var pill_button: TextureButton = $PillButton
@onready var dialog_window: PanelContainer = $DialogWindow
@onready var button_click: AudioStreamPlayer = $"../Sound/ButtonClick"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pill_label.visible = false;
	help_label.visible = false;
	dialog_window.visible = false;

func _process(delta: float) -> void:
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and dialog_window.visible == true:
		dialog_window.visible = false;

func _on_pill_button_pressed() -> void:
	button_click.play();

func _on_pill_button_mouse_entered() -> void:
	pill_label.visible = true;
	pill_button.size.y *= 2;
	pill_button.position.y -= 100;
	
func _on_pill_button_mouse_exited() -> void:
	pill_label.visible = false;
	pill_button.size.y /= 2;
	pill_button.position.y += 100;

func _on_game_pill_number_update(pill_number: int) -> void:
	pill_label.text = "Are you sure?\nCandy remaining: " + str(pill_number);

func _on_help_button_mouse_entered() -> void:
	help_label.visible = true;

func _on_help_button_mouse_exited() -> void:
	help_label.visible = false;

func _on_help_button_pressed() -> void:
	button_click.play();
	dialog_window.visible = true;
