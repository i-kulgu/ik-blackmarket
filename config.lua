Config = {
	Debug = false, -- Enable to add debug boxes and message.
	img = "lj-inventory/html/images/", -- Set this to your inventory
	MaxSlots = 41, -- Set this to your player inventory slot count, this is default "41"
	Measurement = "kg", -- Custom Weight measurement
	RandomLocation = true, -- Set to true if you want random location. False = create for each location a blackmarket
}

Config.Products = {
	["blackmarket"] = {
        [1] = { name = "weapon_pistol", price = 1850, amount = 1 },
		[2] = { name = "pistol_suppressor", price = 850, amount = 1 },
		[3] = { name = "pistol_ammo", price = 550, amount = 5 },
	},
}

Config.Locations = {
	["blackmarket"] = {
		["label"] = "Black Market",
		["model"] = {
			[1] = `mp_f_weed_01`,
			[2] = `MP_M_Weed_01`,
			[3] = `A_M_Y_MethHead_01`,
			[4] = `A_F_Y_RurMeth_01`,
			[5] = `A_M_M_RurMeth_01`,
			[6] = `MP_F_Meth_01`,
			[7] = `MP_M_Meth_01`,
		},
		["coords"] = {
			[1] = vector4(776.24, 4184.08, 41.8, 92.12),
			[2] = vector4(2482.51, 3722.28, 43.92, 39.98),
			[3] = vector4(462.67, -1789.16, 28.59, 317.53),
			[4] = vector4(-115.15, 6369.07, 31.52, 232.08),
			[5] = vector4(752.52, -3198.33, 6.07, 301.72)
			},
		["products"] = Config.Products["blackmarket"],
		["hideblip"] = true,
	},
}
