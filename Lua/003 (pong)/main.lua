Paddle = {};
Ball = {};

local paddleHeight = 200;
local paddleSpeed = 300;
local w = 600;
local paddleA, paddleB, ball;
local paddleAScore = 0;
local paddleBScore = 0;

function Paddle:new(x, y)
  return setmetatable({
    x = x,
    y = y
  }, { __index = Paddle });
end

function Paddle:draw()
  love.graphics.setColor(1, 1, 1);
  love.graphics.rectangle("fill", self.x, self.y, 20, paddleHeight);
end

function Paddle:moveY(dy, dt)
  self.y = self.y + dy * dt;

  if self.y > 400 then
    self.y = 400;
  end
  if self.y < 0 then
    self.y = 0;
  end
end

function Ball:new(x, y)
  return setmetatable({
    x = x,
    y = y,
    dx = 100,
    dy = 100,
    radius = 20,
    defaultX = x,
    defaultY = y,
  }, { __index = Ball });
end

function Ball:draw()
  love.graphics.setColor(1, 0, 0);
  love.graphics.circle("fill", self.x, self.y, self.radius);
end

function Ball:update(dt)
  self.x = self.x + self.dx * dt;
  self.y = self.y - self.dy * dt;

  if (self.y < self.radius) then
    self.y = self.radius;
    self.dy = -self.dy;
  end
  if (self.y > w - self.radius) then
    self.y = w - self.radius;
    self.dy = -self.dy;
  end
  if (self.x < self.radius) then
    self.x = self.defaultX;
    self.y = self.defaultY;
    self.dx = -self.dx;
    paddleAScore = paddleAScore + 1;
  end
  if (self.x > w + self.radius) then
    self.x = self.defaultX;
    self.y = self.defaultY;
    self.dx = -self.dx;
    paddleBScore = paddleBScore + 1;
    self.speedMultiplier = 1.1;
  end

  if self.x + self.radius > paddleA.x and
      self.x - self.radius < paddleA.x + 20 and
      self.y + self.radius > paddleA.y and
      self.y - self.radius < paddleA.y + paddleHeight then
    self.dx = -self.dx;
  end
  if self.x + self.radius > paddleB.x and
      self.x - self.radius < paddleB.x + 20 and
      self.y + self.radius > paddleB.y and
      self.y - self.radius < paddleB.y + paddleHeight then
    self.dx = -self.dx;
  end
end

function love.load()
  paddleA = Paddle:new(600 - 20, 300 - paddleHeight / 2);
  paddleB = Paddle:new(0, 300 - paddleHeight / 2);
  ball = Ball:new(300 - 20 / 2, 300 - 20 / 2);
end

local paddleAMoving, paddleBMoving;

function love.update(dt)
  paddleAMoving = false;
  paddleBMoving = false;

  if love.keyboard.isDown("up") and not paddleBMoving then
    paddleA:moveY(-paddleSpeed, dt);
    paddleAMoving = true;
  end
  if love.keyboard.isDown("down") and not paddleBMoving then
    paddleA:moveY(paddleSpeed, dt);
    paddleAMoving = true;
  end
  if love.keyboard.isDown("w") and not paddleAMoving then
    paddleB:moveY(-paddleSpeed, dt);
    paddleBMoving = true;
  end
  if love.keyboard.isDown("s") and not paddleAMoving then
    paddleB:moveY(paddleSpeed, dt);
    paddleBMoving = true;
  end
  ball:update(dt);
end

function love.draw()
  paddleA:draw();
  paddleB:draw();
  ball:draw();
  love.graphics.setColor(1, 1, 1);
  love.graphics.print("Player A score: " .. paddleAScore, paddleA.x - 250, (300 - paddleHeight / 2) - 30);
  love.graphics.print("Player B score: " .. paddleBScore, paddleB.x + 200, (300 - paddleHeight / 2) - 30);
end
