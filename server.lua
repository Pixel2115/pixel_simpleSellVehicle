ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterCommand('sellvehicle', function(source, args, rawCommand)
	local xPlayer = ESX.GetPlayerFromId(source)
	if tonumber(args[1]) and args[2] then
		local tPlayer = ESX.GetPlayerFromId(args[1])
		if tPlayer then
			local plate = args[2]
			local result = MySQL.Sync.fetchAll('SELECT * FROM owned_vehicles WHERE owner = @identifier AND plate = @plate', {
				['@identifier'] = xPlayer.identifier,
				['@plate'] = plate
			}) 
			if result[1] ~= nil then
				MySQL.Async.execute('UPDATE owned_vehicles SET owner = @target WHERE owner = @owner AND plate = @plate', {
				['@owner'] = xPlayer.identifier,
				['@plate'] = plate,
				['@target'] = tPlayer.identifier
				}, function (rowsChanged)
					if rowsChanged ~= 0 then
						tPlayer.showNotification("~g~Bought vehicle with plate ~w~"..plate.." from "..xPlayer.name)
						tPlayer.showNotification("~g~Sold vehicle with plate ~w~"..plate.." to "..tPlayer.name)
					end
				end)
			else
				xPlayer.showNotification("~r~It's not your vehicle or plate is not valid")
			end
		else
			xPlayer.showNotification("~r~Cannot find player with that ID")
		end
	else
		xPlayer.showNotification("~r~Invalid comand usage. /sellvehicle ID Plate")
	end
end, false)