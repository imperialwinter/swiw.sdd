local skin = {
  info = {
    name    = "GProgressbarbright",
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

  backgroundColor = {1, 1, 1, 1},
}

skin.imagelistview = {
  imageFolder      = "folder.png",
  imageFolderUp    = "folder_up.png",

  --DrawControl = DrawBackground,

  colorBK          = {1,1,1,0.3},
  colorBK_selected = {1,0.7,0.1,0.8},

  colorFG          = {0, 0, 0, 0},
  colorFG_selected = {1,1,1,1},

  imageBK  = ":cl:node_selected_bw.png",
  imageFG  = ":cl:node_selected.png",
  tiles    = {9, 9, 9, 9},

  --tiles = {17,15,17,20},

  DrawItemBackground = DrawItemBkGnd,
}

skin.progressbar = {
  TileImageFG = ":cl:tech_progressbar_full.png",
  TileImageBK = ":cl:tech_progressbar_empty.png",
  tiles       = {10, 10, 10, 10},

  font = {
    shadow = true,
  },

  DrawControl = DrawProgressbar,
}

skin.control = skin.general

--//=============================================================================
--//

return skin

