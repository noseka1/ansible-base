health_status = {}
if obj.status ~= nil then
  if obj.status.conditions ~= nil then
    numProgressing = 0
    numAvailable = 0
    msg = ""
    for i, condition in pairs(obj.status.conditions) do
      msg = msg .. i .. ": " .. condition.type .. " = " .. condition.status .. "\n"
      if condition.type == "ReconcileCompleted" and condition.status == "False" then
        numProgressing = numProgressing + 1
      end
      if condition.type == "DeploymentsHealthy" and condition.status == "True" then
        numAvailable = numAvailable + 1
      end
    end
    if numProgressing > 0 then
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
