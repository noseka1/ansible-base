health_status = {}
if obj.status ~= nil then
  if obj.status.ready ~= nil and obj.status.ready > 0 then
    if obj.status.running ~= nil and obj.status.running > 0 then
      health_status.status = "Healthy"
      return health_status
    end
  end
end
health_status.status = "Progressing"
health_status.message = "Reconciliation in progress"
return health_status
