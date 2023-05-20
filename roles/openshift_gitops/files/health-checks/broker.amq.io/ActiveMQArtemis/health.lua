health_status = {}

deploymentSize = 0

if obj.spec ~= nil then
  if obj.spec.deploymentPlan ~= nil then
    if obj.spec.deploymentPlan.size ~= nil then
      deploymentSize = obj.spec.deploymentPlan.size
    end
  end
end

if deploymentSize == 0 then
  health_status.status = "Healthy"
  health_status.message = "Deployment size is 0"
  return health_status
end

readyCount = 0

if obj.status ~= nil then
  if obj.status.podStatus ~= nil then
    if obj.status.podStatus.ready ~= nil then
      for i, pod in pairs(obj.status.podStatus.ready) do
        readyCount = readyCount + 1
      end
    end
  end
end

if deploymentSize == readyCount then
  health_status.status = "Healthy"
  health_status.message = "All " .. readyCount .. " pods are ready"
else
  health_status.status = "Progressing"
  health_status.message = readyCount .. " out of " .. deploymentSize .. " pods are ready"
end


return health_status
