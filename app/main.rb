# full documenation is at http://docs.dragonruby.org
# be sure to come to the discord if you hit any snags: http://discord.dragonruby.org
def tick args
  # ====================================================
  # initialize default variables
  # ====================================================

  # ruby has an operator called ||= which means "only initialize this if it's nil"
  args.state.count_down   ||= 20 * 60 # set the count down to 20 seconds
  # the game renders in 60 fps: 20s * 60fps = 1200 frames

  # set the width and the height of the target
  args.state.target_width ||= 100
  args.state.target_height ||= 100

  # set the initial position of the target
  args.state.target       ||= { x: args.grid.w.half - args.state.target_width / 2,
                                y: args.grid.h.half - args.state.target_height / 2,
                                w: args.state.target_width,
                                h: args.state.target_height }

  # set the width and the height of the player
  args.state.player_width ||= 100
  args.state.player_height ||= 100

  # set the initial position of the player
  args.state.player       ||= { x: 250,
                                y: 250,
                                w: args.state.player_width,
                                h: args.state.player_height }

  # set the player movement speed
  args.state.player_speed ||= 1

  # set the player maxium speed
  args.state.player_maximum_speed ||= 10

  # set the score
  args.state.score        ||= 0

  # set the instructions
  args.state.instructions ||= "Get to the red goal! Use arrow keys to move."

  # sprite frame
  args.state.sprite_frame = args.state.tick_count.idiv(4).mod(6)

  # set direction speed
  args.state.dir_x ||= 0
  args.state.dir_y ||= 0

  # border specs
  args.state.border_corner_x ||= 5
  args.state.border_corner_y ||= 5
  args.state.border_width ||= args.grid.w - 2 * args.state.border_corner_x
  args.state.border_height ||= args.grid.h - 2 * args.state.border_corner_y

  # random coordinates for target
  args.state.target_x ||= args.state.border_corner_x + (rand (args.state.border_width - args.state.player_width))
  args.state.target_y ||= args.state.border_corner_y + (rand (args.state.border_height - args.state.player_height))

  # ====================================================
  # render the game
  # ====================================================
  args.outputs.labels  << { x: args.grid.w.half, y: args.grid.h - 120,
                            text: "args.state.tick_count: #{args.state.tick_count}",
                            alignment_enum: 1 }

  args.outputs.labels  << { x: args.grid.w.half, y: args.grid.h - 100,
                            text: args.state.sprite_frame,
                            alignment_enum: 1 }

  args.outputs.labels  << { x: args.grid.w.half, y: args.grid.h - 10,
                            text: args.state.instructions,
                            alignment_enum: 1 }

  args.outputs.labels  << { x: args.grid.w.half, y: args.grid.h - 140,
                            text: "args.state.border_height: #{args.state.border_height}",
                            alignment_enum: 1 }

  args.outputs.labels  << { x: args.grid.w.half, y: args.grid.h - 160,
                            text: "rand args.state.border_width: #{args.state.target_x}",
                            alignment_enum: 1 }

  # check if it's game over. if so, then render game over
  # otherwise render the current time left
  if game_over? args
    args.outputs.labels  << { x: args.grid.w.half,
                              y: args.grid.h - 40,
                              text: "game over! (press r to start over)",
                              alignment_enum: 1 }
                              
    args.outputs.labels  << { x: args.grid.w.half,
                              y: args.grid.h - 200,
                              text: "time left: #{(args.state.count_down.idiv 60) + 1}",
                              alignment_enum: 1 }
  else
    args.outputs.labels  << { x: args.grid.w.half,
                              y: args.grid.h - 40,
                              text: "time left: #{(args.state.count_down.idiv 60) + 1}",
                              alignment_enum: 1 }
  end

  # render the score
  args.outputs.labels  << { x: args.grid.w.half,
                            y: args.grid.h - 70,
                            text: "score: #{args.state.score}",
                            alignment_enum: 1 }

  # render the target
  args.outputs.sprites << { x: args.state.target.x,
                            y: args.state.target.y,
                            w: args.state.target.w,
                            h: args.state.target.h,
                            path: 'sprites/icon.png' }

  # render the border
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

  # count down calculation
  # substract one to 
  args.state.count_down -= 1
  args.state.count_down = -1 if args.state.count_down < -1

  # ====================================================
  # process player input
  # ====================================================
  # if it isn't game over let them move
  if !game_over? args

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

    # apply change to player
    args.state.player.x += args.state.dir_x
    args.state.player.y += args.state.dir_y
  else
    args.outputs.solids << { x: args.state.border_corner_x, 
                            y: args.state.border_corner_y, 
                            w: args.state.border_width, 
                            h: args.state.border_height, 
                            r: 0, 
                            g: 0, 
                            b: 0,
                            a: 128 }

    # keep the dragon flying in the good direction when game over
    if args.state.dir_x < 0
      args.outputs.sprites << { x: args.state.player.x,
                                y: args.state.player.y,
                                w: args.state.player.w,
                                h: args.state.player.h,
                                path: "sprites/dragon-left-#{args.state.sprite_frame}.png" }
    else
      args.outputs.sprites << { x: args.state.player.x,
                                y: args.state.player.y,
                                w: args.state.player.w,
                                h: args.state.player.h,
                                path: "sprites/dragon-right-#{args.state.sprite_frame}.png" }
    end

    # if r is pressed, reset the game
    if args.inputs.keyboard.key_down.r
      $gtk.reset
      return
    end
  end

  # ====================================================
  # determine score
  # ====================================================

  # calculate new score if the player is at goal
  if !game_over? args

    # if the player is at the goal, then move the goal
    if args.state.player.intersect_rect? args.state.target
      # increment the goal
      args.state.score += 1

      # random coordinates for target
      args.state.target_x = args.state.border_corner_x + (rand (args.state.border_width - args.state.player_width))
      args.state.target_y = args.state.border_corner_y + (rand (args.state.border_height - args.state.player_height))

      # move the goal to a random location
      args.state.target = { x: (args.state.target_x), y: (args.state.target_y), w: args.state.target_width, h: args.state.target_height }
    end
  end
end

def game_over? args
  args.state.count_down < 0
end

$gtk.reset
