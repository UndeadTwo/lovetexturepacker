function love.load(args)
	moses = require('moses_min')

	packingImage = verifyArguments(args)
	cursorImage = nil


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
	love.graphics.setBackgroundColor(128, 128, 128, 0)
	love.graphics.draw(packingImage, 0, 0)

	if(cursorImage ~= nil)then
		love.graphics.draw(cursorImage, love.mouse.getX(), love.mouse.getY())
	end
end

-- function love.mousepressed(x, y, b)
-- 	local pixDump = generateIslandPixelDump(packingImage:getData(), x, y)

-- 	local pixelDumpData = createImageDataFromPixelDump(pixDump)
-- 	cursorImage = love.graphics.newImage(pixelDumpData)

-- end

function generateIslandPixelDump(imageData, x, y)
	local r,g,b,a = imageData:getPixel(x, y)
	local result = {{x, y, r, a}}	-- XY coords, one byte of color. Overkill considering images should be 2bit images (white, black, alpha)

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
		newSprite:setPixel(v[1] - xOffset, v[2] - yOffset, v[3], v[3], v[3], 255)
	end

	return newSprite
end

function exportBitmap()

end

function makeString(...)
  local result = ''
  for k,v in pairs({...}) do
    result = result .. tostring(v) .. ', '
  end
  return result .. '\n'
end