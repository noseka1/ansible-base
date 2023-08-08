health_status = {}

phaseDeploying = false
phaseRunning = false
phaseError = false

if obj.status ~= nil then
  if obj.status.phase ~= nil then
    if obj.status.phase == "Running" then
      phaseRunning = true
    elseif obj.status.phase == "Deploying" then
      phaseDeploying = true
    elseif obj.status.phase == "Error" then
      phaseError = true
    end
  end
end

if phaseRunning == true then
  health_status.status = "Healthy"
  health_status.message = "Status phase is 'Running'"
elseif phaseDeploying == true then
  health_status.status = "Progressing"
  health_status.message = "Status phase is 'Deploying'"
elseif phaseError == true then
  health_status.status = "Degraded"
  health_status.message = "Status phase is 'Error'"
else
  health_status.status = "Progressing"
end

return health_status
