Normal = {};
HealthBar = {};

local function distance(obj1, obj2)
  return math.sqrt(((obj1.x - obj2.x) ^ 2) + ((obj1.y - obj2.y) ^ 2));
end

function HealthBar:new(x, y, hp, maxHp)
  return setmetatable({
    x = x,
    y = y,
    hp = hp,
    maxHp = maxHp or 100
  }, { __index = HealthBar });
end

function HealthBar:update(newHp)
  self.hp = newHp;
end

function HealthBar:move(dx, dy)
  self.x = dx - 25;
  self.y = dy - 50;
end

function HealthBar:show()
  local barWidth = 50;
  local displayedWidth = (self.hp / self.maxHp) * barWidth;

  if displayedWidth < 0 then
    displayedWidth = 0;
  end

  love.graphics.setColor(1, 1, 1);
  love.graphics.rectangle("line", self.x - 1, self.y - 1, barWidth + 2, 12);

  love.graphics.setColor(89 / 255, 88 / 255, 88 / 255);
  love.graphics.rectangle("fill", self.x, self.y, barWidth, 10);
  love.graphics.setColor(79 / 255, 255 / 255, 97 / 255);
  love.graphics.rectangle("fill", self.x, self.y, displayedWidth, 10);
end

function Normal:new(x, y, enemy)
  return setmetatable({
    x = x,
    y = y,
    enemy = enemy,
    hp = 100,
    dx = 2,
    healthBar = HealthBar:new(x - 25, y - 50, 100, 100),
    attackCooldown = 1.5,
    damage = 5,
    critDamage = 10
  }, { __index = Normal });
end

function Normal:draw()
  if not self.enemy then
    love.graphics.setColor(0, 0, 0.7);
  else
    love.graphics.setColor(0.7, 0, 0);
  end

  love.graphics.circle("fill", self.x, self.y, 20, 20);
  self.healthBar:show();
end

function Normal:attack(enemy, dt)
  if self.attackCooldown > 0 then
    self.attackCooldown = self.attackCooldown - dt;
  end

  if enemy.enemy then
    self.x = self.x + self.dx;
  else
    self.x = self.x - self.dx;
  end

  if self.x > 600 then
    self.x = 600;
    self.dx = self.dx * -1;
  end
  if self.x < 0 then
    self.x = 0;
    self.dx = self.dx * -1;
  end

  self.healthBar:move(self.x, self.y);

  local d = distance(self, enemy);

  if d < 40 and self.attackCooldown <= 0 then
    enemy.hp = enemy.hp - self.damage;
    enemy.healthBar.hp = enemy.hp;
    enemy.healthBar:update(enemy.hp);
    self.attackCooldown = 1.5;
    love.graphics.print(self.damage, enemy.x - 10, enemy.y + 10);
  end
end

local goodGuy, badGuy;

function love.load()
  goodGuy = Normal:new(40, 600 / 2, false);
  badGuy = Normal:new(600 - 40, 600 / 2, true);
end

function love.update(dt)
  goodGuy:attack(badGuy, dt);
  badGuy:attack(goodGuy, dt);
end

function love.draw()
  goodGuy:draw();
  badGuy:draw();
end
