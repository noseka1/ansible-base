health_status = {}
if obj.status ~= nil then
  if obj.status.stage ~= nil and obj.status.stage == "complete" then
    if obj.status.stageStatus ~= nil and obj.status.stageStatus == "success" then
      health_status.status = "Healthy"
      return health_status
    end
  end
end
health_status.status = "Progressing"
health_status.message = "Reconciliation in progress"
return health_status
