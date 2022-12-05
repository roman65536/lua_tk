

require "lxit"
ltk = require "ltk"


fl={}
gout=nil
idx=1


mes_method=mes_vce
plot_method=nil

function sleep(n)
  os.execute("sleep ".. n)
  end

dso={}


function connect()
print("connect \n")
-- Connect to instruments
--dso = connect_raw("192.168.2.3")
dso = connectl("192.168.2.3",5025,"ints0",2000,"RAW")
print("dso =" .. dso)

-- Print instrument IDs
dso_id = scpi(dso, "*IDN?\n")
print("ID = " .. dso_id)

scpi(dso,"INST OUT1\n")
--scpi(dso,"APPLY \"1,.001\" \n")
scpi(dso,"CURR .001 \n")
scpi(dso,"VOLT 1 \n")
scpi(dso,"OUTP ON\n")

scpi(dso,"INST OUT2\n")
--scpi(dso,"APPLY \"0,2\" \n")
scpi(dso,"CURR 2 \n")
scpi(dso,"VOLT 0 \n")
scpi(dso,"OUTP ON\n")

end



function mess_ice(file)
print("mess_ice")
scpi(dso,"DISP:WIND:TEXT:CLEAR \n")
gout:write("set title \"Hfe Characteristic\"\n ")
gout:write("set xlabel 'Ib (A)'\n")
gout:write("set ylabel 'Ice (A)'\n")
gout:write("set y2label 'Hfe'\n")
gout:write("set y2tics \n")

gout:write("set grid\n")

scpi(dso,"INST OUT1\n")
--scpi(dso,"APPLY \"1,.001\" \n")
scpi(dso,"CURR .000 \n")
scpi(dso,"VOLT 1.5 \n")
scpi(dso,"OUTP ON\n")


scpi(dso,"INST OUT2\n")
command=string.format( "VOLT %.3f\n",20.0)

dso_id= scpi(dso, command)
scpi(dso,"CURR 5 \n")
scpi(dso,"OUTP ON\n")

for ib= 0.005,0.1,.005 do

scpi(dso,"INST OUT1\n")
--setcur=string.format("APPLY \"1,%0.3f\" \n",ib)
setcur=string.format("CURR %0.3f\n",ib)
--print(setcur)
dso_id=scpi(dso,setcur)

	   sleep(.5)
scpi(dso,"INST OUT2\n")
cur=tonumber(scpi(dso, "MEAS:CURR?\n"))

print(string.format("%.3f %.3f\n",tonumber(ib),tonumber(cur)))

file:write(string.format("%.3f %.3f\n",tonumber(ib),tonumber(cur)))
file:flush()
update_gnuplot()

	end

scpi(dso,"VOLT 0 \n")
scpi(dso,"APPLY 0,0 \n")
scpi(dso,"INST OUT1\n")
scpi(dso,"VOLT 0 \n")
scpi(dso,"APPLY 0,0 \n")
scpi(dso,"OUTP:GEN 0\n")
scpi(dso,"DISP:WIND:TEXT:DATA \"Messung ist fertig!! \" \n")

disconnect(dso)
file:close()

end

function mess_id(file)
print("mess_id")

scpi(dso,"DISP:WIND:TEXT:CLEAR \n")

gout:write("set title \"Diode Forward Current Characteristic\"\n ")
gout:write("set ylabel 'Ika (A)'\n")
gout:write("set xlabel 'Vka (V)'\n")
gout:write("set grid\n")


scpi(dso,"INST OUT1\n")
--scpi(dso,"APPLY \"1,.001\" \n")
scpi(dso,"CURR 2.000 \n")
scpi(dso,"VOLT 0 \n")
scpi(dso,"OUTP ON\n")


for vka= 0.1,1,.01 do

scpi(dso,"INST OUT1\n")

setcur=string.format("VOLT %0.3f\n",vka)
dso_id=scpi(dso,setcur)

	   sleep(.5)
cur=tonumber(scpi(dso, "MEAS:CURR?\n"))
vmes=tonumber(scpi(dso, "MEAS:VOLT?\n"))

print(string.format("%.3f %.3f\n",tonumber(vmes),tonumber(cur)))

file:write(string.format("%.3f %.3f\n",tonumber(vmes),tonumber(cur)))
file:flush()
update_gnuplot()

	end
scpi(dso,"INST OUT1\n")
scpi(dso,"VOLT 0 \n")
scpi(dso,"APPLY 0,0 \n")
scpi(dso,"OUTP:GEN 0\n")
scpi(dso,"DISP:WIND:TEXT:DATA \"Messung ist fertig!! \" \n")

disconnect(dso)
file:close()


end


function mess_vce( file )
print("mess_vce")

scpi(dso,"DISP:WIND:TEXT:CLEAR \n")

gout:write("set title \"Ice/Vce Characteristic\"\n ")
gout:write("set ylabel 'Ice (A)'\n")
gout:write("set xlabel 'Vce (V)'\n")
gout:write("set grid\n")



for ib= 0.005,0.02,.003 do

scpi(dso,"INST OUT1\n")
--setcur=string.format("APPLY \"1,%0.3f\" \n",ib)
scpi(dso,"VOLT 1\n")
setcur=string.format("CURR %0.3f\n",ib)
--print(setcur)
dso_id=scpi(dso,setcur)

	   sleep(.5)
 
--dso_id = scpi(dso, "*ESR?\n")
--print("ID = " .. dso_id)
 icur_mes=tonumber(scpi(dsi, "MEAS:CURR?\n"))



file:write(string.format("\"Ib=%.3f A\"\n",icur_mes))
file:flush()

for vol=0.1,30,.5 do



--print(vol)
scpi(dso,"INST OUT2\n")
command=string.format( "VOLT %.3f\n",vol)
dso_id= scpi(dso, command)


  sleep(.2)

-- print(scpi(dso,"*OPC\n"))
-- sleep(.2)
--print(scpi(dso,"*OPC\n"))
cur=tonumber(scpi(dso, "MEAS:CURR?\n"))
 --cur=cur+tonumber(scpi(dsi, "MEAS:CURR?\n"))
 --cur=cur+tonumber(scpi(dsi, "MEAS:CURR?\n"))
 --cur = cur /3
 
 vvol=scpi(dsi, "MEAS:VOLT?\n")

print(string.format("%.3f %.3f\n",tonumber(vvol),tonumber(cur)))

file:write(string.format("%.3f %.3f\n",tonumber(vvol),tonumber(cur)))
file:flush()
update_gnuplot()
ltk.update()
end
file:write("#\n#\n\n\n")
idx=idx+1
-- coroutine.yield()
end

scpi(dso,"VOLT 0 \n")
scpi(dso,"APPLY 0,0 \n")

scpi(dso,"INST OUT1\n")
scpi(dso,"VOLT 0 \n")
scpi(dso,"APPLY 0,0 \n")
scpi(dso,"OUTP:GEN 0\n")
--scpi(dso,"OUTP:STAT 0,1,2  \n")
scpi(dso,"DISP:WIND:TEXT:DATA \"Messung ist fertig!! \" \n")

disconnect(dso)
file:close()

end



function mess_mosvce( file )
print("mess_vce")

scpi(dso,"DISP:WIND:TEXT:CLEAR \n")

gout:write("set title \"Ice/Vce Characteristic\"\n ")
gout:write("set ylabel 'Isd/Ice (A)'\n")
gout:write("set xlabel 'Vsd/Vce (V)'\n")
gout:write("set grid\n")



for vb= 5.0,5.2,.025 do

scpi(dso,"INST OUT1\n")
scpi(dso,"CURR .01\n")
--setcur=string.format("APPLY \"1,%0.3f\" \n",ib)
setcur=string.format("VOLT %3f\n",vb)
--print(setcur)
dso_id=scpi(dso,setcur)

	   sleep(.5)
 
--dso_id = scpi(dso, "*ESR?\n")
--print("ID = " .. dso_id)
 vcur_mes=tonumber(scpi(dsi, "MEAS:VOLT?\n"))



file:write(string.format("\"Vg=%.3f V\"\n",vcur_mes))
file:flush()

for vol=0.1,30,.5 do



--print(vol)
scpi(dso,"INST OUT2\n")
command=string.format( "VOLT %.3f\n",vol)
dso_id= scpi(dso, command)


  sleep(.2)

-- print(scpi(dso,"*OPC\n"))
-- sleep(.2)
--print(scpi(dso,"*OPC\n"))
cur=tonumber(scpi(dso, "MEAS:CURR?\n"))
if cur > 1.95 then
 file:write(string.format("%.3f %.3f\n",tonumber(vvol),tonumber(cur)))
 file:flush()
 update_gnuplot()
 ltk.update()
 break
end
 --cur=cur+tonumber(scpi(dsi, "MEAS:CURR?\n"))
 --cur=cur+tonumber(scpi(dsi, "MEAS:CURR?\n"))
 --cur = cur /3
 
 vvol=scpi(dsi, "MEAS:VOLT?\n")

print(string.format("%.3f %.3f\n",tonumber(vvol),tonumber(cur)))

file:write(string.format("%.3f %.3f\n",tonumber(vvol),tonumber(cur)))
file:flush()
update_gnuplot()
ltk.update()
end
file:write("#\n#\n\n\n")
idx=idx+1
-- coroutine.yield()
end

scpi(dso,"VOLT 0 \n")
scpi(dso,"APPLY 0,0 \n")
scpi(dso,"INST OUT1\n")
scpi(dso,"VOLT 0 \n")
scpi(dso,"APPLY 0,0 \n")
scpi(dso,"OUTP:GEN 0\n")
scpi(dso,"DISP:WIND:TEXT:DATA \"Messung ist fertig!! \" \n")

disconnect(dso)
file:close()

end






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
idx=0

function finished(win,b)
  local bit=1<<b
  if ((a & bit) == 0) then
	print("hallo")
	win.text="OFF"
  else
	print("gugus")
	win.text="ON"

  end
  a=a ~ bit
	print(a)
	--ltk.exit()



update_gnuplot()

end


function update_vce()
if idx >0 then
str=string.format("plot for [IDX=0:%d] '/tmp/tra.data' i IDX u 1:2 smooth bezier title columnheader(1)\n",idx) 
--print(str)
else
str=string.format("plot \"/tmp/tra.data\" using 1:2 smooth bezier t columnheader(1)\n")
end
gout:write(str)
gout:flush()
ltk.update()
end


function update_ice()
str=string.format("plot \"/tmp/tra.data\" using 1:2 smooth bezier t \"Ice\", \"\" using 1:($2/$1) smooth bezier axes x1y2 t \"hfe\" \n")
gout:write(str)
gout:flush()
ltk.update()
end


function update_id()
str=string.format("plot \"/tmp/tra.data\" using 1:2 smooth csplines t \"Ice\" , \"\" using 1:2 notitle \n")
gout:write(str)
gout:flush()
ltk.update()
end


function update_mosvce()
if idx >0 then
str=string.format("plot for [IDX=0:%d] '/tmp/tra.data' i IDX u 1:2 smooth bezier title columnheader(1)\n",idx) 
--print(str)
else
str=string.format("plot \"/tmp/tra.data\" using 1:2 smooth bezier t columnheader(1)\n")
end
gout:write(str)
gout:flush()
ltk.update()
end



function update_gnuplot()

if plot_method ~= nil then
plot_method()
end

end


function mess2()
print("mess2")
print(mes_method)
if mes_method ~= nil then
   mes_method(fl)
  end
--ltk.after(500,mess2)
end

roman=0

function r_change(id)
lid=ltk.var.roman
if lid == 1 then
 mes_method=mess_vce
 plot_method=update_vce
elseif lid == 2 then
 mes_method=mess_ice
 plot_method=update_ice
elseif lid == 3 then
 mes_method=mess_id
 plot_method=update_id
elseif lid == 4 then
  mes_method=mess_mosvce
 plot_method=update_mosvce
end
print(ltk.var.roman)
print(mes_method)

end



function start()


print(gout)
if gout ~= nil then
 
 gout:close()
end

fl=io.open("/tmp/tra.data","w")


gout=io.popen("gnuplot","w");
gout:write(string.format("set term x11 window \"%s\"\n",wid))
gout:write(string.format("set grid\n"))
gout:write("set colorsequence classic\n")
gout:write(string.format("unset mouse\n"))

---gout:write(string.format("plot \"/tmp/tra.data\" using 1:2 smooth bezier t columnheader(1) \n"))
--gout:write(string.format("plot for [IDX=0:1] '/tmp/tra.data' i IDX u 1:2 smooth bezier title columnheader(1)\n"))
gout:flush()

idx=1

connect()
ltk.after(100, update_gnuplot)
ltk.after(500,mess2)
end




_menu = ltk.menu {}
ltk.stdwin:configure{menu=_menu}
_file = ltk.menu(_menu)()
_menu:add{'cascade', menu=_file, label='Choose', underline=0}

_file:add{'radio', label="Bipolar Transistor Vce/Ice", variable='roman',
        value=1, underline=0,command={r_change}}
_file:add{'radio', label="Bipolar Transistor Ice/Ib", variable='roman',
        value=2, underline=0,command={r_change}}
_file:add{'radio', label="Mosfet/IGBT Transistor Vce/Ice", variable='roman',
        value=4, underline=0,command={r_change}}
_file:add{'radio', label="Diode Forward I", variable='roman',
        value=3, underline=0, command={r_change}}
_file:add{'separator'}

_file:add{'command', label="Exit program", underline=0, command=ltk.exit}

nn2=ltk.labelframe{text="Action"}
b = ltk.button(nn2) {text="Start", command=function() start() end }
b:grid {row=1,column=1,pady=10,padx=10}


nn3=ltk.labelframe{text="Measurements"}
--canvas=ltk.canvas(nn3){background='white',width=200,height=200}
canvas=ltk.canvas(nn3){background='white'}
wid=ltk.winfo.id(canvas)


ltk.pack{nn2, padx=10,pady=10  } 
ltk.pack{canvas, fill='both' , expand=1 }
ltk.pack{nn3, expand='1' ,fill='both' } 

--print_table(ltk)




--ltk.after(100, update_gnuplot)
--ltk.after(500, mess2 )
--drawing()

ltk.tk.appname('Semiconductor messearements with Power Supply ')
ltk.stdwin:minsize (800, 600)
-- and go.
ltk.mainloop()




