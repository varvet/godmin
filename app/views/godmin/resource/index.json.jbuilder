json.array! resources.limit(nil).offset(nil) do |resource|
  json.extract! resource, *resource_service.attrs_for_export
end
