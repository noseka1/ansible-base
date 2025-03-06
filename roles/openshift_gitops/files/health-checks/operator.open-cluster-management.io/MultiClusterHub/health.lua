health_status = {}
if obj.status ~= nil then
  if obj.status.conditions ~= nil then
    numComplete = 0
    msg = ""
    for i, condition in pairs(obj.status.conditions) do
      msg = msg .. i .. ": " .. condition.type .. " = " .. condition.status .. "\n"
      if condition.type == "Complete" and condition.status == "True" then
        numComplete = numComplete + 1
      end
    end
    if numComplete > 0 then
      health_status.status = "Healthy"
      health_status.message = msg
      return health_status
    end
  end
end
health_status.status = "Progressing"
health_status.message = "Reconciliation in progress"
return health_status
