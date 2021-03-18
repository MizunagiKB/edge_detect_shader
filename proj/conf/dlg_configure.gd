extends ConfirmationDialog


func _ready():
    self.connect("confirmed", self, "_on_confirmed")


func _on_confirmed():
    $container_configure.save()

