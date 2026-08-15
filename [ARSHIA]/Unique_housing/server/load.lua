-- ============================================================================
-- Sunset Housing - in-memory cache
-- Houses[id]          -> full single-house record (sent to every client)
-- Apartments[id]      -> apartment building record (sent to every client)
-- ApartmentUnitIndex[apartmentId] -> {[1] = {id = unitId}, ...} (sent to every client)
-- ApartmentUnits[id]  -> full apartment-unit record (kept server-side only,
--                        lazily sent per-request via `sunset_housing:getHouse`)
-- ============================================================================

Houses             = {}
Apartments         = {}
ApartmentUnitIndex = {}
ApartmentUnits     = {}

local function decode(v)
	if v == nil or v == '' then return nil end
	local ok, result = pcall(json.decode, v)
	if ok then return result end
	return nil
end

function SH_BuildHouseRecord(row)
	return {
		Id             = row.id,
		Owner          = row.owner,
		Entercoords    = decode(row.entercoords),
		Garagecoords   = decode(row.garagecoords) or 'no',
		Shell          = row.shell,
		Shellgarage    = row.shellgarage,
		Price          = row.price,
		IsAP           = false,
		inventorylevel = row.inventorylevel or 1,
		safelevel      = row.safelevel or 1,
		Furniture      = decode(row.furniture) or {},
		storage_data   = row.storage_data,
	}
end

function SH_BuildApartmentUnitRecord(row)
	return {
		Id             = row.id,
		ApartmentId    = row.apartment_id,
		Floor          = row.floor,
		Owner          = row.owner,
		Shell          = row.shell,
		Price          = row.price,
		IsAP           = true,
		inventorylevel = row.inventorylevel or 1,
		safelevel      = row.safelevel or 1,
		Furniture      = decode(row.furniture) or {},
		storage_data   = row.storage_data,
	}
end

function SH_LoadAll(cb)
	Houses, Apartments, ApartmentUnitIndex, ApartmentUnits = {}, {}, {}, {}

	SH_DB.GetAllHouses(function(rows)
		for _, row in ipairs(rows) do
			Houses[row.id] = SH_BuildHouseRecord(row)
		end

		SH_DB.GetAllApartments(function(aRows)
			for _, row in ipairs(aRows) do
				Apartments[row.id] = {
					Id          = row.id,
					Label       = row.label,
					Entercoords = decode(row.entercoords),
				}
				ApartmentUnitIndex[row.id] = { house = {} }
			end

			SH_DB.GetAllApartmentUnits(function(uRows)
				for _, row in ipairs(uRows) do
					ApartmentUnits[row.id] = SH_BuildApartmentUnitRecord(row)
					if ApartmentUnitIndex[row.apartment_id] then
						table.insert(ApartmentUnitIndex[row.apartment_id].house, { id = row.id })
					end
				end

				if cb then cb() end
			end)
		end)
	end)
end

AddEventHandler('sunset_housing:dbReady', function()
	SH_LoadAll(function()
		print(('[sunset_housing] loaded %s houses, %s apartments, %s apartment units'):format(
			SH_TableLen(Houses), SH_TableLen(Apartments), SH_TableLen(ApartmentUnits)
		))
	end)
end)

function SH_TableLen(t)
	local n = 0
	for _ in pairs(t) do n = n + 1 end
	return n
end

-- Broadcasts the full house/apartment index to one player (or everyone if -1)
function SH_SendHouses(target)
	TriggerClientEvent('sunset_housing:set_houses', target, Houses, Apartments, ApartmentUnitIndex)
end

RegisterNetEvent('sunset_housing:request_houses')
AddEventHandler('sunset_housing:request_houses', function()
	SH_SendHouses(source)
end)

AddEventHandler('esx:playerLoaded', function(playerId)
	CreateThread(function()
		-- small delay so the client's Config.Houses table exists before we send
		Wait(2000)
		SH_SendHouses(playerId)
	end)
end)
