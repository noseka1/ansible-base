health_status = {}

active = false

if obj.status ~= nil then
  if obj.status.phase ~= nil then
    if obj.status.phase == "Available" then
      active = true
    end
  end
end

if active == true then
  health_status.status = "Healthy"
  health_status.message = "Status phase is 'Available'"
else
  health_status.status = "Progressing"
  health_status.message = "Status phase is not 'Available'"
end

return health_status
