health_status = {}
if obj.status ~= nil then
  if obj.status.ready ~= nil then
    if obj.status.ready then
      health_status.status = "Healthy"
      return health_status
    end
  end
end
health_status.status = "Progressing"
health_status.message = "Reconciliation in progress"
return health_status
