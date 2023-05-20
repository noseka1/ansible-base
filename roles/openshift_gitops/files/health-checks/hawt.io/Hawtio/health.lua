health_status = {}

deployed = false

if obj.status ~= nil then
  if obj.status.phase ~= nil then
    if obj.status.phase == "Deployed" then
      deployed = true
    end
  end
end

if deployed == true then
  health_status.status = "Healthy"
  health_status.message = "Status phase is 'Deployed'"
else
  health_status.status = "Progressing"
  health_status.message = "Status phase is not 'Deployed'"
end

return health_status
