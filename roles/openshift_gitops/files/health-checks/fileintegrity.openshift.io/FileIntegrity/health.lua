health_status = {}

active = false

if obj.status ~= nil then
  if obj.status.phase ~= nil then
    if obj.status.phase == "Active" then
      active = true
    end
  end
end

if active == true then
  health_status.status = "Healthy"
  health_status.message = "Status phase is 'Active'"
else
  health_status.status = "Progressing"
  health_status.message = "Status phase is not 'Active'"
end

return health_status
