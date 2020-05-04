function love.load()
    background = love.graphics.newImage("sprites/background.png")
    world = love.physics.newWorld(0, 100, true)

    -- love.keyboard.setKeyRepeat(false)

    world:setCallbacks(beginContact, endContact, preSolve, postSolve)

    ball = {}
    ball.b = love.physics.newBody(world, 400,200, "dynamic")
    ball.s = love.physics.newCircleShape(50)
    ball.f = love.physics.newFixture(ball.b, ball.s)
    ball.f:setRestitution(0.4)
    ball.f:setUserData("Ball")
    
    static = {}
    static.b = love.physics.newBody(world, 0,500, "static")
    static.s = love.physics.newRectangleShape(50,400)
    static.f = love.physics.newFixture(static.b, static.s)
    static.f:setUserData("Block")

    text = ""
    persisting = 0
end

function love.update(dt)
    world:update(dt)
    
    if love.keyboard.isDown("right") then
        ball.b:applyForce(1000, 0) 
    elseif love.keyboard.isDown("left") then
        ball.b:applyForce(-1000, 0) 
    end
    if love.keyboard.isDown("up") then
        ball.b:applyForce(0, -10000)
    elseif love.keyboard.isDown("down") then
        ball.b:applyForce(0, 1000)
    end
 
    if string.len(text) > 768 then
        text = "" 
    end
end

function love.draw()
    for i = 0, love.graphics.getWidth() / background:getWidth() do
        for j = 0, love.graphics.getHeight() / background:getHeight() do
            love.graphics.draw(background, i * background:getWidth(), j * background:getHeight())
        end
    end

    tile2 = love.graphics.newImage("sprites/Tiles/2.png")
    love.graphics.circle("line", ball.b:getX(), ball.b:getY(), ball.s:getRadius(), 20)
    love.graphics.draw(tile2, static.b:getX(), static.b:getY())
end

function love.draw()
    for i = 0, love.graphics.getWidth() / background:getWidth() do
        for j = 0, love.graphics.getHeight() / background:getHeight() do
            love.graphics.draw(background, i * background:getWidth(), j * background:getHeight())
        end
    end

    love.graphics.circle("line", ball.b:getX(), ball.b:getY(), ball.s:getRadius(), 20)
    -- love.graphics.draw(tile2, static.b:getX(), static.b:getY())
    showTile()
end

function showTile()
    tile2 = love.graphics.newImage("sprites/Tiles/2.png")
    
    for i = 0, love.graphics.getWidth() / tile2:getWidth() do
        for j = 0, love.graphics.getHeight() / tile2:getHeight() do
            love.graphics.draw(tile2, i * tile2:getWidth(), static.b:getY())
        end
    end
end

function beginContact(a, b, coll)
    x,y = coll:getNormal()
    text = text.."\n"..a:getUserData().." colliding with "..b:getUserData().." with a vector normal of: "..x..", "..y
end
 
 
function endContact(a, b, coll)
    persisting = 0
    text = text.."\n"..a:getUserData().." uncolliding with "..b:getUserData()
end
 
function preSolve(a, b, coll)
    if persisting == 0 then 
        text = text.."\n"..a:getUserData().." touching "..b:getUserData()
    elseif persisting < 20 then
        text = text.." "..persisting
    end
    persisting = persisting + 1
end
 
function postSolve(a, b, coll, normalimpulse, tangentimpulse)
-- we won't do anything with this function
end