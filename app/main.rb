# full documenation is at http://docs.dragonruby.org
# be sure to come to the discord if you hit any snags: http://discord.dragonruby.org

# The tick method is called by DragonRuby every frame
# args contains all the information regarding the game.
def tick args
  # ====================================================
  # initialize default variables
  # ====================================================

  # ruby has an operator called ||= which means "only initialize this if it's nil"
  args.state.count_down   ||= 25 * 60 # set the count down to 20 seconds
  # the game renders in 60 fps: 20s * 60fps = 1200 frames

  # set the width and the height of the target
  args.state.target_width  ||= 100
  args.state.target_height ||= 100

  # set the initial position of the target
  args.state.target       ||= { x: args.grid.w.half - args.state.target_width / 2,
                                y: args.grid.h.half - args.state.target_height / 2,
                                w: args.state.target_width,
                                h: args.state.target_height }

  # set the width and the height of the left guard
  args.state.guard_width  ||= 100
  args.state.guard_height ||= 100

  # set the initial position of the left guard
  args.state.guard_left   ||= { x: args.grid.w.half - args.state.guard_width / 2 - 300,
                                y: args.grid.h.half - args.state.guard_height / 2,
                                w: args.state.guard_width,
                                h: args.state.guard_height }

  # set the initial position of the right guard
  args.state.guard_right   ||= { x: args.grid.w.half - args.state.guard_width / 2 + 300,
                                y: args.grid.h.half - args.state.guard_height / 2,
                                w: args.state.guard_width,
                                h: args.state.guard_height }

  # set the guard speed
  args.state.guard_speed ||= 1

  # set the guard maxium speed
  args.state.guard_maximum_speed ||= 10

  # set the width and the height of the player
  args.state.player_width  ||= 100
  args.state.player_height ||= 100

  # set the initial position of the player
  args.state.player       ||= { x: 100,
                                y: 100,
                                w: args.state.player_width,
                                h: args.state.player_height }

  # set the player movement speed
  args.state.player_speed ||= 1

  # set the player maxium speed
  args.state.player_maximum_speed ||= 10

  # set the player maxium speed
  args.state.player_life ||= 100

  # set the score and the score to win
  args.state.score        ||= 0
  args.state.score_win    ||= 10

  # set the instructions
  args.state.instructions_1 ||= "Get #{args.state.score_win} DragonRuby icons!"
  args.state.instructions_2 ||= "Use arrow keys to move."
  args.state.instructions_3 ||= "Press [Tab] to change difficulty."
  args.state.instructions_4 ||= "Press [Enter] to start."

  # sprite frame
  args.state.sprite_frame = args.state.tick_count.idiv(4).mod(6)

  # guard frame
  args.state.guard_frame = args.state.tick_count.idiv(30).mod(2)

  # life frame
  args.state.life_frame = 5 * (args.state.tick_count.idiv(5).mod(2) + 1)

  # count down life
  args.state.count_down_life ||= 0

  # set direction speed
  args.state.dir_x ||= 0
  args.state.dir_y ||= 0

  # set border specs
  args.state.border_corner_x ||= 5
  args.state.border_corner_y ||= 5
  args.state.border_width  ||= args.grid.w - 2 * args.state.border_corner_x
  args.state.border_height ||= args.grid.h - 2 * args.state.border_corner_y

  # set random coordinates for the target
  args.state.target_x ||= args.state.border_corner_x + (rand (args.state.border_width - args.state.player_width))
  args.state.target_y ||= args.state.border_corner_y + (rand (args.state.border_height - args.state.player_height))

  # set y coordinate of the left guard and the right guard
  args.state.guard_left_y  ||= 5
  args.state.guard_right_y ||= -5

  # ====================================================
  # render the game
  # ====================================================
  # check if we are in the game menu 
  if game_menu? args
    args.outputs.primitives << { x: args.grid.w.half, y: args.grid.h.half + 150,
                                 text: "Dragon Quest Rush",
                                 size_enum: 20, alignment_enum: 1,
                                 r: 255, g: 0, b: 0, a: 255,
                                 font: "fonts/manaspc.ttf" }.label

    args.outputs.labels  << { x: args.grid.w.half, y: args.grid.h.half + 50,
                              text: args.state.instructions_1,
                              size_enum: 10, alignment_enum: 1,
                              r: 0, g: 200, b: 255, a: 255, font: "fonts/manaspc.ttf" }

    args.outputs.labels  << { x: args.grid.w.half, y: args.grid.h.half,
                              text: args.state.instructions_2,
                              size_enum: 10, alignment_enum: 1,
                              r: 0, g: 120, b: 255, a: 255, font: "fonts/manaspc.ttf" }

    args.outputs.labels  << { x: args.grid.w.half, y: args.grid.h.half - 50,
                              text: args.state.instructions_3,
                              size_enum: 10, alignment_enum: 1,
                              r: 255, g: 200, b: 120, a: 255, font: "fonts/manaspc.ttf" }

    args.outputs.labels  << { x: args.grid.w.half, y: args.grid.h.half - 100,
                              text: args.state.instructions_4,
                              size_enum: 10, alignment_enum: 1,
                              r: 255, g: 200, b: 255, a: 255, font: "fonts/manaspc.ttf" }

    # render black menu background
    args.outputs.solids  << { x: args.state.border_corner_x, y: args.state.border_corner_y, 
                              w: args.state.border_width, h: args.state.border_height, 
                              r: 0, g: 0, b: 0, a: 200 }

    #     [ X ,  Y,    TEXT,   SIZE, ALIGN, RED, GREEN, BLUE, ALPHA, FONT STYLE]
    args.outputs.labels << [args.grid.left.shift_right(10), args.grid.bottom.shift_up(95), "Code:   https://github.com/marcoandre1/mygame", 3, 0, 255, 255, 255, 200]
    args.outputs.labels << [args.grid.left.shift_right(10), args.grid.bottom.shift_up(65), "Art:    @mobypixel (from flappy-dragon)", 3, 0, 255, 255, 255, 200]
    args.outputs.labels << [args.grid.left.shift_right(10), args.grid.bottom.shift_up(35), "Engine: DragonRuby GTK", 3, 0, 255, 255, 255, 200]

    # change the difficulty if the player hits tab
    if args.inputs.keyboard.key_down.tab
      args.state.score_win = (args.state.score_win + 10).mod(30)
      args.state.score_win = 30 if args.state.score_win == 0
      args.state.instructions_1 = "Get #{args.state.score_win} DragonRuby icons!"
    end

    # start the game if player hits enter
    if args.inputs.keyboard.key_down.enter
      score_win_memory = args.state.score_win
      $gtk.reset
      args.state.count_down = 24 * 60
      args.state.score_win = score_win_memory
      return
    end
  end

  # check if it's game over
  # otherwise render the current time left
  if game_over? args
    if args.state.score == args.state.score_win
      # render label "You win!"
      args.outputs.primitives << { x: args.grid.w.half, y: args.grid.h.half + 75,
                                   text: "Game over! You win!",
                                   size_enum: 10, alignment_enum: 1,
                                   r: 0, g: 255, b: 0, a: 255,
                                   font: "fonts/manaspc.ttf" }.label
    else
      #check if player is dead
      if args.state.player_life == 0
        args.outputs.primitives << { x: args.grid.w.half, y: args.grid.h.half + 75,
                                     text: "Game over! You are dead!",
                                     size_enum: 10, alignment_enum: 1,
                                     r: 255, g: 0, b: 0, a: 255,
                                     font: "fonts/manaspc.ttf" }.label
      else
        # render label "Game over!"
        args.outputs.primitives << { x: args.grid.w.half, y: args.grid.h.half + 75,
                                     text: "Game over! You lose!",
                                     size_enum: 10, alignment_enum: 1,
                                     r: 255, g: 0, b: 0, a: 255,
                                     font: "fonts/manaspc.ttf" }.label
      end
    end

    # render total DragonRuby icons
    args.outputs.labels  << { x: args.grid.w.half, y: args.grid.h.half + 25,
                              text: "DragonRuby icons: #{args.state.score}/#{args.state.score_win}",
                              size_enum: 10, alignment_enum: 1,
                              r: 0, g: 0, b: 255, a: 255, font: "fonts/manaspc.ttf" }

    # render label "Press [r] to start over"
    args.outputs.labels  << { x: args.grid.w.half, y: args.grid.h.half - 25,
                              text: "Press [r] to start over",
                              size_enum: 10, alignment_enum: 1,
                              r: 0, g: 200, b: 255, a: 255, font: "fonts/manaspc.ttf" }

    # render label "Press [Enter] to go back to menu"
    args.outputs.labels  << { x: args.grid.w.half, y: args.grid.h.half - 75,
                              text: "Press [Enter] to go back to menu",
                              size_enum: 10, alignment_enum: 1,
                              r: 255, g: 200, b: 255, a: 255, font: "fonts/manaspc.ttf" }
  else
    # game is not over
    # check if we are in the game menu
    if !game_menu? args and game_start? args
      # Show warning label is maximum speed is over 10
      if args.state.player_maximum_speed > 10
        args.outputs.labels  << { x: args.grid.left.shift_right(10),
                                  y: args.grid.h - 10,
                                  text: "Be careful, hitting a wall increases you maximum speed!",
                                  alignment_enum: 0, r: 255, g: 0, b: 0 }
      end

      # render the number of DragonRuby icons
      args.outputs.labels  << { x: args.grid.left.shift_right(10), y: args.grid.h - 40,
                                text: "DragonRuby icons: #{args.state.score}/#{args.state.score_win}",
                                alignment_enum: 0 }

      # show time left
      args.outputs.labels  << { x: args.grid.left.shift_right(10),
                                y: args.grid.h - 70,
                                text: "Time left: #{(args.state.count_down.idiv 60) + 1}",
                                alignment_enum: 0 }

      # show dragon life label
      args.outputs.labels  << { x: args.grid.left.shift_right(10),
                                y: args.grid.h - 100,
                                text: "Life: ",
                                alignment_enum: 0 }

      # render game background
      args.outputs.sprites << [args.state.border_corner_x, args.state.border_corner_y, args.state.border_width, args.state.border_height, 'sprites/background.png']
      args.outputs.sprites << [args.state.border_corner_x, args.state.border_corner_y, args.state.border_width, args.state.border_height, 'sprites/parallax_back.png']
      args.outputs.sprites << [args.state.border_corner_x, args.state.border_corner_y, args.state.border_width, args.state.border_height, 'sprites/parallax_middle.png']
      args.outputs.sprites << [args.state.border_corner_x, args.state.border_corner_y, args.state.border_width, args.state.border_height, 'sprites/parallax_front.png']
      if args.state.player_maximum_speed > 10
        args.outputs.sprites << [args.grid.left.shift_right(10), args.grid.h - 30, 545, 20, 'sprites/square-gray.png', 0, 200]
      end
      args.outputs.sprites << [args.grid.left.shift_right(10), args.grid.h - 60, 220, 20, 'sprites/square-gray.png', 0, 200]
      args.outputs.sprites << [args.grid.left.shift_right(10), args.grid.h - 90, 130, 20, 'sprites/square-gray.png', 0, 200]
      args.outputs.sprites << [args.grid.left.shift_right(10), args.grid.h - 120, 50, 20, 'sprites/square-gray.png', 0, 200]

      if (args.state.player.intersect_rect? args.state.guard_left) || (args.state.player.intersect_rect? args.state.guard_right)
        args.outputs.sprites << [args.grid.left.shift_right(70), args.grid.h - 120, args.state.player_life, 20, 'sprites/square-red.png', 0, 200]
        args.state.count_down_life = 4 * 60
      else
        args.outputs.sprites << [args.grid.left.shift_right(70), args.grid.h - 120, args.state.player_life, 20, 'sprites/square-green.png', 0, 200]
      end

      if args.state.count_down_life != 0
        args.state.count_down_life -= 4
        args.state.count_down_life = -1 if args.state.count_down_life < -1
        args.outputs.labels  << { x: args.grid.w.half - 10 + args.state.life_frame, y: args.grid.h.half + 10 + args.state.life_frame,
                              text: "-#{args.state.player_life}",
                              size_enum: 20, alignment_enum: 1,
                              r: 255, g: 0, b: 0, a: args.state.count_down_life, font: "fonts/manaspc.ttf" }
      end

      # render the target
      args.outputs.sprites << { x: args.state.target.x, y: args.state.target.y,
                                w: args.state.target.w, h: args.state.target.h,
                                path: 'sprites/icon.png' }

      # render the left guard
      args.outputs.sprites << { x: args.state.guard_left.x, y: args.state.guard_left.y,
                                w: args.state.guard_left.w, h: args.state.guard_left.h,
                                path: "sprites/guard-HD-#{args.state.guard_frame}.png" }

      # render the left guard
      args.outputs.sprites << { x: args.state.guard_right.x, y: args.state.guard_right.y,
                                w: args.state.guard_right.w, h: args.state.guard_right.h,
                                path: "sprites/guard-HD-#{args.state.guard_frame}.png" }

      args.outputs.sprites << { x: 200, y: 200,
                                w: 100, h: 100,
                                path: "sprites/mini-dragon.png" }

      args.outputs.sprites << { x: 400, y: 400,
                                w: 100, h: 100,
                                path: "sprites/heart.png" }

      args.outputs.sprites << { x: 500, y: 200,
                                w: 75, h: 75,
                                path: "sprites/clock.png" }
    end
  end

  # render the game border
  args.outputs.borders << { x: args.state.border_corner_x, 
                            y: args.state.border_corner_y,
                            w: args.state.border_width,
                            h: args.state.border_height, 
                            r: 0, 
                            g: 0, 
                            b: 0 }

  # ====================================================
  # run simulation
  # ====================================================
  # if we are not in the game menu, decrease count_down
  if !game_menu? args
    # count down calculation
    # if you look at the label "time left" we are doing a full division of the countdown:
    #   args.state.count_down.idiv 60
    # which means that we are dividing the count_down by 60 at every frame and getting the integer portion
    # 1150/60 = 19
    # 1130/60 = 18
    args.state.count_down -= 1
    args.state.count_down = -1 if args.state.count_down < -1
  end

  # ====================================================
  # process player input
  # ====================================================
  # if it isn't game over and the game has started let them move (0 > args.state.count_down <= 20 * 60)
  if !game_over? args and game_start? args
    # collision with a wall will make the guard bounce back
    if args.state.guard_left.y < args.state.border_corner_y
      args.state.guard_left_y *= -1
    elsif args.state.guard_left.y > args.grid.h - args.state.guard_height - args.state.border_corner_y
      args.state.guard_left_y *= -1
    end

    # collision with a wall will make the guard bounce back
    if args.state.guard_right.y < args.state.border_corner_y
      args.state.guard_right_y *= -1
    elsif args.state.guard_right.y > args.grid.h - args.state.guard_height - args.state.border_corner_y
      args.state.guard_right_y *= -1
    end

    # collision with a wall will make the player bounce and increase maximum speed by one
    if args.state.player.x < args.state.border_corner_x
      args.state.dir_x *= -1
      args.state.player_maximum_speed += 1
    elsif args.state.player.x > args.grid.w - args.state.player_width - args.state.border_corner_x
      args.state.dir_x *= -1
      args.state.player_maximum_speed += 1
    end

    # collision with a wall will make the player bounce and increase maximum speed by one
    if args.state.player.y < args.state.border_corner_y
      args.state.dir_y *= -1
      args.state.player_maximum_speed += 1
    elsif args.state.player.y > args.grid.h - args.state.player_height - args.state.border_corner_y
      args.state.dir_y *= -1
      args.state.player_maximum_speed += 1
    end

    # game is not over but
    # check if we are in the game menu
    if !game_menu? args
      # determine the change vertically
      if args.inputs.keyboard.up && args.state.dir_y < args.state.player_maximum_speed 
        args.state.dir_y += args.state.player_speed
      elsif args.inputs.keyboard.down && args.state.dir_y > -args.state.player_maximum_speed
        args.state.dir_y -= args.state.player_speed
      end

      # determine the change horizontally
      if args.inputs.keyboard.left && args.state.dir_x > -args.state.player_maximum_speed
        args.state.dir_x -= args.state.player_speed
      elsif args.inputs.keyboard.right && args.state.dir_x < args.state.player_maximum_speed
        args.state.dir_x += args.state.player_speed
      end
    end

    # change the direction of the dragon according to his direction
    if args.state.dir_x < 0
      args.outputs.sprites << { x: args.state.player.x,
                                y: args.state.player.y,
                                w: args.state.player.w,
                                h: args.state.player.h,
                                path: "sprites/dragon-left-#{args.state.sprite_frame}.png" }
    elsif args.state.dir_x > 0
      args.outputs.sprites << { x: args.state.player.x,
                                y: args.state.player.y,
                                w: args.state.player.w,
                                h: args.state.player.h,
                                path: "sprites/dragon-right-#{args.state.sprite_frame}.png" }
    else
      args.outputs.sprites << { x: args.state.player.x,
                                y: args.state.player.y,
                                w: args.state.player.w,
                                h: args.state.player.h,
                                path: "sprites/dragon-right-#{args.state.sprite_frame}.png" }
    end

    # apply change to left and the right guard
    args.state.guard_left.y  += args.state.guard_left_y
    args.state.guard_right.y += args.state.guard_right_y

    # apply change to player
    args.state.player.x += args.state.dir_x
    args.state.player.y += args.state.dir_y
  else
    # args.state.count_down is inferior to 0 and greater than 20 * 60
    # check if game over (means args.state.count_down < 0)
    if game_over? args
      # render game over background
      args.outputs.sprites << [args.state.border_corner_x, args.state.border_corner_y, args.state.border_width, args.state.border_height, 'sprites/background.png']
      args.outputs.sprites << [args.state.border_corner_x, args.state.border_corner_y, args.state.border_width, args.state.border_height, 'sprites/parallax_back.png']
      args.outputs.sprites << [args.state.border_corner_x, args.state.border_corner_y, args.state.border_width, args.state.border_height, 'sprites/parallax_middle.png']
      args.outputs.sprites << [args.state.border_corner_x, args.state.border_corner_y, args.state.border_width, args.state.border_height, 'sprites/parallax_front.png']
      args.outputs.sprites << [args.state.border_corner_x, args.state.border_corner_y, args.state.border_width, args.state.border_height, 'sprites/square-gray.png', 0, 128]

      # keep the dragon flying in the good direction when game over
      if args.state.dir_x < 0
        # check if dead
        if args.state.player_life == 0
          args.outputs.sprites << { x: args.state.player.x,
                                    y: args.state.player.y,
                                    w: args.state.player.w,
                                    h: args.state.player.h,
                                    path: "sprites/dragon_die_left.png" }
        else
          args.outputs.sprites << { x: args.state.player.x,
                                    y: args.state.player.y,
                                    w: args.state.player.w,
                                    h: args.state.player.h,
                                    path: "sprites/dragon-left-#{args.state.sprite_frame}.png" }
        end
      else
        # check if dead
        if args.state.player_life == 0
          args.outputs.sprites << { x: args.state.player.x,
                                    y: args.state.player.y,
                                    w: args.state.player.w,
                                    h: args.state.player.h,
                                    path: "sprites/dragon_die_right.png" }
        else
          args.outputs.sprites << { x: args.state.player.x,
                                    y: args.state.player.y,
                                    w: args.state.player.w,
                                    h: args.state.player.h,
                                    path: "sprites/dragon-right-#{args.state.sprite_frame}.png" }
        end
      end

      # if r is pressed, reset the game
      # else if enter is pressed, return to game menu
      if args.inputs.keyboard.key_down.r
        score_win_memory = args.state.score_win
        $gtk.reset
        args.state.count_down = 20 * 60
        args.state.score_win = score_win_memory
        return
      elsif args.inputs.keyboard.key_down.enter
        score_win_memory = args.state.score_win
        $gtk.reset
        args.state.count_down = 25 * 60
        args.state.score_win = score_win_memory
        return
      end
    else
      # game is not over
      # check if we are in game prelude (means args.state.count_down between 20 and 25)
      if game_prelude? args
        # render prelude background
        args.outputs.sprites << [args.state.border_corner_x, args.state.border_corner_y, args.state.border_width, args.state.border_height, 'sprites/D4yFN_XWsAAy7WZ.jpg']

        # render label "Game loading!"
        args.outputs.primitives << { x: args.grid.w.half, y: args.grid.h.half + 75,
                                   text: "Game loading!",
                                   size_enum: 10, alignment_enum: 1,
                                   r: 0, g: 255, b: 0, a: 255,
                                   font: "fonts/manaspc.ttf" }.label

        # show count down to start game
        args.outputs.labels  << { x: args.grid.w.half,
                                  y: args.grid.h - 70,
                                  size_enum: 10,
                                  text: "#{((args.state.count_down.idiv 60) + 1) - 21}",
                                  alignment_enum: 0,
                                  font: "fonts/manaspc.ttf" }
      end
    end
  end

  # ====================================================
  # determine score
  # ====================================================

  # calculate new score if the player is at goal
  if !game_over? args and game_start? args
    # if the player is at the goal, then move the goal
    if args.state.player.intersect_rect? args.state.target
      # increment the goal
      args.state.score += 1

      # check if win else keep giving random DragonRuby icons
      if args.state.score == args.state.score_win
        args.state.count_down = 0
      else
        # random coordinates for target
        args.state.target_x = args.state.border_corner_x + (rand (args.state.border_width - args.state.player_width))
        args.state.target_y = args.state.border_corner_y + (rand (args.state.border_height - args.state.player_height))

        # move the goal to a random location
        args.state.target = { x: (args.state.target_x), y: (args.state.target_y), w: args.state.target_width, h: args.state.target_height }
      end
    end

    # if the player hits the left guard
    if args.state.player.intersect_rect? args.state.guard_left
      # increment the goal
      args.state.player_life -= 1

      # check if dead
      if args.state.player_life == 0
        args.state.count_down = 0
      end
    end

    # if the player hits the right guard
    if args.state.player.intersect_rect? args.state.guard_right
      # increment the goal
      args.state.player_life -= 1

      # check if dead
      if args.state.player_life == 0
        args.state.count_down = 0
      end
    end
  end
end

def game_over? args
  args.state.count_down < 0
end

def game_menu? args
  args.state.count_down == 25 * 60
end

def game_start? args
  args.state.count_down <= 20 * 60
end

def game_prelude? args
  args.state.count_down < 25 * 60
end

$gtk.reset
