extends CanvasLayer

@onready var PortalsView = $PortalsView
@onready var PortalA = %PortalA
@onready var PortalB = %PortalB
@onready var PortalViewA = $PortalsView/PortalA
@onready var PortalViewB = $PortalsView/PortalB

@onready var DebugScreen = $DebugScreen
@onready var DebugResumeButton = %ResumeButton
@onready var DebugQuitButton = %QuitButton
@onready var DebugPAOnScreenCheck = %PAOnScreenCheck
@onready var DebugPBOnScreenCheck = %PBOnScreenCheck

func _ready():
	DebugScreen.visible = false
	
	# Auto connect texture and viewport
	var PortalAViewport = PortalA.get_node("SubViewport").get_path()
	var PortalBViewport = PortalB.get_node("SubViewport").get_path()
	
	PortalViewA.texture.viewport_path = PortalAViewport
	PortalViewB.texture.viewport_path = PortalBViewport

func _input(event):
	if event.is_action_pressed("escape"):
		DebugScreen.visible = Input.get_mouse_mode() * .5
		get_tree().paused = Input.get_mouse_mode() * .5
		Input.set_mouse_mode(int(!Input.get_mouse_mode()) * 2)

func _on_resume_button_pressed():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	DebugScreen.visible = false

func _on_quit_button_pressed():
	get_tree().quit()

func _on_pa_on_screen_check_toggled(toggled_on):
	PortalViewA.visible = toggled_on

func _on_pb_on_screen_check_toggled(toggled_on):
	PortalViewB.visible = toggled_on


