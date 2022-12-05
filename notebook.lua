
ltk = require "ltk"


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




a=ltk.notebook( { width=640, height=480 } )
print_table(ltk)
print_table(a)
fr1=ltk.frame()
fr2=ltk.frame()
print_table(fr1)
a.configure(fr1 ) 
--a.configure(fr1, add  ) 
--a.configure(fr2, add) 

nn2=ltk.labelframe(fr1){text="Switches"}
b = ltk.button(nn2) {text="Ok", command=function() finished(b,0) end }
c = ltk.button(nn2) {text="Ok", command=function() finished(c,1) end }
d = ltk.button(nn2) {text="Ok", command=function() finished(d,2) end }
x = ltk.button(nn2) {text="Close", command=function() ltk.exit() end}

x:grid {row=1,column=1}
b:grid {row=1,column=2}
c:grid {row=1,column=3}
d:grid {row=1,column=4}

ltk.pack(nn2)

a:add{fr1,text='roman'}
a:add{fr2,text='test'}

ltk.pack(a)

ltk.tk.appname('Roman')
ltk.mainloop()



