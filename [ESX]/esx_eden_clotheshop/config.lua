Config = {}
Config.Locale = 'fa'

Config.Price = 5000

Config.DrawDistance = 101.0
Config.MarkerSize   = {x = 0.9, y = 0.9, z = 0.9}
Config.MarkerColor  = {r = 153, g = 51, b = 255}
Config.MarkerType   = 29

Config.Zones = {}

Config.Shops = {
  {x=72.25,    y=-1399.1, z=29.38},
  {x=-703.78,  y=-152.26,  z=37.42},
  {x=-167.86,  y=-298.97,  z=39.73},
  {x=428.69,   y=-800.11,  z=29.49},
  {x=-829.41,  y=-1073.71, z=11.33},
  {x=-1447.8, y=-242.46,  z=49.82},
  {x=11.63,    y=6514.22,  z=31.87},
  {x=123.64,   y=-219.44,  z=54.55},
  {x=1696.29,  y=4829.31,  z=42.06},
  {x=618.09,   y=2759.62,  z=42.08},
  {x=1190.55,  y=2713.44,  z=38.22},
  {x=-1193.42, y=-772.26,  z=17.32},
  {x=-3172.49, y=1048.13,  z=20.86},
  {x=-1108.44, y=2708.92,  z=19.10},
  {x=4489.2, y=-4452.53,  z=4.37},
}

for i=1, #Config.Shops, 1 do

	Config.Zones['Shop_' .. i] = {
	 	Pos   = Config.Shops[i],
	 	Size  = Config.MarkerSize,
	 	Color = Config.MarkerColor,
	 	Type  = Config.MarkerType
  }

end
