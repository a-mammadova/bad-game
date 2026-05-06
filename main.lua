enemy = require("enemy")
button = require("button")
carrot = require("carrot")
math.randomseed(os.time())

char = {
	height = 209, width = 225,
	x = 100, y = 100,
	speed = 200,
}

gate = {
	x = 1150, y = 1170,
	w = 300, h = 50,
}

local buttons = {
	menu_state = {},
	levels = {},
	run_state = {},
	pause_state = {},
	end_state = {},
}

game = {	
	state = {
		menu = true,
		paused = false,
		running = false,
		ended = false,
		won = false,
	}
}

levels = {
	[1] = {carrot_req = 3, enemy_count = 1, target_score = 40, },
	[2] = {carrot_req = 2, enemy_count = 2, target_score = 80, },
	[3] = {carrot_req = 2, enemy_count = 2, target_score = 120, },
}

level_text = ""
level_text_timer = 0
sound_played = false

carrots, enemies, time, eaten_carrots, score = {}, {}, 0, 0, 0

final_level = #levels

function changeState(state)
	game.state["running"] = state == "running"
	game.state["menu"] = state == "menu"
	game.state["ended"] = state == "ended"
	game.state["paused"] = state == "paused"
	game.state["won"] = state == "won"
end

function reachedGate()
	return char.x < gate.x + gate.w and
	      char.x + char.width > gate.x and
	      char.y < gate.y + gate.h and
	      char.y + char.height > gate.y
end

function resetGame()

	char.x, char.y, heart = 100, 100, 3
	carrots, enemies, time = {}, {}, 0
	started = false

	table.insert(carrots, 1, carrot())
	table.insert(enemies, enemy())
end
last_second = 0

function loadLevel(level) 
	eaten_carrots, started = 0, false
	carrots, enemies, heart = {}, {}, 3

	level_text = "collect "..levels[level].carrot_req..
             " carrots & reach "..levels[level].target_score.." score"

	level_text_timer = 3
	char.x, char.y = 100, 100

	for i = 1, levels[level].carrot_req do
		table.insert(carrots, carrot())
	end

	for i = 1, levels[level].enemy_count do
		table.insert(enemies, enemy())
	end
end

current_level = 1

function love.mousepressed(x, y, button)
	 if button == 1 then
        if buttons.menu_state.play:hovering(x, y) then
        		current_level = 1
        		loadLevel(current_level)
            changeState("running")
        end

        if buttons.run_state.pause:hovering(x, y) then
           changeState("paused")
        end

      	if buttons.pause_state.continue:hovering(x, y) then
        	changeState("running")
        end

        if buttons.pause_state.replay:hovering(x, y) or
        buttons.end_state.restart:hovering(x, y) then
        	resetGame()
        	changeState("running")
        end

        if buttons.end_state.menu:hovering(x, y) then
        	resetGame()
        	changeState("menu")
        end
    end
   end

function love.load()

	hit_timer, heart = 0, 3
	run_bg = love.graphics.newImage("gfx/game-2.png")
	menu_bg = love.graphics.newImage("gfx/menu-2.png")
	char.sprite = love.graphics.newImage("gfx/blue-2.png")
	heart_pic = love.graphics.newImage("gfx/heart.png")
	over_bg = love.graphics.newImage("gfx/over.png")

	eat_sound = love.audio.newSource("sfx/eat-carrot.mp3", "static")
	lost_heart_sound = love.audio.newSource("sfx/lost-heart.wav", "static")
	game_over_sound = love.audio.newSource("sfx/game-over.mp3", "static")
	night_sound = love.audio.newSource("sfx/night.mp3", "static")

	a = "fonts/font-13.ttf"
	font = love.graphics.newFont(a, 50)
	font2 = love.graphics.newFont(a, 80)
	font3 = love.graphics.newFont(a, 110)

	buttons.menu_state.play = button("PLAY", nil, nil, 150, 90)
	buttons.menu_state.settings = button("SETTINGS", nil, nil, 249, 90)
	buttons.menu_state.exit = button("EXIT", nil , nil, 140, 90)
	buttons.run_state.pause = button("II", nil, nil, 70, 90)
	buttons.pause_state.continue = button("CONTINUE", nil, nil, 250, 80)
	buttons.pause_state.replay = button("REPLAY", nil, nil, 190, 80)
	buttons.end_state.restart = button("RESTART", nil, nil, 230, 90)
	buttons.end_state.menu = button("MENU", nil, nil, 170, 90)

	table.insert(enemies, 1, enemy())
	table.insert(carrots, 1, carrot())
end

function love.update(dt)

	if level_text_timer > 0 then
		level_text_timer = level_text_timer - dt
	end

	time, hit_timer = time + dt, hit_timer - dt

	mouse_x, mouse_y = love.mouse.getPosition()

	current_second = math.floor(time)

	if started == true and current_second ~= last_second and game.state["running"] then
		last_second = current_second

    	if current_second % 1 == 0 then
       		score = score + 1
   		end
	end

	-- char move
	if game.state["running"] then
		if love.keyboard.isDown("w") or love.keyboard.isDown("up") then
			char.y = char.y - char.speed*dt
		end
		if love.keyboard.isDown("s") or love.keyboard.isDown("down") then
			char.y = char.y + char.speed*dt
		end
		if love.keyboard.isDown("a") or love.keyboard.isDown("left") then
			char.x = char.x - char.speed*dt
		end
		if love.keyboard.isDown("d") or love.keyboard.isDown("right") then
			char.x = char.x + char.speed*dt
		end

		if char.x > 1500 then
			char.x = 0
		elseif char.x < 0 then
    		char.x = 1500
		end

		if char.y > 1200 then
 		   char.y = 0
		elseif char.y < 0 then
   		char.y = 1200
end
	end

	-- enemies de move 
	if game.state["running"] then
		for i = 1, #enemies do
			if char.x > 160 or char.y > 160 then
					enemies[i]:move(char.x, char.y)
					started = true
			end
		end
	end

	if score < 0 or heart == 0 then
		changeState("ended")

		if not sound_played then
			love.audio.play(game_over_sound)
			sound_played = true
		end
	end

	if eaten_carrots >= levels[current_level].carrot_req and
		score >= levels[current_level].target_score then
			if reachedGate() then
				current_level = current_level + 1
	  			loadLevel(current_level)
	  		end
	end

end

function love.draw()	

	-- RUNNING
	if game.state["running"] then
		
		love.graphics.draw(run_bg, 0, 0)
		love.graphics.printf("FPS:" .. love.timer.getFPS(), 10, 1080, 200, "left")

		--SCORE
		love.graphics.setColor(0, 0, 0)
		love.graphics.rectangle("fill", 820, 15, 310, 75 )
		love.graphics.setColor(199/255, 49/255, 117/255)
		love.graphics.rectangle("fill", 825, 20, 300, 65)
		love.graphics.setColor(0, 0, 0)
		love.graphics.printf("SCORE: " ..score, 800, 25, 300, "center")
		love.graphics.setColor(1, 1, 1)

		--GATE
		love.graphics.setColor(0, 0, 0)
		love.graphics.rectangle("fill", gate.x - 10, gate.y - 10,
		 gate.w + 20, gate.h + 10)
		love.graphics.setColor(139/255, 69/255, 19/255)
		love.graphics.rectangle("fill", gate.x, gate.y, gate.w, gate.h)
		love.graphics.setColor(0, 0, 0)
		love.graphics.circle("line", gate.x + gate.w / 2, gate.y + gate.h / 3, 6)
		love.graphics.setColor(1, 1, 1)

		--HEART
		for i = 1, heart do
			love.graphics.draw(heart_pic, 80*i, 15)
		end

		buttons.run_state.pause:draw(1400, 30, 200, 400)
		love.graphics.setColor(1, 1, 1)

		offset_y = math.sin(time * 3) * 10 
		love.graphics.push()
		love.graphics.draw(char.sprite, char.x, char.y + offset_y)

		for i = 1, #carrots do
			carrots[i]:draw(time)
		end

		for i = #carrots, 1, -1 do
			if carrots[i]:eaten(char.x, char.y, char.width, char.height) then
				love.audio.play(eat_sound)
				score = score + 10
				table.remove(carrots, i)
				eaten_carrots = eaten_carrots + 1
			end
		end

		love.graphics.pop()

		for i = 1, #enemies do
			if enemies[i]:hit(char.x, char.y, char.width, char.height) and hit_timer <= 0 then 
				heart = heart - 1
				love.audio.play(lost_heart_sound) --WILL BE CHANGED !!!!
				score = score - 20
				hit_timer = 1
			end
		end

		if hit_timer > 0 then
			love.graphics.setColor(1, 0, 0, 0.15)
			love.graphics.rectangle("fill", 0, 0, 1500, 1200)
		else
			love.graphics.setColor(1, 1, 1)
		end


		for i = 1, #enemies do
			enemies[i]:draw()
		end

		love.graphics.setColor(0, 0, 0)
		love.graphics.rectangle("fill", 365, 15, 310, 75 )
		love.graphics.setColor(199/255, 49/255, 117/255)
		love.graphics.rectangle("fill", 370, 20, 300, 65)
		love.graphics.setColor(0, 0, 0)
		love.graphics.printf("LEVEL: " ..current_level, 335, 25, 300, "center")
		love.graphics.setColor(1, 1, 1)

		if level_text_timer > 0 then
    		love.graphics.setFont(font)
    		love.graphics.setColor(0, 0, 0, 0.7 * math.min(level_text_timer / 3, 1))
    		love.graphics.rectangle("fill", 400, 200, 700, 100)

    		love.graphics.setColor(1, 1, 1, math.min(level_text_timer / 3, 1))
    		love.graphics.printf(level_text, 400, 220, 700, "center")
    		love.graphics.setColor(1, 1, 1)
		end

	end

	if game.state["ended"] then
		love.graphics.setColor(1, 1, 1, 1)
		love.graphics.draw(over_bg, 0, 0)
		love.graphics.setColor(1, 1, 1)
		love.graphics.setFont(font)
		love.graphics.printf("SCORE: "..score, 450, 200, 600, "center")

		love.graphics.setFont(font2)
		if score <= 0 then
			love.graphics.printf(score .."? seriously? bruh.", 300, 280, 900, "center"  )
		end

		if score <= 20 and score >= 0 then
			love.graphics.printf("tragic", 300, 280, 900, "center")
		end

		if score > 20 and score <= 40 then
			love.graphics.printf("meh", 300, 280, 900, "center")
		end

		if score > 40 and score <= 60 then
			love.graphics.printf("decent", 300, 280, 900, "center")
		end

		if score < 100 and score > 60 then
			love.graphics.printf("mediocre", 300, 280, 900, "center"  )
		end

		if score >= 100 then
			love.graphics.printf("even i can't go that far, lol", 300, 280, 900, "center"  )
		end

		love.graphics.setColor(1, 1, 1)
		buttons.end_state.restart:draw(620, 480, 200, 400)
		buttons.end_state.menu:draw(645, 600, 200, 400)
		--love.graphics.draw()
	end

	if game.state["paused"] then
		buttons.pause_state.continue:draw(635, 520, 300, 380)	
		buttons.pause_state.replay:draw(660, 400, 300, 400)
	end

	if game.state["menu"] then
		love.graphics.setColor(250/255, 250/255, 250/255)
		love.graphics.draw(menu_bg, 0, 0)
		love.graphics.setColor(0, 0, 0)

		buttons.menu_state.play:draw(650, 400, 200, 400)
		buttons.menu_state.settings:draw(615, 550, 300, 400)
		buttons.menu_state.exit:draw(650, 700, 200, 400)
	end

	if game.state["won"] then
		love.graphics.setFont(font3)
		love.graphics.printf("YOU WON!", 300, 480, 900, "center")
	end
end