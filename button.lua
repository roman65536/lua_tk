--require "bit"
ltk = require "ltk"
--mqttclient = require("luamqttc/client")

--img = ltk.image{'create','photo',format=PNG,file='test.png'}
--img = ltk.image{'create','photo'}
--ccmd=ltk.wcmd(img)
--ccmd{'read','test.png',format='png'}

function print_table(node)
    local cache, stack, output = {},{},{}
    local depth = 1
    local output_str = "{\n"

    while true do
        local size = 0
        for k,v in pairs(node) do
            size = size + 1
        end

        local cur_index = 1
        for k,v in pairs(node) do
            if (cache[node] == nil) or (cur_index >= cache[node]) then

                if (string.find(output_str,"}",output_str:len())) then
                    output_str = output_str .. ",\n"
                elseif not (string.find(output_str,"\n",output_str:len())) then
                    output_str = output_str .. "\n"
                end

                -- This is necessary for working with HUGE tables otherwise we run out of memory using concat on huge strings
                table.insert(output,output_str)
                output_str = ""

                local key
                if (type(k) == "number" or type(k) == "boolean") then
                    key = "["..tostring(k).."]"
                else
                    key = "['"..tostring(k).."']"
                end

                if (type(v) == "number" or type(v) == "boolean") then
                    output_str = output_str .. string.rep('\t',depth) .. key .. " = "..tostring(v)
                elseif (type(v) == "table") then
                    output_str = output_str .. string.rep('\t',depth) .. key .. " = {\n"
                    table.insert(stack,node)
                    table.insert(stack,v)
                    cache[node] = cur_index+1
                    break
                else
                    output_str = output_str .. string.rep('\t',depth) .. key .. " = '"..tostring(v).."'"
                end

                if (cur_index == size) then
                    output_str = output_str .. "\n" .. string.rep('\t',depth-1) .. "}"
                else
                    output_str = output_str .. ","
                end
            else
                -- close the table
                if (cur_index == size) then
                    output_str = output_str .. "\n" .. string.rep('\t',depth-1) .. "}"
                end
            end

            cur_index = cur_index + 1
        end

        if (size == 0) then
            output_str = output_str .. "\n" .. string.rep('\t',depth-1) .. "}"
        end

        if (#stack > 0) then
            node = stack[#stack]
            stack[#stack] = nil
            depth = cache[node] == nil and depth + 1 or depth - 1
        else
            break
        end
    end

    -- This is necessary for working with HUGE tables otherwise we run out of memory using concat on huge strings
    table.insert(output,output_str)
    output_str = table.concat(output)

    print(output_str)
end


a=0

function update(win, c )
--bit1=bit.lshift(1,c)
bit1=c<<1
-- print(" On was pressed " ..a.." "..c.." bit"..bit1)
-- ltk.wcmd(b){'configure',state='active'}
if((a & bit1) == 0 ) then
 --ltk.wcmd(win){'configure',relief='sunken'}
print(type(win))
 --win:configure {relief='sunken'} 
 win.text=c..' ON'
 --ltk.wcmd(win){'configure',text=c..' ON'}
 --print( acl:publish("inTopic/"..c,"on"))
 a=a ^ bit1
 else
 --win:configure {relief='sunken'}
 win.text=c..' OFF'
 --ltk.wcmd(win){'configure',relief='raised'}
 --ltk.wcmd(win){'configure',text=c..' OFF'}
 --print(acl:publish("inTopic/"..c,"off"))
 a=a^bit1
end
 print(" On was pressed " ..a.." "..c.." bit"..bit1)
 --print(acl)
end


nn1=ltk.labelframe{text="Relay"}
nn=ltk.frame(nn1){}
b=ltk.button(nn){text='0 OFF', }
b.command=update(b,0) 
print(type(b))
c=ltk.button(nn){text='1 OFF'}
d=ltk.button(nn){text='2 OFF'}
e=ltk.button(nn){text='3 OFF'}



nn2=ltk.labelframe{text="Switches"}
sw1=ltk.button(nn2){text='Switch OFF'}

nn3=ltk.labelframe{text="Temperature"}
canvas=ltk.canvas(nn3){background='white',width=200,height=200}
--ccmd=ltk.wcmd(canvas)
--ccmd{'create','arc', 50,50,60,60, start=120,extent=300,style='arc'}
--ccmd{'create','line',53,51,53,30}
--ccmd{'create','line',57,51,57,30}
canvas:create_arc { 50,50,60,60, start=120,extent=300,style='arc'}
canvas:create_line { 53,51,53,30}
canvas:create_line { 53,51,53,30}

nn4=ltk.labelframe{text="Picture"}
canvas1=ltk.canvas(nn4){width=200,height=200 }
--ccmd=ltk.wcmd(canvas1)
--ccmd{'create','image',0,0, image=img, anchor='nw'}




--acl=mqttclient.new("Roman's Test")
--acl:connect("192.168.1.100",1883,{timeout=3600})



function temp_draw(win,x,y,size)
--ccmd=ltk.wcmd(win)
--ccmd{'create','arc', x,y,x+size,y+size, start=120,extent=300,style='arc'}
--ccmd{'create','line',x+(size*.25),y+(size*.1),x+(size*.25),y-(size*2)}
--ccmd{'create','line',x+size-(size*.25),y+(size*.1),x+size-(size*.25),y-(size*2)}
--ccmd{'create','line',x+size-(size*.25),y-(size*2),x+(size*.25),y-(size*2)}

--ccmd{'create','arc',x+(size*.1),y+(size*.1),x+size-(size*.1),y+size-(size*.1), start=120,extent=300,style='chord',fill='red',}
--ccmd{'create','rectangle',x+(size*.31),y+size*.25,x+size-(size*.3),y-(size*.17),fill='red',outline='red'}

end

temp_draw(canvas,100,150,50)



sw_b=0

function update1(win, c )
bit1=bit.lshift(1,c)
-- print(" On was pressed " ..a.." "..c.." bit"..bit1)
-- ltk.wcmd(s){'configure',state='active'}
if(bit.band(sw_b,bit1) == 0 ) then
 ltk.wcmd(win){'configure',relief='sunken'}
 ltk.wcmd(win){'configure',text='Switch ON'}
 --acl:publish("cmnd/DVES_1C66BD/light","on")
 sw_b=bit.bxor(sw_b,bit1)
 else
 ltk.wcmd(win){'configure',relief='raised'}
 ltk.wcmd(win){'configure',text='Switch OFF'}
 --acl:publish("cmnd/DVES_1C66BD/light","off")
 sw_b=bit.bxor(sw_b,bit1)
end
 print(" On was pressed " ..sw_b.." "..c.." bit"..bit1)
end


--ltk.wcmd(b){'configure',command={ update ,b, 0}}
b.configure( b )
b.command = update(b,0)
--b.configure( b ,{command, update(b,0) })
--b.configure( b )
--ltk.wcmd(c){'configure',command= {update,c,  1}}
--ltk.wcmd(d){'configure',command= {update,d,  2}}
--ltk.wcmd(e){'configure',command= {update,e,  3}}

--ltk.wcmd(sw1){'configure',command= {update1,sw1,  0}}

ltk.pack{b,c,d,e , side='top'}
ltk.pack{sw1 , side='top'}

ltk.pack{canvas}
ltk.pack{canvas1}

ltk.pack{nn}
ltk.pack{nn1,nn2,nn3,nn4, side='left'}


while (1) do
--acl:message_loop(.1)
ltk.update()
end


ltk.mainloop()


