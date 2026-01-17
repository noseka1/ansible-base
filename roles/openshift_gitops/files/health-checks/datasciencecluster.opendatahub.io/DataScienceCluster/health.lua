health_status = {}

deployed = false

if obj.status ~= nil then
  if obj.status.phase ~= nil then
    if obj.status.phase == "Ready" then
      deployed = true
    end
  end
end

if deployed == true then
  health_status.status = "Healthy"
  health_status.message = "Status phase is 'Ready'"
else
  health_status.status = "Progressing"
  health_status.message = "Status phase is not 'Ready'"
end

return health_status
