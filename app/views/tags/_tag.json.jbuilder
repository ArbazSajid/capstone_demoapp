json.extract! tag, :id, :value, :creator_id, :created_at, :updated_at
json.user_roles tag.user_roles     unless tag.user_roles.empty?
