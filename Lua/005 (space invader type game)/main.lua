Player = {};
Projectile = {};

function Projectile:new(x, y)
  return setmetatable({
    x = x,
    y = y,
    toFire = true,
    cooldown = 3
  }, { __index = Projectile });
end

function Projectile:update()
  self.y = self.y + 2;
end

function Projectile:draw()
  love.graphics.setColor(1, 68 / 255, 0);
  love.graphics.rectangle("fill", self.x, self.y, 10, 20);
end

function Player:new(x, y)
  return setmetatable({
    x = x,
    y = y
  }, { __index = Player });
end

function Player:draw()
  love.graphics.setColor(1, 1, 1);
  love.graphics.rectangle("fill", self.x, self.y, 20, 50);
end

function Player:move(dx)
  self.x = self.x + dx;
end

local player;
local projectiles = {};

function love.load()
  love.window.setTitle("space invaders (kinda)");
  love.window.setMode(600, 600);
  player = Player:new(600 / 2, (600 / 2) + 150);
  for _ = 1, 20 do
    table.insert(projectiles, Projectile:new(player.x + 5, player.y));
  end
end

function love.update(dt)
  if love.keyboard.isDown("left") then
    player:move(-1, 0);
  end
  if love.keyboard.isDown("right") then
    player:move(1, 0);
  end
end

function love.keypressed(key)
  if key == "space" then
    for i = #projectiles, 1, -1 do
      projectiles[i]:update();
    end
  end
end

function love.draw()
  for i = 1, #projectiles do
    projectiles[i]:draw();
  end
  player:draw();
end
