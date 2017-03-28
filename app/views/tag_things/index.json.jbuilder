json.array!(@tag_things) do |tt|
  json.extract! tt, :id, :thing_id, :tag_id, :creator_id, :created_at, :updated_at
  json.thing_name tt.thing_name        if tt.respond_to?(:thing_name)
  json.tag_value tt.tag_value  if tt.respond_to?(:tag_value)
end
