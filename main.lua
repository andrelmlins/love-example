Colors = {
    field = { 56/255, 142/255, 60/255 },
    externalArea = { 161/255, 136/255, 127/255 },
    white = { 1, 1, 1 },
    ball = { 66/255, 66/255, 66/255 }
}

Sizes = {
    border = 40,
    line = 6,
}

function love.load()
    love.graphics.setBackgroundColor(Colors.externalArea)
    world = love.physics.newWorld(0, 0, true)

    world:setCallbacks(beginContact, endContact, preSolve, postSolve)

    ball = {}
    ball.b = love.physics.newBody(world, love.graphics.getWidth() / 2 , love.graphics.getHeight() / 2, "dynamic")
    ball.s = love.physics.newCircleShape(20)
    ball.f = love.physics.newFixture(ball.b, ball.s)
    ball.f:setRestitution(0.4)
    ball.f:setUserData("Ball")

    blockBottom = {}
    blockBottom.b = love.physics.newBody(world, love.graphics.getWidth()/2, love.graphics.getHeight(), "static")
    blockBottom.s = love.physics.newRectangleShape(love.graphics.getWidth(), 0)
    blockBottom.f = love.physics.newFixture(blockBottom.b, blockBottom.s)
    blockBottom.f:setUserData("Block")

    blockTop = {}
    blockTop.b = love.physics.newBody(world, love.graphics.getWidth()/2, 0, "static")
    blockTop.s = love.physics.newRectangleShape(love.graphics.getWidth(), 0)
    blockTop.f = love.physics.newFixture(blockTop.b, blockTop.s)
    blockTop.f:setUserData("Block")

    blockRight = {}
    blockRight.b = love.physics.newBody(world, 0, love.graphics.getHeight()/2, "static")
    blockRight.s = love.physics.newRectangleShape(0, love.graphics.getHeight())
    blockRight.f = love.physics.newFixture(blockRight.b, blockRight.s)
    blockRight.f:setUserData("Block")

    blockLeft = {}
    blockLeft.b = love.physics.newBody(world, love.graphics.getWidth(), love.graphics.getHeight()/2, "static")
    blockLeft.s = love.physics.newRectangleShape(0, love.graphics.getHeight())
    blockLeft.f = love.physics.newFixture(blockLeft.b, blockLeft.s)
    blockLeft.f:setUserData("Block")

    text = ""
    persisting = 0
end

function love.update(dt)
    world:update(dt)
    
    if love.keyboard.isDown("right") then
        ball.b:applyForce(4000, 0) 
    elseif love.keyboard.isDown("left") then
        ball.b:applyForce(-4000, 0) 
    end
    if love.keyboard.isDown("up") then
        ball.b:applyForce(0, -4000)
    elseif love.keyboard.isDown("down") then
        ball.b:applyForce(0, 4000)
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
    love.graphics.setColor(Colors.field)
    love.graphics.rectangle(
        "fill",
        Sizes.border,
        Sizes.border,
        love.graphics.getWidth() - (Sizes.border * 2),
        love.graphics.getHeight() - (Sizes.border * 2)
    )

    love.graphics.setColor(Colors.white)
    love.graphics.setLineWidth(Sizes.line)
    love.graphics.rectangle(
        "line",
        Sizes.border,
        Sizes.border,
        love.graphics.getWidth() - (Sizes.border * 2),
        love.graphics.getHeight() - (Sizes.border * 2)
    )

    love.graphics.setColor(Colors.white)
    love.graphics.setLineWidth(Sizes.line)
    love.graphics.line(
        love.graphics.getWidth() / 2,
        Sizes.border,
        love.graphics.getWidth() / 2,
        love.graphics.getHeight() - Sizes.border
    )

    love.graphics.setColor(Colors.white)
    love.graphics.circle("line", love.graphics.getWidth() / 2, love.graphics.getHeight() / 2, 80)
    
    love.graphics.setColor(Colors.ball)
    love.graphics.circle("fill", ball.b:getX(), ball.b:getY(), ball.s:getRadius(), 20)
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