health_status = {}
if obj.status ~= nil then
  if obj.status.conditions ~= nil then
    numDeployed = 0
    msg = ""
    for i, condition in pairs(obj.status.conditions) do
      msg = msg .. i .. ": " .. condition.type .. " = " .. condition.status .. "\n"
      if condition.type == "Deployed" and condition.status == "True" then
        numDeployed = numDeployed + 1
      end
    end
    if numDeployed > 0 then
      health_status.status = "Healthy"
      health_status.message = msg
      return health_status
    end
  end
end
health_status.status = "Progressing"
health_status.message = "Reconciliation in progress"
return health_status
