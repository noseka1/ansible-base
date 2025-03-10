health_status = {}
if obj.status ~= nil then
  csvInstalled = false
  if obj.status.installedCSV ~= nil then
     csvInstalled = #obj.status.installedCSV > 0
  end
  if obj.status.conditions ~= nil then
    numDegraded = 0
    numPending = 0
    msg = ""
    for i, condition in pairs(obj.status.conditions) do
      msg = msg .. i .. ": " .. condition.type .. " | " .. condition.status .. "\n"
      if condition.type == "InstallPlanPending" and condition.status == "True" then
        numPending = numPending + 1
      elseif (condition.type == "InstallPlanMissing" and condition.reason ~= "ReferencedInstallPlanNotFound") then
        numDegraded = numDegraded + 1
      elseif (condition.type == "CatalogSourcesUnhealthy" or condition.type == "InstallPlanFailed" or condition.type == "ResolutionFailed") and condition.status == "True" then
        numDegraded = numDegraded + 1
      end
    end
    if numDegraded == 0 and csvInstalled then
      health_status.status = "Healthy"
      health_status.message = msg
      return health_status
    elseif numPending > 0 and numDegraded == 0 then
      health_status.status = "Progressing"
      health_status.message = "An install plan for a subscription is pending installation"
      return health_status
    elseif numDegraded > 0 then
      health_status.status = "Degraded"
      health_status.message = msg
      return health_status
    end
  end
end
health_status.status = "Progressing"
health_status.message = "Installation is progressing"
return health_status
