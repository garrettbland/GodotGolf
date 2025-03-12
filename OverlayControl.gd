extends Control

@onready var HitBallButton = $HitBallButton
@onready var Score = $RichTextLabel2
@onready var ResetButton = $ResetButton
@onready var Camera = get_parent().get_node("Camera3D")
@onready var GolfBall = get_parent().get_node("GolfBall")
@onready var Ball2 = get_parent().get_node("Ball2")
# @onready var GolfBall = $"../GolfBall"

var currentScore = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	print("Ready...")
	#HitBallButton.connect("pressed", self.hitBall())
	HitBallButton.pressed.connect(hitBall)
	ResetButton.pressed.connect(resetScore)
	Score.append_text(str(currentScore))

func hitBall():
	print("Hit the golf ball")
	
	var SPEED = 30
	var LAUNCH_DEGREE = 50 # 0 degrees is flat
	var LAUNCH_RADIAN = (LAUNCH_DEGREE * PI) / 180 # Convert to radians (2 radians in a circle)
	var DIRECTION_DEGREE = -5; # Left and right
	var DIRECTION_RADIAN = (DIRECTION_DEGREE * PI) / 180

	# Break impulse into components
	var x = SPEED * cos(LAUNCH_RADIAN)
	var y = SPEED * sin(LAUNCH_RADIAN)
	var z = SPEED * sin(DIRECTION_RADIAN)
	
	var BACK_SPIN = 300 # higher number is more back spin
	var SIDE_SPIN = 0
	
	GolfBall.apply_impulse(Vector3(x, y, z), Vector3.ZERO) # launching the ball
	GolfBall.apply_torque(Vector3(0, SIDE_SPIN, BACK_SPIN)) # back spin and side spin
	
	var newScore = currentScore + 1
	Score.clear()
	Score.append_text(str(newScore))
	currentScore = newScore

func resetScore():
	print("Resetting...")
	currentScore = 0
	Score.clear()
	Score.append_text("0")
	
	GolfBall.freeze = true
	GolfBall.linear_velocity = Vector3.ZERO
	GolfBall.angular_velocity = Vector3.ZERO
	GolfBall.global_position = Vector3(0, 5, 0)
	GolfBall.freeze = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# Sets camera on every frame to follow the golf ball with an offset up and behind
	#print(delta)
	#Camera.global_position = lerp(Camera.global_position, GolfBall.global_position + Vector3(-7, 4, 0), 5 * delta)
	Camera.global_position = GolfBall.global_position + Vector3(-7, 4, 0)


func _on_golf_ball_body_entered(body):
	print("Touching ground...")
	print("Set linear damping...")
	GolfBall.linear_damp = 2.0 # Adjust this depending on type (or group?) of ground. So green rolls further than fairway for example


func _on_golf_ball_body_exited(body):
	print("In air probably")
	print("Remove damping...")
	GolfBall.linear_damp = 0.0


func _on_golf_ball_sleeping_state_changed():
	print("sleeping state changed...", GolfBall.is_sleeping())
