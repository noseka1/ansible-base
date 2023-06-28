health_status = {}
if obj.status ~= nil then
  if obj.status.conditions ~= nil then
    numFailure = 0
    numSuccessful = 0
    numRunning = 0
    msg = ""
    for i, condition in pairs(obj.status.conditions) do
      msg = msg .. i .. ": " .. condition.type .. " = " .. condition.status .. "\n"
      if condition.type == "Failure" and condition.status == "True" then
        numFailure = numFailure + 1
      end
      if condition.type == "Successful" and condition.status == "True" then
        numSuccessful = numSuccessful + 1
      end
      if condition.type == "Running" and condition.status == "True" then
        numRunning = numRunning + 1
      end
    end
    if numFailure > 0 then
      health_status.status = "Degraded"
      health_status.message = msg
      return health_status
    elseif numSuccessful > 0 and numRunning > 0 then
      health_status.status = "Healthy"
      health_status.message = msg
      return health_status
    end
  end
end
health_status.status = "Progressing"
health_status.message = "Reconciliation in progress"
return health_status
