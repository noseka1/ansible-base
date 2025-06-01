health_status = {}
if obj.status ~= nil then
  if obj.status.conditions ~= nil then
    numAvailable = 0
    numProgressing = 0
    numDegraded = 0
    msg = ""
    for i, condition in pairs(obj.status.conditions) do
      msg = msg .. i .. ": " .. condition.type .. " = " .. condition.status .. "\n"
      if condition.type == "Available" and condition.status == "True" then
        numAvailable = numAvailable + 1
      end
      if condition.type == "Progressing" and condition.status == "True" then
        numProgressing = numProgressing + 1
      end
      if condition.type == "ClusterVersionProgressing" and condition.status == "True" then
        numProgressing = numProgressing + 1
      end
      if condition.type == "ClusterVersionSucceeding" and condition.status == "False" then
        numProgressing = numProgressing + 1
      end
      if condition.type == "Degraded" and condition.status == "True" then
        numDegraded = numDegraded + 1
      end
    end
    if numDegraded > 0 then
      health_status.status = "Degraded"
      health_status.message = msg
      return health_status
    elseif numProgressing > 0 then
      health_status.status = "Progressing"
      health_status.message = msg
      return health_status
    elseif numAvailable > 0 then
      health_status.status = "Healthy"
      health_status.message = msg
      return health_status
    end
  end
end
health_status.status = "Progressing"
health_status.message = "Reconciliation in progress"
return health_status
