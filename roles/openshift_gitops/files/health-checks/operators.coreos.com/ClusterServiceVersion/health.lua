health_status = {}

succeeded = false
failed = false

if obj.status ~= nil then
  if obj.status.phase ~= nil then
    if obj.status.phase == "Succeeded" then
      succeeded = true
    end
    if obj.status.phase == "Failed" then
      failed = true
    end
  end
end

if failed == true then
  health_status.status = "Degraded"
  health_status.message = "Status phase is 'Failed'"
elseif succeeded == true then
  health_status.status = "Healthy"
  health_status.message = "Status phase is 'Succeeded'"
else
  health_status.status = "Progressing"
  health_status.message = "Status phase is not 'Failed' or 'Succeeded'"
end

return health_status
