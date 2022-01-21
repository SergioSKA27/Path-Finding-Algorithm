require 'ruby2d'

set diagnostics: true

set title: "MAZE :)"
set background: "black"
set resizable: true

set width: 1900
set height: 1000 

COLORS = %w{'navy' 'blue' 'aqua' 'teal' 'olive'  'green' 'lime' 
'yellow' 'orange' 'red' 'brown' 'fuchsia' 'purple' 'maroon' 
'white' 'silver' 'gray' 'black'}




=begin
    Made by: Sergio Lopez Martinez
    Hi folks :), I made this implementation just for fun 
    feel free to change any part of the code, I hope this 
    code result usefull for some that need it, especialy 
    for those estudents of graph theory.
=end

class Cell

    attr_accessor :y_pos , :x_pos
    attr_accessor :distance , :father, :father_b 
    attr_accessor :visited , :explored,:txplore, :shape

    def initialize(x, y, size, color)
        @y_pos = y
        @x_pos = x
        @shape = Square.new(
            x: @x_pos, y: @y_pos,
            size:  size, color: color.to_s,
            z: 10
        )

        @visited = nil
        @father = nil 
        @father_b = nil
        @explored = 0
        @txplore = nil
        @distance = Float::INFINITY
    end


    def mark_w()
        @shape.color = 'white'
        @visited = 3
    end

    def mark_y()
        @shape.color = 'yellow'
        @visited = 2
    end

    def mark_o()
        @shape.color = 'olive'
        
    end


    def mark_g()
        @shape.color = 'green'
    end

    def mark_l()
        @shape.color = 'lime'
    end


end


#x = Cell.new(0,0, 15,'white')


rows = 95
coloumns = 180
grid = []
xstep = 0
ystep = 0
s = 1

if (rows*coloumns <= 30**2)
    s = 30
elsif (rows*coloumns <= 50**2)
    s = 20
elsif (rows * coloumns <= 75**2)
    s = 15
else 
    s = 10
end

#Make a two dimensional array, each position is a Cell
for i in 0...rows do
    r = []
    xaux = xstep
    for j in 0...coloumns do
        n = Cell.new(xaux,ystep,s,'black')
        r.append(n)
        xaux += s
    end
    grid.append(r)
    ystep += s
end
#v = Text.new((x.x_pos).to_s + (x.y_pos).to_s, x: 100,
#y: 100 , color: 'blue', z: 10)

# x, y           left rigth up down 
DIRECTIONS = [ [0,2],[0,-2],[2,0], [-2, 0]]

DIRECTIONS_walls = [ [0,1],[0,-1],[1,0], [-1, 0]]




start = [1,1]
ned = [10,10]
on :key_down do |event|

    if(event.key == 'g')
    #Generate Maze with random DFS 
        stack = []
        stack << [1,1]
        grid[1][1].mark_y

        gen = true
        update do 
            
            if gen  and !stack.empty? then
                current = stack.pop
                dir = DIRECTIONS.dup
                dir.shuffle!
            
                for i in 0...4 do
                
                    if(current[0] + dir[i][0] >= 1 and current[0] + dir[i][0] <= rows-2)
                        if (current[1] + dir[i][1] >= 1 and current[1] + dir[i][1] <= coloumns-2)
                        
                            if grid[current[0]+ dir[i][0]][current[1]+dir[i][1]].visited == nil then 
                                grid[current[0]+ dir[i][0]][current[1]+dir[i][1]].mark_y
                                grid[current[0]+ dir[i][0]][current[1]+dir[i][1]].father = current

                                if dir[i][0] == 2 and dir[i][1] == 0 and current[0]+1 < rows-1 then
                                    #up wall
                                    grid[current[0]+1][current[1]].mark_w
                                end


                                if dir[i][0] == -2 and dir[i][1] == 0 and current[0]-1 >= 1 then
                                    #down wall
                                    grid[current[0]-1][current[1]].mark_w
                                end


                                if dir[i][1] == 2 and dir[i][0] == 0 and current[1]+1 < coloumns-1 then
                                    #left wall
                                    grid[current[0]][current[1]+1].mark_w
                                end


                                if dir[i][1] == -2 and dir[i][0] == 0 and current[1]-1 >= 1 then
                                    #right wall
                                    grid[current[0]][current[1]-1].mark_w
                                end

                                stack << [current[0]+ dir[i][0],current[1]+dir[i][1]]

                                #sleep(10)
                            end

                        end

                    end

                end

                grid[current[0]][current[1]].mark_w

                if stack.empty? 
                    gen = false
                end
            end
        
        end
        
    
    end

    if(event.key == 'h')
        #Generate Maze with backtracking 
        stack = []
        stack << [1,1]
        grid[1][1].mark_y
        flag = true
        current = [1,1]

        gen = true
        update do 
            
            if gen  and !stack.empty? then
                dir = DIRECTIONS.dup
                dir.shuffle!
                f  = false
            
                for i in 0...4 do
                
                    if(current[0] + dir[i][0] >= 1 and current[0] + dir[i][0] <= rows-2)
                        if (current[1] + dir[i][1] >= 1 and current[1] + dir[i][1] <= coloumns-2)
                        
                            if grid[current[0]+ dir[i][0]][current[1]+dir[i][1]].visited == nil then 
                                grid[current[0]+ dir[i][0]][current[1]+dir[i][1]].mark_y
                                grid[current[0]+ dir[i][0]][current[1]+dir[i][1]].father = current

                                if dir[i][0] == 2 and dir[i][1] == 0 and current[0]+1 < rows-1 then
                                    #up wall
                                    grid[current[0]+1][current[1]].mark_w
                                end


                                if dir[i][0] == -2 and dir[i][1] == 0 and current[0]-1 >= 1 then
                                    #down wall
                                    grid[current[0]-1][current[1]].mark_w
                                end


                                if dir[i][1] == 2 and dir[i][0] == 0 and current[1]+1 < coloumns-1 then
                                    #left wall
                                    grid[current[0]][current[1]+1].mark_w
                                end


                                if dir[i][1] == -2 and dir[i][0] == 0 and current[1]-1 >= 1 then
                                    #right wall
                                    grid[current[0]][current[1]-1].mark_w
                                end

                                stack << [current[0]+ dir[i][0],current[1]+dir[i][1]]

                                #sleep(10)
                                f = true
                                break
                            end

                        end

                    end
    
                end
    
                grid[current[0]][current[1]].mark_w

                if f 
                    current = stack[-1]
                else
                    stack.pop
                    current = stack[-1]
                    if current then 
                        grid[current[0]][current[1]].mark_l
                    end
                end
    
                if stack.empty? 
                    gen = false
                end
            end
            
        end
            
    end

    if(event.key == 'b')
    #BFS
        queue = []
        queue.unshift start
        grid[start[0]][start[1]].mark_g
        grid[start[0]][start[1]].distance = 0
        grid[start[0]][start[1]].explored = 1

        gen = true
        update do 
            
            if gen  and !queue.empty? then
                current = queue.pop
                dir = DIRECTIONS_walls.dup
            
                for i in 0...4 do
                
                    if(current[0] + dir[i][0] >= 1 and current[0] + dir[i][0] <= rows-2)
                        if (current[1] + dir[i][1] >= 1 and current[1] + dir[i][1] <= coloumns-2)
                        
                            if grid[current[0]+ dir[i][0]][current[1]+dir[i][1]].explored == 0 and grid[current[0]+ dir[i][0]][current[1]+dir[i][1]].visited != nil then 
                                grid[current[0]+ dir[i][0]][current[1]+dir[i][1]].distance = grid[current[0]][current[1]].distance + 1
                                grid[current[0]+ dir[i][0]][current[1]+dir[i][1]].father = current

                                if [current[0]+ dir[i][0],current[1]+dir[i][1]] == ned 
                                    gen = false
                                    grid[current[0]+ dir[i][0]][current[1]+dir[i][1]].mark_l
                                end

                                grid[current[0]+ dir[i][0]][current[1]+dir[i][1]].explored = 1
                                grid[current[0]+ dir[i][0]][current[1]+dir[i][1]].mark_y
                                queue.unshift [current[0]+ dir[i][0],current[1]+dir[i][1]]
                            end

                        end

                    end

                end

                grid[current[0]][current[1]].mark_o
                grid[current[0]][current[1]].explored = 2

                if queue.empty?
                    gen = false
                end
            end
        
        end
        
    
    end

    if(event.key == 'd')
    #DFS
        queue = []
        queue <<  start
        grid[start[0]][start[1]].mark_g
        grid[start[0]][start[1]].distance = 0
        grid[start[0]][start[1]].explored = 1

        gen = true
        update do 
            
            if gen  and !queue.empty? then
                current = queue.pop
                dir = DIRECTIONS_walls.dup
            
                for i in 0...4 do
                
                    if(current[0] + dir[i][0] >= 1 and current[0] + dir[i][0] <= rows-2)
                        if (current[1] + dir[i][1] >= 1 and current[1] + dir[i][1] <= coloumns-2)
                        
                            if grid[current[0]+ dir[i][0]][current[1]+dir[i][1]].explored == 0 and grid[current[0]+ dir[i][0]][current[1]+dir[i][1]].visited != nil then 
                                grid[current[0]+ dir[i][0]][current[1]+dir[i][1]].distance = grid[current[0]][current[1]].distance + 1
                                grid[current[0]+ dir[i][0]][current[1]+dir[i][1]].father = current

                                if [current[0]+ dir[i][0],current[1]+dir[i][1]] == ned 
                                    gen = false
                                    grid[current[0]+ dir[i][0]][current[1]+dir[i][1]].mark_l
                                end

                                grid[current[0]+ dir[i][0]][current[1]+dir[i][1]].explored = 1
                                grid[current[0]+ dir[i][0]][current[1]+dir[i][1]].mark_y
                                queue << [current[0]+ dir[i][0],current[1]+dir[i][1]]
                            end

                        end

                    end

                end

                grid[current[0]][current[1]].mark_o
                grid[current[0]][current[1]].explored = 2

                if queue.empty?
                    gen = false
                end
            end
        
        end
        
    
    
    
    end

    if (event.key == 'c')
    #Clear any object on window
        clear
    end


    if (event.key == 'q')
    #This part shows the generated tree by any of the algorithms(BFS, DFS & Maze Generation)
        i = 1
        j = 1

        update do
        
            if(i < rows-1 && j < coloumns-1 && grid[i][j].father != nil)
                grid[i][j].shape.opacity = 0
                f = grid[i][j].father
                aux = Line.new(x1: (grid[i][j].shape.x / 2).to_i, y1: (grid[i][j].shape.y  / 2 ).to_i, 
                x2:( grid[f[0]][f[1]].shape.x / 2 ).to_i, y2: (grid[f[0]][f[1]].shape.y / 2).to_i, 
                width: 5, color: 'red', z: 100)
            end

            
            #if (i < rows-1 && j < coloumns-1) then grid[i][j].mark_o end
            j+= 1

            if j == coloumns-2
                j = 1
                i += 1
            end
        end
    end 

    if (event.key == 'n')
    #Generates a new grid if the last was deleted
        grid = []
        xstep = 0
        ystep = 0
        #Creamos un array bidimensional de nodos que funcionara como tablero para los laberintos
        for i in 0...rows do
            r = []
            xaux = xstep
            for j in 0...coloumns do
                n = Cell.new(xaux,ystep,s,'black')
                r.append(n)
                xaux += s
            end
            grid.append(r)
            ystep += s
        end
    end

end


show
