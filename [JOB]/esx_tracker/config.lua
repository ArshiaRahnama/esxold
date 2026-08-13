Config = {}

Config.selfBlip = true -- use classic arrow or job specified blip?
Config.useRflxMulti = false -- server specific init
Config.useBaseEvents = false -- F for optimisation
Config.prints = false -- server side prints (on/off duty)

-- looks
Config.font = {
    useCustom = false, -- use custom font? Has to be specified below, also can be buggy with player tags
    name = 'Russo One', -- > this being inserted into <font face='nameComesHere'> eg. (<font face='Russo One'>) --> Your font has to be streamed and initialized on ur server
}
Config.notifications = {
    enable = true,
    useMythic = true,
    onDutyText = 'OnDuty', -- pretty straight foward
    offDutyText = 'OffDuty', -- pretty straight foward
}
Config.blipGroup = {
    renameGroup = false,
    groupName = '~b~Other units'
}

-- blips
Config.bigmapTags = false -- Playername tags when bigmap enabled?
Config.blipCone = true -- use that wierd FOV indicators thing?

Config.useCharacterName = true -- use IC name or OOC name, chose your warrior
Config.usePrefix = false
Config.namePrefix = { 
}

Config.emergencyJobs = {
    ['police'] = {
        ignoreDuty = true,
        blip = {
            sprite = 60,
            color = 29,
            flashColors = {
                59,
                29,
            }
        },
        vehBlip = {
            ['default'] = {
                sprite = 56,
                color = 29,
            },
        },

        canSee = {
            ['police'] = true,
            ['ambulance'] = true,
            ['sheriff'] = true,
            ['mt'] = true,
            ['mechanic'] = true,
            ['taxi'] = true,
            ['weazel'] = true,
        },
    },
    ['sheriff'] = {
        ignoreDuty = true,
        blip = {
            sprite = 58,
            color = 28,
            flashColors = {
                59,
                28,
            }
        },
        vehBlip = {
            ['default'] = {
                sprite = 56,
                color = 28,
            },
        },
        canSee = {
            ['police'] = true,
            ['ambulance'] = true,
            ['sheriff'] = true,
            ['mt'] = true,
            ['mechanic'] = true,
            ['taxi'] = true,
            ['weazel'] = true,
        },
    },
    ['fbi'] = {
        ignoreDuty = true,
        blip = {
            sprite = 484,
            color = 40,
            flashColors = {
                59,
                40,
            }
        },
        vehBlip = {
            ['default'] = {
                sprite = 56,
                color = 40,
            },
        },
        canSee = {
            ['police'] = true,
            ['ambulance'] = true,
            ['sheriff'] = true,
            ['fbi'] = true,
            ['taxi'] = true,
            ['mechaic'] = true,
            ['weazel'] = true,
            ['mt'] = true,
        },
    },
    ['mt'] = {
        ignoreDuty = true,
        blip = {
            sprite = 480,
            color = 27,
            flashColors = {
                59,
                27,
            }
        },
        vehBlip = {
            ['default'] = {
                sprite = 225,
                color = 27,
            },
        },
        canSee = {
            ['mt'] = true,
            ['ambulance'] = true,
            ['police'] = true,
            ['sheriff'] = true,
            ['mechanic'] = true,
            ['taxi'] = true,
            ['weazel'] = true,
        },
    },
    ['ambulance'] = {
        ignoreDuty = true,
        blip = {
            sprite = 1,
            color = 0,
            flashColors = {
                0,
                59,
            }
        },
        vehBlip = {
            ['default'] = {
                sprite = 225,
                color = 0,
            },
        },
        canSee = {
            ['police'] = true,
            ['ambulance'] = true,
            ['sheriff'] = true,
            ['mt'] = true,
            ['mechanic'] = true,
            ['taxi'] = true,
            ['weazel'] = true,
        }
    },
    ['taxi'] = {
        ignoreDuty = true,
        blip = {
            sprite = 198,
            color = 46,
            flashColors = {
                46,
                46,
            }
        },
        vehBlip = {
            ['default'] = {
                sprite = 198,
                color = 46,
            },
        },
        canSee = {
            ['taxi'] = true,
        }
    },
    ['mechanic'] = {
        ignoreDuty = true,
        blip = {
            sprite = 402,
            color = 56,
            flashColors = {
                56,
                56,
            }
        },
        vehBlip = {
            ['default'] = {
                sprite = 225,
                color = 56,
            },
        },
        canSee = {
            ['mechanic'] = true,
        }
    },
    ['weazel'] = {
        ignoreDuty = true,
        blip = {
            sprite = 402,
            color = 31,
            flashColors = {
                31,
                31,
            }
        },
        vehBlip = {
            ['default'] = {
                sprite = 225,
                color = 31,
            },
        },
        canSee = {
            ['weazel'] = true,
        }
    },
}

-- Config.emergencyJobs = {
--     ['police'] = {
--         ignoreDuty = true,
--         blip = {
--             sprite = 60,
--             color = 29,
--             flashColors = {
--                 59,
--                 29,
--             }
--         },
--         vehBlip = {
--             ['default'] = {
--                 sprite = 56,
--                 color = 29,
--             },
--         },

--         canSee = {
--             ['police'] = true,
--             ['ambulance'] = true,
--             ['sheriff'] = true,
--             ['mt'] = true,
--         },
--     },
--     ['sheriff'] = {
--         ignoreDuty = true,
--         blip = {
--             sprite = 58,
--             color = 28,
--             flashColors = {
--                 59,
--                 28,
--             }
--         },
--         vehBlip = {
--             ['default'] = {
--                 sprite = 56,
--                 color = 28,
--             },
--         },
--         canSee = {
--             ['police'] = true,
--             ['ambulance'] = true,
--             ['sheriff'] = true,
--             ['mt'] = true,
--         },
--     },
--     ['fbi'] = {
--         ignoreDuty = true,
--         blip = {
--             sprite = 484,
--             color = 40,
--             flashColors = {
--                 59,
--                 40,
--             }
--         },
--         vehBlip = {
--             ['default'] = {
--                 sprite = 56,
--                 color = 40,
--             },
--         },
--         canSee = {
--             ['police'] = true,
--             ['ambulance'] = true,
--             ['sheriff'] = true,
--             ['fbi'] = true,
--             ['taxi'] = true,
--             ['mechaic'] = true,
--             ['weazel'] = true,
--             ['mt'] = true,
--         },
--     },
--     ['mt'] = {
--         ignoreDuty = true,
--         blip = {
--             sprite = 480,
--             color = 27,
--             flashColors = {
--                 59,
--                 27,
--             }
--         },
--         vehBlip = {
--             ['default'] = {
--                 sprite = 225,
--                 color = 27,
--             },
--         },
--         canSee = {
--             ['mt'] = true,
--             ['ambulance'] = true,
--             ['police'] = true,
--             ['sheriff'] = true,
--         },
--     },
--     ['ambulance'] = {
--         ignoreDuty = true,
--         blip = {
--             sprite = 1,
--             color = 0,
--             flashColors = {
--                 0,
--                 59,
--             }
--         },
--         vehBlip = {
--             ['default'] = {
--                 sprite = 225,
--                 color = 0,
--             },
--         },
--         canSee = {
--             ['police'] = true,
--             ['ambulance'] = true,
--             ['sheriff'] = true,
--             ['mt'] = true,
--         }
--     },
--     ['taxi'] = {
--         ignoreDuty = true,
--         blip = {
--             sprite = 198,
--             color = 46,
--             flashColors = {
--                 46,
--                 46,
--             }
--         },
--         vehBlip = {
--             ['default'] = {
--                 sprite = 198,
--                 color = 46,
--             },
--         },
--         canSee = {
--             ['taxi'] = true,
--         }
--     },
--     ['mechanic'] = {
--         ignoreDuty = true,
--         blip = {
--             sprite = 402,
--             color = 56,
--             flashColors = {
--                 56,
--                 56,
--             }
--         },
--         vehBlip = {
--             ['default'] = {
--                 sprite = 225,
--                 color = 56,
--             },
--         },
--         canSee = {
--             ['mechanic'] = true,
--         }
--     },
--     ['weazel'] = {
--         ignoreDuty = true,
--         blip = {
--             sprite = 402,
--             color = 31,
--             flashColors = {
--                 31,
--                 31,
--             }
--         },
--         vehBlip = {
--             ['default'] = {
--                 sprite = 225,
--                 color = 31,
--             },
--         },
--         canSee = {
--             ['weazel'] = true,
--         }
--     },
-- }