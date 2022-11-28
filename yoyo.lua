--[[
    fe nameless animations v3
    made by MyWorld#4430
    discord.gg/pYVHtSJmEY
    no hats needed, r15 supported
]]

if "myworld reanimate again" then
    --reanimate by MyWorld#4430 discord.gg/pYVHtSJmEY
    local Vector3_101 = Vector3.new(1, 0, 1)
    local netless_Y = Vector3.new(0, 25.1, 0)
    local function getNetlessVelocity(realPartVelocity) --change this if you have a better method
        local mag = realPartVelocity.Magnitude
        if (mag > 1) and (mag < 100) then
            local unit = realPartVelocity.Unit
            if (unit.Y > 0.25) or (unit.Y < -0.75) then
                return realPartVelocity * (25.1 / realPartVelocity.Y)
            end
            realPartVelocity = unit * 100
        end
        return (realPartVelocity * Vector3_101) + netless_Y
    end
    local simradius = "shp" --simulation radius (net bypass) method
    --"shp" - sethiddenproperty
    --"ssr" - setsimulationradius
    --false - disable
    local noclipAllParts = false --set it to true if you want noclip
    local antiragdoll = true --removes hingeConstraints and ballSocketConstraints from your character
    local newanimate = true --disables the animate script and enables after reanimation
    local discharscripts = true --disables all localScripts parented to your character before reanimation
    local R15toR6 = true --tries to convert your character to r6 if its r15
    local hatcollide = false --makes hats cancollide (credit to ShownApe) (works only with reanimate method 0)
    local humState16 = true --enables collisions for limbs before the humanoid dies (using hum:ChangeState)
    local addtools = false --puts all tools from backpack to character and lets you hold them after reanimation
    local hedafterneck = true --disable aligns for head and enable after neck or torso is removed
    local loadtime = game:GetService("Players").RespawnTime + 0.5 --anti respawn delay
    local method = 3 --reanimation method
    --methods:
    --0 - breakJoints (takes [loadtime] seconds to laod)
    --1 - limbs
    --2 - limbs + anti respawn
    --3 - limbs + breakJoints after [loadtime] seconds
    --4 - remove humanoid + breakJoints
    --5 - remove humanoid + limbs
    local alignmode = 2 --AlignPosition mode
    --modes:
    --1 - AlignPosition rigidity enabled true
    --2 - 2 AlignPositions rigidity enabled both true and false
    --3 - AlignPosition rigidity enabled false
    local flingpart = "HumanoidRootPart" --name of the part or the hat used for flinging
    --the fling function
    --usage: fling(target, duration, velocity)
    --target can be set to: basePart, CFrame, Vector3, character model or humanoid (flings at mouse.Hit if argument not provided))
    --duration (fling time in seconds) can be set to: a number or a string convertable to the number (0.5s if not provided),
    --velocity (fling part rotation velocity) can be set to a vector3 value (Vector3.new(20000, 20000, 20000) if not provided)
    
    local lp = game:GetService("Players").LocalPlayer
    local rs = game:GetService("RunService")
    local stepped = rs.Stepped
    local heartbeat = rs.Heartbeat
    local renderstepped = rs.RenderStepped
    local sg = game:GetService("StarterGui")
    local ws = game:GetService("Workspace")
    local cf = CFrame.new
    local v3 = Vector3.new
    local v3_0 = Vector3.zero
    local inf = math.huge
    
    local c = lp.Character
    
    if not (c and c.Parent) then
    	return
    end
    
    c:GetPropertyChangedSignal("Parent"):Connect(function()
        if not (c and c.Parent) then
    	    c = nil
    	end
    end)
    
    local function gp(parent, name, className)
    	if typeof(parent) == "Instance" then
    		for i, v in pairs(parent:GetChildren()) do
    			if (v.Name == name) and v:IsA(className) then
    				return v
    			end
    		end
    	end
    	return nil
    end
    
    if type(getNetlessVelocity) ~= "function" then
        getNetlessVelocity = nil
    end
    
    local function align(Part0, Part1)
    	Part0.CustomPhysicalProperties = PhysicalProperties.new(0, 0, 0, 0, 0)
    
    	local att0 = Instance.new("Attachment")
    	att0.Orientation = v3_0
    	att0.Position = v3_0
    	att0.Name = "att0_" .. Part0.Name
    	local att1 = Instance.new("Attachment")
    	att1.Orientation = v3_0
    	att1.Position = v3_0
    	att1.Name = "att1_" .. Part1.Name
    
    	if (alignmode == 1) or (alignmode == 2) then
    		local ape = Instance.new("AlignPosition", att0)
    		ape.ApplyAtCenterOfMass = false
    		ape.MaxForce = inf
    		ape.MaxVelocity = inf
    		ape.ReactionForceEnabled = false
    		ape.Responsiveness = 200
    		ape.Attachment1 = att1
    		ape.Attachment0 = att0
    		ape.Name = "AlignPositionRtrue"
    		ape.RigidityEnabled = true
    	end
    
    	if (alignmode == 2) or (alignmode == 3) then
    		local apd = Instance.new("AlignPosition", att0)
    		apd.ApplyAtCenterOfMass = false
    		apd.MaxForce = inf
    		apd.MaxVelocity = inf
    		apd.ReactionForceEnabled = false
    		apd.Responsiveness = 200
    		apd.Attachment1 = att1
    		apd.Attachment0 = att0
    		apd.Name = "AlignPositionRfalse"
    		apd.RigidityEnabled = false
    	end
    
    	local ao = Instance.new("AlignOrientation", att0)
    	ao.MaxAngularVelocity = inf
    	ao.MaxTorque = inf
    	ao.PrimaryAxisOnly = false
    	ao.ReactionTorqueEnabled = false
    	ao.Responsiveness = 200
    	ao.Attachment1 = att1
    	ao.Attachment0 = att0
    	ao.RigidityEnabled = false
    
    	if getNetlessVelocity then
    	    local vel = Part0.Velocity
    	    local velpart = Part1
            local rsteppedcon = renderstepped:Connect(function()
                Part0.Velocity = vel
            end)
            local heartbeatcon = heartbeat:Connect(function()
                vel = Part0.Velocity
                Part0.Velocity = getNetlessVelocity(velpart.Velocity)
            end)
            local attcon = nil
            Part0:GetPropertyChangedSignal("Parent"):Connect(function()
                if not (Part0 and Part0.Parent) then
                    rsteppedcon:Disconnect()
                    heartbeatcon:Disconnect()
                    attcon:Disconnect()
                end
            end)
            attcon = att1:GetPropertyChangedSignal("Parent"):Connect(function()
    	        if not (att1 and att1.Parent) then
    	            attcon:Disconnect()
                    velpart = Part0
    	        else
    	            velpart = att1.Parent
    	            if not velpart:IsA("BasePart") then
    	                velpart = Part0
    	            end
    	        end
    	    end)
    	end
    	
    	att0.Parent = Part0
        att1.Parent = Part1
    end
    
    local function respawnrequest()
    	local ccfr = ws.CurrentCamera.CFrame
    	local c = lp.Character
    	lp.Character = nil
    	lp.Character = c
    	local con = nil
    	con = ws.CurrentCamera.Changed:Connect(function(prop)
    	    if (prop ~= "Parent") and (prop ~= "CFrame") then
    	        return
    	    end
    	    ws.CurrentCamera.CFrame = ccfr
    	    con:Disconnect()
        end)
    end
    
    local destroyhum = (method == 4) or (method == 5)
    local breakjoints = (method == 0) or (method == 4)
    local antirespawn = (method == 0) or (method == 2) or (method == 3)
    
    hatcollide = hatcollide and (method == 0)
    
    addtools = addtools and gp(lp, "Backpack", "Backpack")
    
    local fenv = getfenv()
    local shp = fenv.sethiddenproperty or fenv.set_hidden_property or fenv.set_hidden_prop or fenv.sethiddenprop
    local ssr = fenv.setsimulationradius or fenv.set_simulation_radius or fenv.set_sim_radius or fenv.setsimradius or fenv.set_simulation_rad or fenv.setsimulationrad
    
    if shp and (simradius == "shp") then
    	spawn(function()
    		while c and heartbeat:Wait() do
    			shp(lp, "SimulationRadius", inf)
    		end
    	end)
    elseif ssr and (simradius == "ssr") then
    	spawn(function()
    		while c and heartbeat:Wait() do
    			ssr(inf)
    		end
    	end)
    end
    
    antiragdoll = antiragdoll and function(v)
    	if v:IsA("HingeConstraint") or v:IsA("BallSocketConstraint") then
    		v.Parent = nil
    	end
    end
    
    if antiragdoll then
    	for i, v in pairs(c:GetDescendants()) do
    		antiragdoll(v)
    	end
    	c.DescendantAdded:Connect(antiragdoll)
    end
    
    if antirespawn then
    	respawnrequest()
    end
    
    if method == 0 then
    	wait(loadtime)
    	if not c then
    		return
    	end
    end
    
    if discharscripts then
    	for i, v in pairs(c:GetChildren()) do
    		if v:IsA("LocalScript") then
    			v.Disabled = true
    		end
    	end
    elseif newanimate then
    	local animate = gp(c, "Animate", "LocalScript")
    	if animate and (not animate.Disabled) then
    		animate.Disabled = true
    	else
    		newanimate = false
    	end
    end
    
    if addtools then
    	for i, v in pairs(addtools:GetChildren()) do
    		if v:IsA("Tool") then
    			v.Parent = c
    		end
    	end
    end
    
    pcall(function()
    	settings().Physics.AllowSleep = false
    	settings().Physics.PhysicsEnvironmentalThrottle = Enum.EnviromentalPhysicsThrottle.Disabled
    end)
    
    local OLDscripts = {}
    
    for i, v in pairs(c:GetDescendants()) do
    	if v.ClassName == "Script" then
    		table.insert(OLDscripts, v)
    	end
    end
    
    local scriptNames = {}
    
    for i, v in pairs(c:GetDescendants()) do
    	if v:IsA("BasePart") then
    		local newName = tostring(i)
    		local exists = true
    		while exists do
    			exists = false
    			for i, v in pairs(OLDscripts) do
    				if v.Name == newName then
    					exists = true
    				end
    			end
    			if exists then
    				newName = newName .. "_"    
    			end
    		end
    		table.insert(scriptNames, newName)
    		Instance.new("Script", v).Name = newName
    	end
    end
    
    c.Archivable = true
    local hum = c:FindFirstChildOfClass("Humanoid")
    if hum then
    	for i, v in pairs(hum:GetPlayingAnimationTracks()) do
    		v:Stop()
    	end
    end
    local cl = c:Clone()
    if hum and humState16 then
        hum:ChangeState(Enum.HumanoidStateType.Physics)
        if destroyhum then
            wait(1.6)
        end
    end
    if hum and hum.Parent and destroyhum then
        hum:Destroy()
    end
    
    if not c then
        return
    end
    
    local head = gp(c, "Head", "BasePart")
    local torso = gp(c, "Torso", "BasePart") or gp(c, "UpperTorso", "BasePart")
    local root = gp(c, "HumanoidRootPart", "BasePart")
    if hatcollide and c:FindFirstChildOfClass("Accessory") then
        local anything = c:FindFirstChildOfClass("BodyColors") or gp(c, "Health", "Script")
        if not (torso and root and anything) then
            return
        end
        torso:Destroy()
        root:Destroy()
        if shp then
            for i,v in pairs(c:GetChildren()) do
                if v:IsA("Accessory") then
                    shp(v, "BackendAccoutrementState", 0)
                end 
            end
        end
        anything:Destroy()
    end
    
    local model = Instance.new("Model", c)
    model.Name = model.ClassName
    
    model:GetPropertyChangedSignal("Parent"):Connect(function()
        if not (model and model.Parent) then
    	    model = nil
        end
    end)
    
    for i, v in pairs(c:GetChildren()) do
    	if v ~= model then
    		if addtools and v:IsA("Tool") then
    			for i1, v1 in pairs(v:GetDescendants()) do
    				if v1 and v1.Parent and v1:IsA("BasePart") then
    					local bv = Instance.new("BodyVelocity", v1)
    					bv.Velocity = v3_0
    					bv.MaxForce = v3(1000, 1000, 1000)
    					bv.P = 1250
    					bv.Name = "bv_" .. v.Name
    				end
    			end
    		end
    		v.Parent = model
    	end
    end
    
    if breakjoints then
    	model:BreakJoints()
    else
    	if head and torso then
    		for i, v in pairs(model:GetDescendants()) do
    			if v:IsA("Weld") or v:IsA("Snap") or v:IsA("Glue") or v:IsA("Motor") or v:IsA("Motor6D") then
    				local save = false
    				if (v.Part0 == torso) and (v.Part1 == head) then
    					save = true
    				end
    				if (v.Part0 == head) and (v.Part1 == torso) then
    					save = true
    				end
    				if save then
    					if hedafterneck then
    						hedafterneck = v
    					end
    				else
    					v:Destroy()
    				end
    			end
    		end
    	end
    	if method == 3 then
    		spawn(function()
    			wait(loadtime)
    			if model then
    				model:BreakJoints()
    			end
    		end)
    	end
    end
    
    cl.Parent = c
    for i, v in pairs(cl:GetChildren()) do
    	v.Parent = c
    end
    cl:Destroy()
    
    local noclipmodel = (noclipAllParts and c) or model
    local noclipcon = nil
    local function uncollide()
    	if noclipmodel then
    		for i, v in pairs(noclipmodel:GetDescendants()) do
    		    if v:IsA("BasePart") then
    			    v.CanCollide = false
    		    end
    		end
    	else
    		noclipcon:Disconnect()
    	end
    end
    noclipcon = stepped:Connect(uncollide)
    uncollide()
    
    for i, scr in pairs(model:GetDescendants()) do
    	if (scr.ClassName == "Script") and table.find(scriptNames, scr.Name) then
    		local Part0 = scr.Parent
    		if Part0:IsA("BasePart") then
    			for i1, scr1 in pairs(c:GetDescendants()) do
    				if (scr1.ClassName == "Script") and (scr1.Name == scr.Name) and (not scr1:IsDescendantOf(model)) then
    					local Part1 = scr1.Parent
    					if (Part1.ClassName == Part0.ClassName) and (Part1.Name == Part0.Name) then
    						align(Part0, Part1)
    						scr:Destroy()
    						scr1:Destroy()
    						break
    					end
    				end
    			end
    		end
    	end
    end
    
    for i, v in pairs(c:GetDescendants()) do
    	if v and v.Parent and (not v:IsDescendantOf(model)) then
    		if v:IsA("Decal") then
    		    v.Transparency = 1
    		elseif v:IsA("BasePart") then
    			v.Transparency = 1
    			v.Anchored = false
    		elseif v:IsA("ForceField") then
    			v.Visible = false
    		elseif v:IsA("Sound") then
    			v.Playing = false
    		elseif v:IsA("BillboardGui") or v:IsA("SurfaceGui") or v:IsA("ParticleEmitter") or v:IsA("Fire") or v:IsA("Smoke") or v:IsA("Sparkles") then
    			v.Enabled = false
    		end
    	end
    end
    
    if newanimate then
    	local animate = gp(c, "Animate", "LocalScript")
    	if animate then
    		animate.Disabled = false
    	end
    end
    
    if addtools then
    	for i, v in pairs(c:GetChildren()) do
    		if v:IsA("Tool") then
    			v.Parent = addtools
    		end
    	end
    end
    
    local hum0 = model:FindFirstChildOfClass("Humanoid")
    if hum0 then
        hum0:GetPropertyChangedSignal("Parent"):Connect(function()
            if not (hum0 and hum0.Parent) then
                hum0 = nil
            end
        end)
    end
    
    local hum1 = c:FindFirstChildOfClass("Humanoid")
    if hum1 then
        hum1:GetPropertyChangedSignal("Parent"):Connect(function()
            if not (hum1 and hum1.Parent) then
                hum1 = nil
            end
        end)
        
    	ws.CurrentCamera.CameraSubject = hum1
    	local camSubCon = nil
    	local function camSubFunc()
    		camSubCon:Disconnect()
    		if c and hum1 then
    			ws.CurrentCamera.CameraSubject = hum1
    		end
    	end
    	camSubCon = renderstepped:Connect(camSubFunc)
    	if hum0 then
    		hum0:GetPropertyChangedSignal("Jump"):Connect(function()
    			if hum1 then
    				hum1.Jump = hum0.Jump
    			end
    		end)
    	else
    		respawnrequest()
    	end
    end
    
    local rb = Instance.new("BindableEvent", c)
    rb.Event:Connect(function()
    	rb:Destroy()
    	sg:SetCore("ResetButtonCallback", true)
    	if destroyhum then
    		c:BreakJoints()
    		return
    	end
    	if hum0 and (hum0.Health > 0) then
    		model:BreakJoints()
    		hum0.Health = 0
    	end
    	if antirespawn then
    	    respawnrequest()
    	end
    end)
    sg:SetCore("ResetButtonCallback", rb)
    
    spawn(function()
    	while c do
    		if hum0 and hum1 then
    			hum1.Jump = hum0.Jump
    		end
    		wait()
    	end
    	sg:SetCore("ResetButtonCallback", true)
    end)
    
    R15toR6 = R15toR6 and hum1 and (hum1.RigType == Enum.HumanoidRigType.R15)
    if R15toR6 then
        local part = gp(c, "HumanoidRootPart", "BasePart") or gp(c, "UpperTorso", "BasePart") or gp(c, "LowerTorso", "BasePart") or gp(c, "Head", "BasePart") or c:FindFirstChildWhichIsA("BasePart")
    	if part then
    	    local cfr = part.CFrame
    		local R6parts = { 
    			head = {
    				Name = "Head",
    				Size = v3(2, 1, 1),
    				R15 = {
    					Head = 0
    				}
    			},
    			torso = {
    				Name = "Torso",
    				Size = v3(2, 2, 1),
    				R15 = {
    					UpperTorso = 0.2,
    					LowerTorso = -0.8
    				}
    			},
    			root = {
    				Name = "HumanoidRootPart",
    				Size = v3(2, 2, 1),
    				R15 = {
    					HumanoidRootPart = 0
    				}
    			},
    			leftArm = {
    				Name = "Left Arm",
    				Size = v3(1, 2, 1),
    				R15 = {
    					LeftHand = -0.849,
    					LeftLowerArm = -0.174,
    					LeftUpperArm = 0.415
    				}
    			},
    			rightArm = {
    				Name = "Right Arm",
    				Size = v3(1, 2, 1),
    				R15 = {
    					RightHand = -0.849,
    					RightLowerArm = -0.174,
    					RightUpperArm = 0.415
    				}
    			},
    			leftLeg = {
    				Name = "Left Leg",
    				Size = v3(1, 2, 1),
    				R15 = {
    					LeftFoot = -0.85,
    					LeftLowerLeg = -0.29,
    					LeftUpperLeg = 0.49
    				}
    			},
    			rightLeg = {
    				Name = "Right Leg",
    				Size = v3(1, 2, 1),
    				R15 = {
    					RightFoot = -0.85,
    					RightLowerLeg = -0.29,
    					RightUpperLeg = 0.49
    				}
    			}
    		}
    		for i, v in pairs(c:GetChildren()) do
    			if v:IsA("BasePart") then
    				for i1, v1 in pairs(v:GetChildren()) do
    					if v1:IsA("Motor6D") then
    						v1.Part0 = nil
    					end
    				end
    			end
    		end
    		part.Archivable = true
    		for i, v in pairs(R6parts) do
    			local part = part:Clone()
    			part:ClearAllChildren()
    			part.Name = v.Name
    			part.Size = v.Size
    			part.CFrame = cfr
    			part.Anchored = false
    			part.Transparency = 1
    			part.CanCollide = false
    			for i1, v1 in pairs(v.R15) do
    				local R15part = gp(c, i1, "BasePart")
    				local att = gp(R15part, "att1_" .. i1, "Attachment")
    				if R15part then
    					local weld = Instance.new("Weld", R15part)
    					weld.Name = "Weld_" .. i1
    					weld.Part0 = part
    					weld.Part1 = R15part
    					weld.C0 = cf(0, v1, 0)
    					weld.C1 = cf(0, 0, 0)
    					R15part.Massless = true
    					R15part.Name = "R15_" .. i1
    					R15part.Parent = part
    					if att then
    						att.Parent = part
    						att.Position = v3(0, v1, 0)
    					end
    				end
    			end
    			part.Parent = c
    			R6parts[i] = part
    		end
    		local R6joints = {
    			neck = {
    				Parent = R6parts.torso,
    				Name = "Neck",
    				Part0 = R6parts.torso,
    				Part1 = R6parts.head,
    				C0 = cf(0, 1, 0, -1, 0, 0, 0, 0, 1, 0, 1, -0),
    				C1 = cf(0, -0.5, 0, -1, 0, 0, 0, 0, 1, 0, 1, -0)
    			},
    			rootJoint = {
    				Parent = R6parts.root,
    				Name = "RootJoint" ,
    				Part0 = R6parts.root,
    				Part1 = R6parts.torso,
    				C0 = cf(0, 0, 0, -1, 0, 0, 0, 0, 1, 0, 1, -0),
    				C1 = cf(0, 0, 0, -1, 0, 0, 0, 0, 1, 0, 1, -0)
    			},
    			rightShoulder = {
    				Parent = R6parts.torso,
    				Name = "Right Shoulder",
    				Part0 = R6parts.torso,
    				Part1 = R6parts.rightArm,
    				C0 = cf(1, 0.5, 0, 0, 0, 1, 0, 1, -0, -1, 0, 0),
    				C1 = cf(-0.5, 0.5, 0, 0, 0, 1, 0, 1, -0, -1, 0, 0)
    			},
    			leftShoulder = {
    				Parent = R6parts.torso,
    				Name = "Left Shoulder",
    				Part0 = R6parts.torso,
    				Part1 = R6parts.leftArm,
    				C0 = cf(-1, 0.5, 0, 0, 0, -1, 0, 1, 0, 1, 0, 0),
    				C1 = cf(0.5, 0.5, 0, 0, 0, -1, 0, 1, 0, 1, 0, 0)
    			},
    			rightHip = {
    				Parent = R6parts.torso,
    				Name = "Right Hip",
    				Part0 = R6parts.torso,
    				Part1 = R6parts.rightLeg,
    				C0 = cf(1, -1, 0, 0, 0, 1, 0, 1, -0, -1, 0, 0),
    				C1 = cf(0.5, 1, 0, 0, 0, 1, 0, 1, -0, -1, 0, 0)
    			},
    			leftHip = {
    				Parent = R6parts.torso,
    				Name = "Left Hip" ,
    				Part0 = R6parts.torso,
    				Part1 = R6parts.leftLeg,
    				C0 = cf(-1, -1, 0, 0, 0, -1, 0, 1, 0, 1, 0, 0),
    				C1 = cf(-0.5, 1, 0, 0, 0, -1, 0, 1, 0, 1, 0, 0)
    			}
    		}
    		for i, v in pairs(R6joints) do
    			local joint = Instance.new("Motor6D")
    			for prop, val in pairs(v) do
    				joint[prop] = val
    			end
    			R6joints[i] = joint
    		end
    		if hum1 then
        		hum1.RigType = Enum.HumanoidRigType.R6
        		hum1.HipHeight = 0
    		end
    	end
    end
    
    local torso1 = torso
    torso = gp(c, "Torso", "BasePart") or ((not R15toR6) and gp(c, torso.Name, "BasePart"))
    if (typeof(hedafterneck) == "Instance") and head and torso and torso1 then
    	local conNeck = nil
    	local conTorso = nil
    	local contorso1 = nil
    	local aligns = {}
    	local function enableAligns()
    	    conNeck:Disconnect()
            conTorso:Disconnect()
            conTorso1:Disconnect()
    		for i, v in pairs(aligns) do
    			v.Enabled = true
    		end
    	end
    	conNeck = hedafterneck.Changed:Connect(function(prop)
    	    if table.find({"Part0", "Part1", "Parent"}, prop) then
    	        enableAligns()
    		end
    	end)
    	conTorso = torso:GetPropertyChangedSignal("Parent"):Connect(enableAligns)
    	conTorso1 = torso1:GetPropertyChangedSignal("Parent"):Connect(enableAligns)
    	for i, v in pairs(head:GetDescendants()) do
    		if v:IsA("AlignPosition") or v:IsA("AlignOrientation") then
    			i = tostring(i)
    			aligns[i] = v
    			v:GetPropertyChangedSignal("Parent"):Connect(function()
    			    aligns[i] = nil
    			end)
    			v.Enabled = false
    		end
    	end
    end
    
    local flingpart0 = gp(model, flingpart, "BasePart") or gp(gp(model, flingpart, "Accessory"), "Handle", "BasePart")
    local flingpart1 = gp(c, flingpart, "BasePart") or gp(gp(c, flingpart, "Accessory"), "Handle", "BasePart")
    
    local fling = function() end
    if flingpart0 and flingpart1 then
        flingpart0:GetPropertyChangedSignal("Parent"):Connect(function()
            if not (flingpart0 and flingpart0.Parent) then
                flingpart0 = nil
                fling = function() end
            end
        end)
        flingpart0.Archivable = true
        flingpart1:GetPropertyChangedSignal("Parent"):Connect(function()
            if not (flingpart1 and flingpart1.Parent) then
                flingpart1 = nil
                fling = function() end
            end
        end)
        local att0 = gp(flingpart0, "att0_" .. flingpart0.Name, "Attachment")
        local att1 = gp(flingpart1, "att1_" .. flingpart1.Name, "Attachment")
        if att0 and att1 then
            att0:GetPropertyChangedSignal("Parent"):Connect(function()
                if not (att0 and att0.Parent) then
                    att0 = nil
                    fling = function() end
                end
            end)
            att1:GetPropertyChangedSignal("Parent"):Connect(function()
                if not (att1 and att1.Parent) then
                    att1 = nil
                    fling = function() end
                end
            end)
            local lastfling = nil
            local mouse = lp:GetMouse()
            fling = function(target, duration, rotVelocity)
                if typeof(target) == "Instance" then
                    if target:IsA("BasePart") then
                        target = target.Position
                    elseif target:IsA("Model") then
                        target = gp(target, "HumanoidRootPart", "BasePart") or gp(target, "Torso", "BasePart") or gp(target, "UpperTorso", "BasePart") or target:FindFirstChildWhichIsA("BasePart")
                        if target then
                            target = target.Position
                        else
                            return
                        end
                    elseif target:IsA("Humanoid") then
                        local parent = target.Parent
                        if not (parent and parent:IsA("Model")) then
                            return
                        end
                        target = gp(target, "HumanoidRootPart", "BasePart") or gp(target, "Torso", "BasePart") or gp(target, "UpperTorso", "BasePart") or target:FindFirstChildWhichIsA("BasePart")
                        if target then
                            target = target.Position
                        else
                            return
                        end
                    else
                        return
                    end
                elseif typeof(target) == "CFrame" then
                    target = target.Position
                elseif typeof(target) ~= "Vector3" then
                    target = mouse.Hit
                    if target then
                        target = target.Position
                    else
                        return
                    end
                end
                lastfling = target
                if type(duration) ~= "number" then
                    duration = tonumber(duration) or 0.5
                end
                if typeof(rotVelocity) ~= "Vector3" then
                    rotVelocity = v3(20000, 20000, 20000)
                end
                if not (target and flingpart0 and flingpart1 and att0 and att1) then
                    return
                end
                local flingpart = flingpart0:Clone()
                flingpart.Transparency = 1
                flingpart.Size = v3(0.01, 0.01, 0.01)
                flingpart.CanCollide = false
                flingpart.Name = "flingpart_" .. flingpart0.Name
                flingpart.Anchored = true
                flingpart.Velocity = v3_0
                flingpart.RotVelocity = v3_0
                flingpart:GetPropertyChangedSignal("Parent"):Connect(function()
                    if not (flingpart and flingpart.Parent) then
                        flingpart = nil
                    end
                end)
                flingpart.Parent = flingpart1
                if flingpart0.Transparency > 0.5 then
                    flingpart0.Transparency = 0.5
                end
                att1.Parent = flingpart
                for i, v in pairs(att0:GetChildren()) do
                    if v:IsA("AlignOrientation") then
                        v.Enabled = false
                    end
                end
                local con = nil
                con = heartbeat:Connect(function()
                    if target and (lastfling == target) and flingpart and flingpart0 and flingpart1 and att0 and att1 then
                        flingpart0.RotVelocity = rotVelocity
                        flingpart.Position = target
                    else
                        con:Disconnect()
                    end
                end)
                local rsteppedRotVel = v3(
                    ((rotVelocity.X > 0) and -1) or 1,
                    ((rotVelocity.Y > 0) and -1) or 1,
                    ((rotVelocity.Z > 0) and -1) or 1
                )
                local con = nil
                con = renderstepped:Connect(function()
                    if target and (lastfling == target) and flingpart and flingpart0 and flingpart1 and att0 and att1 then
                        flingpart0.RotVelocity = rsteppedRotVel
                        flingpart.Position = target
                    else
                        con:Disconnect()
                    end
                end)
                wait(duration)
                if lastfling ~= target then
                    if flingpart then
                        if att1 and (att1.Parent == flingpart) then
                            att1.Parent = flingpart1
                        end
                        flingpart:Destroy()
                    end
                    return
                end
                target = nil
                if not (flingpart and flingpart0 and flingpart1 and att0 and att1) then
                    return
                end
                flingpart0.RotVelocity = v3_0
                att1.Parent = flingpart1
                for i, v in pairs(att0:GetChildren()) do
                    if v:IsA("AlignOrientation") then
                        v.Enabled = true
                    end
                end
                if flingpart then
                    flingpart:Destroy()
                end
            end
        end
    end
end

local lp = game:GetService("Players").LocalPlayer

local c = lp.Character
if not (c and c.Parent) then
	return print("character not found")
end
c:GetPropertyChangedSignal("Parent"):Connect(function()
    if not (c and c.Parent) then
        c = nil
    end
end)

--getPart function

local function gp(parent, name, className)
	local ret = nil
	pcall(function()
		for i, v in pairs(parent:GetChildren()) do
			if (v.Name == name) and v:IsA(className) then
				ret = v
				break
			end
		end
	end)
	return ret
end

--check if reanimate loaded

local model = gp(c, "Model", "Model")
if not model then return print("model not found") end

--find body parts

local head = gp(c, "Head", "BasePart")
if not head then return print("head not found") end

local torso = gp(c, "Torso", "BasePart")
if not torso then return print("torso not found") end

local humanoidRootPart = gp(c, "HumanoidRootPart", "BasePart")
if not humanoidRootPart then return print("humanoid root part not found") end

local leftArm = gp(c, "Left Arm", "BasePart")
if not leftArm then return print("left arm not found") end

local rightArm = gp(c, "Right Arm", "BasePart")
if not rightArm then return print("right arm not found") end

local leftLeg = gp(c, "Left Leg", "BasePart")
if not leftLeg then return print("left leg not found") end

local rightLeg = gp(c, "Right Leg", "BasePart")
if not rightLeg then return print("right leg not found") end

--find rig joints

local neck = gp(torso, "Neck", "Motor6D")
if not neck then return print("neck not found") end

local rootJoint = gp(humanoidRootPart, "RootJoint", "Motor6D")
if not rootJoint then return print("root joint not found") end

local leftShoulder = gp(torso, "Left Shoulder", "Motor6D")
if not leftShoulder then return print("left shoulder not found") end

local rightShoulder = gp(torso, "Right Shoulder", "Motor6D")
if not rightShoulder then return print("right shoulder not found") end

local leftHip = gp(torso, "Left Hip", "Motor6D")
if not leftHip then return print("left hip not found") end

local rightHip = gp(torso, "Right Hip", "Motor6D")
if not rightHip then return print("right hip not found") end

--humanoid

local hum = c:FindFirstChildOfClass("Humanoid")
if not hum then return print("humanoid not found") end

local animate = gp(c, "Animate", "LocalScript")
if animate then
	animate.Disabled = true
end

for i, v in pairs(hum:GetPlayingAnimationTracks()) do
	v:Stop()
end

local function stopIfRemoved(instance)
    if not (instance and instance.Parent) then
        c = nil
        return
    end
    instance:GetPropertyChangedSignal("Parent"):Connect(function()
        if not (instance and instance.Parent) then
            c = nil
        end
    end)
end
stopIfRemoved(c)
stopIfRemoved(hum)
for i, v in pairs({head, torso, leftArm, rightArm, leftLeg, rightLeg, humanoidRootPart}) do
    stopIfRemoved(v)
end
for i, v in pairs({neck, rootJoint, leftShoulder, rightShoulder, leftHip, rightHip}) do
    stopIfRemoved(v)
end
if not c then
    return
end
local mode = false
uis = game:GetService("UserInputService")
local modes = {
	[Enum.KeyCode.Q] = "lay",
	[Enum.KeyCode.E] = "sit",
	[Enum.KeyCode.K] = "kazotsky",
	[Enum.KeyCode.T] = "wave",
	[Enum.KeyCode.Y] = "dab",
	[Enum.KeyCode.U] = "dance",
	[Enum.KeyCode.L] = "L",
	[Enum.KeyCode.F] = "fly",
	[Enum.KeyCode.G] = "floss",
	[Enum.KeyCode.R] = "rickroll"
}
uis.InputBegan:Connect(function(keycode)
    if uis:GetFocusedTextBox() then
        return
    end
	keycode = keycode.KeyCode
	if modes[keycode] ~= nil then
		if mode == modes[keycode] then
			mode = nil
		else
			mode = modes[keycode]
		end
	end
end)

local cf, v3, euler, sin, sine, abs = CFrame.new, Vector3.new, CFrame.fromEulerAnglesXYZ, math.sin, 0, math.abs
local con = nil
con = game:GetService("RunService").RenderStepped:Connect(function(deltaTime)
    if not c then
        con:Disconnect()
        return
    end
    deltaTime = deltaTime * 10
    hum.CameraOffset = hum.CameraOffset:Lerp(v3(0, head.Position.Y - humanoidRootPart.Position.Y - 1.5, 0), deltaTime / 4)
    sine = sine + deltaTime * 3
    local vel = humanoidRootPart.Velocity
    if vel.Magnitude > 2 then
        if abs(vel.X) + abs(vel.Z) > abs(vel.Y) then -- walk
    
            neck.C0 = neck.C0:Lerp(cf(0, 1, 0) * euler(-1.5707963267948966 - 0.08726646259971647 * sin((sine - 2.5) * 0.4), -0.08726646259971647 * sin((sine - 7.5) * 0.2), -3.1590459461097367 - 0.17453292519943295 * sin((sine + 5) * 0.2)), deltaTime) 
            rootJoint.C0 = rootJoint.C0:Lerp(cf(-0.1 * sin((sine + 5) * 0.2), 0.1 + 0.125 * sin((sine + 10) * 0.4), 0) * euler(-1.6580627893946132, 0.08726646259971647 * sin((sine - 10) * 0.2), -3.141592653589793 + 0.17453292519943295 * sin((sine + 2.5) * 0.2)), deltaTime) 
            leftShoulder.C0 = leftShoulder.C0:Lerp(cf(-1, 0.5 - 0.1 * sin((sine - 15) * 0.2), 0) * euler(1.5707963267948966 - 0.4363323129985824 * sin((sine + 5) * 0.2), -1.6580627893946132 + 0.08726646259971647 * sin((sine - 10) * 0.2), 1.5707963267948966), deltaTime) 
            rightShoulder.C0 = rightShoulder.C0:Lerp(cf(1, 0.5 + 0.1 * sin((sine - 15) * 0.2), 0) * euler(1.5707963267948966 + 0.4363323129985824 * sin((sine + 5) * 0.2), 1.6580627893946132 + 0.08726646259971647 * sin((sine - 10) * 0.2), -1.5707963267948966), deltaTime) 
            leftHip.C0 = leftHip.C0:Lerp(cf(-1, -1 - 0.15 * sin((sine + 5) * 0.2), 0) * euler(1.5707963267948966, -1.6057029118347832 + 0.08726646259971647 * sin((sine - 10) * 0.2), 1.5707963267948966 + 0.8726646259971648 * sin(sine * 0.2)), deltaTime) 
            rightHip.C0 = rightHip.C0:Lerp(cf(1, -1 + 0.15 * sin((sine + 5) * 0.2), 0) * euler(1.5707963267948966, 1.6057029118347832 + 0.08726646259971647 * sin((sine - 10) * 0.2), -1.5707963267948966 + 0.8726646259971648 * sin(sine * 0.2)), deltaTime) 
            --local MW_animator_progressSave = "0,  0,  0,  0.1,  -90,  -5,  -2.5,  0.4,  1,  0,  0,  0.1,  0,  -5,  -7.5,  0.2,  0,  0,  0,  0.1,  -181,  -10,  5,  0.2,  0, -0.1, 5,  0.2,  -95,  0,  0,  0.1,  0.1,  0.125,  10,  0.4,  0,  5,  -10,  0.2,  0,  0,  0,  0.1,  -180,  10,  2.5,  0.2,  -1,  0,  0,  0.1,  90,  -25,  5,  0.2,  0.5,  -0.1,  -15,  0.2,  -95,  5,  -10,  0.2,  0,  0,  0,  0.1,  90,  0,  0,  0.1,  1,  0,  0,  0.1,  90,  25,  5,  0.2,  0.5,  0.1,  -15,  0.2,  95,  5,  -10,  0.2,  0,  0,  0,  0.1,  -90,  0,  0,  0.1,  -1,  0,  0,  0.1,  90,  0,  0,  0.1,  -1,  -0.15,  5,  0.2,  -92,  5,  -10,  0.2,  0,  0,  0,  0.1,  90,  50,  0,  0.2,  1,  0,  0,  0.1,  90,  0,  0,  0.1,  -1,  0.15,  5,  0.2,  92,  5,  -10,  0.2,  0,  0,  0,  0.1,  -90,  50,  0,  0.2"
    
        elseif vel.Y > 0 then -- jump

            neck.C0 = neck.C0:Lerp(cf(0, 1, 0) * euler(-1.3962634015954636 + 0.08726646259971647 * sin((sine + 45) * 0.1), 0, -3.1590459461097367), deltaTime) 
            rootJoint.C0 = rootJoint.C0:Lerp(cf(0, 0, 0) * euler(-1.4835298641951802 - 0.08726646259971647 * sin((sine + 30) * 0.1), 0, -3.1590459461097367), deltaTime) 
            leftShoulder.C0 = leftShoulder.C0:Lerp(cf(-1, 0.5, 0) * euler(-1.5707963267948966 - 0.17453292519943295 * sin((sine + 15) * 0.1), -1.9198621771937625 + 0.17453292519943295 * sin(sine * 0.1), 2.6179938779914944), deltaTime) 
            rightShoulder.C0 = rightShoulder.C0:Lerp(cf(1, 0.5, 0) * euler(-2.6179938779914944 - 0.17453292519943295 * sin((sine + 15) * 0.1), 1.9198621771937625 - 0.17453292519943295 * sin(sine * 0.1), -1.5707963267948966), deltaTime) 
            leftHip.C0 = leftHip.C0:Lerp(cf(-1, -0.8, 0) * euler(-0.4363323129985824 + 0.17453292519943295 * sin((sine - 25) * 0.1), -1.5882496193148399, 0), deltaTime) 
            rightHip.C0 = rightHip.C0:Lerp(cf(1, -0.5, -1) * euler(-0.4363323129985824 + 0.17453292519943295 * sin((sine - 15) * 0.1), 1.5707963267948966, 0), deltaTime) 
            --local MW_animator_progressSave = "0, 0, 0, 0.1, -80, 5, 45, 0.1, 1, 0, 0, 0.1, 0, 0, 0, 0.1, 0, 0, 0, 0.1, -181, 0, 0, 0.1, 0, 0, 0, 0.1, -85, -5, 30, 0.1, 0, 0, 0, 0.1, 0, 0, 0, 0.1, 0, 0, 0, 0.1, -181, 0, 0, 0.1, -1, 0, 0, 0.1, -90, -10, 15, 0.1, 0.5, 0, 0, 0.1, -110, 10, 0, 0.1, 0, 0, 0, 0.1, 150, 0, 0, 0.1, 1, 0, 0, 0.1, -150, -10, 15, 0.1, 0.5, 0, 0, 0.1, 110, -10, 0, 0.1, 0, 0, 0, 0.1, -90, 0, 0, 0.1, -1, 0, 0, 0.1, -25, 10, -25, 0.1, -0.8, 0, 0, 0.1, -91, 0, 0, 0.1, 0, 0, 0, 0.1, 0, 0, 0, 0.1, 1, 0, 0, 0.1, -25, 10, -15, 0.1, -0.5, 0, 0, 0.1, 90, 0, 0, 0.1, -1, 0, 0, 0.1, 0, 0, 0, 0.1"

        else -- fall

            neck.C0 = neck.C0:Lerp(cf(0, 1, 0) * euler(-1.7453292519943295 + 0.08726646259971647 * sin((sine + 45) * 0.1), 0, -3.1590459461097367), deltaTime) 
            rootJoint.C0 = rootJoint.C0:Lerp(cf(0, 0, 0) * euler(-1.6580627893946132 - 0.08726646259971647 * sin((sine + 30) * 0.1), 0, -3.1590459461097367), deltaTime) 
            leftShoulder.C0 = leftShoulder.C0:Lerp(cf(-1, 0.5, 0) * euler(-1.5707963267948966 - 0.17453292519943295 * sin((sine + 15) * 0.1), -1.0471975511965976 + 0.17453292519943295 * sin(sine * 0.1), -2.0943951023931953), deltaTime) 
            rightShoulder.C0 = rightShoulder.C0:Lerp(cf(1, 0.5, 0) * euler(2.0943951023931953 - 0.17453292519943295 * sin((sine + 15) * 0.1), 2.2689280275926285 + 0.17453292519943295 * sin(sine * 0.1), -1.5707963267948966), deltaTime) 
            leftHip.C0 = leftHip.C0:Lerp(cf(-1, -0.8, 0) * euler(-0.4363323129985824 + 0.17453292519943295 * sin((sine - 25) * 0.1), -1.5882496193148399, 0), deltaTime) 
            rightHip.C0 = rightHip.C0:Lerp(cf(1, -0.5, -1) * euler(-0.4363323129985824 + 0.17453292519943295 * sin((sine - 15) * 0.1), 1.5707963267948966, 0), deltaTime) 
            --local MW_animator_progressSave = "0, 0, 0, 0.1, -100, 5, 45, 0.1, 1, 0, 0, 0.1, 0, 0, 0, 0.1, 0, 0, 0, 0.1, -181, 0, 0, 0.1, 0, 0, 0, 0.1, -95, -5, 30, 0.1, 0, 0, 0, 0.1, 0, 0, 0, 0.1, 0, 0, 0, 0.1, -181, 0, 0, 0.1, -1, 0, 0, 0.1, -90, -10, 15, 0.1, 0.5, 0, 0, 0.1, -60, 10, 0, 0.1, 0, 0, 0, 0.1, -120, 0, 0, 0.1, 1, 0, 0, 0.1, 120, -10, 15, 0.1, 0.5, 0, 0, 0.1, 130, 10, 0, 0.1, 0, 0, 0, 0.1, -90, 0, 0, 0.1, -1, 0, 0, 0.1, -25, 10, -25, 0.1, -0.8, 0, 0, 0.1, -91, 0, 0, 0.1, 0, 0, 0, 0.1, 0, 0, 0, 0.1, 1, 0, 0, 0.1, -25, 10, -15, 0.1, -0.5, 0, 0, 0.1, 90, 0, 0, 0.1, -1, 0, 0, 0.1, 0, 0, 0, 0.1"

        end
        
    else -- idle

		if not mode then
		    
            neck.C0 = neck.C0:Lerp(cf(0, 1, 0) * euler(-1.5707963267948966 + 0.08726646259971647 * sin((sine - 60) * 0.05), 0, -3.490658503988659 + 0.5235987755982988 * sin(sine * 0.0125)), deltaTime) 
            rootJoint.C0 = rootJoint.C0:Lerp(cf(0, 0.1 * sin(sine * 0.05), 0) * euler(-1.5707963267948966 + 0.08726646259971647 * sin((sine - 30) * 0.05), 0, -2.792526803190927), deltaTime) 
            leftShoulder.C0 = leftShoulder.C0:Lerp(cf(-1, 0.5 - 0.1 * sin((sine + 40) * 0.05), 0) * euler(1.5707963267948966, -1.3962634015954636 + 0.17453292519943295 * sin((sine + 30) * 0.05), 1.2217304763960306), deltaTime) 
            rightShoulder.C0 = rightShoulder.C0:Lerp(cf(1, 0.5 - 0.1 * sin((sine + 40) * 0.05), 0) * euler(1.5707963267948966, 1.7453292519943295 - 0.08726646259971647 * sin((sine + 30) * 0.05), -1.5707963267948966), deltaTime) 
            leftHip.C0 = leftHip.C0:Lerp(cf(-1 + 0.06 * sin((sine + 30) * 0.05), -1.1 - 0.1 * sin(sine * 0.05), -0.11 * sin((sine + 30) * 0.05)) * euler(1.3962634015954636 - 0.08726646259971647 * sin((sine - 20) * 0.05), -1.7453292519943295, 1.7453292519943295), deltaTime) 
            rightHip.C0 = rightHip.C0:Lerp(cf(1 + 0.06 * sin((sine + 30) * 0.05), -1.1 - 0.1 * sin(sine * 0.05), -0.11 * sin((sine + 30) * 0.05)) * euler(2.0943951023931953 + 0.08726646259971647 * sin((sine + 40) * 0.05), 1.7453292519943295, -1.7453292519943295), deltaTime) 
            --local MW_animator_progressSave = "0,  0,  0,  0.1,  -90,  5,  -60,  0.05,  1,  0,  0,  0.1,  0,  0,  0,  0.025,  0,  0,  0,  0.1,  -200,  30,  0,  0.0125,  0,  0,  0,  0.1,  -90,  5,  -30,  0.05,  0,  0.1,  0,  0.05,  0,  0,  0,  0.1,  0,  0,  0,  0.1,  -160,  0,  0,  0.1,  -1,  0,  0,  0.1,  90,  0,  0,  0.1,  0.5,  -0.1,  40,  0.05,  -80,  10,  30,  0.05,  0,  0,  0,  0.1,  70,  0,  0,  0.1,  1,  0,  0,  0.1,  90,  0,  0,  0.05,  0.5,  -0.1,  40,  0.05,  100,  -5,  30,  0.05,  0,  0,  0,  0.1,  -90,  0,  0,  0.1,  -1,  0.06,  30,  0.05,  80,  -5,  -20,  0.05,  -1.1,  -0.1,  0,  0.05,  -100,  0,  0,  0.1,  0,  -0.11,  30,  0.05,  100,  0,  0,  0.1,  1,  0.06,  30,  0.05,  120,  5,  40,  0.05,  -1.1,  -0.1,  0,  0.05,  100,  0,  0,  0.1,  0,  -0.11,  30,  0.05,  -100,  0,  0,  0.1"

		elseif mode == "kazotsky" then

            neck.C0 = neck.C0:Lerp(cf(0, 1, 0) * euler(-1.6580627893946132 - 0.04363323129985824 * sin(sine * 0.4), -0.12217304763960307 * sin((sine + 2.5) * 0.2), -3.1590459461097367 - 0.20943951023931956 * sin(sine * 0.2)), deltaTime) 
            rootJoint.C0 = rootJoint.C0:Lerp(cf(0, 0.2 + 0.25 * sin((sine + 2.5) * 0.4), 0) * euler(-1.4835298641951802 + 0.08726646259971647 * sin(sine * 0.4), 0.08726646259971647 * sin(sine * 0.2), -3.1590459461097367 + 0.17453292519943295 * sin(sine * 0.2)), deltaTime) 
            leftShoulder.C0 = leftShoulder.C0:Lerp(cf(-0.7 - 0.07 * sin((sine - 2.5) * 0.2), 0.2 + 0.05 * sin(sine * 0.2), -0.2 + 0.1 * sin(sine * 0.2)) * euler(0.08726646259971647 * sin(sine * 0.4), 3.2288591161895095 + 0.17453292519943295 * sin(sine * 0.2), -1.4835298641951802 - 0.03490658503988659 * sin((sine - 15) * 0.4)), deltaTime) 
            rightShoulder.C0 = rightShoulder.C0:Lerp(cf(0.7 - 0.07 * sin((sine - 2.5) * 0.2), 0.2 - 0.05 * sin(sine * 0.2), -0.2 - 0.1 * sin(sine * 0.2)) * euler(0.08726646259971647 * sin(sine * 0.4), 3.0543261909900767 + 0.17453292519943295 * sin(sine * 0.2), 1.4835298641951802 + 0.03490658503988659 * sin((sine - 15) * 0.4)), deltaTime) 
            leftHip.C0 = leftHip.C0:Lerp(cf(-1, -1, 0) * euler(1.3089969389957472 + 0.8726646259971648 * sin(sine * 0.2), -1.6580627893946132 + 0.08726646259971647 * sin(sine * 0.2), 0.8726646259971648), deltaTime) 
            rightHip.C0 = rightHip.C0:Lerp(cf(1, -1, 0) * euler(1.3089969389957472 - 0.8726646259971648 * sin(sine * 0.2), 1.6580627893946132 + 0.08726646259971647 * sin(sine * 0.2), -0.8726646259971648), deltaTime) 
            --local MW_animator_progressSave = "0,   0,   0,   0.1,   -95,  -2.5,  0,   0.4,   1,   0,   0,   0.1,   0,  -7,  2.5,   0.2,   0,   0,   0,   0.1,   -181,  -12,  0,   0.2,   0,   0,   0,   0.1,   -85,   5,   0,   0.4,   0.2,   0.25,    2.5,   0.4,   0,   5,   0,   0.2,   0,   0,   0,   0.1,   -181,   10,   0,   0.2,   -0.7,   -0.07,   -2.5,   0.2,   0,   5,   0,   0.4,   0.2,   0.05,   0,   0.2,   185,   10,   0,   0.2,  -0.2,   0.1,   0,   0.2,   -85,  -2,    -15,   0.4,   0.7,   -0.07,   -2.5,   0.2,   0,   5,   0,   0.4,   0.2,  -0.05,   0,   0.2,   175,   10,   0,   0.2,  -0.2,  -0.1,   0,   0.2,   85,  2,  -15,   0.4,   -1,   0,   0,   0.1,  75,   50,   0,   0.2,   -1,   0,   0,   0.1,   -95,  5,   0,   0.2,   0,   0,   0,   0.1,   50,   0,   0,   0.1,   1,   0,   0,   0.1,   75,   -50,   0,   0.2,   -1,   0,   0,   0.1,  95,  5,   0,   0.2,   0,   0,   0,   0.1,   -50,   0,   0,     0.1"

		elseif mode == "sit" then
		    
            neck.C0 = neck.C0:Lerp(cf(0, 1, 0) * euler(-1.5882496193148399 - 0.04363323129985824 * sin((sine - 35) * 0.05), 0, -3.1590459461097367 + 0.5235987755982988 * sin(sine * 0.0125)), deltaTime) 
            rootJoint.C0 = rootJoint.C0:Lerp(cf(0, -1.75 + 0.1 * sin(sine * 0.05), 0.0375 * sin((sine + 5) * 0.05)) * euler(-1.3962634015954636 + 0.04363323129985824 * sin((sine + 5) * 0.05), 0, -3.1590459461097367), deltaTime) 
            leftShoulder.C0 = leftShoulder.C0:Lerp(cf(-1, 0.25 - 0.1 * sin(sine * 0.05), 0) * euler(0, -1.3962634015954636 + 0.08726646259971647 * sin((sine + 10) * 0.05), 0.17453292519943295 - 0.04363323129985824 * sin((sine + 5) * 0.05)), deltaTime) 
            rightShoulder.C0 = rightShoulder.C0:Lerp(cf(1, 0.25 - 0.1 * sin(sine * 0.05), 0) * euler(0, 1.3962634015954636 - 0.08726646259971647 * sin((sine + 10) * 0.05), -0.17453292519943295 + 0.04363323129985824 * sin((sine + 5) * 0.05)), deltaTime) 
            leftHip.C0 = leftHip.C0:Lerp(cf(-1, -0.75 - 0.05 * sin(sine * 0.05), -0.5) * euler(1.3089969389957472 - 0.08726646259971647 * sin((sine + 5) * 0.05), -1.5882496193148399, 0), deltaTime) 
            rightHip.C0 = rightHip.C0:Lerp(cf(1, 0.25 - 0.15 * sin(sine * 0.05), -1 - 0.17 * sin((sine + 7.5) * 0.05)) * euler(0, 1.5707963267948966, -0.12217304763960307 * sin((sine + 5) * 0.05)), deltaTime) 
            --local MW_animator_progressSave = "0, 0, 0, 0.1, -91, -2.5, -35, 0.05, 1, 0, 0, 0.1, 0, 0, 0, 0.1, 0, 0, 0, 0.1, -181, 30, 0, 0.0125, 0, 0, 0, 0.1, -80, 2.5, 5, 0.05, -1.75, 0.1, 0, 0.05, 0, 0, 0, 0.1, 0, 0.0375, 5, 0.05, -181, 0, 0, 0.1, -1, 0, 0, 0.1, -0, 0, 0, 0.1, 0.25, -0.1, 0, 0.05, -80, 5, 10, 0.05, 0, 0, 0, 0.1, 10, -2.5, 5, 0.05, 1, 0, 0, 0.1, 0, 0, 0, 0.1, 0.25, -0.1, 0, 0.05, 80, -5, 10, 0.05, 0, 0, 0, 0.1, -10, 2.5, 5, 0.05, -1, 0, 0, 0.1, 75, -5, 5, 0.05, -0.75, -0.05, 0, 0.05, -91, 0, 0, 0.1, -0.5, 0, 0, 0.1, 0, 0, 0, 0.1, 1, 0, 0, 0.1, 0, 0, 5, 0.05, 0.25, -0.15, 0, 0.05, 90, 0, 0, 0.1, -1, -0.17, 7.5, 0.05, 0, -7, 5, 0.05"		

        elseif mode == "wave" then
		    
		    neck.C0 = neck.C0:Lerp(cf(0, 1, 0) * euler(-1.5882496193148399, -0.17453292519943295 * sin((sine - 6) * 0.1), -3.1590459461097367), deltaTime) 
            rootJoint.C0 = rootJoint.C0:Lerp(cf(0.2 * sin((sine - 10) * 0.1), 0, 0) * euler(-1.5707963267948966, 0.17453292519943295 * sin((sine - 10) * 0.1), -3.1590459461097367), deltaTime) 
            leftShoulder.C0 = leftShoulder.C0:Lerp(cf(-1 + 0.025 * sin((sine - 20) * 0.1), 0.5, 0) * euler(1.5707963267948966, -1.631882850614698 + 0.061086523819801536 * sin((sine - 20) * 0.1), 1.5707963267948966), deltaTime) 
            rightShoulder.C0 = rightShoulder.C0:Lerp(cf(1 - 0.15 * sin(sine * 0.1), 1.4, 0) * euler(1.5707963267948966, 1.3962634015954636 + 0.3490658503988659 * sin(sine * 0.1), 1.5707963267948966), deltaTime) 
            leftHip.C0 = leftHip.C0:Lerp(cf(-1 - 0.025 * sin((sine - 10) * 0.1), -0.95 - 0.175 * sin((sine - 10) * 0.1), 0) * euler(1.5707963267948966, -1.7453292519943295 + 0.17453292519943295 * sin((sine - 10) * 0.1), 1.5707963267948966), deltaTime) 
            rightHip.C0 = rightHip.C0:Lerp(cf(1 - 0.025 * sin((sine - 10) * 0.1), -0.95 + 0.175 * sin((sine - 10) * 0.1), 0) * euler(1.5707963267948966, 1.7453292519943295 + 0.17453292519943295 * sin((sine - 10) * 0.1), -1.5707963267948966), deltaTime) 
            --local MW_animator_progressSave = "0, 0, 0, 0.1, -91, 0, 0, 0.1, 1, 0, 0, 0.1, 0, -10, -6, 0.1, 0, 0, 0, 0.1, -181, 0, 0, 0.1, 0, 0.2, -10, 0.1, -90, 0, 0, 0.1, 0, 0, 0, 0.1, 0, 10, -10, 0.1, 0, 0, 0, 0.1, -181, 0, 0, 0.1, -1, 0.025, -20, 0.1, 90, 0, 0, 0.1, 0.5, 0, 0, 0.1, -93.5, 3.5, -20, 0.1, 0, 0, 0, 0.1, 90, 0, 0, 0.1, 1, -0.15, 0, 0.1, 90, 0, 0, 0.1, 1.4, 0, 0, 0.1, 80, 20, 0, 0.1, 0, 0, 0, 0.1, 90, 0, 0, 0.1, -1, -0.025, -10, 0.1, 90, 0, 0, 0.1, -0.95, -0.175, -10, 0.1, -100, 10, -10, 0.1, 0, 0, 0, 0.1, 90, 0, 0, 0.1, 1, -0.025, -10, 0.1, 90, 0, 0, 0.1, -0.95, 0.175, -10, 0.1, 100, 10, -10, 0.1, 0, 0, 0, 0.1, -90, 0, 0, 0.1"

        elseif mode == "lay" then

            neck.C0 = neck.C0:Lerp(cf(0, 1, 0) * euler(-2.007128639793479 - 0.08726646259971647 * sin(sine * 0.05), 0, -3.1590459461097367 + 0.04363323129985824 * sin(sine * 0.05)), deltaTime) 
            rootJoint.C0 = rootJoint.C0:Lerp(cf(0, -2.4 - 0.05 * sin(sine * 0.05), 0) * euler(-0.04363323129985824 + 0.04363323129985824 * sin(sine * 0.05), 0, -3.1590459461097367), deltaTime) 
            leftShoulder.C0 = leftShoulder.C0:Lerp(cf(-0.6, 1.2, 0) * euler(1.9198621771937625 - 0.1308996938995747 * sin(sine * 0.05), -2.2689280275926285, -1.5707963267948966), deltaTime) 
            rightShoulder.C0 = rightShoulder.C0:Lerp(cf(1, 0.5, -0.3) * euler(1.2217304763960306, 0.17453292519943295, -1.0471975511965976 - 0.04363323129985824 * sin(sine * 0.05)), deltaTime) 
            leftHip.C0 = leftHip.C0:Lerp(cf(-1, -1 - 0.04 * sin(sine * 0.05), -1) * euler(-0.04363323129985824 * sin(sine * 0.05), -1.5707963267948966, 0.8726646259971648), deltaTime) 
            rightHip.C0 = rightHip.C0:Lerp(cf(0, -1, 0) * euler(1.5707963267948966 - 0.04363323129985824 * sin(sine * 0.05), -1.4835298641951802, 1.5707963267948966), deltaTime) 
            --local MW_animator_progressSave = "0,  0,  0,  0.1,  -115,  -5,  0,  0.05,  1,  0,  0,  0.1,  0, 0,  0,  0.1,  0, ,  0,  0.05,  -181, 2.5,  0,  0.05,  0,  0,  0,  0.1,  -2.5,  2.5,  0,  0.05,  -2.4,  -0.05,  0,  0.05,  0,  0,  0,  0.1,  0,  0,  0,  0.1,  -181,  0,  0,  0.1,  -0.6,  0,  0,  0.1, 110, -7.5,  0,  0.05,  1.2,  0,  0,  0.1, -130,  0,  0,  0.1,  0,  0,  0,  0.1, -90,  0,  0,  0.1,  1,  0,  0,  0.1, 70, 0,  0,  0.1,  0.5,  0,  0,  0.1,  10, 0,  0,  0.1, -0.3,  0,  0,  0.1, -60, -2.5,  0,  0.05,  -1,  0,  0,  0.1, 0, -2.5,  0,  0.05,  -1, -0.04,  0,  0.05, -90,  0,  0,  0.1,  -1,  0,  0,  0.1, 50,  0,  0,  0.1, -,  0,  0,  0.1, 90, -2.5,  0,  0.05,  -1,  0,  0,  0.1, -85,  0,  0,  0.1, -,  0,  0,  0.1, 90, 0,  0,  0.1"

		elseif mode == "dab" then

            neck.C0 = neck.C0:Lerp(cf(0, 1, 0) * euler(-2.0943951023931953 - 0.08726646259971647 * sin((sine + 10) * 0.05), -0.08726646259971647, -3.490658503988659), deltaTime) 
            rootJoint.C0 = rootJoint.C0:Lerp(cf(0, 0.1 * sin(sine * 0.05), 0) * euler(-1.6580627893946132, 0.08726646259971647, -3.2288591161895095), deltaTime) 
            leftShoulder.C0 = leftShoulder.C0:Lerp(cf(-1.5, 0.5, 0) * euler(-1.7453292519943295, 0.17453292519943295 - 0.05235987755982989 * sin((sine + 30) * 0.05), -1.4835298641951802 + 0.08726646259971647 * sin((sine - 5) * 0.05)), deltaTime) 
            rightShoulder.C0 = rightShoulder.C0:Lerp(cf(1, 1.2, 0) * euler(-0.5235987755982988 - 0.08726646259971647 * sin((sine + 15) * 0.05), 2.443460952792061, 1.7453292519943295), deltaTime) 
            leftHip.C0 = leftHip.C0:Lerp(cf(-1, -1 - 0.1 * sin(sine * 0.05), 0) * euler(1.5707963267948966, -1.7453292519943295, 1.5707963267948966), deltaTime) 
            rightHip.C0 = rightHip.C0:Lerp(cf(1, -0.9 - 0.1 * sin(sine * 0.05), 0) * euler(1.7453292519943295, 1.7453292519943295, -1.5707963267948966), deltaTime) 
            --local MW_animator_progressSave = "0, 0, 0, 0.1, -120, -5, 10, 0.05, 1, 0, 0, 0.1, -5, 0, 0, 0.1, 0, 0, 0, 0.1, -200, 0, 0, 0.1, 0, 0, 0, 0.1, -95, 0, 0, 0.1, 0, 0.1, 0, 0.05, 5, 0, 0, 0.1, 0, 0, 0, 0.1, -185, 0, 0, 0.1, -1.5, 0, 0, 0.1, -100, 0, 0, 0.1, 0.5, -0., 30, 0.05, 10, -3, 30, 0.05, 0, 0, 0, 0.1, -85, 5, -5, 0.05, 1, 0, 0, 0.1, -30, -5, 15, 0.05, 1.2, 0, 0, 0.1, 140, 0, 0, 0.1, 0, 0, 0, 0.1, 100, 0, 0, 0.1, -1, 0, 0, 0.1, 90, 0, 0, 0.1, -1, -0.1, 0, 0.05, -100, 0, 0, 0.1, 0, 0, 0, 0.1, 90, 0, 0, 0.1, 1, 0, 0, 0.1, 100, 0, 0, 0.1, -0.9, -0.1, 0, 0.05, 100, 0, 0, 0.1, 0, 0, 0, 0.1, -90, 0, 0, 0.1"

		elseif mode == "dance" then

            neck.C0 = neck.C0:Lerp(cf(0, 1, 0) * euler(-1.5882496193148399 + 0.08726646259971647 * sin((sine + 15) * 0.1), 0.08726646259971647 * sin(sine * 0.1), -2.9670597283903604 + 0.2617993877991494 * sin((sine + 15) * 0.1)), deltaTime) 
            rootJoint.C0 = rootJoint.C0:Lerp(cf(-0.1 * sin(sine * 0.1), 0.1 * sin(sine * 0.1), 0) * euler(-1.5882496193148399 + 0.17453292519943295 * sin((sine + 5) * 0.1), 0, -3.1590459461097367 + 0.2617993877991494 * sin(sine * 0.1)), deltaTime) 
            leftShoulder.C0 = leftShoulder.C0:Lerp(cf(-1, 0.75 + 0.25 * sin(sine * 0.1), -0.5) * euler(2.792526803190927, -1.5707963267948966 - 1.2217304763960306 * sin((sine + 10) * 0.1), 1.5707963267948966 - 0.6981317007977318 * sin((sine + 10) * 0.1)), deltaTime) 
            rightShoulder.C0 = rightShoulder.C0:Lerp(cf(0.7, 0.5, 0) * euler(1.9198621771937625, 0.5235987755982988 + 0.08726646259971647 * sin((sine + 5) * 0.1), -1.5707963267948966), deltaTime) 
            leftHip.C0 = leftHip.C0:Lerp(cf(-1, -1, 0) * euler(1.5707963267948966 - 0.17453292519943295 * sin((sine + 5) * 0.1), -1.7453292519943295 + 0.08726646259971647 * sin(sine * 0.1), 1.5707963267948966), deltaTime) 
            rightHip.C0 = rightHip.C0:Lerp(cf(1, -1, 0) * euler(1.5707963267948966, 1.7453292519943295 + 0.08726646259971647 * sin(sine * 0.1), -1.5707963267948966 - 0.3490658503988659 * sin((sine + 5) * 0.1)), deltaTime) 
            --local MW_animator_progressSave = "0, 0, 0, 0.1, -91, 5, 15, 0.1, 1, 0, 0, 0.1, 0, 5, 0, 0.1, 0, 0, 0, 0.1, -170, 15, 15, 0.1, 0, -0.1, 0, 0.1, -91, 10, 5, 0.1, 0, 0.1, 0, 0.1, 0, 0, 0, 0.1, 0, 0, 0, 0.1, -181, 15, 0, 0.1, -1, 0, 0, 0.1, 160, 0, 0, 0.1, 0.75, 0.25, 0, 0.1, -90, -70, 10, 0.1, -0.5, 0, 0, 0.1, 90, -40, 10, 0.1, 0.7, 0, 0, 0.1, 110, 0, 0, 0.1, 0.5, 0, 0, 0.1, 30, 5, 5, 0.1, 0, 0, 0, 0.1, -90, 0, 0, 0.1, -1, 0, 0, 0.1, 90, -10, 5, 0.1, -1, 0, 0, 0.1, -100, 5, 0, 0.1, 0, 0, 0, 0.1, 90, 0, 0, 0.1, 1, 0, 0, 0.1, 90, 0, 0, 0.1, -1, 0, 0, 0.1, 100, 5, 0, 0.1, 0, 0, 0, 0.1, -90, -20, 5, 0.1"

		elseif mode == "L" then

            neck.C0 = neck.C0:Lerp(cf(0, 1, 0) * euler(-1.5882496193148399 + 0.08726646259971647 * sin((sine - 1.75) * 0.4), 0.08726646259971647 * sin((sine + 2.5) * 0.2), 3.141592653589793), 0.2) 
            rootJoint.C0 = rootJoint.C0:Lerp(cf(0, 0.1 + 0.2 * sin((sine + 3.75) * 0.4), 0) * euler(-1.4835298641951802 + 0.04363323129985824 * sin((sine + 3.75) * 0.4), -0.08726646259971647 * sin(sine * 0.2), 3.141592653589793), 0.2) 
            leftShoulder.C0 = leftShoulder.C0:Lerp(cf(-0.7, 0.42, -0.2) * euler(-0.8726646259971648, -2.2689280275926285 + 0.17453292519943295 * sin(sine * 0.2), -1.3962634015954636), 0.2) 
            rightShoulder.C0 = rightShoulder.C0:Lerp(cf(1, 1, 0) * euler(0.7853981633974483, 2.443460952792061, 1.5707963267948966 + 0.08726646259971647 * sin((sine - 1.75) * 0.4)), 0.2) 
            leftHip.C0 = leftHip.C0:Lerp(cf(-1, -0.8 - 0.1 * sin((sine - 1.75) * 0.2), 0) * euler(1.3962634015954636, -2.0943951023931953 + 0.5235987755982988 * sin(sine * 0.2), 1.2217304763960306 + 0.5235987755982988 * sin(sine * 0.2)), 0.2) 
            rightHip.C0 = rightHip.C0:Lerp(cf(1, -0.8 + 0.1 * sin((sine - 1.75) * 0.2), 0) * euler(1.3962634015954636, 2.0943951023931953 + 0.5235987755982988 * sin(sine * 0.2), -1.2217304763960306 + 0.5235987755982988 * sin(sine * 0.2)), 0.2) 
            --local MW_animator_progressSave = "0,   0,   0,   0.1,   -91,   5,   -1.75,   0.4,   1,   0,   0,   0.1,   -0,   5, 2.5,   0.2,   0,   0,   0,   0.1,   180,   0,   0,   0.1,   0,   0,   0,   0.1,   -85,   2.5, 3.75,   0.4,   0.1,   0.2, 3.75,   0.4,   -0,   -5,   0,   0.2,   0,   0,   0,   0.1,   180,   0,   0,   0.1,   -0.7,   0,   0,   0.1,   -50,   0,   0,   0.1,   0.42,   0,   0,   0.1,   -130,   10,   0,   0.2,   -0.2,   0,   0,   0.1,   -80,   0,   -10,   0.1,   1,   0,   0,   0.1,   45,   0,   -5,   0.1,   1,   0,   0,   0.1,   140, -7, 3.75,   0.,   0,   0,   0,   0.1,   90,   5,   -1.75,   0.4,   -1,   0,   0,   0.1,   80,   0,   0,   0.1,   -0.8,   -0.1,   -1.75,   0.2,   -120,   30,   0,   0.2,   0,   0,   0,   0.1,   70,   30,   0,   0.2,   1,   0,   0,   0.1,   80,   0,   0,   0.1,   -0.8,   0.1,   -1.75,   0.2,   120,   30,   0,   0.2,   0,   0,   0,   0.1,   -70,   30,   0,   0.2"

		elseif mode == "fly" then

            neck.C0 = neck.C0:Lerp(cf(0, 1, 0) * euler(-1.9198621771937625 + -0.08726646259971647 * sin((sine + 15) * 0.05), 0.5235987755982988 + 0.08726646259971647 * sin((sine + 10) * 0.05), -3.1590459461097367), deltaTime) 
            rootJoint.C0 = rootJoint.C0:Lerp(cf(0, 5 + 1 * sin(sine * 0.05), 0) * euler(-1.9198621771937625 + -0.17453292519943295 * sin((sine + 30) * 0.05), 0.3490658503988659 + 0.08726646259971647 * sin((sine + 30) * 0.05), 2.9670597283903604), deltaTime) 
            leftShoulder.C0 = leftShoulder.C0:Lerp(cf(-0.7, 0.1 + 0.1 * sin(sine * 0.05), -0.5) * euler(-0.08726646259971647 * sin((sine + 15) * 0.05), 2.9670597283903604, -1.7453292519943295 + 0.05235987755982989 * sin((sine + 10) * 0.05)), deltaTime) 
            rightShoulder.C0 = rightShoulder.C0:Lerp(cf(1, 0.1 + -0.15 * sin((sine + 10) * 0.05), -1.1) * euler(2.0943951023931953, 1.9198621771937625 + -0.03490658503988659 * sin((sine + 30) * 0.05), 1.5707963267948966), deltaTime) 
            leftHip.C0 = leftHip.C0:Lerp(cf(-1, -1, 0) * euler(1.5707963267948966, -1.3089969389957472 + 0.17453292519943295 * sin((sine + 20) * 0.05), 1.1344640137963142 + -0.17453292519943295 * sin((sine + 55) * 0.05)), deltaTime) 
            rightHip.C0 = rightHip.C0:Lerp(cf(1, -1, 0) * euler(1.5707963267948966, 2.007128639793479 + -0.08726646259971647 * sin((sine + 10) * 0.05), -1.1344640137963142 + 0.17453292519943295 * sin((sine + 55) * 0.05)), deltaTime) 
            --[[MW_animator progress save: 0,  0,  0,  0.1,  -110,  -5,  15,  0.05,  1,  0,  0,  0.1,  30,  5,  10,  0.05,  0,  0,  0,  0.1,  -181,  0,  30,  0.025,  0,  0,  0,  0.025,  -110,  -10,  30,  0.05,  5,  1,  0,  0.05,  20,  5,  30,  0.05,  0,  0,  0,  0.0125, 170,  0,  0,  0.025,  -0.7,  0,  0,  0.1,  0,  -5,  15,  0.05,  0.1,  0.1,  0,  0.05,  170,  0,  0,  0.1,  -0.5,  0,  0,  0.1,  -100,  3,  10,  0.05,  1,  0,  0,  0.1,  120,  0,  0,  0.1,  0.1,  -0.15,  10,  0.05,  110,  -2,  30,  0.05,  -1.1,  0,  0,  0.1,  90,  0,  0,  0.1,  -1,  0,  0,  0.1,  90,  0,  0,  0.1,  -1,  0,  0,  0.1,  -75,  10,  20,  0.05,  0,  0,  0,  0.1,  65,  -10,  55,  0.05,  1,  0,  0,  0.1,  90,  0,  30,  0.05,  -1,  0,  0,  0.1,  115,  -5,  10,  0.05,  0,  0,  0,  0.1,  -65,  10,  55,  0.05]]

		elseif mode == "floss" then

            neck.C0 = neck.C0:Lerp(cf(0, 1, 0) * euler(-1.5882496193148399 + 0.08726646259971647 * sin((sine - 3.75) * 0.15), -0.1308996938995747 * sin(sine * 0.2), -3.1590459461097367 + 0.5235987755982988 * sin(sine * 0.0125)), deltaTime) 
            rootJoint.C0 = rootJoint.C0:Lerp(cf(-0.2 * sin(sine * 0.2), 0, 0) * euler(-1.5882496193148399, 0.17453292519943295 * sin(sine * 0.2), -3.1590459461097367), deltaTime) 
            leftShoulder.C0 = leftShoulder.C0:Lerp(cf(-1 + 0.2 * sin(sine * 0.2), 0.5 + 0.2 * sin(sine * 0.2), 0) * euler(1.5707963267948966 + 0.6981317007977318 * sin((sine + 7.5) * 0.1), -1.5882496193148399 + 0.7853981633974483 * sin(sine * 0.2), 1.5707963267948966), deltaTime) 
            rightShoulder.C0 = rightShoulder.C0:Lerp(cf(1 + 0.2 * sin(sine * 0.2), 0.4 - 0.2 * sin(sine * 0.2), 0) * euler(1.5707963267948966 + 0.6981317007977318 * sin((sine + 25) * 0.1), 1.5707963267948966 + 0.7853981633974483 * sin(sine * 0.2), -1.5707963267948966), deltaTime) 
            leftHip.C0 = leftHip.C0:Lerp(cf(-1, -1 - 0.2 * sin(sine * 0.2), 0) * euler(1.5707963267948966, -1.7453292519943295 + 0.3490658503988659 * sin(sine * 0.2), 1.5707963267948966), deltaTime) 
            rightHip.C0 = rightHip.C0:Lerp(cf(1, -1 + 0.2 * sin(sine * 0.2), 0) * euler(1.5707963267948966, 1.7453292519943295 + 0.3490658503988659 * sin(sine * 0.2), -1.5707963267948966), deltaTime) 
            --local MW_animator_progressSave = "0,    0,    0,    0.1,    -91,   5,    -3.75,    0.15,    1,    0,    0,    0.1,    0,    -7.5,    0,    0.2,    0,    0,    0,    0.1,    -181,    30,    0,    0.0125,    0,    -0.2,    0,    0.2,    -91,    0,    15,    0,    0,   0,    0,   0,    0,    10,    0,    0.2,    0,    0,    0,    0.1,    -181,    0,    0,    0.1,    -1, 0.2,    0,    0.2,    90, 40, 7.5,    0.1,    0.5, 0.2,    0,    0.2,    -91, 45,    0,    0.2,    0,    0,    0,    0.1,    90,    0,    0,    0.1,    1, 0.2,    0,    0.2,    90, 40, 25,    0.1,    0.4, -0.2,    0,    0.2,    90, 45,    0,    0.2,    0,    0,    0,    0.1,    -90,    0,    0,    0.1,    -1,    0,    0,    0.1,    90,    0,    0,    0.1,    -1,    -0.2,    0,    0.2,    -100,    20,    0,    0.2,    0,    0,    0,    0.1,    90,    0,    0,    0.1,    1,    0,    0,    0.1,    90,    0,    0,    0.1,    -1,    0.2,    0,    0.2,    100,    20,    0,    0.2,    0,    0,    0,    0.1,    -90,    0,    0,    0.1"		

		elseif mode == "rickroll" then
        
            neck.C0 = neck.C0:Lerp(cf(0, 1, 0) * euler(-1.6580627893946132 + 0.03490658503988659 * sin((sine - 10) * 0.075), -0.08726646259971647 * sin((sine + 10) * 0.0375), -3.141592653589793 - 0.17453292519943295 * sin((sine + 20) * 0.0375)), deltaTime) 
            rootJoint.C0 = rootJoint.C0:Lerp(cf(0.1 * sin((sine + 5) * 0.0375), -0.4 + 0.3 * sin(sine * 0.075), 0) * euler(-1.3962634015954636, 0.12217304763960307 * sin((sine + 10) * 0.0375), -3.141592653589793 + 0.17453292519943295 * sin((sine + 15) * 0.0375)), deltaTime) 
            leftShoulder.C0 = leftShoulder.C0:Lerp(cf(-1, -0.2, 0.1) * euler(3.3161255787892263 - 0.08726646259971647 * sin(sine * 0.2), -1.5707963267948966 - 0.2617993877991494 * sin(sine * 0.2), 1.5707963267948966), deltaTime) 
            rightShoulder.C0 = rightShoulder.C0:Lerp(cf(1, -0.2, 0.1) * euler(3.3161255787892263 + 0.08726646259971647 * sin(sine * 0.2), 1.5707963267948966 - 0.2617993877991494 * sin(sine * 0.2), -1.5707963267948966), deltaTime) 
            leftHip.C0 = leftHip.C0:Lerp(cf(-1, -0.75 - 0.25 * sin(sine * 0.075), -0.2) * euler(1.2217304763960306, -1.5707963267948966 + 0.1308996938995747 * sin((sine + 10) * 0.0375), 1.5707963267948966), deltaTime) 
            rightHip.C0 = rightHip.C0:Lerp(cf(1, -0.75 - 0.3 * sin(sine * 0.075), -0.2) * euler(1.2217304763960306, 1.5707963267948966 + 0.1308996938995747 * sin((sine + 10) * 0.0375), -1.5707963267948966), deltaTime) 
            --local MW_animator_progressSave = "0, 0, 0, 0.1, -95, 2, -10, 0.075, 1, 0, 0, 0.1, 0, -5, 10, 0.0375, 0, 0, 0, 0.1, -180, -10, 20, 0.0375, 0, 0.1, 5, 0.0375, -80, 0, 0, 0.1, -0.4, 0.3, 0, 0.075, 0, 7, 10, 0.0375, 0, 0, 0, 0.1, -180, 10, 15, 0.0375, -1, 0, 0, 0.1, 190, -5, 0, 0.2, -0.2, 0, 0, 0.1, -90, -15, 0, 0.2, 0.1, 0, 0, 0.1, 90, 0, 0, 0.1, 1, 0, 0, 0.1, 190, 5, 0, 0.2, -0.2, 0, 0, 0.1, 90, -15, 0, 0.2, 0.1, 0, 0, 0.1, -90, 0, 0, 0.1, -1, 0, 0, 0.1, 70, 0, 0, 0.1, -0.75, -0.25, 0, 0.075, -90, 7.5, 10, 0.0375, -0.2, 0, 0, 0.1, 90, 0, 0, 0.1, 1, 0, 0, 0.1, 70, 0, 0, 0.1, -0.75, -0.3, 0, 0.075, 90, 7.5, 10, 0.0375, -0.2, 0, 0, 0.1, -90, 0, 0, 0.1"
        
        end
    end
end)