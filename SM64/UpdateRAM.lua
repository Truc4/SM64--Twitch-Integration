memory.usememorydomain("RDRAM");

count = 0;
textTime = 0;
time = 0
odd = false;
cannonTime = 0;
cannonCam = false;

function justWords(str)
   local words = {}
   for word in str:gmatch("%S+") do table.insert(words, word) end
   return words
end

function readFile()
	file = io.open("command.txt", "r");
	if not file_exists(file) then return {} end
	command = file:read("*a");
	file:close();
	--print(justWords(command))
	command = justWords(command);
	username = command[1];
	address = tonumber(command[2]);
	value = tonumber(command[3]);
	signature = tonumber(command[4]);
end

function file_exists(file)
  local f = io.open("command.txt", "r")
  if f then f:close() end
  return f ~= nil
end

function mario()
	memory.write_s16_be(0x2535CA, 0x3F80);
	memory.write_s16_be(0x2535C2, 0x3F80);
	memory.write_s16_be(0x2535BE, 0x3F80);
	memory.write_s16_be(0x7EC40, 0xFF00);
	memory.write_s16_be(0x7EC42, 0x0);
	memory.write_s16_be(0x7EC38, 0x7F00);
	memory.write_s16_be(0x7EC3A, 0x0);
	memory.write_s16_be(0x7EC20, 0x0);
	memory.write_s16_be(0x7EC22, 0x7F00);
	memory.write_s16_be(0x7EC28, 0x0);
	memory.write_s16_be(0x7EC2A, 0xFF00);
	--Physics
	acceleration = 0x3F80;
	maxSpeed = 0x4240;
	jump = 1;
	gravity = 1;
	waluigi = false;
end

--Saves and loads a save state to update render
function reload()
	local save = memorysavestate.savecorestate();
	memorysavestate.loadcorestate(save);
end

function display(str)
	text = username .. " used " .. str;
	textTime = 500
end

mario();
reload();
readFile();
lastSignature = signature;

print("Start");

while true do
	if count > 10 then
		readFile();
		count = 0;
	end
	
	if lastSignature ~= signature and signature ~= nil then
		lastSignature = signature;
		print("update");
		print(address);
		print(value);
		if address == 0 then
			--Turn to Mario
			mario();
			reload();
			display("Mario");
		elseif address == 1 then
			--Turn to Luigi
			mario();
			memory.write_s16_be(0x2535C2, 0x3F89);
			memory.write_s16_be(0x2535BE, 0x3F40);
			memory.write_s16_be(0x7EC38, 0x7F);
			memory.write_s16_be(0x7EC40, 0xFF);
			reload();
			jump = 1.015;
			gravity = .95;
			display("Luigi");
		elseif address == 2 then
			--Turn to Wario
			mario();
			memory.write_s16_be(0x2535BE, 0x4000);
			memory.write_s16_be(0x2535CA, 0x4020);
			memory.write_s16_be(0x7EC40, 0xFFFF);
			memory.write_s16_be(0x7EC38, 0x5050);
			memory.write_s16_be(0x7EC20, 0x9900);
			memory.write_s16_be(0x7EC28, 0x3000);
			memory.write_s16_be(0x7EC2A, 0x9930);
			reload();
			jump = .985;
			gravity = 1.1;
			display("Wario")
		elseif address == 3 then
			--Turn to Waluigi
			mario();
			memory.write_s16_be(0x2535C2, 0x4000);
			memory.write_s16_be(0x2535BE, 0x3F80);
			memory.write_s16_be(0x7EC40, 0x800F);
			memory.write_s16_be(0x7EC38, 0x800F);
			memory.write_s16_be(0x7EC3A, 0xBB00);
			memory.write_s16_be(0x7EC20, 0x0);
			memory.write_s16_be(0x7EC22, 0x0);
			memory.write_s16_be(0x7EC28, 0x0);
			memory.write_s16_be(0x7EC2A, 0x0);
			reload();
			waluigi = true;
			display("Waluigi")
		elseif address == 4 then
			--Turn to Sonic
			mario();
			memory.write_s16_be(0x7EC40, 0x0);
			memory.write_s16_be(0x7EC42, 0x0);
			memory.write_s16_be(0x7EC38, 0x0);
			memory.write_s16_be(0x7EC3A, 0xDDDD);
			memory.write_s16_be(0x7EC20, 0x0);
			memory.write_s16_be(0x7EC22, 0xDDDD);
			memory.write_s16_be(0x7EC28, 0x0);
			memory.write_s16_be(0x7EC2A, 0x0);
			reload();

			acceleration = 0xBFFF;
			maxSpeed = 0x44A0;
			
			display("Sonic")
		elseif address == 5 then
			--Turn to neon
			mario();
			memory.write_s16_be(0x7EC40, 0xA5);
			memory.write_s16_be(0x7EC42, 0xBB00);
			memory.write_s16_be(0x7EC38, 0xA5);
			memory.write_s16_be(0x7EC3A, 0xBB00);
			memory.write_s16_be(0x7EC20, 0xA5);
			memory.write_s16_be(0x7EC22, 0x0);
			memory.write_s16_be(0x7EC28, 0xA5);
			memory.write_s16_be(0x7EC2A, 0x0);
			reload();
			jump = ((math.random() - .5) / 4) + 1
			gravity = ((math.random() - .5) / 4) + 1
			print("Jump: " .. jump)
			print("Gravity: " .. gravity)
			acceleration = math.random(1,0x5000);
			maxSpeed = math.random(1,0x5000);
			display("Neon")
		elseif address == 6 then
			--Toggle vanish cap
			if memory.read_s16_be(0x33B176) == 0x12 then
				memory.write_s16_be(0x33B176, 0x10);
			else
				memory.write_s16_be(0x33B176, 0x12);
			end
			display("vanish")
		elseif address == 7 then
			--Toggle metal cap
			if memory.read_s16_be(0x33B176) == 0x15 then
				memory.write_s16_be(0x33B176, 0x10);
			else
				memory.write_s16_be(0x33B176, 0x15);
			end
			display("metal")
		elseif address == 8 then
			--Toggle wing  cap
			if memory.read_s16_be(0x33B176) == 0x18 then
				memory.write_s16_be(0x33B176, 0x10);
			else
				memory.write_s16_be(0x33B176, 0x18);
			end
			display("wing")
		elseif address == 9 then
			--Toggle random cap
			local cap = math.random(1, 142);
			memory.write_s16_be(0x33B176, cap);
			display("random cap")
		elseif address == 10 then
			--Take X amount of health
			memory.writebyte(0x33B21E, memory.readbyte(0x33B21E) - value);
			print("oof")
			text = username .. " took " .. value .. " health"
			textTime = 500
		elseif address == 11 then
			--Add speed
			memory.write_s32_be(0x33B17C, 0x4000440);
			memory.writefloat(0x33B1C4, memory.readfloat(0x33B1C4, true) + (value*10), true)
			text = username .. " added " .. value .. " positive speed"
			textTime = 500
		elseif address == 12 then
			--Remove speed
			memory.write_s32_be(0x33B17C, 0x4000440);
			memory.writefloat(0x33B1C4, memory.readfloat(0x33B1C4, true) - (value*10), true)
			text = username .. " added " .. value .. " negative speed"
			textTime = 500
		elseif address == 13 then
			--Teleport upwards
			memory.write_s32_be(0x33B17C, 0x3000880);
			memory.writefloat(0x33B1B0, memory.readfloat(0x33B1B0, true) + (value*50) + 20, true)
			print("upwards")
			text = username .. " upwards " .. value
			textTime = 500
		elseif address == 14 then
			--Cannon for X seconds
			if cannonTime < 0 then
				cannonTime = 0
			end
			cannonCam = true
			cannonTime = cannonTime + value;
			text = username .. " added " .. value .. " seconds to CannonCamTM"
			textTime = 500
		end
	end
	
	count = count + 1;
	textTime = textTime - 1;
	if textTime > 0 then
		gui.drawText(client.bufferwidth()/2, client.bufferheight()/4, text, nil, nil, (client.bufferwidth()*client.bufferheight())/50000, nil, nil, 'center', 'middle');
	end
	if memory.readfloat(0x33B1BC, true) > 0 then
		memory.writefloat(0x33B1BC, memory.readfloat(0x33B1BC, true) * jump, true);
	elseif memory.readfloat(0x33B1BC, true) < 0 then
		memory.writefloat(0x33B1BC, memory.readfloat(0x33B1BC, true) * gravity, true);
	end
	memory.write_s16_be(0x2653B6, acceleration);
	memory.write_s16_be(0x2653CE, maxSpeed);
	
	if waluigi then
		if odd then
			odd = false
			buttons = joypad.get();
			if buttons["P1 A Up"] == true then
				buttons["P1 A Up"] = false
				buttons["P1 A Down"] = true
			elseif buttons["P1 A Down"] == true then
				buttons["P1 A Down"] = false
				buttons["P1 A Up"] = true
			end
			if buttons["P1 A Left"] == true then
				buttons["P1 A Left"] = false
				buttons["P1 A Right"] = true
			elseif buttons["P1 A Right"] == true then
				buttons["P1 A Right"] = false
				buttons["P1 A Left"] = true
			end
			if buttons["P1 A"] == true then
				buttons["P1 A"] = false
				buttons["P1 B"] = true
			elseif buttons["P1 B"] == true then
				buttons["P1 B"] = false
				buttons["P1 A"] = true
			end
			if buttons["P1 R"] == true then
				buttons["P1 R"] = false
				buttons["P1 Z"] = true
			elseif buttons["P1 Z"] == true then
				buttons["P1 Z"] = false
				buttons["P1 R"] = true
			end
			joypad.set(buttons);
		else
			odd = true
		end
	end
	
	if cannonCam == true and cannonTime > 0 then
		cannonTime = cannonTime - (1/60)
		memory.writebyte(0x33C6D4, 0xA);
		gui.drawText(0,0, "Cannon time remaining: " .. math.ceil(cannonTime), nil, nil, 25);
	elseif cannonCam == true and memory.readbyte(0x33C6D4) == 0xA then
		memory.writebyte(0x33C6D4, 0x10);
	else
		cannonCam = false
	end
	
	emu.frameadvance();
end
