local skin = {
  info = {
    name    = "Gsteelbar",
    version = "0.1",
    author  = "Smoth",
  }
}

--//=============================================================================
--//

skin.general = {
  --font        = "LuaUI/Fonts/gunplay.ttf",
  fontOutline = true,
  fontsize    = 13,
  textColor   = {1,1,1,1},

  --padding         = {5, 5, 5, 5}, --// padding: left, top, right, bottom
  backgroundColor = {0.1, 0.1, 0.1, 0.7},
}


skin.window = {
  TileImage = ":cl:tech_dragwindow.png",
  tiles = {62, 62, 62, 62}, --// tile widths: left,top,right,bottom
  padding = {3, 3, 3, 3},
  hitpadding = {4, 4, 4, 4},

  captionColor = {1, 1, 1, 0.45},

  boxes = {
    resize = {-15, -15, -5, -5},
    drag = {0, 0, "100%", -220},
  },

  NCHitTest = NCHitTestWithPadding,
  NCMouseDown = WindowNCMouseDown,
  NCMouseDownPostChildren = WindowNCMouseDownPostChildren,

  DrawControl = DrawWindow,
  DrawDragGrip = function() end,
  DrawResizeGrip = DrawResizeGrip,
}


skin.control = skin.general


--//=============================================================================
--//

return skin

