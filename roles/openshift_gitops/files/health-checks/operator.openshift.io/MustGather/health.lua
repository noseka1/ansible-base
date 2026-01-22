health_status = {}

deployed = false

if obj.status ~= nil then
  if obj.status.status ~= nil then
    if obj.status.status == "Completed" then
      deployed = true
    end
  end
end

if deployed == true then
  health_status.status = "Healthy"
  health_status.message = "Status is 'Completed'"
else
  health_status.status = "Progressing"
  health_status.message = "Status is not 'Completed'"
end

return health_status
