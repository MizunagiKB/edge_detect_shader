extends WindowDialog


func plugin_open():
    self.popup_centered()


func request_preview(node: ModelMesh):
    node.mesh = null
    self.hide()


