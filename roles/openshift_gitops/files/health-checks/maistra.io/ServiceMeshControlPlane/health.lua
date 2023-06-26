health_status = {}
if obj.status ~= nil then
  if obj.status.conditions ~= nil then
    numInstalled = 0
    numReconciled = 0
    numReady = 0
    msg = ""
    for i, condition in pairs(obj.status.conditions) do
      msg = msg .. i .. ": " .. condition.type .. " = " .. condition.status .. "\n"
      if condition.type == "Installed" and condition.status == "True" then
        numInstalled = numInstalled + 1
      end
      if condition.type == "Reconciled" and condition.status == "True" then
        numReconciled = numReconciled + 1
      end
      if condition.type == "Ready" and condition.status == "True" then
        numReady = numReady + 1
      end
    end
    if numInstalled == 0 or numReconciled == 0 then
      health_status.status = "Progressing"
      health_status.message = msg
      return health_status
    elseif numReady == 0 then
      health_status.status = "Degraded"
      health_status.message = msg
      return health_status
    elseif numReady > 0 then
      health_status.status = "Healthy"
      health_status.message = msg
      return health_status
    end
  end
end
health_status.status = "Progressing"
health_status.message = "Reconciliation in progress"
return health_status
