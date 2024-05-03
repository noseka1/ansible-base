health_status = {}
if obj.status ~= nil then
  if obj.status.conditions ~= nil then
    numDegraded = 0
    numProgressing = 0
    msg = ""
    for i, condition in pairs(obj.status.conditions) do
      msg = msg .. i .. ": " .. condition.type .. " = " .. condition.status .. "\n"
      if condition.type == "Initialized" and condition.status == "False" then
        numDegraded = numDegraded + 1
      end
      if condition.type == "Available" and condition.status == "False" then
        numDegraded = numDegraded + 1
      end
      if condition.type == "Upgrading" and condition.status == "True" then
        numProgressing = numProgressing + 1
      end
    end
    if numProgressing > 0 then
      health_status.status = "Progressing"
      health_status.message = msg
      return health_status
    elseif numDegraded == 0 then
      health_status.status = "Healthy"
      health_status.message = msg
      return health_status
    else
      health_status.status = "Degraded"
      health_status.message = msg
      return health_status
    end
  end
end
health_status.status = "Progressing"
health_status.message = "Reconciliation in progress"
return health_status
