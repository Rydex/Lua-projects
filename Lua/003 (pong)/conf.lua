io.stdout:setvbuf('no')

function love.conf(t)
  t.console = true;
  t.window.title = "Pong";
  t.window.width = 600;
  t.window.height = 600;
end

love.window.setMode(600, 600);
