health_status = {}

enabled = false
failed_validation = false

if obj.status ~= nil then
  if obj.status.phase ~= nil then
    if obj.status.phase == "Enabled" then
      enabled = true
    end
    if obj.status.phase == "FailedValidation" then
      failed_validation = true
    end
  end
end

if failed_validation == true then
  health_status.status = "Degraded"
  health_status.message = "Status phase is 'FailedValidation'"
elseif enabled == true then
  health_status.status = "Healthy"
  health_status.message = "Status phase is 'Enabled'"
else
  health_status.status = "Progressing"
  health_status.message = "Status phase is not 'FailedValidation' or 'Enabled'"
end

return health_status
