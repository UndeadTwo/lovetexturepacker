function love.load(args)
	moses = require('moses_min')

	packingImage = verifyArguments(args)
	cursorImage = nil

	local resultingIslands = {}
	images = {}

	for x = 0, packingImage:getWidth() - 1 do
		for y = 0, packingImage:getHeight() - 1 do
			local r,g,b,a = packingImage:getData():getPixel(x, y)
			if(a ~= 0)then
				table.insert(resultingIslands, createImageDataFromPixelDump(generateIslandPixelDump(packingImage:getData(), x, y)))
			end
		end
	end

	moses.sort(resultingIslands, imageDataSortingHeuristic)

	for k,v in pairs(resultingIslands) do
		table.insert(images, love.graphics.newImage(v))
	end
end

function verifyArguments(args)
	local packingImage

	if(args[2] == nil)then
		error("No image supplied.")
	end

	packingImage = love.graphics.newImage(args[2])

	if(packingImage == nil)then
		error("Bad image.")
	end

	return packingImage
end

function love.draw()
	love.graphics.setBackgroundColor(255, 128, 128, 255)

	local x, y = 0, 0
	local newY = 0
	local sprite = 1
	local spriteLimit = #images
	while(sprite ~= spriteLimit) do
		love.graphics.draw(images[sprite],x,y)
		x = x + images[sprite]:getWidth() + 1

		if(images[sprite]:getHeight() > newY)then
			newY = images[sprite]:getHeight()
		end

		if(x >= 800 or ((sprite + 1 <= spriteLimit) and 800 - x < images[sprite + 1]:getWidth()))then
			x = 0
			y = newY + 1
		end

		sprite = sprite + 1
	end
end

function generateIslandPixelDump(imageData, x, y)
	local r,g,b,a = imageData:getPixel(x, y)
	local result = {{x, y, r, g, b, a}}

	imageData:setPixel(x, y, r, g, b, 0)

	if(originx ~= x + 1) then
		r,g,b,a = imageData:getPixel(x + 1, y)
		if(a ~= 0)then
			result = moses.append(result, generateIslandPixelDump(imageData, x + 1, y))
		end
	end

	if(originx ~= x - 1) then
		r,g,b,a = imageData:getPixel(x - 1, y)
		if(a ~= 0)then
			result = moses.append(result, generateIslandPixelDump(imageData, x - 1, y))
		end
	end

	if(originy ~= y + 1) then
		r,g,b,a = imageData:getPixel(x, y + 1)
		if(a ~= 0)then
			result = moses.append(result, generateIslandPixelDump(imageData, x, y + 1))
		end
	end

	if(originy ~= y - 1) then
		r,g,b,a = imageData:getPixel(x, y - 1)
		if(a ~= 0)then
			result = moses.append(result, generateIslandPixelDump(imageData, x, y - 1))
		end
	end

	if(originx ~= x + 1 and originy ~= y + 1) then
		r,g,b,a = imageData:getPixel(x + 1, y + 1)
		if(a ~= 0)then
			result = moses.append(result, generateIslandPixelDump(imageData, x + 1, y + 1))
		end
	end

	if(originx ~= x - 1 and originy ~= x - 1) then
		r,g,b,a = imageData:getPixel(x - 1, y - 1)
		if(a ~= 0)then
			result = moses.append(result, generateIslandPixelDump(imageData, x - 1, y - 1))
		end
	end

	if(originy ~= y + 1 and originx ~= x - 1) then
		r,g,b,a = imageData:getPixel(x - 1, y + 1)
		if(a ~= 0)then
			result = moses.append(result, generateIslandPixelDump(imageData, x - 1, y + 1))
		end
	end

	if(originy ~= y - 1 and originx ~= x + 1) then
		r,g,b,a = imageData:getPixel(x + 1, y - 1)
		if(a ~= 0)then
			result = moses.append(result, generateIslandPixelDump(imageData, x + 1, y - 1))
		end
	end

	return result
end

function createImageDataFromPixelDump(pixelDump)
	local pixXSort = moses.sort(moses.clone(pixelDump), function(a, b) return a[1] < b[1] end)
	local pixYSort = moses.sort(moses.clone(pixelDump), function(a, b) return a[2] < b[2] end)

	local xOffset = pixXSort[1][1]
	local yOffset = pixYSort[1][2]
	local width  = math.abs(pixXSort[1][1] - pixXSort[#pixXSort][1]) + 1
	local height = math.abs(pixYSort[1][2] - pixYSort[#pixYSort][2]) + 1

	local newSprite = love.image.newImageData(width, height)

	for k,v in pairs(pixelDump) do
		newSprite:setPixel(v[1] - xOffset, v[2] - yOffset, v[3], v[4], v[5], v[6])
	end

	return newSprite
end

function imageDataSortingHeuristic(imageDataA, imageDataB)
	return imageDataA:getWidth() * imageDataA:getHeight() > imageDataB:getWidth() * imageDataB:getHeight()
end

function exportBitmap()

end