--  Custom Options Definition Table format

--  NOTES:
--  - using an enumerated table lets you specify the options order

--
--  These keywords must be lowercase for LuaParser to read them.
--
--  key:      the string used in the script.txt
--  name:     the displayed name
--  desc:     the description (could be used as a tooltip)
--  type:     the option type
--  def:      the default value
--  min:      minimum value for number options
--  max:      maximum value for number options
--  step:     quantization step, aligned to the def value
--  maxlen:   the maximum string length for string options
--  items:    array of item strings for list options
--  scope:    'all', 'player', 'team', 'allyteam'      <<< not supported yet >>>
--

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--
--  Example EngineOptions.lua 
--

local options = 
{
  
  {
    key    = 'StartingResources',
    name   = 'Starting Resources',
    desc   = 'Sets storage and amount of resources that players will start with',
    type   = 'section',
  },
  
  {
    key    = 'StartMetal',
    name   = 'Starting requisition',
    desc   = 'Determines amount of requisition and requisition capacity that each player will start with',
    type   = 'number',
    section= 'StartingResources',
    def    = 1000,
    min    = 100,
    max    = 10000,
    step   = 1,  -- quantization is aligned to the def value
                    -- (step <= 0) means that there is no quantization
  },
  {
    key    = 'StartEnergy',
    name   = 'Starting power',
    desc   = 'Determines amount of power and power storage that each player will start with',
    type   = 'number',
    section= 'StartingResources',
    def    = 1000,
    min    = 100,
    max    = 10000,
    step   = 1,  -- quantization is aligned to the def value
                    -- (step <= 0) means that there is no quantization
  },
  
  {
    key    = 'MaxUnits',
    name   = 'Maximum units',
    desc   = 'Determines the max number of units and buildings a player is allowed to own',
    type   = 'number',
    def    = 1000,
    min    = 1,
    max    = 10000,
    step   = 1,  -- quantization is aligned to the def value
                    -- (step <= 0) means that there is no quantization
  },

  {
    key    = 'GhostedBuildings',
    name   = 'Ghosted buildings',
    desc   = "Once an enemy building is spotted a 'ghost' will be visible at its location even after the loss of the line of sight",
    type   = 'bool',
    def    = true,
  },

  {
    key    = 'FixedAllies',
    name   = 'Fixed alliances',
    desc   = 'Disables the possibility to change allies in-game',
    type   = 'bool',
    def    = true,
  },

  {
    key    = 'LimitSpeed',
    name   = 'Speed Restriction',
    desc   = 'Limits the minimum and maximum game speed that the players will be allowed to set',
    type   = 'section',
  },
  
  
  {
    key    = 'MinSpeed',
    name   = 'Minimum game speed',
    desc   = 'Sets the minimum speed that the players will be allowed to set',
    type   = 'number',
    section= 'LimitSpeed',
    def    = 0.3,
    min    = 0.1,
    max    = 100,
    step   = 0.1,  -- quantization is aligned to the def value
                    -- (step <= 0) means that there is no quantization
  },
  {
    key    = 'MaxSpeed',
    name   = 'Maximum game speed',
    desc   = 'Sets the maximum speed that the players will be allowed to set',
    type   = 'number',
    section= 'LimitSpeed',
    def    = 3,
    min    = 0.1,
    max    = 100,
    step   = 0.1,  -- quantization is aligned to the def value
                    -- (step <= 0) means that there is no quantization
  },
  
  {
    key    = 'DisableMapDamage',
    name   = 'Disable map deformation',
    desc   = 'Prevents the map from being deformed by weapons',
    type   = 'bool',
    def    = false,
  },

}
return options
