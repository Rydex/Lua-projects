love.window.setMode(600, 600);

Player = {};
Projectile = {};
Enemy = {};

local w = 10;
local h = 50;
local player;
local projectiles = {};
local enemies = {};
local gameOver = false;

-- function to get distance
local function dist(x1, y1, x2, y2)
	return math.sqrt((x2 - x1) ^ 2 + (y2 - y1) ^ 2)
end

-- player start
function Player:new(x, y)
	local obj = {};

	setmetatable(obj, self);
	self.__index = self;

	self.x = x;
	self.y = y;

	return obj;
end

function Player:show()
	love.graphics.setColor(1, 1, 1);
	love.graphics.rectangle("fill", self.x, self.y, w, h);
end

function Player:move(dx, dy)
	self.x = self.x + dx;
	self.y = self.y + dy;

	if self.x + w > 600 then
		self.x = 600 - w;
	end
	if self.x < 0 then
		self.x = 0;
	end
	if self.y + h > 600 then
		self.y = 600 - h;
	end
	if self.y < 0 then
		self.y = 0;
	end
end

-- player end

-- projectile start
function Projectile:new(x, y)
	local obj = {
		x = x,
		y = y
	};

	setmetatable(obj, { __index = Projectile });

	return obj;
end

function Projectile:show()
	love.graphics.setColor(255 / 255, 60 / 255, 25 / 255);
	love.graphics.rectangle("fill", self.x, self.y + 20, 20, 10);
end

function Projectile:update()
	self.x = self.x + 5;
end

function Projectile:checkCollisions()
	for i = #enemies, 1, -1 do
		local enemy = enemies[i];

		local distance = dist(self.x, self.y, enemy.x, enemy.y);

		if distance < 50 then
			table.remove(enemies, i);
			return true;
		end
	end
	return false;
end

-- projectile end


-- enemy start

function Enemy:new(x, y)
	local obj = {
		x = x,
		y = y
	};

	setmetatable(obj, { __index = Enemy });

	return obj;
end

function Enemy:show()
	love.graphics.setColor(1, 0, 0);
	love.graphics.circle("fill", self.x, self.y, 25, 25);

	love.graphics.setColor(0, 0, 0);
	love.graphics.setLineWidth(1.5);
	love.graphics.circle("line", self.x, self.y, 25, 25);
	love.graphics.setLineWidth(1);
end

function Enemy:update()
	self.x = self.x - 1

	if self.x < 0 then
		gameOver = true;
	end
end

function Enemy:hit()
	local distance = dist(self.x, self.y, player.x, player.y);

	if distance < 25 + w then
		gameOver = true;
	end
end

-- enemy end

function love.load()
	love.graphics.setBackgroundColor(60 / 255, 60 / 255, 60 / 255);
	player = Player:new(0, 300);
	for i = 0, 11 do
		table.insert(enemies, Enemy:new(550, i * 50 + 25));
	end
end

function love.keypressed(key)
	if key == "space" then
		table.insert(projectiles, Projectile:new(player.x, player.y));
	end

	if key == "r" and gameOver then
		gameOver = false;
		player = Player:new(0, 300);
		enemies = {};
		for i = 0, 11 do
			table.insert(enemies, Enemy:new(550, i * 50 + 25))
		end
	end
end

function love.update(dt)
	if gameOver then
		return;
	end
	if love.keyboard.isDown("d") then
		player:move(5, 0);
	end
	if love.keyboard.isDown("a") then
		player:move(-5, 0);
	end
	if love.keyboard.isDown("s") then
		player:move(0, 5);
	end
	if love.keyboard.isDown("w") then
		player:move(0, -5);
	end

	for i = #projectiles, 1, -1 do
		projectiles[i]:update();

		if projectiles[i].x + 20 > 600 or projectiles[i]:checkCollisions() then
			table.remove(projectiles, i);
			break;
		end
	end

	for i = #enemies, 1, -1 do
		enemies[i]:hit();
		enemies[i]:update();
	end
end

function love.draw()
	if gameOver then
		love.graphics.setColor(1, 1, 1);
		love.graphics.print("Game over!!! Press R to restart", 250, 300);
		return;
	end
	for i = #projectiles, 1, -1 do
		projectiles[i]:show();
	end
	for i = #enemies, 1, -1 do
		enemies[i]:show();
	end
	player:show();

	if #enemies == 0 then
		love.graphics.print("You have won!!!", 600 / 2, 600 / 2);
	end
end
